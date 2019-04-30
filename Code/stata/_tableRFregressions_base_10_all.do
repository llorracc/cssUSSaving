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
log using $logPath\tableRFregressions_base3.log, replace;
set more off;

***********************************************************************************;
global startRegW  "1966q2";
global startRegW2ndHalf  "1980q1";
global endRegW  "2011q4";  *"2017q4";
global nwLags "4";				* Newey-West lags;
global dmmIndex "0";				* CCI index of Duca et al 2010;
global ceaIndex "3";				* [1] 1 CEA_comp, 2 CEA_comp_unw, 3 CEA_base, 4 CEA_mue;
global psroldIndex "0";				* [0] 1 use outdated PSR series (available until 2011Q1;
global savingSeriesIndex "PSR";			* "PSR" What measure of saving to use? "PSR" [default], "inflAdj" inflation-adjusted, "model" model-implied SR
						"grossHh", gross Hh S/DI, "netPrivate" net private S/GDP, "grossPrivate" gross private S/GDP
						"fofInclDur" FoF SR including durables, "fofExclDur" FoF SR excluding durables;
***********************************************************************************;

//*use $dataPath\cssussavingdata_20120628.dta;
*import excel using "P:\ECB business areas\DGR\Databases and Programme files\MPR\D - Other projects\Slacalek -- cssUSsaving\code\data\cssUSsavingData_20160726_selection_new.xlsx", firstrow sheet(Clean);
import excel using $dataPath\20190124_cssUSsavingData_selection.xlsx, firstrow sheet(Clean);


gen mortgages = mortgages_liab;
gen installment = installment_liab;
gen ccards = credit_card_liab;
gen dyRat_m=mortgages/dispy;
gen dyRat_i=installment/dispy;
gen dyRat_c=ccards/dispy;
gen dyRat_l=liabilities/dispy;

* In the latest Excel data file these variables have the opposite sign in Haver;
replace will_mortgages=-will_mortgages;
replace will_ccard=-will_ccard;

replace mortgages_liab=0 if will_mortgages==.;
replace installment_liab=0 if will_install==.;
replace credit_card_liab=0 if will_ccard==.;

replace will_mortgages=0 if will_mortgages==.;
replace will_install=0 if will_install==.;
replace will_ccard=0 if will_ccard==.;
replace credit_card_liab=0 if credit_card_liab==.;


drop AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU;

gen t =  q(1960q1)+_n-1;
format t %tq;
tsset t;


* post-2012 dummy;
gen post2012=0;
replace post2012=1 if tin(2013q1,2018q4); 
gen dummy2012=0;
replace dummy2012=1 if tin(2012q1,2012q4); 

gen weight_install=1;
gen weight_ccard=0;
gen weight_mortg=0;

replace weight_install=0.5 if tin(1990q3,1995q4);
replace weight_mortg=0.5 if tin(1990q3,1995q4);

replace weight_install=1/3 if tin(1996q1,2016q4);
replace weight_ccard=1/3  if tin(1996q1,2016q4);
replace weight_mortg=1/3  if tin(1996q1,2016q4);

gen wyRat = net_worth/dispy+1;	* Adding 1 because m is cash on hand after receiving income;
gen lagWyRat=L.wyRat;
replace wyRat = lagWyRat;		* wealth is measured at the end of the quarter;
gen dyRat = liabilities/dispy;

*replace credit_card_liab=0;
*replace mortgages_liab=0;

gen dispy2=dispy;
*replace dispy2 =3*dispy2 if tin(2008Q1, 2017Q1);
gen dyRat_mortg=mortgages_liab/dispy*liabilities/(mortgages_liab+installment_liab+credit_card_liab);
gen dyRat_install=installment_liab/dispy*liabilities/(mortgages_liab+installment_liab+credit_card_liab);
gen dyRat_ccard=credit_card_liab/dispy*liabilities/(mortgages_liab+installment_liab+credit_card_liab);

gen dyRat_mortg_0 = mortgages_liab/dispy;

gen sumdy=dyRat_mortg+dyRat_install+dyRat_ccard;
gen diffdy=dyRat-sumdy;

gen time=_n;

* Adjust PSR 2012Q1-2013Q4 observations (smooth temporary spikes);
replace psr = 7.2 if tin(2012q1,2013q4);

tsfilter hp psr_hp_cycl = psr, trend(psr_hp);
replace psr_hp = -psr_hp;

gen recessionI = 0;
replace recessionI = 1 if tin(1969q4,1970q4);
replace recessionI = 1 if tin(1973q4,1975q1);
replace recessionI = 1 if tin(1969q4,1970q4);
replace recessionI = 1 if tin(1980q1,1980q3);
replace recessionI = 1 if tin(1981q3,1982q4);
replace recessionI = 1 if tin(1990q3,1991q1);
replace recessionI = 1 if tin(2001q1,2001q4);
replace recessionI = 1 if tin(2007q4,2009q2);

***********************************************************************************;

replace willingness_to_lend=0 if tin(1966q2,1966q2);
gen CEA_base=willingness_to_lend; /* Loan Officer Survey measure of banks' willingness to lend to consumers */
gen CEA_mue=CEA_base; * closer to the Muellbauer version;
gen CEA_comp=CEA_base; * PREFERRED -- CEA index for the 3 components, weighted by debt ratios;
gen CEA_comp_unw=CEA_base; * unweighted CEA index for the 3 components, weighted by debt ratios;
gen CEA_mort=CEA_base;
gen CEA_install=CEA_base;
gen CEA_ccard=CEA_base;
gen CEA_mortFlows=CEA_base;
gen CEA_flowsAdj=CEA_flows;
gen CEA_comp_GSE=CEA_flows;



/* Accumulate values of FWILL to produce CEA - Credit Easing Accumulated */
global nobs=_N;
forvalues i = 27(1)$nobs {; 
	sca CEA_soFar_comp=CEA_comp[`i'-1]+will_mortgages[`i']*dyRat_mortg[`i']+will_install[`i']*dyRat_install[`i']+will_ccard[`i']*dyRat_ccard[`i']; /* debt-weighted CEA, 3 components */
	qui replace CEA_comp=CEA_soFar_comp in `i';
	
	*sca CEA_comp_unw_soFar=CEA_comp_unw[`i'-1]+will_mortgages[`i']+will_install[`i']+will_ccard[`i']; /* unweighted CEA, 3 components */
	*qui replace CEA_comp_unw=CEA_comp_unw_soFar in `i';
	
	sca CEA_comp_unw_soFar=CEA_comp_unw[`i'-1]+weight_mortg[`i']*will_mortgages[`i']+weight_install[`i']*will_install[`i']+weight_ccard[`i']*will_ccard[`i']; /* unweighted CEA, 3 components */
	qui replace CEA_comp_unw=CEA_comp_unw_soFar in `i';
	
	sca CEA_soFar_base=CEA_base[`i'-1]+willingness_to_lend[`i']*dyRat[`i']; /* CDC: modified Muellbauer's method to multiply by dOy, in order to provide sensible scaling given rising dOy */
	qui replace CEA_base=CEA_soFar_base in `i';

	sca CEA_soFar_mue=CEA_mue[`i'-1]+willingness_to_lend[`i']; /* original Muellbauer measure */
	qui replace CEA_mue=CEA_soFar_mue in `i';
	
	sca CEA_mort_soFar=CEA_mort[`i'-1]+will_mortgages[`i']; 
	qui replace CEA_mort=CEA_mort_soFar in `i';
	
	sca CEA_install_soFar=CEA_install[`i'-1]+will_install[`i']; 
	qui replace CEA_install=CEA_install_soFar in `i';
	
	sca CEA_ccard_soFar=CEA_ccard[`i'-1]+will_ccard[`i']; 
	qui replace CEA_ccard=CEA_ccard_soFar in `i';
	
	sca CEA_mortFlows_soFar=CEA_mortFlows[`i'-1]+weight_mortg[`i']*mort_flows_fitted_dy[`i']*will_mortgages[`i']+0.01*weight_install[`i']*will_install[`i']+weight_ccard[`i']*0.3*0.01*will_ccard[`i']; 
	qui replace CEA_mortFlows=CEA_mortFlows_soFar in `i';
	
	sca CEA_soFar_comp_GSE=CEA_comp_GSE[`i'-1]+will_mortgages[`i']*dyRat_mortg[`i']*GSE_share[`i']+will_install[`i']*dyRat_install[`i']+will_ccard[`i']*dyRat_ccard[`i']; /* debt-weighted CEA, 3 components */
	qui replace CEA_comp_GSE=CEA_soFar_comp_GSE in `i';
};

local allVars "comp comp_unw base mue mort install ccard mortFlows comp_GSE";

foreach var of local allVars {;

	sum CEA_`var' if tin($startRegW,$endRegW);
	sca CEA_min=r(min);
	sca CEA_max=r(max);
	replace CEA_`var'=(CEA_`var'-CEA_min)/(CEA_max-CEA_min);

};

