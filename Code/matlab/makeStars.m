
% Carroll, Slacalek and Sommer: International Evidence on Sticky
% Consumption Growth
%
% This MATLAB program is called by t1stStage.m and produces a string of stars
% denoting statistical significance of tStat

function y=makeStars(tStat);
% makes 1-3 stars depening on the significance of tStat

ptest = 2*(1-normcdf(abs(tStat)));
ptest=max(ptest,0.0001);

y='^{}';
if .1/ptest>1; y='^{*}'; end;
if .05/ptest>1; y='^{**}'; end;
if .01/ptest>1; y='^{***}'; end;
