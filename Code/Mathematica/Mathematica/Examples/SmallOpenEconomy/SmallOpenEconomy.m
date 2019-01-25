(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* This notebook simulates the small open economy model in the handout TractableBufferStock associated 
with Christopher Carroll's first year graduate macroeconomics course; see that document for notation and explanations *)


(* This cell is basically housekeeping and setup stuff; it can be ignored *)
ClearAll["Global`*"];ParamsAreSet=False;
If[$VersionNumber<8,(*then*) Print["These programs require Mathematica version 8 or greater."];Abort[]];
If[Length[$FrontEnd] > 0,NBDir=SetDirectory[NotebookDirectory[]]];(* If running from the Notebook interface *)
rootDir = SetDirectory["../../.."];
AutoLoadDir=SetDirectory["./Mathematica/CoreCode/Autoload"];Get["./init.m"];
CoreCodeDir=SetDirectory[".."];
rootDir = SetDirectory[".."];
Get[CoreCodeDir<>"/MakeAnalyticalResults.m"];
Get[CoreCodeDir<>"/VarsAndFuncs.m"];
(* Method of creating figures depends on whether being run in batch mode or interactively *)
If[$FrontEnd == Null,OpenFigsUsingShell=True,OpenFigsUsingShell=False]; 


Get[CoreCodeDir<>"/ParametersBase.m"];
FindStableArm;



SetDirectory[NotebookDirectory[]];
<<SOESimFuncs.m;
<<SOESimParams.m;


(* Don't worry about the error messages this generates *)
VerboseOutput=False;CensusMakeStakes;
Do[AddNewGen[{\[ScriptB]E,\[ScriptCapitalN],\[GothicCapitalG]}],{4}];
\[CurlyTheta]=0.06;
FindStableArm;


Do[AddNewGen[{\[ScriptB]E,\[ScriptCapitalN],\[GothicCapitalG]}],{75}];




timePath=Table[i,{i,Length[CensusMeans]}];
cPathAfterThetaDropPlot=ListPlot[Transpose[{timePath,CensusMeansT[[\[ScriptC]Pos]]}],PlotRange->All,PlotStyle->Black];



SOEStakescPathAfterThetaDropPlot=Show[cPathAfterThetaDropPlot,Ticks->{{{4,"0"}},None},AxesLabel->{"Time","\[ScriptC]"},AxesOrigin->{-3,0},PlotRange->{{-3,Automatic},{0,Automatic}}];
ExportFigsToDir["SOEStakescPathAfterThetaDropPlot","/Volumes/Data/Courses/Choice/LectureNotes/Consumption/Handouts/TractableBufferStock/Code/Mathematica/Examples/TractableBufferStock/Figures"];
Show[SOEStakescPathAfterThetaDropPlot]



CensusMakeNoStakes;
VerboseOutput=False;
Do[AddNewGen[{0,\[ScriptCapitalN],\[GothicCapitalG]}],{100}];
timePath=Table[i,{i,Length[Census]}];
cPath=ListPlot[Transpose[{timePath,CensusMeansT[[\[ScriptC]Pos]]}],PlotRange->All];

SOENoStakescPath=Show[cPath,Ticks->{{{1,"0"}},None},AxesLabel->{"Time","\[ScriptC]"},AxesOrigin->{-3,0},PlotRange->{{-3,All},{0,All}}];
ExportFigsToDir["SOENoStakescPath","/Volumes/Data/Courses/Choice/LectureNotes/Consumption/Handouts/TractableBufferStock/Code/Mathematica/Examples/TractableBufferStock/Figures"];
Show[SOENoStakescPath]




