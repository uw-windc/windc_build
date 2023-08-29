$title Routine for disaggregating sectoring definitions

* The sector disaggregation routine relies on detailed BEA IO tables and
* state-level Quarterly Census of Employment and Wages (QCEW) data resolved at
* detailed BEA sectoring scheme. QCEW data is from 2016. Note that if users want
* to use alternative years, see R code in data directories and be aware that
* NAICS codes change in 2017 which do not correspond well with 2012. At the time
* of writing, 2017 detailed IO accounts are not publicly available. More work
* is needed to use more recent QCEW data. Similar story for older QCEW data <
* 2012.

* This routine uses the windc sectoral aggregation (71 sectors) from the
* household build as an input. Use of other aggregations from the household
* build will result in an error.


* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* Set aggregation environment variable
$if not set smap $set smap test

* Set year of data
$set year 2017

* Set household datset option
$set ds cps_static_all_%year%

* Set location of windc_base to read in detailed bea tables
$set windc_base ../data/core/windc_base.gdx

* Set location of reconciled WiNDCDatabase.gdx
$if not set core $set core ../core/

* Define directory containing household data
$set hhdatadir ../household/

* Set temporary directory for intermediary data files
$if not dexist gdx $call mkdir gdx
$set gdxdir gdx/



* ------------------------------------------------------------------------------
* Read in the household dataset
* ------------------------------------------------------------------------------

* Read in the household dataset

$include %hhdatadir%windc_hhdata

* Aliased set named abbreviation of "aggregate sector"

alias (as,ag,s);

* Characterize aggregate margin supply

parameter
    ms0(r,s,m)	Margin supply;

ms0(r,s,m) = nm0(r,s,m) + dm0(r,s,m);



* ------------------------------------------------------------------------------
* Read in detailed BEA data
* ------------------------------------------------------------------------------

sets
    ir_use	Dynamically created set from parameter use_det_units,
    jc_use	Dynamically created set from parameter use_det_units,
    ir_supply	Dynamically created set from parameter supply_det_units,
    jc_supply	Dynamically created set from parameter supply_det_units,
    yr_det	Years of detailed tables,
    s_det	Sectors in detailed tables,
    sector_map	Mapping between detailed and aggregated BEA sectors,
    va		Value-added,
    fd		Final demand;

parameters
    use_det_units(yr_det,ir_use,jc_use,*)		Annual use matrix with units as domain,
    supply_det_units(yr_det,ir_supply,jc_supply,*)	Annual supply matrix with units as domain;

$gdxin '%windc_base%'

* global sets
$load yr_det<use_det_units.dim1 s_det=i_det va fd

* use table sets
$load ir_use<use_det_units.dim2 jc_use<use_det_units.dim3

* supply table sets
$load ir_supply<supply_det_units.dim2 jc_supply<supply_det_units.dim3

* use and supply tables
$load use_det_units supply_det_units

* mapping between detailed and summary sectors
$load sector_map
$gdxin

alias(s_det,g_det,i,j);

* Scale input-output data to be in billions of dollars.

parameter
    use(yr_det,ir_use,jc_use) 		Detailed use matrix (billions dollars),
    supply(yr_det,ir_supply,jc_supply) 	Detailed supply matrix (billions dollars);

use(yr_det,ir_use,jc_use) =
    use_det_units(yr_det,ir_use,jc_use,"millions of us dollars (USD)") * 1e-3;

supply(yr_det,ir_supply,jc_supply) =
    supply_det_units(yr_det,ir_supply,jc_supply,"millions of us dollars (USD)") * 1e-3;


* ------------------------------------------------------------------------------
* Read in QCEW data (2016)
* ------------------------------------------------------------------------------

$set file "../data/bluenote/qcew/state_qcew_windc_2016.csv"
$call 'csv2gdx "%file%" id=qcew useheader=yes index=(1,3,4,5) values=6 output="%gdxdir%qcewcsv.gdx" trace=3'

parameter
    qcew_(r,*,s,s_det)	QCEW data (with year),
    qcew(r,s,s_det)	QCEW data (without year);

$gdxin %gdxdir%qcewcsv.gdx
$load qcew_=qcew
$gdxin

qcew(r,s,s_det) = qcew_(r,'2016',s,s_det);


* ------------------------------------------------------------------------------
* Construct CGE parameters using detailed tables
* ------------------------------------------------------------------------------

* Sets for aggregate final demand shares
set
    fdcat 	Aggregated final demand categories /
	  	C 	"Household consumption",
	  	I 	"Investment",
	  	G 	"Government expenditures" /,

    fdmap(fd,fdcat) Mapping of final demand /
	  	pce.C 			"Personal consumption expenditures",
	  	structures.I 		"Nonresidential private fixed investment in structures",
	  	equipment.I 		"Nonresidential private fixed investment in equipment",
	  	intelprop.I 		"Nonresidential private fixed investment in intellectual",
	  	residential.I 		"Residential private fixed investment",
	  	changinv.I 		"Change in private inventories",
	  	defense.G 		"National defense: Consumption expenditures",
	  	def_structures.G 	"Federal national defense: Gross investment in structures",
	  	def_equipment.G 	"Federal national defense: Gross investment in equipment",
	  	def_intelprop.G 	"Federal national defense: Gross investment in intellectual",
	  	nondefense.G 		"Nondefense: Consumption expenditures",
	  	fed_structures.G 	"Federal nondefense: Gross investment in structures",
	  	fed_equipment.G 	"Federal nondefense: Gross investment in equipment",
	  	fed_intelprop.G 	"Federal nondefense: Gross investment in intellectual prop",
	  	state_consume.G 	"State and local government consumption expenditures",
	  	state_invest.G 		"State and local: Gross investment in structures",
	  	state_equipment.G 	"State and local: Gross investment in equipment",
	  	state_intelprop.G 	"State and local: Gross investment in intellectual" /;


* Construct data for the years in which we have detailed IO accounts (2007 and
* 2012):

parameters
    ys0_det(yr_det,j,i)		Sectoral supply,
    fs0_det(yr_det,i)		Household supply,
    id0_det(yr_det,i,j)		Intermediate demand,
    fd0_det_(yr_det,i,fd)	Final demand,
    fd0_det(yr_det,i,fdcat)	Aggregate final demand,
    va0_det(yr_det,va,j)	Vaue added,
    m0_det(yr_det,i)		Imports,
    cif0_det(yr_det,i)		CIF-FOB Adjustments on Imports,    
    x0_det(yr_det,i)		Exports of goods and services,
    y0_det(yr_det,i)		Aggregate supply,
    a0_det(yr_det,i)		Armington supply,
    duty0_det(yr_det,i)		Tarrif revenue,
    tax0_det(yr_det,i)		Taxes on products,
    mrg0_det(yr_det,i) 		Trade margins,
    trn0_det(yr_det,i) 		Transportation costs,
    ms0_det(yr_det,i,m)		Margin supply,
    md0_det(yr_det,m,i)		Margin demand;


id0_det(yr_det,i(ir_use),j(jc_use)) = use(yr_det,ir_use,jc_use);
ys0_det(yr_det,j(jc_supply),i(ir_supply)) = supply(yr_det,ir_supply,jc_supply);

* Treat negative inputs as outputs:

ys0_det(yr_det,j,i) = ys0_det(yr_det,j,i) - min(0, id0_det(yr_det,i,j));
id0_det(yr_det,i,j) = max(0, id0_det(yr_det,i,j));

va0_det(yr_det,va(ir_use),j(jc_use)) = use(yr_det,ir_use,jc_use);
x0_det(yr_det,i(ir_use)) = use(yr_det,ir_use,'exports');
m0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,'imports');
cif0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,"ciffob");

* Adjust transport margins for transport sectors according to CIF/FOB
* adjustments. Insurance imports are specified as net of adjustments.

mrg0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,"margins");
trn0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,"trncost");
trn0_det(yr_det,i)$(cif0_det(yr_det,i) and not sameas(i,'car_ins')) = trn0_det(yr_det,i) + cif0_det(yr_det,i);
m0_det(yr_det,i)$(sameas(i,'car_ins')) = m0_det(yr_det,i) + cif0_det(yr_det,i);

ms0_det(yr_det,i,"trd") = max(-mrg0_det(yr_det,i),0);
ms0_det(yr_det,i,'trn') = max(-trn0_det(yr_det,i),0);
md0_det(yr_det,"trd",i) = max(mrg0_det(yr_det,i),0);
md0_det(yr_det,'trn',i) = max(trn0_det(yr_det,i),0);

* Treat negative imports as exports:

x0_det(yr_det,i) = x0_det(yr_det,i) - min(0,m0_det(yr_det,i));
m0_det(yr_det,i) = max(0, m0_det(yr_det,i));

* Aggregate final demand to aggregate categories. Treat negative consumption as
* household supply. Project negative investment and government demand values to
* 0 (most large numbers are use or oth categories, which are dropped from the
* windc dataset anyway)

fd0_det_(yr_det,i(ir_use),fd(jc_use)) = use(yr_det,ir_use,jc_use);
fd0_det(yr_det,i,fdcat) = sum(fdmap(fd,fdcat), fd0_det_(yr_det,i,fd));
fs0_det(yr_det,i) = -min(0, fd0_det(yr_det,i,'C'));
fd0_det(yr_det,i,'C')$(fd0_det(yr_det,i,'C') < 0)  = 0;
fd0_det(yr_det,i,fdcat)$(fd0_det(yr_det,i,fdcat)<0) = 0;
y0_det(yr_det,i) = sum(j, ys0_det(yr_det,j,i)) + fs0_det(yr_det,i);
a0_det(yr_det,i) = sum(fdcat, fd0_det(yr_det,i,fdcat)) + sum(j, id0_det(yr_det,i,j));

