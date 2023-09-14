$stitle Data read subroutine for v2.1 bluenote model

* For users that require legacy parameter nomenclature without a household
* decomposition, this program reads the accounts to match the blunote
* parameter indexing from WiNDC v2.1.

* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* Set the dataset
$if not set ds $set ds WiNDC_bluenote_cps_state_2017

* file separator
$set sep %system.dirsep%


* -----------------------------------------------------------------------------
* Read in the base dataset
* -----------------------------------------------------------------------------

* sets in WiNDC
set
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport),
    trn     Transfer types;    

$gdxin 'datasets%sep%%ds%.gdx'
$loaddc r s m trn

* aliased sets
alias(s,g),(r,q,rr);

* time series of parameters
parameter
* core data
    ys0(r,g,s)  	Sectoral supply,
    id0(r,s,g)  	Intermediate demand,
    ld0(r,s)    	Labor demand,
    kd0(r,s)    	Capital demand,
    ty0(r,s)    	Output tax on production,
    tk0(r)              Capital tax rate,
    m0(r,s)     	Imports,
    x0(r,s)     	Exports of goods and services,
    rx0(r,s)    	Re-exports of goods and services,
    md0(r,m,s)  	Total margin demand,
    nm0(r,g,m)  	Margin demand from national market,
    dm0(r,g,m)  	Margin supply from local market,
    s0(r,s)     	Aggregate supply,
    a0(r,s)     	Armington supply,
    ta0(r,s)    	Tax net subsidy rate on intermediate demand,
    tm0(r,s)    	Import tariff,
    cd0(r,s)    	Final demand,
    c0(r)       	Aggregate final demand,
    yh0(r,s)    	Household production,
    bopdef0(r)  	Balance of payments,
    hhadj(r)    	Household adjustment,
    govdef0	   	    Government deficit,
    g0(r,s)     	Government demand,
    i0(r,s)     	Investment demand,
    xn0(r,g)    	Regional supply to national market,
    xd0(r,g)    	Regional supply to local market,
    dd0(r,g)    	Regional demand from local  market,
    nd0(r,g)    	Regional demand from national market,

* bluenote additions
    resco2(r,g)		Residential co2 emissions,
    secco2(r,g,s)	Sector level co2 emissions;

* production data:
$loaddc ys0 ld0 kd0 id0 ty0 tk0

* aggregate consumption data:
$loaddc yh0 cd0 c0 i0 g0 bopdef0 hhadj

* trade data:
$loaddc s0 xd0 xn0 x0 rx0 a0 nd0 dd0 m0 ta0 tm0

* margins:
$loaddc md0 nm0 dm0

* bluenote data:
$loaddc resco2 secco2

* define margin goods
gm(g) = yes$(sum((r,m), nm0(r,g,m) + dm0(r,g,m)) or sum((r,m), md0(r,m,g)));

* specify sparsity parameters
parameter
    y_(r,s)     Sectors and regions with positive production,
    x_(r,g)     Disposition by region,
    a_(r,g)     Absorption by region;

y_(r,s)$(sum(g, ys0(r,s,g))>0) = 1;
x_(r,g)$s0(r,g) = 1;
a_(r,g)$(a0(r,g) + rx0(r,g)) = 1;

