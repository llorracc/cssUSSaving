% The main file that estimates the structural model for cssUSsaving
clear all;
close all;
fclose('all');

UsingMatlab = 1;

thispath = mfilename('fullpath');
thisfile = mfilename;
pathlength = size(thispath,2);
namelength = size(thisfile,2);
CurDir = thispath(1:(pathlength-namelength));
cd(CurDir); path(CurDir,path);
path([CurDir 'SOEfiles'],path); path([CurDir 'indivScripts'],path); path([CurDir 'indivFuncs'],path); path([CurDir 'plotFiles'],path);
cd('figures');

delete([mfilename '.out']); diary([mfilename '.out']);
disp('==================================================================================');
disp(['Running  ' mfilename '.m                      ' datestr(now)]); format compact; tic;
disp('==================================================================================');

warning off MATLAB:nearlySingularMatrix;
format long;
minimizeObjFuncInd =0;  % Minimize objective function? Yes [1] takes about 36 hours!!


[dataOrig,txt] = xlsread('cssussavingdata_selection_20110831.xls'); 
%transformData;
time=(1960:.25:2011.25)';
saving_rate=dataOrig(:,1);
wyRat=dataOrig(:,2);
CEA=dataOrig(:,3);
unemp_pred=dataOrig(:,4);

wyRatSeries=wyRat(25:203);  % Note the series is lagged! (wealth is measured at the end of the quarter)
mhoSeries=unemp_pred(26:204)/100;
CEAseries=CEA(26:204);
time=time(26:204);
thetaBase=0.05;

cExAll=[]; cEyAll=[]; mcPathAll=[]; scriptmEBaseAll=[]; steadyStateMC=[]; PiAll=[];
PrecisionAugmentationFactor=1;
myoptions = optimset('fminsearch');
myoptions = optimset(myoptions, 'TolX', 1.0e-006 ,'TolFun', 1.0e-006, 'MaxFunEvals', 1000000, 'MaxIter', 1000000,'Display','off');
initialValues=[0; .0003; 1; 4; 0.01];
data=[wyRatSeries mhoSeries CEAseries saving_rate(26:204)];

if minimizeObjFuncInd==1;
    [parametersM1, fvalM1, exitflag, output] = fminsearch('minCdist',initialValues, myoptions, data)
else;
    parametersM1=[0.000063217933389; 0.000260785069995; 0.875122279496263; 5.250441493574298; 0.006389908011468];
end;

[cRescaled_est,actualC,mhoRescaled_est,debtLimPDVrescaled_est,cRescaledFull_est,mRescaledFull_est] = minCdist_outputSeries(parametersM1, data);
mhoRescaled_mean=mean(mhoRescaled_est);
ceaRescaled_mean=mean(debtLimPDVrescaled_est);
CEAmean=mean(CEAseries);
UnempMean=mean(mhoSeries);

% Decomposition by Wealth/Uncertainty/CEA
switchOffMho=[mhoRescaled_mean; 0; parametersM1(3:5)];
[cRescaled_soMho,actualC,mhoRescaled_soMho,debtLimPDVrescaled_soMho,cRescaledFull_soMho,mRescaledFull_soMho] = minCdist_outputSeries(switchOffMho, data);

switchOffMhoCEA=[mhoRescaled_mean; 0; ceaRescaled_mean; 0; parametersM1(5)];
[cRescaled_soMhoCEA,actualC,mhoRescaled_soMhoCEA,debtLimPDVrescaled_soMhoCEA,cRescaledFull_soMhoCEA,mRescaledFull_soMhoCEA] = minCdist_outputSeries(switchOffMhoCEA, data);

close all;
savingRates=100*(1-[actualC,cRescaled_est]);
drawFigs_all;

modelDataSummary=[time savingRates [actualC,cRescaled_est]];
xlswrite('modelDataSummary.xls',modelDataSummary,'Data','A3');

d2=1e-5; nPars=length(parametersM1); delta=d2*parametersM1; dI=eye(nPars);
fprintf('Delta   %4.4g \n ',d2);

cRescaled=cRescaled_est;
nPers=length(cRescaled);
cRescaled0=cRescaled;
cPlusDelta=zeros(nPers,nPars); cMinusDelta=zeros(nPers,nPars);

for j=1:nPars;
    xPlusDelta=parametersM1+delta(j)*dI(:,j);
    [cRescaledPlusDelta,actualCPlusDelta,mhoRescaledPlusDelta,debtLimPDVrescaledPlusDeltaFull,cRescaledPlusDeltaFull,mRescaledPlusDeltaFull] = minCdist_outputSeries(xPlusDelta, data);
    cPlusDelta(:,j)=cRescaledPlusDelta;

    xMinusDelta=parametersM1-delta(j)*dI(:,j);
    [cRescaledMinusDelta,actualCMinusDelta,mhoRescaledMinusDelta,debtLimPDVrescaledMinusDeltaFull,cRescaledMinusDeltaFull,mRescaledMinusDeltaFull] = minCdist_outputSeries(xMinusDelta, data);
    cMinusDelta(:,j)=cRescaledMinusDelta;
    
end;

gradC=(cPlusDelta-repmat(cRescaled0,1,nPars))./repmat(delta',nPers,1); mean(gradC(:,1))
hessC=(cPlusDelta-2*repmat(cRescaled0,1,nPars)+cMinusDelta)./(repmat(delta',nPers,1)).^2; mean(hessC(:,1))

cMatrix=repmat((actualC-cRescaled0),1,nPars);
qScore=(-cMatrix).*(-gradC);
Ematrix=cov(qScore);

d2CdTheta2=zeros(nPers,nPars,nPars);
for i=1:nPars;
    for j=1:nPars;
        d2CdTheta2(:,i,j)=((cPlusDelta(:,i)-cRescaled0)-(cRescaled0-cMinusDelta(:,j)))/(delta(i)*delta(j));
    end;
end;
        
Dmatrix=repmat((actualC-cRescaled0),[1 nPars nPars]).*d2CdTheta2-repmat(gradC,[1 1 5]).*permute(repmat(gradC,[1 1 5]),[1 3 2]);
varTheta=pinv(squeeze(mean(Dmatrix)))*Ematrix*pinv(squeeze(mean(Dmatrix))');
sesAll=sqrt(diag(varTheta))
tStatsAll=parametersM1./sesAll
cError=actualC-cRescaled;
adjR2=1-var(cError)/var(actualC)*(nPers-1)/(nPers-nPars-1)
dwStat=sum(diff(cError).^2)/sum(cError.^2);

disp('Parameter   Std Error');
disp([parametersM1 sesAll]);
disp('t stats');
disp(tStatsAll);

writeStructEstTable;

%==========================================================================
t=toc; mints=floor(toc/60); secs=toc-60*mints;
fprintf('Time: %4.0f minutes, %4.2f seconds\n',mints,secs); diary off;
