/* $Id: 03.02.discover-internal.sas 1720 2015-09-25 14:29:12Z lv39 $ */

%include "config.sas";

proc means data=INTERNL.jcrempagesz_test(where=(year2 in (1999,2000)));
run;

proc freq data=INTERNL.jcrempagesz_test(where=(year2 in (1999,2000)));
table year2 age4 size;
run;

proc print data=INTERNL.jcrempagesz_test(where=(age4="a) 0" and size="a) 1 to 4"));
var year2 bpos;
run;

