
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tOLS_prelim_time_model.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Preliminary regressions with time trend---Model generated PSR \$s_t$} \label{tOLSprelim_model} " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}d{6}d{6}d{6}d{6}@{}}" _n;
file write `hh' "\multicolumn{8}{c}{ \$s_t=\gamma_0+\gamma_m m_t+\gamma_{\CEA}\CEA_t+ \gamma_{Eu}\Ex_t u_{t+4}+\gamma_t t+\gamma_{uC} (\Ex_t u_{t+4}\times\CEA_t)+\varepsilon_t$ } " $eolString  _n "\toprule" _n;
file write `hh' "  Model & \multicolumn{1}{c}{Time} & \multicolumn{1}{c}{Wealth} & \multicolumn{1}{c}{CEA} & \multicolumn{1}{c}{Un Risk}& \multicolumn{1}{c}{All 3} & \multicolumn{1}{c}{Baseline} & \multicolumn{1}{c}{Interact} " $eolString _n "\midrule " _n;

file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(m5b0)/m5se0));
do MakeTestStringJ;
file write `hh' %4.3f (m5b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m1b0)/m1se0));
do MakeTestStringJ;
file write `hh' %4.3f (m1b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m2b0)/m2se0));
do MakeTestStringJ;
file write `hh' %4.3f (m2b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m3b0)/m3se0));
do MakeTestStringJ;
file write `hh' %4.3f (m3b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m6b0)/m6se0));
do MakeTestStringJ;
file write `hh' %4.3f (m6b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4b0)/m4se0));
do MakeTestStringJ;
file write `hh' %4.3f (m4b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7b0)/m7se0));
do MakeTestStringJ;
file write `hh' %4.3f (m7b0) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (m5se0) ")  &  (" %4.3f (m1se0) ")  &  (" %4.3f (m2se0) ")  &  (" %4.3f (m3se0) ")  &  (" %4.3f (m6se0) ")  &  (" %4.3f (m4se0) ")  & ("%4.3f (m7se0) ")" $eolString _n;


file write `hh' "\$\gamma_m$   & &";
sca ptest = 2*(1-normal(abs(m1bm)/m1sem));
do MakeTestStringJ;
file write `hh' %4.3f (m1bm) (teststr) "  & & & ";
sca ptest = 2*(1-normal(abs(m6bm)/m6sem));
do MakeTestStringJ;
file write `hh' %4.3f (m6bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bm)/m4sem));
do MakeTestStringJ;
file write `hh' %4.3f (m4bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bm)/m7sem));
do MakeTestStringJ;
file write `hh' %4.3f (m7bm) (teststr) $eolString _n;

file write `hh' " & & (" %4.3f (m1sem) ")  &  & &   (" %4.3f (m6sem) ")  &  (" %4.3f (m4sem) ")  &  (" %4.3f (m7sem)  ") "  $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & & & ";
sca ptest = 2*(1-normal(abs(m2bCEA)/m2seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (m2bCEA) (teststr) "  & &";
sca ptest = 2*(1-normal(abs(m6bCEA)/m6seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (m6bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bCEA)/m4seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (m4bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bCEA)/m7seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (m7bCEA) (teststr)  $eolString _n;

file write `hh' " & & & (" %4.3f (m2seCEA) ")  &   &   (" %4.3f (m6seCEA) ")  &  (" %4.3f (m4seCEA) ")  &  (" %4.3f (m7seCEA) ")"  $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & & & & ";

sca ptest = 2*(1-normal(abs(m3bunpred)/m3seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (m3bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m6bunpred)/m6seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (m6bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m4bunpred)/m4seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (m4bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m7bunpred)/m7seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (m7bunpred) (teststr) $eolString _n;

file write `hh' " &   &   &  & (" %4.3f (m3seunpred) ")  &   (" %4.3f (m6seunpred) ")  &   (" %4.3f (m4seunpred) ")  &   (" %4.3f (m7seunpred) " ) "  $eolString _n;

file write `hh' " \$\gamma_{t}$   & ";
sca ptest = 2*(1-normal(abs(m5btime)/m5setime));
do MakeTestStringJ;
file write `hh' %4.3f (m5btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m1btime)/m1setime));
do MakeTestStringJ;
file write `hh' %4.3f (m1btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m2btime)/m2setime));
do MakeTestStringJ;
file write `hh' %4.3f (m2btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m3btime)/m3setime));
do MakeTestStringJ;
file write `hh' %4.3f (m3btime) (teststr) "  &  "; 
sca ptest = 2*(1-normal(abs(m6btime)/m6setime));
do MakeTestStringJ;
file write `hh' %4.3f (m6btime) (teststr) "  & & "; 
sca ptest = 2*(1-normal(abs(m7btime)/m7setime));
do MakeTestStringJ;
file write `hh' %4.3f (m7btime) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (m5setime) ")& (" %4.3f (m1setime) ") & (" %4.3f (m2setime) ") & (" %4.3f (m3setime) ") & ( " %4.3f (m6setime) 
" ) & & (" %4.3f (m7setime) ")"  $eolString _n;

file write `hh' " \$\gamma_{uC}$   &  & & & & & & ";
sca ptest = 2*(1-normal(abs(m7bunCEA)/m7seunCEA));
do MakeTestStringJ;
file write `hh' %4.3f (m7bunCEA) (teststr) $eolString _n;

file write `hh' " &   &  &  & & & & (" %4.3f (m7seunCEA) ")   "  $eolString _n;

file write `hh' "\midrule " _n;

file write `hh' " \$\bar{R}^2$  & ";
file write `hh' %4.3f (m5r1) "  & " %4.3f (m1r1) "  & " %4.3f (m2r1) "  & " %4.3f (m3r1) "  & " %4.3f (m6r1) "  & " %4.3f (m4r1) "  & " %4.3f (m7r1)  $eolString _n;

file write `hh' " F stat p val  & ";
file write `hh' %6.5f (m5fpval) "  & " %6.5f (m1fpval) "  & " %6.5f (m2fpval) "  & " %6.5f (m3fpval) "  & " %6.5f (m6fpval) "  & " %6.5f (m4fpval)  "  & " %6.5f (m7fpval)  $eolString _n;

file write `hh' "DW stat  & ";
file write `hh' %4.3f (m5dw) "  & " %4.3f (m1dw) "  & " %4.3f (m2dw) "  & " %4.3f (m3dw) " & "  %4.3f (m6dw)  " & "  %4.3f (m4dw)  " & "  %4.3f (m7dw)  $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\footnotesize Notes: Estimation sample: 1966Q2--2011Q1. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent. Newey--West standard errors, 4 lags.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

