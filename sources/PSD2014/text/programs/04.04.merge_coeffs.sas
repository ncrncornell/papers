/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 04.04.merge_coeffs.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.04.merge_coeffs.sas $ */

%let level=agesz;
%let type=e;

options mprint;


%include "config.sas";

%mergevars(final=no,level=agesz,levelvars=age4 size,type=e,vars=emp);
proc print data=merged_stats;
run;
proc print data=stats_transposed ;
run;

proc print data=table_sercorr;
run;

%mergevars(final=yes,level=agesz,levelvars=age4 size,type=e,vars=emp estabs estabs_entry job_creation job_creation_births,
	outfile=OUTPUTS.r_e_agesz_all_pub,
	precision=0.001);

proc export data=OUTPUTS.r_e_agesz_all_pub(where=(_NAME_ not in ('p_95','p_05')))
	outfile="%sysfunc(pathname(OUTPUTS))/r_e_agesz_all_pub.csv"
	dbms=csv
	replace;
run;
