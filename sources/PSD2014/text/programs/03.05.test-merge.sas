/* $Id: 03.05.test-merge.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/03.05.test-merge.sas $ */
%include "config.sas";

%let analysisvars=emp estabs estabs_entry estabs_entry_alt job_creation job_creation_births job_destruction;
%let byvars=year2 size age4;
%format_size;
%format_age4;

proc contents data=OUTPUTS.synbds_agesz;
run;

data out_synbds/view=out_synbds;
	set OUTPUTS.synbds_agesz
		(rename=(yr=year2 age4=age4num size=sizenum));
	length age4 $ 16 size $ 13;
	age4=put(age4num,age4x.);
	size=put(sizenum,size.);
	if year2>1976;
run;

proc sort data=INTERNL.bds_e_agesz_release out=release(where=(year2<2001));
by &byvars.;
run;

proc sort data=out_synbds out=synbds;
by &byvars.;
run;

data merged;
	merge
		release(in=_a)
		synbds(in=_b);
	by &byvars.;
	_merge=_a+2*_b;
run;

proc freq data=merged;
table _merge year2*_merge age4*_merge size*_merge;
run;

proc print data=merged(where=(_merge=2));
	run;


