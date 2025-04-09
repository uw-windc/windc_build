$title Aggregation routine for windc-household datasets

* --------------------------------------------------------------------------
* Set options
* --------------------------------------------------------------------------

* set year(s) to compute data (cps: 2000-2023, soi: 2014-2017)
$if not set year $set year 2023

* set household data (cps, soi)
$if not set hhdata $set hhdata "cps"

* set investment calibration (static, dynamic)
$if not set invest $set invest "static"

* set assumption on capital ownership (all,partial)
$if not set capital_ownership $set capital_ownership "all"

* Dataset to be aggregated:
$if not set ds $set ds %hhdata%_%invest%_%capital_ownership%_%year%

* Sectoral and regional aggregations:
$if not set smap $set smap bluenote
$if not set rmap $set rmap census_divisions
$set aggr %smap%_%rmap%

* Set directory with mapping
$set mapdir maps/
$set datadir datasets/


* --------------------------------------------------------------------------
* Read the disaggregate state level dataset
* --------------------------------------------------------------------------

$batinclude windc_hhdata %datadir%WiNDC_%ds%

* Read steady state parameters if aggregating dynamic dataset

$ifthen.dynamic %invest%=="dynamic"

$set datafile %datadir%WiNDC_%ds%.gdx
$gdxin '%datafile%'

parameter
    ir		Steady-state interest rate,
    gr		Steady-state growth rate,
    delta	Steady-state depreciation rate;

$loaddc ir gr delta
$gdxin
$endif.dynamic



* --------------------------------------------------------------------------
* Read in sector and region mappings
* --------------------------------------------------------------------------

$include '%mapdir%%smap%.map'
$include '%mapdir%%rmap%.map'


* --------------------------------------------------------------------------
* Canned aggregation routine
* --------------------------------------------------------------------------

set	bug(*)	Mapping errors;

bug(r) = yes$(sum(rmap(rr,r),1)<>1);
abort$card(bug) "Region in r not uniquely mapped. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

bug(s) = yes$(sum(smap(ss,s),1)<>1);
abort$card(bug) "Sector in s not uniquely mapped. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

bug(m) = yes$(sum(mmap(mm,m),1)<>1);
abort$card(bug) "Margin in m not uniquely mapped. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

bug(rr) = yes$(sum(rmap(rr,r),1)=0);
abort$card(bug) "Region in rr has no constituents. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

bug(ss) = yes$(sum(smap(ss,s),1)=0);
abort$card(bug) "Sector in ss has no constituents. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

bug(mm) = yes$(sum(mmap(mm,m),1)=0);
abort$card(bug) "Margin in mm has no constituents. lst/aggr_%ds%_%smap%_%rmap%.lst",bug;

alias (ss,gg), (rr,qq), (smap,gmap), (rmap,qmap);

* Aggregate data parameters

parameter
    ys0__(rr,gg,ss)	Sectoral supply,
    id0__(rr,ss,gg)	Intermediate demand,
    ld0__(rr,ss)	Labor demand,
    kd0__(rr,ss)	Capital demand,
    tk0__(rr)		Capital tax rate,
    ty0__(rr,ss)	Output tax on production,
    m0__(rr,ss)	        Imports,
    x0__(rr,ss)	        Exports of goods and services,
    rx0__(rr,ss)	Re-exports of goods and services,
    md0__(rr,mm,gg)	Total margin demand,
    nm0__(rr,gg,mm)	Margin demand from national market,
    dm0__(rr,gg,mm)	Margin supply from local market,
    s0__(rr,gg)	        Aggregate supply,
    a0__(rr,gg)	        Armington supply,
    ta0__(rr,gg)	Tax net subsidy rate on intermediate demand,
    tm0__(rr,gg)	Import tariff,
    cd0__(rr,gg)	Final demand,
    c0__(rr)		Aggregate final demand,
    yh0__(rr,ss)	Household production,
    fe0__(rr)	        Factor endowments,
    bopdef0__(rr)	Balance of payments,
    hhadj0__(rr)        Household adjustment
    g0__(rr,gg)	        Government demand,
    i0__(rr,gg)	        Investment demand,
    xn0__(rr,gg)	Regional supply to national market,
    xd0__(rr,gg)	Regional supply to local market,
    dd0__(rr,gg)	Regional demand from local market,
    nd0__(rr,gg)	Regional demand from national market,
    le0__(rr,qq,h)	Household labor endowment,
    ke0__(rr,h)		Household interest payments,
    tl_avg0__(rr,h)	Household average labor tax rate,
    tl0__(rr,h)		Household marginal labor tax rate,
    tfica0__(rr,h)	Household payroll tax rate,
    cd0_h__(rr,gg,h)	Household level expenditures,
    c0_h__(rr,h)	Aggregate household level expenditures,
    sav0__(rr,h)	Household saving,
    trn0__(rr,h)	Household transfer payments
    hhtrn0__(rr,h,trn)	Disaggregate transfer payments,
    pop0__(rr,h)	Population (in millions);

ys0__(rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),ys0(r,g,s));
id0__(rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),id0(r,g,s));
ld0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),ld0(r,s));
ty0__(rr,ss)$sum((rmap(rr,r),g,smap(ss,s)),ys0(r,s,g))
		 = sum((rmap(rr,r),g,smap(ss,s)),ty0(r,s)*ys0(r,s,g)) /
		   sum((rmap(rr,r),g,smap(ss,s)),ys0(r,s,g));
