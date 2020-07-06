$TITLE Routine for disaggregating sectoring definitions :/

$IF NOT SET aggr	$SET aggr bluenote

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* Set directory structure:
$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "..%sep%built_datasets"

* $IF NOT SET year $SET year 2016

SET ir_use "Dynamically created set from parameter use_det_units, identifiers for use table rows";
SET jc_use "Dynamically created set from parameter use_det_units, identifiers for use table columns";
SET ir_supply "Dynamically created set from parameter supply_det_units, identifiers for supply table rows";
SET jc_supply "Dynamically created set from parameter supply_det_units, identifiers for supply table columns";
SET yr_det "Dynamically created set from parameter use_det_units, identifiers for supply table columns";

SET s	"Detailed BEA Goods and sectors categories (2007 and 2012 only)";
SET as "Aggregated 71 sector definitions";
SET sector_map "Mapping between detailed and aggregated BEA sectors";
SET va "Value-added";
SET fd "Final demand";


PARAMETER use_det_units(yr_det,ir_use,jc_use,*) "Annual use matrix with units as domain";
PARAMETER supply_det_units(yr_det,ir_supply,jc_supply,*) "Annual supply matrix with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD yr_det<use_det_units.dim1
$LOAD ir_use<use_det_units.dim2
$LOAD jc_use<use_det_units.dim3
$LOAD use_det_units
$LOAD ir_supply<supply_det_units.dim2
$LOAD jc_supply<supply_det_units.dim3
$LOAD supply_det_units
$LOAD s=i_det
$LOAD as=i
$LOAD sector_map
$LOAD va
$LOAD fd
$GDXIN

ALIAS(s,g,i,j);

PARAMETER ys0(yr_det,j,i) "Sectoral supply";
PARAMETER fs0(yr_det,i) "Household supply";
PARAMETER id0(yr_det,i,j) "Intermediate demand";
PARAMETER fd0(yr_det,i,fd) "Final demand";
PARAMETER va0(yr_det,va,j) "Vaue added";
PARAMETER m0(yr_det,i) "Imports";
PARAMETER x0(yr_det,i) "Exports of goods and services";
PARAMETER y0(yr_det,i) "Aggregate supply";
PARAMETER a0(yr_det,i) "Armington supply";

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

PARAMETER interm(*,j,*) "Total intermediate inputs (purchasers' prices)";
PARAMETER valueadded(*,j,*) "Value added (purchaser's prices)";
PARAMETER output(*,j,*) "Total industry output (basic prices)";
PARAMETER totint(*,i,*) "Total intermediate use (purchasers' prices)";
PARAMETER totaluse(*,i,*) "Total use of commodities (purchasers' prices)";

interm(yr_det,j(jc_use),'use') = use_det_units(yr_det,'interm',jc_use,'millions of us dollars (USD)');
interm(yr_det,j,'id0') = sum(i, id0(yr_det,i,j));
interm(yr_det,j,'chk') = interm(yr_det,j,'id0') - interm(yr_det,j,'use');
DISPLAY interm;


* Sets with large positive differences are the result of eliminating negative
* input demands. Indicies with negative numbers for "chk" represent improper
* summing in the use tables supplied by the BEA. I use purchaser price tables.

valueadded(yr_det,j(jc_use),'use') = use_det_units(yr_det,'basicvalueadded',jc_use,'millions of us dollars (USD)');
valueadded(yr_det,j,'va0') = sum(va, va0(yr_det,va,j));
valueadded(yr_det,j,'chk') = valueadded(yr_det,j,'use') - valueadded(yr_det,j,'va0');
DISPLAY valueadded;

output(yr_det,j(jc_use),'use') = use_det_units(yr_det,'industryoutput',jc_use,'millions of us dollars (USD)');
output(yr_det,j,'id0+va0') = sum(va, va0(yr_det,va,j)) + sum(i, id0(yr_det,i,j));
output(yr_det,j,'ys0') = sum(i, ys0(yr_det,j,i));
output(yr_det,j,'chk') = output(yr_det,j,'id0+va0') - output(yr_det,j,'use');
output(yr_det,j,'chk-ys0') = output(yr_det,j,'id0+va0') - output(yr_det,j,'ys0');
DISPLAY output;

totint(yr_det,i(ir_use),'use') = use_det_units(yr_det,ir_use,'totint','millions of us dollars (USD)');
totint(yr_det,i,'id0') = sum(j, id0(yr_det,i,j));
totint(yr_det,i,'chk') = totint(yr_det,i,'use') - totint(yr_det,i,'id0');
DISPLAY totint;

