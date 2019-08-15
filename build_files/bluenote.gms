$STITLE Matrix balancing routine for enforcing parameter values

$ONTEXT
This sub-routine adjusts accounts from the core WiNDC database to match SEDS
(State Energy Data System). It has three parts:
 - Separate the oil and natural gas extraction sector
 - Impose new totals
 - Re-calibrate dataset for a given year

I refrain from separating the energy sector technology type (ie. coal
vs. nuclear). The basic totals I am interested in from SEDS are margins
(from consumer vs. wholesale electricity pricing), energy demands and output
which correspond well to emissions data.

New sector name: ds -- includes separation of oil and gas sectors.
Parameters altered: ys0, cd0, md0, id0, x0(ele_uti), m0(ele_uti) to match SEDS
totals. New parameters included are co2(*) describing total co2 emissions by
generating sector/agent.
$OFFTEXT

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* Set directory structure:
$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "..%sep%built_datasets"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

* Aggregation:
$IF NOT SET satdata $SET satdata bluenote

* Output parameters for a single year:
$IF NOT SET year $SET year 2016

* Define loss function (huber, ls):
$IF NOT SET matbal $SET matbal ls


$IFTHENI.kestrel "%neos%" == "yes"
FILE opt / kestrel.opt /;
$ENDIF.kestrel


* -------------------------------------------------------------------
* Read in core regionalized WiNDC dataset and other necessary data:
* -------------------------------------------------------------------

SET source "Dynamically created set from seds_units parameter, EIA SEDS source codes";
SET sector "Dynamically created set from seds_units parameter, EIA SEDS sector codes";
SET sr "Super set of Regions (states + US) in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";
SET yr "Years in WiNDC Database"
PARAMETER seds_units(source,sector,sr,yr,*) "Complete EIA SEDS data, with units as domain";
PARAMETER crude_oil_price_units(yr,*) "Crude Oil price (composite between domestic and international), with units as domain";
PARAMETER heatrate_units(yr,*,*) "EIA Elec Generator average heat rates, with units as domain";
PARAMETER co2perbtu_units(*,*) "Carbon dioxide -- not CO2s -- content (kg per million btu)";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD yr
$LOAD sr
$LOAD r
$LOAD source<seds_units.dim1
$LOAD sector<seds_units.dim2
$LOAD seds_units
$LOAD heatrate_units
$LOAD crude_oil_price_units
$LOAD co2perbtu_units
$GDXIN

SET e "Energy producing sectors in SEDS";
SET src "SEDS energy technologies";
PARAMETER sedsenergy(r,*,*,*,yr) "Reconciled SEDS energy data";
PARAMETER elegen(*,*,yr) "Electricity generation by source (mill. btu or tkwh for ele)";

$GDXIN '%reldir%%sep%temp%sep%gdx_temp%sep%seds.gdx'
$LOAD e
$LOAD src
$LOADDC sedsenergy
$LOAD elegen
$GDXIN

SET s "Goods\sectors (national data)";
SET gm(s) "Margin related sectors";
SET m	"Margins (trade or transport)";

$GDXIN '%dsdir%%sep%WiNDC_disagg_%satdata%.gdx'
$LOADDC s
$LOADDC m
$LOADDC gm

ALIAS(s,g),(r,rr),(*,u);

PARAMETER ys0_(yr,r,s,g) "Sectoral supply";
PARAMETER id0_(yr,r,g,s) "Intermediate demand";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER ty0_(yr,r,s) "Production tax rate";
PARAMETER m0_(yr,r,g) "Imports";
PARAMETER x0_(yr,r,g) "Exports of goods and services";
PARAMETER rx0_(yr,r,g) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,g) "Total margin demand";
PARAMETER nm0_(yr,r,g,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from local market";
PARAMETER s0_(yr,r,g) "Aggregate supply";
PARAMETER a0_(yr,r,g) "Armington supply";
PARAMETER ta0_(yr,r,g) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,g) "Import tariff";
PARAMETER cd0_(yr,r,g) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,g) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,g) "Government demand";
PARAMETER i0_(yr,r,g) "Investment demand";
PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local  market";
PARAMETER nd0_(yr,r,g) "Regional demand from national market";

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
$GDXIN

* -------------------------------------------------------------------
* Define national totals:
* -------------------------------------------------------------------
PARAMETER ys0nat;
PARAMETER m0nat;
PARAMETER x0nat;
PARAMETER va0nat;
PARAMETER i0nat;
PARAMETER g0nat;
PARAMETER cd0nat;

ys0nat(yr,s,g) = sum(r, ys0_(yr,r,s,g));
m0nat(yr,g) = sum(r, m0_(yr,r,g));
x0nat(yr,g) = sum(r, x0_(yr,r,g));
va0nat(yr,g) = sum(r, ld0_(yr,r,g) + kd0_(yr,r,g));
i0nat(yr,g) = sum(r, i0_(yr,r,g));
g0nat(yr,g) = sum(r, g0_(yr,r,g));
cd0nat(yr,g) = sum(r, cd0_(yr,r,g));

PARAMETER dataconschk "Consistency check on re-calibrated data";

dataconschk(r,s,'ys0','old') = sum(g, ys0_('%year%',r,s,g));
dataconschk(r,g,'id0','old') = sum(s, id0_('%year%',r,g,s));
dataconschk(r,s,'va0','old') = ld0_('%year%',r,s) + kd0_('%year%',r,s);
dataconschk(r,s,'tyrev','old') = (1-ty0_('%year%',r,s)) * sum(g, ys0_('%year%',r,s,g));

dataconschk(r,g,'i0','old') = i0_('%year%',r,g);
dataconschk(r,g,'g0','old') = g0_('%year%',r,g);
dataconschk(r,g,'cd0','old') = cd0_('%year%',r,g);
dataconschk(r,g,'yh0','old') = yh0_('%year%',r,g);
dataconschk(r,'total','hhadj','old') = hhadj_('%year%',r);
dataconschk(r,'total','bop','old') = bopdef0_('%year%',r);

dataconschk(r,g,'s0','old') = s0_('%year%',r,g);
dataconschk(r,g,'xd0','old') = xd0_('%year%',r,g);
dataconschk(r,g,'xn0','old') = xn0_('%year%',r,g);
dataconschk(r,g,'x0','old') = x0_('%year%',r,g);
dataconschk(r,g,'rx0','old') = rx0_('%year%',r,g);
dataconschk(r,g,'a0','old') = a0_('%year%',r,g);
dataconschk(r,g,'nd0','old') = nd0_('%year%',r,g);
dataconschk(r,g,'dd0','old') = dd0_('%year%',r,g);
dataconschk(r,g,'m0','old') = m0_('%year%',r,g);

dataconschk(r,g,'md0','old') = sum(m, md0_('%year%',r,m,g));
dataconschk(r,g,'nm0','old') = sum(m, nm0_('%year%',r,g,m));
dataconschk(r,g,'dm0','old') = sum(m, dm0_('%year%',r,g,m));

* -------------------------------------------------------------------
* Impose outside data: SEDS
* -------------------------------------------------------------------

PARAMETER prodbtu(r,yr,*) "Total production of either natural gas or crude oil (trillions btu)";
PARAMETER prodval(r,yr,*) "Value of production using supply prices (billions dollars)";
PARAMETER sedsenergy(r,*,*,*,yr) "SEDS energy data";

PARAMETER convfac(yr,r) "Conversion factor for translating dollars per barrel to dollars per million btu";
PARAMETER cprice(yr,r) "Crude oil price in dollars per million btu";

convfac(yr,r) = seds_units('CO','PR',r,yr,'million btu per barrel');
cprice(yr,r)$convfac(yr,r) = crude_oil_price_units(yr,'us dollars (USD) per barrel') / convfac(yr,r);

prodbtu(r,yr,'gas') = seds_units('NG','MP',r,yr,'billion btu') / 1000;
prodbtu(r,yr,'cru') = seds_units('PA','PR',r,yr,'billion btu') / 1000;


SET demsec "Demanding categories for energy"
			/ ind	"Industry",
			  com	"Commercial",
			  res	"Residential",
			  trn	"Transportation",
			  ele	"Electricity generation",
			  ref	"Oil refining" /;

SET fds_e(demsec) "Non energy final demand categories" / ind, com, res, trn /;

SET mapdems(*,demsec) "Mapping between SEDS and IO demanding sectors" /
$INCLUDE %reldir%%sep%maps%sep%mapseds.map
/;

* Quick note on units. pe0 is in dollars per million btu's for non
* electricity energy sources. Prices are denominated in dollars per
* thousand kwhs for electricity. Multiplying price x quanitity below
* results in things denominated in millions of dollars. Scaling by 1000 ->
* billions of dollars per year.

PARAMETER pe0(yr,r,e,demsec) "Energy demand prices ($ per mbtu -- $ per thou kwh for ele)";
PARAMETER pedef(yr,r,e) "Average energy demand prices";
PARAMETER ps0(yr,*) "Supply prices of crude oil and natural gas (dollars per million btu)";

pedef(yr,r,e)$sum(demsec, sedsenergy(r,'q',e,demsec,yr))
	 =	sum(demsec, sedsenergy(r,'p',e,demsec,yr)*sedsenergy(r,'q',e,demsec,yr)) /
		sum(demsec, sedsenergy(r,'q',e,demsec,yr));

* Otherwise, use the average across all regions which have a value:

pedef(yr,r,e)$(not pedef(yr,r,e) and sum(rr$pedef(yr,rr,e), sum(demsec, sedsenergy(rr,'q',e,demsec,yr)))) =
	sum(rr, pedef(yr,rr,e)*sum(demsec, sedsenergy(rr,'q',e,demsec,yr))) /
	sum(rr$pedef(yr,rr,e), sum(demsec, sedsenergy(rr,'q',e,demsec,yr)));

pe0(yr,r,e,demsec) = pedef(yr,r,e);
pe0(yr,r,e,demsec)$sedsenergy(r,'p',e,demsec,yr) = sedsenergy(r,'p',e,demsec,yr);

* There is no price information for crude oil in SEDS. Use annual EIA
* averages:

pe0(yr,r,'cru',demsec) = cprice(yr,r);
pe0(yr,r,'cru',demsec)$(not pe0(yr,r,'cru',demsec) and max(0,sedsenergy(r,'q','cru',demsec,yr))) =
    (1/sum(rr$cprice(yr,rr), 1)) * sum(rr, cprice(yr,rr));

* ps0 denotes the supply price of energy supply sources and is assumed to
* be the minimum price across regions. Note that industrial electricity
* prices are quite a bit lower than other industries in each state.

