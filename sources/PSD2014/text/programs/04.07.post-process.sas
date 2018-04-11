/* Time-stamp: <05/07/06 22:53:04 vilhu001> */
/* this computes serial correlation for */
/*       margin   cells                 */
/* for published cells     */
/* $Id: 04.07.post-process.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/04.07.post-process.sas $ */

%macro convert(infile=,outfile=,vars=coverage significanti2 significantr2 missing);

proc import out=import
	datafile="./&infile."
	dbms=csv
	replace;
run;

data export;
	set import;
	%do i = 1 %to %sysfunc(countw(&vars.));
		%let var=%scan(&vars.,&i.);
		&var.=&var.*100;
	%end;
	run;
	
proc export data=export
	outfile="./&outfile."
	dbms=csv
	replace;
run;
%mend;

%convert(infile=r_e_agesz_all_pub2.csv,outfile=r_e_agesz_all_pub2_post.csv,vars=coverage significanti2 significantr2 Jk missing);
%convert(infile=r_e_agesz_all_syn2.csv,outfile=r_e_agesz_all_syn2_post.csv,vars=coverage significanti2 significant22 Jk missing);

/* Now let's combine them */
proc import out=import
	datafile="./r_e_agesz_all_pub2_post.csv"
	dbms=csv
	replace;
run;

proc import out=import2
	datafile="./r_e_agesz_all_syn2_post.csv"
	dbms=csv;
run;

data merged;
	merge import(in=_a)
		  import2(in=_b keep=Variable age4 size significant22 missing coverage Jk
		  	      rename=(Jk=Jks coverage=coverages missing=missings)
		  	      );
	by age4 size Variable;
	_merge=_a+2*_b;
	drop _merge;
	run;
	
proc export data=merged
	outfile="./r_e_agesz_all_combined.csv"
	dbms=csv
	replace;
run;




