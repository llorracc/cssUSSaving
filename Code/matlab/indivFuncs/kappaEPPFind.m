% This function takes no inputs and does a binary search for the third derivative of consumption at
% steady state.  The equation used was derived explicitly by Mathematica
% and then translated into Matlab code.  The user is invited to verify the
% solution by hand or with other computer methods.


function kappaEPPSeek = kappaEPPFind(rho,mho,scriptR,kappa,kappaE,kappaEP,Beth,scriptcE,scriptcU)
%globalizeTBSvars;
gothisdeep = 100; % A limit on the number of iterations to attempt.  Not reached in practice.
counter = 0;
searchAt = 0;
found = 0;
scriptcEP = kappaE;
scriptcEPP = kappaEP;
% The binary search for a solution.
while (counter <= gothisdeep && found == 0)
    scriptcEPPP = searchAt;
    LHS = scriptcEPPP * CRRApp(scriptcE,rho) + 3 * scriptcEP * scriptcEPP * CRRAppp(scriptcE,rho) + scriptcEP^3 * CRRApppp(scriptcE,rho);
    RHS = Beth * (-(1 - mho) * scriptcEP * scriptcEPPP * scriptR * CRRApp(scriptcE,rho) - 3 * (1 - mho) * (1 - scriptcEP) * scriptcEPP^2 * scriptR^2 * CRRApp(scriptcE,rho) + (1 - mho) * (1 - scriptcEP)^3 * scriptcEPPP * scriptR^3 * CRRApp(scriptcE,rho) - kappa * mho * scriptcEPPP * scriptR * CRRApp(scriptcU,rho) - 3 * (1 - mho) * (1 - scriptcEP) * scriptcEP^2 * scriptcEPP * scriptR^2 * CRRAppp(scriptcE,rho) + 3 * (1 - mho) * (1 - scriptcEP)^3 * scriptcEP * scriptcEPP * scriptR^3 * CRRAppp(scriptcE,rho) - 3 * kappa^2 * mho * (1 - scriptcEP) * scriptcEPP * scriptR^2 * CRRAppp(scriptcU,rho) + (1 - mho) * (1 - scriptcEP)^3 * scriptcEP^3 * scriptR^3 * CRRApppp(scriptcE,rho) + kappa^3 * mho * (1 - scriptcEP)^3 * scriptR^3 * CRRApppp(scriptcU,rho));
    if LHS > RHS
        searchAt = searchAt + 2^(-counter);
    end
    if LHS < RHS
        searchAt = searchAt - 2^(-counter);
    end
    if LHS == RHS
        found = 1;
    end
    counter = counter + 1;
end
kappaEPPSeek = scriptcEPPP;
