
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tPred.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Personal Saving Rate---Actual and Explained Change, 2007--2010} \label{tPred} " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}lrrc@{}}" $eolString  _n "\toprule" _n;
file write `hh' "     Variable & \multicolumn{1}{c}{Baseline }& \multicolumn{1}{c}{Interact }& \multicolumn{1}{c}{Actual \$\Delta s_t\$ }" $eolString _n "\midrule " _n;

sca m4mTimesDwy=m4bm*dwyRat;
file write `hh' "\$\gamma_m\times\Delta m_t\$ & \$ ";
file write `hh' %4.2f (m4bm)  " \times " %4.2f (dwyRat)  " = "  %4.2f (m4mTimesDwy) " \$ & \$ ";
sca m7mTimesDwy=m7bm*dwyRat;
file write `hh' %4.2f (m7bm)  " \times " %4.2f (dwyRat)  " = "  %4.2f (m7mTimesDwy) " \$ & " $eolString _n;

sca m4CEATimesdCEA=m4bCEA*dCEA;
file write `hh' "\$\gamma_\CEA\times\Delta \CEA_t\$ & \$ ";
file write `hh' %4.2f (m4bCEA)  " \times " %4.2f (dCEA)  " = "  %4.2f (m4CEATimesdCEA) " \$ & \$ ";
sca m7CEATimesdCEA=m7bCEA*dCEA;
file write `hh' %4.2f (m7bCEA)  " \times " %4.2f (dCEA)  " = "  %4.2f (m7CEATimesdCEA) " \$ &  " $eolString _n;


sca m4unTimesdun=m4bunpred*dunemp_pred;
file write `hh' "\$\gamma_{Eu}\times\Delta \Ex_t u_{t+4} \$ & \$ ";
file write `hh' %4.2f (m4bunpred)  " \times " %4.2f (dunemp_pred)  " = "  %4.2f (m4unTimesdun) " \$ & \$ ";
sca m7unTimesdun=m7bunpred*dunemp_pred;
file write `hh' %4.2f (m7bunpred)  " \times " %4.2f (dunemp_pred)  " = "  %4.2f (m7unTimesdun) " \$ & " $eolString _n;


file write `hh' "\$\gamma_{uC}\times\Delta (\Ex_t u_{t+4}\times\CEA_t) \$ &  & \$ ";
sca m7unCEATimesdunCEA=m7bunCEA*dunCEA;
file write `hh' %4.2f (m7bunCEA)  " \times " %4.2f (dunCEA)  " = "  %4.2f (m7unCEATimesdunCEA) " \$ &  " $eolString "\midrule" _n;

sca m4Expl=m4mTimesDwy+m4CEATimesdCEA+m4unTimesdun;
sca m7Expl=m7mTimesDwy+m7CEATimesdCEA+m7unTimesdun+m7unCEATimesdunCEA;


file write `hh' "Explained \$\Delta s_t\$ &  "  %4.2f (m4Expl)  " &  "  %4.2f (m7Expl) " & "  %4.2f (dsaving_rate) $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\end{table} " _n;
file close `hh';

