% This function generates the previous period's consumption based on the
% current period's consumption and assets.

function x = scriptcEtFromtp1(scriptmEtp1,scriptcEtp1,biggamma,mybeta,bigR,rho,mho,kappa)
%globalizeTBSvars;
x = biggamma * (mybeta*bigR)^(-1/rho) * scriptcEtp1 * (1 + mho * ((scriptcEtp1/(kappa * (scriptmEtp1 - 1)))^rho - 1))^(-1/rho);
