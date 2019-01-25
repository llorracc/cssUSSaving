
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tOLS02.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{sidewaystable}" _n;
file write `hh' "\caption{ Additional Saving Regressions I.---Robustness to Explanatory Variables} \label{tOLS} \footnotesize " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}d{6}d{6}d{6}d{6}d{6}d{6}d{6}@{}}" _n;
file write `hh' "\multicolumn{11}{c}{ \$s_t=\gamma_0+\gamma_m m_t+\gamma_{\CEA}\CEA_t+ \gamma_{Eu}\Ex_t u_{t+4}+\gamma_\sigma\sigma_t+\gamma_s s_{t-1}+\gamma_d d_t+\gamma_{top5\%} \text{top5\%}_t+  {}$\dots } " $eolString  _n;
file write `hh' "\multicolumn{11}{c}{ \phantom{\$s_t=$}\dots\${}+\gamma_{db}\text{db}_t+ \gamma_{hitax} \text{hitax}_t+ \gamma_{lotax} \text{lotax}_t+\gamma_{r}r_t+\gamma_{GS}GS_t+\gamma_{CS} CS_t+\varepsilon_t$ } " $eolString  _n "\toprule" _n;
file write `hh' "     Model & \multicolumn{1}{c}{Baseline} & \multicolumn{1}{c}{Uncert} & \multicolumn{1}{c}{Lggd \$s_{t-1}\$} & \multicolumn{1}{c}{Debt} &
\multicolumn{1}{c}{Inc Ineq} & \multicolumn{1}{c}{DB Pnsn} & \multicolumn{1}{c}{Hi Tax Br} & \multicolumn{1}{c}{Lo Tax Br}
& \multicolumn{1}{c}{Mult Cntrls} & \multicolumn{1}{c}{IV}  " $eolString _n "\midrule " _n;

file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(b0_base)/se0_base));
do MakeTestStringJ;
file write `hh' %4.3f (b0_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_unc)/se0_unc));
do MakeTestStringJ;
file write `hh' %4.3f (b0_unc) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_lagsr)/se0_lagsr));
do MakeTestStringJ;
file write `hh' %4.3f (b0_lagsr) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_debt)/se0_debt));
do MakeTestStringJ;
file write `hh' %4.3f (b0_debt) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_top5)/se0_top5));
do MakeTestStringJ;
file write `hh' %4.3f (b0_top5) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_db)/se0_db));
do MakeTestStringJ;
file write `hh' %4.3f (b0_db) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_hi)/se0_hi));
do MakeTestStringJ;
file write `hh' %4.3f (b0_hi) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(b0_lo)/se0_lo));
do MakeTestStringJ;
file write `hh' %4.3f (b0_lo) (teststr) " & ";
sca ptest = 2*(1-normal(abs(b0_full)/se0_full));
do MakeTestStringJ;
file write `hh' %4.3f (b0_full) (teststr) " & ";
sca ptest = 2*(1-normal(abs(b0_iv)/se0_iv));
do MakeTestStringJ;
file write `hh' %4.3f (b0_iv) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (se0_base) ")  &  (" %4.3f (se0_unc) ")  &  (" %4.3f (se0_lagsr) ")  &  (" %4.3f (se0_debt) ")  &  ("%4.3f (se0_top5) ")  &  ("%4.3f (se0_db)  ")  &  ("%4.3f (se0_hi)  ")  &  ("%4.3f (se0_lo) ")  &  ("%4.3f (se0_full) ")  &  ("%4.3f (se0_iv) ")" $eolString _n;


