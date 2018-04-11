/* $Id: 01.02.post-process.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/01.02.post-process.sas $ */
/* Create publication tables */

%include "config.sas"/source2;


data pubtable_e;
	merge OUTPUTS.bds_d_flag_public(in=_a)
		  OUTPUTS.bds_d_flag_public_estabs_entry(in=_b keep=type level percentsup rename=(percentsup=estabsentry))
		  OUTPUTS.bds_d_flag_public_jc_births(in=_c keep=type level percentsup rename=(percentsup=jcbirths))
		  ;
	by type level;
	if level="e";
	keep type level typename percentsup cells estabsentry jcbirths;
run;

proc export data=pubtable_e outfile="bds_e_suppressions_multi.csv" dbms=csv replace;
run;

