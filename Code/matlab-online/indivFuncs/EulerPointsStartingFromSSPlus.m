% This function provides a list of points on the stable arm using
% BackShoot.  Its single input is the starting distance from the steady
% state on the monetary assets axis.

function PointsList = EulerPointsStartingFromSSPlus(filldelta,scriptmE,scriptcE,scriptvE,kappaE,kappaEP,kappaEPP,kappaEPPP,biggamma,mybeta,bigR,rho,mho,kappa,scriptR,Beth,littleV)
%globalizeTBSvars;
% Provide the first Euler point
scriptmStart = scriptmE + filldelta;
kappaStart = kappaE + kappaEP * filldelta + kappaEPP * (filldelta^2)/2 + kappaEPPP * (filldelta^3)/6;
kappaPStart = kappaEP + kappaEPP * filldelta + kappaEPPP * (filldelta^2)/2;
scriptcStart = cETaylorNearTarget(filldelta,scriptcE,kappaE,kappaEP,kappaEPP,kappaEPPP);

% This section does a numeric integration to find scriptvStart, as Matlab's
% numeric integration is unable to handle the job.
current = 0;
places = 1000;
iterator = filldelta/places;
areasum = 0;
while current < filldelta
    areasum = areasum + CRRAp(cETaylorNearTarget(current,scriptcE,kappaE,kappaEP,kappaEPP,kappaEPPP),rho)*iterator;
    current = current + iterator;
end
scriptvStart = scriptvE + areasum;

% Use BackShoot to generate the Euler points
StartPoint = [scriptmStart scriptcStart kappaStart scriptvStart kappaPStart];
PointsList = BackShoot(StartPoint,scriptmE,biggamma,mybeta,bigR,rho,mho,kappa,scriptR,Beth,littleV);