ps0(yr,e) = smin((demsec,rr)$pe0(yr,rr,e,demsec),pe0(yr,rr,e,demsec));

* Crude oil prices are quite high relative to refined oil prices. Set crude oil
* to be half of refined oil prices pending better estimates.

ps0(yr,'cru') = ps0(yr,'oil') / 2;

prodval(r,yr,'gas') = ps0(yr,'gas') * prodbtu(r,yr,'gas') / 1000;
prodval(r,yr,'cru') = ps0(yr,'cru') * prodbtu(r,yr,'cru') / 1000;

* Separate all parameters using the same share to maintain
* micro-consistency.

SET as "Additional sectors" / gas, cru /;
SET mapog(as,s) "Mapping between oil and gas sectors" / gas.cng, cru.cng /;
SET ds(*) "Disaggregate sectoring scheme";

PARAMETER shrgas(r,yr,as) "Share of production in each state for gas extraction";
PARAMETER chkshr "Check on extraction shares";

shrgas(r,yr,as)$sum(as.local, prodval(r,yr,as)) = prodval(r,yr,as) / sum(as.local, prodval(r,yr,as));

* If no production data exists, use the average:

shrgas(r,yr,as)$(NOT shrgas(r,yr,as) and sum(g, ys0_(yr,r,'cng',g))) = (1/sum(r.local$shrgas(r,yr,as), 1)) * sum(r.local, shrgas(r,yr,as));

* Scale such that shares sum to one:

shrgas(r,yr,as)$sum(as.local, shrgas(r,yr,as)) = shrgas(r,yr,as) / sum(as.local, shrgas(r,yr,as));

* Verify no shares are greater than one:

chkshr(r,yr,as,'>1')$(shrgas(r,yr,as) > 1) = shrgas(r,yr,as);
chkshr(r,yr,as,'<0')$(shrgas(r,yr,as) < 0) = shrgas(r,yr,as);
chkshr(r,yr,'tot','tot') = sum(as, shrgas(r,yr,as));
chkshr('max',yr,'tot','tot') = smax(r, chkshr(r,yr,'tot','tot'));
ABORT$(round(smax((r,yr), chkshr(r,yr,'tot','tot')),5) > 1) "Shares don't sum to 1.";

PARAMETER ys0(yr,r,*,*) "Sectoral supply";
PARAMETER id0(yr,r,*,*) "Intermediate demand";
PARAMETER ld0(yr,r,*) "Labor demand";
PARAMETER kd0(yr,r,*) "Capital demand";
PARAMETER ty0(yr,r,*) "Production tax rate";
PARAMETER m0(yr,r,*) "Imports";
PARAMETER x0(yr,r,*) "Exports of goods and services";
PARAMETER rx0(yr,r,*) "Re-exports of goods and services";
PARAMETER md0(yr,r,m,*) "Total margin demand";
PARAMETER nm0(yr,r,*,m) "Margin demand from national market";
PARAMETER dm0(yr,r,*,m) "Margin supply from local market";
PARAMETER s0(yr,r,*) "Aggregate supply";
PARAMETER a0(yr,r,*) "Armington supply";
PARAMETER ta0(yr,r,*) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0(yr,r,*) "Import tariff";
PARAMETER cd0(yr,r,*) "Final demand";
PARAMETER c0(yr,r) "Aggregate final demand";
PARAMETER yh0(yr,r,*) "Household production";
PARAMETER fe0(yr,r) "Factor endowments";
PARAMETER bopdef0(yr,r) "Balance of payments";
PARAMETER hhadj(yr,r) "Household adjustment";
PARAMETER g0(yr,r,*) "Government demand";
PARAMETER i0(yr,r,*) "Investment demand";
PARAMETER xn0(yr,r,*) "Regional supply to national market";
PARAMETER xd0(yr,r,*) "Regional supply to local market";
PARAMETER dd0(yr,r,*) "Regional demand from local  market";
PARAMETER nd0(yr,r,*) "Regional demand from national market";

* Set values for unaffected parameters:

ld0(yr,r,s)$(NOT SAMEAS(s,'cng')) = ld0_(yr,r,s);
kd0(yr,r,s)$(NOT SAMEAS(s,'cng')) = kd0_(yr,r,s);
ty0(yr,r,s)$(NOT SAMEAS(s,'cng')) = ty0_(yr,r,s);
m0(yr,r,g)$(NOT SAMEAS(g,'cng')) = m0_(yr,r,g);
x0(yr,r,g)$(NOT SAMEAS(g,'cng')) = x0_(yr,r,g);
rx0(yr,r,g)$(NOT SAMEAS(g,'cng')) = rx0_(yr,r,g);
s0(yr,r,g)$(NOT SAMEAS(g,'cng')) = s0_(yr,r,g);
a0(yr,r,g)$(NOT SAMEAS(g,'cng')) = a0_(yr,r,g);
ta0(yr,r,g)$(NOT SAMEAS(g,'cng')) = ta0_(yr,r,g);
tm0(yr,r,g)$(NOT SAMEAS(g,'cng')) = tm0_(yr,r,g);
cd0(yr,r,g)$(NOT SAMEAS(g,'cng')) = cd0_(yr,r,g);
yh0(yr,r,g)$(NOT SAMEAS(g,'cng')) = yh0_(yr,r,g);
g0(yr,r,g)$(NOT SAMEAS(g,'cng')) = g0_(yr,r,g);
i0(yr,r,g)$(NOT SAMEAS(g,'cng')) = i0_(yr,r,g);
xn0(yr,r,g)$(NOT SAMEAS(g,'cng')) = xn0_(yr,r,g);
xd0(yr,r,g)$(NOT SAMEAS(g,'cng')) = xd0_(yr,r,g);
dd0(yr,r,g)$(NOT SAMEAS(g,'cng')) = dd0_(yr,r,g);
nd0(yr,r,g)$(NOT SAMEAS(g,'cng')) = nd0_(yr,r,g);
ys0(yr,r,s,g)$(NOT SAMEAS(s,'cng') and NOT SAMEAS(g,'cng')) = ys0_(yr,r,s,g);
id0(yr,r,g,s)$(NOT SAMEAS(s,'cng') and NOT SAMEAS(g,'cng')) = id0_(yr,r,g,s);
md0(yr,r,m,g)$(NOT SAMEAS(g,'cng')) = md0_(yr,r,m,g);
nm0(yr,r,g,m)$(NOT SAMEAS(g,'cng')) = nm0_(yr,r,g,m);
dm0(yr,r,g,m)$(NOT SAMEAS(g,'cng')) = dm0_(yr,r,g,m);
c0(yr,r) = c0_(yr,r);
bopdef0(yr,r) = bopdef0_(yr,r);
hhadj(yr,r) = hhadj_(yr,r);

* Share out oil and gas extraction sector:

ld0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * ld0_(yr,r,s));
kd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * kd0_(yr,r,s));
ty0(yr,r,as) = sum(mapog(as,s), ty0_(yr,r,s));
m0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * m0_(yr,r,s));
x0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * x0_(yr,r,s));
rx0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * rx0_(yr,r,s));
s0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * s0_(yr,r,s));
a0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * a0_(yr,r,s));
ta0(yr,r,as) = sum(mapog(as,s), ta0_(yr,r,s));
tm0(yr,r,as) = sum(mapog(as,s), tm0_(yr,r,s));
cd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * cd0_(yr,r,s));
yh0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * yh0_(yr,r,s));
g0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * g0_(yr,r,s));
i0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * i0_(yr,r,s));
xn0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * xn0_(yr,r,s));
xd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * xd0_(yr,r,s));
dd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * dd0_(yr,r,s));
nd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * nd0_(yr,r,s));
md0(yr,r,m,as) = sum(mapog(as,s), shrgas(r,yr,as) * md0_(yr,r,m,s));
nm0(yr,r,as,m) = sum(mapog(as,s), shrgas(r,yr,as) * nm0_(yr,r,s,m));
dm0(yr,r,as,m) = sum(mapog(as,s), shrgas(r,yr,as) * dm0_(yr,r,s,m));

ALIAS(as,as_);

ys0(yr,r,s,as)$(NOT SAMEAS(s,'cng')) = sum(mapog(as,g), shrgas(r,yr,as) * ys0_(yr,r,s,g));
ys0(yr,r,as,g)$(NOT SAMEAS(g,'cng')) = sum(mapog(as,s), shrgas(r,yr,as) * ys0_(yr,r,s,g));

* Assume there is no byproduct production between both crude oil and
* natural gas.

ys0(yr,r,as,as) = sum(mapog(as,s), shrgas(r,yr,as) * ys0_(yr,r,s,s));

id0(yr,r,g,as)$(NOT SAMEAS(g,'cng')) = sum(mapog(as,s), shrgas(r,yr,as) * id0_(yr,r,g,s));
id0(yr,r,as,s)$(NOT SAMEAS(s,'cng')) = sum(mapog(as,g), shrgas(r,yr,as) * id0_(yr,r,g,s));
id0(yr,r,as,as) = sum(mapog(as,s), shrgas(r,yr,as) * id0_(yr,r,s,s));

ds(s)$(NOT SAMEAS(s,'cng')) = yes;
ds(as) = yes;
ALIAS(ds,dg);

* Save initial factor value shares in production:

PARAMETER fvs "Factor value shares";

fvs(yr,r,ds,'lab')$sum(dg, ys0(yr,r,ds,dg)) = ld0(yr,r,ds) / sum(dg, ys0(yr,r,ds,dg));
fvs(yr,r,ds,'cap')$sum(dg, ys0(yr,r,ds,dg)) = kd0(yr,r,ds) / sum(dg, ys0(yr,r,ds,dg));


* -------------------------------------------------------------------------
* Enforce that supply sent to other regions in the county or imported from
* other states line up with net generation. Also, enforce aggregate
* production value of electricity is in line with seds.
* -------------------------------------------------------------------------

PARAMETER netgen(r,yr,*) "Net interstate flows of electricity (10s of bill $)";
PARAMETER trdele(r,yr,*) "Electricity imports-exports to-from USA (10s of bill. $)";
PARAMETER elesup(r,yr) "Impose electricity supply totals based on SEDS";
PARAMETER eledem(r,yr) "Energy demand based on SEDS";

netgen(r,yr,'seds') = ps0(yr,'ele') / 1000 * seds_units('EL','IS',r,yr,'million kilowatthours') / 1000;
netgen(r,yr,'seds') = netgen(r,yr,'seds') / 10;
netgen(r,yr,'io') = nd0(yr,r,'ele') - xn0(yr,r,'ele');

