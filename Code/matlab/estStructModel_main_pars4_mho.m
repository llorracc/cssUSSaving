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
%cd('figures');

delete([mfilename '.out']); diary([mfilename '.out']);
disp('==================================================================================');
disp(['Running  ' mfilename '.m                      ' datestr(now)]); format compact; tic;
disp('==================================================================================');

warning off MATLAB:nearlySingularMatrix;
format long;
minimizeObjFuncInd = 0;  % Minimize objective function? Yes [1] takes about 36 hours!!
CutoffData=17;

%%% Prepare data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[dataOrig,txt] = xlsread('cssUSsavingData_20190124_forMatlab.xls'); 
dataOrig=dataOrig(1:end-CutoffData,:);  % 
%transformData;
time=(1960:.25:2016)';
saving_rate=dataOrig(:,1);
wyRat=dataOrig(:,2);
CEA=dataOrig(:,3);
unemp_pred=dataOrig(:,4);

psr=saving_rate(26:225-CutoffData);
wyRatSeries=wyRat(25:224-CutoffData);  % Note the series is lagged! (wealth is measured at the end of the quarter)
mhoSeries=unemp_pred(26:225-CutoffData)/100;
CEAseries=CEA(26:225-CutoffData);
time=time(26:225-CutoffData);
thetaBase=0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

recessionsI=zeros(size(time));
recessionsI(15:19)=1;
recessionsI(31:36)=1;
recessionsI(56:58)=1;
recessionsI(62:67)=1;
recessionsI(98:100)=1;
recessionsI(140:143)=1;
recessionsI(167:173)=1;

fPSR_actual=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,15.5*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,[psr]); %legend('m Bar');
axis tight; set(h,'linewidth',1.0,'color','black');
ylabel('Percent');
print(fPSR_actual,'-depsc','fPSR_actual.eps');
print(fPSR_actual,'-dpdf','fPSR_actual.pdf');
print(fPSR_actual,'-dpng','fPSR_actual.png');

%%% Estimate parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cExAll=[]; cEyAll=[]; mcPathAll=[]; scriptmEBaseAll=[]; steadyStateMC=[]; PiAll=[];
PrecisionAugmentationFactor=1;
myoptions = optimset('fminsearch');
%myoptions = optimset(myoptions, 'TolX', 1.0e-006 ,'TolFun', 1.0e-006, 'MaxFunEvals', 1000000, 'MaxIter', 1000000,'Display','off');
myoptions = optimset(myoptions,'TolX', 1.0e-002 ,'TolFun', 1.0e-004,'PlotFcns',@optimplotfval);

% Note that values for params are rescaled (to improve how tolerance tolX works)

% ordering of parameters [mho_const, mho_slope, CEA_slope, impatience]
% The last parameter is the log difference b/w the impatience factor and (\Gamma(1-Mho)^rho), so that: zeta = log( (R*beta)^(1/rho) - \Gamma((1-Mho)^rho) ).
% Starting value for zeta: log[ 1.0025*(1-10^-4)^2 - (1.01*0.9937)^(1/2) ]
% = log(.00048266) = -7.6
initialValues=[3; 1.5; 1; -7.6];  % alternative #1

data=[wyRatSeries mhoSeries CEAseries saving_rate(26:225-CutoffData)];

if minimizeObjFuncInd==1;
    disp('Running full structural estimation. Takes about 30 hours!')
    [parametersM1, fvalM1, exitflag, output] = fminsearch('minCdist_pars4_mho',initialValues, myoptions, data)
else;
    disp('This specification takes about 1 hour to run, please be patient. (NOT estimating structural model).')
     parametersM1=[1.2078; 2.6764; 0.88943; -7.1553];
end;

% Rescale back parameters:
parametersM1(1:2)=parametersM1(1:2)*1e-4;
parametersM1(3)=parametersM1(3)*10;
term1 =  1.0025*( (1-(10^(-4))^2) );
parametersM1(4) = 1-( term1 - exp(parametersM1(4)))^2/1.01;

%mResc= parametersM1(1)+parametersM1(2)*data(:,2); figure; plot(mResc);

