
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tCampbell87.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ \cite{cam87} Saving for a Rainy Day Regressions } \label{tCampbell87} " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}@{}}" _n;
file write `hh' "\toprule" _n;
file write `hh' "     Series & \multicolumn{1}{c}{Official BEA} & \multicolumn{1}{c}{Less Cleaned} & \multicolumn{1}{c}{More Cleaned}  " $eolString _n "\midrule " _n;
file write `hh' "\multicolumn{4}{c}{ Full Sample: 1966Q2--2011Q1 }" $eolString  _n;
file write `hh' "\multicolumn{4}{c}{ \$s_t=\alpha_0+\alpha_1 \Delta y_{t+1}+ \varepsilon_t \$ } " $eolString  _n;

file write `hh' "\$\alpha_1$ & ";
sca ptest = 2*(1-normal(abs(by_F1_full_official)/sey_F1_full_official));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_full_official) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F1_full_clean_simple)/sey_F1_full_clean_simple));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_full_clean_simple) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F1_full_clean_compl)/sey_F1_full_clean_compl));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_full_clean_compl) (teststr)  $eolString _n;
file write `hh' " & (" %4.3f (sey_F1_full_official) ")  &  (" %4.3f (sey_F1_full_clean_simple) ")  &  (" %4.3f (sey_F1_full_clean_compl) ")" $eolString _n;
file write `hh' " $\bar{R}^2$ & " %4.3f (r2adj_F1_full_official) "  &  " %4.3f (r2adj_F1_full_clean_simple) "  &  " %4.3f (r2adj_F1_full_clean_compl)  $eolString _n;

file write `hh' "\multicolumn{4}{c}{ \$s_t=\alpha_0+\alpha_1 \Delta y_{t+2}+ \varepsilon_t \$ } " $eolString  _n;

file write `hh' "\$\alpha_1$ & ";
sca ptest = 2*(1-normal(abs(by_F2_full_official)/sey_F2_full_official));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_full_official) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F2_full_clean_simple)/sey_F2_full_clean_simple));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_full_clean_simple) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F2_full_clean_compl)/sey_F2_full_clean_compl));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_full_clean_compl) (teststr)  $eolString _n;
file write `hh' " & (" %4.3f (sey_F2_full_official) ")  &  (" %4.3f (sey_F2_full_clean_simple) ")  &  (" %4.3f (sey_F2_full_clean_compl) ")" $eolString _n;
file write `hh' " $\bar{R}^2$ & " %4.3f (r2adj_F2_full_official) "  &  " %4.3f (r2adj_F2_full_clean_simple) " & " %4.3f (r2adj_F2_full_clean_compl) $eolString _n "\midrule " _n;

file write `hh' "\multicolumn{4}{c}{ Pre-1985 Sample: 1966Q2--1984Q4 }" $eolString  _n;
file write `hh' "\multicolumn{4}{c}{ \$s_t=\alpha_0+\alpha_1 \Delta y_{t+1}+ \varepsilon_t \$ } " $eolString  _n;

file write `hh' "\$\alpha_1$ & ";
sca ptest = 2*(1-normal(abs(by_F1_camp_official)/sey_F1_camp_official));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_camp_official) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F1_camp_clean_simple)/sey_F1_camp_clean_simple));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_camp_clean_simple) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F1_camp_clean_compl)/sey_F1_camp_clean_compl));
do MakeTestStringJ;
file write `hh' %4.3f (by_F1_camp_clean_compl) (teststr)  $eolString _n;
file write `hh' " & (" %4.3f (sey_F1_camp_official) ")  &  (" %4.3f (sey_F1_camp_clean_simple) ")  &  (" %4.3f (sey_F1_camp_clean_compl) ")" $eolString _n;
file write `hh' " $\bar{R}^2$ & " %4.3f (r2adj_F1_camp_official) "  &  " %4.3f (r2adj_F1_camp_clean_simple) "  &  " %4.3f (r2adj_F1_camp_clean_compl) $eolString _n;

file write `hh' "\multicolumn{4}{c}{ \$s_t=\alpha_0+\alpha_1 \Delta y_{t+2}+ \varepsilon_t \$ } " $eolString  _n;

file write `hh' "\$\alpha_1$ & ";
sca ptest = 2*(1-normal(abs(by_F2_camp_official)/sey_F2_camp_official));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_camp_official) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F2_camp_clean_simple)/sey_F2_camp_clean_simple));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_camp_clean_simple) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(by_F2_camp_clean_compl)/sey_F2_camp_clean_compl));
do MakeTestStringJ;
file write `hh' %4.3f (by_F2_camp_clean_compl) (teststr)  $eolString _n;
file write `hh' " & (" %4.3f (sey_F2_camp_official) ")  &  (" %4.3f (sey_F2_camp_clean_simple) ")  &  (" %4.3f (sey_F2_camp_clean_compl) ")" $eolString _n;
file write `hh' " $\bar{R}^2$ & " %4.3f (r2adj_F2_camp_official) "  &  " %4.3f (r2adj_F2_camp_clean_simple) "  &  " %4.3f (r2adj_F2_camp_clean_compl) $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\small Notes: \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent. Newey--West standard errors, 4 lags.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