tk0__(rr) = sum((rmap(rr,r)), tk0(r)*sum(s, kd0(r,s))) / sum((rmap(rr,r),s), kd0(r,s));
kd0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),kd0(r,s));
x0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),x0(r,s));
nd0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),nd0(r,s));
xn0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),xn0(r,s));
xd0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),xd0(r,s));
dd0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),dd0(r,s));
md0__(rr,mm,ss) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),md0(r,m,s));
dm0__(rr,ss,mm) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),dm0(r,s,m));
nm0__(rr,ss,mm) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),nm0(r,s,m));
s0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),s0(r,s));
a0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),a0(r,s));
rx0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),rx0(r,s));
m0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),m0(r,s));
g0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),g0(r,s));
i0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),i0(r,s));
cd0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),cd0(r,s));
yh0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)),yh0(r,s));
c0__(rr) = sum(rmap(rr,r),c0(r));
bopdef0__(rr) = sum(rmap(rr,r),bopdef0(r));
hhadj0__(rr) = sum(rmap(rr,r),hhadj0(r));

le0__(rr,qq,h) = sum((rmap(rr,r),qmap(qq,q)),le0(r,q,h));
ke0__(rr,h) = sum(rmap(rr,r),ke0(r,h));
tl_avg0__(rr,h) = sum(rmap(rr,r),tl_avg0(r,h)*sum(q,le0(r,q,h))) /
		sum(rmap(rr,r),sum(q,le0(r,q,h)));
tl0__(rr,h) = sum(rmap(rr,r),tl0(r,h)*sum(q,le0(r,q,h))) /
		sum(rmap(rr,r),sum(q,le0(r,q,h)));
tfica0__(rr,h) = sum(rmap(rr,r),tfica0(r,h)*sum(q,le0(r,q,h))) /
		sum(rmap(rr,r),sum(q,le0(r,q,h)));
cd0_h__(rr,gg,h) = sum((rmap(rr,r),gmap(gg,g)),cd0_h(r,g,h));
c0_h__(rr,h) = sum(rmap(rr,r),c0_h(r,h));
sav0__(rr,h) = sum(rmap(rr,r),sav0(r,h));
trn0__(rr,h) = sum(rmap(rr,r),trn0(r,h));
hhtrn0__(rr,h,trn) = sum(rmap(rr,r),hhtrn0(r,h,trn));
pop0__(rr,h) = sum(rmap(rr,r), pop0(r,h));

* Assign averaged tax rates:

ta0__(rr,ss)$a0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)), ta0(r,s)*a0(r,s))/a0__(rr,ss);
tm0__(rr,ss)$m0__(rr,ss) = sum((rmap(rr,r),smap(ss,s)), tm0(r,s)*m0(r,s))/m0__(rr,ss);

* Define goods related to margin supply/demand:

set
    gmm(ss)	Goods with margins;

gmm(ss) = yes$(sum((rr,mm), nm0__(rr,ss,mm) + dm0__(rr,ss,mm)) or sum((rr,mm), md0__(rr,mm,ss)));


* --------------------------------------------------------------------------
* Output target dataset:
* --------------------------------------------------------------------------

* Output the static dataset

$ifthen.static %invest%=="static" 
execute_unload '%datadir%WiNDC_%ds%_%aggr%.gdx',

* sets:
rr=r, ss=s, mm=m, gmm=gm, h, trn,

* production data: 
ys0__=ys0, ld0__=ld0, kd0__=kd0, id0__=id0, ty0__=ty0,

* consumption data:
yh0__=yh0,fe0__=fe0,cd0__=cd0,c0__=c0,i0__=i0,
g0__=g0,bopdef0__=bopdef0,hhadj0__=hhadj0,

* trade data:
s0__=s0,xd0__=xd0,xn0__=xn0,x0__=x0,rx0__=rx0,a0__=a0,
nd0__=nd0,dd0__=dd0,m0__=m0,ta0__=ta0,tm0__=tm0,

* margins:
md0__=md0,nm0__=nm0,dm0__=dm0,

* household data
le0__=le0, ke0__=ke0, tk0__=tk0, tl_avg0__=tl_avg0, tl0__=tl0, tfica0__=tfica0,
cd0_h__=cd0_h, c0_h__=c0_h,sav0__=sav0, pop0__=pop0, trn0__=trn0, hhtrn0__=hhtrn0,
fsav0, fint0;
$endif.static


* Output the dynamic dataset

$ifthen.dynamic %invest%=="dynamic" 
execute_unload '%datadir%WiNDC_%ds%_%aggr%.gdx',

* sets:
rr=r, ss=s, mm=m, gmm=gm, h, trn,

* steady-state parameters:
ir, gr, delta,
    
* production data: 
ys0__=ys0, ld0__=ld0, kd0__=kd0, id0__=id0, ty0__=ty0,

* consumption data:
yh0__=yh0,fe0__=fe0,cd0__=cd0,c0__=c0,i0__=i0,
g0__=g0,bopdef0__=bopdef0,hhadj0__=hhadj0,

* trade data:
s0__=s0,xd0__=xd0,xn0__=xn0,x0__=x0,rx0__=rx0,a0__=a0,
nd0__=nd0,dd0__=dd0,m0__=m0,ta0__=ta0,tm0__=tm0,

* margins:
md0__=md0,nm0__=nm0,dm0__=dm0,

* household data
le0__=le0, ke0__=ke0, tk0__=tk0, tl_avg0__=tl_avg0, tl0__=tl0, tfica0__=tfica0,
cd0_h__=cd0_h, c0_h__=c0_h,sav0__=sav0, pop0__=pop0, trn0__=trn0, hhtrn0__=hhtrn0,
fsav0, fint0;
$endif.dynamic



* --------------------------------------------------------------------------
* End
* --------------------------------------------------------------------------
