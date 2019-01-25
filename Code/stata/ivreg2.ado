*! ivreg2 2.0.06  26Jul2004
*! authors cfb & mes
*! cloned from official ivreg version 5.0.9  19Dec2001
*  1.0.2:  add logic for reg3. Sargan test
*  1.0.3:  add prunelist to ensure that count of excluded exogeneous is correct 
*  1.0.4:  revise option to exog(), allow included exog to be specified as well
*  1.0.5:  switch from reg3 to regress, many options and output changes
*  1.0.6:  fixed treatment of nocons in Sargan and C-stat, and corrected problems
*          relating to use of nocons combined with a constant as an IV
*  1.0.7:  first option reports F-test of excluded exogenous; prunelist bug fix
*  1.0.8:  dropped prunelist and switched to housekeeping of variable lists
*  1.0.9:  added collinearity checks; C-stat calculated with recursive call;
*          added ffirst option to report only F-test of excluded exogenous
*          from 1st stage regressions
*  1.0.10: 1st stage regressions also report partial R2 of excluded exogenous
*  1.0.11: complete rewrite of collinearity approach - no longer uses calls to
*          _rmcoll, does not track specific variables dropped; prunelist removed
*  1.0.12: reorganised display code and saved results to enable -replay()-
*  1.0.13: -robust- and -cluster- now imply -small-
*  1.0.14: fixed hascons bug; removed ivreg predict fn (it didn't work); allowed
*          robust and cluster with z stats and correct dofs
*  1.0.15: implemented robust Sargan stat; changed to only F-stat, removed chi-sq;
*          removed exog option (only orthog works)
*  1.0.16: added clusterised Sargan stat; robust Sargan handles collinearities;
*          predict now works with standard SE options plus resids; fixed orthog()
*          so it accepts time series operators etc.
*  1.0.17: fixed handling of weights.  fw, aw, pw & iw all accepted.
*  1.0.18: fixed bug in robust Sargan code relating to time series variables.
*  1.0.19: fixed bugs in reporting ranks of X'X and Z'Z
*          fixed bug in reporting presence of constant
*  1.0.20: added GMM option and replaced robust Sargan with (equivalent) J;
*          added saved statistics of 1st stage regressions
*  1.0.21: added Cragg HOLS estimator, including allowing empty endog list;
*          -regress- syntax now not allowed; revised code searching for "_cons"
*  1.0.22: modified cluster output message; fixed bug in replay for Sargan/Hansen stat;
*          exactly identified Sargan/Hansen now exactly zero and p-value not saved as e();
*          cluster multiplier changed to 1 (from buggy multiplier), in keeping with
*          eg Wooldridge 2002 p. 193.
*  1.0.23: fixed orthog option to prevent abort when restricted equation is underid.
*  1.0.24: fixed bug if 1st stage regressions yielded missing values for saving in e().
*  1.0.25: Added Shea version of partial R2
*  1.0.26: Replaced Shea algorithm with Godfrey algorithm
*  1.0.27: Main call to regress is OLS form if OLS or HOLS is specified; error variance
*          in Sargan and C statistics use small-sample adjustment if -small- option is
*          specified; dfn of S matrix now correctly divided by sample size
*  1.0.28: HAC covariance estimation implemented
*          Symmetrize all matrices before calling syminv
*          Added hack to catch F stats that ought to be missing but actually have a
*          huge-but-not-missing value
*          Fixed dof of F-stat - was using rank of ZZ, should have used rank of XX (couldn't use df_r
*          because it isn't always saved.  This is because saving df_r triggers small stats
*          (t and F) even when -post- is called without dof() option, hence df_r saved only
*          with -small- option and hence a separate saved macro Fdf2 is needed.
*          Added rankS to saved macros
*          Fixed trap for "no regressors specified"
*          Added trap to catch gmm option with no excluded instruments
*          Allow OLS syntax (no endog or excluded IVs specified)
*          Fixed error messages and traps for rank-deficient robust cov matrix; includes
*          singleton dummy possibility
*          Capture error if posting estimated VCV that isn't pos def and report slightly
*          more informative error message
*          Checks 3 variable lists (endo, inexog, exexog) separately for collinearities
*          Added AC (autocorrelation-consistent but conditionally-homoskedastic) option
*          Sargan no longer has small-sample correction if -small- option
*          robust, cluster, AC, HAC all passed on to first-stage F-stat
*          bw must be < T
*  1.0.29  -orthog- also displays Hansen-Sargan of unrestricted equation
*          Fixed collinearity check to include nocons as well as hascons
*          Fixed small bug in Godfrey-Shea code - macros were global rather than local
*          Fixed larger bug in Godfrey-Shea code - was using mixture of sigma-squares from IV and OLS
*            with and without small-sample corrections
*          Added liml and kclass
*  1.0.30  Changed order of insts macro to match saved matrices S and W
*  2.0.00  Collinearities no longer -qui-
*          List of instruments tested in -orthog- option prettified
*  2.0.01  Fixed handling of nocons with no included exogenous, including LIML code
*  2.0.02  Allow C-test if unrestricted equation is just-identified.  Implemented by
*          saving Hansen-Sargan dof as = 0 in e() if just-identified.
*  2.0.03  Added score() option per latest revision to official ivreg
*  2.0.04  Changed score() option to pscore() per new official ivreg
*  2.0.05  Fixed est hold bug in first-stage regressions
*          Fixed F-stat finite sample adjustment with cluster option to match official Stata
*          Fixed F-stat so that it works with hascons (collinearity with constant is removed)
*          Fixed bug in F-stat code - wasn't handling failed posting of vcv
*          No longer allows/ignores nonsense options
*  2.0.06  Modified lsStop to sync with official ivreg 5.1.3

*  Variable naming:
*  lhs = LHS endogenous
*  endo = RHS endogenous (instrumented)
*  inexog = included exogenous (instruments)
*  exexog = excluded exogenous (instruments)
*  iv = {inexog exexog} = all instruments
*  rhs = {endo inexog} = RHS regressors
*  1 at the end of the name means the varlist after duplicates and collinearities removed

program define ivreg2, eclass byable(recall)
	version 7.0
	local version 02.0.05

	if replay() {
		if `"`e(cmd)'"' != "ivreg2"  {
			error 301
		}
		else {
			syntax [, Level(integer $S_level) NOHEader NOFOoter /*
				*/ EForm(string) PLUS]
			if "`eform'"!="" {
				local efopt "eform(`eform')"
			}
		}
	}
	else {

		syntax [anything(name=0)] [if] [in] [aw fw pw iw/] [, /*
			*/ FIRST FFIRST SMall Beta Robust CLuster(varname) hc2 hc3 /*
			*/ GMM WMATRIX(string) ORTHOG(string) NOConstant Hascons /*
			*/ Level(integer $S_level) NOHEader NOFOoter /*
			*/ DEPname(string) EForm(string) PLUS /*
			*/ BW(string) kernel(string) /*
			*/ LIML COVIV FULLER(real 0) Kclass(string) PSCore(string) ]

		local n 0

		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		IsStop `lhs'
		if `s(stop)' { error 198 }
		while `s(stop)'==0 { 
			if "`paren'"=="(" {
				local n = `n' + 1
				if `n'>1 { 
capture noi error 198 
di in red `"syntax is "(all instrumented variables = instrument variables)""'
exit 198
				}
				gettoken p lhs : lhs, parse(" =")
				while "`p'"!="=" {
					if "`p'"=="" {
capture noi error 198 
di in red `"syntax is "(all instrumented variables = instrument variables)""'
di in red `"the equal sign "=" is required"'
exit 198 
					}
					local endo `endo' `p'
					gettoken p lhs : lhs, parse(" =")
				}
* To enable Cragg HOLS estimator, allow for empty endo list
				if "`endo'" != "" {
					tsunab endo : `endo'
				}
				tsunab exexog : `lhs'
			}
			else {
				local inexog `inexog' `lhs'
			}
			gettoken lhs 0 : 0, parse(" ,[") match(paren)
			IsStop `lhs'
		}
		local 0 `"`lhs' `0'"'

		tsunab inexog : `inexog'
		tokenize `inexog'
		local lhs "`1'"
		local 1 " " 
		local inexog `*'

		if "`gmm'" != "" & "`exexog'" == "" {
			di in red "option `gmm' invalid: no excluded instruments specified"
			exit 102
		}

* Process options

* Fuller implies LIML
		if "`liml'" == "" & `fuller' != 0 {
			local liml "liml"
			}
* LIML/kclass incompatibilities
		if "`liml'`kclass'" != "" {
			if "`bw'`kernel'" != "" {
di as err "autocorrelation-robust regression not available with LIML or k-class estimators"
			exit 198
			}
			if "`gmm'" != "" {
di as err "GMM estimation not available with LIML or k-class estimators"
			exit 198
			}
			if `fuller' < 0 {
di as err "invalid Fuller option"
			exit 198
			}
			if "`liml'" != "" & "`kclass'" != "" {
di as err "cannot use liml and kclass options together"
			exit 198
			}
* Process kclass string
			tempname kclass2
			scalar `kclass2'=real("`kclass'")
			if "`kclass'" != "" & (`kclass2' == . | `kclass2' < 0 ) {
di as err "invalid k-class option"
				exit 198
				}			
		}

* HAC estimation.
* If bw is omitted, default `bw' is empty string.
* If bw or kernel supplied, check/set `kernel'.
* Macro `kernel' is also used for indicating HAC in use.
		if "`bw'" != "" | "`kernel'" != "" {
