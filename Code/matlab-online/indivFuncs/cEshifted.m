% This is the (employed) consumption function, which takes a single input of the level
% of assets and returns the consumption level at that value.  If the level
% of assets is below the highest Euler point, it uses the interpolated
% value.  Otherwise it uses the exponential extrapolation.

function scriptc = cEshifted(scriptm,debtLimPDV, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa)
%globalizeTBSvars;
%scriptm=scriptm+debtLimPDV;
scriptc=cE(scriptm+debtLimPDV, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa);