* Pull in tax revenues on imports and intermediate demand

duty0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,"duties");
tax0_det(yr_det,i(ir_supply)) = supply(yr_det,ir_supply,"tax") + supply(yr_det,ir_supply,"subsidies");

parameters
    interm(*,j,*)	Total intermediate inputs (purchasers' prices),
    valueadded(*,j,*)	Value added (purchaser's prices),
    output(*,j,*)	Total industry output (basic prices),
    totint(*,i,*)	Total intermediate use (purchasers' prices),
    totaluse(*,i,*)	Total use of commodities (purchasers' prices);

interm(yr_det,j(jc_use),'use') = use(yr_det,'interm',jc_use);
interm(yr_det,j,'id0') = sum(i, id0_det(yr_det,i,j));
interm(yr_det,j,'chk') = round(interm(yr_det,j,'id0') - interm(yr_det,j,'use'),2);
display interm;

valueadded(yr_det,j(jc_use),'use') = use(yr_det,'basicvalueadded',jc_use);
valueadded(yr_det,j,'va0') = sum(va, va0_det(yr_det,va,j));
valueadded(yr_det,j,'chk') = round(valueadded(yr_det,j,'use') - valueadded(yr_det,j,'va0'),2);
display valueadded;

output(yr_det,j(jc_use),'use') = use(yr_det,'industryoutput',jc_use);
output(yr_det,j,'id0+va0') = sum(va, va0_det(yr_det,va,j)) + sum(i, id0_det(yr_det,i,j));
output(yr_det,j,'ys0') = sum(i, ys0_det(yr_det,j,i));
output(yr_det,j,'chk') = output(yr_det,j,'id0+va0') - output(yr_det,j,'use');
output(yr_det,j,'chk-ys0') = round(output(yr_det,j,'id0+va0') - output(yr_det,j,'ys0'),2);
display output;

totint(yr_det,i(ir_use),'use') = use(yr_det,ir_use,'totint');
totint(yr_det,i,'id0') = sum(j, id0_det(yr_det,i,j));
totint(yr_det,i,'chk') = round(totint(yr_det,i,'use') - totint(yr_det,i,'id0'),2);
display totint;

* Ore mining off due to negative imports in total use check. some other sectors
* due to negative investments (inventory changes)

totaluse(yr_det,i(ir_use),'use') = use(yr_det,ir_use,'totaluse');
totaluse(yr_det,i,'id0+fd0+x0') =
    sum(j, id0_det(yr_det,i,j)) + sum(fdcat, fd0_det(yr_det,i,fdcat)) + x0_det(yr_det,i);
totaluse(yr_det,i,'chk') = round(totaluse(yr_det,i,'use') - totaluse(yr_det,i,'id0+fd0+x0'),2);
display totaluse;


* ------------------------------------------------------------------------------
* Pick sectors to disaggregate:
* ------------------------------------------------------------------------------

set
    disagg(as,s_det) 	Mapping for chosen sector disaggregation /
$include "maps/%smap%.set"
/,
    ss_det(s_det)	Subset of disaggregate sectors being disaggregated;
option ss_det<disagg;
alias(ss_det,gg_det);


* ------------------------------------------------------------------------------
* Create master set for all included indices:
* ------------------------------------------------------------------------------

* As a simple naming convention, I leave the aggregate label unchanged IF the
* dissagregate sectors chosen only partially covers the aggregate sector.

sets
    ms(*) 	Master set of goods and sectors in disaggregation,
    gms(*) 	Master list of goods related to margin supply and demand;

ms(as) = yes;

* Remove aggregate sector (if being fully disaggregated) and replace with
* disaggregated sector scheme

ms(as)$(sum(ss_det$sector_map(ss_det,as), 1) = sum(s_det$sector_map(s_det,as), 1)) = no;
ms(s_det)$sum(as, disagg(as,s_det)) = yes;

* Define subset for aggregate sectors not impacted by the disaggregation:

sets
    us(as)	Unaffected aggregate sectors,
    afs(*)	Affected sectors (aggregate and disaggregate),
    same(*,*,*) Linking of affected sectors with aggregated sectors;

alias (sss_det,ss_det),(sector_map,sector_mapp),(ms,ns),(us,uus),(afs,afss,aafs);

us(as) = yes$(not sum(s_det, disagg(as,s_det)));
afs(ss_det) = yes;
afs(as) = yes$(not us(as));
same(ss_det,as,as) = yes$(sector_map(ss_det,as) and not us(as));
same(as,ss_det,as) = yes$(sector_map(ss_det,as) and not us(as));
same(ss_det,sss_det,as) = yes$(sector_map(ss_det,as) and sector_mapp(sss_det,as));
same(as,as,as) = yes$(not us(as));
display us, afs, same;


* ------------------------------------------------------------------------------
* Generate shares for disaggregation:
* ------------------------------------------------------------------------------

* NB: shares from detailed BEA tables used to target national totals. Regional
* heterogeneity driven by QCEW labor compensation data.

parameter
    bea_share_single(yr_det,*,as,*)  	National detailed BEA shares (single dim),
    bea_share_double(yr_det,*,as,*,*,*)	National detailed BEA shares (double dim);

bea_share_single(yr_det,ss_det,as,"y0")$sector_map(ss_det,as) =
    y0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), y0_det(yr_det,s_det));

bea_share_single(yr_det,ss_det,as,"a0")$sector_map(ss_det,as) =
    a0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), a0_det(yr_det,s_det));

bea_share_single(yr_det,ss_det,as,"x0")$sector_map(ss_det,as) =
    x0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), x0_det(yr_det,s_det));

bea_share_single(yr_det,ss_det,as,"m0")$sector_map(ss_det,as) =
    m0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), m0_det(yr_det,s_det));

bea_share_single(yr_det,ss_det,as,"duty0")$(sector_map(ss_det,as) and sum(s_det$sector_map(s_det,as), duty0_det(yr_det,s_det))) =
    duty0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), duty0_det(yr_det,s_det));

bea_share_single(yr_det,ss_det,as,"tax0")$sector_map(ss_det,as) =
    tax0_det(yr_det,ss_det) / sum(s_det$sector_map(s_det,as), tax0_det(yr_det,s_det));

bea_share_double(yr_det,ss_det,as,fdcat,fdcat,'fd0')$(sector_map(ss_det,as) and sum(s_det$sector_map(s_det,as), fd0_det(yr_det,s_det,fdcat))) =
    fd0_det(yr_det,ss_det,fdcat) / sum(s_det$sector_map(s_det,as), fd0_det(yr_det,s_det,fdcat));

bea_share_double(yr_det,ss_det,as,va,va,'va0')$sector_map(ss_det,as) =
    va0_det(yr_det,va,ss_det) / sum(s_det$sector_map(s_det,as), va0_det(yr_det,va,s_det));

bea_share_double(yr_det,ss_det,as,m,m,'md0')$(sector_map(ss_det,as) and sum(s_det$sector_map(s_det,as), md0_det(yr_det,m,s_det))) =
    md0_det(yr_det,m,ss_det) / sum(s_det$sector_map(s_det,as), md0_det(yr_det,m,s_det));

bea_share_double(yr_det,ss_det,as,m,m,'ms0')$(sector_map(ss_det,as) and sum(s_det$sector_map(s_det,as), ms0_det(yr_det,s_det,m))) =
    ms0_det(yr_det,ss_det,m) / sum(s_det$sector_map(s_det,as), ms0_det(yr_det,s_det,m));

* id0 and ys0 are more complicated. need to capture within dissaggregate sector
* shares, row shares for aggregate sectors and column shares for aggregate
* sectors

alias(sector_map,secmap);
bea_share_double(yr_det,gg_det,ag,ss_det,as,'id0_within')$(sector_map(ss_det,as) and sector_mapp(gg_det,ag) and sum((s_det,g_det)$(sector_map(s_det,as) and sector_mapp(g_det,ag)), id0_det(yr_det,g_det,s_det))) =
    id0_det(yr_det,gg_det,ss_det) / sum((s_det,g_det)$(sector_map(s_det,as) and sector_mapp(g_det,ag)), id0_det(yr_det,g_det,s_det));

bea_share_double(yr_det,ag,ag,ss_det,as,'id0_column')$(sector_map(ss_det,as) and sum(secmap(g_det,ag)$(not disagg(ag,g_det)), sum((s_det)$(sector_map(s_det,as)), id0_det(yr_det,g_det,s_det)))) =
    sum(secmap(g_det,ag)$(not disagg(ag,g_det)), id0_det(yr_det,g_det,ss_det)) / sum(secmap(g_det,ag)$(not disagg(ag,g_det)), sum((s_det)$(sector_map(s_det,as)), id0_det(yr_det,g_det,s_det)));

bea_share_double(yr_det,ag,ag,ss_det,as,'id0_column')$(afs(ag) and disagg(as,ss_det) and sum(sector_map(g_det,ag),id0_det(yr_det,g_det,ss_det))) =
    (sum(sector_map(g_det,ag),id0_det(yr_det,g_det,ss_det)) - sum(sector_map(gg_det,ag),id0_det(yr_det,gg_det,ss_det))) / sum(sector_map(g_det,ag),id0_det(yr_det,g_det,ss_det));

