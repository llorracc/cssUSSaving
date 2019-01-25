**********************************************************************************
* OLS/IV Models of US Personal Saving Rate
**********************************************************************************

clear
#delimit;

gr drop _all; discard;
set scheme s1mono;

global eolString "_char(92) _char(92)";		 
*string denoting new line in LaTeX tables \\;

*cd $logPath;

*capture log close;
*log using $logPath\tableRFregressions_rob.log, replace;
set more off;

***********************************************************************************;
global startRegW  "1966q2";
global startRegW2ndHalf  "1980q1";
global endRegW  "2011q1";
global nwLags  "4";
global dmmIndex "0";				* CCI index of Duca et al 2010;
global savingSeriesIndex "PSR";			* What measure of saving to use? "PSR" [default], "inflAdj" inflation-adjusted, "model" model-implied SR
						"grossHh", gross Hh S/DI, "netPrivate" net private S/GDP, "grossPrivate" gross private S/GDP
						"fofInclDur" FoF SR including durables, "fofExclDur" FoF SR excluding durables;

***********************************************************************************;

use $dataPath\cssussavingdata_20120426.dta;

gen t =  q(1960q1)+_n-1;
format t %tq;
tsset t;

global nwLags "4";		* Newey-West lags;

gen imfIndex=imf_index;
gen wyRat = net_worth/disposy+1;	* Adding 1 because m is cash on hand after receiving income;
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

corrgram dydisp if tin($startRegW,$endRegW), lags(10);
corrgram dydisp_clean_simple if tin($startRegW,$endRegW), lags(10);
corrgram dydisp_clean_compl if tin($startRegW,$endRegW), lags(10);

dfuller lydisp if tin($startRegW,$endRegW), lags(4) trend;
dfuller lydisp_clean_simple if tin($startRegW,$endRegW), lags(4) trend;
dfuller lydisp_clean_compl if tin($startRegW,$endRegW), lags(4) trend;

dfgls lydisp if tin($startRegW,$endRegW), maxlag(12);
dfgls lydisp_clean_simple if tin($startRegW,$endRegW), maxlag(12);
dfgls lydisp_clean_compl if tin($startRegW,$endRegW), maxlag(12);

label var saving_rate "PSR";
label var saving_rate_calc "PSR Calculated";
label var saving_rate_clean_simple "PSR Less Cleaned";
label var saving_rate_clean_compl "PSR More Cleaned";

graph twoway 
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red)  xlabel(40(20)200,format(%tqCY)))
(line saving_rate_clean_simple t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(magenta)  xlabel(40(20)200,format(%tqCY)))
(line saving_rate_clean_compl t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(purple)  xlabel(40(20)200,format(%tqCY)))
;
*graph export psrCompare.eps, replace;
*graph export psrCompare.png, replace;

*replace saving_rate=saving_rate_clean_compl;


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

* Preliminary SR regressions;
*************************************************************************************************************;
reg saving_rate L.saving_rate if tin($startRegW,$endRegW);

gen diffU=F4.unemployment-unemployment;
gen lagMichU=sentiment_u;
reg diffU lagMichU if tin($startRegW,$endRegW);
predict diffU_pred if tin($startRegW,$endRegW);
gen unemp_pred=unemployment+diffU_pred;

**** Baseline;
reg saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW);
scalar r1_base = e(r2_a);
estat dwatson;
scalar dw_base=r(dw);

newey saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_base= _b[_cons];
scalar se0_base=_se[_cons];
scalar bm_base= _b[wyRat];
scalar sem_base=_se[wyRat];
scalar bCEA_base= _b[CEA];
scalar seCEA_base=_se[CEA];
scalar bunpred_base= _b[unemp_pred];
scalar seunpred_base=_se[unemp_pred];

test wyRat CEA unemp_pred;
scalar fpval_base=r(p);

predict sr_fit_base if tin($startRegW,$endRegW);

******************;

**** Model Uncertainty;
reg saving_rate wyRat CEA unemp_pred uncertainty if tin($startRegW,$endRegW);
scalar r1_unc = e(r2_a);
estat dwatson;
scalar dw_unc =r(dw);

