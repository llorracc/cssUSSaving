
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tRFtable_all.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Reduced-Form Regressions} \label{tRFall} \small " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}d{6}d{6}d{6}@{}}" _n;
file write `hh' "\multicolumn{7}{c}{ \$s_t=\gamma_0+\gamma_m m_t+\gamma_{\CEA}\CEA_t+ \gamma_{Eu}\Ex_t u_{t+4}+\gamma'X_t+\varepsilon_t$ } " $eolString  _n "\toprule" _n;

file write `hh' "   & & & \multicolumn{2}{c}{Reduced-Form} & \multicolumn{2}{c}{Additional Variables} " $eolString _n;
file write `hh' "  \cmidrule(l){4-5} \cmidrule(l){6-7} " _n;

file write `hh' "  Model & \multicolumn{1}{c}{Uncertainty} & \multicolumn{1}{c}{Demographics} & \multicolumn{1}{c}{Baseline} & \multicolumn{1}{c}{Time Trend}& \multicolumn{1}{c}{Gov Sav} & \multicolumn{1}{c}{Ineq} " $eolString _n "\midrule " _n;

file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(mUncT_b0)/mUncT_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mUncT_b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mDem_b0)/mDem_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mDem_b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mAll3_b0)/mAll3_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mAll3_b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mRF_b0)/mRF_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mRF_b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mGovSav_b0)/mGovSav_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mGovSav_b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mIneq_b0)/mIneq_se0));
do MakeTestStringJ;
file write `hh' %4.3f (mIneq_b0) (teststr) $eolString _n;

file write `hh' " & (" %4.3f (mUncT_se0) ")  &  (" %4.3f (mDem_se0) ")  &  (" %4.3f (mAll3_se0) ")  &  (" %4.3f (mRF_se0) ")  &  ("  %4.3f (mGovSav_se0) ")  & ("%4.3f (mIneq_se0) ")" $eolString _n;


file write `hh' "\$\gamma_m$   & &";
sca ptest = 2*(1-normal(abs(mDem_bm)/mDem_sem));
do MakeTestStringJ;
file write `hh' %4.3f (mDem_bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mAll3_bm)/mAll3_sem));
do MakeTestStringJ;
file write `hh' %4.3f (mAll3_bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mRF_bm)/mRF_sem));
do MakeTestStringJ;
file write `hh' %4.3f (mRF_bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mGovSav_bm)/mGovSav_sem));
do MakeTestStringJ;
file write `hh' %4.3f (mGovSav_bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mIneq_bm)/mIneq_sem));
do MakeTestStringJ;
file write `hh' %4.3f (mIneq_bm) (teststr) $eolString _n;

file write `hh' " & & ("  %4.3f (mDem_sem) ")  &  (" %4.3f (mAll3_sem) ")  &  (" %4.3f (mRF_sem) ")  &  (" %4.3f (mGovSav_sem) ")  & ("%4.3f (mIneq_sem) ")" $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & & ";
sca ptest = 2*(1-normal(abs(mDem_bCEA)/mDem_seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (mDem_bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mAll3_bCEA)/mAll3_seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (mAll3_bCEA) (teststr) "  &";
sca ptest = 2*(1-normal(abs(mRF_bCEA)/mRF_seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (mRF_bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mGovSav_bCEA)/mGovSav_seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (mGovSav_bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mIneq_bCEA)/mIneq_seCEA));
do MakeTestStringJ;
file write `hh' %4.3f (mIneq_bCEA) (teststr)  $eolString _n;