bea_share_double(yr_det,gg_det,ag,as,as,'id0_row')$(sector_map(gg_det,ag) and sum(secmap(s_det,as)$(not disagg(as,s_det)), sum((g_det)$(sector_map(g_det,ag)), id0_det(yr_det,g_det,s_det)))) =
    sum(secmap(s_det,as)$(not disagg(as,s_det)), id0_det(yr_det,gg_det,s_det)) / sum(secmap(s_det,as)$(not disagg(as,s_det)), sum((g_det)$(sector_map(g_det,ag)), id0_det(yr_det,g_det,s_det)));

bea_share_double(yr_det,gg_det,ag,as,as,'id0_row')$(afs(as) and disagg(ag,gg_det) and sum(sector_map(s_det,as),id0_det(yr_det,gg_det,s_det))) =
    (sum(sector_map(s_det,as),id0_det(yr_det,gg_det,s_det)) - sum(sector_map(ss_det,as),id0_det(yr_det,gg_det,ss_det))) / sum(sector_map(s_det,as),id0_det(yr_det,gg_det,s_det));

bea_share_double(yr_det,ss_det,as,gg_det,ag,'ys0_within')$(sector_map(ss_det,as) and sector_mapp(gg_det,ag) and sum((s_det,g_det)$(sector_map(s_det,as) and sector_mapp(g_det,ag)), ys0_det(yr_det,s_det,g_det))) =
    ys0_det(yr_det,ss_det,gg_det) / sum((s_det,g_det)$(sector_map(s_det,as) and sector_mapp(g_det,ag)), ys0_det(yr_det,s_det,g_det));

bea_share_double(yr_det,as,as,gg_det,ag,'ys0_column')$(sector_map(gg_det,ag) and sum(secmap(s_det,as), sum((g_det)$(sector_map(g_det,ag)), ys0_det(yr_det,s_det,g_det)))) =
    sum(secmap(s_det,as)$(not disagg(as,s_det)), ys0_det(yr_det,s_det,gg_det)) / sum(secmap(s_det,as)$(not disagg(as,s_det)), sum((g_det)$(sector_map(g_det,ag)), ys0_det(yr_det,s_det,g_det)));

bea_share_double(yr_det,ag,ag,gg_det,ag,'ys0_column')$(disagg(ag,gg_det) and sum(sector_map(s_det,ag),ys0_det(yr_det,s_det,gg_det))) =
    (sum(sector_map(s_det,ag),ys0_det(yr_det,s_det,gg_det)) - sum(sector_map(ss_det,ag),ys0_det(yr_det,ss_det,gg_det))) / sum(sector_map(s_det,ag),ys0_det(yr_det,s_det,gg_det));

bea_share_double(yr_det,ss_det,as,ag,ag,'ys0_row')$(sector_map(ss_det,as) and sum(secmap(g_det,ag), sum((s_det)$(sector_map(s_det,as)), ys0_det(yr_det,s_det,g_det)))) =
    sum(secmap(g_det,ag)$(not disagg(ag,g_det)), ys0_det(yr_det,ss_det,g_det)) / sum(secmap(g_det,ag)$(not disagg(ag,g_det)), sum((s_det)$(sector_map(s_det,as)), ys0_det(yr_det,s_det,g_det)));

bea_share_double(yr_det,ss_det,as,as,as,'ys0_row')$(disagg(as,ss_det) and sum(sector_map(g_det,as),ys0_det(yr_det,ss_det,g_det))) =
    (sum(sector_map(g_det,as),ys0_det(yr_det,ss_det,g_det)) - sum(sector_map(gg_det,as),ys0_det(yr_det,ss_det,gg_det))) / sum(sector_map(g_det,as),ys0_det(yr_det,ss_det,g_det));

* Choose year of detailed data needed:

set
    mapy(yr_det) 	Mapping between summary and detailed table years;

mapy('2007') = yes$(%year% <= 2009);
mapy('2012') = yes$(%year% > 2009);


* ------------------------------------------------------------------------------
* Verify disaggregation robustness using windc 2012 data and make sure we are
* getting the right totals at the national level
* ------------------------------------------------------------------------------

* Read in core WiNDC data

parameter
    ys0_(*,r,s,g)	Sectoral supply,
    id0_(*,r,g,s)	Intermediate demand,
    ld0_(*,r,s)		Labor demand,
    kd0_(*,r,s)		Capital demand,
    ty0_(*,r,s)		Output tax on production,
    m0_(*,r,s)		Imports,
    x0_(*,r,s)		Exports of goods and services,
    md0_(*,r,m,s)	Total margin demand,
    nm0_(*,r,g,m)	Margin demand from national market,
    dm0_(*,r,g,m)	Margin supply from local market,
    a0_(*,r,s)		Armington supply,
    cd0_(*,r,s)		Final demand,
    g0_(*,r,s)		Government demand,
    i0_(*,r,s)		Investment demand,
    ys0_nat(s,g)	Sectoral supply,
    id0_nat(g,s)	Intermediate demand,
    va0_nat(va,s)	Value added,
    m0_nat(s)		Imports,
    x0_nat(s)		Exports of goods and services,
    md0_nat(m,s)	Total margin demand,
    ms0_nat(g,m)	Margin supply,
    a0_nat(s)		Armington supply,
    fd0_nat(s,fdcat)	Final demand;
    
$set ds '%core%WiNDCdatabase.gdx'
$gdxin '%ds%'
$loaddc ys0_ id0_ ld0_ kd0_ ty0_ m0_ x0_ 
$loaddc md0_ nm0_ dm0_ a0_ cd0_ g0_ i0_
$gdxin

ys0_nat(s,g) = sum(r, ys0_('2012',r,s,g));
id0_nat(g,s) = sum(r, id0_('2012',r,g,s));
va0_nat('compen',s) = sum(r, ld0_('2012',r,s));
va0_nat('surplus',s) = sum(r, kd0_('2012',r,s));
va0_nat('othtax',s) = sum(r, ty0(r,s)*sum(g, ys0_('2012',r,s,g)));
m0_nat(g) = sum(r, m0_('2012',r,g));
md0_nat(m,s) = sum(r, md0_('2012',r,m,s));
ms0_nat(s,m) = sum(r, nm0_('2012',r,s,m) + dm0_('2012',r,s,m));
x0_nat(g) = sum(r, x0_('2012',r,g));
a0_nat(g) = sum(r, a0_('2012',r,g));
fd0_nat(g,'C') = sum(r, cd0_('2012',r,g));
fd0_nat(g,'I') = sum(r, i0_('2012',r,g));
fd0_nat(g,'G') = sum(r, g0_('2012',r,g));

* Verify that totals line up well between summary and detailed table:

parameter
    sum_det	Comparison of summary and detailed tables,
    sum_det_two Comparison of summary and det tables for two dim parameters;

sum_det(g,'m0','windc') = m0_nat(g);
sum_det(g,'m0','det') = sum(sector_map(g_det,g), m0_det('2012',g_det));
sum_det(g,'m0','diff') = round(sum_det(g,'m0','windc') - sum_det(g,'m0','det'),4);

sum_det(g,'x0','windc') = x0_nat(g);
sum_det(g,'x0','det') = sum(sector_map(g_det,g), x0_det('2012',g_det));
sum_det(g,'x0','diff') = round(sum_det(g,'x0','windc') - sum_det(g,'x0','det'),4);

sum_det(g,'a0','windc') = a0_nat(g);
sum_det(g,'a0','det') = sum(sector_map(g_det,g), a0_det('2012',g_det));
sum_det(g,'a0','diff') = round(sum_det(g,'a0','windc') - sum_det(g,'a0','det'),4);

sum_det_two(s,g,'ys0','windc') = ys0_nat(s,g);
sum_det_two(s,g,'ys0','det') = sum((sector_map(s_det,s),sector_mapp(g_det,g)), ys0_det('2012',s_det,g_det));
sum_det_two(s,g,'ys0','diff') = sum_det_two(s,g,'ys0','windc') - sum_det_two(s,g,'ys0','det');

sum_det_two(g,s,'id0','windc') = id0_nat(g,s);
sum_det_two(g,s,'id0','det') = sum((sector_map(s_det,s),sector_mapp(g_det,g)), id0_det('2012',g_det,s_det));
sum_det_two(g,s,'id0','diff') = sum_det_two(g,s,'id0','windc') - sum_det_two(g,s,'id0','det');

sum_det_two(va,s,'va0','windc') = va0_nat(va,s);
sum_det_two(va,s,'va0','det') = sum(sector_map(s_det,s), va0_det('2012',va,s_det));
sum_det_two(va,s,'va0','diff') = sum_det_two(va,s,'va0','windc') - sum_det_two(va,s,'va0','det');

sum_det_two(g,fdcat,'fd0','windc') = fd0_nat(g,fdcat);
sum_det_two(g,fdcat,'fd0','det') = sum(sector_mapp(g_det,g), fd0_det('2012',g_det,fdcat));
sum_det_two(g,fdcat,'fd0','diff') = sum_det_two(g,fdcat,'fd0','windc') - sum_det_two(g,fdcat,'fd0','det');

sum_det_two(m,s,'md0','windc') = md0_nat(m,s);
sum_det_two(m,s,'md0','det') = sum(sector_map(s_det,s), md0_det('2012',m,s_det));
sum_det_two(m,s,'md0','diff') = sum_det_two(m,s,'md0','windc') - sum_det_two(m,s,'md0','det');

sum_det_two(s,m,'ms0','windc') = ms0_nat(s,m);
sum_det_two(s,m,'ms0','det') = sum(sector_map(s_det,s), ms0_det('2012',s_det,m));
sum_det_two(s,m,'ms0','diff') = sum_det_two(s,m,'ms0','windc') - sum_det_two(s,m,'ms0','det');
display sum_det_two;

