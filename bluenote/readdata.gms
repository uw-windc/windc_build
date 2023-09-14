$stitle Data read subroutine for static and dynamic models

* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* Set the dataset
$if not set ds $set ds WiNDC_bluenote_cps_state_2017

* File separator
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
    h       Household categories,
    trn     Transfer types;    

$gdxin 'datasets%sep%%ds%.gdx'
$loaddc r s m h trn

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
    g0(r,s)     	Government demand,
    i0(r,s)     	Investment demand,
    xn0(r,g)    	Regional supply to national market,
    xd0(r,g)    	Regional supply to local market,
    dd0(r,g)    	Regional demand from local  market,
    nd0(r,g)    	Regional demand from national market,

* household data
    pop(r,h)		Population (households or returns in millions),
    le0(r,q,h)		Household labor endowment,
    ke0(r,h)		Household interest payments,
    tk0(r)            	Capital tax rate,
    tl0(r,h)		Household labor tax rate,
    cd0_h(r,g,h)    	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    fsav0           	Foreign savings,
    totsav0	    	Aggregate savings,
    govdef0	   	Government deficit,
    taxrevL(r)     	Tax revenue,
    taxrevK	    	Capital tax revenue,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,trn) 	Disaggregate transfer payments,

* bluenote additions
    resco2(r,g)		Residential co2 emissions,
    secco2(r,g,s)	Sector level co2 emissions;

* production data:
$loaddc ys0 ld0 kd0 id0 ty0

* aggregate consumption data:
$loaddc yh0 cd0 c0 i0 g0 bopdef0 hhadj

* trade data:
$loaddc s0 xd0 xn0 x0 rx0 a0 nd0 dd0 m0 ta0 tm0

* margins:
$loaddc md0 nm0 dm0

* household data:
$loaddc le0 ke0 tk0 tl0 cd0_h c0_h sav0 trn0 hhtrn0 pop

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

* calculate additional aggregate parameters
totsav0 = sum((r,h), sav0(r,h));
fsav0 = sum((r,g), i0(r,g)) - totsav0;
taxrevL(rr) = sum((r,h),tl0(r,h)*le0(r,rr,h));
taxrevK = sum((r,s),tk0(r)*kd0(r,s));
govdef0 = sum((r,g), g0(r,g)) + sum((r,h), trn0(r,h))
	- sum(r, taxrevL(r)) 
	- taxrevK 
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g));