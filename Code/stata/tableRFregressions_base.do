**********************************************************************************
* OLS/IV Models of US Personal Saving Rate
**********************************************************************************

clear
#delimit;
set scheme s1mono;

gr drop _all; discard;
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

cd $logPath;

capture log close;
log using $logPath\tableRFregressions_base.log, replace;
set more off;

***********************************************************************************;
global startRegW  "1966q2";
global startRegW2ndHalf  "1980q1";
global endRegW  "2011q1";
global nwLags "4";				* Newey-West lags;
global dmmIndex "0";				* CCI index of Duca et al 2010;
global savingSeriesIndex "PSR";			* What measure of saving to use? "PSR" [default], "inflAdj" inflation-adjusted, "model" model-implied SR
						"grossHh", gross Hh S/DI, "netPrivate" net private S/GDP, "grossPrivate" gross private S/GDP
						"fofInclDur" FoF SR including durables, "fofExclDur" FoF SR excluding durables;
***********************************************************************************;

*use $dataPath\cssussavingdata_20120426.dta;
use $dataPath\cssussavingdata_20120628.dta;

gen t =  q(1960q1)+_n-1;
format t %tq;
tsset t;

gen imfIndex=imf_index;
gen wyRat = net_worth/disposy+1;	* Adding 1 because m is cash on hand after receiving income;
gen lagWyRat=L.wyRat;
replace wyRat = lagWyRat;		* wealth is measured at the end of the quarter;
gen dyRat = liabilities/disposy;
gen lydisp = log(ydisp);
gen dydisp = 400*D.lydisp;
gen dydisp_ann=100*(lydisp-L4.lydisp);

gen young=young_below16a;
gen old=old_above65a;
gen currAcc=400*curr_acc/gdp;
gen yield_10y_real=yield_10y-infl_exp_long;
gen realIR = yield_10y_real;
gen time=_n;

***********************************************************************************;

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

********* Saving rate series;
**** inflation-adjustment;
**HH interest-bearing net worth equals household total deposits + credit market assets + credit market assets 
held by private pension funds + credit market liabilities (measured at beginning of period);

gen HHintNW = depositshh + creditassethh - creditliabhh + creditmktpension;

**Use GDP deflator inflation;
gen ipdefgdp=gdpnom/gdp;
gen infl_gdpdefl = ipdefgdp/L.ipdefgdp - 1;

**HH net inflation compensation;
gen inflcomphh = infl_gdpdefl * L.HHintNW;

**HH inflation compensation adjusted income;
gen disposy_inflAdj = disposy - inflcomphh;

**Inflation adjusted personal saving rate;
gen saving_rate_inflAdj = 100*(netsav_hh-1000*inflcomphh)/(1000*disposy_inflAdj);
label var saving_rate_inflAdj "Inflation-Adjusted";
label var saving_rate_model "Explained by Struct Model";

gen saving_rate_bea=saving_rate; label var saving_rate_bea "PSR BEA";
gen saving_rate_net_hh=100*netsav_hh/(1000*disposy); 
gen saving_rate_gross_hh=100*(netsav_hh+cons_fixcap_hh)/(1000*disposy); label var saving_rate_gross_hh "Gross Hh SR/DI";
gen saving_rate_net_priv=100*(netsav_hh+netsav_corp)/(1000*gdpnom); label var saving_rate_net_priv "Net Private SR/GDP";
gen saving_rate_gross_priv=100*grosssav_priv/(1000*gdpnom); label var saving_rate_gross_priv "Gross Private SR/GDP";
gen saving_rate_fof_excl_dur=sr_fof_excl_dur; * FoF SR including/excluding consumer durables; label var saving_rate_fof_excl_dur "FoF Excl Durables";
gen saving_rate_fof_incl_dur=sr_fof_incl_dur; label var saving_rate_fof_incl_dur "FoF Incl Durables";

gen sr_struct_resid=saving_rate_bea-saving_rate_model;

