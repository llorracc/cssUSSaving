% A function which iterates the reverse Euler equations until it reaches a
% point outside some predefined boundaries.
% It takes as an input an nx4 matrix (only caring about the last row) and
% returns an nx4 matrix with more points appended.

function PointsList = BackShoot(InitialPoints,scriptmE,biggamma,mybeta,bigR,rho,mho,kappa,scriptR,Beth,littleV)
%globalizeTBSvars;
VerboseOutput=0;
if VerboseOutput == 1
    disp('Solving for Euler points...');
end
%scriptmMaxBound = 100 * scriptmE;
scriptmMaxBound = 100 * scriptmE; % don't need to solve full C fuction
% scriptmMinBound = 1;
scriptmMinBound = 1; % don't need to solve full C fuction
Counter = 0;
InitialSize = size(InitialPoints);
InitialLength = InitialSize(1);
if InitialSize(2) ~= 5
    error('BackShoot was passed a matrix that does not have width 5, terminating.')
end
% Set the first point to be used as the last point from the inputed matrix
PointsList=zeros(1e4,5);
PointsList(1,:) = InitialPoints;

scriptmPrev = InitialPoints(InitialLength,1);
scriptcPrev = InitialPoints(InitialLength,2);
kappaPrev = InitialPoints(InitialLength,3);
scriptvPrev = InitialPoints(InitialLength,4);
kappaPPrev = InitialPoints(InitialLength,5);
% Add points to the PointsList until a point exceeds the specified bounds
while ((scriptmPrev > scriptmMinBound) && (scriptmPrev <= scriptmMaxBound))
    scriptmNow = scriptmEtFromtp1(scriptmPrev,scriptcPrev,biggamma,mybeta,bigR,rho,mho,kappa);
    scriptcNow = scriptcEtFromtp1(scriptmPrev,scriptcPrev,biggamma,mybeta,bigR,rho,mho,kappa);
    kappaNow = kappaEtFromtp1(scriptmPrev, scriptcPrev, kappaPrev, scriptmNow, scriptcNow,kappa,scriptR,Beth,rho,mho);
    kappaPNow = kappaEPtFromtp1(scriptmPrev, scriptcPrev, kappaPrev, scriptmNow, scriptcNow, kappaNow, kappaPPrev,scriptR,kappa,Beth,mho,rho);
    scriptvNow = (scriptcNow.^(1-rho))/(1-rho) + mybeta * (biggamma^(1-rho)) * ((1-mho) * scriptvPrev + mho * vUPF(scriptR * (scriptmNow - scriptcNow),rho,kappa,littleV,bigR,mybeta));
    newDataPoint = [scriptmNow scriptcNow kappaNow scriptvNow kappaPNow];
    PointsList(Counter+2,:) = newDataPoint;
    scriptmPrev = scriptmNow;
    scriptcPrev = scriptcNow;
    kappaPrev = kappaNow;
    scriptvPrev = scriptvNow;
    kappaPPrev = kappaPNow;
    Counter = Counter + 1;
end
PointsList=PointsList(1:(Counter+1),:);


% Tell the user when the points exceed the bounds
if scriptmPrev <= scriptmMinBound && VerboseOutput==1
    disp(['Went below minimum bound after ' num2str(Counter-1) ' backwards Euler iterations.']);
    disp(['Last point: {' num2str(newDataPoint) '}']); 
end
if scriptmPrev > scriptmMaxBound && VerboseOutput==1;
    disp(['Went above maximum bound after ' num2str(Counter-1) ' backwards Euler iterations.']);
    disp(['Last point: {' num2str(newDataPoint) '}']);
end