% Extract estimated series (given parameter values)
[cRescaled_est,actualC,mhoRescaled_est,debtLimPDVrescaled_est,cRescaledFull_est,mRescaledFull_est] = minCdist_outputSeries_pars4_mho(parametersM1, data);
mhoRescaled_mean=mean(mhoRescaled_est);
ceaRescaled_mean=mean(debtLimPDVrescaled_est);
CEAmean=mean(CEAseries);
UnempMean=mean(mhoSeries);

% Decomposition by Wealth/Uncertainty/CEA
switchOffMho=[mhoRescaled_mean; 0; parametersM1(3:4)];
[cRescaled_soMho,actualC,mhoRescaled_soMho,debtLimPDVrescaled_soMho,cRescaledFull_soMho,mRescaledFull_soMho] = minCdist_outputSeries_pars4_mho(switchOffMho, data);

% Need to use here (not minCdist_outputSeries_pars4_mho)
switchOffMhoCEA=[mhoRescaled_mean; 0; ceaRescaled_mean; 0; parametersM1(4)];
[cRescaled_soMhoCEA,actualC,mhoRescaled_soMhoCEA,debtLimPDVrescaled_soMhoCEA,cRescaledFull_soMhoCEA,mRescaledFull_soMhoCEA] = minCdist_outputSeries(switchOffMhoCEA, data);

%%% Draw graphs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
savingRates=100*(1-[actualC,cRescaled_est]);
drawFigs_all;  % Draw charts with PSR decomposition and estimated mho and CEA

modelDataSummary=[time savingRates [actualC,cRescaled_est]];
xlswrite('modelDataSummary.xls',modelDataSummary,'Data','A3');

%%% Calculate standard errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d2=1e-5; % Small number to calculate numerical gradient
nPars=length(parametersM1); delta=d2*parametersM1; dI=eye(nPars);
fprintf('Delta   %4.4g \n ',d2);

cRescaled=cRescaled_est;
nPers=length(cRescaled);
cRescaled0=cRescaled;
cPlusDelta=zeros(nPers,nPars); cMinusDelta=zeros(nPers,nPars);

% Calculate numerical gradient of c for the 4 parameters
for j=[1:4];
    j
    xPlusDelta=parametersM1+delta(j)*dI(:,j);
    [cRescaledPlusDelta,actualCPlusDelta,mhoRescaledPlusDelta,debtLimPDVrescaledPlusDeltaFull,cRescaledPlusDeltaFull,mRescaledPlusDeltaFull] = minCdist_outputSeries_pars4_mho(xPlusDelta, data);
    cPlusDelta(:,j)=cRescaledPlusDelta;
    close;

    xMinusDelta=parametersM1-delta(j)*dI(:,j);
    [cRescaledMinusDelta,actualCMinusDelta,mhoRescaledMinusDelta,debtLimPDVrescaledMinusDeltaFull,cRescaledMinusDeltaFull,mRescaledMinusDeltaFull] = minCdist_outputSeries_pars4_mho(xMinusDelta, data);
    cMinusDelta(:,j)=cRescaledMinusDelta;
    close;
    
end;

gradC=(cPlusDelta-repmat(cRescaled0,1,nPars))./repmat(delta',nPers,1); mean(gradC(:,1)); % gradient
hessC=(cPlusDelta-2*repmat(cRescaled0,1,nPars)+cMinusDelta)./(repmat(delta',nPers,1)).^2; mean(hessC(:,1)); % hessian [not used]

varResid = var((actualC-cRescaled0));
Fmatrix = gradC;
varMatrix = varResid*pinv(Fmatrix'*Fmatrix);
sesAll=sqrt(diag(varMatrix))
tStatsAll=parametersM1./sesAll

cError=actualC-cRescaled;
adjR2=1-var(cError)/var(actualC)*(nPers-1)/(nPers-nPars-1)
dwStat=sum(diff(cError).^2)/sum(cError.^2);

%%% Print Results and LaTeX table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
diary on;
disp('    Parameter            Std Error          t stats');
disp([parametersM1 sesAll tStatsAll]);
disp('t stats');
disp(tStatsAll);
diary off;

% Print LaTeX code with the structural estimation table
writeStructEstTable_4par;

diary on;
%==========================================================================
t=toc; mints=floor(toc/60); secs=toc-60*mints;
fprintf('Time: %4.0f minutes, %4.2f seconds\n',mints,secs); diary off;
