/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 04.06.merge_coeffs_new.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.06.merge_coeffs_new.sas $ */

%let level=agesz;
%let type=e;

options mprint;


%include "config.sas";

%mergevars_new(final=no,level=agesz,levelvars=age4 size,type=e,vars=emp job_creation_births);
proc print data=merged_stats;
run;
proc print data=stats_transposed ;
run;

proc print data=table_sercorr;
run;

proc print data=coverage_stats(where=(_TYPE_=1));
run;

/* run for all variables pub vs internal */
%mergevars_new(final=yes,level=agesz,levelvars=age4 size,type=e,vars=emp estabs estabs_entry job_creation job_creation_births,
	outfile=OUTPUTS.r_e_agesz_all_pub,
	precision=0.001);

data export;
	set OUTPUTS.r_e_agesz_all_pub2
	(rename=(significant_i2=significanti2 significant_r2=significantr2 _FREQ_=number) where=(_TYPE_=1))
	;
	drop _TYPE_;
	array chars _CHARACTER_;
	do over chars;
		chars=tranwrd(chars,'_','');
	end;
run;

proc export data=export
	outfile="./r_e_agesz_all_pub2.csv"
	dbms=csv
	replace;
run;

/* do the same with the synbds */
%mergevars_new(final=yes,level=agesz,insuffix2=22,levelvars=age4 size,type=e,vars=emp estabs estabs_entry job_creation job_creation_births,
	outfile=OUTPUTS.r_e_agesz_all_syn,
	precision=0.001);

data export;
	set OUTPUTS.r_e_agesz_all_syn2
	(rename=(significant_i2=significanti2 significant_22=significant22 _FREQ_=number) where=(_TYPE_=1))
	;
	drop _TYPE_;
	array chars _CHARACTER_;
	do over chars;
		chars=tranwrd(chars,'_','');
	end;
run;
proc export data=export
	outfile="./r_e_agesz_all_syn2.csv"
	dbms=csv
	replace;
run;
