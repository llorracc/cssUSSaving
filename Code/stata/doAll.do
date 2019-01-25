
**********************************************************************************
* Execute all Stata programs for the cssUSsaving project
**********************************************************************************
clear
#delimit;
gr drop _all;

do setPath.do;
do drawMotivationGraphs.do;
do tableRFregressions_base.do;
do tableRFregressions_rob.do;
do tableDispIncome.do;




