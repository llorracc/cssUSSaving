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



ClearAll["Global`*"];
SetDirectory[NotebookDirectory[]];
<<ManipulatePrepare.m;

(* Reset formulas and variables for the specialization to \[GothicCapitalG]=(1-\[Alpha] \[Mho])(R) *)
Clear[\[Mho],\[CurlyTheta],\[GothicCapitalG],\[GothicG],\[Alpha],r];
\[GothicCapitalG]=(1-\[Alpha] \[Mho])(R);
\[GothicG]=\[GothicCapitalG]-1;
\[Mho]=\[Mho]Base;
r=rBase;
\[CurlyTheta]=\[CurlyTheta]Base=rBase+0.02;


(* The interesting solutions for very low \[Alpha] where the \[Beta]MaxWhereGICTBSHoldsExactly locus is above the \[Beta]MaxWhereRICHoldsExactly locus are not legitimate solutions to the model; in this case, \[Kappa] < 0 and model's equations are solved with a negatively sloping consumption function, which can be ruled out on a priori grounds.  This is not exactly an error; this configuration just does not correspond to a meaningful solution.  (The problem could be solved by imposing an assumption that \[Kappa] > 0) *)
Clear[\[Mho],\[CurlyTheta]];
\[Beta]PlotMax=1.3;
\[Alpha]PlotMax=20;
\[Mho]Min=0.005;
\[Mho]Max=0.035;
NumOfSteps=30;
\[Mho]Step=(\[Mho]Max-\[Mho]Min)/(NumOfSteps) //N;
rMin=0.02;
rMax=0.14;
rStep=(rMax-rMin)/(NumOfSteps) //N;
\[Rho]Min=2;
\[Rho]Max=5;
\[Rho]Step=(\[Rho]Max-\[Rho]Min)/(NumOfSteps) //N;
Manipulate[Block[{$PerformanceGoal="Quality",\[Alpha],\[CurlyTheta],\[Mho],r,\[Rho]},
\[Mho]=\[Mho]Slider;
\[Rho]=\[Rho]Slider;
r=rSlider;
Plot[{
\[Beta]MaxWhereRICHoldsExactly
,(\[Beta]MaxWhereGICTBSHoldsExactly /. \[Alpha] -> \[Alpha]Plot)
,(\[Beta]MaxWhereGIC\[CapitalGamma]HoldsExactly /. \[Alpha] -> \[Alpha]Plot)
,(\[Beta]MaxWhereGIC\[GothicCapitalG]HoldsExactly /. \[Alpha] -> \[Alpha]Plot)
},{\[Alpha]Plot,1,\[Alpha]PlotMax}
,PlotStyle->{Black,Red,Green,Blue}
,PlotRange->{{1,\[Alpha]PlotMax},{0,\[Beta]PlotMax}}
,AxesLabel->{"\[Alpha]","\[Beta]"}
,AxesOrigin->{1,0}
,PlotLegends->{"RIC","GICTBS","\!\(\*SubscriptBox[\(GIC\), \(\[CapitalGamma]\)]\)","\!\(\*SubscriptBox[\(GIC\), \(\[GothicCapitalG]\)]\)"}
]
]
,{{\[Mho]Slider,\[Mho]Min,"\[Mho]"},\[Mho]Min,\[Mho]Max,\[Mho]Step,Appearance->"Labeled"}
,{{\[Rho]Slider,\[Rho]Min,"\[Rho]"},\[Rho]Min,\[Rho]Max,\[Rho]Step,Appearance->"Labeled"}
,{{rSlider,rMin,"r"},rMin,rMax,rStep,Appearance->"Labeled"}
]




