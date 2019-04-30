
function cDist = minCdist_resc_pars4_mho(thetaVec, data);

disp('******************************************************************');
disp(['New iteration    ' datestr(now)]);
disp('******************************************************************');
nPers=2; % number of periods to simulate
% scaleFac0_mho=thetaVec(1);
% scaleFac1_mho=thetaVec(2);
% scaleFac0_CEA=10*thetaVec(3);
% scaleFac1_CEA=10*thetaVec(4);
% thetaBase=thetaVec(5);

scaleFac0_mho=thetaVec(1)*1e-4;
scaleFac1_mho=thetaVec(2)*1e-4;
scaleFac0_CEA=0;
scaleFac1_CEA=thetaVec(3)*10;

term1 =  1.0025*( (1-(10^(-4))^2) );
betaBase =( term1 - exp(thetaVec(4)) )^2/1.01
thetaBase = 1- betaBase;
disp('thetaBase: '); disp(thetaBase);

%zeta_trans_1 = (1.0025*(1-10^(-4))^2;
%zeta_trans_2 = (1.01*(1-thetaBase))^(1/2); 
%zeta_both = zeta_trans_1-zeta_trans_2;

wyRatSeries=data(:,1);
mhoSeries=data(:,2);
CEAseries=data(:,3);
saving_rate=data(:,4);
steadyStateMC=[]; steadyStateMCexPDVdebt=[];

mhoRescaled=scaleFac0_mho+scaleFac1_mho*mhoSeries;
debtLimPDVrescaled=scaleFac0_CEA+scaleFac1_CEA*CEAseries;

for k=1:length(mhoSeries);
    disp('Calculating Quarter'); disp(k);
    
    mhoBase=mhoRescaled(k);
    initializeParams;
    scriptmEBase = scriptmE;
    scriptcEBase = scriptcE;
    debtLimPDV=debtLimPDVrescaled(k);
    
    scriptmEcea = 1+(bigR/(biggamma+myZeta*biggamma-bigR))-debtLimPDV;
    scriptcEcea = (1-scriptR^(-1))*scriptmEcea+scriptR^(-1);
    scriptmEexPDVdebt = 1+(bigR/(biggamma+myZeta*biggamma-bigR));
    scriptcEexPDVdebt = (1-scriptR^(-1))*scriptmEexPDVdebt+scriptR^(-1);
    steadyStateMC=[steadyStateMC; scriptmEcea scriptcEcea scriptmEexPDVdebt scriptcEexPDVdebt];
    
    FindStableArm;
    mPrevious=4*wyRatSeries(k); % As a fraction of QUARTERLY INCOME
    psavConstsAll=[[ephi0 phi1 egamma0 gamma1] scriptmTop];
    
    mcPath = SimGeneratePath(mPrevious,debtLimPDV,nPers, EulerPoints, consumptionCoeffs, psavConstsAll,littleH,kappa,scriptmEBase,scriptcEBase,scriptR);
    mcPathAll(:,:,k) = mcPath;

end;

mcExtract=squeeze(mcPathAll(2,:,:))';
actualC=(100-saving_rate)/100;
mMinusC=mcExtract(:,1)-mcExtract(:,2);
mMinusC=[mMinusC(1); mMinusC(1:end-1,:)];
cRescaled = mcExtract(:,2)./(1+littleR/bigR*mMinusC);

cDist=sum((cRescaled-actualC).^2);

%close all;
%figure; plot([cRescaled actualC]); legend('Simulated C','Actual C')
%==========================================================================
t=toc; mints=floor(toc/60); secs=toc-60*mints;
fprintf('Time: %4.0f minutes, %4.2f seconds\n',mints,secs); %diary off;


 
