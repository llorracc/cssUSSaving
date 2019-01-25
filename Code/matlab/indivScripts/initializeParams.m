% This script defines the base values for parameters in the TBS model.
% It then calls a script to define the working values of these parameters.

% epsilon = 0.0001;
% %mhoBase = 0.05;
% thetaBase = 0.10;
% littleRBase = 0.05;
% littleGBase = -0.02;
% rhoBase = 1.01;
% VerboseOutput = 0;

epsilon = 0.01;
%mhoBase = 0.05;
%thetaBase = 0.04;
%littleRBase = 0.04/4;   %Quarterly numbers
%littleGBase = 0.01/4;
%littleRBase = 0.04/4;   %Quarterly numbers
littleRBase = 0.04/4;   %Quarterly numbers

if ~exist('prodGbase','var'); littleGBase = 0.01/4;
else; littleGBase=(prodGbase)/400; 
    %littleGBase = 0.01/4;
end;

rhoBase = 2;
VerboseOutput = 0;

if VerboseOutput == 1
    disp('Output will be verbose.');
    disp('Parameter base values have been set.');
end

resetParams;
