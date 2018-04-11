/* $Id: 03.04b.create-synlbd-alt-fix.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/03.04b.create-synlbd-alt-fix.sas $ */
%include "config.sas";

%let analysisvars=emp estabs estabs_entry estabs_entry_alt job_creation job_creation_births job_destruction;
%let byvars=yr size age4;
%format_age4;
%format_size;

data round/view=round;
	set OUTPUTS.synbds_agesz_test;
	if size>1 then 	size=round(size);
	else size=ceil(size);
run;

proc summary data=round nway;
class &byvars.;
format age4 age4x. size size.;
var &analysisvars.;
output out=OUTPUTS.synbds_agesz_2 sum=/noinherit;
run;

proc print data=OUTPUTS.synbds_agesz_2;
run;

proc contents data=OUTPUTS.synbds_agesz_2;
run;
