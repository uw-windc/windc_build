$title	aggregation routine for windc-household datasets

* --------------------------------------------------------------------------
* set options
* --------------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

*	Dataset to be aggregated:

$if not set ds $set ds cps_static

*	Sectoral and regional aggregations:

$if not set smap $set smap bluenote
$if not set rmap $set rmap census
$set aggr %smap%_%rmap%

$set mapdir maps%sep%
$set datadir %system.fp%datasets%sep%

* --------------------------------------------------------------------------
*	Read the disaggregate state level dataset:
* --------------------------------------------------------------------------

$batinclude %system.fp%windc_hhdata %datadir%WiNDC_%ds%

* --------------------------------------------------------------------------
* give the aggregation a name and include the files which aggregate
* sectors and states/regions:
* --------------------------------------------------------------------------

$include '%mapdir%%smap%.map'
$include '%mapdir%%rmap%.map'

* --------------------------------------------------------------------------
* part 2: canned aggregation routine
* --------------------------------------------------------------------------

set	bug(*)	Mapping errors;

bug(r) = yes$(sum(rmap(rr,r),1)<>1);
abort$card(bug) "Region in r not uniquely mapped.",bug;

bug(s) = yes$(sum(smap(ss,s),1)<>1);
abort$card(bug) "Sector in s not uniquely mapped.",bug;

bug(m) = yes$(sum(mmap(mm,m),1)<>1);
abort$card(bug) "Margin in m not uniquely mapped.",bug;

bug(rr) = yes$(sum(rmap(rr,r),1)=0);
abort$card(bug) "Region in rr has no constituents.",bug;

bug(ss) = yes$(sum(smap(ss,s),1)=0);
abort$card(bug) "Sector in ss has no constituents.",bug;

bug(mm) = yes$(sum(mmap(mm,m),1)=0);
abort$card(bug) "Margin in mm has no constituents.",bug;

alias (ss,gg), (rr,qq), (smap,gmap), (rmap,qmap);

* aggregate data parameters
parameter
    ys0__(yr,rr,gg,ss)		Sectoral supply,
    id0__(yr,rr,ss,gg)		Intermediate demand,
    ld0__(yr,rr,ss)		Labor demand,
    kd0__(yr,rr,ss)		Capital demand,
    tk0__(yr,rr)		Capital tax rate,
    ty0__(yr,rr,ss)		Output tax on production,
    m0__(yr,rr,ss)	        Imports,
    x0__(yr,rr,ss)	        Exports of goods and services,
    rx0__(yr,rr,ss)		Re-exports of goods and services,
    md0__(yr,rr,mm,gg)		Total margin demand,
    nm0__(yr,rr,gg,mm)		Margin demand from national market,
    dm0__(yr,rr,gg,mm)		Margin supply from local market,
    s0__(yr,rr,gg)	        Aggregate supply,
    a0__(yr,rr,gg)	        Armington supply,
    ta0__(yr,rr,gg)		Tax net subsidy rate on intermediate demand,
    tm0__(yr,rr,gg)		Import tariff,
    cd0__(yr,rr,gg)		Final demand,
    c0__(yr,rr)			Aggregate final demand,
    yh0__(yr,rr,ss)		Household production,
    fe0__(yr,rr)	        Factor endowments,
    bopdef0__(yr,rr)		Balance of payments,
    hhadj__(yr,rr)	        Household adjustment
    g0__(yr,rr,gg)	        Government demand,
    i0__(yr,rr,gg)	        Investment demand,
    xn0__(yr,rr,gg)		Regional supply to national market,
    xd0__(yr,rr,gg)		Regional supply to local market,
    dd0__(yr,rr,gg)		Regional demand from local market,
    nd0__(yr,rr,gg)		Regional demand from national market,
    le0__(yr,rr,qq,h)		Household labor endowment,
    ke0__(yr,rr,h)		Household interest payments,
    tl0__(yr,rr,h)		Household direct tax rate
    cd0_h__(yr,rr,gg,h)		Household level expenditures,
    c0_h__(yr,rr,h)		Aggregate household level expenditures,
    sav0__(yr,rr,h)		Household saving,
    trn0__(yr,rr,h)		Household transfer payments
    hhtrn0__(yr,rr,h,trn)  	Disaggregate transfer payments,
    pop__(yr,rr,h)         	Population (in millions);

ys0__(yr,rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),ys0_(yr,r,g,s));
id0__(yr,rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),id0_(yr,r,g,s));
ld0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),ld0_(yr,r,s));
ty0__(yr,rr,ss)$sum((rmap(rr,r),g,smap(ss,s)),ys0_(yr,r,s,g))
		 = sum((rmap(rr,r),g,smap(ss,s)),ty0_(yr,r,s)*ys0_(yr,r,s,g)) /
		   sum((rmap(rr,r),g,smap(ss,s)),ys0_(yr,r,s,g));
