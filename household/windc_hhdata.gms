$stitle		Read a WiNDC Household Dataset 

* --------------------------------------------------------------------------
* set options
* --------------------------------------------------------------------------

*	N.B. Default specification is to skip loading a single year.  If you
*	want to load one year's data, then $set year in the calling program.
*	$if not set year $set year 2017

*	Default dataset to read:

$if not set ds $set ds cps_static

*	File separator

$set sep %system.dirsep%

*	The data directory is defined relative to the location of this file:

$set datadir %system.fp%datasets%sep%

$if not set datafile $set datafile %datadir%WiNDC_%ds%.gdx

* --------------------------------------------------------------------------
* read data
* --------------------------------------------------------------------------

* sets in WiNDC
set
    yr      Years of IO data,
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport),
    h       Household categories,
    trn     Transfer types;    

$gdxin '%datafile%'

$if not defined s $loaddc s

$loaddc yr r m gm h trn

alias(s,g),(r,q);

* time series of parameters
parameter
* core data
    ys0_(yr,r,g,s)  	Sectoral supply,
    id0_(yr,r,s,g)  	Intermediate demand,
    ld0_(yr,r,s)    	Labor demand,
    kd0_(yr,r,s)    	Capital demand,
    ty0_(yr,r,s)    	Output tax on production,
    m0_(yr,r,s)     	Imports,
    x0_(yr,r,s)     	Exports of goods and services,
    rx0_(yr,r,s)    	Re-exports of goods and services,
    md0_(yr,r,m,s)  	Total margin demand,
    nm0_(yr,r,g,m)  	Margin demand from national market,
    dm0_(yr,r,g,m)  	Margin supply from local market,
    s0_(yr,r,s)     	Aggregate supply,
    a0_(yr,r,s)     	Armington supply,
    ta0_(yr,r,s)    	Tax net subsidy rate on intermediate demand,
    tm0_(yr,r,s)    	Import tariff,
    cd0_(yr,r,s)    	Final demand,
    c0_(yr,r)       	Aggregate final demand,
    yh0_(yr,r,s)    	Household production,
    bopdef0_(yr,r)  	Balance of payments,
    hhadj_(yr,r)    	Household adjustment,
    g0_(yr,r,s)     	Government demand,
    i0_(yr,r,s)     	Investment demand,
    xn0_(yr,r,g)    	Regional supply to national market,
    xd0_(yr,r,g)    	Regional supply to local market,
    dd0_(yr,r,g)    	Regional demand from local  market,
    nd0_(yr,r,g)    	Regional demand from national market,

* household data
    pop_(yr,r,h)        Population (households or returns in millions),
    le0_(yr,r,q,h)	Household labor endowment,
    ke0_(yr,r,h)	Household interest payments,
    tk0_(yr,r)          Capital tax rate,
    tl0_(yr,r,h)	Household labor tax rate,
    cd0_h_(yr,r,g,h)    Household level expenditures,
    c0_h_(yr,r,h)	Aggregate household level expenditures,
    sav0_(yr,r,h)	Household saving,
    trn0_(yr,r,h)	Household transfer payments,
    hhtrn0_(yr,r,h,trn) Disaggregate transfer payments
    fsav0_(yr)		Foreign savings;

* production data:
$loaddc ys0_ ld0_ kd0_ id0_ ty0_

* aggregate consumption data:
$loaddc yh0_ cd0_ c0_ i0_ g0_ bopdef0_ hhadj_

* trade data:
$loaddc s0_ xd0_ xn0_ x0_ rx0_ a0_ nd0_ dd0_ m0_ ta0_ tm0_

* margins:
$loaddc md0_ nm0_ dm0_

* household data:
$loaddc le0_ ke0_ tk0_ tl0_ cd0_h_ c0_h_ sav0_ trn0_ hhtrn0_ pop_

* Calculate foreign savings:

fsav0_(yr) = sum((r,g), i0_(yr,r,g)) - sum((r,h), sav0_(yr,r,h));

*	Skip reading data for a single year if not year is provided.

$if not set year $exit

