(* ::Package:: *)

(* Initialization file necessary for running the Manipulate notebooks *)
If[Length[$FrontEnd] > 0,SetDirectory[NotebookDirectory[]]];
Get["../../CoreCode/Autoload/init.m"];
Get["../../CoreCode/MakeAnalyticalResults.m"];
Get["../../CoreCode/VarsAndFuncs.m"];
Get["../../CoreCode/ParametersBase.m"];
Get["../../CoreCode/DrawDiagrams.m"];
VerboseOutput=False;
