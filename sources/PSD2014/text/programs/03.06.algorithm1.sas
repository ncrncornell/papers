/* $Id: 03.06.algorithm1.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/03.06.algorithm1.sas $ */
%include "config.sas";

%let analysisvars=emp estabs estabs_entry job_creation job_creation_births job_destruction;
%let byvars=year2 size age4;
%format_size;
%format_age4;

proc contents data=OUTPUTS.synbds_agesz;
run;

data out_synbds/view=out_synbds;
	set OUTPUTS.synbds_agesz
		(rename=(yr=year2 age4=age4num size=sizenum) keep=yr age4 size &analysisvars.);
	length age4 $ 16 size $ 13;
	age4=put(age4num,age4x.);
	size=put(sizenum,size.);
	if year2>1976;
	rename
		%rename_vars(vars=&analysisvars.,prefix=syn_)
	;
run;

proc sort data=INTERNL.bds_e_agesz_release out=release(where=(year2<2001));
by &byvars.;
run;

proc sort data=out_synbds out=synbds;
by &byvars.;
run;

%macro main(vars=);
%local i var;
data merged;
	merge
		release(in=_a)
		synbds(in=_b);
	by &byvars.;
	_merge=_a+2*_b;
	if _merge in (1,3);
	%do i = 1 %to %sysfunc(countw(&vars.));
	  %let var=%scan(&vars.,&i.);
	  d_flag_&var=0;
	  if d_flag=1 and &var.<.z then do;
		d_flag_&var=1;
		&var.=syn_&var.;
	  end;
       %end;/* end i loop */
run;
%mend;
%main(vars=&analysisvars.);

proc means data=release;
title2 "Unmodified";
var &analysisvars.;
run;
proc means data=merged;
title2 "Algorithm1";
var &analysisvars.;
run;
proc freq data=merged;
title2 "Algorithm1";
table d_flag:;
run;
/* make the final file */
data OUTPUTS.jcrempsynthagesz_test2;
	set merged;
	drop age4num sizenum ;
run;

/* compare to confidential values */
data internal/view=internal;
	set INTERNL.jcrempagesz_test(where=(year2<2001));
	emp=round(employment);

	job_destruction_deaths=	round(deaths);
	job_creation_births=round(births);
	job_destruction=round(negtvs);
	job_creation=round(postvs);
	estabs=round(count);
	estabs_entry=round(entry);

proc means data=internal;
title2 "original data";
var &analysisvars.;
run;