replace saving_rate=saving_rate_bea;
if "$savingSeriesIndex"=="inflAdj" {;	replace saving_rate=saving_rate_inflAdj;   };
if "$savingSeriesIndex"=="model" {;	replace saving_rate=saving_rate_model;   };
if "$savingSeriesIndex"=="grossHh" {;	replace saving_rate=saving_rate_gross_hh;   };
if "$savingSeriesIndex"=="netPrivate" {;	replace saving_rate=saving_rate_net_priv;   };
if "$savingSeriesIndex"=="grossPrivate" {;	replace saving_rate=saving_rate_gross_priv;   };
if "$savingSeriesIndex"=="fofInclDur" {;	replace saving_rate=saving_rate_fof_incl_dur;   };
if "$savingSeriesIndex"=="fofExclDur" {;	replace saving_rate=saving_rate_fof_excl_dur;   };

/*
graph twoway 
(line saving_rate_bea t if tin($startRegW,$endRegW), name(fInflAdjSR) lcolor(black) xtitle("") ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_model t if tin($startRegW,$endRegW), lcolor(black) xtitle(blue) ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_inflAdj t if tin($startRegW,$endRegW), xtitle("") lcolor(red) ytitle("") xlabel(40(20)200,format(%tqCY)));
graph export $figPath\fInflAdjSR.eps, replace;
graph export $figPath\fInflAdjSR.png, replace;

graph twoway 
(line saving_rate_bea t if tin($startRegW,$endRegW), name(fPrivSR) lcolor(black) xtitle("") ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_gross_hh t if tin($startRegW,$endRegW), xtitle("") lcolor(red) ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_net_priv t if tin($startRegW,$endRegW), xtitle("") lcolor(green) ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_gross_priv t if tin($startRegW,$endRegW), xtitle("") lcolor(yellow) ytitle("") xlabel(40(20)200,format(%tqCY)));
graph export $figPath\fPrivSR.eps, replace;
graph export $figPath\fPrivSR.png, replace;

graph twoway 
(line saving_rate_bea t if tin($startRegW,$endRegW), name(fFoFSR) lcolor(black) xtitle("") ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_fof_incl_dur t if tin($startRegW,$endRegW), lcolor(black) xtitle(blue) ytitle("") xlabel(40(20)200,format(%tqCY)))
(line saving_rate_fof_excl_dur t if tin($startRegW,$endRegW), xtitle("") lcolor(red) ytitle("") xlabel(40(20)200,format(%tqCY)));
graph export $figPath\fFoFSR.eps, replace;
graph export $figPath\fFoFSR.png, replace;
*/;

* Preliminary SR regressions;
*************************************************************************************************************;
reg saving_rate L.saving_rate if tin($startRegW,$endRegW);

gen diffU=F4.unemployment-unemployment;
gen lagMichU=sentiment_u;
reg diffU lagMichU if tin($startRegW,$endRegW);
predict diffU_pred if tin($startRegW,$endRegW);
gen unemp_pred=unemployment+diffU_pred;

**** Model 1;
reg saving_rate wyRat time if tin($startRegW,$endRegW);
scalar m1r1 = e(r2_a);
estat dwatson;
scalar m1dw=r(dw);

newey saving_rate wyRat time if tin($startRegW,$endRegW), lag($nwLags);
scalar m1b0= _b[_cons];
scalar m1se0=_se[_cons];
scalar m1bm= _b[wyRat];
scalar m1sem=_se[wyRat];
scalar m1btime= _b[time];
scalar m1setime=_se[time];

test wyRat time;
scalar m1fpval=r(p);

predict sr_fit_m1 if tin($startRegW,$endRegW);


******************;

**** Model 2;
reg saving_rate CEA time if tin($startRegW,$endRegW);
scalar m2r1 = e(r2_a);
estat dwatson;
scalar m2dw=r(dw);

newey saving_rate CEA time if tin($startRegW,$endRegW), lag($nwLags);
scalar m2b0= _b[_cons];
scalar m2se0=_se[_cons];
scalar m2bCEA= _b[CEA];
scalar m2seCEA=_se[CEA];
scalar m2btime= _b[time];
scalar m2setime=_se[time];

test CEA time;
scalar m2fpval=r(p);