* Initial data is in millions of dollars:

trdele(r,yr,'imp') = seds_units('EL','IM',r,yr,'million dollars') / 10000;
trdele(r,yr,'exp') = seds_units('EL','EX',r,yr,'million dollars') / 10000;

x0(yr,r,'ele') = trdele(r,yr,'exp');
m0(yr,r,'ele') = trdele(r,yr,'imp');



SET mapsrc(src,*) "Mapping with technologies and primary inputs for fossil fuel" / col.col, gas.gas, oil.oil /;
SET ioe(*) "Energy sectors in the IO data" / col, cru, gas, oil, ele /;
SET mapioe(ioe,e) / col.col, cru.cru, gas.gas, oil.oil, ele.ele /;

PARAMETER pctgen "Percent of generation";
PARAMETER pctgen_;
ALIAS(src,ssrc);

pctgen_(yr,r,src,'ele')$sum(ssrc, elegen(r,ssrc,yr)) = 100 * elegen(r,src,yr) / sum(ssrc, elegen(r,ssrc,yr));
pctgen(yr,r,ioe,'ele') = sum(mapsrc(src,ioe), pctgen_(yr,r,src,'ele'));
pctgen(yr,r,ioe,demsec)$(NOT SAMEAS(demsec,'ele')) = 2;

* Electricity demand should be shared across sectors in each
* category. Margin demand will be defined as the difference between the
* two.

PARAMETER eq0(yr,r,*,*) "Energy demand (trillions of btu or billions of kwh)";
PARAMETER ed0(yr,r,e,demsec) "Energy demand (10s of bill $ value gross margin)";
PARAMETER emarg0(yr,r,e,*) "Margin demand for energy markups (10s of bill $)";
PARAMETER ned0(yr,r,*,*) "Net energy demands (10s of bill $ value net of margin)";

eq0(yr,r,e,demsec) = max(0,sedsenergy(r,'q',e,demsec,yr));
ed0(yr,r,e,demsec) = pe0(yr,r,e,demsec) * eq0(yr,r,e,demsec) / 1e4;
emarg0(yr,r,e,demsec)$ed0(yr,r,e,demsec) = (pe0(yr,r,e,demsec) - ps0(yr,e)) * eq0(yr,r,e,demsec) / 1e4;
ned0(yr,r,e,demsec) = ed0(yr,r,e,demsec) - emarg0(yr,r,e,demsec);

* Assume margins for energy is aggregated and applied uniformily to all
* demanding sectors for each energy type. I.e. adjust md0(yr,r,e) for
* margins and id0(r,e,demsec) and cd0(r,e) for demands.

* Resource related energy goods already had margins in the data. Share out
* new totals using existing margins.

PARAMETER margshr(yr,r,m,*);

margshr(yr,r,'trn',ioe)$sum(m, md0(yr,r,m,ioe)) = md0(yr,r,'trn',ioe) / sum(m, md0(yr,r,m,ioe));
margshr(yr,r,'trd',ioe) = 1 - margshr(yr,r,'trn',ioe);

md0(yr,r,m,'col') = margshr(yr,r,m,'col') * sum(demsec, emarg0(yr,r,'col',demsec));
md0(yr,r,m,'cru') = margshr(yr,r,m,'cru') * sum(demsec, emarg0(yr,r,'cru',demsec));
md0(yr,r,m,'gas') = margshr(yr,r,m,'gas') * sum(demsec, emarg0(yr,r,'gas',demsec));
md0(yr,r,m,'oil') = margshr(yr,r,m,'oil') * sum(demsec, emarg0(yr,r,'oil',demsec));
md0(yr,r,m,'ele') = margshr(yr,r,m,'ele') * sum(demsec, emarg0(yr,r,'ele',demsec));

* Compare new and old energy input demands:

PARAMETER enegdem(yr,r,ioe,*);

enegdem(yr,r,ioe,'old') = sum(dg, id0(yr,r,ioe,dg)) + cd0(yr,r,ioe);

* Check on residential energy demands. Electricity demands line up quite
* well.

PARAMETER resechk "Residential energy demand check";

resechk(yr,r,ioe,'old') = cd0(yr,r,ioe);
cd0(yr,r,ioe) = sum(mapioe(ioe,e), ed0(yr,r,e,'res'));
resechk(yr,r,ioe,'new') = cd0(yr,r,ioe);

* Adjust supply totals. The District of Columbia is a strange case. In 2014,
* there are no generation statistics from electric utilities, but independent
* power did produce electricity per EIA.

PARAMETER chkele;
chkele(r,'old') = ys0('2016',r,'ele','ele');
chkele(r,'new') = elegen(r,'total','2016') * ps0('2016','ele') / 1e4;
DISPLAY chkele;

ys0(yr,r,'ele','ele') = elegen(r,'total',yr) * ps0(yr,'ele') / 1e4;
ys0(yr,r,'cru','cru') = sedsenergy(r,'q','cru','supply',yr)*ps0(yr,'cru') / 1e4;
ys0(yr,r,'gas','gas') = sedsenergy(r,'q','gas','supply',yr)*ps0(yr,'gas') / 1e4;
ys0(yr,r,'col','col') = sedsenergy(r,'q','col','supply',yr)*ps0(yr,'col') / 1e4;
ys0(yr,r,'oil','oil') = sedsenergy(r,'q','cru','ref',yr)/sum(r.local,sedsenergy(r,'q','cru','ref',yr)) *
	sum((demsec,r.local),ned0(yr,r,'oil',demsec));

* Share out input demands for production:

PARAMETER inpshrs(yr,r,*,demsec,*) "Shares of input demand by sector";
PARAMETER inpchk(yr,r,*,*) "Check on energy input demand";

inpshrs(yr,r,ioe,demsec,ds)$(sum(ds.local$mapdems(ds,demsec), id0(yr,r,ioe,ds)) AND mapdems(ds,demsec) AND pctgen(yr,r,ioe,demsec)>1) =
		id0(yr,r,ioe,ds) / sum(ds.local$mapdems(ds,demsec), id0(yr,r,ioe,ds));

* If input shares do not exist for the aggregate demsec category, use national
* average, subject to multiple caveats:


inpshrs(yr,r,ioe,demsec,ds)$(
    sum(ds.local,inpshrs(yr,r,ioe,demsec,ds)) = 0 AND
    ys0(yr,r,ds,ds) <> 0 AND
    pctgen(yr,r,ioe,demsec) > 1 AND
    mapdems(ds,demsec) AND
    sum(mapioe(ioe,e),ed0(yr,r,e,demsec)) AND
    sum((r.local,ds.local)$mapdems(ds,demsec), id0(yr,r,ioe,ds))) =
    sum(r.local, id0(yr,r,ioe,ds)) / sum((r.local,ds.local)$mapdems(ds,demsec), id0(yr,r,ioe,ds));

inpchk(yr,r,ds,'old') = sum(ioe, id0(yr,r,ioe,ds));
id0(yr,r,ioe,ds) = sum(demsec, inpshrs(yr,r,ioe,demsec,ds) * sum(mapioe(ioe,e), ed0(yr,r,e,demsec)));
inpchk(yr,r,ds,'new') = sum(ioe, id0(yr,r,ioe,ds));

* Zero out production and allocation accounts without generation totals:

ys0(yr,r,'ele',g)$(elegen(r,'total',yr) * ps0(yr,'ele') = 0) = 0;
ld0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
kd0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
ty0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
id0(yr,r,dg,'ele')$(sum(ds, ys0(yr,r,'ele',ds)) = 0) = 0;
s0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
xd0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
xn0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
x0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
rx0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;

enegdem(yr,r,ioe,'new') = sum(dg, id0(yr,r,ioe,dg)) + cd0(yr,r,ioe);
DISPLAY enegdem;

* -------------------------------------------------------------------
* Include emissions data:
* -------------------------------------------------------------------

PARAMETER co2emiss "Carbon content of energy demands (mill. metric tonnes)";
PARAMETER btus "BTU totals (quadrillions)";
PARAMETER usatotalco2	"National totals for carbon emissions (mill. metric tonnes)";

* Scaling to quadrillions of btus (trill btu/ 1e3). Note that 1000kg = 1
* metric tonne. So, quadrillion btus * kg per million btu = billions of
* kgs or millions of metric tonnes.

btus(r,e,demsec) = eq0('%year%',r,e,demsec) / 1e3;
co2emiss(r,ioe,demsec) = sum(mapioe(ioe,e), co2perbtu_units(e,'kilograms CO2 per million btu') * btus(r,e,demsec));

usatotalco2(demsec,'tonnes') = sum((r,ioe), co2emiss(r,ioe,demsec));
usatotalco2('total','tonnes') = sum((r,ioe,demsec), co2emiss(r,ioe,demsec));
usatotalco2(demsec,'%') = usatotalco2(demsec,'tonnes') / usatotalco2('total','tonnes');

* Sector level disaggregation -- Note that emissions here are calculated
* by sharing out emission totals by category based on energy input use by
* sector.

PARAMETER shrsec(r,ioe,*,demsec) "Share of sector level emisions";
PARAMETER secco2(r,*,*) "Sector level contributions to emissions";
PARAMETER resco2(r,*) "Residential co2 emissions";

shrsec(r,ioe,ds,'ind')$(mapdems(ds,'ind') and sum(ds.local$mapdems(ds,'ind'), id0('%year%',r,ioe,ds))) = id0('%year%',r,ioe,ds) / sum(ds.local$mapdems(ds,'ind'), id0('%year%',r,ioe,ds));
shrsec(r,ioe,ds,'com')$(mapdems(ds,'com') and sum(ds.local$mapdems(ds,'com'), id0('%year%',r,ioe,ds))) = id0('%year%',r,ioe,ds) / sum(ds.local$mapdems(ds,'com'), id0('%year%',r,ioe,ds));
shrsec(r,ioe,ds,'trn')$(mapdems(ds,'trn') and sum(ds.local$mapdems(ds,'trn'), id0('%year%',r,ioe,ds))) = id0('%year%',r,ioe,ds) / sum(ds.local$mapdems(ds,'trn'), id0('%year%',r,ioe,ds));

* Map co2 emissions to aggregate fuel categories:

resco2(r,ioe) = co2emiss(r,ioe,'res');
secco2(r,ioe,ds) = sum(demsec, shrsec(r,ioe,ds,demsec) * co2emiss(r,ioe,demsec));
secco2(r,ioe,'ele') = co2emiss(r,ioe,'ele');
secco2(r,'cru','oil') = co2emiss(r,'cru','ref');

