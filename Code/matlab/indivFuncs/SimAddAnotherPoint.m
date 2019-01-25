% This function adds another consumption and asset point to a path of (m,c)
% points by using the appropriate time iterating functions.

function nextPoint = SimAddAnotherPoint(mcPath,debtLimPDV, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa,scriptR)
last = size(mcPath,1);
mNextVal = scriptmEtp1Fromt(mcPath(last,1),mcPath(last,2),scriptR);
cNextVal = cEshifted(mNextVal,debtLimPDV, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa);
nextPoint = [mNextVal cNextVal];
