**********************************************************************************
* OLS/IV Models of US Personal Saving Rate
**********************************************************************************

clear
#delimit;
set scheme s1mono;

gr drop _all; discard; set scheme s1mono;
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

cd $logPath;

capture log close;
log using $logPath\tableDispIncome.log, replace;
set more off;

***********************************************************************************;
global startRegW  "1966q2";
global startRegW2ndHalf  "1980q1";
global endRegW  "2011q1";
global nwLags  "4";
global dmmIndex "0";				* CCI index of Duca et al 2010;

***********************************************************************************;

use $dataPath\cssussavingdata_20120426.dta;

gen t =  q(1960q1)+_n-1;
format t %tq;
tsset t;

global nwLags "4";		* Newey-West lags;

gen imfIndex=imf_index;
gen wyRat = net_worth/disposy;
gen lagWyRat=L.wyRat;
replace wyRat = lagWyRat;	* wealth is measured at the end of the quarter;
gen dyRat = liabilities/disposy;
gen lydisp = log(ydisp);
gen dydisp = 400*D.lydisp;


gen young=young_below16a;
gen old=old_above65a;
gen currAcc=400*curr_acc/gdp;
gen yield_10y_real=yield_10y-infl_exp_long;
*gen realIR = yield_10y_real;
gen realIR = yield_1y-infl_exp_1y;

*gen private_saving_rate=;
gen saving_rate_calc=100*(income_nominal-pers_outlays)/income_nominal;
gen saving_rate_clean_simple=100*(income_nominal_clean_simple-pers_outlays)/income_nominal_clean_simple;
gen saving_rate_clean_compl=100*(income_nominal_clean_compl-pers_outlays)/income_nominal_clean_compl;
gen ydisp_deflator=income_nominal/ydisp;
gen lydisp_clean_simple=log(income_nominal_clean_simple/ydisp_deflator);
gen lydisp_clean_compl=log(income_nominal_clean_compl/ydisp_deflator);
gen dydisp_clean_simple=400*D.lydisp_clean_simple;
gen dydisp_clean_compl=400*D.lydisp_clean_compl;
*replace saving_rate=saving_rate_clean_compl;

gen saving_rate_fof=sr_fof_incl_dur; * gen saving_rate_fof=sr_fof_excl_dur; * FoF SR including/excluding consumer durables;

replace willingness_to_lend=0 if tin(1966q2,1966q2);
gen       CEA=willingness_to_lend; /* Loan Officer Survey measure of banks' willingness to lend to consumers */
gen CEA_mue=CEA; * closer to the Muellbauer version;

/* Accumulate values of FWILL to produce CEA - Credit Easing Accumulated */
global nobs=_N;
forvalues i = 27(1)$nobs {; 
	sca CEA_soFar=CEA[`i'-1]+willingness_to_lend[`i']*dyRat[`i']; /* CDC: modified Muellbauer's method to multiply by dOy, in order to provide sensible scaling given rising dOy */
	qui replace CEA=CEA_soFar in `i';

	sca CEA_soFar_mue=CEA_mue[`i'-1]+willingness_to_lend[`i']; /* original Muellbauer measure */
	qui replace CEA_mue=CEA_soFar_mue in `i';
};

sum CEA if tin($startRegW,$endRegW);
sca CEA_min=r(min);
sca CEA_max=r(max);
replace CEA=(CEA-CEA_min)/(CEA_max-CEA_min);

sum CEA_mue if tin($startRegW,$endRegW);
sca CEA_mue_min=r(min);
sca CEA_mue_max=r(max);
replace CEA_mue=(CEA_mue-CEA_mue_min)/(CEA_mue_max-CEA_mue_min);

label   var CEA "Credit Availability";
gen CCI=CEA_mue;

if $dmmIndex==1 {;	* Duca et al CCI index;
		replace CCI=cci_dmm;
	};
gen wyRatCCI=wyRat*CCI;

*replace CEA=dyRat;


label var saving_rate "PSR";
label var saving_rate_calc "PSR Calculated";
label var saving_rate_clean_simple "PSR Less Cleaned";
label var saving_rate_clean_compl "PSR More Cleaned";

label var dydisp "Official Series";
label var dydisp_clean_simple "PSR Less Cleaned";
label var dydisp_clean_compl "PSR More Cleaned";

***********************************************************************************;

qui sum dydisp if tin($startRegW,$endRegW);
local dyMax=`r(max)';