* Disaggregate summary sector data into detailed sector data at national level
* to verify robustness of sharing methodology:

parameter
    ys0_dis(*,*,*)		Sectoral supply,
    id0_dis(*,*,*)		Intermediate demand,
    va0_dis(va,s_det,*)		Value added,
    m0_dis(g_det,*)		Imports,
    md0_dis(m,g_det,*)		Margin demands,
    ms0_dis(g_det,m,*)		Margin supply,
    x0_dis(g_det,*)		Exports of goods and services,
    a0_dis(g_det,*)		Armington supply,
    fd0_dis(g_det,fdcat,*)	Final demand;

m0_dis(gg_det,'summary') = sum(g, bea_share_single('2012',gg_det,g,'m0') * m0_nat(g));
m0_dis(gg_det,'detailed') = m0_det('2012',gg_det);
m0_dis(gg_det,'diff') = round(m0_dis(gg_det,'detailed') - m0_dis(gg_det,'summary'),1);

x0_dis(gg_det,'summary') = sum(g, bea_share_single('2012',gg_det,g,'x0') * x0_nat(g));
x0_dis(gg_det,'detailed') = x0_det('2012',gg_det);
x0_dis(gg_det,'diff') = round(x0_dis(gg_det,'detailed') - x0_dis(gg_det,'summary'),1);

a0_dis(gg_det,'summary') = sum(g, bea_share_single('2012',gg_det,g,'a0') * a0_nat(g));
a0_dis(gg_det,'detailed') = a0_det('2012',gg_det);
a0_dis(gg_det,'diff') = round(a0_dis(gg_det,'detailed') - a0_dis(gg_det,'summary'),1);

fd0_dis(gg_det,fdcat,'summary') = sum(g, bea_share_double('2012',gg_det,g,fdcat,fdcat,'fd0') * fd0_nat(g,fdcat));
fd0_dis(gg_det,fdcat,'detailed') = fd0_det('2012',gg_det,fdcat);
fd0_dis(gg_det,fdcat,'diff') = round(fd0_dis(gg_det,fdcat,'detailed') - fd0_dis(gg_det,fdcat,'summary'),1);

va0_dis(va,ss_det,'summary') = sum(s, bea_share_double('2012',ss_det,s,va,va,'va0') * va0_nat(va,s));
va0_dis(va,ss_det,'detailed') = va0_det('2012',va,ss_det);
va0_dis(va,ss_det,'diff') = round(va0_dis(va,ss_det,'detailed') - va0_dis(va,ss_det,'summary'),1);

md0_dis(m,ss_det,'summary') = sum(s, bea_share_double('2012',ss_det,s,m,m,'md0') * md0_nat(m,s));
md0_dis(m,ss_det,'detailed') = md0_det('2012',m,ss_det);
md0_dis(m,ss_det,'diff') = round(md0_dis(m,ss_det,'detailed') - md0_dis(m,ss_det,'summary'),1);

ms0_dis(ss_det,m,'summary') = sum(s, bea_share_double('2012',ss_det,s,m,m,'ms0') * ms0_nat(s,m));
ms0_dis(ss_det,m,'detailed') = ms0_det('2012',ss_det,m);
ms0_dis(ss_det,m,'diff') = round(ms0_dis(ss_det,m,'detailed') - ms0_dis(ss_det,m,'summary'),1);

* For ys0 and id0, define three cases seperately (affected, unaffected row,
* unaffected column):

ys0_dis(ss_det,gg_det,'summary') = sum((s,g), bea_share_double('2012',ss_det,s,gg_det,g,'ys0_within') * ys0_nat(s,g));
ys0_dis(s,s,'summary') = bea_share_double('2012',s,s,s,s,'ys0_within') * ys0_nat(s,s);
ys0_dis(s,gg_det,'summary') = sum((g), bea_share_double('2012',s,s,gg_det,g,'ys0_column') * ys0_nat(s,g));
ys0_dis(ss_det,g,'summary') = sum((s), bea_share_double('2012',ss_det,s,g,g,'ys0_row') * ys0_nat(s,g));

ys0_dis(ss_det,gg_det,'detailed') = ys0_det('2012',ss_det,gg_det);
ys0_dis(s,gg_det,'detailed') = sum(sector_map(s_det,s)$(not ss_det(s_det)), ys0_det('2012',s_det,gg_det));
ys0_dis(ss_det,g,'detailed') = sum(sector_map(g_det,g)$(not gg_det(g_det)), ys0_det('2012',ss_det,g_det));
ys0_dis(s,s,'detailed')$ys0_dis(s,s,'summary') = sum(sector_map(s_det,s)$(not ss_det(s_det)), ys0_det('2012',s_det,s_det));

ys0_dis(ms,ns,'diff') = round(ys0_dis(ms,ns,'detailed') - ys0_dis(ms,ns,'summary'),1);

id0_dis(gg_det,ss_det,'summary') = sum((s,g), bea_share_double('2012',gg_det,g,ss_det,s,'id0_within') * id0_nat(g,s));
id0_dis(s,s,'summary') = bea_share_double('2012',s,s,s,s,'id0_within') * id0_nat(s,s);
id0_dis(g,ss_det,'summary') = sum((s), bea_share_double('2012',g,g,ss_det,s,'id0_column') * id0_nat(g,s));
id0_dis(gg_det,s,'summary') = sum((g), bea_share_double('2012',gg_det,g,s,s,'id0_row') * id0_nat(g,s));

id0_dis(gg_det,ss_det,'detailed') = id0_det('2012',gg_det,ss_det);
id0_dis(gg_det,s,'detailed') = sum(sector_map(s_det,s)$(not ss_det(s_det)), id0_det('2012',gg_det,s_det));
id0_dis(g,ss_det,'detailed') = sum(sector_map(g_det,g)$(not gg_det(g_det)), id0_det('2012',g_det,ss_det));
id0_dis(s,s,'detailed')$id0_dis(s,s,'summary') = sum(sector_map(s_det,s)$(not ss_det(s_det)), id0_det('2012',s_det,s_det));

id0_dis(ms,ns,'diff') = round(id0_dis(ms,ns,'detailed') - id0_dis(ms,ns,'summary'),1);

* Display parameters to verify sharing procedure is robust:

display m0_dis, x0_dis, a0_dis, fd0_dis, va0_dis, md0_dis, ms0_dis, id0_dis, ys0_dis;


* ------------------------------------------------------------------------------
* Construct national control totals using national detailed shares
* ------------------------------------------------------------------------------

parameters
    ys0_control(*,*)	Sectoral supply,
    id0_control(*,*)	Intermediate demand,
    ld0_control(*)	Labor demand,
    kd0_control(*)	Capital demand,
    ty0_control(*)	Production tax revenue,
    m0_control(*)	Imports,
    x0_control(*)	Exports of goods and services,
    md0_control(*,*)	Margin demand,
    ms0_control(*,*)	Margin supply,
    a0_control(*)	Armington supply,
    ta0_control(*)	Tax net subsidy revenue on intermediate demand,
    tm0_control(*)	Import tariff revenue,
    cd0_control(*)	Final demand,
    cd0_h_control(*,*)  Household final demand,
    g0_control(*)	Government demand,
    i0_control(*)	Investment demand;

* Use abort statment to verify that all data has been mapped:

set
    chkmap(*,s)	Mapping from affected sectors;
chkmap(ss_det,s)$disagg(s,ss_det) = yes;
chkmap(s,s) = yes;
alias(chkmap,cm);

ys0_control(ss_det,gg_det) = sum((mapy(yr_det),s,g), bea_share_double(yr_det,ss_det,s,gg_det,g,'ys0_within') * sum(r, ys0(r,s,g)));
ys0_control(s,gg_det) = sum((mapy(yr_det),g), bea_share_double(yr_det,s,s,gg_det,g,'ys0_column') * sum(r, ys0(r,s,g)));
ys0_control(ss_det,g) = sum((mapy(yr_det),s), bea_share_double(yr_det,ss_det,s,g,g,'ys0_row') * sum(r, ys0(r,s,g)));
alias(disagg,disaggg);
ys0_control(s,g) = sum(r, ys0(r,s,g)) - sum(disagg(g,gg_det), ys0_control(s,gg_det)) -
    sum(disaggg(s,ss_det), ys0_control(ss_det,g)) - sum((disagg(s,ss_det),disaggg(g,gg_det)), ys0_control(ss_det,gg_det));
abort$(smax((s,g),round(sum((chkmap(ms,s),cm(ns,g)), ys0_control(ms,ns)) - sum(r, ys0(r,s,g)),5))>0) 'ys0 controls totals are inconsistent';
display ys0_control;

id0_control(gg_det,ss_det) = sum((mapy(yr_det),g,s), bea_share_double(yr_det,gg_det,g,ss_det,s,'id0_within') * sum(r, id0(r,g,s)));
id0_control(g,ss_det) = sum((mapy(yr_det),s), bea_share_double(yr_det,g,g,ss_det,s,'id0_column') * sum(r, id0(r,g,s)));
id0_control(gg_det,s) = sum((mapy(yr_det),g), bea_share_double(yr_det,gg_det,g,s,s,'id0_row') * sum(r, id0(r,g,s)));
id0_control(g,s) = sum(r, id0(r,g,s)) - sum(disagg(g,gg_det), id0_control(gg_det,s)) -
    sum(disagg(s,ss_det), id0_control(g,ss_det)) - sum((disagg(g,gg_det),disaggg(s,ss_det)), id0_control(gg_det,ss_det));
