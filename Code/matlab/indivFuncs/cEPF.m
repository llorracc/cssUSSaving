% This is the linear function that describes consumption under perfect
% foresight.  Note that the perfect foresight MPC is always kappa.

function x = cEPF(scriptm,littleH,kappa)
%globalizeTBSvars;
x = (scriptm - 1 + littleH) * kappa;
