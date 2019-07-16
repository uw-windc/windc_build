$TITLE Sectoral/Regional (Dis)aggregation routine :/

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
* work from in the "canned" portion of the program. Make distinction between
* intended regions/sectors in the target vs. origin dataset.

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

$IF NOT SET sdisagg	$SET sdisagg yes
$IF NOT SET aggr	$SET aggr bluenote
$IF NOT SET year $SET year 2016

* Set directory structure:
$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "..%sep%built_datasets"




* --------------------------------------------------------------------------
* Set and data definitions

SET yr "Years of IO data";
SET r "States";
SET s "Goods and sectors from BEA";
SET gm(s) "Margin related sectors";
SET m "Margins (trade or transport)";

$IF %sdisagg% == yes $GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%sectordisagg_%aggr%.gdx
$IF %sdisagg% == no $GDXIN %dsdir%%sep%WiNDCdatabase.gdx

$LOADDC yr
$LOADDC r
$LOADDC s
$LOADDC m
$LOADDC gm

ALIAS(s,g);

PARAMETER ys0_(yr,r,g,s) "Sectoral supply";
PARAMETER id0_(yr,r,s,g) "Intermediate demand";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER m0_(yr,r,s) "Imports";
PARAMETER x0_(yr,r,s) "Exports of goods and services";
PARAMETER rx0_(yr,r,s) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,s) "Total margin demand";
PARAMETER nm0_(yr,r,g,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from local market";
PARAMETER s0_(yr,r,s) "Aggregate supply";
PARAMETER a0_(yr,r,s) "Armington supply";
PARAMETER ta0_(yr,r,s) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,s) "Import tariff";
PARAMETER cd0_(yr,r,s) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,s) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,s) "Government demand";
PARAMETER i0_(yr,r,s) "Investment demand";
PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local market";
PARAMETER nd0_(yr,r,g) "Regional demand from national market";

* Production data:
$LOADDC ys0_
$LOADDC ld0_
$LOADDC kd0_
$LOADDC id0_

* Consumption data:
$LOADDC yh0_
$LOADDC fe0_
$LOADDC cd0_
$LOADDC c0_
$LOADDC i0_
$LOADDC g0_
$LOADDC bopdef0_
$LOADDC hhadj_

* Trade data:
$LOADDC s0_
$LOADDC xd0_
$LOADDC xn0_
$LOADDC x0_
$LOADDC rx0_
$LOADDC a0_
$LOADDC nd0_
$LOADDC dd0_
$LOADDC m0_
$LOADDC ta0_
$LOADDC tm0_

* Margins:
$LOADDC md0_
$LOADDC nm0_
$LOADDC dm0_
$GDXIN


* --------------------------------------------------------------------------
* Include mapping file:

$INCLUDE %reldir%%sep%user_defined_schemes%sep%%aggr%.map

* --------------------------------------------------------------------------
* Part 2: Canned Aggregation Routine

$LABEL canned

SET bug(*) "Mapping errors";

bug(r) = yes$(sum(rmap(rr,r), 1) <> 1);
ABORT$CARD(bug) "Region in r not uniquely mapped.",bug;

bug(s) = yes$(sum(smap(ss,s), 1) <> 1);
ABORT$CARD(bug) "Sector in s not uniquely mapped.",bug;

bug(m) = yes$(sum(mmap(mm,m), 1) <> 1);
ABORT$CARD(bug) "Margin in m not uniquely mapped.",bug;

bug(rr) = yes$(sum(rmap(rr,r), 1) = 0);
ABORT$CARD(bug) "Region in rr has no constituents.",bug;

bug(ss) = yes$(sum(smap(ss,s), 1) = 0);
ABORT$CARD(bug) "Sector in ss has no constituents.",bug;

bug(mm) = yes$(sum(mmap(mm,m), 1) = 0);
ABORT$CARD(bug) "Margin in mm has no constituents.",bug;

ALIAS(ss,gg), (r,q), (rr,qq), (smap,gmap), (rmap,qmap);


PARAMETER ys0__(yr,rr,gg,ss) "Sectoral supply";
PARAMETER id0__(yr,rr,ss,gg) "Intermediate demand";
PARAMETER ld0__(yr,rr,ss) "Labor demand";
PARAMETER kd0__(yr,rr,ss) "Capital demand";
PARAMETER m0__(yr,rr,ss) "Imports";
PARAMETER x0__(yr,rr,ss) "Exports of goods and services";
PARAMETER rx0__(yr,rr,ss) "Re-exports of goods and services";
PARAMETER md0__(yr,rr,mm,gg) "Total margin demand";
PARAMETER nm0__(yr,rr,gg,mm) "Margin demand from national market";
PARAMETER dm0__(yr,rr,gg,mm) "Margin supply from local market";
PARAMETER s0__(yr,rr,gg) "Aggregate supply";
PARAMETER a0__(yr,rr,gg) "Armington supply";
PARAMETER ta0__(yr,rr,gg) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0__(yr,rr,gg) "Import tariff";
PARAMETER cd0__(yr,rr,gg) "Final demand";
PARAMETER c0__(yr,rr) "Aggregate final demand";
PARAMETER yh0__(yr,rr,ss) "Household production";
PARAMETER fe0__(yr,rr) "Factor endowments";
PARAMETER bopdef0__(yr,rr) "Balance of payments";
PARAMETER hhadj__(yr,rr) "Household adjustment";
PARAMETER g0__(yr,rr,gg) "Government demand";
PARAMETER i0__(yr,rr,gg) "Investment demand";
PARAMETER xn0__(yr,rr,gg) "Regional supply to national market";
PARAMETER xd0__(yr,rr,gg) "Regional supply to local market";
PARAMETER dd0__(yr,rr,gg) "Regional demand from local market";
PARAMETER nd0__(yr,rr,gg) "Regional demand from national market";

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

* Assign averaged tax rates:

ta0__(yr,rr,ss)$a0__(yr,rr,ss)	= sum((rmap(rr,r),smap(ss,s)), ta0_(yr,r,s)*a0_(yr,r,s))/a0__(yr,rr,ss);
tm0__(yr,rr,ss)$m0__(yr,rr,ss)	= sum((rmap(rr,r),smap(ss,s)), tm0_(yr,r,s)*m0_(yr,r,s))/m0__(yr,rr,ss);

* Define goods related to margin supply/demand:

SET gmm(ss) "Goods with margins";

gmm(ss) = yes$(sum((yr,rr,mm), nm0__(yr,rr,ss,mm) + dm0__(yr,rr,ss,mm)) or sum((yr,rr,mm), md0__(yr,rr,mm,ss)));

* --------------------------------------------------------------------------
* Output target dataset:

EXECUTE_UNLOAD '%dsdir%%sep%WiNDC_disagg_%aggr%.gdx',

* Sets:

yr,rr=r,ss=s,mm=m,gmm=gm,

* Production data:

ys0__=ys0_,ld0__=ld0_,kd0__=kd0_,id0__=id0_,

* Consumption data:

yh0__=yh0_,fe0__=fe0_,cd0__=cd0_,c0__=c0_,i0__=i0_,
g0__=g0_,bopdef0__=bopdef0_,hhadj__=hhadj_,

* Trade data:

s0__=s0_,xd0__=xd0_,xn0__=xn0_,x0__=x0_,rx0__=rx0_,a0__=a0_,
nd0__=nd0_,dd0__=dd0_,m0__=m0_,ta0__=ta0_,tm0__=tm0_,

* Margins:

md0__=md0_,nm0__=nm0_,dm0__=dm0_;