* Need tvar only for markout with time-series stuff
* but data must be tsset for time-series operators in code to work
			capture tsset
			capture local tvar "`r(timevar)'"
			capture local ivar "`r(panelvar)'"
			capture local T `r(tmax)'-`r(tmin)'
			if "`tvar'" == "" {
di as err "must tsset data and specify timevar"
				exit 5
			}
			tsreport if `tvar' != .
			if `r(N_gaps)' != 0 & "`ivar'"=="" {
di in gr "Warning: time variable " in ye "`tvar'" in gr " has " /*
	*/ in ye "`r(N_gaps)'" in gr " gap(s) in relevant range"
			}

			if "`bw'" == "" {
di as err "bandwidth option bw() required for HAC-robust estimation"
				exit 102
			}
			local bw real("`bw'")
* Check it's a valid bandwidth
			if   `bw' != int(`bw') | /*
			*/   `bw' == .  | /*
			*/   `bw' <= 0 {
di as err "invalid bandwidth in option bw() - must be integer > 0"
				exit 198
			}
* Convert bw macro to simple integer
			local bw=`bw'
* and check that bw < T
			if `bw' >= `T' {
di as err "invalid bandwidth in option bw() - cannot exceed timespan of data"
				exit 198
			}
* Check it's a valid kernel
			local validkernel 0
			if lower(substr("`kernel'", 1, 3)) == "bar" | "`kernel'" == "" {
* Default kernel
				local kernel "Bartlett"
				local window "lag"
				local validkernel 1
				if `bw'==1 {
di in ye "Note: kernel=Bartlett and bw=1 implies zero lags used.  Standard errors and"
di in ye "      test statistics are not autocorrelation-consistent."
				}
			}
			if lower(substr("`kernel'", 1, 3)) == "par" {
				local kernel "Parzen"
				local window "lag"
				local validkernel 1
				if `bw'==1 {
di in ye "Note: kernel=Parzen and bw=1 implies zero lags used.  Standard errors and"
di in ye "      test statistics are not autocorrelation-consistent."
				}
			}
			if lower(substr("`kernel'", 1, 3)) == "tru" {
				local kernel "Truncated"
				local window "lag"
				local validkernel 1
			}
			if lower(substr("`kernel'", 1, 9)) == "tukey-han" | lower("`kernel'") == "thann" {
				local kernel "Tukey-Hanning"
				local window "lag"
				local validkernel 1
				if `bw'==1 {
di in ye "Note: kernel=Tukey-Hanning and bw=1 implies zero lags.  Standard errors and"
di in ye "      test statistics are not autocorrelation-consistent."
				}
			}
			if lower(substr("`kernel'", 1, 9)) == "tukey-ham" | lower("`kernel'") == "thamm" {
				local kernel "Tukey-Hamming"
				local window "lag"
				local validkernel 1
				if `bw'==1 {
di in ye "Note: kernel=Tukey-Hamming and bw=1 implies zero lags.  Standard errors and"
di in ye "      test statistics are not autocorrelation-consistent."
				}
			}
			if lower(substr("`kernel'", 1, 3)) == "qua" | lower("`kernel'") == "qs" {
				local kernel "Quadratic spectral"
				local window "spectral"
				local validkernel 1
			}
			if lower(substr("`kernel'", 1, 3)) == "dan" {
				local kernel "Daniell"
				local window "spectral"
				local validkernel 1
			}
			if lower(substr("`kernel'", 1, 3)) == "ten" {
				local kernel "Tent"
				local window "spectral"
				local validkernel 1
			}
			if ~`validkernel' {
				di in red "invalid kernel"
				exit 198
			}
		}

		if "`kernel'" != "" & "`cluster'" != "" {
di as err "cannot use HAC kernel estimator with -cluster- option"
				exit 198
		}

		if "`orthog'" != "" {
			tsunab orthog : `orthog'
			}

		if "`hc2'`hc3'" != "" {
			if "`hc2'"!="" {
				di in red "option `hc2' invalid"
			}
			else	di in red "option `hc3' invalid"
			exit 198
		}

		if "`beta'" != "" {
			di in red "option `beta' invalid"
			exit 198
		}

* Weights
* fweight and aweight accepted as is
* iweight not allowed with robust or gmm and requires a trap below when used with summarize
* pweight is equivalent to aweight + robust
*   but in HAC case, robust implied by `kernel' rather than `robust'

		tempvar wvar
		if "`weight'" == "fweight" | "`weight'"=="aweight" {
			local wtexp `"[`weight'=`exp']"'
			gen double `wvar'=`exp'
		}
		if "`weight'" == "fweight" & "`kernel'" !="" {
			di in red "fweights not allowed (data are -tsset-)"
			exit 101
		}
		if "`weight'" == "iweight" {
			if "`robust'`cluster'`gmm'`kernel'" !="" {
				di in red "iweights not allowed with robust or gmm"
				exit 101
			}
			else {
				local wtexp `"[`weight'=`exp']"'
				gen double `wvar'=`exp'
			}
		}
		if "`weight'" == "pweight" {
			local wtexp `"[aweight=`exp']"'
			gen double `wvar'=`exp'
			local robust "robust"
		}

* If no kernel (=no HAC) then gmm implies (heteroskedastic-) robust
		if "`kernel'" == "" & "`gmm'" != "" {
			local robust "robust"
		}

		marksample touse
		markout `touse' `lhs' `inexog' `exexog' `endo' `cluster' `tvar', strok

* Remove collinearities
		if "`noconstant'`hascons'" != "" {
			local rmcnocons "nocons"
		}
		_rmcoll `inexog' if `touse' `wtexp', `rmcnocons'
		local inexog1 `r(varlist)'
		_rmcoll `exexog' if `touse' `wtexp', `rmcnocons'
		local exexog1 `r(varlist)'
		_rmcoll `endo' if `touse' `wtexp', `rmcnocons'
		local endo1 `r(varlist)'

		local insts1 `inexog1' `exexog1'
		local rhs1   `endo1'   `inexog1'
		local iv1_ct     : word count `insts1'
		local rhs1_ct    : word count `rhs1'
		local endo1_ct   : word count `endo1'
		local endoexex1_ct : word count `endo1' `exexog1'
		local inexog1_ct : word count `inexog1'

		if "`noconstant'" == "" {
			local cons_ct 1
		}
		else {
			local cons_ct 0
		}

		if `rhs1_ct' > `iv1_ct' {
			di in red "equation not identified; must have at " /*
			*/ "least as many instruments not in"
			di in red "the regression as there are "           /*
			*/ "instrumented variables"
			exit 481
		}

		if `rhs1_ct' + `cons_ct' == 0 {
			di in red "error: no regressors specified"
			exit 102
		}

		if "`cluster'"!="" {
			local clopt "cluster(`cluster')"
		}
		if "`bw'"!="" {
			local bwopt "bw(`bw')"
		}
		if "`kernel'"!="" {
			local kernopt "kernel(`kernel')"
		}
		if "`eform'"!="" {
			local efopt "eform(`eform')"
		}