abort$(smax((g,s),round(sum((chkmap(ms,s),cm(ns,g)), id0_control(ns,ms)) - sum(r, id0(r,g,s)),5))>0) 'id0 controls totals are inconsistent';

ld0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'compen','compen','va0') * sum(r, ld0(r,as)));
ld0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, ld0(r,s)) - sum(ss_det$disagg(s,ss_det), ld0_control(ss_det));
ld0_control(s)$(not ld0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, ld0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), ld0_control(ms)) - sum(r, ld0(r,s)),5))>0) 'ld0 controls totals are inconsistent';

kd0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'surplus','surplus','va0') * sum(r, kd0(r,as)));
kd0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, kd0(r,s)) - sum(ss_det$disagg(s,ss_det), kd0_control(ss_det));
kd0_control(s)$(not kd0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, kd0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), kd0_control(ms)) - sum(r, kd0(r,s)),5))>0) 'kd0 controls totals are inconsistent';

ty0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'othtax','othtax','va0') * sum(r, ty0(r,as)*sum(g, ys0(r,as,g))));
ty0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, ty0(r,s)*sum(g, ys0(r,s,g))) - sum(ss_det$disagg(s,ss_det), ty0_control(ss_det));
ty0_control(s)$(not ty0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, ty0(r,s)*sum(g, ys0(r,s,g)));
abort$(smax((s),round(sum(chkmap(ms,s), ty0_control(ms)) - sum(r, ty0(r,s)*sum(g, ys0(r,s,g))),5))>0) 'ty0 controls totals are inconsistent';

m0_control(ss_det) = sum((mapy(yr_det),as), bea_share_single(yr_det,ss_det,as,'m0') * sum(r, m0(r,as)));
m0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, m0(r,s)) - sum(ss_det$disagg(s,ss_det), m0_control(ss_det));
m0_control(s)$(not m0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, m0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), m0_control(ms)) - sum(r, m0(r,s)),5))>0) 'm0 controls totals are inconsistent';

x0_control(ss_det) = sum((mapy(yr_det),as), bea_share_single(yr_det,ss_det,as,'x0') * sum(r, x0(r,as)));
x0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, x0(r,s)) - sum(ss_det$disagg(s,ss_det), x0_control(ss_det));
x0_control(s)$(not x0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, x0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), x0_control(ms)) - sum(r, x0(r,s)),5))>0) 'x0 controls totals are inconsistent';

md0_control(m,ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,m,m,'md0') * sum(r, md0(r,m,as)));
md0_control(m,s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, md0(r,m,s)) - sum(ss_det$disagg(s,ss_det), md0_control(m,ss_det));
md0_control(m,s)$(not md0_control(m,s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, md0(r,m,s));
abort$(smax((m,s),round(sum(chkmap(ms,s), md0_control(m,ms)) - sum(r, md0(r,m,s)),5))>0) 'md0 controls totals are inconsistent';

ms0_control(ss_det,m) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,m,m,'ms0') * sum(r, ms0(r,as,m)));
ms0_control(s,m)$(sum(ss_det, disagg(s,ss_det))) = sum(r, ms0(r,s,m)) - sum(ss_det$disagg(s,ss_det), ms0_control(ss_det,m));
ms0_control(s,m)$(not ms0_control(m,s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, ms0(r,s,m));
abort$(smax((s,m),round(sum(chkmap(ms,s), ms0_control(m,ms)) - sum(r, ms0(r,s,m)),5))>0) 'ms0 controls totals are inconsistent';

a0_control(ss_det) = sum((mapy(yr_det),as), bea_share_single(yr_det,ss_det,as,'a0') * sum(r, a0(r,as)));
a0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, a0(r,s)) - sum(ss_det$disagg(s,ss_det), a0_control(ss_det));
a0_control(s)$(not a0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, a0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), a0_control(ms)) - sum(r, a0(r,s)),5))>0) 'a0 controls totals are inconsistent';

tm0_control(ss_det) = sum((mapy(yr_det),as), bea_share_single(yr_det,ss_det,as,'duty0') * sum(r, tm0(r,as)*m0(r,as)));
tm0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, tm0(r,s)*m0(r,s)) - sum(ss_det$disagg(s,ss_det), tm0_control(ss_det));
tm0_control(s)$(not tm0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, tm0(r,s)*m0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), tm0_control(ms)) - sum(r, tm0(r,s)*m0(r,s)),5))>0) 'tm0 controls totals are inconsistent';

ta0_control(ss_det) = sum((mapy(yr_det),as), bea_share_single(yr_det,ss_det,as,'tax0') * sum(r, ta0(r,as)*a0(r,as)));
ta0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, ta0(r,s)*a0(r,s)) - sum(ss_det$disagg(s,ss_det), ta0_control(ss_det));
ta0_control(s)$(not ta0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, ta0(r,s)*a0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), ta0_control(ms)) - sum(r, ta0(r,s)*a0(r,s)),5))>0) 'ta0 controls totals are inconsistent';

cd0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'C','C','fd0') * sum(r, cd0(r,as)));
cd0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, cd0(r,s)) - sum(ss_det$disagg(s,ss_det), cd0_control(ss_det));
cd0_control(s)$(not cd0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, cd0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), cd0_control(ms)) - sum(r, cd0(r,s)),5))>0) 'cd0 controls totals are inconsistent';

* Assume household demands are split proportionally

cd0_h_control(ss_det,h) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'C','C','fd0') * sum(r, cd0_h(r,as,h)));
cd0_h_control(s,h)$(sum(ss_det, disagg(s,ss_det))) = sum(r, cd0_h(r,s,h)) - sum(ss_det$disagg(s,ss_det), cd0_h_control(ss_det,h));
cd0_h_control(s,h)$(not cd0_h_control(s,h) and not sum(ss_det,disagg(s,ss_det))) = sum(r, cd0_h(r,s,h));
abort$(smax((s,h),round(sum(chkmap(ms,s), cd0_h_control(ms,h)) - sum(r, cd0_h(r,s,h)),5))>0) 'cd0_h controls totals are inconsistent';

g0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'G','G','fd0') * sum(r, g0(r,as)));
g0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, g0(r,s)) - sum(ss_det$disagg(s,ss_det), g0_control(ss_det));
g0_control(s)$(not g0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, g0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), g0_control(ms)) - sum(r, g0(r,s)),5))>0) 'g0 controls totals are inconsistent';

i0_control(ss_det) = sum((mapy(yr_det),as), bea_share_double(yr_det,ss_det,as,'I','I','fd0') * sum(r, i0(r,as)));
i0_control(s)$(sum(ss_det, disagg(s,ss_det))) = sum(r, i0(r,s)) - sum(ss_det$disagg(s,ss_det), i0_control(ss_det));
i0_control(s)$(not i0_control(s) and not sum(ss_det,disagg(s,ss_det))) = sum(r, i0(r,s));
abort$(smax((s),round(sum(chkmap(ms,s), i0_control(ms)) - sum(r, i0(r,s)),5))>0) 'i0 controls totals are inconsistent';

* Convert tax revenues into tax rates:

ty0_control(ms)$ty0_control(ms) = ty0_control(ms) / sum(ns, ys0_control(ms,ns));
ta0_control(ms)$ta0_control(ms) = ta0_control(ms) / a0_control(ms);
tm0_control(ms)$tm0_control(ms) = tm0_control(ms) / m0_control(ms);

parameter
    comp_taxrates;

comp_taxrates(r,s,'ty') = round(ty0_control(s) - ty0(r,s),6);
comp_taxrates(r,s,'ta') = round(ta0_control(s) - ta0(r,s),6);
comp_taxrates(r,s,'tm') = round(tm0_control(s) - tm0(r,s),6);
display comp_taxrates;



* ------------------------------------------------------------------------------
* Adjust control totals to satisfy accounting identities
* ------------------------------------------------------------------------------

* First check how off initial accounting identities are:

parameter
    zp_y_control,
    zp_a_control,
    mkt_py_control,
    mkt_pa_control,
    mkt_pm_control;

zp_y_control(ms) =
    (1 - ty0_control(ms))*sum(ns, ys0_control(ms,ns)) -
    (sum(ns, id0_control(ns,ms)) + ld0_control(ms) + (1+tk0('wi'))*kd0_control(ms));

zp_a_control(ms) =
    (1 - ta0_control(ms)) * a0_control(ms) + x0_control(ms) -
    ((sum(ns, ys0_control(ns,ms)) - sum(m, ms0_control(ms,m))) + (1+tm0_control(ms))*m0_control(ms) + sum(m, md0_control(m,ms)));

mkt_pa_control(ms) =
    a0_control(ms) -
    (sum(ns, id0_control(ms,ns)) + sum(h, cd0_h_control(ms,h)) + i0_control(ms) + g0_control(ms));

mkt_pm_control(m) =
    sum(ms, ms0_control(ms,m)) - sum(ms, md0_control(m,ms));

display zp_y_control, zp_a_control, mkt_pa_control, mkt_pm_control;

* Adjust control totals for affected sectors to satisfy accounting identities
* and sum to aggregate windc sectors

variables
    OBJ;

nonnegative
variables
    ys_con, id_con, ld_con, kd_con,
    a_con, x_con, ms_con, m_con, md_con,
    cdh_con, i_con, g_con;

equations
    objcon, zpy_con, zpa_con, mkta_con, mktm_con,
    ys_consum, id_consum, ld_consum, kd_consum, 
    a_consum, x_consum, ms_consum, m_consum, md_consum,
    cdh_consum, i_consum, g_consum;

