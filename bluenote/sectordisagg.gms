$title Routine for disaggregating sectoring definitions

$set sep %system.dirsep%

* ------------------------------------------------------------------------------
* set options
* ------------------------------------------------------------------------------

$set core          ..%sep%data%sep%core%sep%
$set windc_base    %core%windc_base.gdx

*	Set aggregation environment variable

$if not set smap $set smap bluenote

*	Define directory from which we read the household data:

$set hhdatadir ..%sep%household%sep%

*	Define the household dataset to use (cps or soi):

$if not set hhdata $set hhdata cps
$if not set ds $set ds %hhdata%_static
$set householddata %hhdatadir%datasets%sep%%ds%.gdx

$if not dexist gdx $call mkdir gdx
$set gdxdir gdx%sep%


* ------------------------------------------------------------------------------
*	Read information about the detailed IO data from windc_base.GDX
* ------------------------------------------------------------------------------

SETS
	ir_use		"Dynamically created set from parameter use_det_units, identifiers for use table rows",
	jc_use		"Dynamically created set from parameter use_det_units, identifiers for use table columns",
	ir_supply	"Dynamically created set from parameter supply_det_units, identifiers for supply table rows",
	jc_supply	"Dynamically created set from parameter supply_det_units, identifiers for supply table columns",
	yr_det		"Dynamically created set from parameter use_det_units, identifiers for supply table columns",

	s_det		"Detailed BEA Goods and sectors categories (2007 and 2012 only)",

	sector_map	"Mapping between detailed and aggregated BEA sectors",
	va		"Value-added",
	fd		"Final demand";

PARAMETERS 
	use_det_units(yr_det,ir_use,jc_use,*)		"Annual use matrix with units as domain",
	supply_det_units(yr_det,ir_supply,jc_supply,*)	"Annual supply matrix with units as domain";

$GDXIN '%windc_base%'
$LOAD yr_det<use_det_units.dim1
$LOAD ir_use<use_det_units.dim2
$LOAD jc_use<use_det_units.dim3
$LOAD use_det_units
$LOAD ir_supply<supply_det_units.dim2
$LOAD jc_supply<supply_det_units.dim3
$LOAD supply_det_units
$LOAD s_det=i_det
$LOAD sector_map
$LOAD va
$LOAD fd
$GDXIN

* ------------------------------------------------------------------
*	Read in the household dataset.  

*	N.B. Environment variable year is not set and no single year
*	data are loaded.

$include %hhdatadir%windc_hhdata

alias (as,s), (s_det,g_det,i,j);

option as:0:0:1;
*.display as;

*	Construct data for the years in which we have detailed IO
*	accounts (2007 and 2012):

parameters	ys0(yr_det,j,i)		"Sectoral supply"
		fs0(yr_det,i)		"Household supply"
		id0(yr_det,i,j)		"Intermediate demand"
		fd0(yr_det,i,fd)	"Final demand"
		va0(yr_det,va,j)	"Vaue added"
		m0(yr_det,i)		"Imports"
		x0(yr_det,i)		"Exports of goods and services"
		y0(yr_det,i)		"Aggregate supply"
		a0(yr_det,i)		"Armington supply";

id0(yr_det,i(ir_use),j(jc_use)) = use_det_units(yr_det,ir_use,jc_use,'millions of us dollars (USD)');

ys0(yr_det,j(ir_supply),i(jc_supply)) = supply_det_units(yr_det,ir_supply,jc_supply,'millions of us dollars (USD)');

* Treat negative inputs as outputs:

ys0(yr_det,j,i) = ys0(yr_det,j,i) - min(0, id0(yr_det,i,j));
id0(yr_det,i,j) = max(0, id0(yr_det,i,j));

fd0(yr_det,i(ir_use),fd(jc_use)) = use_det_units(yr_det,ir_use,jc_use,'millions of us dollars (USD)');
va0(yr_det,va(ir_use),j(jc_use)) = use_det_units(yr_det,ir_use,jc_use,'millions of us dollars (USD)');

