/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 04.01.serial-corr-internal.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.01.serial-corr-internal.sas $ */

%let level=agesz;
%let type=e;

options mprint;


%include "config.sas";

%let finputfile=jcremp&level._test;
%let rinputfile=TBD;

proc contents data=INTERNL.&finputfile.;
run;


/* isize x state */

*run_regression(input=release,output=results,level=iszst,levelvar=isize state,type=e);
*run_regression(input=release,output=results,level=szsic,levelvar=size sic1,type=e);

data bds_e_agesz_internal/view=bds_e_agesz_internal;
	set INTERNL.jcrempagesz_test(where=(year2<2001));
	emp=round(employment);

	job_destruction_deaths=	round(deaths);
	job_creation_births=round(births);
	job_destruction=round(negtvs);
	job_creation=round(postvs);
	estabs=round(count);
	estabs_entry=round(entry);
	drop entry count postvs negtvs births deaths employment;
run;

%run_regression(input=internal,inlib=WORK,output=r,outsuffix=i,level=agesz,levelvar=age4 size,type=e);

proc datasets library=INTERWRK;
quit;