* If depname not provided (default) name is lhs variable
		if "`depname'"=="" {
			local depname `lhs'
		}


************************************************************************************************
* Cross-products and basic IV coeffs, residuals and moment conditions
		tempvar iota y2 yhat ivresid ivresid2 gresid gresid2
		tempname Nprec ysum yy yyc r2u r2c B V ivB gmmB gmmV ivest
		tempname r2 r2_a rss mss rmse sigmasq iv_s2 F Fp Fdf2
		tempname S Sinv ivZu gmmZu A XZ XZa XZb Zy ZZ ZZinv XPZX XPZXinv XPZy
		tempname YY Z2Z2 ZY Z2Y XXa XXb XX Xy Z2Z2inv
		tempname B V B1 uZWZu j jp sargmse tempmat

* Generate cross-products of y, X, Z
		qui matrix accum `A' = `lhs' `endo1' `exexog1' `inexog1' /*
			*/ if `touse' `wtexp', `noconstant'
		if "`noconstant'"=="" {
			matrix rownames `A' = `lhs' `endo1' `exexog1' /*
				*/ `inexog1' _cons
			matrix colnames `A' = `lhs' `endo1' `exexog1' /*
				*/ `inexog1' _cons
		}
		else {
			matrix rownames `A' = `lhs' `endo1' `exexog1' `inexog1'
			matrix colnames `A' = `lhs' `endo1' `exexog1' `inexog1'
		}
		if `endo1_ct' > 0 {
* X'Z is [endo1 inexog1]'[exexog1 inexog1]
			mat `XZ'=`A'[2..`endo1_ct'+1,`endo1_ct'+2...]
* Append portion corresponding to included exog if they (incl constant) exist
			if 2+`endo1_ct'+`iv1_ct'-(`rhs1_ct'-`endo1_ct') /*
					*/ <= rowsof(`A') {
				mat `XZ'=`XZ' \ /*
					*/ `A'[2+`endo1_ct'+`iv1_ct'- /*
					*/ (`rhs1_ct'-`endo1_ct')..., /*
					*/ `endo1_ct'+2...]
			}
* If included exog (incl const) exist, create XX matrix in 3 steps
			if `inexog1_ct' + `cons_ct' > 0 {
				mat `XXa'  = `A'[2..`endo1_ct'+1, 2..`endo1_ct'+1], /*
					*/ `A'[2..`endo1_ct'+1, `endoexex1_ct'+2...]
				mat `XXb'  = `A'[`endoexex1_ct'+2..., 2..`endo1_ct'+1], /*
					*/ `A'[`endoexex1_ct'+2..., `endoexex1_ct'+2...]
				mat `XX'   = `XXa' \ `XXb'
				mat `Xy'  = `A'[2..`endo1_ct'+1, 1] \ `A'[`endoexex1_ct'+2..., 1]
			}
			else {
				mat `XX'   = `A'[2..`endo1_ct'+1, 2..`endo1_ct'+1]
				mat `Xy'  = `A'[2..`endo1_ct'+1, 1]
			}
		}
		else {
* Cragg HOLS estimator with no endogenous variables
			mat `XZ'= `A'[2+`iv1_ct'-(`rhs1_ct'-`endo1_ct')..., /*
					*/ 2...]
			mat `XX'   = `A'[`endoexex1_ct'+2..., `endoexex1_ct'+2...]
* Xy matrix is the same thing as Z2y
			mat `Xy'  = `A'[`endoexex1_ct'+2..., 1]
		}

		mat `Zy'=`A'[`endo1_ct'+2...,1]
		mat `ZZ'=`A'[`endo1_ct'+2...,`endo1_ct'+2...]
		mat `ZZ'=(`ZZ'+`ZZ'')/2
		mat `ZZinv'=syminv(`ZZ')
		local iv_ct = rowsof(`ZZ') - diag0cnt(`ZZinv')
		mat `YY'=`A'[1..`endo1_ct'+1, 1..`endo1_ct'+1]
		mat `ZY' = `A'[`endo1_ct'+2..., 1..`endo1_ct'+1]
		if "`liml'" != "" & (`inexog1_ct' + `cons_ct') > 0 {
* Need these only for LIML ... but is LIML defined only if included exog > 0?
			mat `Z2Y'  = `A'[`endoexex1_ct'+2..., 1..`endo1_ct'+1]
			mat `Z2Z2' = `A'[`endoexex1_ct'+2..., `endoexex1_ct'+2...]
			mat `Z2Z2'=(`Z2Z2'+`Z2Z2'')/2
			mat `Z2Z2inv' = syminv(`Z2Z2')
		}
		mat `XPZX'=`XZ'*`ZZinv'*`XZ''
		mat `XPZX'=(`XPZX'+`XPZX'')/2
		mat `XPZXinv'=syminv(`XPZX')
		mat `XPZy'=`XZ'*`ZZinv'*`Zy'
		mat `B' = `XPZy''*`XPZXinv''
		mat `ivB'=`B'

		qui mat score double `yhat' = `B' if `touse'
		qui gen double `ivresid'=`lhs'-`yhat'
		capture drop `yhat'
		qui gen double `ivresid2'=`ivresid'^2
		qui gen `iota'=1
		qui gen double `y2'=`lhs'^2
* Stata summarize won't work with iweights, so must use matrix cross-product
		qui matrix vecaccum `ysum' = `iota' `y2' `lhs' `ivresid2' `wtexp' if `touse'
* Nprec is ob count from mat accum.  Use this rather than `N' in calculations
* here and below because in official -regress- `N' is rounded if iweights are used.
		scalar `Nprec'=`ysum'[1,4]
		local N=int(`Nprec')
		scalar `rss'=`ysum'[1,3]
		scalar `yy'=`ysum'[1,1]
		scalar `yyc'=`yy'-`ysum'[1,2]^2/`Nprec'
		if "`noconstant'"=="" {
			scalar `mss'=`yyc' - `rss'
		}
		else {
			scalar `mss'=`yy' - `rss'
		}
		scalar `sigmasq'=`rss'/`Nprec'
		scalar `iv_s2'=`sigmasq'
		scalar `rmse'=sqrt(`sigmasq')
* Bread of the sandwich
		qui mat vecaccum `ivZu'=`ivresid' `exexog1' `inexog1' /*
			*/ `wtexp' if `touse', `noconstant'
* End of basic IV block

*******************************************************************************************
* Start robust block for robust-HAC S and Sinv

		if "`robust'`cluster'" != "" & "`liml'"=="" & "`kclass'"=="" {
* Optimal weighting matrix
* If user-supplied wmatrix is used, use it, otherwise use _robust (hence weights allowed)
			if "`wmatrix'" != "" {
				matrix `Sinv'=`wmatrix'
* Need S as well only if call by HAC which isn't also GMM, but do it anyway
				mat `S'=syminv(`Sinv')
				mat `S' = (`S' + `S'') / 2
			}
			else {
* Block calculates S_0 robust matrix
* _robust has same results as
* mat accum `S'=`exexog1' `inexog1' [iweight=`ivresid'^2] if `touse'
* mat `S' = `S'*1/`Nprec'
* _robust doesn't work properly with TS variables, so must first tsrevar
				tsrevar `exexog1' `inexog1'
				local TSinsts1 `r(varlist)'
* Create identity matrix with matching col/row names
				mat `S'=I(colsof(`ivZu'))
				if "`noconstant'"=="" {
					mat colnames `S' = `TSinsts1' "_cons"
					mat rownames `S' = `TSinsts1' "_cons"
				}
				else {
					mat colnames `S' = `TSinsts1'
					mat rownames `S' = `TSinsts1'
				}
				_robust `ivresid' `wtexp' if `touse', variance(`S') `clopt' minus(0)
				if "`cluster'"!="" {
					local N_clust=r(N_clust)
				}
				mat `S' = `S'*1/`Nprec'
* Above doesn't work properly with iweights (i.e. yield same matrix as fw),
*   hence iweight trap at start
				if "`kernel'" != "" {
* HAC block for S_1 onwards matrices
					tempvar vt1
					qui gen double `vt1' = .
					tempname tt tx kw karg ow
* Use insts with TS ops removed and with iota (constant) column
					if "`noconstant'"=="" {
						local insts1c "`TSinsts1' `iota'"
					}
					else {
						local insts1c "`TSinsts1'"
					}
					local iv1c_ct   : word count `insts1c'
* "tau=0 loop" is S_0 block above for all robust code
					local tau 1
* Spectral windows require looping through all T-1 autocovariances
					if "`window'" == "spectral" {
						local TAU `T'-1
di in ye "Computing kernel ..."
					}
					else {
						local TAU `bw'
					}
					if "`weight'" == "" {
* If no weights specified, define neutral weight variables for code below
						gen byte `wvar'=1
						gen byte `ow'=1
						local wtexp `"[fweight=`wvar']"'
					}
					else {
* pweights and aweights
						summ `wvar' if `touse', meanonly
						gen double `ow' = `wvar'/r(mean)
					}
					while `tau' <= `TAU' {
						capture mat drop `tt' 
						local i 1
						while `i' <= `iv1c_ct' {
							local x : word `i' of `insts1c'
* Add lags defined with TS operators
							local Lx "L`tau'.`x'"
							local Livresid "L`tau'.`ivresid'"
							local Low "L`tau'.`ow'"
							qui replace `vt1' = `Lx'*`ivresid'* /*
								*/ `Livresid'*`Low'*`ow' if `touse'
* Use capture here because there may be insufficient observations, e.g., if
*   the IVs include lags and tau=N-1.  _rc will be 2000 in this case.
							capture mat vecaccum `tx' = `vt1' `insts1c' /*
								*/ if `touse', nocons
							if _rc == 0 {
								mat `tt' = nullmat(`tt') \ `tx'
							}
							local i = `i'+1
						}
* bw = bandwidth, karg is argument to kernel function, kw is kernel function (weight)
						scalar `karg' = `tau'/(`bw')
						if "`kernel'" == "Truncated" {
							scalar `kw'=1
						}
						if "`kernel'" == "Bartlett" {
							scalar `kw'=(1-`karg')
						}
						if "`kernel'" == "Parzen" {
							if `karg' <= 0.5 {
								scalar `kw' = 1-6*`karg'^2+6*`karg'^3
							}
							else {
								scalar `kw' = 2*(1-`karg')^3
							}
						}
						if "`kernel'" == "Tukey-Hanning" {
							scalar `kw'=0.5+0.5*cos(_pi*`karg')
						}
						if "`kernel'" == "Tukey-Hamming" {
							scalar `kw'=0.54+0.46*cos(_pi*`karg')
						}
						if "`kernel'" == "Tent" {
							scalar `kw'=2*(1-cos(`tau'*`karg')) / (`karg'^2)
						}
						if "`kernel'" == "Daniell" {
							scalar `kw'=sin(_pi*`karg') / (_pi*`karg')
						}
						if "`kernel'" == "Quadratic spectral" {
							scalar `kw'=25/(12*_pi^2*`karg'^2) /*
								*/ * ( sin(6*_pi*`karg'/5)/(6*_pi*`karg'/5) /*
								*/     - cos(6*_pi*`karg'/5) )
						}
* Need -capture-s here because tt may not exist (because of insufficient observations/lags)
						capture mat `tt' = (`tt'+`tt'')*`kw'*1/`Nprec'
						if _rc == 0 {
							mat `S' = `S' + `tt'
						}
						local tau = `tau'+1
					}
					if "`weight'" == "" {
* If no weights specified, remove neutral weight variables
						local wtexp ""
					}
				}
* To give S the right col/row names
				mat `S'=`S'+0*diag(`ivZu')
				mat `S'=(`S'+`S'')/2
				mat `Sinv'=syminv(`S')
			}
		}

* End robust-HAC S and Sinv block

************************************************************************************
* Block for non-robust S and Sinv, including autocorrelation-consistent (AC).

		if "`robust'`cluster'" == "" & "`liml'" == ""  & "`kclass'"=="" {

* First do with S_0 (=S for simple IV)
			mat `S' = `iv_s2'*`ZZ'*(1/`Nprec')

			if "`kernel'" != "" {
* AC code for S_1 onwards matrices
				tempvar vt1
				qui gen double `vt1' = .
				tempname tt tx kw karg ow sigttj
* Use insts with TS ops removed and with iota (constant) column
				tsrevar `exexog1' `inexog1'
				local TSinsts1 `r(varlist)'
				if "`noconstant'"=="" {
					local insts1c "`TSinsts1' `iota'"
				}
				else {
					local insts1c "`TSinsts1'"
				}
				local iv1c_ct   : word count `insts1c'
* "tau=0 loop" is S_0 block above
				local tau 1
* Spectral windows require looping through all T-1 autocovariances
				if "`window'" == "spectral" {
					local TAU `T'-1
di in ye "Computing kernel ..."
				}
				else {
					local TAU `bw'
				}
				if "`weight'" == "" {
* If no weights specified, define neutral weight variables for code below
					gen byte `wvar'=1
					gen byte `ow'=1
					local wtexp `"[fweight=`wvar']"'
				}
				else {
* pweights and aweights
					summ `wvar' if `touse', meanonly
					gen double `ow' = `wvar'/r(mean)
				}
				while `tau' <= `TAU' {
					capture mat drop `tt' 
					local i 1
* errflag signals problems that make this loop's tt invalid
					local errflag 0
					while `i' <= `iv1c_ct' {
						local x : word `i' of `insts1c'
* Add lags defined with TS operators
						local Lx "L`tau'.`x'"
						local Low "L`tau'.`ow'"
						qui replace `vt1' = `Lx'*`Low'*`ow' if `touse'
* Use capture here because there may be insufficient observations, e.g., if
*   the IVs include lags and tau=N-1.  _rc will be 2000 in this case.
						capture mat vecaccum `tx' = `vt1' `insts1c' /*
							*/ if `touse', nocons
						if _rc == 0 {
							mat `tt' = nullmat(`tt') \ `tx'
						}
						local i = `i'+1
					}
					capture mat `tt' = 1/`Nprec' * `tt'
					if _rc != 0 {
						local errflag = 1
					}
					local Livresid "L`tau'.`ivresid'"
* Should weights appear here as well?
					tempvar ivLiv
					qui gen double `ivLiv' = `ivresid' * `Livresid' if `touse'
					qui sum `ivLiv' if `touse', meanonly
					scalar `sigttj' = r(sum)/`Nprec'

					capture mat `tt' = `sigttj' * `tt'
* bw = bandwidth, karg is argument to kernel function, kw is kernel function (weight)
					scalar `karg' = `tau'/(`bw')
					if "`kernel'" == "Truncated" {
						scalar `kw'=1
					}
					if "`kernel'" == "Bartlett" {
						scalar `kw'=(1-`karg')
					}
					if "`kernel'" == "Parzen" {
						if `karg' <= 0.5 {
							scalar `kw' = 1-6*`karg'^2+6*`karg'^3
						}
						else {
							scalar `kw' = 2*(1-`karg')^3
						}
					}
					if "`kernel'" == "Tukey-Hanning" {
						scalar `kw'=0.5+0.5*cos(_pi*`karg')
					}
					if "`kernel'" == "Tukey-Hamming" {
						scalar `kw'=0.54+0.46*cos(_pi*`karg')
					}
					if "`kernel'" == "Tent" {
						scalar `kw'=2*(1-cos(`tau'*`karg')) / (`karg'^2)
					}
					if "`kernel'" == "Daniell" {
						scalar `kw'=sin(_pi*`karg') / (_pi*`karg')
					}
					if "`kernel'" == "Quadratic spectral" {
						scalar `kw'=25/(12*_pi^2*`karg'^2) /*
							*/ * ( sin(6*_pi*`karg'/5)/(6*_pi*`karg'/5) /*
							*/     - cos(6*_pi*`karg'/5) )
					}

* Need -capture-s here because tt may not exist (because of insufficient observations/lags)
					capture mat `tt' = (`tt'+`tt'')*`kw'
					if _rc != 0 {
						local errflag = 1
					}
* Accumulate if tt is valid
					if `errflag' == 0 {
						capture mat `S' = `S' + `tt'
					}
					local tau = `tau'+1
				}
				if "`weight'" == "" {
* If no weights specified, remove neutral weight variables
					local wtexp ""
				}
			}
* End of AC code
* To give S the right col/row names
			mat `S'=`S'+0*diag(`ivZu')
			mat `S'=(`S'+`S'')/2
			mat `Sinv'=syminv(`S')
		}

