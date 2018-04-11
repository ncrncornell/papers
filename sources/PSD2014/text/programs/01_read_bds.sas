/* $Id: 01_read_bds.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/01_read_bds.sas $ */
/* Read in the BDS, one after the other, and identify the flags */

%include "config.sas"/source2;

filename DIRLIST pipe "cd &bdsraw.; ls -1 *sas7bdat ";               
libname INPUTS "&bdsraw.";
                                           
/* create a mapping of BDS tabulations */

data bdsmap;
	length type $ 30 typename tmp $ 100;
	input type tmp;
	typename=tranwrd(tmp,"_"," ");
	drop tmp;
	datalines;
age Age
ageisz Age-Initial_Size
ageiszsic Age-Initial_Size-SIC
ageiszmetro Age-Initial_Size-Metropolitan_Area
agemetrononmetro Age-Metropolitan_and_Nonmetro_Area
agemsa Age-MSA
agesic Age-SIC
agest Age-State
agesz Age-Size
ageszmetrononmetro Age-Size-Metropolitan_and_Nonmetro_Area
all All
isz Initial_Size
iszmetrononmetro Initial_Size-Metropolitan_and_Nonmetro_Area
iszsic Initial_Size-SIC
iszst Initial_Size-State
metrononmetro Metropolitan_and_Nonmetro_Area
sic SIC
st State
sz Size
szmetrononmetro Size-Metropolitan_and_Nonmetro_Area
szmsa Size-MSA
szsic Size-SIC
szst Size-State
;;
run;

proc sort data=bdsmap;
by type;
run;

/* now read in the data files */
                  
data dirlist ;                                               
infile dirlist lrecl=200 truncover;                          
input line $200.;                                            
length file_name $ 100;                                      
file_name=line;                    
keep file_name;                                                                               
run;
                      
proc print data=dirlist;
run;
                         
data _null_;                                                 
set dirlist end=end;                                         
count+1;                                                     
call symput('read'||left(count),left(trim(scan(file_name,1,'.'))));      
if end then call symput('max',count);                        
run;                                                         
                                                             
options mprint symbolgen;                                    
%macro readin(keepvars=emp estabs estabs_entry job_creation job_creation_births);                                               
%do i=1 %to &max;                                            
                                                             
%let type=%scan(&&read&i,3,"_");
%let suptype=%scan(&&read&i,4,"_");
%let level=%scan(&&read&i,2,"_");
%if ( "&suptype." = "sic" ) %then %let type=&type.sic;

 data tmp;                                              
	%if ( "&&read&i" = "bds_e_all_release" or "&&read&i" = "bds_f_all_release" or "&&read&i" = "bds_f_metrononmetro_release") %then %do;
	 set INPUTS.&&read&i
         (keep=&keepvars.);
	d_flag=0;
	%end;
	%else %do;
	 set INPUTS.&&read&i
	 (keep=&keepvars. d_flag);
	%end;
 length file_name $ 100 type $ 30 level $ 1;
 file_name="&&read&i.";
 level="&level.";
 type="&type";
 %do j = 1 %to %sysfunc(countw(&keepvars.));
    %let var=%scan(&keepvars.,&j.);
    length d_flag_&var. 3;
    d_flag_&var.=(d_flag=1 and &var.=.);
 %end;
* drop emp;
 run;                                                        

 proc append base=d_flag data=tmp;
run;
                                                             
%end;                                                        
%mend readin;                                                
                                                             
%readin;                  


proc sort data=d_flag;
by type level ;
run;

%macro make_table(suffix=,outsuffix=);
%if ( "&outsuffix." = "" ) %then %let outsuffix=&suffix.;
proc freq data=d_flag;
title "For suffix=&suffix.";
by type level ;
table d_flag&suffix./out=freq;
run;

data freq;
	set freq;
	if d_flag&suffix.=0;
	drop d_flag:;
	percentsup=round(100-percent,.1);
	cells=count/percent*100;
run;

proc print data=freq;
run;

title;

/* attach nice names */
proc sort data=freq;
by type;
run;
data freq;
	merge freq(in=_a) bdsmap(in=_b);
	by type;
	if _a;
	run;

/* now sort for output */

proc sort data=freq;
by percentsup cells;
run;

proc export data=freq(where=(level="f")) outfile="bds_f_suppressions&suffix..csv" dbms=csv replace;
run;
proc export data=freq(where=(level="e")) outfile="bds_e_suppressions&suffix..csv" dbms=csv replace;
run;

proc sort data=freq;
by type level;
run;

data OUTPUTS.bds_d_flag_public&outsuffix.(label="$Id: 01_read_bds.sas 1720 2015-09-25 14:29:12Z lv39 $ %sysfunc(today(),yymmdd10.)");
	set freq;
run;
%mend;

%make_table(suffix=);
%make_table(suffix=_emp);
%make_table(suffix=_job_creation);
%make_table(suffix=_job_creation_births,outsuffix=_jc_births);
%make_table(suffix=_estabs_entry);

