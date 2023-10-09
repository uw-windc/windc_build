$title Consolidate household datasets

* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* set year(s) to compute data (cps: 2000-2021, soi: 2014-2017)
$if not set year $set year 2017

* set environment variable for alternative household datasets
$if not set hhdata $set hhdata "cps"

* set invest assumption (static vs. dynamic)
$if not set invest $set invest "dynamic"

* set assumption on capital ownership (all,partial)
$if not set capital_ownership $set capital_ownership "all"

* core data directory:
$if not set core $set core ../core/

* GDX directory:
$set gdxdir gdx/
$if not dexist gdx $call mkdir gdx 

* set output directory
$set datadir datasets/
$if not dexist datasets $call mkdir datasets


* -----------------------------------------------------------------------------
* Grab needed elements of core WiNDC database
* -----------------------------------------------------------------------------

* Read WiNDC base dataset

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'
alias (r,q,rr), (s,g);

* Add capital tax rate

parameter
    tk0    Capital tax rate;

$gdxin "%gdxdir%capital_tax_rates.gdx"
$loaddc tk0
$gdxin

* Set capital demands to be net of tax payments

kd0(r,s) = kd0(r,s) / (1+tk0(r));


* -----------------------------------------------------------------------------
* Consolidate household data into time series
* -----------------------------------------------------------------------------

* Sets included in the data

set
    h     household categories,
    trn   transfer types;    

* Load h and trn from representative file    

$gdxin '%gdxdir%calibrated_hhdata_%invest%_%hhdata%_%capital_ownership%_%year%.gdx'
$load h trn

* Household parameters

parameter
    pop0(r,h)		Population (households or returns in millions),
    le0(r,q,h)		Household labor endowment,
    ke0(r,h)		Household interest payments,
    tl_avg0(r,h)	Average tax rate on labor income,
    tl0(r,h)		Marginal tax rate on labor income,
    tfica0(r,h)		FICA tax rate on labor income,
    cd0_h(r,g,h)	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    fsav0		Foreign savings,
    fint0		Foreign interest payments,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,*)	Disaggregate transfer payments;

$loaddc pop0 le0 ke0 tl_avg0 tl0 tfica0 cd0_h c0_h sav0 trn0 hhtrn0 fsav0 fint0


* -----------------------------------------------------------------------------
* Add steady state parameters if calibrating a dynamic model
* -----------------------------------------------------------------------------

* Unmapped merged parameters

parameter
    ys0ss(r,s,g)	Steady-state output,
    id0ss(r,g,s)	Steady-state intermediate demand,
    dd0ss(r,g)		Steady-state local demand,
    nd0ss(r,g)		Steady-state national demand,
    xd0ss(r,g)		Steady-state local supply,
    xn0ss(r,g)		Steady-state national supply,
    g0ss(r,g)		Steady-state government demand,
    a0ss(r,g)		Steady-state armington supply,
    s0ss(r,g)		Steady-state total supply,
    i0ss(r,g)		Steady-state investment,
    ty0ss(r,s)		Steady-state production tax,
    ta0ss(r,g)		Steady-state commodity tax,
    ir			Stead-state interest rate,
    gr			Steady-state growth rate,
    delta		Steady-state depreciation rate;

$ifthen.dynamic %invest%=="dynamic" 

$gdxin %gdxdir%dynamic_parameters_%year%.gdx
$loaddc ys0ss=ys0 id0ss=id0 dd0ss=dd0 nd0ss=nd0 xd0ss=xd0 xn0ss=xn0 
$loaddc a0ss=a0 s0ss=s0 i0ss=i0 g0ss=g0 ty0ss=ty0 ta0ss=ta0
$loaddc ir gr delta

ys0(r,s,g) = ys0ss(r,s,g);
id0(r,g,s) = id0ss(r,g,s);
dd0(r,g) = dd0ss(r,g);
nd0(r,g) = nd0ss(r,g);
xd0(r,g) = xd0ss(r,g);
xn0(r,g) = xn0ss(r,g);
g0(r,g) = g0ss(r,g);
a0(r,g) = a0ss(r,g);
s0(r,g) = s0ss(r,g);
i0(r,g) = i0ss(r,g);
ty0(r,s) = ty0ss(r,s);
ta0(r,g) = ta0ss(r,g);

$endif.dynamic


* -----------------------------------------------------------------------------
* Add data parameters to a single data container
* -----------------------------------------------------------------------------

* Output the static dataset

$ifthen.static %invest%=="static" 
execute_unload '%datadir%WiNDC_%hhdata%_%invest%_%capital_ownership%_%year%.gdx',

* sets
    r, s, gm, m, h, trn

* base parameters
    ys0, ld0, kd0, id0, ty0, yh0, cd0, c0, i0, g0, bopdef0, hhadj0, 
    s0, xd0, xn0, x0, rx0, a0, nd0, dd0, m0, ta0, tm0, md0, nm0, dm0,
    
* household parameters
    le0, ke0, tk0, tl_avg0, tl0, tfica0, cd0_h, c0_h, sav0, fsav0,
    fint0, trn0, hhtrn0, pop0;
$endif.static

* Output the dynamic dataset

$ifthen.dynamic %invest%=="dynamic" 
execute_unload '%datadir%WiNDC_%hhdata%_%invest%_%capital_ownership%_%year%.gdx',

* sets
    r, s, gm, m, h, trn

* base parameters
    ys0, ld0, kd0, id0, ty0, yh0, cd0, c0, i0, g0, bopdef0, hhadj0, 
    s0, xd0, xn0, x0, rx0, a0, nd0, dd0, m0, ta0, tm0, md0, nm0, dm0,

* steady-state rates
    ir, gr, delta,
    
* household parameters
    le0, ke0, tk0, tl_avg0, tl0, tfica0, cd0_h, c0_h, sav0, fsav0,
    fint0, trn0, hhtrn0, pop0;
$endif.dynamic


* -----------------------------------------------------------------------------
* End
* -----------------------------------------------------------------------------
