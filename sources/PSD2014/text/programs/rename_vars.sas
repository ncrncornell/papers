/* $Id: rename_vars.sas 1720 2015-09-25 14:29:12Z lv39 $ */
/* $URL: https://forge.cornell.edu/svn/repos/ncrn-cornell/branches/papers/PSD2014/text/programs/rename_vars.sas $ */
/* macro to batch rename vars, or generate code 
    var=(prefix)var(suffix)
  if invert=yes then 
    (prefix)var(suffix)=var
*/
%macro rename_vars(prefix=,vars=,suffix=,invert=no);
%local var i;
%do i = 1 %to %sysfunc(countw(&vars.));
  %let var=%scan(&vars.,&i.);
  %if ( "&invert." = "no" ) %then %do;
    &var.=&prefix.&var.&suffix.
  %end;
  %else %do;
    &prefix.&var.&suffix.=&var.
  %end;
    
%end;
   

%mend;
