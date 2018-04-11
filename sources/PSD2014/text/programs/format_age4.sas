%macro format_age4;
	proc format;
	 value age4x 
               0="a) 0"
               1="b) 1"
                               2="c) 2"
                               3="d) 3"
                               4="e) 4"
                               5="f) 5"
                               6-10="g) 6 to 10"
                               11-15="h) 11 to 15"
                               16-20="i) 16 to 20"
                               21-25="j) 21 to 25"
                               26-98="k) 26+"
                               99="l) Left Censored"
				.="m) ALL"
;
run;
%mend;

