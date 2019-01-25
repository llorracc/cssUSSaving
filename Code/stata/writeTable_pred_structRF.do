
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tPred_structRF.tex", write replace;
file write `hh' "  "_n;

*file write `hh' "\begin{table} " _n;
*file write `hh' "\caption{ Actual and Explained Change in PSR, 2007--2010} \label{tPred_structRF} " _n;
file write `hh' "\begin{center} \footnotesize" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}lrrc@{}}" $eolString  _n "\toprule" _n;
file write `hh' "     Variable & \multicolumn{1}{c}{Reduced-Form Model }& \multicolumn{1}{c}{Structural Model }& \multicolumn{1}{c}{Actual \$\Delta s_t\$ }" $eolString _n "\midrule " _n;

sca m4mTimesDwy=m4bm*dwyRat;
file write `hh' "\$\gamma_m\times\Delta m_t\$ & \$ ";
file write `hh' %4.2f (m4bm)  " \times " %4.2f (dwyRat)  " = "  %4.2f (m4mTimesDwy) " \$ & \$ ";
sca m4mTimesDwy_model=m4bm_model*dwyRat;
file write `hh' %4.2f (m4bm_model)  " \times " %4.2f (dwyRat)  " = "  %4.2f (m4mTimesDwy_model) " \$ & " $eolString _n;

sca m4CEATimesdCEA=m4bCEA*dCEA;
file write `hh' "\$\gamma_\CEA\times\Delta \CEA_t\$ & \$ ";
file write `hh' %4.2f (m4bCEA)  " \times " %4.2f (dCEA)  " = "  %4.2f (m4CEATimesdCEA) " \$ & \$ ";
sca m4CEATimesdCEA_model=m4bCEA_model*dCEA;
file write `hh' %4.2f (m4bCEA_model)  " \times " %4.2f (dCEA)  " = "  %4.2f (m4CEATimesdCEA_model) " \$ &  " $eolString _n;


sca m4unTimesdun=m4bunpred*dunemp_pred;
file write `hh' "\$\gamma_{Eu}\times\Delta \Ex_t u_{t+4} \$ & \$ ";
file write `hh' %4.2f (m4bunpred)  " \times " %4.2f (dunemp_pred)  " = "  %4.2f (m4unTimesdun) " \$ & \$ ";
sca m4unTimesdun_model=m4bunpred_model*dunemp_pred;
file write `hh' %4.2f (m4bunpred_model)  " \times " %4.2f (dunemp_pred)  " = "  %4.2f (m4unTimesdun_model) " \$ & " $eolString _n "\midrule " _n;


sca m4Expl=m4mTimesDwy+m4CEATimesdCEA+m4unTimesdun;
sca m4Expl_model=m4mTimesDwy_model+m4CEATimesdCEA_model+m4unTimesdun_model;


file write `hh' "Explained \$\Delta s_t\$ &  "  %4.2f (m4Expl)  " &  "  %4.2f (m4Expl_model) " & "  %4.2f (dsaving_rate) $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

*file write `hh' "\end{table} " _n;
file close `hh';

