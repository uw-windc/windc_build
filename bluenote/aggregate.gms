$title Sectoral/regional (dis)aggregation routine

* A customized sectoral aggregation/disaggregation requires both disaggregation
* from the 2007-2012 tables and re-aggregation after separating a given
* sector. We provide examples stored in the defines directory for the reference
* case, an energy based and agricultural based dataset. A mechanism for regional
* aggregations are also provided.

* The sectoral disaggregation and subsequent aggregation is done in two
* parts. This program is the latter of the two.
* 	Part 1: Sectoral disaggregation based on choices from 2007-2012 table.
* 	Part 2: Canned routine which aggregates the rest of the dataset.

* Point routine to the correct aggregation file. Environment variable "aggr" must
* be set to the NAME of the mapping file. 'ref' is the reference case without
* any sectoral/regional disaggregation/aggregation and provided only a base to
* work from in the boilerplay portion of the program. Make distinction between
* intended regions/sectors in the target vs. origin dataset.

* ------------------------------------------------------------------------------
* set options
* ------------------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

*	Sectoral aggregation is always bluenote:

$if not set smap $set smap bluenote

*	Regional aggregation could be census rather than state:

$if not set rmap $set rmap state

*	Could be soi:

$if not set hhdata $set hhdata cps

*	Output file contains the dataset name and the aggregation info:

$set dsout %hhdata%_%rmap%

*	The input data file is in the bluenote/gdx directory, so we
*	need to define datafile in the call to windc_hhdata, otherwise
*	it assumes the data file is in the household directory.
$set datafile %system.fp%gdx%sep%%hhdata%.gdx

*	Point to the household data directory:

$set hhdatadir %system.fp%..%sep%household%sep%

*	Read the household data:

$set ds WiNDC_%hhdata%_static

$include %hhdatadir%windc_hhdata

*	Sector and region mapping files are in the maps subdirectory:

$if not set mapdir $set mapdir %system.fp%maps%sep%

* --------------------------------------------------------------------------
* Read the sector and geographic mapping files:

$INCLUDE %mapdir%%smap%.map
$INCLUDE %mapdir%%rmap%.map

* --------------------------------------------------------------------------
* Part 2: Aggregation Routine

set bug(*) "Mapping errors";

bug(r) = yes$(sum(rmap(rr,r), 1) <> 1);
abort$card(bug) "Region in r not uniquely mapped.",bug;

bug(s) = yes$(sum(smap(ss,s), 1) <> 1);
abort$card(bug) "Sector in s not uniquely mapped.",bug;

bug(m) = yes$(sum(mmap(mm,m), 1) <> 1);
abort$card(bug) "Margin in m not uniquely mapped.",bug;

bug(rr) = yes$(sum(rmap(rr,r), 1) = 0);
abort$card(bug) "Region in rr has no constituents.",bug;

bug(ss) = yes$(sum(smap(ss,s), 1) = 0);
abort$card(bug) "Sector in ss has no constituents.",bug;

bug(mm) = yes$(sum(mmap(mm,m), 1) = 0);
abort$card(bug) "Margin in mm has no constituents.",bug;

alias(ss,gg), (r,q), (rr,qq), (smap,gmap), (rmap,qmap);