sum psr_hp if tin($startRegW,$endRegW);
sca psr_min=r(min);
sca psr_max=r(max);
gen psr_hp_norm=(psr_hp-psr_min)/(psr_max-psr_min);

label var CEA_base "CEA Base";
label var CEA_comp "CEA 3 Comps, Weighted";
label var CEA_comp_unw "CEA 3 Comps, Unweighted";
label var CEA_mue "CEA Muellbauer";
gen CCI=CEA_mue;

gen CEA=CEA_comp_GSE;
replace CEA=CEA_comp_unw if "$ceaIndex"=="2";
replace CEA=CEA_base if "$ceaIndex"=="3";
replace CEA=CEA_mue if "$ceaIndex"=="4";
replace CEA=CEA_comp_GSE if "$ceaIndex"=="5";
* [1] 1 CEA_comp, 2 CEA_comp_unw, 3 CEA_base, 4 CEA_mue, 5 CEA_comp_GSE;

gen wyRatCCI=wyRat*CCI;
gen saving_rate_old = psr;
gen saving_rate = psr;
replace saving_rate = psr_old if "$psroldIndex"=="1";

replace saving_rate = psr_model if "$savingSeriesIndex"=="model";

*line CEA_base CEA_comp CEA_comp_unw CEA_mue CEA CEA_comp_GSE t;
line CEA_base CEA_comp CEA_comp_unw CEA_mue CEA_comp_GSE t if tin(1966q2,2011q4);
graph export "CEA.pdf", as(pdf) replace;