* End of non-robust S and Sinv code (including AC)

***************************************************************************************
* Block for gmm 2nd step for coefficients, and robust/cluster/AC/HAC for Sargan-Hansen

* Non-robust IV, LIML, k-class do not enter
		if "`gmm'`robust'`cluster'`kernel'" != "" & "`liml'"=="" & "`kclass'"=="" {
* Symmetrize before call to syminv
			mat `tempmat'=`XZ'*`Sinv'*`XZ''
			mat `tempmat'=(`tempmat'+`tempmat'')/2
			mat `B1'=syminv(`tempmat')
			mat `B1'=(`B1'+`B1'')/2
			mat `B'=(`B1'*`XZ'*`Sinv'*`Zy')'
* Symmetrize before call to syminv
			mat `tempmat'=`XZ'*`Sinv'*`XZ''
			mat `tempmat'=(`tempmat'+`tempmat'')/2
			mat `V' = syminv(`tempmat')*`Nprec'
			mat `V'=(`V'+`V'')/2

			local rankS = rowsof(`Sinv') - diag0cnt(`Sinv')

			capture drop `yhat'
			qui mat score double `yhat'=`B' if `touse'
			qui gen double `gresid'=`lhs'-`yhat'
			qui gen double `gresid2'=`gresid'^2
* J or Sargan statistic
			qui mat vecaccum `gmmZu'=`gresid' `exexog1' `inexog1' /*
				*/ `wtexp' if `touse', `noconstant'
			mat `uZWZu'= (`gmmZu'/`Nprec')*`Sinv'*(`gmmZu''/`Nprec')
* If non-robust, it's a Sargan, otherwise it's a J
			scalar `j' = `Nprec'*`uZWZu'[1,1]

* New rss, R2s etc if new coeffs (GMM)
			if "`gmm'"!="" {
				capture drop `ysum'
				qui matrix vecaccum `ysum' = `iota' `gresid2' /*
					*/ `wtexp' if `touse', `noconstant'
				scalar `rss'= `ysum'[1,1]
				scalar `sigmasq'=`rss'/`Nprec'
				scalar `rmse'=sqrt(`sigmasq')
				if "`noconstant'"=="" {
					scalar `mss'=`yyc'-`rss'
				}
				else {
					scalar `mss'=`yy'-`rss'
				}
			}
		}
* End of second-step gmm code

*********************************************************************************
* IV code
		if ("`robust'`cluster'`gmm'`kernel'" == "") /*
			*/	& ("`liml'"=="") & ("`kclass'"=="") {
* Straight IV block for Sargan, coeffs and VCV, no small sample correction
			mat `uZWZu' = (`ivZu'/`Nprec')*`Sinv'*(`ivZu''/`Nprec')
			scalar `j' = `Nprec'*`uZWZu'[1,1]
			mat `B'=`ivB'
* XPZXinv may not exist if there were problems with the original regression
			capture mat `V'=`XPZXinv'*`iv_s2'
			capture mat `V'=(`V'+`V'')/2
		}


		if ("`robust'`cluster'`kernel'" != "") & ("`gmm'" == "") /*
			*/	& ("`liml'"=="") & ("`kclass'"=="") {
* Block for IV coeffs with robust SEs of all sorts, no small-sample correction
			mat `B'=`ivB'
			mat `V'=`XPZXinv'*`XZ'*`ZZinv'*`S'*`Nprec'*  /*
				*/ `ZZinv'*`XZ''*`XPZXinv'
			mat `V'=(`V'+`V'')/2
		}

********************************************************************************
* LIML and kclass code
		if "`liml'" != "" | "`kclass'" != "" {

			tempname W W1 Evec Eval Evaldiag target lambda XhXh XhXhinv ll
			tempvar lresid lresid2

			if "`kclass'" == "" {
* LIML block
				matrix `W'  = `YY' - `ZY''*`ZZinv'*`ZY'
				if `inexog1_ct' + `cons_ct' > 0 {
					matrix `W1' = `YY' - `Z2Y''*`Z2Z2inv'*`Z2Y'
				}
				else {
* Special case of no included exogenous (incl constant)
					matrix `W1' = `YY'
				}
				matrix symeigen `Evec' `Eval' = `W'
				matrix `Evaldiag' = diag(`Eval')
* Replace diagonal elements of Evaldiag with the element raised to the power (-1/2)
				local i 1
				while `i' <= rowsof(`Evaldiag') {
* Need to use capture because with collinearities, diag may be virtually zero
* ... but actually negative
					capture matrix `Evaldiag'[`i',`i'] = /*
						*/ `Evaldiag'[`i',`i']^(-0.5)
					local i = `i'+1
				}
				matrix `target' = (`Evec'*`Evaldiag'*`Evec'') * `W1' /*
					*/ * (`Evec'*`Evaldiag'*`Evec'')
* Re-use macro names
				matrix symeigen `Evec' `Eval' = `target'
* Get smallest eigenvalue
* Note that collinearities can yield a nonsense eigenvalue appx = 0
* and just-identified will yield an eigenvalue that is ALMOST exactly = 1
* so require it to be >= 0.9999999999.
				local i 1
				scalar `lambda'=.
				while `i' <= colsof(`Eval') {
					if (`lambda' > `Eval'[1,`i']) & (`Eval'[1,`i'] >=0.9999999999) {
						scalar `lambda' = `Eval'[1,`i']
					}
					local i = `i'+1
				}
				if `fuller'==0 {
* Basic LIML.  Macro kclass2 is the scalar.
					scalar `kclass2'=`lambda'
				}
				else {
* Fuller LIML
					if `fuller' > (`N'-`iv_ct') {
di as err "error: invalid choice of Fuller LIML parameter"
						exit 198
					}
					scalar `kclass2' = `lambda' - `fuller'/(`N'-`iv_ct')
				}

