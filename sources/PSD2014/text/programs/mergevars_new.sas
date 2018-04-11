/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: mergevars_new.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/mergevars_new.sas $ */
/* confidential data goes into file1 */


%macro mergevars_new(final=no,level=agesz,inprefix=r,insuffix1=i2,insuffix2=r2,levelvars=age4 size,type=e,vars=emp,outfile=,precision=0.00001);
%put INFO: Confidential data in file1;
%if ( &outfile.= ) %then %let final=no;
%let keeplist=&levelvars. Lag Estimate StdErr;

%do i = 1 %to %sysfunc(countw(&vars.));
	%let var=%scan(&vars.,&i.);
	%put PROCESSING VAR=&var.;
	%let statfile1=INTERWRK.&inprefix._&type._&level._&var._&insuffix1.;
	%let statfile2=INTERWRK.&inprefix._&type._&level._&var._&insuffix2.;

%put ASSUMPTION: Confidential data in file1;
%put      FILE1: &statfile1.;
%put      FILE2: &statfile2.;
	/* merge */
	data merged;
		merge
			&statfile1.(in=in_1 keep=&keeplist Lag where=(Lag=1) rename=(Estimate=a_1_&insuffix1. StdErr=stderr_&insuffix1.))
			&statfile2.(in=in_2 keep=&keeplist Lag where=(Lag=1) rename=(Estimate=a_1_&insuffix2. StdErr=stderr_&insuffix2.))
		;
		by &levelvars.;	
		length Variable $ 32;
		Variable="&var.";
		if in_1 ;
		missing=(in_1 and not in_2);
		delta_r=a_1_&insuffix2.-a_1_&insuffix1.;
		pct_delta_r=delta_r/a_1_&insuffix2.;
	        if a_1_&insuffix1. ne . then 
			significant_&insuffix1. = ( abs(a_1_&insuffix1. / stderr_&insuffix1.) > 1.96 );
	        if a_1_&insuffix2. ne . then do;
			significant_&insuffix2. = ( abs(a_1_&insuffix2. / stderr_&insuffix2.) > 1.96 );
			coverage = ( abs(a_1_&insuffix1. - a_1_&insuffix2. ) < a_1_&insuffix2. + 1.96*stderr_&insuffix2. );
			/* compute Jk from tas2006 */
			L_orig = a_1_&insuffix1.-1.96*stderr_&insuffix1.;
			U_orig = a_1_&insuffix1.+1.96*stderr_&insuffix1.;
			L_alt  = a_1_&insuffix2.-1.96*stderr_&insuffix2.;
			U_alt  = a_1_&insuffix2.+1.96*stderr_&insuffix2.;
			L_over = max(L_orig,L_alt);
			U_over = min(U_orig,U_alt);
			if U_over > L_over then do;
				Jk = 0.5 * ( ( U_over - L_over )/ (U_orig-L_orig) 
						    + ( U_over - L_over )/ (U_alt-L_alt) ); 
			end;
		end;
		label delta_r="r - r star (&var.)";
		label pct_delta_r=" (r - r star)/r (&var.)";
		label missing="Result present file1=&insuffix1, missing file2=&insuffix2.";
		label significant_&insuffix1.="( a_1_&insuffix1. / stderr_&insuffix1. > 1.96 )";
		label significant_&insuffix2.="( a_1_&insuffix2. / stderr_&insuffix2. > 1.96 )";
		label coverage="a_1_&insuffix1. within 1.96 stderr_&insuffix2. of a_1_&insuffix2.";
		label Jk = "Interval overlap measure";

	run;
	/*============== distributions =============*/
	/* get distribution of the differnce */
	proc univariate data=merged;
	var pct_delta_r;
	output out=merged_stats pctlpre=p_ pctlpts=5,10,25,50,75,90,95;
	run;

	/* transpose to useful */
	proc transpose data=merged_stats
		out=stats_transposed(rename=(col1=&var.));
	run;

	proc sort data=stats_transposed ;
	by descending _name_;
	run;

	%if ( &i. = 1 ) %then %do;
	data table_sercorr;
		set stats_transposed(keep=_name_ &var.);
	run;
	%end;
	%else %do;
	data table_sercorr;
		merge table_sercorr
			stats_transposed(keep=_name_ &var.)
		;
		by descending _name_;
	run;
	%end;
	/*======================================================*/


	/*================== coverage and significance ==========================*/
	%if ( &i = 1 ) %then %do;
	data coverage;
		set merged;
	run;
	%end;
	%else %do;
	proc append data=merged base=coverage ;
	run;
	%end;

	/*======================================================*/

%end; /*end i loop */

	data table_sercorr;
	 set table_sercorr;
	 if _name_ = 'p_1' then _name_='p_01';
	 if _name_ = 'p_5' then _name_='p_05';
	run;

	/*================== coverage and significance ==========================*/
	proc summary data=coverage;
	class  &levelvars. Variable;
	var coverage Jk significant_&insuffix1. significant_&insuffix2. missing;
	output out=coverage_stats mean=;
	run;

%if ( &final. = yes ) %then %do;
	proc sort data=table_sercorr out=&outfile;
	by descending _name_;
	run;

	data &outfile.;
		set &outfile.;
	 array est &vars.;
	 do over est;
		est=round(est,&precision.);
	 end;
	run;

	data &outfile.2;
		set coverage_stats;
	 array est coverage Jk significant_&insuffix1. significant_&insuffix2. missing;
	 do over est;
		est=round(est,&precision.);
	 end;
	run;
	

%end;

%mend;
