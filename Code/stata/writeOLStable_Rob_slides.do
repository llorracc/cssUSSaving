
* writes the TeX table (i.e. just the numbers)
#delimit;
tempname hh;
file open `hh' using "$docPath\tOLS02_slides.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\scriptsize" _n;
*file write `hh' "\showEstTime{$lineLabel } ";  * COMMENT OUT IF DESIRABLE;
file write `hh' "\begin{tabular}{@{}lgd{2}d{2}d{2}d{2}d{2}d{2}@{}}" _n  "\toprule" _n;
file write `hh' "     Model & \multicolumn{1}{c}{\remph{Baseline}} & \multicolumn{1}{c}{Uncert} & \multicolumn{1}{c}{\$s_{t-1}\$} & \multicolumn{1}{c}{Debt} & \multicolumn{1}{c}{Full Controls} & \multicolumn{1}{c}{Post-80} & \multicolumn{1}{c}{IV}  " $eolString _n "\midrule " _n;

/*
file write `hh' "\$\gamma_0$ & ";
sca ptest = 2*(1-normal(abs(m1b0)/m1se0));
do MakeTestStringJ;
file write `hh' %4.2f (m1b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m2b0)/m2se0));
do MakeTestStringJ;
file write `hh' %4.2f (m2b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m3b0)/m3se0));
do MakeTestStringJ;
file write `hh' %4.2f (m3b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m8b0)/m8se0));
do MakeTestStringJ;
file write `hh' %4.2f (m8b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4b0)/m4se0));
do MakeTestStringJ;
file write `hh' %4.2f (m4b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m5b0)/m5se0));
do MakeTestStringJ;
file write `hh' %4.2f (m5b0) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7b0)/m7se0));
do MakeTestStringJ;
file write `hh' %4.2f (m7b0) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (m1se0) ")  &  (" %4.2f (m2se0) ")  &  (" %4.2f (m3se0) ")  &  (" %4.2f (m8se0) ")  &  (" %4.2f (m4se0) ")  &  ("%4.2f (m5se0) ")  &  ("%4.2f (m7se0) ")" $eolString _n;
*/;

file write `hh' "\$\gamma_m$   & ";
sca ptest = 2*(1-normal(abs(m1bm)/m1sem));
do MakeTestStringJ;
file write `hh' %4.2f (m1bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m2bm)/m2sem));
do MakeTestStringJ;
file write `hh' %4.2f (m2bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m3bm)/m3sem));
do MakeTestStringJ;
file write `hh' %4.2f (m3bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m8bm)/m8sem));
do MakeTestStringJ;
file write `hh' %4.2f (m8bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bm)/m4sem));
do MakeTestStringJ;
file write `hh' %4.2f (m4bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m5bm)/m5sem));
do MakeTestStringJ;
file write `hh' %4.2f (m5bm) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bm)/m7sem));
do MakeTestStringJ;
file write `hh' %4.2f (m7bm) (teststr) $eolString _n;

file write `hh' " & (" %4.2f (m1sem) ")  &  (" %4.2f (m2sem) ")  &  (" %4.2f (m3sem) ")  &  (" %4.2f (m8sem) ")  &  (" %4.2f (m4sem) ")  &  ("%4.2f (m5sem) ")  &  ("%4.2f (m7sem)  ") "  $eolString _n;

file write `hh' " \$\gamma_{\CEA}$   & ";
sca ptest = 2*(1-normal(abs(m1bCEA)/m1seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m1bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m2bCEA)/m2seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m2bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m3bCEA)/m3seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m3bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m8bCEA)/m8seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m8bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m4bCEA)/m4seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m4bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m5bCEA)/m5seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m5bCEA) (teststr) "  & ";
sca ptest = 2*(1-normal(abs(m7bCEA)/m7seCEA));
do MakeTestStringJ;
file write `hh' %4.2f (m7bCEA) (teststr)  $eolString _n;

file write `hh' " & (" %4.2f (m1seCEA) ")  &  (" %4.2f (m2seCEA) ")  &  (" %4.2f (m3seCEA) ")  &  (" %4.2f (m8seCEA) ")  &  (" %4.2f (m4seCEA) ")  &  ("%4.2f (m5seCEA) ")  &  ("%4.2f (m7seCEA) ")"  $eolString _n;

file write `hh' "\$\gamma_{Eu}$  & ";
sca ptest = 2*(1-normal(abs(m1bunpred)/m1seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m1bunpred) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(m2bunpred)/m2seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m2bunpred) (teststr) "  &  ";

sca ptest = 2*(1-normal(abs(m3bunpred)/m3seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m3bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m8bunpred)/m8seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m8bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m4bunpred)/m4seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m4bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m5bunpred)/m5seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m5bunpred) (teststr) "  & ";

sca ptest = 2*(1-normal(abs(m7bunpred)/m7seunpred));
do MakeTestStringJ;
file write `hh' %4.2f (m7bunpred) (teststr) $eolString _n;