* Are there co2 emissions without associated energy demands? There are when the
* pctgeneration < 1. I do this for numerical reasons if disaggregating the
* electricity sector into composite technologies.

PARAMETER nomatch;
nomatch(r,ioe,ds)$(secco2(r,ioe,ds) and not id0('%year%',r,ioe,ds)) = secco2(r,ioe,ds);
secco2(r,ioe,ds)$nomatch(r,ioe,ds) = 0;

* Recalculate the household adjustment parameter

hhadj(yr,r) = c0(yr,r)
    - sum(ds, ld0(yr,r,ds) + kd0(yr,r,ds) + yh0(yr,r,ds)) - bopdef0(yr,r)
    - sum(ds, ta0(yr,r,ds) * a0(yr,r,ds) + tm0(yr,r,ds)*m0(yr,r,ds) + ty0(yr,r,ds)*sum(dg, ys0(yr,r,ds,dg)))
    + sum(ds, g0(yr,r,ds) + i0(yr,r,ds));


* -------------------------------------------------------------------
* Recalibrate dataset to match totals using LS or Huber method:
* -------------------------------------------------------------------

* Apply a fine filter to the dataset: drop values which are less than .01%
* of the average value across all regions.

PARAMETER trace "Debug check on calculations";
PARAMETER zerotol "Tolerance level" / 5 /;

* Number of elements in each parameter before filter is applied:

trace(yr,ds,'ld0','before') = sum((r)$ld0(yr,r,ds),1);
trace(yr,ds,'kd0','before') = sum((r)$kd0(yr,r,ds),1);
trace(yr,dg,'m0','before') = sum((r)$m0(yr,r,dg),1);
trace(yr,dg,'x0','before') = sum((r)$x0(yr,r,dg),1);
trace(yr,dg,'rx0','before') = sum((r)$rx0(yr,r,dg),1);
trace(yr,dg,'s0','before') = sum((r)$s0(yr,r,dg),1);
trace(yr,dg,'a0','before') = sum((r)$a0(yr,r,dg),1);
trace(yr,dg,'cd0','before') = sum((r)$cd0(yr,r,dg),1);
trace(yr,dg,'yh0','before') = sum((r)$yh0(yr,r,dg),1);
trace(yr,dg,'g0','before') = sum((r)$g0(yr,r,dg),1);
trace(yr,dg,'i0','before') = sum((r)$i0(yr,r,dg),1);
trace(yr,dg,'xn0','before') = sum((r)$xn0(yr,r,dg),1);
trace(yr,dg,'xd0','before') = sum((r)$xd0(yr,r,dg),1);
trace(yr,dg,'dd0','before') = sum((r)$dd0(yr,r,dg),1);
trace(yr,dg,'nd0','before') = sum((r)$nd0(yr,r,dg),1);
trace(yr,ds,'ys0','before') = sum((r,dg)$ys0(yr,r,ds,dg),1);
trace(yr,dg,'id0','before') = sum((r,ds)$id0(yr,r,dg,ds),1);
trace(yr,dg,'md0','before') = sum((r,m)$md0(yr,r,m,dg),1);
trace(yr,dg,'nm0','before') = sum((r,m)$nm0(yr,r,dg,m),1);
trace(yr,dg,'dm0','before') = sum((r,m)$dm0(yr,r,dg,m),1);

* Average value of each parameter:

trace(yr,ds,'ld0','avg')$trace(yr,ds,'ld0','before') = sum((r),ld0(yr,r,ds))/trace(yr,ds,'ld0','before');
trace(yr,ds,'kd0','avg')$trace(yr,ds,'kd0','before') = sum((r),kd0(yr,r,ds))/trace(yr,ds,'kd0','before');
trace(yr,dg,'m0','avg')$trace(yr,dg,'m0','before') = sum((r),m0(yr,r,dg))/trace(yr,dg,'m0','before');
trace(yr,dg,'x0','avg')$trace(yr,dg,'x0','before') = sum((r),x0(yr,r,dg))/trace(yr,dg,'x0','before');
trace(yr,dg,'rx0','avg')$trace(yr,dg,'rx0','before') = sum((r),rx0(yr,r,dg))/trace(yr,dg,'rx0','before');
trace(yr,dg,'s0','avg')$trace(yr,dg,'s0','before') = sum((r),s0(yr,r,dg))/trace(yr,dg,'s0','before');
trace(yr,dg,'a0','avg')$trace(yr,dg,'a0','before') = sum((r),a0(yr,r,dg))/trace(yr,dg,'a0','before');
trace(yr,dg,'cd0','avg')$trace(yr,dg,'cd0','before') = sum((r),cd0(yr,r,dg))/trace(yr,dg,'cd0','before');
trace(yr,dg,'yh0','avg')$trace(yr,dg,'yh0','before') = sum((r),yh0(yr,r,dg))/trace(yr,dg,'yh0','before');
trace(yr,dg,'g0','avg')$trace(yr,dg,'g0','before') = sum((r),g0(yr,r,dg))/trace(yr,dg,'g0','before');
trace(yr,dg,'i0','avg')$trace(yr,dg,'i0','before') = sum((r),i0(yr,r,dg))/trace(yr,dg,'i0','before');
trace(yr,dg,'xn0','avg')$trace(yr,dg,'xn0','before') = sum((r),xn0(yr,r,dg))/trace(yr,dg,'xn0','before');
trace(yr,dg,'xd0','avg')$trace(yr,dg,'xd0','before') = sum((r),xd0(yr,r,dg))/trace(yr,dg,'xd0','before');
trace(yr,dg,'dd0','avg')$trace(yr,dg,'dd0','before') = sum((r),dd0(yr,r,dg))/trace(yr,dg,'dd0','before');
trace(yr,dg,'nd0','avg')$trace(yr,dg,'nd0','before') = sum((r),nd0(yr,r,dg))/trace(yr,dg,'nd0','before');
trace(yr,ds,'ys0','avg')$trace(yr,ds,'ys0','before') = sum((r,dg),ys0(yr,r,ds,dg))/trace(yr,ds,'ys0','before');
trace(yr,dg,'id0','avg')$trace(yr,dg,'id0','before') = sum((r,ds),id0(yr,r,dg,ds))/trace(yr,dg,'id0','before');
trace(yr,dg,'md0','avg')$trace(yr,dg,'md0','before') = sum((r,m),md0(yr,r,m,dg))/trace(yr,dg,'md0','before');
trace(yr,dg,'nm0','avg')$trace(yr,dg,'nm0','before') = sum((r,m),nm0(yr,r,dg,m))/trace(yr,dg,'nm0','before');
trace(yr,dg,'dm0','avg')$trace(yr,dg,'dm0','before') = sum((r,m),dm0(yr,r,dg,m))/trace(yr,dg,'dm0','before');

ld0(yr,r,ds)$(round(ld0(yr,r,ds)/trace(yr,ds,'ld0','avg'),zerotol)=0) = 0;
kd0(yr,r,ds)$(round(kd0(yr,r,ds)/trace(yr,ds,'kd0','avg'),zerotol)=0) = 0;
m0(yr,r,dg)$(round(m0(yr,r,dg)/trace(yr,dg,'m0','avg'),zerotol)=0) = 0;
x0(yr,r,dg)$(round(x0(yr,r,dg)/trace(yr,dg,'x0','avg'),zerotol)=0) = 0;
rx0(yr,r,dg)$(round(rx0(yr,r,dg)/trace(yr,dg,'rx0','avg'),zerotol)=0) = 0;
s0(yr,r,dg)$(round(s0(yr,r,dg)/trace(yr,dg,'s0','avg'),zerotol)=0) = 0;
a0(yr,r,dg)$(round(a0(yr,r,dg)/trace(yr,dg,'a0','avg'),zerotol)=0) = 0;
cd0(yr,r,dg)$(round(cd0(yr,r,dg)/trace(yr,dg,'cd0','avg'),zerotol)=0) = 0;
yh0(yr,r,dg)$(round(yh0(yr,r,dg)/trace(yr,dg,'yh0','avg'),zerotol)=0) = 0;
g0(yr,r,dg)$(round(g0(yr,r,dg)/trace(yr,dg,'g0','avg'),zerotol)=0) = 0;
i0(yr,r,dg)$(round(i0(yr,r,dg)/trace(yr,dg,'i0','avg'),zerotol)=0) = 0;
xn0(yr,r,dg)$(round(xn0(yr,r,dg)/trace(yr,dg,'xn0','avg'),zerotol)=0) = 0;
xd0(yr,r,dg)$(round(xd0(yr,r,dg)/trace(yr,dg,'xd0','avg'),zerotol)=0) = 0;
dd0(yr,r,dg)$(round(dd0(yr,r,dg)/trace(yr,dg,'dd0','avg'),zerotol)=0) = 0;
nd0(yr,r,dg)$(round(nd0(yr,r,dg)/trace(yr,dg,'nd0','avg'),zerotol)=0) = 0;
ys0(yr,r,ds,dg)$(round(ys0(yr,r,ds,dg)/trace(yr,ds,'ys0','avg'),zerotol)=0) = 0;
id0(yr,r,dg,ds)$(round(id0(yr,r,dg,ds)/trace(yr,dg,'id0','avg'),zerotol)=0) = 0;
md0(yr,r,m,dg)$(round(md0(yr,r,m,dg)/trace(yr,dg,'md0','avg'),zerotol)=0) = 0;
nm0(yr,r,dg,m)$(round(nm0(yr,r,dg,m)/trace(yr,dg,'nm0','avg'),zerotol)=0) = 0;
dm0(yr,r,dg,m)$(round(dm0(yr,r,dg,m)/trace(yr,dg,'dm0','avg'),zerotol)=0) = 0;

* Also, drop tiny numbers:

ld0(yr,r,ds)$(not round(ld0(yr,r,ds),7)) = 0;
kd0(yr,r,ds)$(not round(kd0(yr,r,ds),7)) = 0;
m0(yr,r,dg)$(not round(m0(yr,r,dg),7)) = 0;
x0(yr,r,dg)$(not round(x0(yr,r,dg),7)) = 0;
rx0(yr,r,dg)$(not round(rx0(yr,r,dg),7)) = 0;
s0(yr,r,dg)$(not round(s0(yr,r,dg),7)) = 0;
a0(yr,r,dg)$(not round(a0(yr,r,dg),7)) = 0;
cd0(yr,r,dg)$(not round(cd0(yr,r,dg),7)) = 0;
yh0(yr,r,dg)$(not round(yh0(yr,r,dg),7)) = 0;
g0(yr,r,dg)$(not round(g0(yr,r,dg),7)) = 0;
i0(yr,r,dg)$(not round(i0(yr,r,dg),7)) = 0;
xn0(yr,r,dg)$(not round(xn0(yr,r,dg),7)) = 0;
xd0(yr,r,dg)$(not round(xd0(yr,r,dg),7)) = 0;
dd0(yr,r,dg)$(not round(dd0(yr,r,dg),7)) = 0;
nd0(yr,r,dg)$(not round(nd0(yr,r,dg),7)) = 0;
ys0(yr,r,ds,dg)$(not round(ys0(yr,r,ds,dg),7)) = 0;
id0(yr,r,dg,ds)$(not round(id0(yr,r,dg,ds),7)) = 0;
md0(yr,r,m,dg)$(not round(md0(yr,r,m,dg),7)) = 0;
nm0(yr,r,dg,m)$(not round(nm0(yr,r,dg,m),7)) = 0;
dm0(yr,r,dg,m)$(not round(dm0(yr,r,dg,m),7)) = 0;

trace(yr,ds,'ld0','after') = sum((r)$ld0(yr,r,ds),1);
trace(yr,ds,'kd0','after') = sum((r)$kd0(yr,r,ds),1);
trace(yr,dg,'m0','after') = sum((r)$m0(yr,r,dg),1);
trace(yr,dg,'x0','after') = sum((r)$x0(yr,r,dg),1);
trace(yr,dg,'rx0','after') = sum((r)$rx0(yr,r,dg),1);
trace(yr,dg,'s0','after') = sum((r)$s0(yr,r,dg),1);
trace(yr,dg,'a0','after') = sum((r)$a0(yr,r,dg),1);
trace(yr,dg,'cd0','after') = sum((r)$cd0(yr,r,dg),1);
trace(yr,dg,'yh0','after') = sum((r)$yh0(yr,r,dg),1);
trace(yr,dg,'g0','after') = sum((r)$g0(yr,r,dg),1);
trace(yr,dg,'i0','after') = sum((r)$i0(yr,r,dg),1);
trace(yr,dg,'xn0','after') = sum((r)$xn0(yr,r,dg),1);
trace(yr,dg,'xd0','after') = sum((r)$xd0(yr,r,dg),1);
trace(yr,dg,'dd0','after') = sum((r)$dd0(yr,r,dg),1);
trace(yr,dg,'nd0','after') = sum((r)$nd0(yr,r,dg),1);
trace(yr,ds,'ys0','after') = sum((r,dg)$ys0(yr,r,ds,dg),1);
trace(yr,dg,'id0','after') = sum((r,ds)$id0(yr,r,dg,ds),1);
trace(yr,dg,'md0','after') = sum((r,m)$md0(yr,r,m,dg),1);
trace(yr,dg,'nm0','after') = sum((r,m)$nm0(yr,r,dg,m),1);
trace(yr,dg,'dm0','after') = sum((r,m)$dm0(yr,r,dg,m),1);

* Check on the number of lost parameter values:

ALIAS(pm,*);
PARAMETER zeroed "Number of zeroed elements in filter";

zeroed(yr,'before')$(NOT SAMEAS(yr,'2015')) = sum((pm,dg), trace(yr,dg,pm,'before'));
zeroed(yr,'after')$(NOT SAMEAS(yr,'2015')) = sum((pm,dg), trace(yr,dg,pm,'after'));
zeroed(yr,'diff') = zeroed(yr,'before') - zeroed(yr,'after');

* -------------------------------------------------------------------------
* Write a re-calibration routine which minimally shifts data to maintain
* micro-consistency.
* -------------------------------------------------------------------------

SET mat "Select parameters for huber objective" / ys0,id0 /;

SET nonzero(mat,r,*,*) "Nonzeros in the reference data";
SET zeros(mat,r,*,*) "Zeros in the reference data";

PARAMETER zeropenalty "Penalty for imposing non-zero elements" / 1e7 /;

SET eneg(s) Energy sectors in national data / cng, ele, oil, col /;


POSITIVE VARIABLE YS "Production variable";
POSITIVE VARIABLE ID "Production variable";
POSITIVE VARIABLE LD "Production variable";
POSITIVE VARIABLE KD "Production variable";

POSITIVE VARIABLE ARM "Trade variable";
POSITIVE VARIABLE ND "Trade variable";
POSITIVE VARIABLE DD "Trade variable";
POSITIVE VARIABLE IMP "Trade variable";

POSITIVE VARIABLE SUP "Supply variable";
POSITIVE VARIABLE XD "Supply variable";
POSITIVE VARIABLE XN "Supply variable";
POSITIVE VARIABLE XPT "Supply variable";
POSITIVE VARIABLE RX "Supply variable";

POSITIVE VARIABLE NM "Margin variable";
POSITIVE VARIABLE DM "Margin variable";
POSITIVE VARIABLE MARD "Margin variable";

POSITIVE VARIABLE YH "Demand variable";
POSITIVE VARIABLE CD "Demand variable";
POSITIVE VARIABLE INV "Demand variable";
POSITIVE VARIABLE GD "Demand variable";

POSITIVE VARIABLE X1 "Percentage deviations";
POSITIVE VARIABLE X2 "Percentage deviations";
POSITIVE VARIABLE X3 "Percentage deviations";

VARIABLE OBJ "Objective variable";
VARIABLE BOP(r) "Balance of payments";

EQUATION obj_ls "Least squares objective definition";
EQUATION obj_huber "Hybrid huber objective definition";

EQUATION zp_y "Zero profit conditions";
EQUATION zp_a "Zero profit conditions";
EQUATION zp_x "Zero profit conditions";
EQUATION zp_ms "Zero profit conditions";
EQUATION zp_c "Zero profit conditions";

EQUATION lvshr "Value share condition";
EQUATION kvshr "Value share condition";

EQUATION mc_py "Market Clearance Conditions";
EQUATION mc_pa "Market Clearance Conditions";
EQUATION mc_pn "Market Clearance Conditions";
EQUATION mc_pfx "Market Clearance Conditions";
EQUATION mc_pm "Market Clearance Conditions";
EQUATION mc_pfx "Market Clearance Conditions";
EQUATION mc_pd "Market Clearance Conditions";

EQUATION incbal "Income balance";

EQUATION expdef "Gross exports must be greater than re-exports";

EQUATION netgenbalpos1 "Net generation of electricity balancing";
EQUATION netgenbalpos2 "Net generation of electricity balancing";
EQUATION netgenbalneg1 "Net generation of electricity balancing";
EQUATION netgenbalneg2 "Net generation of electricity balancing";

EQUATION natys0 "Verify regional totals eq national totals";
EQUATION natm0 "Verify regional totals eq national totals";
EQUATION natx0 "Verify regional totals eq national totals";
EQUATION natva "Verify regional totals eq national totals";
EQUATION nati0 "Verify regional totals eq national totals";
EQUATION natg0 "Verify regional totals eq national totals";
EQUATION natc0 "Verify regional totals eq national totals";


EQUATION x2def "Huber constraints";
EQUATION x3def "Huber constraints";


PARAMETER ys0loop;
PARAMETER id0loop;
PARAMETER ld0loop;
PARAMETER kd0loop;
PARAMETER ty;
PARAMETER ta;
PARAMETER a0loop;
PARAMETER nd0loop;
PARAMETER dd0loop;
PARAMETER tm;
PARAMETER m0loop;
PARAMETER s0loop;
PARAMETER xd0loop;
PARAMETER xn0loop;
PARAMETER x0loop;
PARAMETER rx0loop;
PARAMETER nm0loop;
PARAMETER dm0loop;
PARAMETER md0loop;
PARAMETER cd0loop;
PARAMETER c0loop;
PARAMETER g0loop;
PARAMETER i0loop;
PARAMETER yh0loop;
PARAMETER bopdef0loop;
PARAMETER hhadjloop;
PARAMETER netgenloop;
PARAMETER nat_ys;
PARAMETER nat_m;
PARAMETER nat_x;
PARAMETER nat_va;
PARAMETER nat_i;
PARAMETER nat_g;
PARAMETER nat_c;
PARAMETER edloop;
PARAMETER fvsloop;

* Huber method: additional parameters needed if using Huber's matrix
* balancing routine:

PARAMETER v0(mat,r,*,*) "matrix values";

PARAMETER gammab "Lower bound cross-over tolerance" / 0.5 /;
PARAMETER thetab "Upper bound cross-over tolerance" / 0.25 /;

$MACRO	MV(mat,r,ds,dg) (YS(r,ds,dg)$SAMEAS(mat,'ys0') + ID(r,ds,dg)$SAMEAS(mat,'id0'))

x2def(nonzero(mat,r,ds,dg))..   X2(mat,r,ds,dg) + X1(mat,r,ds,dg) =G= (MV(mat,r,ds,dg)/v0(mat,r,ds,dg)-1);
x3def(nonzero(mat,r,ds,dg))..   X3(mat,r,ds,dg) - X2(mat,r,ds,dg) =G= (1-MV(mat,r,ds,dg)/v0(mat,r,ds,dg));

