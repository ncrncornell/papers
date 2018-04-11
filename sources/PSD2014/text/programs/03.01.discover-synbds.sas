/* $Id: 03.01.discover-synbds.sas 1720 2015-09-25 14:29:12Z lv39 $ */

%include "config.sas";

proc means data=INTERNL.jcrempsynthagesz_test;
run;

proc freq data=INTERNL.jcrempsynthagesz_test;
table year2 age4 size;
run;

endsas;
proc means data=INTERNL.jcrempagesz_test;
run;
