% This script sets variable values based on TBS parameters.
% It should be called immediately after parameter values are changed.

mybeta = 1/(1+theta); % individual's time discount factor
bigR = littleR + 1; % interest factor
bigG = littleG + 1; % wage growth factor
%biggamma = bigG/(1-mho); % "uncertainty compensated" wage growth factor

% Jirka: Note that we use plain, uncompensated wage growth
biggamma = bigG;
scriptR = bigR/biggamma; % net interest factor (R normalized by wage growth)
lambda = (bigR^(-1))*(bigR*mybeta)^(1/rho); % MPS for a perfect foresight consumer
kappa = 1-lambda; % MPC for a perfect foresight consumer

% Various impatience factors
scriptPGrowth = (bigR*mybeta)^(1/rho)/biggamma;
scriptPReturn = (bigR*mybeta)^(1/rho)/bigR;
scriptpgrowth = log(scriptPGrowth);
scriptpreturn = log(scriptPReturn);

CheckForGammaImpatience
CheckForBigRImpatience

Pi = (1+(scriptPGrowth^(-rho)-1)/mho)^(1/rho);
littleH = (1/(1-bigG/bigR));
myZeta = scriptR*kappa*Pi;

% The steady state values for the employed and unemployed consumer
scriptmE = 1+(bigR/(biggamma+myZeta*biggamma-bigR));
scriptcE = (1-scriptR^(-1))*scriptmE+scriptR^(-1);
scriptaE = scriptmE - scriptcE;
scriptbE = scriptaE*scriptR;
scriptyE = scriptaE*(scriptR-1)+1;
scriptxE = scriptyE - scriptcE;
scriptbU = scriptbE;
scriptmU = (scriptmE - scriptcE) * scriptR;
scriptcU = scriptmU * kappa;

littleV = 1/(1-mybeta*((bigR*mybeta)^((1/rho)-1)));
scriptvU = CRRA(scriptcU,rho)*littleV;
scriptvE = (CRRA(scriptcE,rho) + mybeta*(biggamma^(1-rho))*mho*vUPF(scriptaE * scriptR,rho,kappa,littleV,bigR,mybeta))/(1-mybeta*(biggamma^(1-rho)*(1-mho)));

Beth = scriptR * mybeta * biggamma^(1-rho);

% Find the limiting MPC as assets approach zero
kappaEMax = kappaLim0Find(Beth,scriptR,mho,kappa,rho,lambda);

% These functions find the MPC and its derivatives at the steady state.
kappaE = kappaEFind(rho,mho,kappa,scriptR,Beth,scriptcE,scriptcU);
kappaEP = kappaEPFind(kappaE,kappa,rho,mho,Beth,scriptR,scriptcE,scriptcU);
kappaEPP = kappaEPPFind(rho,mho,scriptR,kappa,kappaE,kappaEP,Beth,scriptcE,scriptcU);
kappaEPPP = kappaEPPPFind(rho,mho,kappa,kappaE,kappaEP,kappaEPP,Beth,scriptR,scriptcE,scriptcU);

SteadyStateVals = [scriptbE scriptmE scriptcE scriptaE kappaE kappaEP scriptvE];

if VerboseOutput==1
    disp('All variables set, consumer is sufficiently impatient.');
end