file write `hh' "\$\gamma_m$   & ";
sca ptest = 2*(1-normal(abs(bm_base)/sem_base));
do MakeTestStringJ;
file write `hh' %4.3f (bm_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_unc)/sem_unc));
do MakeTestStringJ;
file write `hh' %4.3f (bm_unc) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_lagsr)/sem_lagsr));
do MakeTestStringJ;
file write `hh' %4.3f (bm_lagsr) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_debt)/sem_debt));
do MakeTestStringJ;
file write `hh' %4.3f (bm_debt) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_top5)/sem_top5));
do MakeTestStringJ;
file write `hh' %4.3f (bm_top5) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_db)/sem_db));
do MakeTestStringJ;
file write `hh' %4.3f (bm_db) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_hi)/sem_hi));
do MakeTestStringJ;
file write `hh' %4.3f (bm_hi) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_lo)/sem_lo));
do MakeTestStringJ;
file write `hh' %4.3f (bm_lo)  (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_full)/sem_full));
do MakeTestStringJ;
file write `hh' %4.3f (bm_full)  (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bm_iv)/sem_iv));
do MakeTestStringJ;
file write `hh' %4.3f (bm_iv) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (sem_base) ")  &  (" %4.3f (sem_unc) ")  &  (" %4.3f (sem_lagsr) ")  &  (" %4.3f (sem_debt) ")  &  ("%4.3f (sem_top5) ")  &  (" %4.3f (sem_db) ")  &  ("%4.3f (sem_hi)  ")  &  ("%4.3f (sem_lo)  ")  &  ("%4.3f (sem_full)  ")  &  (" %4.3f (sem_iv) ") "  $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & ";
sca ptest = 2*(1-normal(abs(bCEA_base)/seCEA_base));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_base) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_unc)/seCEA_unc));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_unc) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_lagsr)/seCEA_lagsr));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_lagsr) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_debt)/seCEA_debt));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_debt) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_top5)/seCEA_top5));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_top5) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_db)/seCEA_db));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_db) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_hi)/seCEA_hi));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_hi) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_lo)/seCEA_lo));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_lo) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_full)/seCEA_full));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_full) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(bCEA_iv)/seCEA_iv));
do MakeTestStringJ;
file write `hh' %4.3f (bCEA_iv) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (seCEA_base) ")  &  (" %4.3f (seCEA_unc) ")  &  (" %4.3f (seCEA_lagsr) ")  &  (" %4.3f (seCEA_debt) ")  &  (" %4.3f (seCEA_top5) ")  &  (" %4.3f (seCEA_db) ")  &  (" %4.3f (seCEA_hi) ")  &  ("%4.3f (seCEA_lo) ")  &  ("%4.3f (seCEA_full)  ")  &  (" %4.3f (seCEA_iv) " ) "  $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & ";
sca ptest = 2*(1-normal(abs(bunpred_base)/seunpred_base));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_base) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(bunpred_unc)/seunpred_unc));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_unc) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(bunpred_lagsr)/seunpred_lagsr));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_lagsr) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_debt)/seunpred_debt));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_debt) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_top5)/seunpred_top5));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_top5) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_db)/seunpred_db));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_db) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_hi)/seunpred_hi));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_hi) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_lo)/seunpred_lo));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_lo) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_full)/seunpred_full));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_full) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(bunpred_iv)/seunpred_iv));
do MakeTestStringJ;
file write `hh' %4.3f (bunpred_iv) (teststr) $eolString _n;

file write `hh' " &   (" %4.3f (seunpred_base) ")  &   (" %4.3f (seunpred_unc) ")  &   (" %4.3f (seunpred_lagsr) ")  &   (" %4.3f (seunpred_debt) ")  &   (" %4.3f (seunpred_top5) ")  &   (" %4.3f (seunpred_db) ")  &   (" %4.3f (seunpred_hi) ")  &   (" %4.3f (seunpred_lo) " )  &   (" %4.3f (seunpred_full) " )  &   (" %4.3f (seunpred_iv) " ) " $eolString _n;

file write `hh' " \$\gamma_{\sigma}$   & ";
file write `hh' "  & ";
sca ptest = 2*(1-normal(abs(bunc_unc)/seunc_unc));
do MakeTestStringJ;
file write `hh' %4.3f (bunc_unc) (teststr) "  &  &  &  & & & & & " $eolString _n;

file write `hh' " &   &  (" %4.3f (seunc_unc) ")  &  &   &  & & & & & " $eolString _n;

file write `hh' " \$\gamma_s$   & ";
file write `hh' "  & & ";
sca ptest = 2*(1-normal(abs(bs_lagsr)/ses_lagsr));
do MakeTestStringJ;
file write `hh' %4.3f (bs_lagsr) (teststr) "  &  &  & & & & & " $eolString _n;

file write `hh' " &   &  & (" %4.3f (ses_lagsr) ")  &  &  & & & & & "  $eolString _n;

file write `hh' " \$\gamma_d$   & ";
file write `hh' "  & & &";
sca ptest = 2*(1-normal(abs(bl_debt)/sel_debt));
do MakeTestStringJ;
file write `hh' %4.3f (bl_debt) (teststr) "  &  &  & & & & " $eolString _n;

file write `hh' " &   &  &  &(" %4.3f (sel_debt) ")  &  &  & & & & "  $eolString _n;

file write `hh' " \$\gamma_{top5\%}$   & ";
file write `hh' "  & & & & ";
sca ptest = 2*(1-normal(abs(bl_top5)/sel_top5));
do MakeTestStringJ;
file write `hh' %4.3f (bl_top5) (teststr) "  &  &  & & & " $eolString _n;

file write `hh' " &   &  &  & & (" %4.3f (sel_top5) ")  &  &  & & &  "  $eolString _n;

file write `hh' " \$\gamma_{db}$   & ";
file write `hh' "  & & & & & ";
sca ptest = 2*(1-normal(abs(bl_db)/sel_db));
do MakeTestStringJ;
file write `hh' %4.3f (bl_db) (teststr) "    &  & & &  " $eolString _n;

file write `hh' " &   &  & & & & (" %4.3f (sel_db) ")    &  & & &   "  $eolString _n;

