
filePath=['tStructEst.tex'];
fid=fopen(filePath,'w');

fprintf(fid, '\\begin{table} \n \\caption{ Calibration and Structural Estimates} \\label{tStructEst} \n ');
fprintf(fid, '\\begin{center} \n ');
fprintf(fid, '\\begin{tabular}{@{}lld{12}@{}} \n ');
fprintf(fid, '\\multicolumn{3}{c}{ $\\text{s}_t=\\text{s}\\big(\\{m_{t},\\CEA_{t},\\Ex_{t}u_{t+4} \\} ; \\Theta)$\\big), } \\\\ \n ');
fprintf(fid, '\\multicolumn{3}{c}{ $\\underline{h}_t=\\theta_{\\CEA} \\CEA_t$, } \\\\ \n ');
fprintf(fid, '\\multicolumn{3}{c}{  $\\mho_t=\\bar{\\theta}_\\mho+\\theta_u \\Ex_tu_{t+4}$. } \\\\ \n ');
fprintf(fid, '\\toprule \n ');
fprintf(fid, ' \\multicolumn{1}{l}{Parameter} & \\multicolumn{1}{l}{Description} & \\multicolumn{1}{c}{Value}  \\\\ \n \\midrule \n ');
fprintf(fid, '  \\multicolumn{3}{l}{Calibrated Parameters} \\\\ \n ');
fprintf(fid, '  $\\rfree$ & Interest Rate & \\multicolumn{1}{c}{0.04/4} \\\\ \n '); 
fprintf(fid, ' $\\Delta \\Wage$ & Wage Growth & \\multicolumn{1}{c}{0.01/4} \\\\ \n ');
fprintf(fid, ' $\\CRRA$  & Relative Risk Aversion & \\multicolumn{1}{c}{2} \\\\ \n \\midrule \n ');
fprintf(fid, ' \\multicolumn{3}{l}{Estimated Parameters $\\Theta=\\{\\Discount, \\theta_{\\CEA},\\bar{\\theta}_\\mho,\\theta_u\\}$}\\\\ \n ');

fprintf(fid, ' $\\Discount$ & Discount Factor & 1- ');
fprintf(fid,'%6.4f',parametersM1(4));
starr=makeStars(tStatsAll(4)); fprintf(fid,starr); 
fprintf(fid, '  \\\\ \n ');
fprintf(fid,' & & ('); fprintf(fid,'%6.4f',sesAll(4)); fprintf(fid,' ) \\\\ \n ');

fprintf(fid, ' ${\\theta}_{\\CEA}$ & Scaling of $\\CEA_t$ to $\\underline{h}_t$ & ');
fprintf(fid,'%6.4f',parametersM1(3));
starr=makeStars(tStatsAll(3)); fprintf(fid,starr); 
fprintf(fid, '  \\\\ \n ');
fprintf(fid,' & & ('); fprintf(fid,'%6.4f',sesAll(3)); fprintf(fid,' ) \\\\ \n ');

scaleFac=1e4;
scaledThetaMho=parametersM1(1)*scaleFac;
fprintf(fid, ' $\\bar{\\theta}_\\mho$ & Scaling of $\\Ex_tu_{t+4}$ to $\\mho_t$ & ');
fprintf(fid,'%6.4f',scaledThetaMho); fprintf(fid, ' \\times{10^{-4}}');
starr=makeStars(tStatsAll(1)); fprintf(fid,starr); 
fprintf(fid, '  \\\\ \n ');
scaledThetaMhoSE=sesAll(1)*scaleFac;
fprintf(fid,' & & ('); fprintf(fid,'%6.4f',scaledThetaMhoSE); fprintf(fid,'\\times{10^{-4}} ) \\\\ \n ');

scaleFac=1e4;
scaledThetaU=parametersM1(2)*scaleFac;
fprintf(fid, ' ${\\theta}_u$ & Scaling of $\\Ex_tu_{t+4}$ to $\\mho_t$ & ');
fprintf(fid,'%6.4f',scaledThetaU); fprintf(fid, ' \\times{10^{-4}}');
starr=makeStars(tStatsAll(2)); fprintf(fid,starr); 
fprintf(fid, '  \\\\ \n ');
scaledThetaUSE=sesAll(2)*scaleFac;
fprintf(fid,' & & ('); fprintf(fid,'%6.4f',scaledThetaUSE); fprintf(fid,' \\times{10^{-4}} ) \\\\ \n \\midrule \n ');

fprintf(fid, ' $\\bar{R}^2$ & & ');
fprintf(fid,'%6.3f',adjR2);
fprintf(fid, '  \\\\ \n ');
fprintf(fid, ' DW stat & & ');
fprintf(fid,'%6.3f',dwStat);
fprintf(fid, '  \\\\ \n \\midrule \n ');

fprintf(fid, '  & Sample average of $\\CEA_t$  & ');
fprintf(fid,'%6.4f',CEAmean); 
fprintf(fid, '  \\\\ \n ');

fprintf(fid, '  & Sample average of $\\Ex_tu_{t+4}$  & ');
fprintf(fid,'%6.4f',UnempMean); 
fprintf(fid, '  \\\\ \n ');


fprintf(fid, ' \\bottomrule \n \\end{tabular} \n \\end{center} \n ');

fprintf(fid, ' {\\footnotesize Notes: Quarterly calibration. Estimation sample: 1966q2--2011q4. $\\{{}^*,{}^{**},{}^{***}\\}={}$Statistical significance at $\\{10,5,1\\}$ percent.  Standard errors (in parentheses) were calculated with the delta method. ');
fprintf(fid, ' Parameter estimates imply sample averages of ');
fprintf(fid,'%6.2f',ceaRescaled_mean);
fprintf(fid, ' and ');
fprintf(fid,'%8.6f',mhoRescaled_mean);
fprintf(fid, ' for $\\underline{h}_t$ and $\\mho_t$, respectively. } \\\\ \n ');
fprintf(fid, ' \\end{table} \n \n');

fclose(fid);

disp('Done')
