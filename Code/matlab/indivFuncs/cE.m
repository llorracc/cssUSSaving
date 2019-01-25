% This is the (employed) consumption function, which takes a single input of the level
% of assets and returns the consumption level at that value.  If the level
% of assets is below the highest Euler point, it uses the interpolated
% value.  Otherwise it uses the exponential extrapolation.

function scriptc = cE(scriptm, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa)
%globalizeTBSvars;
%scriptm=scriptm+debtLimPDV;
scriptmTop=psavConstsAll(5);
if scriptm < scriptmTop
    scriptc = cEInterp(scriptm, EulerPoints, consumptionCoeffs);
else
    scriptc = cEExtrap(scriptm,psavConstsAll,littleH,kappa);
end

