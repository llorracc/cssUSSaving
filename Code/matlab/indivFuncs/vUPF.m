% This is the value function for an unemployed consumer under perfect
% foresight.  Given a level of assets, it returns the consumer's value of
% holding those assets.

function x = vUPF(scriptm,rho,kappa,littleV,bigR,mybeta)
%globalizeTBSvars;
temp = CRRA(kappa * scriptm,rho) * littleV;
if rho == 1
    temp = temp + log(bigR * mybeta) * (mybeta/((mybeta-1)^2));
end
x = temp;
