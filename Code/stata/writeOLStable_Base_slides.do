
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tOLS_prelim_time_slides.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\scriptsize " _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{3}d{3}d{3}d{3}d{3}gd{3}@{}}" _n "\toprule" _n;
file write `hh' "  Model & \multicolumn{1}{c}{Time} & \multicolumn{1}{c}{Wealth} & \multicolumn{1}{c}{CEA} & \multicolumn{1}{c}{Un Risk}& \multicolumn{1}{c}{All 3} & \multicolumn{1}{c}{\remph{Baseline}} & \multicolumn{1}{c}{Interact} " $eolString _n "\midrule " _n;

file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(m5b0)/m5se0));
do MakeTestStringJ;
file write `hh' %4.2f (m5b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m1b0)/m1se0));
do MakeTestStringJ;
file write `hh' %4.2f (m1b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m2b0)/m2se0));
do MakeTestStringJ;
file write `hh' %4.2f (m2b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m3b0)/m3se0));
do MakeTestStringJ;
file write `hh' %4.2f (m3b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m6b0)/m6se0));
do MakeTestStringJ;
file write `hh' %4.2f (m6b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4b0)/m4se0));
do MakeTestStringJ;
file write `hh' %4.2f (m4b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7b0)/m7se0));
do MakeTestStringJ;
file write `hh' %4.2f (m7b0) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (m5se0) ")  &  (" %4.2f (m1se0) ")  &  (" %4.2f (m2se0) ")  &  (" %4.2f (m3se0) ")  &  (" %4.2f (m6se0) ")  &  (" %4.2f (m4se0) ")  & ("%4.2f (m7se0) ")" $eolString _n;


file write `hh' "\$\gamma_m$   & &";
sca ptest = 2*(1-normal(abs(m1bm)/m1sem));
do MakeTestStringJ;
file write `hh' %4.2f (m1bm) (teststr) "  & & & ";
sca ptest = 2*(1-normal(abs(m6bm)/m6sem));
do MakeTestStringJ;
file write `hh' %4.2f (m6bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bm)/m4sem));
do MakeTestStringJ;
file write `hh' %4.2f (m4bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bm)/m7sem));
do MakeTestStringJ;
file write `hh' %4.2f (m7bm) (teststr) $eolString _n;

file write `hh' " & & (" %4.2f (m1sem) ")  &  & &   (" %4.2f (m6sem) ")  &  (" %4.2f (m4sem) ")  &  (" %4.2f (m7sem)  ") "  $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & & & ";
sca ptest = 2*(1-normal(abs(m2bCEA)/m2seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m2bCEA) (teststr) "  & &";
sca ptest = 2*(1-normal(abs(m6bCEA)/m6seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m6bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bCEA)/m4seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m4bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bCEA)/m7seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m7bCEA) (teststr)  $eolString _n;

file write `hh' " & & & (" %4.2f (m2seCEA) ")  &   &   (" %4.2f (m6seCEA) ")  &  (" %4.2f (m4seCEA) ")  &  (" %4.2f (m7seCEA) ")"  $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & & & & ";

sca ptest = 2*(1-normal(abs(m3bunpred)/m3seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m3bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m6bunpred)/m6seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m6bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m4bunpred)/m4seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m4bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m7bunpred)/m7seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m7bunpred) (teststr) $eolString _n;

file write `hh' " &   &   &  & (" %4.2f (m3seunpred) ")  &   (" %4.2f (m6seunpred) ")  &   (" %4.2f (m4seunpred) ")  &   (" %4.2f (m7seunpred) " ) "  $eolString _n;

file write `hh' " \$\gamma_{t}$   & ";
sca ptest = 2*(1-normal(abs(m5btime)/m5setime));
do MakeTestStringJ;
file write `hh' %4.2f (m5btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m1btime)/m1setime));
do MakeTestStringJ;
file write `hh' %4.2f (m1btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m2btime)/m2setime));
do MakeTestStringJ;
file write `hh' %4.2f (m2btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m3btime)/m3setime));
do MakeTestStringJ;
file write `hh' %4.2f (m3btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m6btime)/m6setime));
do MakeTestStringJ;
file write `hh' %4.2f (m6btime) (teststr) "  & & "; 
sca ptest = 2*(1-normal(abs(m7btime)/m7setime));
do MakeTestStringJ;
file write `hh' %4.2f (m7btime) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (m5setime) ")& (" %4.2f (m1setime) ") & (" %4.2f (m2setime) ") & (" %4.2f (m3setime) ") & ( " %4.2f (m6setime) 
" ) & & (" %4.2f (m7setime) ")"  $eolString _n;

file write `hh' " \$\gamma_{uC}$   &  & & & & & & ";
sca ptest = 2*(1-normal(abs(m7bunCEA)/m7seunCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m7bunCEA) (teststr) $eolString _n;

file write `hh' " &   &  &  & & & & (" %4.2f (m7seunCEA) ")   "  $eolString _n;

file write `hh' "\midrule " _n;

file write `hh' " \$\bar{R}^2$  & ";
file write `hh' %4.2f (m5r1) "  & " %4.2f (m1r1) "  & " %4.2f (m2r1) "  & " %4.2f (m3r1) "  & " %4.2f (m6r1) "  & " %4.2f (m4r1) "  & " %4.2f (m7r1)  $eolString _n;

file write `hh' " F stat p val  & ";
file write `hh' %6.2f (m5fpval) "  & " %6.2f (m1fpval) "  & " %6.2f (m2fpval) "  & " %6.2f (m3fpval) "  & " %6.2f (m6fpval) "  & " %6.2f (m4fpval)  "  & " %6.2f (m7fpval)  $eolString _n;

file write `hh' "DW stat  & ";
file write `hh' %4.2f (m5dw) "  & " %4.2f (m1dw) "  & " %4.2f (m2dw) "  & " %4.2f (m3dw) " & "  %4.2f (m6dw)  " & "  %4.2f (m4dw)  " & "  %4.2f (m7dw)  $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file close `hh';

