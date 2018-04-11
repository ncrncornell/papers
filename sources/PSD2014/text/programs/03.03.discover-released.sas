/* $Id: 03.03.discover-released.sas 1720 2015-09-25 14:29:12Z lv39 $ */

%include "config.sas";

proc means data=INTERNL.bds_e_agesz_release(where=(year2 in (1999,2000)));
run;

proc freq data=INTERNL.bds_e_agesz_release(where=(year2 in (1999,2000)));
table year2 age4 size;
run;

proc print data=INTERNL.bds_e_agesz_release(where=(year2 in (1999,2000) 
   and d_flag=1));
var job_creation estabs_entry estabs_exit job_destruction job_creation_births job_destruction_deaths;
run;

proc print data=INTERNL.bds_e_agesz_release(where=(age4="a) 0" and size="a) 1 to 4"));
var year2 job_creation_births;
run;

