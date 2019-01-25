
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tUnivarYPSR.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Univariate Properties of Disposable Income and Personal Saving Rate} \label{tUnivarYPSR} " _n;
file write `hh' "\begin{center}" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}ld{6}d{6}d{6}@{}}" _n;
file write `hh' "\toprule" _n;
file write `hh' "     Series & \multicolumn{1}{c}{Official BEA} & \multicolumn{1}{c}{Less Cleaned} & \multicolumn{1}{c}{More Cleaned}  " $eolString _n "\midrule " _n;

file write `hh' "      & \multicolumn{3}{c}{Disposable Income---Log-level}  " $eolString _n;
file write `hh' "First Autocorrelation & " %4.3f (rho1_lydisp) " & " %4.3f (rho1_lydisp_clean_simple) " & "  %4.3f (rho1_lydisp_clean_compl)  $eolString _n;  
file write `hh' "Box--Ljung Q stat, p value & " %4.3f (probQ_lydisp) " & " %4.3f (probQ_lydisp_clean_simple) " & "  %4.3f (probQ_lydisp_clean_compl)  $eolString _n;  
file write `hh' "Augmented Dickey--Fuller test, p value & " %4.3f (probADF_lydisp) " & " %4.3f (probADF_lydisp_clean_simple) " & "  %4.3f (probADF_lydisp_clean_compl)  $eolString _n "\midrule " _n;  

file write `hh' "      & \multicolumn{3}{c}{Disposable Income---Growth Rate}  " $eolString _n;
file write `hh' "First Autocorrelation & " %4.3f (rho1_dydisp) " & " %4.3f (rho1_dydisp_clean_simple) " & "  %4.3f (rho1_dydisp_clean_compl)  $eolString _n;  
file write `hh' "Box--Ljung Q stat, p value & " %4.3f (probQ_dydisp) " & " %4.3f (probQ_dydisp_clean_simple) " & "  %4.3f (probQ_dydisp_clean_compl)  $eolString _n;  
file write `hh' "Augmented Dickey--Fuller test, p value & " %4.3f (probADF_dydisp) " & " %4.3f (probADF_dydisp_clean_simple) " & "  %4.3f (probADF_dydisp_clean_compl)  $eolString _n "\midrule " _n;  

file write `hh' "      & \multicolumn{3}{c}{Personal Saving Rate}  " $eolString _n;
file write `hh' "First Autocorrelation & " %4.3f (rho1_saving_rate) " & " %4.3f (rho1_saving_rate_clean_simple) " & "  %4.3f (rho1_saving_rate_clean_compl)  $eolString _n;  
file write `hh' "Box--Ljung Q stat, p value & " %4.3f (probQ_saving_rate) " & " %4.3f (probQ_saving_rate_clean_simple) " & "  %4.3f (probQ_saving_rate_clean_compl)  $eolString _n;  
file write `hh' "Augmented Dickey--Fuller test, p value & " %4.3f (probADF_saving_rate) " & " %4.3f (probADF_saving_rate_clean_simple) " & "  %4.3f (probADF_saving_rate_clean_compl)  $eolString _n;  

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}"  _n;

file write `hh' " {\small Notes: Box--Ljung statistics: 8 lags, ADF test: 4 lags.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

