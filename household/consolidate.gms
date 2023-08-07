$title consolidate years of available windc data with households

* -----------------------------------------------------------------------------
* set options
* -----------------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

* set environment variable for years of available household data
$if not set hh_years $set hh_years "2017"

* set environment variable for alternative household datasets
$if not set hhdata $set hhdata "cps"

* set invest assumption (static vs. dynamic)
$if not set invest $set invest "dynamic"

*	Core data directory:
$if not set core $set core ..%sep%core%sep%

*	GDX directory:

$set gdxdir gdx%sep%
$if not dexist gdx $call mkdir gdx 

$set datadir datasets%sep%
$if not dexist datasets $call mkdir datasets

* -----------------------------------------------------------------------------
* grab needed elements of core WiNDC database
* -----------------------------------------------------------------------------

* sets in WiNDC
set
    yr      Years of IO data,
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport);

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'

alias (r,q,rr), (s,g);

set    yrh(yr) Subsample with available household data / %hh_years% /;


*	Keep years of data with corresponding household information

ys0_(yr,r,g,s)$(not yrh(yr)) = 0;
id0_(yr,r,s,g)$(not yrh(yr)) = 0;
ld0_(yr,r,s)$(not yrh(yr)) = 0;
kd0_(yr,r,s)$(not yrh(yr)) = 0;
ty0_(yr,r,s)$(not yrh(yr)) = 0;
m0_(yr,r,g)$(not yrh(yr)) = 0;
x0_(yr,r,g)$(not yrh(yr)) = 0;
rx0_(yr,r,g)$(not yrh(yr)) = 0;
md0_(yr,r,m,gm)$(not yrh(yr)) = 0;
nm0_(yr,r,gm,m)$(not yrh(yr)) = 0;
dm0_(yr,r,gm,m)$(not yrh(yr)) = 0;
s0_(yr,r,g)$(not yrh(yr)) = 0;
a0_(yr,r,g)$(not yrh(yr)) = 0;
ta0_(yr,r,g)$(not yrh(yr)) = 0;
tm0_(yr,r,g)$(not yrh(yr)) = 0;
cd0_(yr,r,g)$(not yrh(yr)) = 0;
c0_(yr,r)$(not yrh(yr)) = 0;
yh0_(yr,r,g)$(not yrh(yr)) = 0;
bopdef0_(yr,r)$(not yrh(yr)) = 0;
g0_(yr,r,g)$(not yrh(yr)) = 0;
i0_(yr,r,g)$(not yrh(yr)) = 0;
xn0_(yr,r,g)$(not yrh(yr)) = 0;
xd0_(yr,r,g)$(not yrh(yr)) = 0;
dd0_(yr,r,g)$(not yrh(yr)) = 0;
nd0_(yr,r,g)$(not yrh(yr)) = 0;
hhadj_(yr,r)$(not yrh(yr)) = 0;

* add capital tax rate
parameter
    tk0_(yr,r)  Capital tax rate,
    tk0(*,r)    Annual rates to be consolidated;

* in general, because file names are inclusive of the year, we construct a time
* series using gdxmerge. the same code is used for households and steady state
* parameters.
 set
     mapcap(*,*) /  capital_taxrate_2014.2014,
                     capital_taxrate_2015.2015,
                     capital_taxrate_2016.2016,
                     capital_taxrate_2017.2017 /;
alias(u,*);
$call gdxmerge %gdxdir%capital_taxrate_*.gdx output=%gams.scrdir%merged.gdx
$gdxin %gams.scrdir%merged.gdx
$load tk0
tk0_(yr,r) = sum(mapcap(u,yr), tk0(u,r));

* set capital demands to be net of tax payments
kd0_(yr,r,s) = kd0_(yr,r,s) / (1+tk0_(yr,r));

* -----------------------------------------------------------------------------
* consolidate household data into time series
* -----------------------------------------------------------------------------

* sets included in the data
set
    h     household categories,
    trn   transfer types;    

* load h and trn from representative file    
$gdxin '%gdxdir%calibrated_hhdata_%hhdata%_%invest%_%hh_years%.gdx'
$load h trn

* household parameters
parameter
    pop0_(yr,r,h)          Population (households or returns in millions),
    le0_(yr,r,q,h)	  Household labor endowment,
    ke0_(yr,r,h)	  Household interest payments,
    tl0_(yr,r,h)	  Household labor tax rate,
    cd0_h_(yr,r,g,h)      Household level expenditures,
    c0_h_(yr,r,h)	  Aggregate household level expenditures,
    sav0_(yr,r,h)	  Household saving,
    trn0_(yr,r,h)	  Household transfer payments,
    hhtrn0_(yr,r,h,*)     Disaggregate transfer payments;

* merged parameters
parameter
    le0, ke0, tl0, cd0_h, c0_h, sav0, trn0, hhtrn0, pop0;

set
    maphh(*,yr) / calibrated_hhdata_%hhdata%_%invest%_2014.2014,
                  calibrated_hhdata_%hhdata%_%invest%_2015.2015,
		  calibrated_hhdata_%hhdata%_%invest%_2016.2016,
		  calibrated_hhdata_%hhdata%_%invest%_2017.2017 /;