x0(yr_det,i(ir_use)) = use_det_units(yr_det,ir_use,'exports','millions of us dollars (USD)');
m0(yr_det,i(ir_supply)) = supply_det_units(yr_det,ir_supply,'imports','millions of us dollars (USD)');

fs0(yr_det,i) = -min(0, fd0(yr_det,i,'pce'));
fd0(yr_det,i,'pce')$(fd0(yr_det,i,'pce') < 0)  = 0;
y0(yr_det,i) = sum(j, ys0(yr_det,j,i)) + fs0(yr_det,i);
a0(yr_det,i) = sum(fd, fd0(yr_det,i,fd)) + sum(j, id0(yr_det,i,j));

* Negative imports due to negative implicit subsidies underlying the data.

parameters	interm(*,j,*)		"Total intermediate inputs (purchasers' prices)",
		valueadded(*,j,*)	"Value added (purchaser's prices)",
		output(*,j,*)		"Total industry output (basic prices)",
		totint(*,i,*)		"Total intermediate use (purchasers' prices)",
		totaluse(*,i,*)		"Total use of commodities (purchasers' prices)";

interm(yr_det,j(jc_use),'use') = use_det_units(yr_det,'interm',jc_use,'millions of us dollars (USD)');
interm(yr_det,j,'id0') = sum(i, id0(yr_det,i,j));
interm(yr_det,j,'chk') = interm(yr_det,j,'id0') - interm(yr_det,j,'use');
display interm;

* Sets with large positive differences are the result of eliminating negative
* input demands. Indicies with negative numbers for "chk" represent improper
* summing in the use tables supplied by the BEA. I use purchaser price tables.

valueadded(yr_det,j(jc_use),'use') = use_det_units(yr_det,'basicvalueadded',jc_use,'millions of us dollars (USD)');
valueadded(yr_det,j,'va0') = sum(va, va0(yr_det,va,j));
valueadded(yr_det,j,'chk') = valueadded(yr_det,j,'use') - valueadded(yr_det,j,'va0');
display valueadded;

output(yr_det,j(jc_use),'use') = use_det_units(yr_det,'industryoutput',jc_use,'millions of us dollars (USD)');
output(yr_det,j,'id0+va0') = sum(va, va0(yr_det,va,j)) + sum(i, id0(yr_det,i,j));
output(yr_det,j,'ys0') = sum(i, ys0(yr_det,j,i));
output(yr_det,j,'chk') = output(yr_det,j,'id0+va0') - output(yr_det,j,'use');
output(yr_det,j,'chk-ys0') = output(yr_det,j,'id0+va0') - output(yr_det,j,'ys0');
display output;

totint(yr_det,i(ir_use),'use') = use_det_units(yr_det,ir_use,'totint','millions of us dollars (USD)');
totint(yr_det,i,'id0') = sum(j, id0(yr_det,i,j));
totint(yr_det,i,'chk') = totint(yr_det,i,'use') - totint(yr_det,i,'id0');
display totint;

totaluse(yr_det,i(ir_use),'use') = use_det_units(yr_det,ir_use,'totaluse','millions of us dollars (USD)');
totaluse(yr_det,i,'id0+fd0+x0-m0') = sum(j, id0(yr_det,i,j)) + sum(fd, fd0(yr_det,i,fd)) + x0(yr_det,i) - m0(yr_det,i);
totaluse(yr_det,i,'chk') = totaluse(yr_det,i,'use') - totaluse(yr_det,i,'id0+fd0+x0-m0');
display totaluse;

* -------------------------------------------------------------------
* Pick sectors to disaggregate:

set disagg(as,s_det) /
$INCLUDE maps%sep%%smap%.set
/;

set	ss_det(s_det)	Which detailed sectors are being disaggregated;
option ss_det<disagg;

* ----------------------------------------------------------------
*	Create master set for all included indices:

*	As a simple naming convention, I leave the aggregate label unchanged IF the
*	dissagregate sectors chosen only partially covers the aggregate sector.

