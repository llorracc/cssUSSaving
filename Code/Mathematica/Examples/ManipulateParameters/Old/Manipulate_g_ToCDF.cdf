Notebook[{

Cell[CellGroupData[{
Cell["Manipulate\[GothicG]", "Section"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{"SetDirectory", "[", 
   RowBox[{"NotebookDirectory", "[", "]"}], "]"}], ";", 
  RowBox[{"ClearAll", "[", "\"\<Global`*\>\"", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"SetDirectory", "[", 
   RowBox[{"NotebookDirectory", "[", "]"}], "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Get", "[", "\"\<../../CoreCode/Autoload/init.m\>\"", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Get", "[", "\"\<../../CoreCode/MakeAnalyticalResults.m\>\"", "]"}],
   ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Get", "[", "\"\<../../CoreCode/VarsAndFuncs.m\>\"", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Get", "[", "\"\<../../CoreCode/ParametersBase.m\>\"", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"Get", "[", "\"\<../../CoreCode/DrawDiagrams.m\>\"", "]"}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{"VerboseOutput", "=", "False"}], ";", "FindStableArm", 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   RowBox[{"{", 
    RowBox[{"mMaxPlot", ",", "mMaxPlot"}], "}"}], "=", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"2.5", ",", "4"}], "}"}], " ", "\[ScriptM]E"}]}], ";", 
  RowBox[{"\[ScriptC]MaxPlot", "=", 
   RowBox[{"cE", "[", "mMaxPlot", "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Manipulate", "[", "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Block", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
       RowBox[{"$PerformanceGoal", "=", "\"\<Quality\>\""}], ",", " ", 
       "\[GothicG]"}], "}"}], ",", "\[IndentingNewLine]", 
     RowBox[{
      RowBox[{"\[GothicG]", "=", "\[GothicG]Slider"}], ";", 
      "\[IndentingNewLine]", 
      RowBox[{"If", "[", 
       RowBox[{
        RowBox[{
         RowBox[{
          RowBox[{
           RowBox[{
            RowBox[{"(", 
             RowBox[{
              RowBox[{"(", "R", ")"}], " ", "\[Beta]"}], ")"}], "^", 
            RowBox[{"(", 
             RowBox[{"1", "/", "\[Rho]"}], ")"}]}], "/", "\[CapitalGamma]"}], 
          " ", "\[GreaterEqual]", "  ", "1"}], "||", 
         RowBox[{
          RowBox[{
           RowBox[{
            RowBox[{"(", 
             RowBox[{
              RowBox[{"(", "R", ")"}], " ", "\[Beta]"}], ")"}], "^", 
            RowBox[{"(", 
             RowBox[{"1", "/", "\[Rho]"}], ")"}]}], "/", 
           RowBox[{"(", "R", ")"}]}], " ", "\[GreaterEqual]", "  ", "1"}]}], 
        ",", 
        RowBox[{
         RowBox[{"Style", "[", 
          RowBox[{
           RowBox[{
           "Text", "[", "\"\<Impatience Condition Not Satisfied.\>\"", "]"}], 
           ",", "24"}], "]"}], ";", 
         RowBox[{"Abort", "[", "]"}]}]}], "]"}], ";", "\[IndentingNewLine]", 
      RowBox[{"DrawPhaseDiagram", "[", 
       RowBox[{"mMaxPlot", ",", "mMaxPlot", ",", "\[ScriptC]MaxPlot"}], 
       "]"}]}]}], "\[IndentingNewLine]", "]"}], ",", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
      "\[GothicG]Slider", ",", "\[GothicG]Base", ",", "\"\<\[GothicG]\>\""}], 
      "}"}], ",", 
     RowBox[{"\[GothicG]Base", "-", "0.02"}], ",", 
     RowBox[{"\[GothicG]Base", "+", ".02"}], ",", "0.005"}], "}"}]}], 
  "]"}]}], "Input",
 InitializationCell->True],

Cell[BoxData["\<\"MakeAnalyticalResults should be executed before parameter \
values are defined.\"\>"], "Print"],

Cell[BoxData["$Aborted"], "Output"],

Cell[BoxData["\<\"This file should be executed before parameter values are \
defined.\"\>"], "Print"],

Cell[BoxData["$Aborted"], "Output"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`\[GothicG]Slider$$ = 0., Typeset`show$$ = 
    True, Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`\[GothicG]Slider$$], 0., "\[GothicG]"}, -0.02, 0.02, 
      0.005}}, Typeset`size$$ = {702., {209., 225.}}, Typeset`update$$ = 0, 
    Typeset`initDone$$, Typeset`skipInitDone$$ = 
    True, $CellContext`\[GothicG]Slider$8455$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`\[GothicG]Slider$$ = 0.}, 
      "ControllerVariables" :> {
        Hold[$CellContext`\[GothicG]Slider$$, \
$CellContext`\[GothicG]Slider$8455$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> 
      Block[{$PerformanceGoal = 
         "Quality", $CellContext`\[GothicG]}, $CellContext`\[GothicG] = \
$CellContext`\[GothicG]Slider$$; If[
          
          Or[($CellContext`R $CellContext`\[Beta])^(
              1/$CellContext`\[Rho])/$CellContext`\[CapitalGamma] >= 
           1, ($CellContext`R $CellContext`\[Beta])^(
              1/$CellContext`\[Rho])/$CellContext`R >= 1], Style[
            Text["Impatience Condition Not Satisfied."], 24]; 
          Abort[]]; $CellContext`DrawPhaseDiagram[$CellContext`mMaxPlot, \
$CellContext`mMaxPlot, $CellContext`\[ScriptC]MaxPlot]], 
      "Specifications" :> {{{$CellContext`\[GothicG]Slider$$, 0., 
          "\[GothicG]"}, -0.02, 0.02, 0.005}}, "Options" :> {}, 
      "DefaultOptions" :> {}],
     ImageSizeCache->{768., {272., 281.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UndoTrackedVariables:>{Typeset`show$$, Typeset`bookmarkMode$$},
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Manipulate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]]
}, Open  ]]
},
AutoGeneratedPackage->Automatic,
WindowSize->{1078, 1051},
WindowMargins->{{421, Automatic}, {Automatic, 0}},
Visible->True,
ScrollingOptions->{"VerticalScrollRange"->Fit},
ShowCellBracket->Automatic,
CellContext->Notebook,
TrackCellChangeTimes->False,
FrontEndVersion->"10.2 for Mac OS X x86 (32-bit, 64-bit Kernel) (July 6, \
2015)",
StyleDefinitions->"Default.nb"
]