* read in static parameters
$call gdxmerge %gdxdir%calibrated_hhdata_%hhdata%_%invest%_*.gdx output=%gdxdir%hh_%invest%.gdx
$gdxin %gdxdir%hh_%invest%.gdx
$load le0 ke0 tl0 cd0_h c0_h sav0 trn0 hhtrn0 pop0

le0_(yr,r,q,h) = sum(maphh(u,yr), le0(u,r,q,h));
ke0_(yr,r,h) = sum(maphh(u,yr), ke0(u,r,h));
tl0_(yr,r,h) = sum(maphh(u,yr), tl0(u,r,h));
cd0_h_(yr,r,g,h) = sum(maphh(u,yr), cd0_h(u,r,g,h));
c0_h_(yr,r,h) = sum(maphh(u,yr), c0_h(u,r,h));
sav0_(yr,r,h) = sum(maphh(u,yr), sav0(u,r,h));
trn0_(yr,r,h) = sum(maphh(u,yr), trn0(u,r,h));
hhtrn0_(yr,r,h,trn) = sum(maphh(u,yr), hhtrn0(u,r,h,trn));
pop0_(yr,r,h) = sum(maphh(u,yr), pop0(u,r,h));

* -----------------------------------------------------------------------------
* if reading in dynamic data, consolidate additional steady state parameters
* -----------------------------------------------------------------------------

* unmapped merged parameters
parameter
    ys0ss(*,r,s,g)	Dynamic output,
    id0ss(*,r,g,s)	Dynamic intermediate demand,
    dd0ss(*,r,g)	Dynamic local demand,
    nd0ss(*,r,g)	Dynamic national demand,
    xd0ss(*,r,g)	Dynamic local supply,
    xn0ss(*,r,g)	Dynamic national supply,
    g0ss(*,r,g)		Dynamic government demand,
    a0ss(*,r,g)		Dynamic armington supply,
    s0ss(*,r,g)		Dynamic total supply,
    i0ss(*,r,g)		Dynamic investment,
    ty0ss(*,r,s)        Dynamic production tax,
    ta0ss(*,r,g)        Dynamic commodity tax;

set
    mapss(*,yr) / dynamic_parameters_2014.2014,
                  dynamic_parameters_2015.2015,
		  dynamic_parameters_2016.2016,
		  dynamic_parameters_2017.2017 /;

$ifthen.dynamic %invest%=="dynamic" 

$call gdxmerge %gdxdir%dynamic_parameters_*.gdx output=%gdxdir%dynamic.gdx
$gdxin %gdxdir%dynamic.gdx

$load ys0ss=ys0 id0ss=id0 dd0ss=dd0 nd0ss=nd0 xd0ss=xd0 xn0ss=xn0 
$load a0ss=a0 s0ss=s0 i0ss=i0 g0ss=g0 ty0ss=ty0 ta0ss=ta0

	ys0_(yr,r,s,g) = sum(mapss(u,yr), ys0ss(u,r,s,g));
	id0_(yr,r,g,s) = sum(mapss(u,yr), id0ss(u,r,g,s));
	dd0_(yr,r,g) = sum(mapss(u,yr), dd0ss(u,r,g));
	nd0_(yr,r,g) = sum(mapss(u,yr), nd0ss(u,r,g));
	xd0_(yr,r,g) = sum(mapss(u,yr), xd0ss(u,r,g));
	xn0_(yr,r,g) = sum(mapss(u,yr), xn0ss(u,r,g));
	g0_(yr,r,g) = sum(mapss(u,yr), g0ss(u,r,g));
	a0_(yr,r,g) = sum(mapss(u,yr), a0ss(u,r,g));
	s0_(yr,r,g) = sum(mapss(u,yr), s0ss(u,r,g));
	i0_(yr,r,g) = sum(mapss(u,yr), i0ss(u,r,g));
	ty0_(yr,r,s) = sum(mapss(u,yr), ty0ss(u,r,s));
	ta0_(yr,r,g) = sum(mapss(u,yr), ta0ss(u,r,g));
$endif.dynamic

parameter	plchk;
plchk(yr,r,"ld0") = sum(s,ld0_(yr,r,s));
plchk(yr,q,"le0") = sum((r,h),le0_(yr,r,q,h));
plchk(yr,r,"chk") = plchk(yr,r,"ld0") - plchk(yr,r,"le0");
display plchk;

* -----------------------------------------------------------------------------
* add data parameters to a single data container
* -----------------------------------------------------------------------------

execute_unload '%datadir%WiNDC_%hhdata%_%invest%.gdx',

* sets
    yrh=yr, r, s, gm, m, h, trn

* base parameters
    ys0_, ld0_, kd0_, id0_, ty0_, yh0_, cd0_, c0_, i0_, g0_, bopdef0_, hhadj_, 
    s0_, xd0_, xn0_, x0_, rx0_, a0_, nd0_, dd0_, m0_, ta0_, tm0_, md0_, nm0_, dm0_,

* household parameters
    le0_, ke0_, tk0_, tl0_, cd0_h_, c0_h_, sav0_, trn0_, hhtrn0_, pop0_;