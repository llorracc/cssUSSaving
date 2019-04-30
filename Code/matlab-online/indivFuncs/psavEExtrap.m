% This function takes a level of assets (above the highest Euler point) and
% returns the extrapolated value of precautionary saving using the
% parameters that were solved for in FindStableArm.

function x = psavEExtrap(scriptm,psavConsts)
%globalizeTBSvars;
ephi0=psavConsts(1);
phi1=psavConsts(2);
egamma0=psavConsts(3);
gamma1=psavConsts(4);
scriptmTop=psavConsts(5);

x = ephi0*exp(phi1*(scriptmTop-scriptm)) - egamma0*exp(gamma1*(scriptmTop-scriptm));