newey saving_rate wyRat CEA unemp_pred uncertainty if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_unc= _b[_cons];
scalar se0_unc=_se[_cons];
scalar bm_unc= _b[wyRat];
scalar sem_unc=_se[wyRat];
scalar bCEA_unc= _b[CEA];
scalar seCEA_unc=_se[CEA];
scalar bunpred_unc= _b[unemp_pred];
scalar seunpred_unc=_se[unemp_pred];
scalar bunc_unc= _b[uncertainty];
scalar seunc_unc=_se[uncertainty];

test wyRat CEA unemp_pred uncertainty;
scalar fpval_unc=r(p);

predict sr_fit_unc if tin($startRegW,$endRegW);
******************;

**** Model Lagged Saving;
reg saving_rate L.saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW);
scalar r1_lagsr = e(r2_a);
estat dwatson;
scalar dw_lagsr=r(dw);

newey saving_rate L.saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_lagsr= _b[_cons];
scalar se0_lagsr=_se[_cons];
scalar bm_lagsr= _b[wyRat];
scalar sem_lagsr=_se[wyRat];
scalar bCEA_lagsr= _b[CEA];
scalar seCEA_lagsr=_se[CEA];
scalar bs_lagsr= _b[L.saving_rate];
scalar ses_lagsr =_se[L.saving_rate];
scalar bunpred_lagsr= _b[unemp_pred];
scalar seunpred_lagsr=_se[unemp_pred];

test L.saving_rate wyRat CEA unemp_pred;
scalar fpval_lagsr=r(p);

predict sr_fit_lagsr if tin($startRegW,$endRegW);
******************;

**** Model -- Debt-Income ratio;
reg saving_rate wyRat CEA unemp_pred dyRat if tin($startRegW,$endRegW);
scalar r1_debt = e(r2_a);
estat dwatson;
scalar dw_debt=r(dw);

newey saving_rate wyRat CEA unemp_pred dyRat if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_debt= _b[_cons];
scalar se0_debt=_se[_cons];
scalar bm_debt= _b[wyRat];
scalar sem_debt=_se[wyRat];
scalar bCEA_debt= _b[CEA];
scalar seCEA_debt=_se[CEA];
scalar bl_debt= _b[dyRat];
scalar sel_debt =_se[dyRat];
scalar bunpred_debt= _b[unemp_pred];
scalar seunpred_debt=_se[unemp_pred];

test wyRat CEA unemp_pred dyRat;
scalar fpval_debt=r(p);

predict sr_fit_debt if tin($startRegW,$endRegW);
******************;

**** Model -- Income Inequality -- Income share of top 5 percent incl capital income;
rename top5incl inc_top5;
reg saving_rate wyRat CEA unemp_pred inc_top5 if tin($startRegW,$endRegW);
scalar r1_top5 = e(r2_a);
estat dwatson;
scalar dw_top5=r(dw);

newey saving_rate wyRat CEA unemp_pred inc_top5 if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_top5= _b[_cons];
scalar se0_top5=_se[_cons];
scalar bm_top5= _b[wyRat];
scalar sem_top5=_se[wyRat];
scalar bCEA_top5= _b[CEA];
scalar seCEA_top5=_se[CEA];
scalar bl_top5= _b[inc_top5];
scalar sel_top5 =_se[inc_top5];
scalar bunpred_top5= _b[unemp_pred];
scalar seunpred_top5=_se[unemp_pred];

test wyRat CEA unemp_pred inc_top5;
scalar fpval_top5=r(p);

predict sr_fit_top5 if tin($startRegW,$endRegW);
******************;


**** Model -- Defined-benefit pension gap;
reg saving_rate wyRat CEA unemp_pred db_diff if tin($startRegW,$endRegW);
scalar r1_db = e(r2_a);
estat dwatson;
scalar dw_db=r(dw);

newey saving_rate wyRat CEA unemp_pred db_diff if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_db= _b[_cons];
scalar se0_db=_se[_cons];
scalar bm_db= _b[wyRat];
scalar sem_db=_se[wyRat];
scalar bCEA_db= _b[CEA];
scalar seCEA_db=_se[CEA];
scalar bl_db= _b[ db_diff];
scalar sel_db =_se[db_diff];
scalar bunpred_db= _b[unemp_pred];
scalar seunpred_db=_se[unemp_pred];

test wyRat CEA unemp_pred  db_diff;
scalar fpval_db=r(p);

predict sr_fit_db if tin($startRegW,$endRegW);
******************;

