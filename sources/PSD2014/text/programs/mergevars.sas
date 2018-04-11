/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: mergevars.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/mergevars.sas $ */



%macro mergevars(final=no,level=agesz,levelvars=age4 size,type=e,vars=emp,outfile=,precision=0.00001);

%if ( &outfile.= ) %then %let final=no;
%let keeplist=&levelvars. _a_1 _sse_;

%do i = 1 %to %sysfunc(countw(&vars.));
	%let var=%scan(&vars.,&i.);
	%put PROCESSING VAR=&var.;
	%let statfile1=INTERWRK.r_&type._&level._&var._i;
	%let statfile2=INTERWRK.r_&type._&level._&var._r;

	/* merge */
	data merged;
		merge
			&statfile1.(in=in_int keep=&keeplist rename=(_a_1=int_a_1 _sse_=int_sse_))
			&statfile2.(in=in_pub keep=&keeplist rename=(_a_1=pub_a_1 _sse_=pub_sse_))
		;
		by &levelvars.;	
		if in_int and in_pub;
		delta_r=pub_a_1-int_a_1;
		pct_delta_r=delta_r/pub_a_1;
		label delta_r="r - r star (&var.)";
		label pct_delta_r=" (r - r star)/r (&var.)";
	run;
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
%end; /*end i loop */

	data table_sercorr;
	 set table_sercorr;
	 if _name_ = 'p_1' then _name_='p_01';
	 if _name_ = 'p_5' then _name_='p_05';
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

%end;

%mend;