*	Load one year's data:
parameter
    ys0(r,g,s)      Sectoral supply,
    id0(r,s,g)      Intermediate demand,
    ld0(r,s)        Labor demand,
    kd0(r,s)        Capital demand,
    ty0(r,s)        Output tax on production,
    m0(r,s)         Imports,
    x0(r,s)         Exports of goods and services,
    rx0(r,s)        Re-exports of goods and services,
    md0(r,m,s)      Total margin demand,
    nm0(r,g,m)      Margin demand from national market,
    dm0(r,g,m)      Margin supply from local market,
    s0(r,s)         Aggregate supply,
    a0(r,s)         Armington supply,
    ta0(r,s)        Tax net subsidy rate on intermediate demand,
    tm0(r,s)        Import tariff,
    cd0(r,s)        Final demand,
    c0(r)           Aggregate final demand,
    yh0(r,s)        Household production,
    bopdef0(r)      Balance of payments,
    hhadj(r)        Household adjustment,
    g0(r,s)         Government demand,
    i0(r,s)         Investment demand,
    xn0(r,g)        Regional supply to national market,
    xd0(r,g)        Regional supply to local market,
    dd0(r,g)        Regional demand from local  market,
    nd0(r,g)        Regional demand from national market,
    pop(r,h)        Population (households or returns in millions),
    le0(r,q,h)	    Household labor endowment,
    ke0(r,h)	    Household interest payments,
    tk0(r)          Capital tax rate,
    tl0(r,h)	    Household labor tax rate,
    cd0_h(r,g,h)    Household level expenditures,
    c0_h(r,h)	    Aggregate household level expenditures,
    sav0(r,h)	    Household saving,
    govdef0	    Government deficit,
    taxrevL(r)      Tax revenue,
    taxrevK	    Capital tax revenue,
    totsav0	    Aggregate savings,
    trn0(r,h)	    Household transfer payments,
    hhtrn0(r,h,trn) Disaggregate transfer payments,
    fsav0           Foreign savings;

ys0(r,g,s) = ys0_('%year%',r,g,s);
id0(r,s,g) = id0_('%year%',r,s,g);
ld0(r,s) = ld0_('%year%',r,s);
kd0(r,s) = kd0_('%year%',r,s);
ty0(r,s) = ty0_('%year%',r,s);
m0(r,g) = m0_('%year%',r,g);
x0(r,g) = x0_('%year%',r,g);
rx0(r,g) = rx0_('%year%',r,g);
md0(r,m,gm) = md0_('%year%',r,m,gm);
nm0(r,gm,m) = nm0_('%year%',r,gm,m);
dm0(r,gm,m) = dm0_('%year%',r,gm,m);
s0(r,g) = s0_('%year%',r,g);
a0(r,g) = a0_('%year%',r,g);
ta0(r,g) = ta0_('%year%',r,g);
tm0(r,g) = tm0_('%year%',r,g);
cd0(r,g) = cd0_('%year%',r,g);
c0(r) = c0_('%year%',r);
yh0(r,g) = yh0_('%year%',r,g);
bopdef0(r) = bopdef0_('%year%',r);
g0(r,g) = g0_('%year%',r,g);
i0(r,g) = i0_('%year%',r,g);
xn0(r,g) = xn0_('%year%',r,g);
xd0(r,g) = xd0_('%year%',r,g);
dd0(r,g) = dd0_('%year%',r,g);
nd0(r,g) = nd0_('%year%',r,g);
hhadj(r) = hhadj_('%year%',r);
pop(r,h) = pop_('%year%',r,h);
le0(r,q,h) = le0_('%year%',r,q,h);
ke0(r,h) = ke0_('%year%',r,h);
tk0(r) = tk0_('%year%',r);
tl0(r,h) = tl0_('%year%',r,h);
cd0_h(r,g,h) = cd0_h_('%year%',r,g,h);
c0_h(r,h) = c0_h_('%year%',r,h);
sav0(r,h) = sav0_('%year%',r,h);
trn0(r,h) = trn0_('%year%',r,h);
hhtrn0(r,h,trn) = hhtrn0_('%year%',r,h,trn);
fsav0 = fsav0_("%year%");

*	specify sparsity tuples

sets	y_(r,s) "Sectors and regions with positive production",
	x_(r,g) "Disposition by region",
	a_(r,g) "Absorption by region";

y_(r,s) = yes$(sum(g, ys0(r,s,g))>0);
x_(r,g) = yes$s0(r,g);
a_(r,g) = yes$(a0(r,g) + rx0(r,g));

parameter	ty(r,s)		"Counterfactual production tax"
		tm(r,g)		"Counterfactual import tariff"
		ta(r,g)		"Counteractual tax on intermediate demand";

ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
ta(r,g) = ta0(r,g);

* calculate additional aggregate parameters
totsav0 = sum((r,h),sav0(r,h));
taxrevL(q) = sum((r,h),tl0(r,h)*le0(r,q,h));
taxrevK = sum((r,s),tk0(r)*kd0(r,s));
govdef0 = sum((r,g), g0(r,g)) + sum((r,h), trn0(r,h))
	- sum(r, taxrevL(r)) 
	- taxrevK 
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g));
