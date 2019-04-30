**********************************************************************************
* OLS/IV Models of US Personal Saving Rate
**********************************************************************************

clear
#delimit;
set scheme s2color;
set scheme ecb2015;

gr drop _all; discard;
global eolString "_char(92) _char(92)";		//* string denoting new line in LaTeX tables \\;


cd $logPath;

capture log close;
log using $logPath\drawAdditionalCharts_01.log, replace;
set more off;

set scheme ecb2015;

***********************************************************************************;
global startRegW  "1966q2";
global startRegW2ndHalf  "1980q1";
global endRegW  "2011q4";  *"2017q4";
global nwLags "4";				* Newey-West lags;
global dmmIndex "0";				* CCI index of Duca et al 2010;
global ceaIndex "3";				* [1] 1 CEA_comp, 2 CEA_comp_unw, 3 CEA_base, 4 CEA_mue;
global psroldIndex "0";				* [0] 1 use outdated PSR series (available until 2011Q1;
global savingSeriesIndex "PSR";			* What measure of saving to use? "PSR" [default], "inflAdj" inflation-adjusted, "model" model-implied SR
						"grossHh", gross Hh S/DI, "netPrivate" net private S/GDP, "grossPrivate" gross private S/GDP
						"fofInclDur" FoF SR including durables, "fofExclDur" FoF SR excluding durables;
***********************************************************************************;

//*use $dataPath\cssussavingdata_20120628.dta;
*import excel using "P:\ECB business areas\DGR\Databases and Programme files\MPR\D - Other projects\Slacalek -- cssUSsaving\code\data\cssUSsavingData_20160726_selection_new.xlsx", firstrow sheet(Clean);
import excel using $dataPath\20190124_cssUSsavingData_selection.xlsx, firstrow sheet(Clean);

gen popOld_share=100*pop_above65/pop;
gen corpSav_share = 100*corp_sav/gdp;
gen govSav_share = 100*gov_sav/gdp;

gen top1_wealth_perc = 100*top1_wealth;
gen top1_income_perc = 100*top1_income;

label var corpSav_share "Corporate";
label var govSav_share "Government";
label var psr "Personal";
label var top1_wealth_perc "Wealth";
label var top1_income_perc "Income";

drop AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU;


gen t =  q(1960q1)+_n-1;
*format t %tq;
format t %tq;
tsset t;



* Government saving;
twoway
(line govSav_share t, lcolor(black) lwidth(medthick) lpattern(solid))
(line corpSav_share t, lcolor(blue*1.2) lwidth(medium) lpattern(solid))
(line psr t, lcolor("0 177 234") lwidth(medium) lpattern(solid) xtitle("Year") xlabel(0(40)220,format(%tqCY)) ytitle("Percent") ylabel(-15(5)15) legend(rows(1)))
;

graph export "govSavingShare.pdf", replace;
graph export "govSavingShare.emf", replace;
graph export "govSavingShare.png", replace;
graph export "govSavingShare.svg", replace;

* Top income wealth shares;
twoway
(line top1_income_perc t, lcolor(black) lwidth(medthick) lpattern(solid))
(line top1_wealth_perc t, lcolor(blue*1.2) lwidth(medium) lpattern(solid) xtitle("Year") xlabel(0(40)220,format(%tqCY)) ytitle("Share of Top 1% on Total, Percent") ylabel(0(5)40) legend(rows(1)))
;

graph export "topIncomeShare.pdf", replace;
graph export "topIncomeShare.emf", replace;
graph export "topIncomeShare.png", replace;
graph export "topIncomeShare.svg", replace;


* Demographics: Share above 65;
twoway
(line popOld_share t, lcolor(black) lwidth(medthick) lpattern(solid) xtitle("Year") xlabel(0(40)220,format(%tqCY)) ytitle("Share on Total, Percent") ylabel(0(5)16) legend(off))
;


graph export "sharePopOld.pdf", replace;
graph export "sharePopOld.emf", replace;
graph export "sharePopOld.png", replace;
graph export "sharePopOld.svg", replace;

