% This function returns the second derivative of consumption in the
% previous period based on several inputs

function x = kappaEPtFromtp1(scriptmEtp1, scriptcEtp1, kappaEtp1, scriptmEt, scriptcEt, kappaEt, kappaEPtp1,scriptR,kappa,Beth,mho,rho)
%globalizeTBSvars;
scriptcUtp1 = (scriptmEt - scriptcEt) * scriptR * kappa;
y = (Beth * scriptR^2 * (1-kappaEt)^2 * (mho * kappa^2 * CRRAppp(scriptcUtp1,rho) + (1-mho) * kappaEtp1^2 * CRRAppp(scriptcEtp1,rho) + (1-mho) * (-rho * scriptcEtp1.^(-rho-1)) * kappaEPtp1) - (kappaEt)^2 * CRRAppp(scriptcEt,rho));
z = (-rho * scriptcEt.^(-rho-1)) + Beth * scriptR * (mho * kappa * (-rho * scriptcUtp1.^(-rho-1)) +...
    (1-mho) * kappaEtp1 * (-rho * scriptcEtp1.^(-rho-1)));
x = y/z;