obj_huber..  OBJ =E= 	sum(nonzero(mat,r,ds,dg), abs(v0(mat,r,ds,dg)) *
	                (sqr(X2(mat,r,ds,dg)) + 2*thetab*X1(mat,r,ds,dg) -
			2*gammab*(1-gammab)*log(1-gammab-X3(mat,r,ds,dg)))) +

			sum((r,ds)$ld0loop(r,ds), abs(ld0loop(r,ds)) * sqr(LD(r,ds) / ld0loop(r,ds) - 1)) +
			sum((r,ds)$kd0loop(r,ds), abs(kd0loop(r,ds)) * sqr(KD(r,ds) / kd0loop(r,ds) - 1)) +
			sum((r,dg)$a0loop(r,dg), abs(a0loop(r,dg)) * sqr(ARM(r,dg) / a0loop(r,dg) - 1)) +
			sum((r,dg)$nd0loop(r,dg), abs(nd0loop(r,dg)) * sqr(ND(r,dg) / nd0loop(r,dg) - 1)) +
			sum((r,dg)$dd0loop(r,dg), abs(dd0loop(r,dg)) * sqr(DD(r,dg) / dd0loop(r,dg) - 1)) +
			sum((r,dg)$m0loop(r,dg), abs(m0loop(r,dg)) * sqr(IMP(r,dg) / m0loop(r,dg) - 1)) +
			sum((r,dg)$s0loop(r,dg), abs(s0loop(r,dg)) * sqr(SUP(r,dg) / s0loop(r,dg) - 1)) +
			sum((r,dg)$xd0loop(r,dg), abs(xd0loop(r,dg)) * sqr(XD(r,dg) / xd0loop(r,dg) - 1)) +
			sum((r,dg)$xn0loop(r,dg), abs(xn0loop(r,dg)) * sqr(XN(r,dg) / xn0loop(r,dg) - 1)) +
			sum((r,dg)$x0loop(r,dg), abs(x0loop(r,dg)) * sqr(XPT(r,dg) / x0loop(r,dg) - 1)) +
			sum((r,dg)$rx0loop(r,dg), abs(rx0loop(r,dg)) * sqr(RX(r,dg) / rx0loop(r,dg) - 1)) +
			sum((r,m,dg)$nm0loop(r,dg,m), abs(nm0loop(r,dg,m)) * sqr(NM(r,dg,m) / nm0loop(r,dg,m) - 1)) +
			sum((r,m,dg)$dm0loop(r,dg,m), abs(dm0loop(r,dg,m)) * sqr(DM(r,dg,m) / dm0loop(r,dg,m) - 1)) +
			sum((r,m,dg)$md0loop(r,m,dg), abs(md0loop(r,m,dg)) * sqr(MARD(r,m,dg) / md0loop(r,m,dg) - 1)) +
			sum((r,dg)$yh0loop(r,dg), abs(yh0loop(r,dg)) * sqr(YH(r,dg) / yh0loop(r,dg) - 1)) +
			sum((r,dg)$cd0loop(r,dg), abs(cd0loop(r,dg)) * sqr(CD(r,dg) / cd0loop(r,dg) - 1)) +
			sum((r,dg)$i0loop(r,dg), abs(i0loop(r,dg)) * sqr(INV(r,dg) / i0loop(r,dg) - 1)) +
			sum((r,dg)$g0loop(r,dg), abs(g0loop(r,dg)) * sqr(GD(r,dg) / g0loop(r,dg) - 1)) +
			sum((r)$bopdef0loop(r), abs(bopdef0loop(r)) * sqr(BOP(r) / bopdef0loop(r) - 1)) +
		zeropenalty * (
			sum((r,ds,dg)$(not ys0loop(r,ds,dg)), YS(r,ds,dg)) +
			sum((r,dg,ds)$(not id0loop(r,dg,ds)), ID(r,dg,ds)) +
			sum((r,ds)$(not ld0loop(r,ds)), LD(r,ds)) +
			sum((r,ds)$(not kd0loop(r,ds)), KD(r,ds)) +
			sum((r,dg)$(not a0loop(r,dg)), ARM(r,dg)) +
			sum((r,dg)$(not nd0loop(r,dg)), ND(r,dg)) +
			sum((r,dg)$(not dd0loop(r,dg)), DD(r,dg)) +
			sum((r,dg)$(not m0loop(r,dg)), IMP(r,dg)) +
			sum((r,dg)$(not s0loop(r,dg)), SUP(r,dg)) +
			sum((r,dg)$(not xd0loop(r,dg)), XD(r,dg)) +
			sum((r,dg)$(not xn0loop(r,dg)), XN(r,dg)) +
			sum((r,dg)$(not x0loop(r,dg)), XPT(r,dg)) +
			sum((r,dg)$(not rx0loop(r,dg)), RX(r,dg)) +
			sum((r,m,dg)$(not nm0loop(r,dg,m)), NM(r,dg,m)) +
			sum((r,m,dg)$(not dm0loop(r,dg,m)), DM(r,dg,m)) +
			sum((r,m,dg)$(not md0loop(r,m,dg)), MARD(r,m,dg)) +
			sum((r,dg)$(not yh0loop(r,dg)), YH(r,dg)) +
			sum((r,dg)$(not cd0loop(r,dg)), CD(r,dg)) +
			sum((r,dg)$(not i0loop(r,dg)), INV(r,dg)) +
			sum((r,dg)$(not g0loop(r,dg)), GD(r,dg)));

* Least squares:

obj_ls..	OBJ =E= sum((r,ds,dg)$ys0loop(r,ds,dg), abs(ys0loop(r,ds,dg)) * sqr(YS(r,ds,dg) / ys0loop(r,ds,dg) - 1)) +
			sum((r,dg,ds)$id0loop(r,dg,ds), abs(id0loop(r,dg,ds)) * sqr(ID(r,dg,ds) / id0loop(r,dg,ds) - 1)) +
			sum((r,ds)$ld0loop(r,ds), abs(ld0loop(r,ds)) * sqr(LD(r,ds) / ld0loop(r,ds) - 1)) +
			sum((r,ds)$kd0loop(r,ds), abs(kd0loop(r,ds)) * sqr(KD(r,ds) / kd0loop(r,ds) - 1)) +
			sum((r,dg)$a0loop(r,dg), abs(a0loop(r,dg)) * sqr(ARM(r,dg) / a0loop(r,dg) - 1)) +
			sum((r,dg)$nd0loop(r,dg), abs(nd0loop(r,dg)) * sqr(ND(r,dg) / nd0loop(r,dg) - 1)) +
			sum((r,dg)$dd0loop(r,dg), abs(dd0loop(r,dg)) * sqr(DD(r,dg) / dd0loop(r,dg) - 1)) +
			sum((r,dg)$m0loop(r,dg), abs(m0loop(r,dg)) * sqr(IMP(r,dg) / m0loop(r,dg) - 1)) +
			sum((r,dg)$s0loop(r,dg), abs(s0loop(r,dg)) * sqr(SUP(r,dg) / s0loop(r,dg) - 1)) +
			sum((r,dg)$xd0loop(r,dg), abs(xd0loop(r,dg)) * sqr(XD(r,dg) / xd0loop(r,dg) - 1)) +
			sum((r,dg)$xn0loop(r,dg), abs(xn0loop(r,dg)) * sqr(XN(r,dg) / xn0loop(r,dg) - 1)) +
			sum((r,dg)$x0loop(r,dg), abs(x0loop(r,dg)) * sqr(XPT(r,dg) / x0loop(r,dg) - 1)) +
			sum((r,dg)$rx0loop(r,dg), abs(rx0loop(r,dg)) * sqr(RX(r,dg) / rx0loop(r,dg) - 1)) +
			sum((r,m,dg)$nm0loop(r,dg,m), abs(nm0loop(r,dg,m)) * sqr(NM(r,dg,m) / nm0loop(r,dg,m) - 1)) +
			sum((r,m,dg)$dm0loop(r,dg,m), abs(dm0loop(r,dg,m)) * sqr(DM(r,dg,m) / dm0loop(r,dg,m) - 1)) +
			sum((r,m,dg)$md0loop(r,m,dg), abs(md0loop(r,m,dg)) * sqr(MARD(r,m,dg) / md0loop(r,m,dg) - 1)) +
			sum((r,dg)$yh0loop(r,dg), abs(yh0loop(r,dg)) * sqr(YH(r,dg) / yh0loop(r,dg) - 1)) +
			sum((r,dg)$cd0loop(r,dg), abs(cd0loop(r,dg)) * sqr(CD(r,dg) / cd0loop(r,dg) - 1)) +
			sum((r,dg)$i0loop(r,dg), abs(i0loop(r,dg)) * sqr(INV(r,dg) / i0loop(r,dg) - 1)) +
			sum((r,dg)$g0loop(r,dg), abs(g0loop(r,dg)) * sqr(GD(r,dg) / g0loop(r,dg) - 1)) +
			sum((r)$bopdef0loop(r), abs(bopdef0loop(r)) * sqr(BOP(r) / bopdef0loop(r) - 1)) +
		zeropenalty * (
			sum((r,ds,dg)$(not ys0loop(r,ds,dg)), YS(r,ds,dg)) +
			sum((r,dg,ds)$(not id0loop(r,dg,ds)), ID(r,dg,ds)) +
			sum((r,ds)$(not ld0loop(r,ds)), LD(r,ds)) +
			sum((r,ds)$(not kd0loop(r,ds)), KD(r,ds)) +
			sum((r,dg)$(not a0loop(r,dg)), ARM(r,dg)) +
			sum((r,dg)$(not nd0loop(r,dg)), ND(r,dg)) +
			sum((r,dg)$(not dd0loop(r,dg)), DD(r,dg)) +
			sum((r,dg)$(not m0loop(r,dg)), IMP(r,dg)) +
			sum((r,dg)$(not s0loop(r,dg)), SUP(r,dg)) +
			sum((r,dg)$(not xd0loop(r,dg)), XD(r,dg)) +
			sum((r,dg)$(not xn0loop(r,dg)), XN(r,dg)) +
			sum((r,dg)$(not x0loop(r,dg)), XPT(r,dg)) +
			sum((r,dg)$(not rx0loop(r,dg)), RX(r,dg)) +
			sum((r,m,dg)$(not nm0loop(r,dg,m)), NM(r,dg,m)) +
			sum((r,m,dg)$(not dm0loop(r,dg,m)), DM(r,dg,m)) +
			sum((r,m,dg)$(not md0loop(r,m,dg)), MARD(r,m,dg)) +
			sum((r,dg)$(not yh0loop(r,dg)), YH(r,dg)) +
			sum((r,dg)$(not cd0loop(r,dg)), CD(r,dg)) +
			sum((r,dg)$(not i0loop(r,dg)), INV(r,dg)) +
			sum((r,dg)$(not g0loop(r,dg)), GD(r,dg)));

zp_y(r,ds)..	(1-ty(r,ds)) * sum(dg, YS(r,ds,dg)) =E= sum(dg, ID(r,dg,ds)) + LD(r,ds) + KD(r,ds);
zp_a(r,dg)..	(1-ta(r,dg)) * ARM(r,dg) + RX(r,dg) =E= ND(r,dg) + DD(r,dg) + (1+tm(r,dg)) * IMP(r,dg) + sum(m, MARD(r,m,dg));
zp_x(r,dg)..	SUP(r,dg) + RX(r,dg) =E= XPT(r,dg) + XN(r,dg) + XD(r,dg);
zp_ms(r,m)..	sum(ds, NM(r,ds,m) + DM(r,ds,m)) =E= sum(dg, MARD(r,m,dg));

lvshr(r,ds)..	LD(r,ds) =G= 0.5 * fvsloop(r,ds,'lab') * sum(dg, YS(r,ds,dg));
kvshr(r,ds)..	KD(r,ds) =G= 0.5 * fvsloop(r,ds,'cap') * sum(dg, YS(r,ds,dg));

