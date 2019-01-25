
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tOLS_subSample.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Additional Saving Regressions II.---Sub-sample Stability} \label{tOLS_subSample} %\small " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}@{}}" _n;
file write `hh' "\multicolumn{4}{c}{ \$s_t=\gamma_0+\gamma_m m_t+\gamma_{\CEA}\CEA_t+ \gamma_{Eu}\Ex_t u_{t+4}+\varepsilon_t$ } " $eolString  _n "\toprule" _n;
file write `hh' "     Model & \multicolumn{1}{c}{Baseline} & \multicolumn{1}{c}{Post-1980}& \multicolumn{1}{c}{Pre-2008}  " $eolString _n "\midrule " _n;

file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(b0_base)/se0_base));
do MakeTestStringJ;
file write `hh' %4.3f (b0_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_post80)/se0_post80));
do MakeTestStringJ;
file write `hh' %4.3f (b0_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_pre08)/se0_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (b0_pre08) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (se0_base) ")  &  (" %4.3f (se0_post80) ")  &  (" %4.3f (se0_pre08) ")" $eolString _n;


file write `hh' "\$\gamma_m$   & ";
sca ptest = 2*(1-normal(abs(bm_base)/sem_base));
do MakeTestStringJ;
file write `hh' %4.3f (bm_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_post80)/sem_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bm_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_pre08)/sem_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bm_pre08) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (sem_base) ")  &  (" %4.3f (sem_post80) ")  &  (" %4.3f (sem_pre08) ") "  $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & ";
sca ptest = 2*(1-normal(abs(bCEA_base)/seCEA_base));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_post80)/seCEA_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_pre08)/seCEA_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_pre08) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (seCEA_base) ")  &  (" %4.3f (seCEA_post80) ")  &  (" %4.3f (seCEA_pre08) " ) "  $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & ";
sca ptest = 2*(1-normal(abs(bunpred_base)/seunpred_base));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_base) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(bunpred_post80)/seunpred_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_post80) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(bunpred_pre08)/seunpred_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_pre08) (teststr)  $eolString _n;

file write `hh' " &   (" %4.3f (seunpred_base) ")  &   (" %4.3f (seunpred_post80) ")  &   (" %4.3f (seunpred_pre08) " ) "  $eolString _n;

file write `hh' " \$\gamma_{\text{0post80}}$/\$\gamma_{\text{0post07}}$  & ";
file write `hh' "  & ";
sca ptest = 2*(1-normal(abs(b0post80_post80)/se0post80_post80));
do MakeTestStringJ;
file write `hh' %4.3f (b0post80_post80) (teststr) "  &  ";
sca ptest = 2*(1-normal(abs(b0post07_pre08)/se0post07_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (b0post07_pre08) (teststr) $eolString _n;

file write `hh' " &  &  (" %4.3f (se0post80_post80) ")   & (" %4.3f (se0post07_pre08) ")  "  $eolString _n;


file write `hh' " \$\gamma_{m\text{post80}}$/\$\gamma_{m\text{post07}}$  & ";
file write `hh' "  &  ";
sca ptest = 2*(1-normal(abs(bmpost80_post80)/sempost80_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bmpost80_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bmpost07_pre08)/sempost07_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bmpost07_pre08) (teststr) $eolString _n;

file write `hh' " & &  (" %4.3f (sempost80_post80) ")  & (" %4.3f (sempost07_pre08) ")  "  $eolString _n;

file write `hh' " \$\gamma_{\CEA\text{post80}}$/\$\gamma_{\CEA\text{post07}}$  & ";
file write `hh' "  &  ";
sca ptest = 2*(1-normal(abs(bCEApost80_post80)/seCEApost80_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bCEApost80_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEApost07_pre08)/seCEApost07_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bCEApost07_pre08) (teststr) $eolString _n;

file write `hh' " &  & (" %4.3f (seCEApost80_post80) ")  & (" %4.3f (seCEApost07_pre08) ") "  $eolString _n;

file write `hh' " \$\gamma_{Eu\text{post80}}$/\$\gamma_{Eu\text{post07}}$  & ";
file write `hh' "  & ";
sca ptest = 2*(1-normal(abs(bunpredpost80_post80)/seunpredpost80_post80));
do MakeTestStringJ;
file write `hh' %4.3f (bunpredpost80_post80) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bunpredpost07_pre08)/seunpredpost07_pre08));
do MakeTestStringJ;
file write `hh' %4.3f (bunpredpost07_pre08) (teststr) $eolString _n;

file write `hh' " &   &  (" %4.3f (seunpredpost80_post80) ")  &  (" %4.3f (seunpredpost07_pre08) ") "  $eolString _n;


file write `hh' "\midrule " _n;

file write `hh' " \$\bar{R}^2$  & ";
file write `hh' %4.3f (r1_base) "  & " %4.3f (r1_post80)  "  & " %4.3f (r1_pre08)  $eolString _n;

file write `hh' " F stat p val  & ";
file write `hh' %6.5f (fpval_base) "  & " %6.5f (fpval_post80) "  & " %6.5f (fpval_pre08) $eolString _n;

file write `hh' " F p val post-80/pre-08 & & " %6.5f (fpvalPost80_post80) "  &  "  %6.5f (fpvalPost07_pre08) $eolString _n;

file write `hh' "DW stat  & ";
file write `hh' %4.3f (dw_base) "  & " %4.3f (dw_post80) "  & " %4.3f (dw_pre08)  $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\footnotesize Notes: Estimation sample: 1966q2--2011q1. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent. Newey--West standard errors, 4 lags. \$\CEA$ is the Credit Easing Accumulated Index. Pre-2008: Heteroscedasticity robust standard errors (because post-2007 sample consists of only 13 observations).}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

