% This function is used in the psavE function, and represents the fact that
% precautionary saving is the difference between consumption with perfect
% foresight and consumption under uncertainty.

function x = psavEInterp(scriptm,EulerPoints,consumptionCoeffs,littleH,kappa)
%globalizeTBSvars;
x = cEPF(scriptm,littleH,kappa) - cEInterp(scriptm,EulerPoints,consumptionCoeffs);