* End of LIML block
			}

			mat `XhXh'=(1-`kclass2')*`XX'+`kclass2'*`XPZX'
			mat `XhXh'=(`XhXh'+`XhXh'')/2
			mat `XhXhinv'=syminv(`XhXh')
			mat `B'=`Xy''*`XhXhinv'*(1-`kclass2') + `kclass2'*`Zy''*`ZZinv'*`XZ''*`XhXhinv'
			capture drop `yhat'
			qui mat score double `yhat'=`B' if `touse'
			qui gen double `lresid'=`lhs' - `yhat'
			qui gen double `lresid2'=`lresid'^2
			capture drop `ysum'
			qui matrix vecaccum `ysum' = `iota' `lresid2' /*
				*/ `wtexp' if `touse', `noconstant'
			scalar `rss'= `ysum'[1,1]
			scalar `sigmasq'=`rss'/`Nprec'
			scalar `rmse'=sqrt(`sigmasq')
			if "`noconstant'"=="" {
				scalar `mss'=`yyc'-`rss'
			}
			else {
				scalar `mss'=`yy'-`rss'
			}
			if "`liml'" != "" {
* Anderson-Rubin overid stat
				scalar `j'=`Nprec'*ln(`lambda')
			}
			else {
* Sargan stat for k-class
				tempvar kclassZu
				qui mat vecaccum `kclassZu'=`lresid' `exexog1' `inexog1' /*
					*/ `wtexp' if `touse', `noconstant'
				mat `S' = `sigmasq'*`ZZ'*(1/`Nprec')
				mat `Sinv' = syminv(`S')
				mat `uZWZu' = (`kclassZu'/`Nprec')*`Sinv'*(`kclassZu''/`Nprec')
				scalar `j' = `Nprec'*`uZWZu'[1,1]
			}


			if "`robust'`cluster'"!="" {
				tsrevar `exexog1' `inexog1'
				local TSinsts1 `r(varlist)'
* Create identity matrix with matching col/row names
				mat `S'=I(colsof(`ivZu'))
				if "`noconstant'"=="" {
					mat colnames `S' = `TSinsts1' "_cons"
					mat rownames `S' = `TSinsts1' "_cons"
				}
				else {
					mat colnames `S' = `TSinsts1'
					mat rownames `S' = `TSinsts1'
				}
				_robust `lresid' `wtexp' if `touse', variance(`S') `clopt' minus(0)
				if "`cluster'"!="" {
					local N_clust=r(N_clust)
				}
				mat `S' = `S'*1/`Nprec'
* To give S the right col/row names
				mat `S'=`S'+0*diag(`ivZu')
				mat `S'=(`S'+`S'')/2
				mat `Sinv'=syminv(`S')
				local rankS = rowsof(`Sinv') - diag0cnt(`Sinv')
				if "`coviv'"== "" {
* Use LIML or k-class cov matrix
					mat `V'=`XhXhinv'*`XZ'*`ZZinv'*`S'*`Nprec'*  /*
						*/ `ZZinv'*`XZ''*`XhXhinv'
				}
				else {
* Use IV cov matrix
					mat `V'=`XPZXinv'*`XZ'*`ZZinv'*`S'*`Nprec'*  /*
						*/ `ZZinv'*`XZ''*`XPZXinv'
				}
				mat `V'=(`V'+`V'')/2
			}

			if "`robust'`cluster'"=="" {
				mat `S' = `sigmasq'*`ZZ'*(1/`Nprec')
				if "`coviv'"== "" {
* LIML or k-class cov matrix
					mat `V'=`sigmasq'*`XhXhinv'
				}
				else {
* IV cov matrix
					mat `V'=`sigmasq'*`XPZXinv'
				}
				mat `V'=(`V'+`V'')/2
			}
		}
* End of LIML/k-class block

********************************************************************************
* Counts, dofs, F-stat, small-sample corrections, hascons

* Counts modified to include constant if appropriate
		if "`noconstant'"=="" {
			local iv1_ct  = `iv1_ct' + 1
			local rhs1_ct = `rhs1_ct' + 1
		}
* Correct count of rhs variables accounting for dropped collinear vars
* Count includes constant
* Will take account of extraneous _cons (with zero coeff) if hascons
		local rhs_ct=colsof(`B')
		local i 1
		while `i' <= colsof(`B') {
			if `B'[1,`i']==0 {
				local rhs_ct = `rhs_ct'-1
			}
			local i = `i'+1
		}
		if "`noconstant'"=="" {
			local df_m = `rhs_ct' - 1
		}
		else {
			local df_m = `rhs_ct'
		}
		if "`cluster'"=="" {
			local df_r = `N' - `rhs_ct'
		}
		else {
* To match Stata, subtract 1 (why 1 and not `rhs_ct' is a mystery)
			local df_r = `N_clust' - 1
		}


* Sargan-Hansen J dof and p-value
		local jdf = `iv_ct' - `rhs_ct'
		if `jdf' == 0 {
			scalar `j' = 0
		}
		else {
			scalar `jp' = chiprob(`jdf',`j')
		}

* Small sample corrections for var-cov matrix.
* If robust, the finite sample correction is N/(N-K), and with no small
* we change this to 1 (a la Davidson & MacKinnon 1993, p. 554, HC0).
* If cluster, the finite sample correction is (N-1)/(N-K)*M/(M-1), and with no small
* we change this to 1 (a la Wooldridge 2002, p. 193), where M=number of clusters.
* In the adj of the V matrix for non-small, we use Nprec instead of N because
* iweights rounds off N.  Note that iweights are not allowed with robust
* but we use Nprec anyway to maintain consistency of code.
		if "`small'" != "" {
			if "`cluster'"=="" {
				matrix `V'=`V'*`Nprec'/(`Nprec'-`rhs_ct')
			}
			else {
				matrix `V'=`V'*(`Nprec'-1)/(`Nprec'-`rhs_ct') /*
					*/    * `N_clust'/(`N_clust'-1)
			}
			scalar `sigmasq'=`rss'/(`Nprec'-`rhs_ct')
			scalar `rmse'=sqrt(`sigmasq')
		}

		scalar `r2u'=1-`rss'/`yy'
		scalar `r2c'=1-`rss'/`yyc'
		if "`noconstant'"=="" {
			scalar `r2'=`r2c'
			scalar `r2_a'=1-(1-`r2')*(`Nprec'-1)/(`Nprec'-`rhs_ct')
		}
		else {
			scalar `r2'=`r2u'
			scalar `r2_a'=1-(1-`r2')*`Nprec'/(`Nprec'-`rhs_ct')
		}

* hascons code - check if true/false
* Strip out extraneous _cons in last col if hascons true
* Report error if hascons false and reset macro to empty string
* True if _cons in last column and coeff==0, false if !=0
		if "`hascons'"!="" {
			local cn : colnames `B'
			local cn : subinstr local cn "_cons" "_cons" , word count(local hc)
			if `hc' == 1 {
				if `B'[1,colsof(`B')]==0 {
					matrix `B'=`B'[1,1..colsof(`B')-1]
					matrix `V'=`V'[1..rowsof(`V')-1,1..colsof(`V')-1]
				}
				else {
di in gr "nb: hascons false"
					local hascons ""
				}
			}
		}

* Fstat
* To get it to match Stata's, must post separately with dofs and then do F stat by hand
*   in case weights generate non-integer obs and dofs
* Create copies so they can be posted
		tempname FB FV
		mat `FB'=`B'
		mat `FV'=`V'
		capture est post `FB' `FV'
* If the cov matrix wasn't positive definite, the post fails with error code 506
		local rc = _rc
		if `rc' != 506 {
* If hascons, remove the relevant collinearity so as to get the right F-stat
			if "`hascons'" == "" {
				local Frhs1 `rhs1'
			}
			else {
				quietly _rmcoll `rhs1' if `touse' `wtexp'
				local Frhs1 `r(varlist)'
			}
			capture test `Frhs1'
			if "`small'" == "" {
				if "`cluster'"=="" {
					capture scalar `F' = r(chi2)/`df_m' * `df_r'/`Nprec'
				}
				else {
					capture scalar `F' = r(chi2)/`df_m' * /*
						*/ (`N_clust'-1)/`N_clust' * (`Nprec'-`rhs_ct')/(`Nprec'-1)
				}
			}
			else {
				capture scalar `F' = r(chi2)/`df_m'
			}
			capture scalar `Fp'=Ftail(`df_m',`df_r',`F')
			capture scalar `Fdf2'=`df_r'
		}

* If j==. or vcv wasn't full rank, then vcv problems and F is meaningless
		if `j' == . | `rc'==506 {
			scalar `F' = .
			scalar `Fp' = .
		}


* End of counts, dofs, F-stat, small sample corrections, hascons
****************************************************************************************

* orthog option: C statistic (difference of Sargan statistics)
* Requires j dof from above
		if "`orthog'"!="" {
* Initialize cstat
			local cstat 0
* Each variable listed must be in instrument list.
* To avoid overwriting, use cendo, cinexog1, cexexog, cendo_ct, cex_ct
			local cendo1   "`endo1'"
			local cinexog1 "`inexog1'"
			local cexexog1 "`exexog1'"
			local cinsts1  "`insts1'"
			local crhs1    "`rhs1'"
			local clist1   "`orthog'"
			local clist_ct  : word count `clist1'

* Check to see if c-stat vars are in original list of all ivs
* cinexog1 and cexexog1 are after c-stat exog list vars have been removed
* cendo1 is endo1 after included exog being tested has been added
			foreach x of local clist1 {
				local llex_ct : word count `cexexog1'
				Subtract cexexog1 : "`cexexog1'" "`x'"
				local cex1_ct : word count `cexexog1'
				local ok = `llex_ct' - `cex1_ct'
				if (`ok'==0) {
* Not in excluded, check included and add to endog list if it appears
					local llin_ct : word count `cinexog1'
					Subtract cinexog1 : "`cinexog1'" "`x'"
					local cin1_ct : word count `cinexog1'
					local ok = `llin_ct' - `cin1_ct'
					if (`ok'==0) {
* Not in either list
di in r "Error: `x' listed in orthog() but does not appear as exogenous." 
						error 198
					}
					else {
						local cendo1 "`cendo1' `x'"
					}
				}
			}