objcon..
    OBJ =e= sum((ms,ns)$ys0_control(ms,ns), abs(ys0_control(ms,ns))*sqr(ys_con(ms,ns)/ys0_control(ms,ns) - 1)) +
	    sum((ms,ns)$id0_control(ms,ns), abs(id0_control(ms,ns))*sqr(id_con(ms,ns)/id0_control(ms,ns) - 1)) +
	    sum((ms)$ld0_control(ms), abs(ld0_control(ms))*sqr(ld_con(ms)/ld0_control(ms) - 1)) +
	    sum((ms)$kd0_control(ms), abs(kd0_control(ms))*sqr(kd_con(ms)/kd0_control(ms) - 1)) +
	    sum((ms)$a0_control(ms), abs(a0_control(ms))*sqr(a_con(ms)/a0_control(ms) - 1)) +
	    sum((ms)$x0_control(ms), abs(x0_control(ms))*sqr(x_con(ms)/x0_control(ms) - 1)) +
	    sum((ms)$m0_control(ms), abs(m0_control(ms))*sqr(m_con(ms)/m0_control(ms) - 1)) +
	    sum((ms,m)$ms0_control(ms,m), abs(ms0_control(ms,m))*sqr(ms_con(ms,m)/ms0_control(ms,m) - 1)) +
	    sum((m,ms)$md0_control(m,ms), abs(md0_control(m,ms))*sqr(md_con(m,ms)/md0_control(m,ms) - 1)) +
	    sum((ms,h)$cd0_h_control(ms,h), abs(cd0_h_control(ms,h))*sqr(cdh_con(ms,h)/cd0_h_control(ms,h) - 1)) + 
	    sum((ms)$i0_control(ms), abs(i0_control(ms))*sqr(i_con(ms)/i0_control(ms) - 1)) +
	    sum((ms)$g0_control(ms), abs(g0_control(ms))*sqr(g_con(ms)/g0_control(ms) - 1));

zpy_con(ms)..
    (1-ty0_control(ms))*sum(ns, ys_con(ms,ns)) =e= 
    sum(ns, id_con(ns,ms)) + ld_con(ms) + (1+tk0('wi'))*kd_con(ms);

zpa_con(ms)..
    (1-ta0_control(ms))*a_con(ms) + x_con(ms) =e=
    (sum(ns, ys_con(ns,ms)) - sum(m, ms_con(ms,m))) + (1+tm0_control(ms))*m_con(ms) + sum(m, md_con(m,ms));

mkta_con(ms)..
    a_con(ms) =e=
    sum(ns, id_con(ms,ns)) + sum(h, cdh_con(ms,h)) + i_con(ms) + g_con(ms);

mktm_con(m)..
    sum(ms, ms_con(ms,m)) =e= sum(ms, md_con(m,ms));

ys_consum(s,g)..
    sum((chkmap(ms,s),cm(ns,g)), ys_con(ms,ns)) =e= sum(r, ys0(r,s,g));

id_consum(g,s)..
    sum((chkmap(ns,g),cm(ms,s)), id_con(ns,ms)) =e= sum(r, id0(r,g,s));

ld_consum(s)..
    sum(chkmap(ms,s), ld_con(ms)) =e= sum(r, ld0(r,s));

kd_consum(s)..
    sum(chkmap(ms,s), kd_con(ms)) =e= sum(r, kd0(r,s));
    
x_consum(s)..
    sum(chkmap(ms,s), x_con(ms)) =e= sum(r, x0(r,s));

a_consum(s)..
    sum(chkmap(ms,s), a_con(ms)) =e= sum(r, a0(r,s));

m_consum(s)..
    sum(chkmap(ms,s), m_con(ms)) =e= sum(r, m0(r,s));

md_consum(m,s)..
    sum(chkmap(ms,s), md_con(m,ms)) =e= sum(r, md0(r,m,s));

ms_consum(s,m)..
    sum(chkmap(ms,s), ms_con(ms,m)) =e= sum(r, ms0(r,s,m));

i_consum(s)..
    sum(chkmap(ms,s), i_con(ms)) =e= sum(r, i0(r,s));

g_consum(s)..
    sum(chkmap(ms,s), g_con(ms)) =e= sum(r, g0(r,s));

cdh_consum(s,h)..
    sum(chkmap(ms,s), cdh_con(ms,h)) =e= sum(r, cd0_h(r,s,h));

model adjust_controls / objcon, zpy_con, zpa_con, mkta_con, mktm_con,
    ys_consum, id_consum, ld_consum, kd_consum, 
    a_consum, x_consum, ms_consum, m_consum, md_consum,
    cdh_consum, i_consum, g_consum /;

ys_con.fx(ms,ns)$(not ys0_control(ms,ns)) = 0;
id_con.fx(ms,ns)$(not id0_control(ms,ns)) = 0;
ld_con.fx(ms)$(not ld0_control(ms)) = 0;
kd_con.fx(ms)$(not kd0_control(ms)) = 0;
a_con.fx(ms)$(not a0_control(ms)) = 0;
x_con.fx(ms)$(not x0_control(ms)) = 0;
ms_con.fx(ms,m)$(not ms0_control(ms,m)) = 0;
md_con.fx(m,ms)$(not md0_control(m,ms)) = 0;
m_con.fx(ms)$(not m0_control(ms)) = 0;
cdh_con.fx(ms,h)$(not cd0_h_control(ms,h)) = 0;
i_con.fx(ms)$(not i0_control(ms)) = 0;
g_con.fx(ms)$(not g0_control(ms)) = 0;

option qcp=cplex;
solve adjust_controls minimizing OBJ using QCP;

* Report differences in the data:

parameter
    rep_adjust;

rep_adjust(ms,h,'cdh','dat') = cd0_h_control(ms,h);
rep_adjust(ms,h,'cdh','cal') = cdh_con.l(ms,h);
rep_adjust(ms,h,'cdh','dif') = rep_adjust(ms,h,'cdh','cal') - rep_adjust(ms,h,'cdh','dat');

rep_adjust(ms,ns,'ys0','dat') = ys0_control(ms,ns);
rep_adjust(ms,ns,'ys0','cal') = ys_con.l(ms,ns);
rep_adjust(ms,ns,'ys0','dif') = rep_adjust(ms,ns,'ys0','cal') - rep_adjust(ms,ns,'ys0','dat');

rep_adjust(ms,ns,'id0','dat') = id0_control(ns,ms);
rep_adjust(ms,ns,'id0','cal') = id_con.l(ns,ms);
rep_adjust(ms,ns,'id0','dif') = rep_adjust(ms,ns,'id0','cal') - rep_adjust(ms,ns,'id0','dat');

rep_adjust(ms,' ','a0','dat') = a0_control(ms);
rep_adjust(ms,' ','a0','cal') = a_con.l(ms);
rep_adjust(ms,' ','a0','dif') = rep_adjust(ms,' ','a0','cal') - rep_adjust(ms,' ','a0','dat');

rep_adjust(ms,' ','m0','dat') = m0_control(ms);
rep_adjust(ms,' ','m0','cal') = m_con.l(ms);
rep_adjust(ms,' ','m0','dif') = rep_adjust(ms,' ','m0','cal') - rep_adjust(ms,' ','m0','dat');
display rep_adjust;

* Reset control totals:

ys0_control(ms,ns) = ys_con.l(ms,ns);
id0_control(ms,ns) = id_con.l(ms,ns);
ld0_control(ms) = ld_con.l(ms);
kd0_control(ms) = kd_con.l(ms);
a0_control(ms) = a_con.l(ms);
x0_control(ms) = x_con.l(ms);
ms0_control(ms,m) = ms_con.l(ms,m);
md0_control(m,ms) = md_con.l(m,ms);
m0_control(ms) = m_con.l(ms);
cd0_h_control(ms,h) = cdh_con.l(ms,h);
i0_control(ms) = i_con.l(ms);
g0_control(ms) = g_con.l(ms);


* ------------------------------------------------------------------------------
* Contruct regional shares using qcew
* ------------------------------------------------------------------------------

* Relying on QCEW to produce regional shares produces infeasibilities in the
* below balancing routine because there are some inconcistencies with that
* dataset relative to windc (and BEA). For instance, there are instances where
* region_shr * control total > windc value for the aggregate sector. Therefore,
* we use QCEW in two ways -- (1) calculate regional heterogeneity of a sectors
* production, and (2) within each region that has production, quantify the
* allocation of labor to disaggregate sectors.

parameter
    region_shr(r,*)	Regional shares based on QCEW data,
    sector_shr(r,*)	Secotral shares based on QCEW data,
    scale_shr(r,*)	Scale shares to prevent inconsistencies with WiNDC data;

region_shr(r,ss_det) = sum(s, qcew(r,s,ss_det)) / sum((r.local,s), qcew(r,s,ss_det));
region_shr(r,s)$(sum(ss_det, disagg(s,ss_det)) and sum(g, ys0(r,s,g))) =
    sum(s_det$(not ss_det(s_det)), qcew(r,s,s_det)) /
    sum((r.local,s_det)$(not ss_det(s_det)), qcew(r,s,s_det));

sector_shr(r,ss_det)$sum(disagg(s,ss_det),sum(g_det, qcew(r,s,g_det))) =
    sum(s, qcew(r,s,ss_det)) / sum(disagg(s,ss_det),sum(g_det, qcew(r,s,g_det)));

sector_shr(r,s)$(sum(ss_det, disagg(s,ss_det)) and sum(g, ys0(r,s,g))) =
    1 - sum(disagg(s,ss_det), sector_shr(r,ss_det));


$ontext
* Scale region_shr such that region_shr * control <= windc value for aggregate sector