predict sr_fit_m2 if tin($startRegW,$endRegW);
******************;

**** Model 3;
reg saving_rate unemp_pred time if tin($startRegW,$endRegW);
scalar m3r1 = e(r2_a);
estat dwatson;
scalar m3dw=r(dw);

newey saving_rate unemp_pred time if tin($startRegW,$endRegW), lag($nwLags);
scalar m3b0= _b[_cons];
scalar m3se0=_se[_cons];
scalar m3bunpred= _b[unemp_pred];
scalar m3seunpred=_se[unemp_pred];
scalar m3btime= _b[time];
scalar m3setime=_se[time];

test unemp_pred time;
scalar m3fpval=r(p);

predict sr_fit_m3 if tin($startRegW,$endRegW);
******************;

**** Model 4;
reg saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW);
scalar m4r1 = e(r2_a);
estat dwatson;
scalar m4dw=r(dw);

newey saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW), lag($nwLags);
scalar m4b0= _b[_cons];
scalar m4se0=_se[_cons];
scalar m4bm= _b[wyRat];
scalar m4sem=_se[wyRat];
scalar m4bCEA= _b[CEA];
scalar m4seCEA=_se[CEA];
scalar m4bunpred= _b[unemp_pred];
scalar m4seunpred=_se[unemp_pred];

test wyRat CEA unemp_pred;
scalar m4fpval=r(p);

predict sr_fit_m4 if tin($startRegW,$endRegW);

******************;

**** Model 5;
gen post80dummy=0;
replace post80dummy=1 if tin($startRegW2ndHalf,$endRegW);
gen wyRatPost80=wyRat*post80dummy;
gen CEAPost80=CEA*post80dummy;
gen unemp_predPost80=unemp_pred*post80dummy;

reg saving_rate time if tin($startRegW,$endRegW);
scalar m5r1 = e(r2_a);
estat dwatson;
scalar m5dw=r(dw);

newey saving_rate time if tin($startRegW,$endRegW), lag($nwLags);
scalar m5b0= _b[_cons];
scalar m5se0=_se[_cons];
scalar m5btime= _b[time];
scalar m5setime=_se[time];

test time;
scalar m5fpval=r(p);

predict sr_fit_m5 if tin($startRegW,$endRegW);

**** Model 6;
reg saving_rate wyRat CEA unemp_pred time if tin($startRegW,$endRegW);
scalar m6r1 = e(r2_a);
estat dwatson;
scalar m6dw=r(dw);

newey saving_rate wyRat CEA unemp_pred time if tin($startRegW,$endRegW), lag($nwLags);
scalar m6b0= _b[_cons];
scalar m6se0=_se[_cons];
scalar m6bm= _b[wyRat];
scalar m6sem=_se[wyRat];
scalar m6bCEA= _b[CEA];
scalar m6seCEA=_se[CEA];
scalar m6bunpred= _b[unemp_pred];
scalar m6seunpred=_se[unemp_pred];
scalar m6btime= _b[time];
scalar m6setime=_se[time];

test wyRat CEA unemp_pred time;
scalar m6fpval=r(p);

predict sr_fit_m6 if tin($startRegW,$endRegW);

**** Model 7;
gen unCEA=unemp_pred*CEA;

reg saving_rate wyRat CEA unemp_pred time unCEA if tin($startRegW,$endRegW);
scalar m7r1 = e(r2_a);
estat dwatson;
scalar m7dw=r(dw);

newey saving_rate wyRat CEA unemp_pred time unCEA if tin($startRegW,$endRegW), lag($nwLags);
scalar m7b0= _b[_cons];
scalar m7se0=_se[_cons];
scalar m7bm= _b[wyRat];
scalar m7sem=_se[wyRat];
scalar m7bCEA= _b[CEA];
scalar m7seCEA=_se[CEA];
scalar m7bunpred= _b[unemp_pred];
scalar m7seunpred=_se[unemp_pred];
scalar m7bunCEA= _b[unCEA];
scalar m7seunCEA=_se[unCEA];
scalar m7btime= _b[time];
scalar m7setime=_se[time];