mc_py(r,dg)..	sum(ds, YS(r,ds,dg)) + YH(r,dg) =E= SUP(r,dg);
mc_pa(r,dg)..	ARM(r,dg) =E= sum(ds, ID(r,dg,ds)) + CD(r,dg) + GD(r,dg) + INV(r,dg);
mc_pd(r,dg)..	XD(r,dg) =E= sum(m, DM(r,dg,m)) + DD(r,dg);
mc_pn(dg)..	sum(r, XN(r,dg)) =E= sum((r,m), NM(r,dg,m)) + sum(r, ND(r,dg));
mc_pfx..	sum(r, BOP(r) + hhadjloop(r)) + sum((r,dg), XPT(r,dg)) =E= sum((r,dg), IMP(r,dg));

expdef(r,dg)..	XPT(r,dg) =G= RX(r,dg);

incbal(r)..	sum(dg, CD(r,dg) + GD(r,dg) + INV(r,dg)) =E=
		sum(dg, YH(r,dg)) + BOP(r) + hhadjloop(r) + sum(ds, LD(r,ds) + KD(r,ds)) +
		sum(dg, ta(r,dg)*ARM(r,dg) + tm(r,dg)*IMP(r,dg)) + sum(ds, ty(r,ds)*sum(dg, YS(r,ds,dg)));

* Impose net generation constraints on national electricity trade if calibrating
* to SEDS data:

netgenbalpos1(r)$(netgenloop(r)>0)..	ND(r,'ele') - XN(r,'ele') =G= 0.8 * netgenloop(r);

netgenbalpos2(r)$(netgenloop(r)>0)..	ND(r,'ele') - XN(r,'ele') =L= 1.2 * netgenloop(r);

netgenbalneg1(r)$(netgenloop(r)<0)..	ND(r,'ele') - XN(r,'ele') =L= 0.8 * netgenloop(r);

netgenbalneg2(r)$(netgenloop(r)<0)..	ND(r,'ele') - XN(r,'ele') =G= 1.2 * netgenloop(r);

* Verify regional parameters sum to national totals (for years other than
* 2015) for key parameters of non-energy sectors. SEDS data is used for
* energy totals.

natys0(s)$(not eneg(s))..	sum((r,dg), YS(r,s,dg)) =E= sum(g, nat_ys(s,g));

natx0(s)$(not eneg(s))..	sum(r, XPT(r,s)) =E= nat_x(s);

natm0(s)$(not eneg(s))..	sum(r, IMP(r,s)) =E= nat_m(s);

natva(s)$(not eneg(s))..	sum(r, LD(r,s) + KD(r,s)) =E= nat_va(s);

natg0(s)$(not eneg(s))..	sum(r, GD(r,s)) =E= nat_g(s);

nati0(s)$(not eneg(s))..	sum(r, INV(r,s)) =E= nat_i(s);

natc0(s)$(not eneg(s))..	sum(r, CD(r,s)) =E= nat_c(s);

$IF %matbal% == huber model regcalib /obj_huber, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, netgenbalpos1, netgenbalpos2, netgenbalneg1, netgenbalneg2, natx0, natm0, natva, natg0, nati0, natc0, lvshr, kvshr /;

$IF %matbal% == ls model regcalib /obj_ls, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, netgenbalpos1, netgenbalpos2, netgenbalneg1, netgenbalneg2, natx0, natm0, natva, natg0, nati0, natc0, lvshr, kvshr /;