file write `hh' " \$\gamma_{hitax}$   & ";
file write `hh' "  & & & & & & ";
sca ptest = 2*(1-normal(abs(bl_hi)/sel_hi));
do MakeTestStringJ;
file write `hh' %4.3f (bl_hi) (teststr) "  &  &  &  " $eolString _n;

file write `hh' " &  & &  & & & & (" %4.3f (sel_hi) ")  &  &  &  "  $eolString _n;

file write `hh' " \$\gamma_{lotax}$   & ";
file write `hh' "  & & & & & & &";
sca ptest = 2*(1-normal(abs(bl_lo)/sel_lo));
do MakeTestStringJ;
file write `hh' %4.3f (bl_lo) (teststr) "   &  &  " $eolString _n;

file write `hh' " &  & & & & & & & (" %4.3f (sel_lo) ")   &  & "  $eolString _n;


file write `hh' " \$\gamma_{r}$  & ";
file write `hh' "  & & & & & & & & ";
sca ptest = 2*(1-normal(abs(bir_full)/seir_full));
do MakeTestStringJ;
file write `hh' %4.3f (bir_full) (teststr) "  &  " $eolString _n;

file write `hh' " &   &  & & & & & & & (" %4.3f (seir_full) ")  &  " $eolString _n;

file write `hh' " \$\gamma_{GS}$  & ";
file write `hh' " & & & & & & & &  ";
sca ptest = 2*(1-normal(abs(bgs_full)/segs_full));
do MakeTestStringJ;
file write `hh' %4.3f (bgs_full) (teststr) "  & " $eolString _n;

file write `hh' " &   & & & & & & & &  (" %4.3f (segs_full) ")  &   " $eolString _n;

file write `hh' " \$\gamma_{CS}$  & ";
file write `hh' "  & & & & & & & &  ";
sca ptest = 2*(1-normal(abs(bcs_full)/secs_full));
do MakeTestStringJ;
file write `hh' %4.3f (bcs_full) (teststr) "  &  " $eolString _n;

file write `hh' " &  & & & & & & & &  (" %4.3f (secs_full) ")  &  "  $eolString _n;

file write `hh' "\midrule " _n;

file write `hh' " \$\bar{R}^2$  & ";
file write `hh' %4.3f (r1_base) "  & " %4.3f (r1_unc)  "  & " %4.3f (r1_lagsr) "  & " %4.3f (r1_debt) "  & " %4.3f (r1_top5) "  & " %4.3f (r1_db) "  & " %4.3f (r1_hi)  "  & " %4.3f (r1_lo)  "  & " %4.3f (r1_full)  "  & " $eolString _n;

file write `hh' " F st p val  & ";
file write `hh' %6.5f (fpval_base) "  & " %6.5f (fpval_unc) "  & " %6.5f (fpval_lagsr) "  & " %6.5f (fpval_debt) "  & " %6.5f (fpval_top5) "  & " %6.5f (fpval_db) "  & " %6.5f (fpval_hi) "  & " %6.5f (fpval_lo) "  & " %6.5f (fpval_full) "  & " %6.5f (fpval_iv) $eolString _n;

file write `hh' "DW stat  & ";
file write `hh' %4.3f (dw_base) "  & " %4.3f (dw_unc) "  & " %4.3f (dw_lagsr) "  & " %4.3f (dw_debt) "  & " %4.3f (dw_top5)  "  & " %4.3f (dw_db)  "  & " %4.3f (dw_hi) "  & " %4.3f (dw_lo) "  & " %4.3f (dw_full) " & " $eolString _n;

file write `hh' "OID p val &  & & & &  & & & & &" %4.3f (p2_iv)  $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\footnotesize Notes: Estimation sample: 1966q2--2011q1. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent. Newey--West standard errors, 4 lags. \$\CEA$ is the Credit Easing Accumulated Index, top5\%\ is the income share of the top 5 percent households (including capital gains, taken from \cite{pikettySaez:incomeIneq_qje03}), db is the gap between the BEA saving rate and the saving rate adjusted for defined-benefit pensions plans, hitax and lotax are top and bottom marginal tax rates respectively, \$GS$ is the government saving as a fraction of GDP, \$CS$ is the corporate saving as a fraction of GDP. In model IV, \$m\$, \$CEA\$ and $\Ex u$ are instrumented with lags 1 and 2 of \$m\$, $\Ex u$ and the \cite{abiadEtAl_FinReforms} Index of Financial Liberalization; the sample for the IV model is 1973q1--2005q4. OID p val denotes the p-value from the Hansen's \$J\$ statistic for overidentification.}" _n;
file write `hh' "\end{sidewaystable} " _n;
file close `hh';