totaluse(yr_det,i(ir_use),'use') = use_det_units(yr_det,ir_use,'totaluse','millions of us dollars (USD)');
totaluse(yr_det,i,'id0+fd0+x0-m0') = sum(j, id0(yr_det,i,j)) + sum(fd, fd0(yr_det,i,fd)) + x0(yr_det,i) - m0(yr_det,i);
totaluse(yr_det,i,'chk') = totaluse(yr_det,i,'use') - totaluse(yr_det,i,'id0+fd0+x0-m0');
DISPLAY totaluse;



* -------------------------------------------------------------------
* Pick sectors to disaggregate:

SET disagg(as,s) /
$INCLUDE %reldir%%sep%user_defined_schemes%sep%%aggr%.set
/;

SET ss(s);
ss(s)$(sum(as, disagg(as,s))) = yes;
* ----------------------------------------------------------------
* Create master set for all included indices:

* As a simple naming convention, I leave the aggregate label unchanged IF the
* dissagregate sectors chosen only partially covers the aggregate sector.


SET ms(*) "Master set of goods and sectors in disaggregation";
SET gms(*) "Master list of goods related to margin supply/demand";

ms(as) = yes;

* remove aggregate sector (if being fully disaggregated) and replace with disaggregated sector scheme
ms(as)$(sum(ss$sector_map(ss,as), 1) = sum(s$sector_map(s,as), 1)) = no;
ms(s)$(sum(as, disagg(as,s))) = yes;


* Define subset for aggregate sectors not impacted by the disaggregation:
SET us(as) "Unaffected aggregate sectors";
SET afs(*) "Others";
SET same(*,*,*) "Linking of affected sectors with aggregated secs";
ALIAS(sss,ss),(sector_map,sector_mapp);

us(as) = yes$(NOT sum(s, disagg(as,s)));
afs(ss) = yes;
afs(as) = yes$(NOT us(as));
same(ss,as,as) = yes$(sector_map(ss,as) AND NOT us(as));
same(as,ss,as) = yes$(sector_map(ss,as) AND NOT us(as));
same(ss,sss,as) = yes$(sector_map(ss,as) AND sector_mapp(sss,as));
same(as,as,as) = yes$(NOT us(as));


* -------------------------------------------------------------------
* Generate shares for disaggregation:

* Current disaggregation simply based on supply shares. Future iteration follows
* statedisagg.gms.

PARAMETER share(*,*,as) "Sharing parameter for disaggregation";
share(yr_det,ss,as)$sector_map(ss,as) = y0(yr_det,ss) / sum(s$sector_map(s,as), y0(yr_det,s));


* Basic check on shares for a given sector (NOT USED, and therefore commented... simply uncommenting will throw errors)

* PARAMETER chkshr;
*
* chkshr(yr_det,'y0',ss) = sum(as, share(yr_det,ss,as));
*
* chkshr(yr_det,'x0',ss)$(sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), x0(u,i)))) =
*     sum(map(ss,i), x0(u,i)) / sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), x0(u,i)));
*
*
* chkshr(yr_det,'m0',ss)$(sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), m0(u,i)))) =
*     sum(map(ss,i), m0(u,i)) / sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), m0(u,i)));
*
* chkshr(yr_det,'a0',ss)$(sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), a0(u,i)))) =
*     sum(map(ss,i), a0(u,i)) / sum(as$sector_map(ss,as), sum(map(g,i)$sector_map(g,as), a0(u,i)));

* For all (as) not associated with chosen sub-sectors, set to 1;

share(yr_det,as,as)$(sum(ss$sector_map(ss,as), 1) = 0) = 1;
share(yr_det,as,as)$(ms(as) and sum(ss$sector_map(ss,as), 1) > 0) = round(1 - sum(ss, share(yr_det,ss,as)), 10);

* ------------------------------------------------------------------
* Read in aggregate data:

SET yr "Years of IO data";
SET r "States";
SET m "Margins (trade or transport)";

$GDXIN %dsdir%%sep%WiNDCdatabase.gdx
$LOADDC yr
$LOADDC r
$LOADDC m

* Create mapping between years of available data:
SET mapy(*,yr) "Mapping between summary and detailed table years";
mapy('2007',yr) = yes$(yr.val <= 2009);
mapy('2012',yr) = yes$(yr.val > 2009);

ALIAS(as,ag),(ms,ns),(us,uus),(ss,gg),(afs,afss);