scale_shr(r,ss_det) = sum(s$disagg(s,ss_det), ys0(r,s,s)) - region_shr(r,ss_det) * ys0_control(ss_det,ss_det);
scale_shr(r,ss_det)$(scale_shr(r,ss_det)>0) = 0;
display scale_shr;

nonnegative
variables
    share(r,*);

equations
    objshr, shr_def, ys0_shr, ld0_shr, kd0_shr, id0_shr;

objshr..
    OBJ =e= sum((r,ss_det)$region_shr(r,ss_det),
	region_shr(r,ss_det)*sqr(share(r,ss_det)/region_shr(r,ss_det) - 1));

shr_def(ss_det)..
    sum(r, share(r,ss_det)) =e= 1;

ys0_shr(r,ss_det)..
    share(r,ss_det)*ys0_control(ss_det,ss_det) =l= sum(s$disagg(s,ss_det), ys0(r,s,s));

ld0_shr(r,ss_det)..
    share(r,ss_det)*ld0_control(ss_det) =l= sum(s$disagg(s,ss_det), ld0(r,s));

kd0_shr(r,ss_det)..
    share(r,ss_det)*kd0_control(ss_det) =l= sum(s$disagg(s,ss_det), kd0(r,s));

id0_shr(r,ss_det)..
    share(r,ss_det)*id0_control(ss_det,ss_det) =l= sum(s$disagg(s,ss_det), id0(r,s,s));

model solve_shr /objshr, shr_def, ys0_shr, ld0_shr, kd0_shr, id0_shr/;

share.l(r,ss_det) = region_shr(r,ss_det);
* share.lo(r,ss_det) = 0.1 * region_shr(r,ss_det);
share.fx(r,ss_det)$(not region_shr(r,ss_det)) = 0;

option qcp=cplex;
solve solve_shr minimizing OBJ using QCP;
$exit
region_shr(r,ss_det) = share.l(r,ss_det);
region_shr(r,s)$(not sum(ss_det,disagg(s,ss_det))) = sum(g, ys0(r,s,g)) / sum((r.local,g), ys0(r,s,g));
$offtext


* ------------------------------------------------------------------------------
* Contruct balancing routine, only endogenizing sectors to disaggregate
* ------------------------------------------------------------------------------

variable
    OBJ;

nonnegative
variables
    ys_v, id_v, ld_v, kd_v,
    x_v, xn_v, xd_v, s_v,
    a_v, rx_v, nd_v, dd_v, m_v, md_v, 
    nm_v, dm_v, cdh_v, i_v, g_v;

equations
    objdef,
    
    zp_y, zp_x, zp_a, zp_ms, mkt_pa, mkt_py, mkt_pn, mkt_pd,

    ys_sum, id_sum, ld_sum, kd_sum, ty_sum, x_sum, xn_sum, xd_sum, rx_sum,
    a_sum, ta_sum, tm_sum, m_sum, i_sum, g_sum, cdh_sum,
    nd_sum, dd_sum, md_sum, nm_sum, dm_sum;

objdef..
    OBJ =e= sum((r,ms,ns)$(region_shr(r,ms)*ys0_control(ms,ns)),
		abs(region_shr(r,ms)*ys0_control(ms,ns)) *
		sqr(ys_v(r,ms,ns)/(region_shr(r,ms)*ys0_control(ms,ns)) - 1)) +
    	    sum((r,ns,ms)$(region_shr(r,ms)*id0_control(ns,ms)),
		abs(region_shr(r,ms)*id0_control(ns,ms)) *
	    	sqr(id_v(r,ns,ms)/(region_shr(r,ms)*id0_control(ns,ms)) - 1)) +
    	    sum((r,ms)$(region_shr(r,ms)*ld0_control(ms)),
		abs(region_shr(r,ms)*ld0_control(ms)) *
	    	sqr(ld_v(r,ms)/(region_shr(r,ms)*ld0_control(ms)) - 1)) +
    	    sum((r,ms)$(region_shr(r,ms)*kd0_control(ms)),
		abs(region_shr(r,ms)*kd0_control(ms)) *
	    	sqr(kd_v(r,ms)/(region_shr(r,ms)*kd0_control(ms)) - 1)) +
* zero penalty    
    	    1e6 * (
	    sum((r,ms,ns)$(not region_shr(r,ms)*ys0_control(ms,ns)),
		ys_v(r,ms,ns)) +
    	    sum((r,ns,ms)$(not region_shr(r,ms)*id0_control(ns,ms)),
	    	id_v(r,ns,ms)));

zp_y(r,ms)$afs(ms)..
    (1-ty0_control(ms))*sum(ns, ys_v(r,ms,ns)) =e=
    sum(ns, id_v(r,ns,ms)) + ld_v(r,ms) + (1+tk0(r))*kd_v(r,ms);

zp_x(r,ms)$afs(ms)..
    x_v(r,ms) - rx_v(r,ms) + xn_v(r,ms) + xd_v(r,ms) =e= s_v(r,ms);

zp_a(r,ms)$afs(ms)..
    (1-ta0_control(ms))*a_v(r,ms) + rx_v(r,ms) =e=
    nd_v(r,ms) + dd_v(r,ms) + (1+tm0_control(ms))*m_v(r,ms) + sum(m, md_v(r,m,ms));

zp_ms(r,m)..
    sum(ms, md_v(r,m,ms)) =e= sum(ms, nm_v(r,ms,m) + dm_v(r,ms,m));

mkt_pa(r,ms)$afs(ms)..
    a_v(r,ms) =e= sum(ns, id_v(r,ms,ns)) + sum(h, cdh_v(r,ms,h)) + i_v(r,ms) + g_v(r,ms);

mkt_py(r,ms)$afs(ms)..
    sum(ns, ys_v(r,ns,ms)) =e= s_v(r,ms);

mkt_pn(ms)$afs(ms)..
    sum(r, xn_v(r,ms)) =e= sum(r, nd_v(r,ms) + sum(m, nm_v(r,ms,m)));

mkt_pd(r,ms)$afs(ms)..
    xd_v(r,ms) =e= dd_v(r,ms) + sum(m, dm_v(r,ms,m));

ys_sum(r,s,g)$(afs(s) or aafs(g))..
    sum((chkmap(ms,s),cm(ns,g)), ys_v(r,ms,ns)) =e= ys0(r,s,g);

id_sum(r,g,s)$(afs(s) or aafs(g))..
    sum((chkmap(ns,g),cm(ms,s)), id_v(r,ns,ms)) =e= id0(r,g,s);

ld_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), ld_v(r,ms)) =e= ld0(r,s);

kd_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), kd_v(r,ms)) =e= kd0(r,s);
    
x_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), x_v(r,ms)) =e= x0(r,s);

rx_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), rx_v(r,ms)) =e= rx0(r,s);

xn_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), xn_v(r,ms)) =e= xn0(r,s);

xd_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), xd_v(r,ms)) =e= xd0(r,s);

a_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), a_v(r,ms)) =e= a0(r,s);

m_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), m_v(r,ms)) =e= m0(r,s);

nd_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), nd_v(r,ms)) =e= nd0(r,s);

dd_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), dd_v(r,ms)) =e= dd0(r,s);

md_sum(r,m,s)$afs(s)..
    sum(chkmap(ms,s), md_v(r,m,ms)) =e= md0(r,m,s);

nm_sum(r,s,m)$afs(s)..
    sum(chkmap(ms,s), nm_v(r,ms,m)) =e= nm0(r,s,m);

dm_sum(r,s,m)$afs(s)..
    sum(chkmap(ms,s), dm_v(r,ms,m)) =e= dm0(r,s,m);

i_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), i_v(r,ms)) =e= i0(r,s);

g_sum(r,s)$afs(s)..
    sum(chkmap(ms,s), g_v(r,ms)) =e= g0(r,s);

cdh_sum(r,s,h)$afs(s)..
    sum(chkmap(ms,s), cdh_v(r,ms,h)) =e= cd0_h(r,s,h);

model sectordisagg /objdef, zp_y, zp_x, zp_a, zp_ms, mkt_pa, mkt_py, mkt_pn, mkt_pd,
      ys_sum, id_sum, ld_sum, kd_sum, x_sum, xn_sum, xd_sum, rx_sum, a_sum,
      m_sum, i_sum, g_sum, cdh_sum, nd_sum, dd_sum, md_sum, nm_sum, dm_sum/;

* Level values based on region_share and control totals:

ys_v.l(r,ms,ns)$(afs(ms) or aafs(ns)) = region_shr(r,ms) * ys0_control(ms,ns);
id_v.l(r,ns,ms)$(afs(ms) or aafs(ns)) = region_shr(r,ms) * id0_control(ns,ms);
ld_v.l(r,ms)$afs(ms) = region_shr(r,ms) * ld0_control(ms);
kd_v.l(r,ms)$afs(ms) = region_shr(r,ms) * kd0_control(ms);

x_v.l(r,ms)$afs(ms) = region_shr(r,ms) * x0_control(ms);
xn_v.l(r,s)$afs(s) = xn0(r,s);
xd_v.l(r,s)$afs(s) = xd0(r,s);
s_v.l(r,s)$afs(s) = s0(r,s);

a_v.l(r,ms)$afs(ms) = region_shr(r,ms) * a0_control(ms);
rx_v.l(r,s)$afs(s) = rx0(r,s);
nd_v.l(r,s)$afs(s) = nd0(r,s);
dd_v.l(r,s)$afs(s) = dd0(r,s);
m_v.l(r,ms)$afs(ms) = region_shr(r,ms) * m0_control(ms);
md_v.l(r,m,s)$afs(s) = md0(r,m,s);