**** Model -- High Tax Bracket;
reg saving_rate wyRat CEA unemp_pred high_bracket if tin($startRegW,$endRegW);
scalar r1_hi = e(r2_a);
estat dwatson;
scalar dw_hi=r(dw);

newey saving_rate wyRat CEA unemp_pred high_bracket if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_hi= _b[_cons];
scalar se0_hi=_se[_cons];
scalar bm_hi= _b[wyRat];
scalar sem_hi=_se[wyRat];
scalar bCEA_hi= _b[CEA];
scalar seCEA_hi=_se[CEA];
scalar bl_hi= _b[high_bracket];
scalar sel_hi =_se[high_bracket];
scalar bunpred_hi= _b[unemp_pred];
scalar seunpred_hi=_se[unemp_pred];

test wyRat CEA unemp_pred high_bracket;
scalar fpval_hi=r(p);

predict sr_fit_hi if tin($startRegW,$endRegW);
******************;

**** Model -- Low Tax Bracket;
reg saving_rate wyRat CEA unemp_pred low_bracket if tin($startRegW,$endRegW);
scalar r1_lo = e(r2_a);
estat dwatson;
scalar dw_lo=r(dw);

newey saving_rate wyRat CEA unemp_pred low_bracket if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_lo= _b[_cons];
scalar se0_lo=_se[_cons];
scalar bm_lo= _b[wyRat];
scalar sem_lo=_se[wyRat];
scalar bCEA_lo= _b[CEA];
scalar seCEA_lo=_se[CEA];
scalar bl_lo= _b[low_bracket];
scalar sel_lo =_se[low_bracket];
scalar bunpred_lo= _b[unemp_pred];
scalar seunpred_lo=_se[unemp_pred];

test wyRat CEA unemp_pred low_bracket;
scalar fpval_lo=r(p);

predict sr_fit_lo if tin($startRegW,$endRegW);
******************;

**** Model Full Controls;
reg saving_rate wyRat CEA unemp_pred realIR gov_sr_gdp corp_sr_gdp if tin($startRegW,$endRegW);
scalar r1_full = e(r2_a);
estat dwatson;
scalar dw_full=r(dw);

newey saving_rate wyRat CEA unemp_pred realIR gov_sr_gdp corp_sr_gdp if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_full= _b[_cons];
scalar se0_full=_se[_cons];
scalar bm_full= _b[wyRat];
scalar sem_full=_se[wyRat];
scalar bCEA_full= _b[CEA];
scalar seCEA_full=_se[CEA];
scalar bunpred_full= _b[unemp_pred];
scalar seunpred_full=_se[unemp_pred];
scalar bgs_full= _b[gov_sr_gdp];
scalar segs_full=_se[gov_sr_gdp];
scalar bir_full= _b[realIR];
scalar seir_full=_se[realIR];
scalar bcs_full= _b[corp_sr_gdp];
scalar secs_full=_se[corp_sr_gdp];
*scalar bold_full= _b[old];
*scalar seold_full=_se[old];

test wyRat CEA unemp_pred realIR gov_sr_gdp corp_sr_gdp;
scalar fpval_full=r(p);

predict sr_fit_full if tin($startRegW,$endRegW);

******************;

**** Model Post-80;
gen post80dummy=0;
replace post80dummy=1 if tin($startRegW2ndHalf,$endRegW);
gen wyRatPost80=wyRat*post80dummy;
gen CEAPost80=CEA*post80dummy;
gen unemp_predPost80=unemp_pred*post80dummy;

reg saving_rate wyRat CEA unemp_pred post80dummy wyRatPost80 CEAPost80 unemp_predPost80 if tin($startReg,$endRegW);
scalar r1_post80 = e(r2_a);
estat dwatson;
scalar dw_post80=r(dw);

newey saving_rate wyRat CEA unemp_pred post80dummy wyRatPost80 CEAPost80 unemp_predPost80 if tin($startRegW,$endRegW), lag($nwLags);
scalar b0_post80= _b[_cons];
scalar se0_post80=_se[_cons];
scalar bm_post80= _b[wyRat];
scalar sem_post80=_se[wyRat];
scalar bCEA_post80= _b[CEA];
scalar seCEA_post80=_se[CEA];
scalar bunpred_post80= _b[unemp_pred];
scalar seunpred_post80=_se[unemp_pred];

