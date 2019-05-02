
% The main file that estimates the structural model for cssUSsaving
clear all;
close all;
fclose('all');

UsingMatlab = 1;

thispath = mfilename('fullpath');
thisfile = mfilename;
pathlength = size(thispath,2);
namelength = size(thisfile,2);
CurDir = thispath(1:(pathlength-namelength));
cd(CurDir); path(CurDir,path);
path([CurDir 'SOEfiles'],path); path([CurDir 'indivScripts'],path); path([CurDir 'indivFuncs'],path); path([CurDir 'plotFiles'],path);
%cd('figures');

estStructModel_main_pars4_mho_mid;