nm_v.l(r,s,m)$afs(s) = nm0(r,s,m);
dm_v.l(r,s,m)$afs(s) = dm0(r,s,m);

cdh_v.l(r,ms,h)$afs(ms) = region_shr(r,ms) * cd0_h_control(ms,h);
i_v.l(r,ms)$afs(ms) = region_shr(r,ms) * i0_control(ms);
g_v.l(r,ms)$afs(ms) = region_shr(r,ms) * g0_control(ms);

* Fix production variables in regions with no region_shr to zero:

ys_v.fx(r,ss_det,ns)$(not region_shr(r,ss_det)) = 0;
id_v.fx(r,ns,ss_det)$(not region_shr(r,ss_det)) = 0;
ld_v.fx(r,ss_det)$(not region_shr(r,ss_det)) = 0;
kd_v.fx(r,ss_det)$(not region_shr(r,ss_det)) = 0;

* Fix disaggrgate sectors to zero when they do not exist in control totals:

* ys_v.fx(r,ms,ns)$(not ys0_control(ms,ns)) = 0;
* id_v.fx(r,ns,ms)$(not id0_control(ns,ms)) = 0;
ld_v.fx(r,ms)$(not ld0_control(ms)) = 0;
kd_v.fx(r,ms)$(not kd0_control(ms)) = 0;
x_v.fx(r,ms)$(not x0_control(ms)) = 0;
a_v.fx(r,ms)$(not a0_control(ms)) = 0;
m_v.fx(r,ms)$(not m0_control(ms)) = 0;
cdh_v.fx(r,ms,h)$(not cd0_h_control(ms,h)) = 0;
i_v.fx(r,ms)$(not i0_control(ms)) = 0;
g_v.fx(r,ms)$(not g0_control(ms)) = 0;

* Fix unaffected sectors:

ys_v.fx(r,s,g)$(not afs(s) and not aafs(g)) = ys0(r,s,g);
id_v.fx(r,g,s)$(not afs(s) and not aafs(g)) = id0(r,g,s);
ld_v.fx(r,s)$(not afs(s)) = ld0(r,s);
kd_v.fx(r,s)$(not afs(s)) = kd0(r,s);

x_v.fx(r,g)$(not afs(g)) = x0(r,g);
xn_v.fx(r,g)$(not afs(g)) = xn0(r,g);
xd_v.fx(r,g)$(not afs(g)) = xd0(r,g);
s_v.fx(r,g)$(not afs(g)) = s0(r,g);

a_v.fx(r,g)$(not afs(g)) = a0(r,g);
rx_v.fx(r,g)$(not afs(g)) = rx0(r,g);
nd_v.fx(r,g)$(not afs(g)) = nd0(r,g);
dd_v.fx(r,g)$(not afs(g)) = dd0(r,g);
m_v.fx(r,g)$(not afs(g)) = m0(r,g);
md_v.fx(r,m,g)$(not afs(g)) = md0(r,m,g);

nm_v.fx(r,g,m)$(not afs(g)) = nm0(r,g,m);
dm_v.fx(r,g,m)$(not afs(g)) = dm0(r,g,m);

cdh_v.fx(r,g,h)$(not afs(g)) = cd0_h(r,g,h);
i_v.fx(r,g)$(not afs(g)) = i0(r,g);
g_v.fx(r,g)$(not afs(g)) = g0(r,g);

option qcp=cplex;
solve sectordisagg minimizing OBJ using QCP;

* Construct report on modified parameters

parameter
    report_prodstr	Report on modified production structures,
    report_control	Report on differences with control totals;

report_prodstr(r,ms,ns,'nat')$((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)) and afs(ms)) =
    id0_control(ns,ms) / ((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)));

report_prodstr(r,ms,'l','nat')$((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)) and afs(ms)) =
    ld0_control(ms) / ((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)));

report_prodstr(r,ms,'k','nat')$((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)) and afs(ms)) =
    (1+tk0('wi'))*kd0_control(ms) / ((1-ty0_control(ms))*sum(ns.local, ys0_control(ms,ns)));

report_prodstr(r,ms,ns,'cal')$((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)) and afs(ms)) =
    id_v.l(r,ns,ms) / ((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)));

report_prodstr(r,ms,'l','cal')$((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)) and afs(ms)) =
    ld_v.l(r,ms) / ((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)));

report_prodstr(r,ms,'k','cal')$((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)) and afs(ms)) =
    (1+tk0(r))*kd_v.l(r,ms) / ((1-ty0_control(ms))*sum(ns.local, ys_v.l(r,ms,ns)));
display report_prodstr;

* execute_unload 'chk_prod.gdx' report_prodstr;
* execute 'gdxxrw chk_prod.gdx par=report_prodstr rng=data!A2 cdim=0';
* $exit

* How close to reconciled control totals are we? we are creating data in some
* places at the national level.

alias(u,*);
report_control(ms,ns,'ys0','cal') = sum(r, ys_v.l(r,ms,ns));
report_control(ms,ns,'ys0','control') = ys0_control(ms,ns);

report_control(ns,ms,'id0','cal') = sum(r, id_v.l(r,ms,ns));
report_control(ns,ms,'id0','control') = id0_control(ms,ns);

report_control(ms,ns,u,'diff') = report_control(ms,ns,u,'cal') - report_control(ms,ns,u,'control');
display report_control;
$exit

* ------------------------------------------------------------------------------
* Remove tiny values
* ------------------------------------------------------------------------------

parameters
    ys0_cal(r,*,*)	Sectoral supply,
    id0_cal(r,*,*)	Intermediate demand,
    ld0_cal(r,*)	Labor demand,
    kd0_cal(r,*)	Capital demand,
    ty0_cal(r,*)	Production tax revenue,
    s0_cal(r,*)		Total supply,
    m0_cal(r,*)		Imports,
    nd0_cal(r,*)	National demand for goods and services,
    dd0_cal(r,*)	Local demand for goods and services,
    x0_cal(r,*)		Exports of goods and services,
    rx0_cal(r,*)	Re-exports,
    xn0_cal(r,*)	National supply of goods and services,
    xd0_cal(r,*)	Local supply of goods and services,
    md0_cal(r,*,*)	Margin demand,
    ms0_cal(r,*,*)	Margin supply,
    a0_cal(r,*)		Armington supply,
    ta0_cal(r,*)	Tax net subsidy revenue on intermediate demand,
    tm0_cal(r,*)	Import tariff revenue,
    cd0_cal(r,*)	Final demand,
    cd0_h_cal(r,*,*) 	Household final demand,
    g0_cal(r,*)		Government demand,
    i0_cal(r,*)		Investment demand;

ys0_cal(r,ms,ns) = ys_v.l(r,ms,ns);
id0_cal(r,ns,ms) = id_v.l(r,ns,ms);
ld0_cal(r,ms) = ld_v.l(r,ms);
kd0_cal(r,ms) = kd_v.l(r,ms);
ty0_cal(r,ms)$sum(ns, ys0_cal(r,ms,ns)) = ty0_control(ms);

x0_cal(r,ms) = x_v.l(r,ms);
xn0_cal(r,ms) = xn_v.l(r,ms);
xd0_cal(r,ms) = xd_v.l(r,ms);
s0_cal(r,ms) = s_v.l(r,ms);

a0_cal(r,ms) = a_v.l(r,ms);
ta0_cal(r,ms)$a0_cal(r,ms) = ta0_control(ms);
rx0_cal(r,ms) = rx_v.l(r,ms);
nd0_cal(r,ms) = nd_v.l(r,ms);
dd0_cal(r,ms) = dd_v.l(r,ms);
m0_cal(r,ms) = m_v.l(r,ms);
tm0_cal(r,ms)$m0_cal(r,ms) = tm0_control(ms);
md0_cal(r,m,ms) = md_v.l(r,m,ms);

parameter
    chk;
chk(r,ms,'ta_cal') = ta0_cal(r,ms);
chk(r,s,'ta_orig') = ta0(r,s);

chk(r,ms,'tm_cal') = tm0_cal(r,ms);
chk(r,s,'tm_orig') = tm0(r,s);

chk(r,ms,'ty_cal') = ty0_cal(r,ms);
chk(r,s,'ty_orig') = ty0(r,s);
display chk;
$exit



    nm_v, dm_v, cdh_v, i_v, g_v;


* ------------------------------------------------------------------------------
* Output disaggregated data in the temporary gdx directory:
* ------------------------------------------------------------------------------

execute_unload "%gdxdir%%hhdata%.gdx"

* Sets:

yr,r,ms=s,m,gms=gm,h,trn,

* Production data:

ys_0=ys0_,ld_0=ld0_,kd_0=kd0_,id_0=id0_,ty_0=ty0_,

* Consumption data:

yh_0=yh0_,cd_0=cd0_,c_0=c0_,i_0=i0_,g_0=g0_,bopdef_0=bopdef0_,hhad_j=hhadj_,

* Trade data:

s_0=s0_,xd_0=xd0_,xn_0=xn0_,x_0=x0_,rx_0=rx0_,a_0=a0_,nd_0=nd0_,dd_0=dd0_,
m_0=m0_,ta_0=ta0_,tm_0=tm0_,

* Margins:

md_0=md0_,nm_0=nm0_,dm_0=dm0_,

* Household data:

pop_0=pop_,le_0=le0_,ke_0=ke0_,tk_0=tk0_,tl_0=tl0_,cd_0h_=cd0_h_,c_0h_=c0_h_,
sav_0=sav0_,trn_0=trn0_,hhtrn_0=hhtrn0_;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
