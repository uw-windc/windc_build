$title Read a WiNDC Household Dataset 

* --------------------------------------------------------------------------
* Set options
* --------------------------------------------------------------------------

* Default dataset to read:
$if not set ds $set ds cps_static_all_2017

* The data directory is defined relative to the location of this file:
$if not set datadir $set datadir %system.fp%datasets/
$if not set datafile $set datafile %datadir%WiNDC_%ds%.gdx


* --------------------------------------------------------------------------
* Read data
* --------------------------------------------------------------------------

* Sets in WiNDC

set
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport),
    h       Household categories,
    trn     Transfer types;    

$gdxin '%datafile%'
$loaddc s r m gm h trn
alias(s,g),(r,q);

* Load year of parameters

parameter
    ys0(r,s,g)		Sectoral supply,
    id0(r,g,s)		Intermediate demand,
    ld0(r,s)		Labor demand,
    kd0(r,s)		Capital demand,
    ty0(r,s)		Output tax on production,
    m0(r,s)		Imports,
    x0(r,s)		Exports of goods and services,
    rx0(r,s)		Re-exports of goods and services,
    md0(r,m,s)		Total margin demand,
    nm0(r,g,m)		Margin demand from national market,
    dm0(r,g,m)		Margin supply from local market,
    s0(r,s)		Aggregate supply,
    a0(r,s)		Armington supply,
    ta0(r,s)		Tax net subsidy rate on intermediate demand,
    tm0(r,s)		Import tariff,
    cd0(r,s)		Final demand,
    c0(r)		Aggregate final demand,
    yh0(r,s)		Household production,
    bopdef0(r)		Balance of payments,
    hhadj0(r)		Household adjustment,
    g0(r,s)		Government demand,
    i0(r,s)		Investment demand,
    xn0(r,g)		Regional supply to national market,
    xd0(r,g)		Regional supply to local market,
    dd0(r,g)		Regional demand from local  market,
    nd0(r,g)		Regional demand from national market,
    pop0(r,h)		Population (households or returns in millions),
    le0(r,q,h)		Household labor endowment,
    ke0(r,h)		Household interest payments,
    tk0(r)		Capital tax rate,
    tl_avg0(r,h)	Household average labor tax rate,
    tl0(r,h)		Household marginal labor tax rate,
    tfica0(r,h)		Household FICA labor tax rate,
    cd0_h(r,g,h)	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    fsav0		Foreign savings,
    fint0		Foreign interest payments,
    govdef0		Government deficit,
    taxrevL(r)		Tax revenue,
    taxrevK		Capital tax revenue,
    totsav0		Aggregate savings,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,trn)	Disaggregate transfer payments;

* production data:
$loaddc ys0 ld0 kd0 id0 ty0

* aggregate consumption data:
$loaddc yh0 cd0 c0 i0 g0 bopdef0 hhadj0

* trade data:
$loaddc s0 xd0 xn0 x0 rx0 a0 nd0 dd0 m0 ta0 tm0

* margins:
$loaddc md0 nm0 dm0

* household data:
$loaddc le0 ke0 tk0 tl_avg0 tl0 tfica0 cd0_h c0_h sav0 trn0 hhtrn0 pop0 fsav0 fint0

* Specify sparsity tuples

sets	y_(r,s) "Sectors and regions with positive production",
	x_(r,g) "Disposition by region",
	a_(r,g) "Absorption by region";

y_(r,s) = yes$(round(sum(g, ys0(r,s,g)),6)>0);
x_(r,g) = yes$round(s0(r,g),6);
a_(r,g) = yes$(round(a0(r,g) + rx0(r,g),6));

* calculate additional aggregate parameters
totsav0 = sum((r,h),sav0(r,h));
taxrevL(q) = sum((r,h),(tl_avg0(r,h)+tfica0(r,h))*le0(r,q,h));
taxrevK = sum((r,s),tk0(r)*kd0(r,s));
govdef0 = sum((r,g), g0(r,g)) + sum((r,h), trn0(r,h))
	- sum(r, taxrevL(r)) 
	- taxrevK 
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g));


* --------------------------------------------------------------------------
* End
* --------------------------------------------------------------------------