parameters	ys0__(yr,rr,gg,ss)	"Sectoral supply",
		id0__(yr,rr,ss,gg)	"Intermediate demand",
		ld0__(yr,rr,ss)		"Labor demand",
		kd0__(yr,rr,ss)		"Capital demand",
		tk0__(yr,rr)		"Capital tax rate",
		ty0__(yr,rr,ss)		"Production tax rate",
		m0__(yr,rr,ss)		"Imports",
		x0__(yr,rr,ss)		"Exports of goods and services",
		rx0__(yr,rr,ss)		"Re-exports of goods and services",
		md0__(yr,rr,mm,gg)	"Total margin demand",
		nm0__(yr,rr,gg,mm)	"Margin demand from national market",
		dm0__(yr,rr,gg,mm)	"Margin supply from local market",
		s0__(yr,rr,gg)		"Aggregate supply",
		a0__(yr,rr,gg)		"Armington supply",
		ta0__(yr,rr,gg)		"Tax net subsidy rate on intermediate demand",
		tm0__(yr,rr,gg)		"Import tariff",
		cd0__(yr,rr,gg)		"Final demand",
		c0__(yr,rr)		"Aggregate final demand",
		yh0__(yr,rr,ss)		"Household production",
		bopdef0__(yr,rr)	"Balance of payments",
		hhadj__(yr,rr)		"Household adjustment",
		g0__(yr,rr,gg)		"Government demand",
		i0__(yr,rr,gg)		"Investment demand",
		xn0__(yr,rr,gg)		"Regional supply to national market",
		xd0__(yr,rr,gg)		"Regional supply to local market",
		dd0__(yr,rr,gg)		"Regional demand from local market",
		nd0__(yr,rr,gg)		"Regional demand from national market",

		le0__(yr,rr,qq,h)	"Household labor endowment",
		ke0__(yr,rr,h)		"Household interest payments",
		tl0__(yr,rr,h)		"Household direct tax rate",
		cd0_h__(yr,rr,gg,h)	"Household level expenditures",
		c0_h__(yr,rr,h)		"Aggregate household level expenditures",
		sav0__(yr,rr,h)		"Household saving",
		trn0__(yr,rr,h)		"Household transfer payments",
		hhtrn0__(yr,rr,h,trn)  	"Disaggregate transfer payments",
		pop__(yr,rr,h)         	"Population (in millions)";

ys0__(yr,rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),ys0_(yr,r,g,s));
id0__(yr,rr,gg,ss) = sum((rmap(rr,r),gmap(gg,g),smap(ss,s)),id0_(yr,r,g,s));
ld0__(yr,rr,ss) = sum((rmap(rr,r),smap(ss,s)),ld0_(yr,r,s));
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

* Assign averaged tax rates:

tk0__(yr,rr) = sum(rmap(rr,r), tk0_(yr,r)*sum(s, kd0_(yr,r,s))) / sum(ss, kd0__(yr,rr,ss));
ty0__(yr,rr,ss)$sum(gg,ys0__(yr,rr,ss,gg)) = 
	sum((rmap(rr,r),smap(ss,s)), ty0_(yr,r,s)*sum(g, ys0_(yr,r,s,g)))/
		sum(gg, ys0__(yr,rr,ss,gg));
ta0__(yr,rr,ss)$a0__(yr,rr,ss)	= sum((rmap(rr,r),smap(ss,s)), ta0_(yr,r,s)*a0_(yr,r,s))/a0__(yr,rr,ss);
tm0__(yr,rr,ss)$m0__(yr,rr,ss)	= sum((rmap(rr,r),smap(ss,s)), tm0_(yr,r,s)*m0_(yr,r,s))/m0__(yr,rr,ss);

* Define goods related to margin supply/demand:

set	gmm(ss) "Goods with margins";

gmm(ss) = yes$(sum((yr,rr,mm), nm0__(yr,rr,ss,mm) + dm0__(yr,rr,ss,mm)) or sum((yr,rr,mm), md0__(yr,rr,mm,ss)));

* --------------------------------------------------------------------------
* Output target dataset:

execute_unload '%system.fp%gdx%sep%%dsout%.gdx',

* Sets:

	yr,rr=r,ss=s,mm=m,gmm=gm,h,trn,

* Production data:

	ys0__=ys0_,ld0__=ld0_,kd0__=kd0_,id0__=id0_,ty0__=ty0_,

* Consumption data:

	yh0__=yh0_,cd0__=cd0_,c0__=c0_,i0__=i0_,
	g0__=g0_,bopdef0__=bopdef0_,hhadj__=hhadj_,

* Trade data:

	s0__=s0_,xd0__=xd0_,xn0__=xn0_,x0__=x0_,rx0__=rx0_,a0__=a0_,
	nd0__=nd0_,dd0__=dd0_,m0__=m0_,ta0__=ta0_,tm0__=tm0_,

* Margins:

	md0__=md0_,nm0__=nm0_,dm0__=dm0_,

* household data
	le0__=le0_, ke0__=ke0_, tk0__=tk0_, tl0__=tl0_, cd0_h__=cd0_h_, c0_h__=c0_h_,
	sav0__=sav0_, pop__=pop_, trn0__=trn0_, hhtrn0__=hhtrn0_;