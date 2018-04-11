%macro format_size;
	proc format;
	 value size 
                                1-4="a) 1 to 4"
                                5-9="b) 5 to 9"
                                 10-19="c) 10 to 19"
                                 20-49="d) 20 to 49"
                                 50-99="e) 50 to 99"
                                 100-249="f) 100 to 249"
                                 250-499="g) 250 to 499"
                                 500-999="h) 500 to 999"
                                 1000-high="i) 1000+"
				.="m) ALL"
	;
run;
%mend;