tk0__(yr,rr) = sum((rmap(rr,r)), tk0_(yr,r)*sum(s, kd0_(yr,r,s))) / sum((rmap(rr,r),s), kd0_(yr,r,s));
kd0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),kd0_(yr,r,s));
x0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),x0_(yr,r,s));
nd0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),nd0_(yr,r,s));
xn0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),xn0_(yr,r,s));
xd0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),xd0_(yr,r,s));
dd0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),dd0_(yr,r,s));
md0__(yr,rr,mm,ss) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),md0_(yr,r,m,s));
dm0__(yr,rr,ss,mm) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),dm0_(yr,r,s,m));
nm0__(yr,rr,ss,mm) = sum((rmap(rr,r),mmap(mm,m),smap(ss,s)),nm0_(yr,r,s,m));
s0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),s0_(yr,r,s));
a0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),a0_(yr,r,s));
rx0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),rx0_(yr,r,s));
m0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),m0_(yr,r,s));
g0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),g0_(yr,r,s));
i0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),i0_(yr,r,s));
cd0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),cd0_(yr,r,s));
yh0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),yh0_(yr,r,s));
c0__(yr,rr) = sum(rmap(rr,r),c0_(yr,r));
bopdef0__(yr,rr) = sum(rmap(rr,r),bopdef0_(yr,r));
hhadj__(yr,rr) = sum(rmap(rr,r),hhadj_(yr,r));

le0__(yr,rr,qq,h) = sum((rmap(rr,r),qmap(qq,q)),le0_(yr,r,q,h));
ke0__(yr,rr,h) = sum(rmap(rr,r),ke0_(yr,r,h));
tl0__(yr,rr,h) = sum(rmap(rr,r),tl0_(yr,r,h)*sum(q,le0_(yr,r,q,h))) /
		sum(rmap(rr,r),sum(q,le0_(yr,r,q,h)));
cd0_h__(yr,rr,gg,h) = sum((rmap(rr,r),gmap(gg,g)),cd0_h_(yr,r,g,h));
c0_h__(yr,rr,h) = sum(rmap(rr,r),c0_h_(yr,r,h));
sav0__(yr,rr,h) = sum(rmap(rr,r),sav0_(yr,r,h));
trn0__(yr,rr,h) = sum(rmap(rr,r),trn0_(yr,r,h));
hhtrn0__(yr,rr,h,trn) = sum(rmap(rr,r),hhtrn0_(yr,r,h,trn));
pop__(yr,rr,h) = sum(rmap(rr,r), pop_(yr,r,h));

* assign averaged tax rates:
ta0__(yr,rr,ss)$a0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)), ta0_(yr,r,s)*a0_(yr,r,s))/a0__(yr,rr,ss);
tm0__(yr,rr,ss)$m0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)), tm0_(yr,r,s)*m0_(yr,r,s))/m0__(yr,rr,ss);

* define goods related to margin supply/demand:
set
    gmm(ss)	Goods with margins;

gmm(ss) = yes$(sum((yr,rr,mm), nm0__(yr,rr,ss,mm) + dm0__(yr,rr,ss,mm)) or sum((yr,rr,mm), md0__(yr,rr,mm,ss)));


* --------------------------------------------------------------------------
* output target dataset:
* --------------------------------------------------------------------------

execute_unload '%datadir%WiNDC_%ds%_%aggr%.gdx',

* sets:
yr, rr=r, ss=s, mm=m, gmm=gm, h, trn,

* production data: 
ys0__=ys0_, ld0__=ld0_, kd0__=kd0_, id0__=id0_, ty0__=ty0_,

* consumption data:
yh0__=yh0_,fe0__=fe0_,cd0__=cd0_,c0__=c0_,i0__=i0_,
g0__=g0_,bopdef0__=bopdef0_,hhadj__=hhadj_,

* trade data:
s0__=s0_,xd0__=xd0_,xn0__=xn0_,x0__=x0_,rx0__=rx0_,a0__=a0_,
nd0__=nd0_,dd0__=dd0_,m0__=m0_,ta0__=ta0_,tm0__=tm0_,

* margins:
md0__=md0_,nm0__=nm0_,dm0__=dm0_,

* household data
le0__=le0_, ke0__=ke0_, tk0__=tk0_, tl0__=tl0_, cd0_h__=cd0_h_, c0_h__=c0_h_,
sav0__=sav0_, pop__=pop_, trn0__=trn0_, hhtrn0__=hhtrn0_;
