/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for synbds cells     */
/* $Id: 04.03.serial-corr-algorithm1.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.03.serial-corr-algorithm1.sas $ */

%let level=agesz;
%let type=e;

options mprint ;


%include "config.sas";
%let inputfile=jcrempsynth&level._test2;;

proc contents data=OUTPUTS.&inputfile.;
run;

data bds_&type._&level._syn2/view=bds_&type._&level._syn2;
	set OUTPUTS.&inputfile
	;
run;
/* isize x state */

%run_regression(input=syn2,inlib=WORK,output=r,outsuffix=2,level=agesz,levelvar=age4 size,type=e);

proc datasets library=INTERWRK;
quit;

