% % This function returns the first derivative of consumption in the
% previous period based on several inputs

function x = kappaEtFromtp1(scriptmEtp1, scriptcEtp1, kappaEtp1, scriptmEt, scriptcEt,kappa,scriptR,Beth,rho,mho)
%globalizeTBSvars;
scriptcUtp1 = kappa * (scriptmEt - scriptcEt) * scriptR;
natural = Beth * scriptR * (1 / (-rho * scriptcEt.^(-rho-1))) * ((1-mho) * (-rho * scriptcEtp1.^(-rho-1)) * kappaEtp1 + mho * (-rho * scriptcUtp1.^(-rho-1)) *kappa);
x = natural / (natural + 1);