scalar b0post80_post80= _b[post80dummy];
scalar se0post80_post80=_se[post80dummy];
scalar bmpost80_post80= _b[wyRatPost80];
scalar sempost80_post80=_se[wyRatPost80];
scalar bCEApost80_post80= _b[CEAPost80];
scalar seCEApost80_post80=_se[CEAPost80];
scalar bunpredpost80_post80= _b[unemp_predPost80];
scalar seunpredpost80_post80=_se[unemp_predPost80];

test wyRat CEA unemp_pred post80dummy wyRatPost80 CEAPost80 unemp_predPost80;
scalar fpval_post80=r(p);
test post80dummy wyRatPost80 CEAPost80 unemp_predPost80;
scalar fpvalPost80_post80=r(p);


predict sr_fit_post80 if tin($startRegW2ndHalf,$endRegW);
******************;

reg saving_rate wyRat CEA unemp_pred wyRatPost80 CEAPost80 unemp_predPost80 if tin($startRegW,$endRegW);

test wyRatPost80 CEAPost80 unemp_predPost80;

newey saving_rate wyRat CEA unemp_pred wyRatPost80 CEAPost80 unemp_predPost80 if tin($startRegW,$endRegW), lag($nwLags);

test wyRatPost80 CEAPost80 unemp_predPost80;



**** Model -- Pre-2008;
gen post07dummy=0;
replace post07dummy=1 if tin(2008q1,$endRegW);
gen wyRatPost07=wyRat*post07dummy;
gen CEAPost07=CEA*post07dummy;
gen unemp_predPost07=unemp_pred*post07dummy;

reg saving_rate wyRat CEA unemp_pred post07dummy wyRatPost07 CEAPost07 unemp_predPost07 if tin($startReg,$endRegW);
scalar r1_pre08 = e(r2_a);
estat dwatson;
scalar dw_pre08=r(dw);

newey saving_rate wyRat CEA unemp_pred post07dummy wyRatPost07 CEAPost07 unemp_predPost07 if tin($startRegW,$endRegW), lag(0);  * Note it doesn't make sense to use 4 lags here because the post-07 standard error would go crazy due to the small sample;
scalar b0_pre08= _b[_cons];
scalar se0_pre08=_se[_cons];
scalar bm_pre08= _b[wyRat];
scalar sem_pre08=_se[wyRat];
scalar bCEA_pre08= _b[CEA];
scalar seCEA_pre08=_se[CEA];
scalar bunpred_pre08= _b[unemp_pred];
scalar seunpred_pre08=_se[unemp_pred];

scalar b0post07_pre08= _b[post07dummy];
scalar se0post07_pre08=_se[post07dummy];
scalar bmpost07_pre08= _b[wyRatPost07];
scalar sempost07_pre08=_se[wyRatPost07];
scalar bCEApost07_pre08= _b[CEAPost07];
scalar seCEApost07_pre08=_se[CEAPost07];
scalar bunpredpost07_pre08= _b[unemp_predPost07];
scalar seunpredpost07_pre08=_se[unemp_predPost07];

test wyRat CEA unemp_pred post07dummy wyRatPost07 CEAPost07 unemp_predPost07;
scalar fpval_pre08=r(p);
test post07dummy wyRatPost07 CEAPost07 unemp_predPost07;
scalar fpvalPost07_pre08=r(p);

predict sr_fit_pre08 if tin($startRegW2ndHalf,$endRegW);


**** Model 8 --  IV;  
global ivset1 "L(1/2).wyRat L(1/2).imfIndex L(1/2).unemp_pred"; 

reg saving_rate $ivset1 if tin($startRegW,$endRegW);
scalar r1_iv = e(r2_a);

ivreg2 saving_rate (wyRat CEA unemp_pred = $ivset1) if tin($startRegW,$endRegW), robust bw($nwLags) ffirst;	
scalar b0_iv= _b[_cons];
scalar se0_iv=_se[_cons];
scalar bm_iv= _b[wyRat];
scalar sem_iv=_se[wyRat];
scalar bCEA_iv= _b[CEA];
scalar seCEA_iv=_se[CEA];
scalar bunpred_iv= _b[unemp_pred];
scalar seunpred_iv=_se[unemp_pred];
matrix efirst_iv = e(first);
scalar p1_iv = efirst_iv[6,1];
scalar f1_iv = efirst_iv[3,1];
scalar p2_iv = e(jp);
scalar n_iv = e(N);

