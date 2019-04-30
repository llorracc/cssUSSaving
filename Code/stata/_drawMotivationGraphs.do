
**********************************************************************************
* US Wealth and Saving
**********************************************************************************
clear
#delimit;
gr drop _all;

set more off;
set scheme s1mono;
cd $logPath;
capture log close;
log using $logPath\drawMotivationGraphs.log, replace;

* Saving Rates;
********************************************************************;
import excel using $dataPath\Saving_20190425.xls, firstrow sheet(Stata);
gen quarterinrecession=Quarters-1;
gen zero=0;

graph twoway 
(area MaxRS quarterinrecession , color(gs11) xlabel(0(2)20))
(area MinRS quarterinrecession , color(gs11)) 
(line MeanRS quarterinrecession, clwidth(medthin) lcolor(black) lpattern(dash) xtitle("Quarters after Start of Recession") ytitle("Deviation from Start-of-Recession Value in %")) 
(line zero quarterinrecession, clwidth(thin) lcolor(black)) (line CurrentRS quarterinrecession, clwidth(medthick) lcolor(black)) ,legend(cols(3) order(1 3 5) lab(1 "Historical Range") lab(3 "Historical Mean") lab(5 "2007+") size(small)) name(saving);

graph export $figPath\saving.eps, replace;
graph export $figPath\saving.pdf, replace;
graph export $figPath\saving.png, replace;
clear;




* Net Worth Series;
********************************************************************;
use $dataPath\wealth_20111019.dta;
gen quarterinrecession=quarters-1;
gen zero=0;
replace maxrs=100*maxrs;
replace minrs=100*minrs;
replace meanrs=100*meanrs;
replace currentrs=100*currentrs;

graph twoway 
(area maxrs quarterinrecession , color(gs11) xlabel(0(2)20)) 
(area minrs quarterinrecession , color(gs11)) 
(line meanrs quarterinrecession, clwidth(medthin) lcolor(black) lpattern(dash) xtitle("Quarters after Start of Recession") ytitle("Deviation from Start-of-Recession Value")) 
(line zero quarterinrecession, clwidth(thin) lcolor(black)) (line currentrs quarterinrecession, clwidth(medthick) lcolor(black)) ,legend(cols(3) order(1 3 5) lab(1 "Historical Range") lab(3 "Historical Mean") lab(5 "2007+") size(small)) name(wealth);

graph export $figPath\extra\wealth.eps, replace;
graph export $figPath\extra\wealth.png, replace;
**********************************************************************************;
log close;	
