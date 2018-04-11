/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: run_regression.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/run_regression.sas $ */



/* This runs the regressions, and outputs one file per variable and file */

%macro run_regression(input=release,inlib=INPUTS,output=results,outsuffix=,level=iszst,levelvar=isize state,type=e,yearvar=year2,startyear=1977,endyear=1999);

%let inputfile=bds_&type._&level._&input.;
%let analysisvars=emp estabs estabs_entry job_creation job_creation_births; 
*let analysisvars=emp;
%let byvars  =&levelvar. ;
%let keepvars=&byvars. &yearvar. ;


proc sort data=&inlib..&inputfile.
    ( keep=&analysisvars. &keepvars.) 
     nodupkey
     out=tmpall;
     by &keepvars.;
run;

/* run regressions, one at a time */

%let i=1;
%do %while (%scan(&analysisvars.,&i.) ne ) ;
  %let var=%trim(%left(%scan(&analysisvars.,&i.)));
  %put PROCESSING VARIABLE &var.;

  %let outfile=&output._&type._&level._&var._&outsuffix.;

/* add time variable */
  data tmp;
    set tmpall (keep=&var. &keepvars.);
    time=&yearvar.;
    if &var. ne .;
    if time ge &startyear. and time le &endyear.;
  run;

/* get number of obs by by-group */
  proc univariate data=tmp noprint;
	by &byvars.;
	var &var.;
	output out=tmp_count n=count mean=mean;
  run;

  proc print data=tmp_count(where=(count<5) obs=10);
      title2 "Not enough cells VAR=&var.";
  run;

  proc print data=tmp_count(where=(mean<10) obs=10);
      title2 "Too small cells VAR=&var.";
  run;

  data tmp;
      merge tmp(in=in_a) tmp_count(in=in_b keep=&byvars. count mean);
      by &byvars.;
      if in_a and in_b;
      run;
      title2 "AUTOREG VAR=&var.";
*ods trace on;
ods output ARParameterEstimates=arparms;
  proc autoreg data=tmp(where=(mean>10 and count>5)) outest=tmp_est ;* noprint;
   by &byvars.;
   model &var. = time / nlag=2 method=yw;
  run;
*ods trace off;


  data INTERWRK.&outfile.;
    set tmp_est;*(where=(_mse_>0));
  run;

  data INTERWRK.&outfile.2;
    set arparms;*(where=(_mse_>0));
  run;

  %let i=%eval(&i.+1);
%end;
%mend;