PARAMETER share_(yr,*,ag) "Sector disaggregation share";
PARAMETER ys0_(yr,r,as,ag) "Sectoral supply";
PARAMETER id0_(yr,r,ag,as) "Intermediate demand";
PARAMETER ld0_(yr,r,as) "Labor demand";
PARAMETER kd0_(yr,r,as) "Capital demand";
PARAMETER ty0_(yr,r,as) "Production tax rate";
PARAMETER m0_(yr,r,as) "Imports";
PARAMETER x0_(yr,r,as) "Exports of goods and services";
PARAMETER rx0_(yr,r,as) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,as) "Total margin demand";
PARAMETER nm0_(yr,r,ag,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,ag,m) "Margin supply from local market";
PARAMETER s0_(yr,r,as) "Aggregate supply";
PARAMETER a0_(yr,r,as) "Armington supply";
PARAMETER ta0_(yr,r,as) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,as) "Import tariff";
PARAMETER cd0_(yr,r,as) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,as) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,as) "Government demand";
PARAMETER i0_(yr,r,as) "Investment demand";
PARAMETER xn0_(yr,r,ag) "Regional supply to national market";
PARAMETER xd0_(yr,r,ag) "Regional supply to local market";
PARAMETER dd0_(yr,r,ag) "Regional demand from local market";
PARAMETER nd0_(yr,r,ag) "Regional demand from national market";

* Production data:

$LOADDC ys0_
$LOADDC ld0_
$LOADDC kd0_
$LOADDC id0_
$LOADDC ty0_

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

* Share:
share_(yr,ms,ag) = sum(mapy(yr_det,yr), share(yr_det,ms,ag));


* NOTE: set ms in this version has the agg sectors that are being disaggregate removed from the data... original version does not do this... might introduce bugs?



* ------------------------------------------------------------------
* Share out aggregate data:

PARAMETER ys_0(yr,r,*,*) "Sectoral supply";
PARAMETER id_0(yr,r,*,*) "Intermediate demand";
PARAMETER ld_0(yr,r,*) "Labor demand";
PARAMETER kd_0(yr,r,*) "Capital demand";
PARAMETER ty_0(yr,r,*) "Production tax rate";
PARAMETER m_0(yr,r,*) "Imports";
PARAMETER x_0(yr,r,*) "Exports of goods and services";
PARAMETER rx_0(yr,r,*) "Re-exports of goods and services";
PARAMETER md_0(yr,r,m,*) "Total margin demand";
PARAMETER nm_0(yr,r,*,m) "Margin demand from national market";
PARAMETER dm_0(yr,r,*,m) "Margin supply from local market";
PARAMETER s_0(yr,r,*) "Aggregate supply";
PARAMETER a_0(yr,r,*) "Armington supply";
PARAMETER ta_0(yr,r,*) "Tax net subsidy rate on intermediate demand";
PARAMETER tm_0(yr,r,*) "Import tariff";
PARAMETER cd_0(yr,r,*) "Final demand";
PARAMETER c_0(yr,r) "Aggregate final demand";
PARAMETER yh_0(yr,r,*) "Household production";
PARAMETER fe_0(yr,r) "Factor endowments";
PARAMETER bopdef_0(yr,r) "Balance of payments";
PARAMETER hhad_j(yr,r) "Household adjustment";
PARAMETER g_0(yr,r,*) "Government demand";
PARAMETER i_0(yr,r,*) "Investment demand";
PARAMETER xn_0(yr,r,*) "Regional supply to national market";
PARAMETER xd_0(yr,r,*) "Regional supply to local market";
PARAMETER dd_0(yr,r,*) "Regional demand from local market";
PARAMETER nd_0(yr,r,*) "Regional demand from national market";

* Two dimensional indices (ys0, id0) require special treatment. Low hanging
* fruit first.

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

* Define margin set:

gms(ms) = yes$(sum((yr,r,m), nm_0(yr,r,ms,m) + dm_0(yr,r,ms,m)) OR sum((yr,r,m), md_0(yr,r,m,ms)));

* Aggregate parameters can be solved for or set explicitly:

c_0(yr,r) = sum(ms, cd_0(yr,r,ms));
bopdef_0(yr,r) = sum(ms, m_0(yr,r,ms) - x_0(yr,r,ms));
hhad_j(yr,r) = hhadj_(yr,r);
fe_0(yr,r) = fe0_(yr,r);

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
* 	Output disaggregated data:
* ----------------------------------------------------------------

EXECUTE_UNLOAD "%reldir%%sep%temp%sep%gdx_temp%sep%sectordisagg_%aggr%.gdx"

* Sets:

yr,r,ms=s,m,gms=gm,

* Production data:

ys_0=ys0_,ld_0=ld0_,kd_0=kd0_,id_0=id0_,ty_0=ty0_,

* Consumption data:

yh_0=yh0_,fe_0=fe0_,cd_0=cd0_,c_0=c0_,i_0=i0_,g_0=g0_,bopdef_0=bopdef0_,hhad_j=hhadj_,

* Trade data:

s_0=s0_,xd_0=xd0_,xn_0=xn0_,x_0=x0_,rx_0=rx0_,a_0=a0_,nd_0=nd0_,dd_0=dd0_,m_0=m0_,ta_0=ta0_,tm_0=tm0_,

* Margins:

md_0=md0_,nm_0=nm0_,dm_0=dm0_;