test wyRat CEA unemp_pred unCEA time;
scalar m7fpval=r(p);

predict sr_fit_m7 if tin($startRegW,$endRegW);

**** More models;
gen wCEA=wyRat*CEA;

newey saving_rate wyRat CEA unemp_pred time wCEA if tin($startRegW,$endRegW), lag($nwLags);

******************;

******** Data for decomposition table 07-09;
sum wyRat if tin(2007q1,2007q4);
sca wyRat07=r(mean);
sum wyRat if tin(2010q1,2010q4);
sca wyRat09=r(mean);
sca dwyRat=wyRat09-wyRat07;

sum CEA if tin(2007q1,2007q4);
sca CEA07=r(mean);
sum CEA if tin(2010q1,2010q4);
sca CEA09=r(mean);
sca dCEA=CEA09-CEA07;

sum unemp_pred if tin(2007q1,2007q4);
sca unemp_pred07=r(mean);
sum unemp_pred if tin(2010q1,2010q4);
sca unemp_pred09=r(mean);
sca dunemp_pred=unemp_pred09-unemp_pred07;

sum unCEA if tin(2007q1,2007q4);
sca unCEA07=r(mean);
sum unCEA if tin(2010q1,2010q4);
sca unCEA09=r(mean);
sca dunCEA=unCEA09-unCEA07;

sum saving_rate if tin(2007q1,2007q4);
sca saving_rate07=r(mean);
sum saving_rate if tin(2010q1,2010q4);
sca saving_rate09=r(mean);
sca dsaving_rate=saving_rate09-saving_rate07;

log close;

******************************************************************;
label var CEA "CEA";
label var dyRat "Debt-Income Ratio";
label var imfIndex "Abiad et al. Index of Financial Liberalization";

qui sum imfIndex if tin($startRegW,$endRegW);
local imfMax=`r(max)';
local imfMax=1.5;

graph twoway 
(scatteri `imfMax' `=q(1969q4)' `imfMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(1973q4)' `imfMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(1980q1)' `imfMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(1981q3)' `imfMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(1990q3)' `imfMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(2001q1)' `imfMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `imfMax' `=q(2007q4)' `imfMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line CEA t if tin($startRegW,$endRegW), name(creditConditions) xtitle("") ytitle("CEA/Debt-Income Ratio") lwidth(medthick) lcolor(red) yaxis(1) xlabel(40(20)200,format(%tqCY)))
(line dyRat t if tin($startRegW,$endRegW), xtitle("") ytitle("CEA/Debt-Income Ratio") lcolor(black) yaxis(1) xlabel(40(20)200,format(%tqCY)))
(line imfIndex t if tin($startRegW,$endRegW), xtitle("") lcolor(black) lpattern(dash) lwidth(medthick) yaxis(2) ytitle("Abiad et al. Index of Financial Liberalization", axis(2)) xlabel(40(20)200,format(%tqCY)));
graph export $figPath/fCreditAvailability_compare.eps, replace;
graph export $figPath/fCreditAvailability_compare.png, replace;

label var saving_rate "NIPA Saving Rate";
label var sr_fit_m1 "Fitted - Wealth only";
label var sr_fit_m2 "Baseline";
label var sr_fit_m3 "Fitted Values M3";
label var sr_fit_m4 "Baseline";
label var sr_fit_m5 "Time only";
label var sr_fit_m6 "Fitted Values M6";
label var sr_fit_m7 "Fitted Values M7";
label var saving_rate_model "Fitted - Structural";
label var sr_fit_m4 "Fitted - Reduced-Form";



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
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m4 t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m5 t if tin($startRegW,$endRegW), name(olsM4_fit) xtitle("") ytitle("") lcolor(black) lpattern(dash) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));
graph export $figPath/fOLS_fit_time_compare.eps, replace;
graph export $figPath/fOLS_fit_time_compare.eps, replace;

graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m4 t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m5 t if tin($startRegW,$endRegW), name(olsM4_fit_slides) xtitle("") ytitle("") lcolor(magenta) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));
graph export $figPath/fOLS_fit_time_compare_slides.eps, replace;
graph export $figPath/fOLS_fit_time_compare_slides.png, replace;


graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m4 t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line saving_rate_model t if tin($startRegW,$endRegW), legend(label(8 "Actual") label(9 "Reduced-Form") label(10 "Structural") order(8 9 10) rows(1)) name(olsM4_fit_redStruct) xtitle("") ytitle("") lcolor(magenta) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));
graph export $figPath/fOLS_fit_redStruct_compare.eps, replace;
graph export $figPath/fOLS_fit_redStruct_compare.png, replace;


graph twoway 
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m1 t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_m5 t if tin($startRegW,$endRegW), name(olsM5_fit) xtitle("") ytitle("") lcolor(black) lpattern(dash) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/olsM5_fit.eps, replace;
graph export $figPath/olsM5_fit.png, replace;

label var CEA "CEA";

graph twoway 
(line CEA t if tin($startRegW,$endRegW), name(ceaCCI) lcolor(black) xtitle("") ytitle("") xlabel(40(20)200,format(%tqCY)))
(line CCI t if tin($startRegW,$endRegW), xtitle("") lcolor(red) ytitle("") xlabel(40(20)200,format(%tqCY)));
*graph export ceaCCI.eps, replace;
*graph export ceaCCI.png, replace;

do writeOLStable_Base.do;
do writeOLStable_Base_slides.do;


*keep t saving_rate wyRat CEA unemp_pred;
*outsheet t saving_rate wyRat CEA unemp_pred using $dataPath/cssussavingdata_20110831.xls;

********* Normality of residuals from the structural model;
** hist sr_struct_resid, bin(20);
** kdensity sr_struct_resid;
swilk sr_struct_resid;


********* MZ regression;
reg saving_rate_bea saving_rate_model sr_fit_m6 if tin($startRegW,$endRegW);
newey saving_rate_bea saving_rate_model sr_fit_m6 if tin($startRegW,$endRegW), lag($nwLags);

constraint define 1 saving_rate_model + sr_fit_m6 = 1;
cnsreg saving_rate_bea saving_rate_model sr_fit_m6 if tin($startRegW,$endRegW), c(1);

********* Summary Stats: Model and Data;
corrgram saving_rate_bea if tin($startRegW,$endRegW), lags(12);
corrgram saving_rate_model if tin($startRegW,$endRegW), lags(12);

******** Data for decomposition table 07-09;
sum wyRat if tin(2007q1,2007q4);
sca wyRat07=r(mean);
sum wyRat if tin(2010q1,2010q4);
sca wyRat09=r(mean);
sca dwyRat=wyRat09-wyRat07;

sum CEA if tin(2007q1,2007q4);
sca CEA07=r(mean);
sum CEA if tin(2010q1,2010q4);
sca CEA09=r(mean);
sca dCEA=CEA09-CEA07;

sum unemp_pred if tin(2007q1,2007q4);
sca unemp_pred07=r(mean);
sum unemp_pred if tin(2010q1,2010q4);
sca unemp_pred09=r(mean);
sca dunemp_pred=unemp_pred09-unemp_pred07;

sum unCEA if tin(2007q1,2007q4);
sca unCEA07=r(mean);
sum unCEA if tin(2010q1,2010q4);
sca unCEA09=r(mean);
sca dunCEA=unCEA09-unCEA07;

sum saving_rate if tin(2007q1,2007q4);
sca saving_rate07=r(mean);
sum saving_rate if tin(2010q1,2010q4);
sca saving_rate09=r(mean);
sca dsaving_rate=saving_rate09-saving_rate07;

* Structural Model;
**** Model 4;
newey saving_rate_model wyRat CEA unemp_pred if tin($startRegW,$endRegW), lag($nwLags);
scalar m4b0_model= _b[_cons];
scalar m4bm_model= _b[wyRat];
scalar m4bCEA_model= _b[CEA];
scalar m4bunpred_model= _b[unemp_pred];

do writeTable_pred;
do writeTable_pred_structRF;










