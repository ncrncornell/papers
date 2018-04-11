/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 04.02.serial-corr-released.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.02.serial-corr-released.sas $ */

%let level=iszst;
%let type=e;

options mprint;


%include "config.sas";

%let finputfile=bds_&type._&level._release;
%let rinputfile=TBD;

proc contents data=BDS.&finputfile.;
run;


/* isize x state */

*run_regression(input=release,output=r,outsuffix=r,level=iszst,levelvar=isize state,type=e);
*run_regression(input=release,output=r,outsuffix=r,level=szsic,levelvar=size sic1,type=e);
%run_regression(input=release,output=r,outsuffix=r,level=agesz,levelvar=age4 size,type=e);

proc datasets library=INTERWRK;
quit;