* If robust, HAC/AC or GMM (but not LIML or IV), create optimal weighting matrix to pass to ivreg2
*   by extracting the submatrix from the full S and then inverting.
*   This guarantees the C stat will be non-negative.  See Hayashi (2000), p. 220. 
			if "`robust'`cluster'`gmm'`kernel'" != "" & "`liml'"=="" {
				tempname CSa CS CSinv
				if "`noconstant'" !="" {
					local cexin "`cexexog1' `cinexog1'"
				}
				else  {
					local cexin "`cexexog1' `cinexog1' _cons"
				}
				local v1 1
				foreach x of local cexin {
					if `v1'==1 {
					mat `CSa' = `S'[`"`x'"',.]
					local v1 0
					}
					else {
					mat `CSa' = `CSa' \ `S'[`"`x'"',.]
					}
				}
				local v1 1
				foreach x of local cexin {
					if `v1'==1 {
						mat `CS' = `CSa'[.,`"`x'"']
						local v1 0
					}
					else {
					mat `CS' = `CS', `CSa'[.,`"`x'"']
					}
				}
* Symmetrize before call to syminv
				mat `CS'=(`CS'+`CS'')/2
				mat `CSinv'=syminv(`CS')
			}

* Calculate C statistic with recursive call to ivreg2
* Collinearities may cause problems, hence -capture-.
			capture {
				tempname cj cstat cstatp
				estimates hold `ivest', restore

				if "`robust'`cluster'`gmm'`kernel'" == "" | "`liml'"!="" {
* Straight IV or LIML block
					capture ivreg2 `lhs' `cinexog1' /*
						*/ (`cendo1'=`cexexog1') if `touse' /*
						*/ `wtexp', `noconstant' `hascons' /*
						*/ `small' `liml' `options'
					local rc = _rc
					if `rc' == 481 {
						local cstat = 0
						local cstatdf = 0
						}
					else {
						if "`liml'"== "" {
* If not LIML, use MSE from original Sargan test to ensure p.d.
							scalar `cj'=e(sargan)*e(rss)/`rss'
							local cjdf=e(sargandf)
						}
						else {
							scalar `cj'=e(arubin)
							local cjdf=e(arubindf)
						}
						scalar `cstat' = `j' - `cj'
						local cstatdf  = `jdf' - `cjdf'
					}
				}
				else {
* Robust/HAC/AC/gmm block
					if "`kernel'" != "" {
						local bwopt "bw(`bw')"
						local kernopt "kernel(`kernel')"
					}
					capture ivreg2 `lhs' `cinexog1' /*
						*/ (`cendo1'=`cexexog1') /*
						*/ if `touse' `wtexp', `noconstant' /*
						*/ `hascons' `small' `options' `robust' /*
						*/ `clopt' `gmm' `bwopt' `kernopt' /*
						*/ wmatrix("`CSinv'")
					local rc = _rc
					if `rc' == 481 {
						local cstat = 0
						local cstatdf = 0
						}
					else {
						if "`e(vcetype)'"=="Robust" {
* Robust/HAC => J
							scalar `cj'=e(j)
							local cjdf=e(jdf)
							}
						else {
* AC => Sargan
							scalar `cj'=e(sargan)
							local cjdf=e(sargandf)
							}
						scalar `cstat' = `j' - `cj'
						local cstatdf  = `jdf' - `cjdf'
					}
				}
				estimates unhold `ivest'
				scalar `cstatp'= chiprob(`cstatdf',`cstat')
* Collinearities may cause C-stat dof to differ from the number of variables in orthog()
* If so, set cstat=0
				if `cstatdf' != `clist_ct' {
					local cstat = 0
				}
			}
		}
* End of orthog block
*********************************************************************************************

* Error-checking block

* Check if adequate number of observations
		if `N' <= `iv_ct' {
di in r "Error: number of observations must be greater than number of instruments"
di in r "       including constant."
			error 2001
		}

* Check if adequate number of clusters
		if "`cluster'" != "" {
			if `N_clust' <= `iv_ct' {
di in r "Error: number of clusters must be greater than number of instruments"
				error 498
			}
		}

* Check if robust VCV matrix is of full rank
		if "`gmm'`robust'`cluster'`kernel'" != "" {
* Robust covariance matrix not of full rank means either a singleton dummy (in which
*   case the indiv SEs are OK but no F stat or 2-step GMM is possible), or
*   there are too few clusters, or too many AC/HAC-lags, or the HAC covariance estimator
*   isn't positive definite (possible with truncated and Tukey-Hanning kernels)
			if `rankS' < `iv_ct' {
* If two-step GMM then exit with error ...
				if "`gmm'" != "" {
di in r "Error: estimated covariance matrix of moment conditions not of full rank;"
di in r "       cannot calculate optimal weighting matrix for GMM estimation."
di in r "Possible causes:"
					if "`cluster'" != "" {
di in r "  number of clusters insufficient to calculate optimal weighting matrix"
					}
					if "`kernel'" != "" {
di in r "  estimated covariance matrix of moment conditions not positive definite"
di in r "  estimated covariance matrix uses too many lags"
					}
di in r "  singleton dummy variable (dummy with 1 one and N-1 zeros or visa-versa)"
					error 498
				}
* Estimation isn't two-step GMM so continue but J, F, and C stat (if present) all meaningless
*   and VCV is also meaningless unless the cause is a singleton dummy
* Must set Sargan-Hansen j = missing so that problem can be reported in output
				else {
					scalar `j' = .
					if "`orthog'"!="" {
						`cstat' = .
					}
				}
			}
		}

* End of error-checking block
********************************************************************************************

* First stage regression option
* Code here because it relies on proper count of (non-collinear) IVs
* generated earlier
* Note that nocons option + constant in instrument list means first-stage
* regressions are reported with nocons option.  First-stage F-stat therefore
* correctly includes the constant as an explanatory variable.

		if "`first'`ffirst'" != ""  & (`endo1_ct' > 0) {
* For Godfrey method of Shea partial R2, need IV and OLS estimates without robust vces
			tempname olsV ivV godfrey ols_s2 sols siv vrat ivest
			tempname firstmat sheapr2 pr2 pr2F pr2p

* ivV and iv_s2 are without small sample adjustment
			mat `ivV'=`iv_s2'*`XPZXinv'

			estimates hold `ivest'
* Call to ivreg2 to get vcv and sigma-squared without small sample adjustment
			qui ivreg2 `lhs' `rhs1'  /*
					*/ if `touse' `wtexp', `noconstant' `hascons'

			mat `olsV' = e(V)
			scalar `ols_s2' = e(rmse)^2
			estimates unhold `ivest'

			scalar `vrat' = `iv_s2'/`ols_s2'
			mat `godfrey' = J(1,`endo1_ct',0)
			mat colnames `godfrey' = `endo1'
			mat rownames `godfrey' = "sheapr2"
			local i 1
			foreach w of local endo1 {
				mat `sols'=`olsV'["`w'","`w'"]
				mat `siv'=`ivV'["`w'","`w'"]
				mat `godfrey'[1,`i'] = `vrat'*`sols'[1,1]/`siv'[1,1]
				local i = `i'+1
				}

			di in gr _newline "First-stage regressions"
			di in smcl in gr "{hline 23}"
			if `iv1_ct' > `iv_ct' {
di in gr "Warning: collinearities detected among instruments"
di in gr "1st stage tests of excluded exogenous variables may be incorrect"
			}
			di

			doFirst "`endo1'" "`inexog1'" "`exexog1'" /*
				*/ `touse' `"`wtexp'"' `"`noconstant'"' `"`robust'"' /*
				*/ `"`clopt'"' `"`bwopt'"' `"`kernopt'"' `"`ffirst'"'

			capture mat `firstmat'=`godfrey' \ r(firstmat)
			if _rc==0 {
di in gr "Summary results for first-stage regressions:"
di
di in gr    "                Shea"
di in gr _c "Variable      Partial R2      Partial R2       F("
di in gr %3.0f `firstmat'[4,1] "," %6.0f `firstmat'[5,1] ")    P-value"
				local i = 1
				local nrvars : word count `endo1'
				while `i' <= `nrvars' {
					local vn : word `i' of `endo1'
					scalar `sheapr2'=`firstmat'[1,`i']
					scalar `pr2'=`firstmat'[2,`i']
					scalar `pr2F'=`firstmat'[3,`i']
					scalar `pr2p'=`firstmat'[6,`i']
di in y %-12s "`vn'" _col(15) %8.4f `sheapr2' _col(31) %8.4f `pr2' /*
	*/ _col(49) %8.2f `pr2F' _col(64) %8.4f `pr2p'
					local i = `i' + 1
				}
				di
				if "`robust'`cluster'" != "" {
					if "`cluster'" != "" {
di in gr "NB: first-stage F-stat cluster-robust"
					}
					else if "`kernel'" != "" {
di in gr "NB: first-stage F-stat heteroskedasticity and autocorrelation-consistent"
					}
					else {
di in gr "NB: first-stage F-stat heteroskedasticity-robust"
					}
					di
				}
				else if "`kernel'" != "" {
di in gr "NB: first-stage F-stat autocorrelation-consistent"
				}
				di
			}
			else {
di in ye "Warning: missing values encountered; first stage regression results not saved"
			}
		}
