$title Read the WiNDC Dataset


* ------------------------------------------------------------------------------
* Set options:
* ------------------------------------------------------------------------------

* Pick dataset option
$if not set ds $set ds %system.fp%WiNDCdatabase.gdx

* Pick year to model
$if not set year $set year 2017


* ------------------------------------------------------------------------------
* Read in WiNDC database:
* ------------------------------------------------------------------------------

set
    yr      Years of IO data,
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport);

$gdxin '%ds%'
$loaddc yr r s m gm
alias(s,g);

parameter
    ys0_(yr,r,g,s)  Sectoral supply,
    id0_(yr,r,s,g)  Intermediate demand,
    ld0_(yr,r,s)    Labor demand,
    kd0_(yr,r,s)    Capital demand,
    ty0_(yr,r,s)    Output tax on production,
    m0_(yr,r,s)     Imports,
    x0_(yr,r,s)     Exports of goods and services,
    rx0_(yr,r,s)    Re-exports of goods and services,
    md0_(yr,r,m,s)  Total margin demand,
    nm0_(yr,r,g,m)  Margin demand from national market,
    dm0_(yr,r,g,m)  Margin supply from local market,
    s0_(yr,r,s)     Aggregate supply,
    a0_(yr,r,s)     Armington supply,
    ta0_(yr,r,s)    Tax net subsidy rate on intermediate demand,
    tm0_(yr,r,s)    Import tariff,
    cd0_(yr,r,s)    Final demand,
    c0_(yr,r)       Aggregate final demand,
    yh0_(yr,r,s)    Household production,
    bopdef0_(yr,r)  Balance of payments,
    hhadj0_(yr,r)   Household adjustment,
    g0_(yr,r,s)     Government demand,
    i0_(yr,r,s)     Investment demand,
    xn0_(yr,r,g)    Regional supply to national market,
    xd0_(yr,r,g)    Regional supply to local market,
    dd0_(yr,r,g)    Regional demand from local  market,
    nd0_(yr,r,g)    Regional demand from national market;

* Production data:

$loaddc ys0_ ld0_ kd0_ id0_ ty0_

* Consumption data:

$loaddc yh0_ cd0_ c0_ i0_ g0_ bopdef0_ hhadj0_

* Trade data:

$loaddc s0_ xd0_ xn0_ x0_ rx0_ a0_ nd0_ dd0_ m0_ ta0_ tm0_

* Margins:

$loaddc md0_ nm0_ dm0_
$gdxin


* ------------------------------------------------------------------------------
* Pick year of data to extract from WiNDC database:
* ------------------------------------------------------------------------------

parameters
    ys0(r,s,g)		Sectoral supply,
    id0(r,g,s)		Intermediate demand,
    ld0(r,s)		Labor demand,
    kd0(r,s)		Capital demand,
    ty0(r,s)		Production tax,
    m0(r,g)		Imports,
    x0(r,g)		Exports of goods and services,
    rx0(r,g)		Re-exports of goods and services,
    md0(r,m,g)		Total margin demand,
    nm0(r,g,m)		Margin demand from national market,
    dm0(r,g,m)		Margin supply from local market,
    s0(r,g)		Aggregate supply,
    a0(r,g)		Armington supply,
    ta0(r,g)		Tax net subsidy rate on intermediate demand,
    tm0(r,g)		Import tariff,
    cd0(r,g)		Final demand,
    c0(r)		Aggregate final demand,
    yh0(r,g)		Household production,
    bopdef0(r)		Balance of payments,
    hhadj0(r)		Household adjustment,
    g0(r,g)		Government demand,
    i0(r,g)		Investment demand,
    xn0(r,g)		Regional supply to national market,
    xd0(r,g)		Regional supply to local market,
    dd0(r,g)		Regional demand from local  market,
    nd0(r,g)		Regional demand from national market;

ys0(r,s,g) = ys0_("%year%",r,s,g);
id0(r,g,s) = id0_("%year%",r,g,s);
ld0(r,s) = ld0_("%year%",r,s);
kd0(r,s) = kd0_("%year%",r,s);
ty0(r,s) = ty0_("%year%",r,s);
m0(r,g) = m0_("%year%",r,g);
x0(r,g) = x0_("%year%",r,g);
rx0(r,g) = rx0_("%year%",r,g);
md0(r,m,gm) = md0_("%year%",r,m,gm);
nm0(r,gm,m) = nm0_("%year%",r,gm,m);
dm0(r,gm,m) = dm0_("%year%",r,gm,m);
s0(r,g) = s0_("%year%",r,g);
a0(r,g) = a0_("%year%",r,g);
ta0(r,g) = ta0_("%year%",r,g);
tm0(r,g) = tm0_("%year%",r,g);
cd0(r,g) = cd0_("%year%",r,g);
c0(r) = c0_("%year%",r);
yh0(r,g) = yh0_("%year%",r,g);
bopdef0(r) = bopdef0_("%year%",r);
g0(r,g) = g0_("%year%",r,g);
i0(r,g) = i0_("%year%",r,g);
xn0(r,g) = xn0_("%year%",r,g);
xd0(r,g) = xd0_("%year%",r,g);
dd0(r,g) = dd0_("%year%",r,g);
nd0(r,g) = nd0_("%year%",r,g);
hhadj0(r) = hhadj0_("%year%",r);

* Define conditional tuples for endogenous region/commodity/industry pairings

sets
    y_(r,s) 	Sectors and regions with positive production,
    x_(r,g) 	Disposition by region,
    a_(r,g) 	Absorption by region;

y_(r,s) = yes$(sum(g, ys0(r,s,g))>0);
x_(r,g) = yes$s0(r,g);
a_(r,g) = yes$(a0(r,g) + rx0(r,g));

* Define counterfactural tax rates

parameter
    ty(r,s)	Counterfactual production tax,
    tm(r,g)	Counterfactual import tariff,
    ta(r,g)	Counteractual tax on intermediate demand;

ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
ta(r,g) = ta0(r,g);


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
