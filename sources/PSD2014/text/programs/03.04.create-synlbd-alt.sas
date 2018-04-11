/* $Id: 03.04.create-synlbd-alt.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/03.04.create-synlbd-alt.sas $ */

* %include config.sas;

libname bds "/projects4/arts422/SynLBD/bds_synth";
libname SynLBD "/projects4/arts422/SynLBD/data/synlbd/2.0.1";
libname OUTPUTS "/projects4/arts422/PSD2014/SynBDS/data";
    %include " /projects4/arts422/PSD2014/SynBDS/programs/format_age4.sas";
    %include "/projects4/arts422/PSD2014/SynBDS/programs/format_size.sas";

    %format_age4;    
    %format_size;

%macro main(start=1976,end=2000,analysisvars=emp estabs estabs_entry lag1_alive/* estabs_entry_alt */ job_creation job_creation_births job_destruction job_destruction_deaths denom denom_estabs entry exit ,byvars=yr size age4);

data long  /view=long ;
	set 
	%do y=&start. %to &end;
		SynLBD.synlbd&y.c
	%end;
	;
	by lbdnum;

	retain lag1_emp lag1_alive emp1;
	if first.lbdnum then do;
		lag1_emp=.;
		lag1_alive=0;
		emp1=emp;
	end;
        
	/* compute stats */
	/* emp estabs estabs_entry job_creation job_creation_births */
	keep lbdnum lag1_emp lag1_alive sic emp1 firstyear lastyear &byvars. &analysisvars. ;

*	if emp>=0 then do;

   if emp>30000  then delete;
   if substr(sic,1,4) in ('8211','8222','8221','8069','8063','8062','4111') and (lag1_emp=0 and emp>0 and emp>1000) then emp=lag1_emp;

* we have an obvious problem with age = -1 in the synbds calculations that we need to fix. There was a bug in my code below. This is now fixed;
* also missing 26+ and left censored. Note there can.t be a 26+ when we only have data up to 2000 so this problem goes away once we restrict the bds data to years up to 2000;
* also this data creates data for 1977-2000 and BDS has data for 1976-2011: I fixed this in the 03.05.test-merge.sas program and 03.06.algorithm1.sas;


		estabs_entry=(yr=firstyear);
		estabs_entry_alt=(lag1_alive=0 and emp>0) ;
		if emp>0 then estabs=1; else estabs=0;				
		denom=sum(lag1_emp,emp)/2;
		denom_estabs=sum(lag1_alive,estabs)/2;
		if denom>0;
		if emp1=0 then firstyear=firstyear+1;		
		age4=yr-firstyear;
		if firstyear<=1976 then age4=99;		
		if denom > 1 then size=round(denom);
		else size=ceil(denom);
		job_creation=round(max(0,sum(emp,-lag1_emp)));
		if emp>0 and lag1_emp=0 or lag1_emp=. then job_creation_births=job_creation; else job_creation_births=0;		
		entry=(yr=firstyear);
		if emp>0 and lag1_emp=0 or lag1_emp=. then entry=1; 	

 * if we had an exit data point for each establishment (last year with positive activity + 1) then we could compute exit measures as follows;
 * exit variables;
		estabs_exit=(yr=lastyear);
		job_destruction=round(min(0,sum(emp,-lag1_emp)));
		if (emp=0 or emp=.) and lag1_emp>0 then job_destruction_deaths=job_destruction;else job_destruction_births=0;
		exit=(yr=lastyear);		
		if (emp=0 or emp=.) and lag1_emp>0 and yr<&end then exit=1; 
 * ignore other filters for now;
		output;
*	end;
	lag1_emp=emp;
	lag1_alive=estabs;
	emp1=emp1;	
run;


    
proc summary data=long nway;
class &byvars.;
 format age4 age4x. size size.;
var &analysisvars.;
output out=synbds sum=;
run;

data synbds;
  set synbds;
 
  if denom ^=0 then jcr=round(((job_creation/denom)*100),0.1); else jcr=0;
  if job_creation>0 then jcrb=round(((job_creation_births/(job_creation))*100),0.1);else jcrb=0;
  if denom_estabs ^=0 then entry_rate=entry/estabs;  
  if denom ^=0 then jdr=round(((job_destruction/denom)*100),0.1); else jdr=0;
  if job_destruction>0 then jdrd=round(((job_destruction_deaths/(job_destruction))*100),0.1);else jdrd=0;
  if denom_estabs ^=0 then exit_rate=exit/estabs;  
  net=jcr-jdr;
  reall=jcr+jdr-abs(net);
   run;

    proc freq data=synbds(where=(yr>1976));
	tables age4 size yr /missing;
    run;

    proc freq data=bds.bds_e_agesz_release(where=(year2<2001));
	tables age4 size year2/missing;
    run;
    proc freq data=bds.jcrempagesz_test(where=(year2<2001));
	tables age4 size year2/missing;
    run;
    
proc print data=synbds;
run;



%mend;

%main();

data OUTPUTS.synbds_agesz;
	set synbds;
run;