* We could alternatively produce data for all years:
* loop(yr$(NOT SAMEAS(yr,'2015')),

loop(yr$(SAMEAS(yr,'%year%')),

* Define looping data:

fvsloop(r,ds,'lab') = fvs(yr,r,ds,'lab');
fvsloop(r,ds,'cap') = fvs(yr,r,ds,'cap');
ys0loop(r,ds,dg) = ys0(yr,r,ds,dg);
id0loop(r,dg,ds) = id0(yr,r,dg,ds);
ld0loop(r,dg) = ld0(yr,r,dg);
kd0loop(r,dg) = kd0(yr,r,dg);
ty(r,ds) = ty0(yr,r,ds);
a0loop(r,dg) = a0(yr,r,dg);
nd0loop(r,dg) = nd0(yr,r,dg);
dd0loop(r,dg) = dd0(yr,r,dg);
m0loop(r,dg) = m0(yr,r,dg);
s0loop(r,dg) = s0(yr,r,dg);
x0loop(r,dg) = x0(yr,r,dg);
xn0loop(r,dg) = xn0(yr,r,dg);
xd0loop(r,dg) = xd0(yr,r,dg);
rx0loop(r,dg) = rx0(yr,r,dg);
md0loop(r,m,dg) = md0(yr,r,m,dg);
nm0loop(r,dg,m) = nm0(yr,r,dg,m);
dm0loop(r,dg,m) = dm0(yr,r,dg,m);
yh0loop(r,dg) = yh0(yr,r,dg);
cd0loop(r,dg) = cd0(yr,r,dg);
i0loop(r,dg) = i0(yr,r,dg);
g0loop(r,dg) = g0(yr,r,dg);
bopdef0loop(r) = bopdef0(yr,r);
hhadjloop(r) = hhadj(yr,r);
ta(r,dg) = ta0(yr,r,dg);
tm(r,dg) = tm0(yr,r,dg);
netgenloop(r) = netgen(r,yr,'seds');
edloop(r,e,demsec) = ed0(yr,r,e,demsec);
nat_ys(s,g) = ys0nat(yr,s,g);
nat_x(s) = x0nat(yr,s);
nat_m(s) = m0nat(yr,s);
nat_va(s) = va0nat(yr,s);
nat_g(s) = g0nat(yr,s);
nat_i(s) = i0nat(yr,s);
nat_c(s) = cd0nat(yr,s);

$IF %matbal% == huber v0('ys0',r,ds,dg) = ys0loop(r,ds,dg);
$IF %matbal% == huber v0('id0',r,ds,dg) = id0loop(r,ds,dg);
$IF %matbal% == huber nonzero(mat,r,ds,dg) = yes$v0(mat,r,ds,dg);
$IF %matbal% == huber zeros(mat,r,ds,dg) = yes$(not v0(mat,r,ds,dg));
$IF %matbal% == huber X1.FX(zeros) = 0;
$IF %matbal% == huber X2.FX(zeros) = 0;
$IF %matbal% == huber X3.FX(zeros) = 0;
$IF %matbal% == huber X2.UP(nonzero) = thetab;
$IF %matbal% == huber X2.LO(nonzero) = -gammab;
$IF %matbal% == huber X3.UP(nonzero) = 1-gammab-1e-5;
$IF %matbal% == huber X3.LO(nonzero) = 0;
$IF %matbal% == huber X1.L(nonzero) = 0;
$IF %matbal% == huber X2.L(nonzero) = 0;
$IF %matbal% == huber X3.L(nonzero) = 0;

* Set starting values for balancing routine:

YS.L(r,ds,dg) = ys0loop(r,ds,dg);
ID.L(r,dg,ds) = id0loop(r,dg,ds);
LD.L(r,ds) = ld0loop(r,ds);
KD.L(r,ds) = kd0loop(r,ds);
ARM.L(r,dg) = a0loop(r,dg);
ND.L(r,dg) = nd0loop(r,dg);
DD.L(r,dg) = dd0loop(r,dg);
IMP.L(r,dg) = m0loop(r,dg);
SUP.L(r,dg) = s0loop(r,dg);
XD.L(r,dg) = xd0loop(r,dg);
XN.L(r,dg) = xn0loop(r,dg);
XPT.L(r,dg) = x0loop(r,dg);
RX.L(r,dg) = rx0loop(r,dg);
NM.L(r,dg,m) = nm0loop(r,dg,m);
DM.L(r,dg,m) = dm0loop(r,dg,m);
MARD.L(r,m,dg) = md0loop(r,m,dg);
YH.L(r,dg) = yh0loop(r,dg);
CD.L(r,dg) = cd0loop(r,dg);
INV.L(r,dg) = i0loop(r,dg);
GD.L(r,dg) = g0loop(r,dg);
BOP.L(r) = bopdef0loop(r);

* Set lower bounds on all variables:

YS.LO(r,ds,dg) = 0.25 * ys0loop(r,ds,dg);
ID.LO(r,dg,ds) = 0.25 * id0loop(r,dg,ds);
ARM.LO(r,dg) = 0.25 * a0loop(r,dg);
ND.LO(r,dg) = 0.25 * nd0loop(r,dg);
DD.LO(r,dg) = 0.25 * dd0loop(r,dg);
IMP.LO(r,dg) = 0.25 * m0loop(r,dg);
SUP.LO(r,dg) = 0.25 * s0loop(r,dg);
XD.LO(r,dg) = 0.25 * xd0loop(r,dg);
XN.LO(r,dg) = 0.25 * xn0loop(r,dg);
XPT.LO(r,dg) = 0.25 * x0loop(r,dg);
RX.LO(r,dg) = 0.25 * rx0loop(r,dg);
NM.LO(r,dg,m) = 0.25 * nm0loop(r,dg,m);
DM.LO(r,dg,m) = 0.25 * dm0loop(r,dg,m);
MARD.LO(r,m,dg) = 0.25 * md0loop(r,m,dg);
INV.LO(r,dg) = 0.25 * i0loop(r,dg);
INV.UP(r,dg) = 1.75 * i0loop(r,dg);
GD.LO(r,dg) = 0.25 * g0loop(r,dg);

* Impose some zero restrictions:

RX.FX(r,dg)$(rx0loop(r,dg) = 0) = 0;
MARD.FX(r,m,dg)$(md0loop(r,m,dg) = 0) = 0;
NM.FX(r,ds,m)$(nm0loop(r,ds,m) = 0) = 0;
DM.FX(r,ds,m)$(dm0loop(r,ds,m) = 0) = 0;
YH.FX(r,dg)$(yh0loop(r,dg) = 0) = 0;

* Foreign electricity imports and exports are set to zero subject to SEDS
* data:

XPT.FX(r,'ele')$(x0loop(r,'ele') = 0) = 0;
IMP.FX(r,'ele')$(m0loop(r,'ele') = 0) = 0;
XPT.LO(r,'ele')$(x0loop(r,'ele') > 0) = 0.75 * x0loop(r,'ele');
IMP.LO(r,'ele')$(m0loop(r,'ele') > 0) = 0.75 * m0loop(r,'ele');

* Fix electricity imports from the national market for Alaska and Hawaii
* to zero:

ND.FX(r,'ele')$(SAMEAS(r,'HI') or SAMEAS(r,'AK')) = 0;
XN.FX(r,'ele')$(SAMEAS(r,'HI') or SAMEAS(r,'AK')) = 0;

* Provide an allowable range on how SEDS data can shift:

YS.LO(r,ioe,ioe) = 0.75 * ys0loop(r,ioe,ioe);
YS.UP(r,ioe,ioe) = 1.25 * ys0loop(r,ioe,ioe);
YS.FX(r,ioe,dg)$(ys0loop(r,ioe,dg) = 0) = 0;
ID.FX(r,dg,ioe)$(id0loop(r,dg,ioe) = 0) = 0;

MARD.LO(r,m,ioe) = 0.75 * md0loop(r,m,ioe);
MARD.UP(r,m,ioe) = 1.25 * md0loop(r,m,ioe);
CD.LO(r,ioe) = 0.75 * cd0loop(r,ioe);
CD.UP(r,ioe) = 1.25 * cd0loop(r,ioe);
ID.LO(r,ioe,dg) = 0.75 * id0loop(r,ioe,dg);
ID.UP(r,ioe,dg) = 1.25 * id0loop(r,ioe,dg);


* Solve the iteration of the calibration procedure:

$IFTHENI.a1 "%matbal%" == 'huber'
$IFTHENI.a2 "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_nlp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.a2

SOLVE regcalib using NLP minimizing OBJ;
$ENDIF.a1



$IFTHENI.b1 "%matbal%" == 'ls'
$IFTHENI.b2 "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_qcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.b2

SOLVE regcalib using QCP minimizing OBJ;
$ENDIF.b1




ABORT$(regcalib.modelstat > 1) "Optimal solution not found.";

* Reset parameter values:

ys0(yr,r,ds,dg) = YS.L(r,ds,dg);
id0(yr,r,dg,ds) = ID.L(r,dg,ds);
ld0(yr,r,ds) = LD.L(r,ds);
kd0(yr,r,ds) = KD.L(r,ds);
a0(yr,r,dg) = ARM.L(r,dg);
nd0(yr,r,dg) = ND.L(r,dg);
dd0(yr,r,dg) = DD.L(r,dg);
m0(yr,r,dg) = IMP.L(r,dg);
s0(yr,r,dg) = SUP.L(r,dg);
xd0(yr,r,dg) = XD.L(r,dg);
xn0(yr,r,dg) = XN.L(r,dg);
x0(yr,r,dg) = XPT.L(r,dg);
rx0(yr,r,dg) = RX.L(r,dg);
nm0(yr,r,dg,m) = NM.L(r,dg,m);
dm0(yr,r,dg,m) = DM.L(r,dg,m);
md0(yr,r,m,dg) = MARD.L(r,m,dg);
yh0(yr,r,dg) = YH.L(r,dg);
cd0(yr,r,dg) = CD.L(r,dg);
i0(yr,r,dg) = INV.L(r,dg);
g0(yr,r,dg) = GD.L(r,dg);
bopdef0(yr,r) = BOP.L(r);

* Reset variables boundaries:

RX.LO(r,dg) = 0;
RX.UP(r,dg) = inf;
XPT.LO(r,'ele') = 0;
XPT.UP(r,'ele') = inf;
IMP.LO(r,'ele') = 0;
IMP.UP(r,'ele') = inf;
ND.LO(r,'ele') = 0;
ND.UP(r,'ele') = inf;
XN.LO(r,'ele') = 0;
XN.UP(r,'ele') = inf;
YS.LO(r,ds,dg) = 0;
YS.UP(r,ds,dg) = inf;
MARD.LO(r,m,dg) = 0;
MARD.UP(r,m,dg) = inf;
CD.LO(r,dg) = 0;
CD.UP(r,dg) = inf;
ID.LO(r,dg,ds) = 0;
ID.UP(r,dg,ds) = inf;

);

ys0loop(r,ds,dg) = YS.L(r,ds,dg);
id0loop(r,dg,ds) = ID.L(r,dg,ds);
ld0loop(r,ds) = LD.L(r,ds);
kd0loop(r,ds) = KD.L(r,ds);
ty(r,dg) = ty0('%year%',r,dg);
a0loop(r,dg) = ARM.L(r,dg);
nd0loop(r,dg) = ND.L(r,dg);
dd0loop(r,dg) = DD.L(r,dg);
m0loop(r,dg) = IMP.L(r,dg);
s0loop(r,dg) = SUP.L(r,dg);
xd0loop(r,dg) = XD.L(r,dg);
xn0loop(r,dg) = XN.L(r,dg);
x0loop(r,dg) = XPT.L(r,dg);
rx0loop(r,dg) = RX.L(r,dg);
nm0loop(r,dg,m) = NM.L(r,dg,m);
dm0loop(r,dg,m) = DM.L(r,dg,m);
md0loop(r,m,dg) = MARD.L(r,m,dg);
yh0loop(r,dg) = YH.L(r,dg);
cd0loop(r,dg) = CD.L(r,dg);
i0loop(r,dg) = INV.L(r,dg);
g0loop(r,dg) = GD.L(r,dg);
bopdef0loop(r) = BOP.L(r);
ta(r,dg) = ta0('%year%',r,dg);
tm(r,dg) = tm0('%year%',r,dg);
c0loop(r) = sum(dg, cd0loop(r,dg));


* -------------------------------------------------------------------
* Write a report on the differences in the dataset relative to
* the core blueNOTE output:
* -------------------------------------------------------------------

* I.e. change in data for energy sectors only, and then an aggregate change in
* data.

dataconschk(r,ds,'ys0','new') = sum(dg, ys0loop(r,ds,dg));
dataconschk(r,dg,'id0','new') = sum(ds, id0loop(r,dg,ds));
dataconschk(r,ds,'va0','new') = ld0loop(r,ds) + kd0loop(r,ds);
dataconschk(r,ds,'tyrev','new') = (1-ty(r,ds)) * sum(dg, ys0loop(r,ds,dg));

dataconschk(r,dg,'i0','new') = i0loop(r,dg);
dataconschk(r,dg,'g0','new') = g0loop(r,dg);
dataconschk(r,dg,'cd0','new') = cd0loop(r,dg);
dataconschk(r,dg,'yh0','new') = yh0loop(r,dg);
dataconschk(r,'total','hhadj','new') = hhadjloop(r);
dataconschk(r,'total','bop','new') = bopdef0loop(r);

dataconschk(r,dg,'s0','new') = s0loop(r,dg);
dataconschk(r,dg,'xd0','new') = xd0loop(r,dg);
dataconschk(r,dg,'xn0','new') = xn0loop(r,dg);
dataconschk(r,dg,'x0','new') = x0loop(r,dg);
dataconschk(r,dg,'rx0','new') = rx0loop(r,dg);
dataconschk(r,dg,'a0','new') = a0loop(r,dg);
dataconschk(r,dg,'nd0','new') = nd0loop(r,dg);
dataconschk(r,dg,'dd0','new') = dd0loop(r,dg);
dataconschk(r,dg,'m0','new') = m0loop(r,dg);

dataconschk(r,dg,'md0','new') = sum(m, md0loop(r,m,dg));
dataconschk(r,dg,'nm0','new') = sum(m, nm0loop(r,dg,m));
dataconschk(r,dg,'dm0','new') = sum(m, dm0loop(r,dg,m));

ALIAS(u,k,*);

SET es(*) "Energy sectors";

es(ioe) = yes;
es('cng') = yes;

PARAMETER pctchg "Percent Change in the data";

* All sectors for each parameter:
pctchg(u,'all')$sum((r,k), dataconschk(r,k,u,'old')) = 100 * (sum((r,k), dataconschk(r,k,u,'new')) / sum((r,k), dataconschk(r,k,u,'old')) - 1);

* All sectors total:
pctchg('total','all')$sum((r,k,u), dataconschk(r,k,u,'old')) = 100 * (sum((r,k,u), dataconschk(r,k,u,'new')) / sum((r,k,u), dataconschk(r,k,u,'old')) - 1);

* Energy sectors for each parameter:
pctchg(u,'eng')$sum((r,es), dataconschk(r,es,u,'old')) = 100 * (sum((r,es), dataconschk(r,es,u,'new')) / sum((r,es), dataconschk(r,es,u,'old')) - 1);

* Energy sectors total:
pctchg('total','eng') = 100 * (sum((r,es,u), dataconschk(r,es,u,'new')) / sum((r,es,u), dataconschk(r,es,u,'old')) - 1);

* What do capital and labor value shares look like now?

PARAMETER vschk "Check on factor value shares in production";

vschk(r,ds,'lab','old') = fvsloop(r,ds,'lab');
vschk(r,ds,'cap','old') = fvsloop(r,ds,'cap');
vschk(r,ds,'lab','new')$sum(dg, ys0loop(r,ds,dg)) = ld0loop(r,ds) / sum(dg, ys0loop(r,ds,dg));
vschk(r,ds,'cap','new')$sum(dg, ys0loop(r,ds,dg)) = kd0loop(r,ds) / sum(dg, ys0loop(r,ds,dg));

DISPLAY pctchg, vschk;

* execute_unload '%temp%gdx\bluenote_delta.gdx' pctchg;
* execute 'gdxxrw.exe i=%temp%gdx\bluenote_delta.gdx o=%temp%xlsx\bluenote_delta.xlsx par=pctchg rng=pctchg!A2 cdim=0'

* -------------------------------------------------------------------
* Output regionalized dataset calibrated to SEDS:
* -------------------------------------------------------------------

EXECUTE_UNLOAD '%dsdir%%sep%WiNDC_cal_%year%_bluenote.gdx'

* Sets:

r,ds=s,m,

* Production data:

ys0loop=ys0,ld0loop=ld0,kd0loop=kd0,id0loop=id0,ty=ty0,

* Consumption data:

yh0loop=yh0,c0loop=c0,cd0loop=cd0,i0loop=i0,g0loop=g0,bopdef0loop=bopdef0,hhadjloop=hhadj,

* Trade data:

s0loop=s0,xd0loop=xd0,xn0loop=xn0,x0loop=x0,rx0loop=rx0,a0loop=a0,
nd0loop=nd0,dd0loop=dd0,m0loop=m0,ta=ta0,tm=tm0,

* Margins:

md0loop=md0,nm0loop=nm0,dm0loop=dm0,

* Emissions:

resco2, secco2;