*** Preliminary SR regressions;
*************************************************************************************************************;
reg saving_rate L.saving_rate if tin($startRegW,$endRegW);

gen diffU=F4.unemployment-unemployment;
gen lagMichU=sentiment_u;
reg diffU lagMichU if tin($startRegW,$endRegW);
predict diffU_pred if tin($startRegW,$endRegW);
gen unemp_pred=unemployment+diffU_pred;

line saving_rate saving_rate_old t;


line saving_rate wyRat unemp_pred unemployment CEA t;
*replace unemp_pred=unemployment;

*** Export main series for calculations in Matlab;
export excel data saving_rate wyRat CEA unemp_pred using "P:\ECB business areas\DGR\Databases and Programme files\MPR\D - Other projects\Slacalek -- cssUSsaving\code\data\cssUSsavingData_20190124_forMatlab.xls", firstrow(variables) replace;



**** Model Uncertainty and time trend;
reg saving_rate unemp_pred time if tin($startRegW,$endRegW);
scalar mUncT_r1 = e(r2_a);
estat dwatson;
scalar mUncT_dw=r(dw);

newey saving_rate unemp_pred time if tin($startRegW,$endRegW), lag($nwLags);
scalar mUncT_b0= _b[_cons];
scalar mUncT_se0=_se[_cons];
scalar mUncT_bunpred= _b[unemp_pred];
scalar mUncT_seunpred=_se[unemp_pred];
scalar mUncT_btime= _b[time];
scalar mUncT_setime=_se[time];