file write `hh' " & & (" %4.3f (mDem_seCEA) ")  &  (" %4.3f (mAll3_seCEA) ")  &  (" %4.3f (mRF_seCEA) ")  &  ("  %4.3f (mGovSav_seCEA) ")  & ("%4.3f (mIneq_seCEA) ")" $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & ";

sca ptest = 2*(1-normal(abs(mUncT_bunpred)/mUncT_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mUncT_bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(mDem_bunpred)/mDem_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mDem_bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(mAll3_bunpred)/mAll3_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mAll3_bunpred) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mRF_bunpred)/mRF_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mRF_bunpred) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mGovSav_bunpred)/mGovSav_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mGovSav_bunpred) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(mIneq_bunpred)/mIneq_seunpred));
do MakeTestStringJ;
file write `hh' %4.3f (mIneq_bunpred) (teststr) $eolString _n;

file write `hh' " & ("  %4.3f (mUncT_seunpred) ") & (" %4.3f (mDem_seunpred) ")  &  (" %4.3f (mAll3_seunpred) ")  &  (" %4.3f (mRF_seunpred) ")  &  ("   %4.3f (mGovSav_seunpred) ")  & ("%4.3f (mIneq_seunpred) ")" $eolString _n;

file write `hh' " \$\gamma_{t}$   & ";
sca ptest = 2*(1-normal(abs(mUncT_btime)/mUncT_setime));
do MakeTestStringJ;
file write `hh' %4.3f (mUncT_btime) (teststr) "  & & &"; 
sca ptest = 2*(1-normal(abs(mRF_btime)/mRF_setime));
do MakeTestStringJ;
file write `hh' %4.3f (mRF_btime) (teststr) "  & & " $eolString _n; 

file write `hh' " &(" %4.3f (mUncT_setime) ") & & & (" %4.3f (mRF_setime) ")  &    &  " $eolString _n;


file write `hh' " \$\gamma_\text{old}$   &  & ";
sca ptest = 2*(1-normal(abs(mDem_bold)/mDem_seold));
do MakeTestStringJ;
file write `hh' %4.3f (mDem_bold) (teststr) " & & & &   " $eolString _n;
file write `hh' " &    &  (" %4.3f (mDem_seold) ") & & &  &   "  $eolString _n;


file write `hh' " \$\gamma_\text{gov sav}$     & & & & &";
sca ptest = 2*(1-normal(abs(mGovSav_bGS)/mGovSav_seGS));
do MakeTestStringJ;
file write `hh' %4.3f (mGovSav_bGS) (teststr) "  &  " $eolString _n;
file write `hh' " &      & & & &(" %4.3f (mGovSav_seGS) ") &  "  $eolString _n;

file write `hh' " \$\gamma_\text{inc share}$   &  & & & & &";
sca ptest = 2*(1-normal(abs(mIneq_bIneq)/mIneq_seIneq));
do MakeTestStringJ;
file write `hh' %4.3f (mIneq_bIneq) (teststr)  $eolString _n;
file write `hh' " & &   & & & &(" %4.3f (mIneq_seIneq) ")  "  $eolString _n;

file write `hh' "\midrule " _n;

file write `hh' " \$\bar{R}^2$  & ";
file write `hh'  %4.3f (mUncT_r1) "  &  " %4.3f (mDem_r1) "  & " %4.3f (mAll3_r1) "  &  " %4.3f (mRF_r1)  "  &  "  %4.3f (mGovSav_r1) "  & "%4.3f (mIneq_r1)  $eolString _n;

file write `hh' " F stat p val  & ";
file write `hh'  %4.3f (mUncT_fpval) " & " %4.3f (mDem_fpval) "  &  " %4.3f (mAll3_fpval) "  &  " %4.3f (mRF_fpval)  " & " %4.3f (mGovSav_fpval) " & "%4.3f (mIneq_fpval)  $eolString _n;

file write `hh' "DW stat  & ";
file write `hh'  %4.3f (mUncT_dw) "  & " %4.3f (mDem_dw) "  & " %4.3f (mAll3_dw) "  &  " %4.3f (mRF_dw)  "  & " %4.3f (mGovSav_dw) "  & "%4.3f (mIneq_dw)  $eolString _n;


file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\footnotesize Notes: Estimation sample: 1966q2--2011q4. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent. Newey--West standard errors, 4 lags.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

