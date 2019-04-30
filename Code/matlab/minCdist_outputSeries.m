
function [cRescaled,actualC,mhoRescaled,debtLimPDVrescaled,cRescaledFull,mRescaledFull] = minCdist_outputSeries(thetaVec, data);

scaleFac0_mho=thetaVec(1);
scaleFac1_mho=thetaVec(2);
scaleFac0_CEA=thetaVec(3);
scaleFac1_CEA=thetaVec(4);
thetaBase=thetaVec(5);


wyRatSeries=data(:,1);
mhoSeries=data(:,2);
CEAseries=data(:,3);
saving_rate=data(:,4);

nPersBackshoot=1000; % number of periods to simulate
nQuarters=length(mhoSeries);

mhoRescaled=scaleFac0_mho+scaleFac1_mho*mhoSeries;
debtLimPDVrescaled=scaleFac0_CEA+scaleFac1_CEA*CEAseries;
steadyStateMC=zeros(nQuarters,4);
mcPathAll=zeros(nPersBackshoot+2,2,length(mhoSeries));
cRescaledFull=zeros(nPersBackshoot+2,nQuarters);
mRescaledFull=zeros(nPersBackshoot+2,nQuarters);

for k=1:nQuarters;
    
    mhoBase=mhoRescaled(k);
    initializeParams;
    scriptmEBase = scriptmE;
    scriptcEBase = scriptcE;
    debtLimPDV=debtLimPDVrescaled(k);
    
    scriptmEcea = 1+(bigR/(biggamma+myZeta*biggamma-bigR))-debtLimPDV;
    scriptcEcea = (1-scriptR^(-1))*scriptmEcea+scriptR^(-1);
    scriptmEexPDVdebt = 1+(bigR/(biggamma+myZeta*biggamma-bigR));
    scriptcEexPDVdebt = (1-scriptR^(-1))*scriptmEexPDVdebt+scriptR^(-1);
    steadyStateMC(k,:)=[scriptmEcea scriptcEcea scriptmEexPDVdebt scriptcEexPDVdebt]; 
    
    FindStableArm;
    mPrevious=4*wyRatSeries(k); % As a fraction of QUARTERLY LABOR INCOME
    psavConstsAll=[[ephi0 phi1 egamma0 gamma1] scriptmTop];
    
    mcPath = SimGeneratePath(mPrevious,debtLimPDV,nPersBackshoot, EulerPoints, consumptionCoeffs, psavConstsAll,littleH,kappa,scriptmEBase,scriptcEBase,scriptR);
    mcPathAll(:,:,k) = mcPath;
    
    cRescaledFull(:,k)=squeeze(mcPathAll(:,2,k)./(1+littleR/bigR*(mcPathAll(:,1,k)-mcPathAll(:,2,k))));
    mRescaledFull(:,k)=squeeze(mcPathAll(:,1,k)./(1+littleR/bigR*(mcPathAll(:,1,k)-mcPathAll(:,2,k))));

end;

mcExtract=squeeze(mcPathAll(2,:,:))';
actualC=(100-saving_rate)/100;
mMinusC=mcExtract(:,1)-mcExtract(:,2);
mMinusC=[mMinusC(1); mMinusC(1:end-1,:)];
cRescaled = mcExtract(:,2)./(1+littleR/bigR*mMinusC);

mRescaled=mRescaledFull(2,:)';
cDist=sum((cRescaled-actualC).^2);

figure; plot([cRescaled actualC]); legend('Simulated C','Actual C')

%keyboard;