file write `hh' " &   (" %4.2f (m1seunpred) ")  &   (" %4.2f (m2seunpred) ")  &   (" %4.2f (m3seunpred) ")  &   (" %4.2f (m8seunpred) ")  &   (" %4.2f (m4seunpred) ")  &   (" %4.2f (m5seunpred) ")  &   (" %4.2f (m7seunpred) " ) "  $eolString _n;

file write `hh' " \$\gamma_{\sigma}$   & ";
file write `hh' "  & ";
sca ptest = 2*(1-normal(abs(m2bunc)/m2seunc));
do MakeTestStringJ;
file write `hh' %4.2f (m2bunc) (teststr) "  &  &  &  & & " $eolString _n;

file write `hh' " &   &  (" %4.2f (m2seunc) ")  &  &   &  & & " $eolString _n;

file write `hh' " \$\gamma_s$   & ";
file write `hh' "  & & ";
sca ptest = 2*(1-normal(abs(m3bs)/m3ses));
do MakeTestStringJ;
file write `hh' %4.2f (m3bs) (teststr) "  &  &  & & " $eolString _n;

file write `hh' " &   &  & (" %4.2f (m3ses) ")  &  &  & & "  $eolString _n;

file write `hh' " \$\gamma_d$   & ";
file write `hh' "  & & &";
sca ptest = 2*(1-normal(abs(m8bl)/m8sel));
do MakeTestStringJ;
file write `hh' %4.2f (m8bl) (teststr) "  &  &  & " $eolString _n;

file write `hh' " &   &  &  &(" %4.2f (m8sel) ")  &  &  & "  $eolString _n;

file write `hh' " \$\gamma_{r}$  & ";
file write `hh' "  & & & & ";
sca ptest = 2*(1-normal(abs(m4bir)/m4seir));
do MakeTestStringJ;
file write `hh' %4.2f (m4bir) (teststr) "  & & " $eolString _n;

file write `hh' " &   &  & & & (" %4.2f (m4seir) ")  & & " $eolString _n;

file write `hh' " \$\gamma_{GS}$  & ";
file write `hh' "  & & & & ";
sca ptest = 2*(1-normal(abs(m4bgs)/m4segs));
do MakeTestStringJ;
file write `hh' %4.2f (m4bgs) (teststr) "  & & " $eolString _n;

file write `hh' " &   &  & & & (" %4.2f (m4segs) ")  &  & " $eolString _n;

file write `hh' " \$\gamma_{CS}$  & ";
file write `hh' "  & & & &";
sca ptest = 2*(1-normal(abs(m4bcs)/m4secs));
do MakeTestStringJ;
file write `hh' %4.2f (m4bcs) (teststr) "  & & " $eolString _n;

file write `hh' " &   &  & & & (" %4.2f (m4secs) ")  & & "  $eolString _n;


file write `hh' " \$\gamma_{\text{0post80}}$  & ";
file write `hh' "  & & & & &";
sca ptest = 2*(1-normal(abs(m5b0post80)/m5se0post80));
do MakeTestStringJ;
file write `hh' %4.2f (m5b0post80) (teststr) "  &  " $eolString _n;

file write `hh' " &   &  & & & & (" %4.2f (m5se0post80) ")   & "  $eolString _n;


file write `hh' " \$\gamma_{m\text{post80}}$  & ";
file write `hh' "  & & & & &";
sca ptest = 2*(1-normal(abs(m5bmpost80)/m5sempost80));
do MakeTestStringJ;
file write `hh' %4.2f (m5bmpost80) (teststr) "  &  " $eolString _n;

file write `hh' " &   &  & &  & &(" %4.2f (m5sempost80) ")  &  "  $eolString _n;

file write `hh' " \$\gamma_{\CEA\text{post80}}$  & ";
file write `hh' "  & & & & &";
sca ptest = 2*(1-normal(abs(m5bCEApost80)/m5seCEApost80));
do MakeTestStringJ;
file write `hh' %4.2f (m5bCEApost80) (teststr) "  & " $eolString _n;

file write `hh' " &   &  & & & &(" %4.2f (m5seCEApost80) ")  & "  $eolString _n;

/*
file write `hh' " \$\gamma_{Eu\text{post80}}$  & ";
file write `hh' "  & & & & &";
sca ptest = 2*(1-normal(abs(m5bunpredpost80)/m5seunpredpost80));
do MakeTestStringJ;
file write `hh' %4.2f (m5bunpredpost80) (teststr) "  &  " $eolString _n;

file write `hh' " &   &  & &  & & (" %4.2f (m5seunpredpost80) ")  &  "  $eolString _n;
*/;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file close `hh';



