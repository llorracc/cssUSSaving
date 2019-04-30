
Replication Archive for:

DISSECTING SAVING DYNAMICS: MEASURING WEALTH, PRECAUTIONARY AND
CREDIT EFFECTS

Christopher Carroll, Jiri Slacalek, Martin Sommer
April 25, 2019
*********************************************************************************************

Folders:

** stata	Stata programs to replicate Tables 2 and 3, and Figures
1(b), 4 and 7
		Use Stata 15.0 to run them and make sure the variable basePath (eg, global basePath "J:\cssUSsaving\20190424";) contains the correct path to the archive
		* _drawMotivationGraphs.do	Generates Figure 1(a)
		* _drawAdditionalCharts_01.do	Generates Figure 5
		* _tableRFregressions_base_10_all.do	Generates Figure 3 and Tables 2 and 3; for Table 2 set "global savingSeriesIndex "PSR";" for Table 3 set "global savingSeriesIndex "model";"	



** matlab	Matlab programs to replicate Table 1 and Figures 1(a)
and 6
		* estStructModel_main_pars4_mho.m	Table 1 and Figures 1(a) and 4; note: the full estimation [minimizeObjFuncInd = 1] takes about 30 hours; otherwise [minimizeObjFuncInd = 0] about 1 hour. The programs were run on Matlab R2017a and use the modified Matlab programs for Carroll and Toche (2009), http://econ.jhu.edu/people/ccarroll/papers/ctDiscrete
		
		