sets	ms(*) "Master set of goods and sectors in disaggregation",
	gms(*) "Master list of goods related to margin supply/demand";

ms(as) = yes;

*	Remove aggregate sector (if being fully disaggregated) and replace with disaggregated sector scheme

ms(as)$(sum(ss_det$sector_map(ss_det,as), 1) = sum(s_det$sector_map(s_det,as), 1)) = no;
ms(s_det)$sum(as, disagg(as,s_det)) = yes;

*	Define subset for aggregate sectors not impacted by the disaggregation:

sets	us(as)	"Unaffected aggregate sectors",
	afs(*)	"Others";

set	same(*,*,*) "Linking of affected sectors with aggregated secs";

alias   (sss_det,ss_det), (sector_map,sector_mapp);

us(as) = yes$(NOT sum(s_det, disagg(as,s_det)));
afs(ss_det) = yes;
afs(as) = yes$(NOT us(as));
same(ss_det,as,as) = yes$(sector_map(ss_det,as) AND NOT us(as));
same(as,ss_det,as) = yes$(sector_map(ss_det,as) AND NOT us(as));
same(ss_det,sss_det,as) = yes$(sector_map(ss_det,as) AND sector_mapp(sss_det,as));
same(as,as,as) = yes$(NOT us(as));

* -------------------------------------------------------------------
*	Generate shares for disaggregation:

parameter share(*,*,as) "Sharing parameter for disaggregation";

*	Current disaggregation is based on supply shares. Future iteration might follow statedisagg.gms.

share(yr_det,ss_det,as)$sector_map(ss_det,as) = y0(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), y0(yr_det,s_det));

* For all (as) not associated with chosen sub-sectors, set to 1;

share(yr_det,as,as)$(sum(ss_det$sector_map(ss_det,as), 1) = 0) = 1;
share(yr_det,as,as)$(ms(as) and sum(ss_det$sector_map(ss_det,as), 1) > 0) = round(1 - sum(ss_det, share(yr_det,ss_det,as)), 10);


*	Create mapping between years of available data and the years for which
*	we have detailed BEA accounts (only 2007 and 2012).

set mapy(*,yr) "Mapping between summary and detailed table years";

mapy('2007',yr) = yes$(yr.val <= 2009);
mapy('2012',yr) = yes$(yr.val > 2009);

alias	(as,ag),(ms,ns),(us,uus),(afs,afss);

*	Assign shares from either 2007 or 2012:

parameter	share_(yr,*,ag)	Shares applied for years in the household dataset;

share_(yr,ms,ag) = sum(mapy(yr_det,yr), share(yr_det,ms,ag));

* ------------------------------------------------------------------
*	Share out aggregate data:

parameters
	ys_0(yr,r,*,*)	"Sectoral supply",
	id_0(yr,r,*,*)	"Intermediate demand",
	ld_0(yr,r,*)	"Labor demand",
	kd_0(yr,r,*)	"Capital demand",
	ty_0(yr,r,*)	"Production tax rate",
	m_0(yr,r,*)	"Imports",
	x_0(yr,r,*)	"Exports of goods and services",
	rx_0(yr,r,*)	"Re-exports of goods and services",
	md_0(yr,r,m,*)	"Total margin demand",
	nm_0(yr,r,*,m)	"Margin demand from national market",
	dm_0(yr,r,*,m)	"Margin supply from local market",
	s_0(yr,r,*)	"Aggregate supply",
	a_0(yr,r,*)	"Armington supply",
	ta_0(yr,r,*)	"Tax net subsidy rate on intermediate demand",
	tm_0(yr,r,*)	"Import tariff",
	cd_0(yr,r,*)	"Final demand",
	c_0(yr,r)	"Aggregate final demand",
	yh_0(yr,r,*)	"Household production",
	fe_0(yr,r)	"Factor endowments",
	bopdef_0(yr,r)	"Balance of payments",
	hhad_j(yr,r)	"Household adjustment",
	g_0(yr,r,*)	"Government demand",
	i_0(yr,r,*)	"Investment demand",
	xn_0(yr,r,*)	"Regional supply to national market",
	xd_0(yr,r,*)	"Regional supply to local market",
	dd_0(yr,r,*)	"Regional demand from local market",
	nd_0(yr,r,*)	"Regional demand from national market",

	pop_0(yr,r,h)	"Population (households or returns in millions)",
	le_0(yr,r,q,h)	"Household labor endowment",
	ke_0(yr,r,h)	"Household interest payments",
	tk_0(yr,r)	"Capital tax rate",
	tl_0(yr,r,h)	"Household labor tax rate",
	cd_0h_(yr,r,*,h) "Household level expenditures",
	c_0h_(yr,r,h)	"Aggregate household level expenditures",
	sav_0(yr,r,h)	"Household saving",
	trn_0(yr,r,h)	"Household transfer payments",
	hhtrn_0(yr,r,h,trn) "Disaggregate transfer payments";

