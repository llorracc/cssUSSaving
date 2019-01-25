(* ::Package:: *)

FindStableArm;
{\[ScriptM]ERLo,\[ScriptC]ERLo}={\[ScriptM]E,\[ScriptC]E};
\[ScriptM]EDelEqZeroRLoPlot=Plot[\[ScriptM]EDelEqZero[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},AxesOrigin->{0.,0.},PlotRange->\[ScriptC]PlotRange,PlotStyle->{\[ScriptM]DelEqZeroColor,\[ScriptM]EDelEqZeroStyle,RLoStyle},AxesLabel->{"\[ScriptM]"}];
cERLoPlot=Plot[cE[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},AxesOrigin->{0.,0.},PlotRange->\[ScriptC]PlotRange,PlotStyle->{\[ScriptC]Color,RLoStyle},AxesLabel->{"\[ScriptM]"}];
vERLoPlot=Show[
  Plot[vE[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},AxesOrigin->{0.,0.},PlotRange->\[ScriptV]PlotRange,PlotStyle->{\[ScriptV]Color,RLoStyle},Ticks->{Automatic,None},AxesLabel->{"\[ScriptM]"}]
  ,Graphics[Text["\[UpperLeftArrow] \[ScriptL]",{mMaxPlotVal,vE[mMaxPlotVal]},{1,2}]]
];
r=rBase+0.077; (* Now calculate results for RHi types *)
FindStableArm;
{\[ScriptM]ERHi,\[ScriptC]ERHi}={\[ScriptM]E,\[ScriptC]E};
vERHiStayerPlot=Show[
  Plot[vE[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},AxesOrigin->{0.,0.},PlotRange->\[ScriptV]PlotRange,PlotStyle->{\[ScriptV]Color,RHiStyleStay},Ticks->{Automatic,None},AxesLabel->{"\[ScriptM]"}]
  ,Graphics[Text["\[ScriptH] \[RightArrow]",{mMaxPlotVal/2,vE[mMaxPlotVal/2]},{1,-1}]]
];
vERHiSwitcherPlot=Show[
  Plot[vE[\[ScriptM]-PartCost]
    ,{\[ScriptM],\[ScriptM]EMin+PartCost,mMaxPlotVal},AxesOrigin->{0.,0.},PlotRange->\[ScriptV]PlotRange,PlotStyle->{\[ScriptV]Color,RHiStyleMove},Ticks->{Automatic,None},AxesLabel->{"\[ScriptM]"}]
  ,Graphics[Text["\[LeftArrow] \[ScriptL]-to-\[ScriptH] Trainer",{mMaxPlotVal/3,vE[mMaxPlotVal/3-PartCost]},{-1,2}]]
];
cERHiPlot=Plot[cE[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},PlotRange->\[ScriptC]PlotRange,AxesOrigin->{0.,0.},PlotStyle->{\[ScriptC]Color,RHiStyle},AxesLabel->{"\[ScriptM]"}];
\[ScriptM]EDelEqZeroRHiPlot=Plot[\[ScriptM]EDelEqZero[\[ScriptM]]
    ,{\[ScriptM],\[ScriptM]EMin,mMaxPlotVal},PlotRange->\[ScriptC]PlotRange,AxesOrigin->{0.,0.},PlotStyle->{\[ScriptM]DelEqZeroColor,\[ScriptM]EDelEqZeroStyle,RHiStyle},AxesLabel->{"\[ScriptM]"}];
vEPlot=Show[vERLoPlot,vERHiSwitcherPlot,vERHiStayerPlot
  ,Graphics[Text["\[LeftArrow]\[Chi]\[RightArrow]",{5.3,vE[3.7]}]]
  ,PlotLabel->"Value for \[ScriptH], \[ScriptL], and \[ScriptL]-to-\[ScriptH] types"
  ,PlotRange->\[ScriptV]PlotRange
  ,PlotRangePadding->0 (* Don't pad axes; this way they will line up horizontally *)
  ,ImagePadding->PadToLineUpFigsVertically
];
cEPlot=Show[cERLoPlot,cERHiPlot,\[ScriptM]EDelEqZeroRLoPlot,\[ScriptM]EDelEqZeroRHiPlot
  ,ListPlot[{{\[ScriptM]ERLo,\[ScriptC]ERLo}},PlotStyle->{Black,PointSize[0.02]}]
  ,ListPlot[{{\[ScriptM]ERHi,\[ScriptC]ERHi}},PlotStyle->{Black,PointSize[0.02]}]
  ,PlotLabel->"\[ScriptC](m) (black) and \!\(\*SuperscriptBox[\(\[CapitalDelta]\[ScriptM]\), \(e\)]\)=0 (red), Target=\!\(\*
StyleBox[\"\[Bullet]\",\nFontSize->18]\)"
  ,PlotRange->\[ScriptC]PlotRange
  ,PlotRangePadding->0 (* Don't pad axes; this way they will line up horizontally *)
  ,AxesOrigin->{0.,0.}
  ,ImagePadding->PadToLineUpFigsVertically
];