qui sum dydisp_clean_simple if tin($startRegW,$endRegW);
local dyMin=`r(min)';

graph twoway 
(scatteri `dyMax' `=q(1969q4)' `dyMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(1973q4)' `dyMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(1980q1)' `dyMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(1981q3)' `dyMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(1990q3)' `dyMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(2001q1)' `dyMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMax' `=q(2007q4)' `dyMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(1969q4)' `dyMin' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(1973q4)' `dyMin' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(1980q1)' `dyMin' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(1981q3)' `dyMin' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(1990q3)' `dyMin' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(2001q1)' `dyMin' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `dyMin' `=q(2007q4)' `dyMin' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line dydisp t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line dydisp_clean_simple t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line dydisp_clean_compl t if tin($startRegW,$endRegW), name(fDispIncG) xtitle("") ytitle("") lcolor(black) lpattern(dash) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fDispIncG.eps, replace;
graph export $figPath/fDispIncG.png, replace;

qui sum saving_rate if tin($startRegW,$endRegW);
local srMax=`r(max)';

graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line saving_rate_clean_simple t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line saving_rate_clean_compl t if tin($startRegW,$endRegW), name(fPSRcompare) xtitle("") ytitle("") lcolor(black) lpattern(dash) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fPSRcompare.eps, replace;
graph export $figPath/fPSRcompare.png, replace;

***********************************************************************************;
local allVarNames "lydisp lydisp_clean_simple lydisp_clean_compl dydisp dydisp_clean_simple dydisp_clean_compl saving_rate saving_rate_clean_simple saving_rate_clean_compl";	* list of variables; 

foreach varName of local allVarNames {;

	corrgram_J `varName' if tin($startRegW,$endRegW), lags(10);
	sca rho1_`varName' = r(ac1);
	sca probQ_`varName' = r(probq8);
	dfuller `varName' if tin($startRegW,$endRegW), lags(4);
	sca probADF_`varName' = r(p);
	dfgls `varName' if tin($startRegW,$endRegW), maxlag(12);

};

dfuller lydisp if tin($startRegW,$endRegW), lags(4) trend;
sca probADF_lydisp = r(p);
dfuller lydisp_clean_simple if tin($startRegW,$endRegW), lags(4) trend;
sca probADF_lydisp_clean_simple = r(p);
dfuller lydisp_clean_compl if tin($startRegW,$endRegW), lags(4) trend;
sca probADF_lydisp_clean_compl = r(p);
***********************************************************************************;
gen dydisp_official=dydisp;
gen saving_rate_official=saving_rate;
local allVarNames "official clean_simple clean_compl";	* list of variables; 

foreach varName of local allVarNames {;

	newey saving_rate_`varName' F1.dydisp_`varName' if tin($startRegW,$endRegW), lag(4);
	scalar by_F1_full_`varName'= _b[F1.dydisp_`varName'];
	scalar sey_F1_full_`varName'= _se[F1.dydisp_`varName'];
	reg saving_rate_`varName' F1.dydisp_`varName' if tin($startRegW,$endRegW);
	scalar r2adj_F1_full_`varName'=e(r2_a);

	newey saving_rate_`varName' F2.dydisp_`varName' if tin($startRegW,$endRegW), lag(4);
	scalar by_F2_full_`varName'= _b[F2.dydisp_`varName'];
	scalar sey_F2_full_`varName'= _se[F2.dydisp_`varName'];
	reg saving_rate_`varName' F2.dydisp_`varName' if tin($startRegW,$endRegW);
	scalar r2adj_F2_full_`varName'=e(r2_a);

	newey saving_rate_`varName' F1.dydisp_`varName' if tin($startRegW,1984q4), lag(4);
	scalar by_F1_camp_`varName'= _b[F1.dydisp_`varName'];
	scalar sey_F1_camp_`varName'= _se[F1.dydisp_`varName'];
	reg saving_rate_`varName' F1.dydisp_`varName' if tin($startRegW,1984q4);
	scalar r2adj_F1_camp_`varName'=e(r2_a);

	newey saving_rate_`varName' F2.dydisp_`varName' if tin($startRegW,1984q4), lag(4);
	scalar by_F2_camp_`varName'= _b[F2.dydisp_`varName'];
	scalar sey_F2_camp_`varName'= _se[F2.dydisp_`varName'];
	reg saving_rate_`varName' F2.dydisp_`varName' if tin($startRegW,1984q4);
	scalar r2adj_F2_camp_`varName'=e(r2_a);
};

***********************************************************************************;
do writeUnivarYPSRtable01.do;
do writeCampbell87table.do;

log close;