test wyRat CEA unemp_pred;
scalar fpval_iv=r(p);


******************;
*log close;

do writeOLStable_Rob_02.do;
do writeOLStable_RobPart2.do;
*do writeOLStable_Rob_slides.do;
*do writeOLStable02_slides.do;


label var saving_rate "NIPA Saving Rate";
label var sr_fit_full "Fitted - Full Sample";
*label var sr_fit_m2 "Fitted Values M2";
*label var sr_fit_m4 "Fitted Values M4";
label var sr_fit_post80 "Fitted - Post-1980";

set scheme s1color;


qui sum saving_rate if tin($startRegW,$endRegW);
local srMax=`r(max)';

******;

graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_base t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_full t if tin($startRegW,$endRegW), name(fFullControls) xtitle("") ytitle("") lcolor(black) lpattern(dash) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fFullControls.eps, replace;
graph export $figPath/fFullControls.png, replace;

******;

graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_base t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_full t if tin($startRegW,$endRegW), name(fFullControls_slides) xtitle("") ytitle("") lcolor(magenta) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fFullControls_slides.eps, replace;
graph export $figPath/fFullControls_slides.png, replace;

******;

graph twoway 
(scatteri `srMax' `=q(1969q4)' `srMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1973q4)' `srMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1980q1)' `srMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1981q3)' `srMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(1990q3)' `srMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2001q1)' `srMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `srMax' `=q(2007q4)' `srMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line saving_rate t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)))
(line sr_fit_base t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line sr_fit_post80 t if tin($startRegW,$endRegW), name(fPost80) xtitle("") ytitle("") lcolor(magenta) lwidth(medthick) xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fPost80_slides.eps, replace;
graph export $figPath/fPost80_slides.png, replace;


******;
label var unemp_pred "Unemployment risk (mho)";
label var unemployment "Unemployment rate (actual)";

qui sum unemp_pred if tin($startRegW,$endRegW);
local uMax=`r(max)';
graph twoway 
(scatteri `uMax' `=q(1969q4)' `uMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(1973q4)' `uMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(1980q1)' `uMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(1981q3)' `uMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(1990q3)' `uMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(2001q1)' `uMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `uMax' `=q(2007q4)' `uMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line unemp_pred t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(red) lwidth(medthick) xlabel(40(20)200,format(%tqCY)))
(line unemployment t if tin($startRegW,$endRegW), name(mhoUnem) xtitle("") ytitle("") lcolor(black)   xlabel(40(20)200,format(%tqCY)))
;

graph export $figPath/mhoUnem.eps, replace;
graph export $figPath/mhoUnem.png, replace;

******;
graph twoway 
(scatteri 1e0 `=q(1969q4)' 1e0 `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(1973q4)' 1e0 `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(1980q1)' 1e0 `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(1981q3)' 1e0 `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(1990q3)' 1e0 `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(2001q1)' 1e0 `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri 1e0 `=q(2007q4)' 1e0 `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line CEA t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fCEA.eps, replace;
graph export $figPath/fCEA.png, replace;

******;
gen wyRatMinusOne = wyRat-1;
qui sum wyRatMinusOne if tin($startRegW,$endRegW);
local wyRatMax=`r(max)';
local wyRatMax=6.5;
graph twoway 
(scatteri `wyRatMax' `=q(1969q4)' `wyRatMax' `=q(1970q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(1973q4)' `wyRatMax' `=q(1975q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(1980q1)' `wyRatMax' `=q(1980q3)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(1981q3)' `wyRatMax' `=q(1982q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(1990q3)' `wyRatMax' `=q(1991q1)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(2001q1)' `wyRatMax' `=q(2001q4)', bcolor(gs11) recast(area) legend(off))
(scatteri `wyRatMax' `=q(2007q4)' `wyRatMax' `=q(2009q2)', bcolor(gs11) recast(area) legend(off))
(line wyRatMinusOne t if tin($startRegW,$endRegW), xtitle("") ytitle("") lcolor(black)  xlabel(40(20)200,format(%tqCY)));

graph export $figPath/fwyRat.eps, replace;
graph export $figPath/fwyRat.png, replace;

****** Export data in CSV (to make replications of our results easier);
outsheet using $dataPath\cssussavingdata_afterRegressions.csv, comma replace;



