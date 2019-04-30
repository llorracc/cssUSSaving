% This function returns the next period's monetary assets based on the current period's consumption and assets

function x = scriptmEtp1Fromt(scriptmEt, scriptcEt,scriptR)
%globalizeTBSvars;
x = (scriptmEt - scriptcEt)*scriptR + 1;