* End of first-stage regression code
**********************************************************************************************

* Post results.

* NB: Would like to use -Nprec- in obs() in case weights generate non-integer obs
*     but Stata complains.  Using -Nprec- with dof() makes no difference - seems to round it
		if "`small'"!="" {
			local NminusK = `N'-`rhs_ct'
			capture est post `B' `V', dep(`depname') obs(`N') esample(`touse') /*
				*/ dof(`NminusK')
			local rc = _rc
			if `rc' == 506 {
di in red "Error: estimated variance-covariance matrix not positive-definite"
				exit 506
			}
		}
		else {
			capture est post `B' `V', dep(`depname') obs(`N') esample(`touse')
			local rc = _rc
			if `rc' == 506 {
di in red "Error: estimated variance-covariance matrix not positive-definite"
				exit 506
			}
		}
		est local instd `endo1'
		local insts : colnames `S'
		local insts : subinstr local insts "_cons" ""
		est local insts `insts'

		if "`gmm'"!="" | "`kernel'"!="" {
			est matrix W `Sinv'
		}

		if "`wmatrix'" == "" {
			est matrix S `S'
		}

		if "`kernel'"!="" {
			est local kernel "`kernel'"
			est scalar bw=`bw'
			est local tvar "`tvar'"
			if "`ivar'" ~= "" {
				est local ivar "`ivar'"
			}
		}

		if "`small'"!="" {
			est scalar df_r=`df_r'
			est local small "small"
		}

		if "`cluster'"!="" {
			est scalar N_clust=`N_clust'
			est local clustvar `cluster'
		}

		if "`robust'`cluster'" != "" {
			estimates local vcetype "Robust"
		}

		est scalar df_m=`df_m'
		est scalar r2=`r2'
		est scalar rmse=`rmse'
		est scalar rss=`rss'
		est scalar mss=`mss'
		est scalar r2_a=`r2_a'
		est scalar F=`F'
		est scalar Fp=`Fp'
		est scalar Fdf2=`Fdf2'
		est scalar yy=`yy'
		est scalar yyc=`yyc'
		est scalar r2u=`r2u'
		est scalar r2c=`r2c'
		est scalar rankzz=`iv_ct'
		if "`gmm'`robust'`cluster'`kernel'" != "" {
			est scalar rankS=`rankS'
		}
		est scalar rankxx=`rhs_ct'

		if "`liml'"!="" {
			est scalar arubin=`j'
			est scalar arubindf=`jdf'
			if `j' != 0  & `j' != . {
				est scalar arubinp=`jp'
			}
		}
		else if ("`robust'`cluster'"=="") | ("`kclass'" != "") {
			est scalar sargan=`j'
			est scalar sargandf=`jdf'
			if `j' != 0  & `j' != . {
				est scalar sarganp=`jp'
			}
		}
		else {
			est scalar j=`j'
			est scalar jdf=`jdf'
			if `j' != 0 & `j' != . {
				est scalar jp=`jp'
			}
		}

		if "`orthog'"!="" {
			est scalar cstat=`cstat'
			if `cstat'!=0  & `cstat' != . {
				est scalar cstatp=`cstatp'
				est scalar cstatdf=`cstatdf'
				est local clist `clist1'
			}
		}
		if "`first'`ffirst'" != "" & `endo1_ct'>0 {
* Capture here because firstmat empty if mvs encountered in 1st stage regressions
			capture est matrix first `firstmat'
		}
		est local depvar `lhs'

		if "`liml'"!="" {
			est local model "liml"
			est scalar kclass=`kclass2'
			est scalar lambda=`lambda'
			if `fuller' > 0 & `fuller' < . {
				est scalar fuller=`fuller'
			}
		}
		else if "`kclass'" != "" {
			est local model "kclass"
			est scalar kclass=`kclass2'
		}
		else if "`gmm'"=="" {
			if "`endo1'" == "" {
				est local model "ols"
			}
			else {
				est local model "iv"
			}
		}
		else {
			est local model "gmm"
		}

		if "`weight'" != "" { 
			est local wexp "=`wtexp'"
			est local wtype `weight'
		}
		est local cmd ivreg2
		est local version `version'
		if "`noconstant'`hascons'"!="" {
			est scalar cons=0
		}
		else {
			est scalar cons=1
		}
		est local predict "ivreg2_p"
		
* pscore option
		if `"`pscore'"' != "" {
			quietly ivreg2_p double `pscore' if e(sample), residuals
			est local pscorevars `pscore'
		}
	}


	
***************************************************************
* Display results

* Prepare for problem resulting from rank(S) being insufficient
* Results from insuff number of clusters, too many lags in HAC,
*   to calculate robust S matrix, HAC matrix not PD, singleton dummy,
*   and indicated by missing value for j stat
* Macro `rprob' is either 1 (problem) or 0 (no problem)
	capture local rprob ("`e(j)'"=="." | "`e(sargan)'"=="." | "`e(arubin)'"==".")

	if "`noheader'"=="" {
		if "`e(model)'"=="liml" {
			if "`e(instd)'"=="" {
				if "`e(vcetype)'" == "Robust" {
di in gr _n "Maximum likelihood (ML) regression with robust standard errors"
di in gr "{hline 62}"
				}
				else {
di in gr _n "Maximum likelihood (ML) regression"
di in gr "{hline 34}"
				}
			}
			else {
				if "`e(vcetype)'" == "Robust" {
di in gr _n "LIML regression with robust standard errors"
di in gr "{hline 43}"
				}
				else {
di in gr _n "Limited-Information Maximum Likelihood (LIML) regression"
di in gr "{hline 56}"
				}
			}
		}
		else if "`e(model)'"=="kclass" {
			if "`e(vcetype)'" == "Robust" {
di in gr _n "k-class regression with robust standard errors"
di in gr "{hline 46}"
			}
			else {
di in gr _n "k-class estimation"
di in gr "{hline 18}"
			}
		}
		else if "`e(model)'"=="gmm" {
			if "`e(instd)'"=="" {
di in gr _n "HOLS-GMM estimation"
di in gr "{hline 19}"
			}
			else {
di in gr _n "GMM estimation"
di in gr "{hline 14}"
			}
		}
		else {
			if "`e(instd)'"=="" {
				if "`e(vcetype)'" == "Robust" {
di in gr _n "OLS regression with robust standard errors"
di in gr "{hline 42}"
				}
				else {
di in gr _n "Ordinary Least Squares (OLS) regression"
di in gr "{hline 39}"
				}
			}
			else {
				if "`e(vcetype)'" == "Robust" {
di in gr _n "IV (2SLS) regression with robust standard errors"
di in gr "{hline 48}"
				}
				else {
di in gr _n "Instrumental variables (2SLS) regression"
di in gr "{hline 40}"
				}
			}
		}
		if "`e(model)'"=="liml" | "`e(model)'"=="kclass" {
di in gr "k               =" %7.5f `e(kclass)'
		}
		if "`e(model)'"=="liml" {
di in gr "lambda          =" %7.5f `e(lambda)'
		}
		if e(fuller) > 0 & e(fuller) < . {
di in gr "Fuller parameter=" %-5.0f `e(fuller)'
		}
		if "`e(kernel)'"!="" {
			if "`e(vcetype)'" == "Robust" {
di in gr "Heteroskedasticity and autocorrelation-consistent statistics"
			}
			else {
di in gr "Autocorrelation-consistent statistics"
			}
di in gr "  kernel=`e(kernel)'; bandwidth=`e(bw)'"
di in gr "  time variable (t):  " in ye e(tvar)
			if "`e(ivar)'" != "" {
di in gr "  group variable (i): " in ye e(ivar)
			}
		}
		di
		if "`e(clustvar)'"!="" {
di in gr "Number of clusters (" "`e(clustvar)'" ") = " in ye %-4.0f e(N_clust) _continue
		}
		else {
di in gr "                                   " _continue
		}
di in gr _col(55) "Number of obs = " in ye %8.0f e(N)

		if "`e(clustvar)'"=="" {
			local Fdf2=e(N)-e(rankxx)
		}
		else {
			local Fdf2=e(N_clust)-1
		}

* No F stat for GMM of any flavour
*		if "`e(model)'" != "gmm" & "`e(kernel)'"=="" {
di in gr _c _col(55) "F(" %3.0f e(df_m) "," %6.0f e(Fdf2) ") = "
			if e(F) < 99999 {
di in ye %8.2f e(F)
			}
			else {
di in ye %8.2e e(F)
			}
di in gr _col(55) "Prob > F      = " in ye %8.4f e(Fp)
*		}
di in gr "Total (centered) SS     = " in ye %12.0g e(yyc) _continue
di in gr _col(55) "Centered R2   = " in ye %8.4f e(r2c)
di in gr "Total (uncentered) SS   = " in ye %12.0g e(yy) _continue
di in gr _col(55) "Uncentered R2 = " in ye %8.4f e(r2u)
di in gr "Residual SS             = " in ye %12.0g e(rss) _continue
di in gr _col(55) "Root MSE      = " in ye %8.1g e(rmse)
di
	}

* Display coefficients etc.
* Unfortunate but necessary hack here: to suppress message about cluster adjustment of
*   standard error, clear e(clustvar) and then reset it after display
	local cluster `e(clustvar)'
	est local clustvar
	est di, `plus' `efopt' level(`level')
	est local clustvar `cluster'

* Display footer
* Footer not displayed if -nofooter- option or if pure OLS, i.e., model="ols" and Sargan-Hansen=0
	if ~("`nofooter'"~="" | (e(model)=="ols" & (e(sargan)==0 | e(j)==0))) {
* Report either (a) Sargan-Hansen-C stats, or (b) robust covariance matrix problem
		if `rprob' == 0 {
* Display overid statistic
			if "`e(model)'" == "liml" {
				if "`e(instd)'" != "" {
di in gr _c "Anderson-Rubin statistic (overidentification test of all instruments): "
				}
				else {
di in gr _c "Anderson-Rubin statistic (LR test of excluded instruments): "
				}
di in ye _col(72) %7.3f e(arubin)
				local overiddf e(arubindf)
				local overidp e(arubinp)
			}
			else if "`e(vcetype)'" == "Robust" & "`e(model)'" != "kclass" {
				if "`e(instd)'" != "" {
di in gr _c "Hansen J statistic (overidentification test of all instruments): "
				}
				else {
di in gr _c "Hansen J statistic (Lagrange multiplier test of excluded instruments): "
				}
di in ye _col(72) %7.3f e(j)
				local overiddf e(jdf)
				local overidp e(jp)
			}
			else {
				if "`e(instd)'" != "" {
di in gr _c "Sargan statistic (overidentification test of all instruments): "
				}
				else {
di in gr _c "Sargan statistic (Lagrange multiplier test of excluded instruments): "
				}
di in ye _col(72) %7.3f e(sargan)
				local overiddf e(sargandf)
				local overidp e(sarganp)
			}
			if e(rankxx) < e(rankzz) {
di in gr _col(52) "Chi-sq(" in ye `overiddf' /* 
	       			*/  in gr ") P-val =  " in ye _col(72) %6.5f `overidp'
			}
			else {
di in gr _col(50) "(equation exactly identified)"
			}

* Display orthog option: C statistic (difference of Sargan statistics)
			if e(cstat) != . {
* If C-stat = 0 then warn, otherwise output
				if e(cstat) > 0  {
di in gr "-orthog- option:"
					if "`e(model)'" == "liml" {
						tempname arubin_u arubindf_u arubinp_u
						scalar `arubin_u'=e(arubin)-e(cstat)
						scalar `arubindf_u'=e(arubindf)-e(cstatdf)
						scalar `arubinp_u' = chiprob(`arubindf_u',`arubin_u')
di in gr _c "Anderson-Rubin statistic for unrestricted equation: "
di in ye _col(73) %6.3f `arubin_u'
di in gr _col(52) "Chi-sq(" in ye `arubindf_u' /* 
	       			*/  in gr ") P-val =  " in ye _col(72) %6.5f `arubinp_u'
					}
					else if "`e(vcetype)'" == "Robust" & "`e(model)'" != "kclass" {
						tempname j_u jdf_u jp_u
						scalar `j_u'=e(j)-e(cstat)
						scalar `jdf_u'=e(jdf)-e(cstatdf)
						scalar `jp_u' = chiprob(`jdf_u',`j_u')
di in gr _c "Hansen J statistic for unrestricted equation: "
di in ye _col(73) %6.3f `j_u'
di in gr _col(52) "Chi-sq(" in ye `jdf_u' /* 
	       			*/  in gr ") P-val =  " in ye _col(72) %6.5f `jp_u'
					}
					else {
						tempname sargan_u sargandf_u sarganp_u
						scalar `sargan_u'=e(sargan)-e(cstat)
						scalar `sargandf_u'=e(sargandf)-e(cstatdf)
						scalar `sarganp_u' = chiprob(`sargandf_u',`sargan_u')
di in gr _c "Sargan statistic for unrestricted equation: "
di in ye _col(73) %6.3f `sargan_u'
di in gr _col(52) "Chi-sq(" in ye `sargandf_u' /* 
	       			*/  in gr ") P-val =  " in ye _col(72) %6.5f `sarganp_u'
					}
di in gr _c "C statistic (exogeneity/orthogonality of specified instruments): "
di in ye _col(73) %6.3f e(cstat)
di in gr _col(52) "Chi-sq(" in ye e(cstatdf) /* 
	       			*/  in gr ") P-val =  " in ye _col(72) %6.5f e(cstatp)
di in gr "Instruments tested: " _c
					Disp `e(clist)'
				}
				if e(cstat) == 0 {
di in gr _n "Collinearity/identification problems in restricted equation:"
di in gr "  C statistic not calculated for orthog option"
				}
			}
		}
		else {
* Problem exists with robust VCV - notify and list possible causes
di in r "Error: covariance matrix of moment conditions not of full rank; specification"
di in r "       test stats not reported and standard errors above may be meaningless"
di in r "Possible causes:"
			if e(N_clust) < e(rankzz) {
di in r "  number of clusters insufficient to calculate robust covariance matrix"
			}
			if "`e(kernel)'" != "" {
di in r "  estimated covariance matrix of moment conditions not positive definite"
di in r "  estimated covariance matrix uses too many lags"
			}
di in r "  singleton dummy variable (dummy with 1 one and N-1 zeros or visa-versa)"
		}

		di in smcl in gr "{hline 78}"

* Warn about dropped instruments if any
* (Re-)calculate number of user-supplied instruments
		local iv1_ct : word count `e(insts)'
		local iv1_ct = `iv1_ct' + `e(cons)'

		if `iv1_ct' > e(rankzz) {
di in gr "Collinearities detected among instruments: " _c
di in gr `iv1_ct'-e(rankzz) " instrument(s) dropped"
		}

		if "`e(instd)'" != "" {
			di in gr "Instrumented:  " _c
			Disp `e(instd)'
		}

		di in gr "Instruments:   " _c
		Disp `e(insts)'

		di in smcl in gr "{hline 78}"
	}

end

* End of ivreg2
**************************************************************************************

program define IsStop, sclass
				/* sic, must do tests one-at-a-time, 
				 * 0, may be very large */
	if `"`0'"' == "[" {		
		sret local stop 1
		exit
	}
	if `"`0'"' == "," {
		sret local stop 1
		exit
	}
	if `"`0'"' == "if" {
		sret local stop 1
		exit
	}
* per official ivreg 5.1.3
	if substr(`"`0'"',1,3) == "if(" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "in" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "" {
		sret local stop 1
		exit
	}
	else	sret local stop 0
end

program define Disp 
	local first ""
	local piece : piece 1 64 of `"`0'"'
	local i 1
	while "`piece'" != "" {
		di in gr "`first'`piece'"
		local first "               "
		local i = `i' + 1
		local piece : piece `i' 64 of `"`0'"'
	}
	if `i'==1 { di }
end

* Performs first-stage regressions

program define doFirst, rclass
	args	    endog	/*  variable list  (including depvar)
		*/  inexog	/*  list of included exogenous
		*/  exexog	/*  list of excluded exogenous
		*/  touse	/*  touse sample
		*/  weight	/*  full weight expression w/ []
		*/  nocons	/*
		*/  robust	/*
		*/  clopt	/*
		*/  bwopt	/*
		*/  kernopt	/*
		*/  ffirst	/*  display f-stat only */

	tokenize `endog'
	tempname statmat statmat1
	local i 1
	while "``i''" != "" {
* di in gr "First-stage regression of ``i'':"
		if "`ffirst'" != "" {
			capture ivreg2 ``i'' `inexog' `exexog' `weight' /*
				*/ if `touse', `nocons' `robust' `clopt' `bwopt' `kernopt' small
		}
		else {
di in gr "First-stage regression of ``i'':"
			ivreg2 ``i'' `inexog' `exexog' `weight' /*
				*/ if `touse', `nocons' `robust' `clopt' `bwopt' `kernopt' small
		}
		tempvar y2 iota xhat
		tempname ysum yy rssall rssinc pr2 F p
		quietly predict double `xhat' if `touse', xb
		local endoghat "`endoghat' `xhat'"
		quietly test `exexog'
		scalar `F'=r(F)
		scalar `p'=r(p)
		local df=r(df)
		local df_r=r(df_r)
		scalar `rssall'=e(rss)
		qui gen double `y2'=``i''^2
* Stata summarize won't work with iweights, so must use matrix cross-product
		qui gen `iota'=1
		qui matrix vecaccum `ysum' = `iota' `y2' `weight' if `touse', noconstant
		scalar `yy'=`ysum'[1,1]
* 1st stage regression without excluded exogenous
		capture ivreg2 ``i'' `inexog' `weight' /*
			*/ if `touse', `nocons' `robust' `clopt' `bwopt' `kernopt' small
		scalar `rssinc'=e(rss)
* NB: uncentered R2 for main regression is 1-rssall/yy; for restricted is 1-rssinc/yy;
*     squared semipartial correlation=(rssinc-rssall)/yy=diff of 2 R2s
* Squared partial correlation (="partialled-out R2")
		scalar `pr2'=(`rssinc'-`rssall')/`rssinc'
		if "`ffirst'" == "" {
di in gr "Partial R-squared of excluded instruments: " _c
di in ye %8.4f `pr2'
di in gr "Test of excluded instruments:"
di in gr "  F(" %3.0f `df' "," %6.0f `df_r' ") = " in ye %8.2f `F'
di in gr "  Prob > F      = " in ye %8.4f `p'
di
		}
		capture {
			mat `statmat1' = (`pr2' \ `F' \ `df' \ `df_r' \ `p')
			mat colname `statmat1' = ``i''
			if `i'==1 {mat `statmat'=`statmat1'}
				else {mat `statmat' = `statmat' , `statmat1'}
		}
		local i = `i' + 1
	}
	capture mat rowname `statmat' = pr2 F df df_r pvalue
	if _rc==0 {
		return matrix firstmat `statmat'
	}
end

*  Remove all tokens in dirt from full
*  Returns "cleaned" full list in cleaned

program define Subtract   /* <cleaned> : <full> <dirt> */
	args	    cleaned     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  full	/*  list to be cleaned 
		*/  dirt	/*  tokens to be cleaned from full */
	
	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	tokenize `full'			/* cleans up extra spaces */
	c_local `cleaned' `*'       
end

exit