*	Two dimensional indices (ys0, id0) require special treatment. 
*	Low hanging fruit first.

ld_0(yr,r,ms) = sum((as), share_(yr,ms,as) * ld0_(yr,r,as));
kd_0(yr,r,ms) = sum((as), share_(yr,ms,as) * kd0_(yr,r,as));
m_0(yr,r,ms) = sum((as), share_(yr,ms,as) * m0_(yr,r,as));
x_0(yr,r,ms) = sum((as), share_(yr,ms,as) * x0_(yr,r,as));
rx_0(yr,r,ms) = sum((as), share_(yr,ms,as) * rx0_(yr,r,as));
md_0(yr,r,m,ms) = sum((as), share_(yr,ms,as) * md0_(yr,r,m,as));
nm_0(yr,r,ms,m) = sum((as), share_(yr,ms,as) * nm0_(yr,r,as,m));
dm_0(yr,r,ms,m) = sum((as), share_(yr,ms,as) * dm0_(yr,r,as,m));
s_0(yr,r,ms) = sum((as), share_(yr,ms,as) * s0_(yr,r,as));
a_0(yr,r,ms) = sum((as), share_(yr,ms,as) * a0_(yr,r,as));
cd_0(yr,r,ms) = sum((as), share_(yr,ms,as) * cd0_(yr,r,as));
yh_0(yr,r,ms) = sum((as), share_(yr,ms,as) * yh0_(yr,r,as));
g_0(yr,r,ms) = sum((as), share_(yr,ms,as) * g0_(yr,r,as));
i_0(yr,r,ms) = sum((as), share_(yr,ms,as) * i0_(yr,r,as));
xn_0(yr,r,ms) = sum((as), share_(yr,ms,as) * xn0_(yr,r,as));
xd_0(yr,r,ms) = sum((as), share_(yr,ms,as) * xd0_(yr,r,as));
dd_0(yr,r,ms) = sum((as), share_(yr,ms,as) * dd0_(yr,r,as));
nd_0(yr,r,ms) = sum((as), share_(yr,ms,as) * nd0_(yr,r,as));

*	Household data

pop_0(yr,r,h) = pop_(yr,r,h);
le_0(yr,r,q,h) = le0_(yr,r,q,h);
ke_0(yr,r,h) = ke0_(yr,r,h);
tk_0(yr,r) = tk0_(yr,r);
tl_0(yr,r,h) = tl0_(yr,r,h);
cd_0h_(yr,r,ms,h) = sum((as), share_(yr,ms,as)*cd0_h_(yr,r,as,h));
c_0h_(yr,r,h) = c0_h_(yr,r,h);
sav_0(yr,r,h) = sav0_(yr,r,h);
trn_0(yr,r,h) = trn0_(yr,r,h);
hhtrn_0(yr,r,h,trn) = hhtrn0_(yr,r,h,trn);

* Define margin set:

gms(ms) = yes$(sum((yr,r,m), nm_0(yr,r,ms,m) + dm_0(yr,r,ms,m)) OR sum((yr,r,m), md_0(yr,r,m,ms)));

* Aggregate parameters can be solved for or set explicitly:

c_0(yr,r) = sum(ms, cd_0(yr,r,ms));
bopdef_0(yr,r) = sum(ms, m_0(yr,r,ms) - x_0(yr,r,ms));
hhad_j(yr,r) = hhadj_(yr,r);

* Set tax rates the same as aggregate sector:

ty_0(yr,r,ms) = sum(as$share_(yr,ms,as), ty0_(yr,r,as));
ta_0(yr,r,ms) = sum(as$share_(yr,ms,as), ta0_(yr,r,as));
tm_0(yr,r,ms) = sum(as$share_(yr,ms,as), tm0_(yr,r,as));

* Define the output matrix. First case, un-affected sectors:

ys_0(yr,r,us,uus) = sum((as,ag), share_(yr,us,as) * share_(yr,uus,ag) * ys0_(yr,r,as,ag));

* Single affected:

ys_0(yr,r,us,afs) = sum((as,ag), share_(yr,us,as) * share_(yr,afs,ag) * ys0_(yr,r,as,ag));
ys_0(yr,r,afs,us) = sum((as,ag), share_(yr,afs,as) * share_(yr,us,ag) * ys0_(yr,r,as,ag));

* Both affected but different:

ys_0(yr,r,afs,afss)$(NOT sum(as, same(afs,afss,as))) = sum((as,ag), share_(yr,afs,as) * share_(yr,afss,ag) * ys0_(yr,r,as,ag));

* Both affected and within same aggregate sector:

ys_0(yr,r,afs,afs)$(sum(as, same(afs,afs,as))) = sum((as), share_(yr,afs,as) * ys0_(yr,r,as,as));

* Define the intermediate input matrix (same methodology as above):

id_0(yr,r,us,uus) = sum((as,ag), share_(yr,us,as) * share_(yr,uus,ag) * id0_(yr,r,as,ag));
id_0(yr,r,us,afs) = sum((as,ag), share_(yr,us,as) * share_(yr,afs,ag) * id0_(yr,r,as,ag));
id_0(yr,r,afs,us) = sum((as,ag), share_(yr,afs,as) * share_(yr,us,ag) * id0_(yr,r,as,ag));
id_0(yr,r,afs,afss)$(NOT sum(as, same(afs,afss,as))) = sum((as,ag), share_(yr,afs,as) * share_(yr,afss,ag) * id0_(yr,r,as,ag));
id_0(yr,r,afs,afs)$(sum(as, same(afs,afs,as))) = sum((as), share_(yr,afs,as) * id0_(yr,r,as,as));

* ----------------------------------------------------------------
* 	Output disaggregated data in the temporary gdx directory:
* ----------------------------------------------------------------

EXECUTE_UNLOAD "%gdxdir%%hhdata%.gdx"

* Sets:

yr,r,ms=s,m,gms=gm,h,trn,

* Production data:

ys_0=ys0_,ld_0=ld0_,kd_0=kd0_,id_0=id0_,ty_0=ty0_,

* Consumption data:

yh_0=yh0_,cd_0=cd0_,c_0=c0_,i_0=i0_,g_0=g0_,bopdef_0=bopdef0_,hhad_j=hhadj_,

* Trade data:

s_0=s0_,xd_0=xd0_,xn_0=xn0_,x_0=x0_,rx_0=rx0_,a_0=a0_,nd_0=nd0_,dd_0=dd0_,m_0=m0_,ta_0=ta0_,tm_0=tm0_,

* Margins:

md_0=md0_,nm_0=nm0_,dm_0=dm0_,

* Household data:

pop_0=pop_,le_0=le0_,ke_0=ke0_,tk_0=tk0_,tl_0=tl0_,cd_0h_=cd0_h_,c_0h_=c0_h_,sav_0=sav0_,trn_0=trn0_,hhtrn_0=hhtrn0_;
