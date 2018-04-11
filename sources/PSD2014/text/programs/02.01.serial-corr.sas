/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 02.01.serial-corr.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/02.01.serial-corr.sas $ */

%let level=iszst;
%let type=e;

options mprint;


%include "config.sas";

%let finputfile=bds_&type._&level._release;
%let rinputfile=TBD;

proc contents data=INPUTS.&finputfile.;
run;


/* isize x state */

*run_regression(input=release,output=results,level=iszst,levelvar=isize state,type=e);
*run_regression(input=release,output=results,level=szsic,levelvar=size sic1,type=e);
%run_regression(input=release,output=results,level=agesz,levelvar=age4 size,type=e);

proc datasets library=INTERWRK;
quit;

