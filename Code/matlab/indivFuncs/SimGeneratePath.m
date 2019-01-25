% This function simulates the path of consumption and assets given a
% starting level of assets and the number of periods to simulate over.

function mcPath = ...
SimGeneratePath(scriptmInitial,debtLimPDV,PeriodsToGo,EulerPoints,consumptionCoeffs,psavConstsAll,littleH,kappa,scriptmEBase,scriptcEBase,scriptR)
%globalizeTBSvars;
scriptcInitial = cEshifted(scriptmInitial,debtLimPDV, EulerPoints, consumptionCoeffs,psavConstsAll,littleH,kappa);

mcPath=zeros(PeriodsToGo+2,2);
mcPath(1:2,:) = [scriptmEBase scriptcEBase ; scriptmInitial scriptcInitial];

%keyboard;

for j = 1:PeriodsToGo
    mcPath(j+2,:) = SimAddAnotherPoint(mcPath(j+1,:),debtLimPDV, EulerPoints,consumptionCoeffs,psavConstsAll,littleH,kappa,scriptR);
end