test unemp_pred time;
scalar mUncT_fpval=r(p);

predict sr_fit_mUncT if tin($startRegW,$endRegW);

line saving_rate sr_fit_mUncT t;

**** Model All 3 variables;
reg saving_rate wyRat CEA unemp_pred if tin($startRegW,$endRegW);
scalar mAll3_r1 = e(r2_a);
estat dwatson;
scalar mAll3_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred  if tin($startRegW,$endRegW), lag($nwLags);
scalar mAll3_b0= _b[_cons];
scalar mAll3_se0=_se[_cons];
scalar mAll3_bm= _b[wyRat];
scalar mAll3_sem=_se[wyRat];
scalar mAll3_bCEA= _b[CEA];
scalar mAll3_seCEA=_se[CEA];
scalar mAll3_bunpred= _b[unemp_pred];
scalar mAll3_seunpred=_se[unemp_pred];

test wyRat CEA unemp_pred;
scalar mAll3_fpval=r(p);

predict sr_fit_mAll3 if tin($startRegW,$endRegW);

reg saving_rate CEA wyRat if tin($startRegW,$endRegW);
predict sr_fit_mAll3exUnc if tin($startRegW,$endRegW);

line saving_rate sr_fit_mAll3 sr_fit_mAll3exUnc t;
gen sr_diff = sr_fit_mAll3-sr_fit_mAll3exUnc;

reg sr_diff recessionI if tin($startRegW,$endRegW);
reg saving_rate recessionI if tin($startRegW,$endRegW); 
reg sr_fit_mAll3 recessionI if tin($startRegW,$endRegW);
reg sr_fit_mAll3exUnc recessionI if tin($startRegW,$endRegW);

******************;


**** Model Reduced form;
reg saving_rate wyRat CEA unemp_pred time if tin($startRegW,$endRegW);
scalar mRF_r1 = e(r2_a);
estat dwatson;
scalar mRF_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred time if tin($startRegW,$endRegW), lag($nwLags);
scalar mRF_b0= _b[_cons];
scalar mRF_se0=_se[_cons];
scalar mRF_bm= _b[wyRat];
scalar mRF_sem=_se[wyRat];
scalar mRF_bCEA= _b[CEA];
scalar mRF_seCEA=_se[CEA];
scalar mRF_bunpred= _b[unemp_pred];
scalar mRF_seunpred=_se[unemp_pred];
scalar mRF_btime= _b[time];
scalar mRF_setime=_se[time];

test wyRat CEA unemp_pred time;
scalar mRF_fpval=r(p);

predict sr_fit_mRF if tin($startRegW,$endRegW);

**** Model Interact;
gen unCEA=unemp_pred*CEA;

reg saving_rate wyRat CEA unemp_pred time unCEA if tin($startRegW,$endRegW);
scalar mInter_r1 = e(r2_a);
estat dwatson;
scalar mInter_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred time unCEA if tin($startRegW,$endRegW), lag($nwLags);
scalar mInter_b0= _b[_cons];
scalar mInter_se0=_se[_cons];
scalar mInter_bm= _b[wyRat];
scalar mInter_sem=_se[wyRat];
scalar mInter_bCEA= _b[CEA];
scalar mInter_seCEA=_se[CEA];
scalar mInter_bunpred= _b[unemp_pred];
scalar mInter_seunpred=_se[unemp_pred];
scalar mInter_bunCEA= _b[unCEA];
scalar mInter_seunCEA=_se[unCEA];
scalar mInter_btime= _b[time];
scalar mInter_setime=_se[time];

test wyRat CEA unemp_pred unCEA time;
scalar mInter_fpval=r(p);

predict sr_fit_mInter if tin($startRegW,$endRegW);


