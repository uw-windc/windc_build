$title GAMS program for calculating benchmark regional GDP levels

$SET sep %system.dirsep%

SET yr "Years of IO data";
SET r "States";
SET m "Margins (trade or transport)";
SET s "Sectors";

$GDXIN built_datasets%sep%WiNDCdatabase.gdx
$LOADDC yr
$LOADDC r
$LOADDC m
$LOADDC s
ALIAS(s,g);

PARAMETER ys0_(yr,r,s,g) "Sectoral supply";
PARAMETER id0_(yr,r,g,s) "Intermediate demand";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER ty0_(yr,r,s) "Output tax on production";
PARAMETER m0_(yr,r,s) "Imports";
PARAMETER x0_(yr,r,s) "Exports of goods and services";
PARAMETER rx0_(yr,r,s) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,s) "Total margin demand";
PARAMETER nm0_(yr,r,g,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from local market";
PARAMETER s0_(yr,r,s) "Aggregate supply";
PARAMETER a0_(yr,r,s) "Armington supply";
PARAMETER ta0_(yr,r,s) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,s) "Import tariff";
PARAMETER cd0_(yr,r,s) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,s) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,s) "Government demand";
PARAMETER i0_(yr,r,s) "Investment demand";
PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local market";
PARAMETER nd0_(yr,r,g) "Regional demand from national market";

* Production data:

$LOADDC ys0_
$LOADDC ld0_
$LOADDC kd0_
$LOADDC id0_
$LOADDC ty0_

* Consumption data:

$LOADDC yh0_
$LOADDC fe0_
$LOADDC cd0_
$LOADDC c0_
$LOADDC i0_
$LOADDC g0_
$LOADDC bopdef0_
$LOADDC hhadj_

* Trade data:

$LOADDC s0_
$LOADDC xd0_
$LOADDC xn0_
$LOADDC x0_
$LOADDC rx0_
$LOADDC a0_
$LOADDC nd0_
$LOADDC dd0_
$LOADDC m0_
$LOADDC ta0_
$LOADDC tm0_

* Margins:

$LOADDC md0_
$LOADDC nm0_
$LOADDC dm0_

SET agt	"GDP agents in reference model" / C /;
SET cat	"GDP categories" / C, "I+G", "X-M", L, K, TAX, OTH /;

PARAMETER refbudget(yr,*,r,*,*) "Reference budget balance";
PARAMETER refgdp(yr,*,*,*) "GDP totals by category";

refbudget(yr,'expend',r,'C','pc') = c0_(yr,r);
refbudget(yr,'expend',r,'C','pa') = sum(g, i0_(yr,r,g)) + sum(g, g0_(yr,r,g));
refbudget(yr,'income',r,'C','tax') = sum(g, ta0_(yr,r,g) * a0_(yr,r,g)) + sum(g, tm0_(yr,r,g)*m0_(yr,r,g)) + sum(s, ty0_(yr,r,s)*sum(g, ys0_(yr,r,s,g)));
refbudget(yr,'income',r,'C','py') = sum(g, yh0_(yr,r,g));
refbudget(yr,'income',r,'C','pl') = sum(s, ld0_(yr,r,s));
refbudget(yr,'income',r,'C','pk') = sum(s, kd0_(yr,r,s));
refbudget(yr,'income',r,'C','pfx') = hhadj_(yr,r) + bopdef0_(yr,r);

ALIAS(un,*);
refbudget(yr,"total",r,agt,"chksum") = sum(un, refbudget(yr,"expend",r,agt,un)-refbudget(yr,"income",r,agt,un));

* Expenditure approach: ----------------------------------------------------

refgdp(yr,"expend",r,"C") = refbudget(yr,"expend",r,'C',"pc");
refgdp(yr,"expend",r,"I+G") = refbudget(yr,'expend',r,'C','pa');

* Net exports are determined via transfers denominated as foreign
* exchange and through balance of payments.

refgdp(yr,"expend",r,"X-M") = - refbudget(yr,'income',r,'C','pfx');

* Income approach: --------------------------------------------------------

refgdp(yr,"income",r,"L") = refbudget(yr,'income',r,'C','pl');
refgdp(yr,"income",r,"K") = refbudget(yr,'income',r,'C','pk');
refgdp(yr,"income",r,"TAX") = refbudget(yr,'income',r,'C','tax');
refgdp(yr,"income",r,"OTH") = refbudget(yr,'income',r,'C','py');

* Production (value added) approach: --------------------------------------

refgdp(yr,'va',r,s) = ld0_(yr,r,s) + kd0_(yr,r,s) + ty0_(yr,r,s) * sum(g, ys0_(yr,r,s,g));

* Calculate regional and national totals: ---------------------------------

refgdp(yr,'expend',r,'total') = sum(cat, refgdp(yr,'expend',r,cat));
refgdp(yr,'expend','total',un) = sum(r, refgdp(yr,'expend',r,un));
refgdp(yr,'expend','total','total') = sum(cat, refgdp(yr,'expend','total',cat));

refgdp(yr,'income',r,'total') = sum(cat, refgdp(yr,'income',r,cat));
refgdp(yr,'income','total',un) = sum(r, refgdp(yr,'income',r,un));
refgdp(yr,'income','total','total') = sum(cat, refgdp(yr,'income','total',cat));

refgdp(yr,'va',r,'total') = sum(s, refgdp(yr,'va',r,s));
refgdp(yr,'va','total','total') = sum(r, refgdp(yr,'va',r,'total'));

* Check totals match across methods:

refgdp(yr,"chksum",r,"expend") = sum(cat, refgdp(yr,"expend",r,cat));
refgdp(yr,"chksum",r,"income") = sum(cat, refgdp(yr,"income",r,cat));
refgdp(yr,"chksum",r,"chksum") = refgdp(yr,"chksum",r,"expend") - refgdp(yr,"chksum",r,"income");
refgdp(yr,'chksum','total','chksum') = sum(r, refgdp(yr,'chksum',r,'chksum'));
DISPLAY refgdp;

PARAMETER totgdp(yr,*) "Aggregate GDP in Billions of USD";

totgdp(yr,r) = refgdp(yr,'expend',r,'total');
* totgdp(yr,'total') = sum(r, totgdp(yr,r));

DISPLAY totgdp;


* load the values of the parameter into a gdx file
execute_unload 'totgdp.gdx', totgdp;

* get a csv file from the gdx file
execute 'gdxdump totgdp.gdx symb=totgdp format=csv output=totgdp.csv';