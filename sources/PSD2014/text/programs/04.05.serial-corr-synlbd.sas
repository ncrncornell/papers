/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for synbds cells     */
/* $Id: 04.05.serial-corr-synlbd.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.05.serial-corr-synlbd.sas $ */

%let level=agesz;
%let type=e;

options mprint ;


%include "config.sas";
%format_size;
%format_age4;
*%let inputfile=synbds_&level._2;
%let inputfile=synbds_&level;

proc contents data=OUTPUTS.&inputfile.;
run;

data bds_&type._&level._syn1/view=bds_&type._&level._syn1;
	set OUTPUTS.&inputfile
		(rename=(yr=year2 age4=age4num size=sizenum));
	length age4 $ 16 size $ 13;
	age4=put(age4num,age4x.);
	size=put(sizenum,size.);
	if year2>1976;
run;
/* isize x state */

%run_regression(input=syn1,inlib=WORK,output=r,outsuffix=1,level=agesz,levelvar=age4 size,type=e);

proc datasets library=INTERWRK;
quit;