**** Model Demographics;
gen young=100*(1-pop_above16/pop);
gen old=100*pop_above65/pop;

reg saving_rate wyRat CEA unemp_pred old if tin($startRegW,$endRegW);
scalar mDem_r1 = e(r2_a);
estat dwatson;
scalar mDem_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred old if tin($startRegW,$endRegW), lag($nwLags);
scalar mDem_b0= _b[_cons];
scalar mDem_se0=_se[_cons];
scalar mDem_bm= _b[wyRat];
scalar mDem_sem=_se[wyRat];
scalar mDem_bCEA= _b[CEA];
scalar mDem_seCEA=_se[CEA];
scalar mDem_bunpred= _b[unemp_pred];
scalar mDem_seunpred=_se[unemp_pred];
scalar mDem_bold= _b[old];
scalar mDem_seold=_se[old];

test wyRat CEA unemp_pred old;
scalar mDem_fpval=r(p);

predict sr_fit_mDem if tin($startRegW,$endRegW);


**** Model Govt Sav;
gen corp_sr_gdp = 100*corp_sav/gdp;
gen gov_sr_gdp = 100*gov_sav/gdp;

reg saving_rate wyRat CEA unemp_pred gov_sr_gdp if tin($startRegW,$endRegW);
scalar mGovSav_r1 = e(r2_a);
estat dwatson;
scalar mGovSav_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred gov_sr_gdp if tin($startRegW,$endRegW), lag($nwLags);
scalar mGovSav_b0= _b[_cons];
scalar mGovSav_se0=_se[_cons];
scalar mGovSav_bm= _b[wyRat];
scalar mGovSav_sem=_se[wyRat];
scalar mGovSav_bCEA= _b[CEA];
scalar mGovSav_seCEA=_se[CEA];
scalar mGovSav_bunpred= _b[unemp_pred];
scalar mGovSav_seunpred=_se[unemp_pred];
scalar mGovSav_bGS= _b[gov_sr_gdp];
scalar mGovSav_seGS=_se[gov_sr_gdp];

test wyRat CEA unemp_pred gov_sr_gdp;
scalar mGovSav_fpval=r(p);

predict sr_fit_mGovSav if tin($startRegW,$endRegW);


**** Model Ineq;
gen top1_wealth_perc = 100*top1_wealth;
gen top1_income_perc = 100*top1_income;

reg saving_rate wyRat CEA unemp_pred top1_income_perc if tin($startRegW,$endRegW);
scalar mIneq_r1 = e(r2_a);
estat dwatson;
scalar mIneq_dw=r(dw);

newey saving_rate wyRat CEA unemp_pred top1_income_perc if tin($startRegW,$endRegW), lag($nwLags);
scalar mIneq_b0= _b[_cons];
scalar mIneq_se0=_se[_cons];
scalar mIneq_bm= _b[wyRat];
scalar mIneq_sem=_se[wyRat];
scalar mIneq_bCEA= _b[CEA];
scalar mIneq_seCEA=_se[CEA];
scalar mIneq_bunpred= _b[unemp_pred];
scalar mIneq_seunpred=_se[unemp_pred];
scalar mIneq_bIneq= _b[top1_income_perc];
scalar mIneq_seIneq=_se[top1_income_perc];

test wyRat CEA unemp_pred top1_income_perc;
scalar mIneq_fpval=r(p);

predict sr_fit_mIneq if tin($startRegW,$endRegW);
******************;

** Mincer-Zarnowitz b/w RF model and structural model;
constraint 1 sr_fit_mAll3 = 1-psr_model;
cnsreg saving_rate sr_fit_mAll3 psr_model if tin($startRegW,$endRegW), constraint(1) noconstant;


* ;
label var saving_rate "Actual PSR";
label var sr_fit_mAll3 "Fitted Values Reduced Form";
label var psr_model "Fitted Values Structural";

line saving_rate sr_fit_mAll3 psr_model t if tin($startRegW,$endRegW);

do writeRFtable_all.do;

log close;


