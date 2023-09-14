$stitle	Create and Balance an Energy-Economy Dataset with WiNDC and SEDS

$ontext

This sub-routine adjusts accounts from the core WiNDC database to match SEDS
(State Energy Data System). It has three parts:

 - Separate the oil and natural gas extraction sector

 - Impose new totals for electricity generation

 - Impose energy demands 

 - Re-calibrate dataset for a given year


New sector name: ds -- includes separation of oil and gas sectors.
Parameters altered: ys0, cd0, md0, id0, x0(ele_uti), m0(ele_uti) to match SEDS
totals. New parameters included are co2(*) describing total co2 emissions by
generating sector/agent.

Updates:

  - add wood and other electricity generation to seds for recalibration
    (elegen) [done]
  - electricity inputs [done -- not in seds, use net outputs]
  - gas/oil separation refinement [done]
  - enforcing energy totals in consumer demand -- some should be shifted toward
    transportation [done]
  - margins for electricity [done]
  - oil demand definitions seds vs. bea. [done]
  - adding household data [done]
  - recalibration routine for byproducts. limit by product increases and make
    sure coal isn't produced in florida. also -- margin demands should be
    associated with increases in trade and transport sector outputs. this should
    be done after data updates above. [done]

$offtext

* ------------------------------------------------------------------------------
* set options
* ------------------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

*	We always use the bluenote sectors:

$set smap bluenote

*	Three user-specified inputs (12 datasets in total = 2 x 2 x 3)

*	state or census:

$if not set rmap $set rmap state

*	cps or soi:

$if not set hhdata $set hhdata cps

*	Define the year for which bluenote data are to be loaded
*	(2015, 2016 or 2017):

$if not set bnyear $set bnyear 2017

*	Define loss function (huber, ls):

$if not set matbal $set matbal ls

$if not set hhdatadir $set hhdatadir ..%sep%household%sep%

$set gdxdir gdx%sep%

$set core          ..%sep%core%sep%
$set windc_base    %core%windc_base.gdx

* -------------------------------------------------------------------
* Read the household dataset:
* -------------------------------------------------------------------

$set datafile %gdxdir%%hhdata%_%rmap%.gdx

*	Load a dataset without loading a single year:

$include %hhdatadir%windc_hhdata

* -------------------------------------------------------------------
* Read the SEDS data:
* -------------------------------------------------------------------

set	source		"Dynamically created set from seds_units parameter, EIA SEDS source codes",
	sector		"Dynamically created set from seds_units parameter, EIA SEDS sector codes",
	e		"Energy producing sectors in SEDS",
	src(*)		"SEDS energy technologies";

PARAMETER	seds_units(source,sector,r,yr,*)	"Complete EIA SEDS data, with units as domain",
		sedsenergy(r,*,*,*,yr)			"Reconciled SEDS energy data",
		elegen(r,*,yr)				"Electricity generation by source (mill. btu or tkwh for ele)";

$GDXIN '%gdxdir%seds_%rmap%.gdx'
$LOAD e
$LOAD src
$LOAD source<seds_units.dim1
$LOAD sector<seds_units.dim2
$LOAD seds_units
$LOAD sedsenergy
$LOAD elegen
$GDXIN

*	calculate totals

elegen(r,'total',yr) = sum(src, elegen(r,src,yr));

parameter	crude_oil_price_units(yr,*)	"Crude Oil price (composite between domestic and international), with units as domain",
		heatrate_units(yr,*,*)		"EIA Elec Generator average heat rates, with units as domain",
		co2perbtu_units(*,*)		"Carbon dioxide -- not CO2s -- content (kg per million btu)";

$GDXIN '%windc_base%'
$LOAD heatrate_units
$LOAD crude_oil_price_units
$LOAD co2perbtu_units
$GDXIN


* -------------------------------------------------------------------
* Define national totals:
* -------------------------------------------------------------------

PARAMETER	ys0nat		"National output",
		m0nat		"National imports",
		x0nat		"National exports",
		va0nat		"National value added",
		i0nat		"National investment",
		g0nat		"National government demand",
		cd0nat		"National consumer demand";

ys0nat(yr,s,g) = sum(r, ys0_(yr,r,s,g));
m0nat(yr,g) = sum(r, m0_(yr,r,g));
x0nat(yr,g) = sum(r, x0_(yr,r,g));
va0nat(yr,g) = sum(r, ld0_(yr,r,g) + kd0_(yr,r,g));
i0nat(yr,g) = sum(r, i0_(yr,r,g));
g0nat(yr,g) = sum(r, g0_(yr,r,g));
cd0nat(yr,g) = sum(r, cd0_(yr,r,g));


PARAMETER dataconschk "Consistency check on re-calibrated data";
dataconschk(r,s,'ys0','old') = sum(g, ys0_("%bnyear%",r,s,g));
dataconschk(r,g,'id0','old') = sum(s, id0_("%bnyear%",r,g,s));
dataconschk(r,s,'va0','old') = ld0_("%bnyear%",r,s) + kd0_("%bnyear%",r,s);
dataconschk(r,s,'tyrev','old') = (1-ty0_("%bnyear%",r,s)) * sum(g, ys0_("%bnyear%",r,s,g));

dataconschk(r,g,'i0','old') = i0_("%bnyear%",r,g);
dataconschk(r,g,'g0','old') = g0_("%bnyear%",r,g);
dataconschk(r,g,'cd0','old') = cd0_("%bnyear%",r,g);
dataconschk(r,g,'yh0','old') = yh0_("%bnyear%",r,g);
dataconschk(r,'total','hhadj','old') = hhadj_("%bnyear%",r);
dataconschk(r,'total','bop','old') = bopdef0_("%bnyear%",r);

dataconschk(r,g,'s0','old') = s0_("%bnyear%",r,g);
dataconschk(r,g,'xd0','old') = xd0_("%bnyear%",r,g);
dataconschk(r,g,'xn0','old') = xn0_("%bnyear%",r,g);
dataconschk(r,g,'x0','old') = x0_("%bnyear%",r,g);
dataconschk(r,g,'rx0','old') = rx0_("%bnyear%",r,g);
dataconschk(r,g,'a0','old') = a0_("%bnyear%",r,g);
dataconschk(r,g,'nd0','old') = nd0_("%bnyear%",r,g);
dataconschk(r,g,'dd0','old') = dd0_("%bnyear%",r,g);
dataconschk(r,g,'m0','old') = m0_("%bnyear%",r,g);

dataconschk(r,g,'md0','old') = sum(m, md0_("%bnyear%",r,m,g));
dataconschk(r,g,'nm0','old') = sum(m, nm0_("%bnyear%",r,g,m));
dataconschk(r,g,'dm0','old') = sum(m, dm0_("%bnyear%",r,g,m));

dataconschk(r,h,'c0_h','old') = c0_h_("%bnyear%",r,h);
dataconschk(r,h,'le0','old') = sum(q, le0_("%bnyear%",r,q,h));
dataconschk(r,h,'ke0','old') = ke0_("%bnyear%",r,h);
dataconschk(r,h,'sav0','old') = sav0_("%bnyear%",r,h);

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
$INCLUDE maps%sep%mapseds.map
/;


* Quick note on units. pe0 is in dollars per million btu's for non
* electricity energy sources. Prices are denominated in dollars per
* thousand kwhs for electricity. Multiplying price x quanitity below
* results in things denominated in millions of dollars. Scaling by 1000 ->
* billions of dollars per year.

PARAMETER pe0(yr,r,e,demsec) "Energy demand prices ($ per mbtu -- $ per thou kwh for ele)";
PARAMETER pedef(yr,r,e) "Average energy demand prices";
PARAMETER ps0(yr,*) "Supply prices of crude oil and natural gas (dollars per million btu)";
PARAMETER ps0_ind(yr,*,*) "Testing industry-specific demand-side supply prices to fix the extreme margins";

pedef(yr,r,e)$sum(demsec, sedsenergy(r,'q',e,demsec,yr)) =
	sum(demsec, sedsenergy(r,'p',e,demsec,yr)*sedsenergy(r,'q',e,demsec,yr)) /
	sum(demsec, sedsenergy(r,'q',e,demsec,yr));

* Otherwise, use the average across all regions which have a value:

alias (r,rr);

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

ps0_ind(yr,e,demsec) = smin((rr)$pe0(yr,rr,e,demsec),pe0(yr,rr,e,demsec));

* construct a weighted supply price. because oil is a composite of pet coke and
* other refined products, demand prices vary quite a bit making the "minimum"
* rule less effective. moreover, disregarding oil demand prices by ele sector
* due to reliance on cheaper subsitutes in parts of US.

ps0(yr,e) = sum((demsec,r),ps0_ind(yr,e,demsec) *
    sedsenergy(r,'q',e,demsec,yr))/sum((demsec,r),sedsenergy(r,'q',e,demsec,yr));

ps0(yr,e) = smin((demsec,rr)$(pe0(yr,rr,e,demsec) and not sameas(demsec, "ele")),pe0(yr,rr,e,demsec));

* Calculate production values to generation production shares:

prodval(r,yr,'gas') = ps0(yr,'gas') * prodbtu(r,yr,'gas') / 1000;
prodval(r,yr,'cru') = ps0(yr,'cru') * prodbtu(r,yr,'cru') / 1000;

* Separate all parameters using the same share to maintain
* micro-consistency.

SET as "Additional sectors" / gas, cru /;
SET mapog(as,s) "Mapping between oil and gas sectors" / gas.cng, cru.cng /;
SET ds(*) "Disaggregate sectoring scheme";

PARAMETER shrgas(r,yr,as) "Share of production in each state for gas extraction";
PARAMETER chkshr "Check on extraction shares";

* Share is only available where production exists, otherwise set to zero.

shrgas(r,yr,as)$sum(as.local, prodval(r,yr,as)) = prodval(r,yr,as) / sum(as.local, prodval(r,yr,as));

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
PARAMETER bopdef0(yr,r) "Balance of payments";
PARAMETER hhadj(yr,r) "Household adjustment";
PARAMETER g0(yr,r,*) "Government demand";
PARAMETER i0(yr,r,*) "Investment demand";
PARAMETER xn0(yr,r,*) "Regional supply to national market";
PARAMETER xd0(yr,r,*) "Regional supply to local market";
PARAMETER dd0(yr,r,*) "Regional demand from local  market";
PARAMETER nd0(yr,r,*) "Regional demand from national market";

* Add household data:

PARAMETER cd0_h(yr,r,*,h) "Household level expenditures";
PARAMETER c0_h(yr,r,h) "Aggregate household level expenditures";
PARAMETER le0(yr,r,q,h) "Household labor endowment";
PARAMETER ke0(yr,r,h) "Household interest payments";
PARAMETER tk0(yr,r) "Capital tax rate";
PARAMETER tl0(yr,r,h) "Household labor tax rate";
PARAMETER sav0(yr,r,h) "Household saving";
PARAMETER fsav0(yr) "Foreign saving";
PARAMETER trn0(yr,r,h) "Household transfer payments";
PARAMETER hhtrn0(yr,r,h,trn) "Disaggregate transfer payments";
PARAMETER pop(yr,r,h) "Population (households or returns in millions)";


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
cd0_h(yr,r,g,h)$(NOT SAMEAS(g,'cng')) = cd0_h_(yr,r,g,h);
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
pop(yr,r,h) = pop_(yr,r,h);
le0(yr,r,q,h) = le0_(yr,r,q,h);
ke0(yr,r,h) = ke0_(yr,r,h);
tk0(yr,r) = tk0_(yr,r);
tl0(yr,r,h) = tl0_(yr,r,h);
c0_h(yr,r,h) = c0_h_(yr,r,h);
sav0(yr,r,h) = sav0_(yr,r,h);
fsav0(yr) = fsav0_(yr);
trn0(yr,r,h) = trn0_(yr,r,h);
hhtrn0(yr,r,h,trn) = hhtrn0_(yr,r,h,trn);

* Share out oil and gas extraction sector production parameters by assuming
* there is no byproduct production between both crude oil and
* natural gas, keeping tax rates the same.

ALIAS(as,as_);
ld0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * ld0_(yr,r,s));
kd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * kd0_(yr,r,s));
ty0(yr,r,as) = sum(mapog(as,s), ty0_(yr,r,s));
ys0(yr,r,s,as)$(NOT SAMEAS(s,'cng')) = sum(mapog(as,g), shrgas(r,yr,as) * ys0_(yr,r,s,g));
ys0(yr,r,as,g)$(NOT SAMEAS(g,'cng')) = sum(mapog(as,s), shrgas(r,yr,as) * ys0_(yr,r,s,g));
ys0(yr,r,as,as) = sum(mapog(as,s), shrgas(r,yr,as) * ys0_(yr,r,s,s));
id0(yr,r,g,as)$(NOT SAMEAS(g,'cng')) = sum(mapog(as,s), shrgas(r,yr,as) * id0_(yr,r,g,s));
id0(yr,r,as,as) = sum(mapog(as,s), shrgas(r,yr,as) * id0_(yr,r,s,s));

* Assume all of the 'cng' input to refined petroleum is crude oil. assume all of
* the 'cng' input for other sectors is natural gas.

id0(yr,r,'cru','oil') = id0_(yr,r,'cng','oil');
id0(yr,r,'gas',s)$(not sameas(s,'ref')) = id0_(yr,r,'cng',s);

* Assume the relevant source parameters follow the production share defined
* above:

x0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * x0_(yr,r,s));
rx0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * rx0_(yr,r,s));
xn0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * xn0_(yr,r,s));
yh0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * yh0_(yr,r,s));
s0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * s0_(yr,r,s));
xd0(yr,r,as) = sum(mapog(as,s), shrgas(r,yr,as) * xd0_(yr,r,s));
nm0(yr,r,as,m) = sum(mapog(as,s), shrgas(r,yr,as) * nm0_(yr,r,s,m));
dm0(yr,r,as,m) = sum(mapog(as,s), shrgas(r,yr,as) * dm0_(yr,r,s,m));

* Assume demand parameters follow share defined by intermediate demand
* assumption:

parameter
    demshare(yr,r,as)   Demand driven share inputed from above,
    compshare           Share comparison with production share;

demshare(yr,r,'cru') = id0(yr,r,'cru','oil') /
    (id0(yr,r,'cru','oil') + sum(s$(not sameas(s,'oil')), id0(yr,r,'gas',s)));
demshare(yr,r,'gas') = 1 - demshare(yr,r,'cru');
compshare(yr,r,'prod') = shrgas(r,yr,'gas');
compshare(yr,r,'dem') = demshare(yr,r,'gas');
display compshare;

m0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * m0_(yr,r,s));
a0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * a0_(yr,r,s));
ta0(yr,r,as) = sum(mapog(as,s), ta0_(yr,r,s));
tm0(yr,r,as) = sum(mapog(as,s), tm0_(yr,r,s));
dd0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * dd0_(yr,r,s));
nd0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * nd0_(yr,r,s));
md0(yr,r,m,as) = sum(mapog(as,s), demshare(yr,r,as) * md0_(yr,r,m,s));
g0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * g0_(yr,r,s));
i0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * i0_(yr,r,s));
cd0(yr,r,as) = sum(mapog(as,s), demshare(yr,r,as) * cd0_(yr,r,s));
cd0_h(yr,r,as,h) = sum(mapog(as,s), demshare(yr,r,as) * cd0_h_(yr,r,s,h));

ds(s)$(NOT SAMEAS(s,'cng')) = yes;
ds(as) = yes;
ALIAS(ds,dg);


* Save initial factor value shares in production:

PARAMETER fvs "Factor value shares";

fvs(yr,r,ds,'lab')$sum(dg, ys0(yr,r,ds,dg)) = ld0(yr,r,ds) / (sum(dg, ys0(yr,r,ds,dg))*(1-ty0(yr,r,ds)));
fvs(yr,r,ds,'cap')$sum(dg, ys0(yr,r,ds,dg)) = ((1+tk0(yr,r))*kd0(yr,r,ds)) / (sum(dg, ys0(yr,r,ds,dg))*(1-ty0(yr,r,ds)));

* Save output parameter to verify how much byproducts shift:

PARAMETER saveys0 "Save ys0";
PARAMETER prodshr0 "Reference production shares relative to byproducts";

saveys0(yr,r,ds,dg) = ys0(yr,r,ds,dg);
prodshr0(yr,r,ds)$ys0(yr,r,ds,ds) =  sum(dg$(not sameas(dg,ds)), ys0(yr,r,dg,ds)) / ys0(yr,r,ds,ds);


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

trdele(r,yr,'imp') = seds_units('EL','IM',r,yr,'millions of us dollars (USD)') / 10000;
trdele(r,yr,'exp') = seds_units('EL','EX',r,yr,'millions of us dollars (USD)') / 10000;

x0(yr,r,'ele') = trdele(r,yr,'exp');
m0(yr,r,'ele') = trdele(r,yr,'imp');

SET mapsrc(*,*) "Mapping with technologies and primary inputs for fossil fuel" / col.col, gas.gas, oil.oil /;
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
PARAMETER ed0(yr,r,e,demsec) "Energy demand (bill $ value gross margin)";
PARAMETER emarg0(yr,r,e,*) "Margin demand for energy markups (10s of bill $)";
PARAMETER ned0(yr,r,*,*) "Net energy demands (bill $ value net of margin)";

eq0(yr,r,e,demsec) = max(0,sedsenergy(r,'q',e,demsec,yr));
ed0(yr,r,e,demsec) = pe0(yr,r,e,demsec) * eq0(yr,r,e,demsec) / 1e3;
emarg0(yr,r,e,demsec)$ed0(yr,r,e,demsec) = (pe0(yr,r,e,demsec) - ps0(yr,e)) * eq0(yr,r,e,demsec) / 1e3;
emarg0(yr,r,"oil",demsec)$ed0(yr,r,"oil",demsec) = (pe0(yr,r,"oil",demsec) - ps0_ind(yr,"oil",demsec))*eq0(yr,r,"oil",demsec) / 1e3;
emarg0(yr,r,"gas",demsec)$ed0(yr,r,"gas",demsec) = (pe0(yr,r,"gas",demsec) - ps0_ind(yr,"gas",demsec))*eq0(yr,r,"gas",demsec) / 1e3;
emarg0(yr,r,"col",demsec)$ed0(yr,r,"col",demsec) = (pe0(yr,r,"col",demsec) - ps0_ind(yr,"col",demsec))*eq0(yr,r,"col",demsec) / 1e3;
ned0(yr,r,e,demsec) = ed0(yr,r,e,demsec) - emarg0(yr,r,e,demsec);

* Assume margins for energy is aggregated and applied uniformily to all
* demanding sectors for each energy type. I.e. adjust md0(yr,r,e) for
* margins and id0(r,e,demsec) and cd0(r,e) for demands.

* Resource related energy goods already had margins in the data. Share out
* new totals using existing margins.

PARAMETER margshr(yr,r,m,*);

margshr(yr,r,'trn',ioe)$sum(m, md0(yr,r,m,ioe)) = md0(yr,r,'trn',ioe) / sum(m, md0(yr,r,m,ioe));
margshr(yr,r,'trd',ioe) = 1 - margshr(yr,r,'trn',ioe);

* Assume the margins share for electricity is an average of other margins in the
* dataset.

margshr(yr,r,'trn','ele') = sum(ioe$(not sameas(ioe,'ele')), margshr(yr,r,'trn',ioe)) / sum(ioe$(not sameas(ioe,'ele')), 1);
margshr(yr,r,'trd','ele') = 1 - margshr(yr,r,'trn','ele');

* Calculate margins:

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

* Because SEDS shifts most of household oil demands to the transportation
* sector, assign difference to transportation:

cd0(yr,r,'trn') = cd0(yr,r,'trn') + (resechk(yr,r,'oil','old') - resechk(yr,r,'oil','new'));

* Share associated houeshold data

cd0_h(yr,r,ioe,h)$sum(h.local, cd0_h(yr,r,ioe,h)) =
    cd0(yr,r,ioe) * cd0_h(yr,r,ioe,h) / sum(h.local, cd0_h(yr,r,ioe,h));

* Because there are no natural gas expenditures in the benchmark, use oil as a proxy

cd0_h(yr,r,'gas',h) =
    cd0(yr,r,'gas') * cd0_h(yr,r,'oil',h) / sum(h.local, cd0_h(yr,r,'oil',h));

* Adjust supply totals. The District of Columbia is a strange case. In 2014,
* there are no generation statistics from electric utilities, but independent
* power did produce electricity per EIA.

PARAMETER chkele;
chkele(r,'old') = ys0('2016',r,'ele','ele');
chkele(r,'new') = elegen(r,'total','2016') * ps0('2016','ele') / 1e3;

PARAMETER scale(yr,r,*) "Scaling parameter for byproducts";

scale(yr,r,'ele')$ys0(yr,r,'ele','ele') = elegen(r,'total',yr) * ps0(yr,'ele') / 1e3 / ys0(yr,r,'ele','ele');
scale(yr,r,'cru')$ys0(yr,r,'cru','cru') = sedsenergy(r,'q','cru','supply',yr)*ps0(yr,'cru') / 1e3 / ys0(yr,r,'cru','cru');
scale(yr,r,'gas')$ys0(yr,r,'gas','gas') = sedsenergy(r,'q','gas','supply',yr)*ps0(yr,'gas') / 1e3 / ys0(yr,r,'gas','gas');
scale(yr,r,'col')$ys0(yr,r,'col','col') = sedsenergy(r,'q','col','supply',yr)*ps0(yr,'col') / 1e3 / ys0(yr,r,'col','col');
scale(yr,r,'oil')$ys0(yr,r,'oil','oil') = sedsenergy(r,'q','cru','ref',yr)/sum(r.local,sedsenergy(r,'q','cru','ref',yr)) * sum((demsec,r.local),ned0(yr,r,'oil',demsec))  / ys0(yr,r,'oil','oil');

* Also adjust by-products for these energy sectors proportionately, along with
* other inputs as an initial guess:

ys0(yr,r,ioe,dg) = scale(yr,r,ioe) * ys0(yr,r,ioe,dg);
ld0(yr,r,ioe) = scale(yr,r,ioe) * ld0(yr,r,ioe);
kd0(yr,r,ioe) = scale(yr,r,ioe) * kd0(yr,r,ioe);
id0(yr,r,dg,ioe) = scale(yr,r,ioe) * id0(yr,r,dg,ioe);

* Similarly, scale production of energy goods in other sectors:

ys0(yr,r,ds,ioe)$(not sameas(ds,ioe)) = scale(yr,r,ioe) * ys0(yr,r,ds,ioe);

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
display inpchk;

* Verify that revenues are greater than input demand costs for energy demands:

PARAMETER rev_cost(yr,r,*,*) "Comparison of revenues vs. input energy demands";

rev_cost(yr,r,'ele','rev') = elegen(r,'total',yr) * ps0(yr,'ele') / 1e3;
rev_cost(yr,r,'oil','rev') = sedsenergy(r,'q','cru','ref',yr)/sum(r.local,sedsenergy(r,'q','cru','ref',yr)) * sum((demsec,r.local),ned0(yr,r,'oil',demsec));
rev_cost(yr,r,'ele','cost') = sum(e, ed0(yr,r,e,'ele'));
rev_cost(yr,r,'oil','cost') = sum(e, ed0(yr,r,e,'ref'));
rev_cost(yr,r,ioe,'%')$(rev_cost(yr,r,ioe,'rev')-rev_cost(yr,r,ioe,'cost')<0) = 100 * rev_cost(yr,r,ioe,'cost') / rev_cost(yr,r,ioe,'rev');

* Scale group that has inconsistencies in data:

id0(yr,r,ioe,ds)$(rev_cost(yr,r,ds,'rev')-rev_cost(yr,r,ds,'cost')<0) = rev_cost(yr,r,ds,'rev') / rev_cost(yr,r,ds,'cost') * id0(yr,r,ioe,ds);

* Zero out production and allocation accounts without generation totals:

ys0(yr,r,'ele',dg)$(elegen(r,'total',yr) * ps0(yr,'ele') = 0) = 0;
ld0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
kd0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
id0(yr,r,dg,'ele')$(sum(ds, ys0(yr,r,'ele',ds)) = 0) = 0;
s0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
xd0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
xn0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
x0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;
rx0(yr,r,'ele')$(sum(dg, ys0(yr,r,'ele',dg)) = 0) = 0;

* Zero out other production and allocation accounts without associated energy
* production:

ys0(yr,r,ioe,dg)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
ld0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
kd0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
id0(yr,r,dg,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
s0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
xd0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
xn0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
x0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;
rx0(yr,r,ioe)$(not sameas(ioe,'ele') and not scale(yr,r,ioe)) = 0;

* Assume byproducts cannot be produced in a region if there is no primary
* production in the region:

ys0(yr,r,dg,ioe)$(not scale(yr,r,ioe)) = 0;

* Print new energy demands:

enegdem(yr,r,ioe,'new') = sum(dg, id0(yr,r,ioe,dg)) + cd0(yr,r,ioe);
display enegdem;

* Check by-product shares in new unbalanced data:

parameter
    chkps, chk;

chkps(yr,r,ds)$ys0(yr,r,ds,ds) =  sum(dg$(not sameas(dg,ds)), ys0(yr,r,dg,ds)) / ys0(yr,r,ds,ds);
chk(r,ds,'old') = prodshr0('%bnyear%',r,ds);
chk(r,ds,'new') = chkps('%bnyear%',r,ds);
display chk;


* -------------------------------------------------------------------
* Include emissions data:
* -------------------------------------------------------------------

PARAMETER co2emiss "Carbon content of energy demands (mill. metric tonnes)";
PARAMETER btus "BTU totals (quadrillions)";
PARAMETER usatotalco2	"National totals for carbon emissions (mill. metric tonnes)";

* Scaling to quadrillions of btus (trill btu/ 1e3). Note that 1000kg = 1
* metric tonne. So, quadrillion btus * kg per million btu = billions of
* kgs or millions of metric tonnes.

btus(r,e,demsec) = eq0('%bnyear%',r,e,demsec) / 1e3;
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

shrsec(r,ioe,ds,'ind')$(mapdems(ds,'ind') and sum(ds.local$mapdems(ds,'ind'), id0('%bnyear%',r,ioe,ds))) = id0('%bnyear%',r,ioe,ds) / sum(ds.local$mapdems(ds,'ind'), id0('%bnyear%',r,ioe,ds));
shrsec(r,ioe,ds,'com')$(mapdems(ds,'com') and sum(ds.local$mapdems(ds,'com'), id0('%bnyear%',r,ioe,ds))) = id0('%bnyear%',r,ioe,ds) / sum(ds.local$mapdems(ds,'com'), id0('%bnyear%',r,ioe,ds));
shrsec(r,ioe,ds,'trn')$(mapdems(ds,'trn') and sum(ds.local$mapdems(ds,'trn'), id0('%bnyear%',r,ioe,ds))) = id0('%bnyear%',r,ioe,ds) / sum(ds.local$mapdems(ds,'trn'), id0('%bnyear%',r,ioe,ds));

* Map co2 emissions to aggregate fuel categories:

resco2(r,ioe) = co2emiss(r,ioe,'res');
secco2(r,ioe,ds) = sum(demsec, shrsec(r,ioe,ds,demsec) * co2emiss(r,ioe,demsec));
secco2(r,ioe,'ele') = co2emiss(r,ioe,'ele');
secco2(r,'cru','oil') = co2emiss(r,'cru','ref');

* Are there co2 emissions without associated energy demands? There are when the
* pctgeneration < 1. I do this for numerical reasons if disaggregating the
* electricity sector into composite technologies.

PARAMETER nomatch;
nomatch(r,ioe,ds)$(secco2(r,ioe,ds) and not id0('%bnyear%',r,ioe,ds)) = secco2(r,ioe,ds);
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
PARAMETER zerotol "Tolerance level" / 6 /;

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

ld0(yr,r,ds)$(not round(ld0(yr,r,ds),zerotol)) = 0;
kd0(yr,r,ds)$(not round(kd0(yr,r,ds),zerotol)) = 0;
m0(yr,r,dg)$(not round(m0(yr,r,dg),zerotol)) = 0;
x0(yr,r,dg)$(not round(x0(yr,r,dg),zerotol)) = 0;
rx0(yr,r,dg)$(not round(rx0(yr,r,dg),zerotol)) = 0;
s0(yr,r,dg)$(not round(s0(yr,r,dg),zerotol)) = 0;
a0(yr,r,dg)$(not round(a0(yr,r,dg),zerotol)) = 0;
cd0(yr,r,dg)$(not round(cd0(yr,r,dg),zerotol)) = 0;
yh0(yr,r,dg)$(not round(yh0(yr,r,dg),zerotol)) = 0;
g0(yr,r,dg)$(not round(g0(yr,r,dg),zerotol)) = 0;
i0(yr,r,dg)$(not round(i0(yr,r,dg),zerotol)) = 0;
xn0(yr,r,dg)$(not round(xn0(yr,r,dg),zerotol)) = 0;
xd0(yr,r,dg)$(not round(xd0(yr,r,dg),zerotol)) = 0;
dd0(yr,r,dg)$(not round(dd0(yr,r,dg),zerotol)) = 0;
nd0(yr,r,dg)$(not round(nd0(yr,r,dg),zerotol)) = 0;
ys0(yr,r,ds,dg)$(not round(ys0(yr,r,ds,dg),zerotol)) = 0;
id0(yr,r,dg,ds)$(not round(id0(yr,r,dg,ds),zerotol)) = 0;
md0(yr,r,m,dg)$(not round(md0(yr,r,m,dg),zerotol)) = 0;
nm0(yr,r,dg,m)$(not round(nm0(yr,r,dg,m),zerotol)) = 0;
dm0(yr,r,dg,m)$(not round(dm0(yr,r,dg,m),zerotol)) = 0;

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

* zeroed(yr,'before')$(NOT SAMEAS(yr,'2015')) = sum((pm,dg), trace(yr,dg,pm,'before'));
* zeroed(yr,'after')$(NOT SAMEAS(yr,'2015')) = sum((pm,dg), trace(yr,dg,pm,'after'));

zeroed(yr,'before') = sum((pm,dg), trace(yr,dg,pm,'before'));
zeroed(yr,'after') = sum((pm,dg), trace(yr,dg,pm,'after'));
zeroed(yr,'diff') = zeroed(yr,'before') - zeroed(yr,'after');


* -------------------------------------------------------------------------
* Write a re-calibration routine which minimally shifts data to maintain
* micro-consistency.
* -------------------------------------------------------------------------

* Define needed sets and parameters:

SET mat "Select parameters for huber objective" / ys0,id0 /;
SET nonzero(mat,r,*,*) "Nonzeros in the reference data";
SET zeros(mat,r,*,*) "Zeros in the reference data";
SET eneg(s) Energy sectors in national data / cng, ele, oil, col /;

PARAMETER zeropenalty "Penalty for imposing non-zero elements" / 1e7 /;

* Define variables:

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

* Assume minimal change in the household data:

POSITIVE VARIABLE CD_H "Household demand";
POSITIVE VARIABLE WAGE "Household wages";
POSITIVE VARIABLE INT "Household interest";
POSITIVE VARIABLE SAVE "Household savings";

POSITIVE VARIABLE X1 "Percentage deviations";
POSITIVE VARIABLE X2 "Percentage deviations";
POSITIVE VARIABLE X3 "Percentage deviations";

VARIABLE OBJ "Objective variable";
VARIABLE BOP(r) "Balance of payments";
VARIABLE HHAD(r) "Adjustment of household payments";

* Define equations:

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

EQUATION bop_def "Balance of payment definition";

EQUATION hh_c "Household demand summing constraint";
EQUATION hh_wage "Household wages summing constraint";
EQUATION hh_cap "Household interest summing constraint";
EQUATION hh_save "Household saving summing constraint";
EQUATION hh_ibal "Household level income balance";

EQUATION expdef "Gross exports must be greater than re-exports";

EQUATION netgenbalpos1 "Net generation of electricity balancing";
EQUATION netgenbalpos2 "Net generation of electricity balancing";
EQUATION netgenbalneg1 "Net generation of electricity balancing";
EQUATION netgenbalneg2 "Net generation of electricity balancing";

EQUATION byproddef "Primary vs byproduct production upper bound";

EQUATION natys0 "Verify regional totals eq national totals";
EQUATION natm0 "Verify regional totals eq national totals";
EQUATION natx0 "Verify regional totals eq national totals";
EQUATION natva "Verify regional totals eq national totals";
EQUATION nati0 "Verify regional totals eq national totals";
EQUATION natg0 "Verify regional totals eq national totals";
EQUATION natc0 "Verify regional totals eq national totals";

EQUATION x2def "Huber constraints";
EQUATION x3def "Huber constraints";

* Define loop parameters:

PARAMETER ys0loop "Sectoral supply";
PARAMETER id0loop "Intermediate demand";
PARAMETER ld0loop "Labor demand";
PARAMETER kd0loop "Capital demand";
PARAMETER ty "Production tax rate";
PARAMETER ta "Tax net subsidy rate on intermediate demand";
PARAMETER a0loop "Armington supply";
PARAMETER nd0loop "Regional demand from national market";
PARAMETER dd0loop "Regional demand from local  market";
PARAMETER tm "Import tariff";
PARAMETER m0loop "Imports";
PARAMETER s0loop "Aggregate supply";
PARAMETER xd0loop "Regional supply to local market";
PARAMETER xn0loop "Regional supply to national market";
PARAMETER x0loop "Exports of goods and services";
PARAMETER rx0loop "Re-exports of goods and services";
PARAMETER nm0loop "Margin demand from national market";
PARAMETER dm0loop "Margin supply from local market";
PARAMETER md0loop "Total margin demand";
PARAMETER cd0loop "Final demand";
PARAMETER c0loop "Aggregate final demand";
PARAMETER g0loop "Government demand";
PARAMETER i0loop "Investment demand";
PARAMETER yh0loop "Household production";
PARAMETER bopdef0loop "Balance of payments";
PARAMETER hhadjloop "Household adjustment";

PARAMETER cd0_hloop "Household commodity demand";
PARAMETER c0_hloop "Aggregate household demand";
PARAMETER le0loop "Household labor endowment";
PARAMETER ke0loop "Interest endowment";
PARAMETER tk0loop "Capital income taxrate";
PARAMETER tl0loop "Labor income taxrate";
PARAMETER sav0loop "Household savings";
PARAMETER fsav0loop "Foreign savings";
PARAMETER trn0loop "Aggregate transfers";
PARAMETER hhtrn0loop "Disaggregate transfers";
PARAMETER poploop "Population";

PARAMETER netgenloop "Net interstate generation";
PARAMETER fvsloop "Factor value shares";

PARAMETER nat_ys "National output";
PARAMETER nat_m "National imports";
PARAMETER nat_x "National exports";
PARAMETER nat_va "National value added";
PARAMETER nat_i "National investment";
PARAMETER nat_g "National government demand";
PARAMETER nat_c "National consumption";

* Huber method: additional parameters needed if using Huber's matrix
* balancing routine:

PARAMETER v0(mat,r,*,*) "Matrix values";
PARAMETER gammab "Lower bound cross-over tolerance" / 0.5 /;
PARAMETER thetab "Upper bound cross-over tolerance" / 0.25 /;

$MACRO	MV(mat,r,ds,dg) (YS(r,ds,dg)$SAMEAS(mat,'ys0') + ID(r,ds,dg)$SAMEAS(mat,'id0'))

x2def(nonzero(mat,r,ds,dg))..   X2(mat,r,ds,dg) + X1(mat,r,ds,dg) =G= (MV(mat,r,ds,dg)/v0(mat,r,ds,dg)-1);
x3def(nonzero(mat,r,ds,dg))..   X3(mat,r,ds,dg) - X2(mat,r,ds,dg) =G= (1-MV(mat,r,ds,dg)/v0(mat,r,ds,dg));

obj_huber..     OBJ =E=	sum(nonzero(mat,r,ds,dg), abs(v0(mat,r,ds,dg)) *
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
			sum((r)$hhadjloop(r), abs(hhadjloop(r)) * sqr(HHAD(r) / hhadjloop(r) - 1)) +
			sum((r,dg,h)$cd0_hloop(r,dg,h), abs(cd0_hloop(r,dg,h)) * sqr(CD_H(r,dg,h) / cd0_hloop(r,dg,h) - 1)) +
			sum((r,q,h)$le0loop(r,q,h), abs(le0loop(r,q,h)) * sqr(WAGE(r,q,h) / le0loop(r,q,h) - 1)) +
			sum((r,h)$ke0loop(r,h), abs(ke0loop(r,h)) * sqr(INT(r,h) / ke0loop(r,h) - 1)) +
			sum((r,h)$sav0loop(r,h), abs(sav0loop(r,h)) * sqr(SAVE(r,h) / sav0loop(r,h) - 1)) +
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
			sum((r)$hhadjloop(r), abs(hhadjloop(r)) * sqr(HHAD(r) / hhadjloop(r) - 1)) +
			sum((r,dg,h)$cd0_hloop(r,dg,h), abs(cd0_hloop(r,dg,h)) * sqr(CD_H(r,dg,h) / cd0_hloop(r,dg,h) - 1)) +
			sum((r,q,h)$le0loop(r,q,h), abs(le0loop(r,q,h)) * sqr(WAGE(r,q,h) / le0loop(r,q,h) - 1)) +
			sum((r,h)$ke0loop(r,h), abs(ke0loop(r,h)) * sqr(INT(r,h) / ke0loop(r,h) - 1)) +
			sum((r,h)$sav0loop(r,h), abs(sav0loop(r,h)) * sqr(SAVE(r,h) / sav0loop(r,h) - 1)) +
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

zp_y(r,ds)..	(1-ty(r,ds)) * sum(dg, YS(r,ds,dg)) =E= sum(dg, ID(r,dg,ds)) + LD(r,ds) + (1+tk0loop(r)) * KD(r,ds);

zp_a(r,dg)..	(1-ta(r,dg)) * ARM(r,dg) + RX(r,dg) =E= ND(r,dg) + DD(r,dg) + (1+tm(r,dg)) * IMP(r,dg) + sum(m, MARD(r,m,dg));

zp_x(r,dg)..	SUP(r,dg) + RX(r,dg) =E= XPT(r,dg) + XN(r,dg) + XD(r,dg);

zp_ms(r,m)..	sum(ds, NM(r,ds,m) + DM(r,ds,m)) =E= sum(dg, MARD(r,m,dg));

lvshr(r,ds)$sum(dg, ys0loop(r,ds,dg))..
                LD(r,ds) =G= 0.5 * fvsloop(r,ds,'lab') * (1-ty(r,ds))*sum(dg, YS(r,ds,dg));

kvshr(r,ds)$sum(dg, ys0loop(r,ds,dg))..
                KD(r,ds) =G= 0.5 * fvsloop(r,ds,'cap') * (1-ty(r,ds))*sum(dg, YS(r,ds,dg))/(1+tk0loop(r));

mc_py(r,dg)..	sum(ds, YS(r,ds,dg)) + YH(r,dg) =E= SUP(r,dg);
mc_pa(r,dg)..	ARM(r,dg) =E= sum(ds, ID(r,dg,ds)) + CD(r,dg) + GD(r,dg) + INV(r,dg);
mc_pd(r,dg)..	XD(r,dg) =E= sum(m, DM(r,dg,m)) + DD(r,dg);
mc_pn(dg)..	sum(r, XN(r,dg)) =E= sum((r,m), NM(r,dg,m)) + sum(r, ND(r,dg));
bop_def(r)..	BOP(r) =e= sum(dg, IMP(r,dg) - XPT(r,dg));
mc_pfx..	sum(r, BOP(r) + HHAD(r)) + sum((r,dg), XPT(r,dg)) =E= sum((r,dg), IMP(r,dg));

expdef(r,dg)..	XPT(r,dg) =G= RX(r,dg);

incbal(r)..	sum(dg, CD(r,dg) + GD(r,dg) + INV(r,dg)) =E=
		sum(dg, YH(r,dg)) + BOP(r) + HHAD(r) + sum(ds, LD(r,ds) + KD(r,ds)) +
		sum(dg, ta(r,dg)*ARM(r,dg) + tm(r,dg)*IMP(r,dg)) + sum(ds, ty(r,ds)*sum(dg, YS(r,ds,dg))) +
		sum(ds, tk0loop(r)*KD(r,ds));

* Additional household summing conditions:

hh_c(r,dg)..	sum(h, CD_H(r,dg,h)) =E= CD(r,dg);
hh_wage(r)..    sum((q,h), WAGE(q,r,h)) =E= sum(ds, LD(r,ds));
hh_cap..	sum((r,h), INT(r,h)) =E= sum((r,ds), KD(r,ds) + YH(r,ds));
hh_save..	sum((r,h), SAVE(r,h)) + fsav0loop =E= sum((r,dg), INV(r,dg));
hh_ibal(r,h)..	trn0loop(r,h) + sum(q, WAGE(r,q,h)) + INT(r,h) =E=
		sum(dg, CD_H(r,dg,h)) + SAVE(r,h) + tl0loop(r,h)*sum(q, WAGE(r,q,h));


* Impose net generation constraints on national electricity trade if calibrating
* to SEDS data:

netgenbalpos1(r)$(netgenloop(r)>0)..	ND(r,'ele') - XN(r,'ele') =G= 0.8 * netgenloop(r);

netgenbalpos2(r)$(netgenloop(r)>0)..	ND(r,'ele') - XN(r,'ele') =L= 1.2 * netgenloop(r);

netgenbalneg1(r)$(netgenloop(r)<0)..	ND(r,'ele') - XN(r,'ele') =L= 0.8 * netgenloop(r);

netgenbalneg2(r)$(netgenloop(r)<0)..	ND(r,'ele') - XN(r,'ele') =G= 1.2 * netgenloop(r);


* Require that primary production vs. byproduct production is fixed from the
* original data

byproddef(ioe)..	sum((r,dg)$(not sameas(dg,ioe)), YS(r,dg,ioe)) =e= sum(r, prodshr0('%bnyear%',r,ioe) * YS(r,ioe,ioe));


* Verify regional parameters sum to national totals for key parameters of
* non-energy sectors. SEDS data is used for energy totals.

natys0(s)$(not eneg(s))..	sum((r,dg), YS(r,s,dg)) =E= sum(g, nat_ys(s,g));

natx0(s)$(not eneg(s))..	sum(r, XPT(r,s)) =E= nat_x(s);

natm0(s)$(not eneg(s))..	sum(r, IMP(r,s)) =E= nat_m(s);

natva(s)$(not eneg(s))..	sum(r, LD(r,s) + KD(r,s)) =E= nat_va(s);

natg0(s)$(not eneg(s))..	sum(r, GD(r,s)) =E= nat_g(s);

nati0(s)$(not eneg(s))..	sum(r, INV(r,s)) =E= nat_i(s);

natc0(s)$(not eneg(s) and not sameas(s,'trn'))..	sum(r, CD(r,s)) =E= nat_c(s);


$IF %matbal% == huber model regcalib /obj_huber, x2def, x3def, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, netgenbalpos1, netgenbalpos2, netgenbalneg1, netgenbalneg2, natx0, natm0, natva, natg0, nati0, natc0, lvshr, kvshr, hh_c, hh_wage, hh_cap, hh_save, hh_ibal, byproddef, bop_def /;

$IF %matbal% == ls model regcalib /obj_ls, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, netgenbalpos1, netgenbalpos2, netgenbalneg1, netgenbalneg2, natx0, natm0, natva, natg0, nati0, natc0, lvshr, kvshr, hh_c, hh_wage, hh_cap, hh_save, hh_ibal, byproddef, bop_def /;

* We could alternatively produce data for all years:

loop(yr$(SAMEAS(yr,'%bnyear%')),

* Define looping data:

ys0loop(r,ds,dg) = ys0(yr,r,ds,dg);
id0loop(r,dg,ds) = id0(yr,r,dg,ds);
ld0loop(r,dg) = ld0(yr,r,dg);
kd0loop(r,dg) = kd0(yr,r,dg);
ty(r,ds) = ty0(yr,r,ds);
ta(r,dg) = ta0(yr,r,dg);
tm(r,dg) = tm0(yr,r,dg);
yh0loop(r,dg) = yh0(yr,r,dg);
s0loop(r,dg) = sum(ds, ys0(yr,r,ds,dg)) + yh0loop(r,dg);
a0loop(r,dg) = a0(yr,r,dg);
nd0loop(r,dg) = nd0(yr,r,dg);
dd0loop(r,dg) = dd0(yr,r,dg);
m0loop(r,dg) = m0(yr,r,dg);
x0loop(r,dg) = x0(yr,r,dg);
xn0loop(r,dg) = xn0(yr,r,dg);
xd0loop(r,dg) = xd0(yr,r,dg);
rx0loop(r,dg) = rx0(yr,r,dg);
md0loop(r,m,dg) = md0(yr,r,m,dg);
nm0loop(r,dg,m) = nm0(yr,r,dg,m);
dm0loop(r,dg,m) = dm0(yr,r,dg,m);
cd0loop(r,dg) = cd0(yr,r,dg);
i0loop(r,dg) = i0(yr,r,dg);
g0loop(r,dg) = g0(yr,r,dg);
bopdef0loop(r) = bopdef0(yr,r);
hhadjloop(r) = hhadj(yr,r);

cd0_hloop(r,dg,h) = cd0_h(yr,r,dg,h);
c0_hloop(r,h) = c0_h(yr,r,h);
le0loop(r,q,h) = le0(yr,r,q,h);
ke0loop(r,h) = ke0(yr,r,h);
tk0loop(r) = tk0(yr,r);
tl0loop(r,h) = tl0(yr,r,h);
sav0loop(r,h) = sav0(yr,r,h);
fsav0loop = fsav0(yr);
trn0loop(r,h) = trn0(yr,r,h);
hhtrn0loop(r,h,trn) = hhtrn0(yr,r,h,trn);

fvsloop(r,ds,'lab') = fvs(yr,r,ds,'lab');
fvsloop(r,ds,'cap') = fvs(yr,r,ds,'cap');
netgenloop(r) = netgen(r,yr,'seds');

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

display a0loop, rx0loop, nd0loop, dd0loop, m0loop, md0loop;

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
HHAD.L(r) = hhadjloop(r);
CD_H.L(r,dg,h) = cd0_hloop(r,dg,h);
WAGE.L(r,q,h) = le0loop(r,q,h);
INT.L(r,h) = ke0loop(r,h);
SAVE.L(r,h) = sav0loop(r,h);

* Set lower bounds on key variables:

YS.LO(r,ds,dg) = 0.1 * ys0loop(r,ds,dg);
ID.LO(r,dg,ds) = 0.1 * id0loop(r,dg,ds);
IMP.LO(r,dg) = 0.1 * m0loop(r,dg);
SUP.LO(r,dg) = 0.1 * s0loop(r,dg);
XD.LO(r,dg) = 0.1 * xd0loop(r,dg);
XN.LO(r,dg) = 0.1 * xn0loop(r,dg);
XPT.LO(r,dg) = 0.1 * x0loop(r,dg);
RX.LO(r,dg) = 0.1 * rx0loop(r,dg);
NM.LO(r,dg,m) = 0.1 * nm0loop(r,dg,m);
DM.LO(r,dg,m) = 0.1 * dm0loop(r,dg,m);
MARD.LO(r,m,dg) = 0.1 * md0loop(r,m,dg);
INV.LO(r,dg) = 0.5 * i0loop(r,dg);
INV.UP(r,dg) = 1.5 * i0loop(r,dg);
GD.LO(r,dg) = 0.1 * g0loop(r,dg);
CD.LO(r,dg) = 0.1 * cd0loop(r,dg);
CD_H.LO(r,dg,h) = 0.1 * cd0_hloop(r,dg,h);
WAGE.LO(r,q,h) = 0.1 * le0loop(r,q,h);
INT.LO(r,h) = 0.1 * ke0loop(r,h);
SAVE.LO(r,h) = 0.1 * sav0loop(r,h);

* Impose some zero restrictions:

RX.FX(r,dg)$(rx0loop(r,dg) = 0) = 0;
MARD.FX(r,m,dg)$(md0loop(r,m,dg) = 0) = 0;
NM.FX(r,ds,m)$(nm0loop(r,ds,m) = 0) = 0;
DM.FX(r,ds,m)$(dm0loop(r,ds,m) = 0) = 0;
YH.FX(r,dg)$(yh0loop(r,dg) = 0) = 0;

* Impose zero restrictions on household data (not included in zero penalty
* above):

CD_H.FX(r,dg,h)$(cd0_hloop(r,dg,h) = 0) = 0;
WAGE.FX(r,q,h)$(le0loop(r,q,h) = 0) = 0;
INT.FX(r,h)$(ke0loop(r,h) = 0) = 0;
SAVE.FX(r,h)$(sav0loop(r,h) = 0) = 0;

* Foreign electricity imports and exports are set to zero subject to SEDS
* data:

XPT.FX(r,'ele')$(x0loop(r,'ele') = 0) = 0;
IMP.FX(r,'ele')$(m0loop(r,'ele') = 0) = 0;
XPT.LO(r,'ele')$(x0loop(r,'ele') > 0) = 0.75 * x0loop(r,'ele');
IMP.LO(r,'ele')$(m0loop(r,'ele') > 0) = 0.75 * m0loop(r,'ele');

* If producing a state level model, fix electricity imports from the national
* market for Alaska and to zero:

$if %rmap%=="state" ND.FX(r,'ele')$(SAMEAS(r,'HI') or SAMEAS(r,'AK')) = 0;
$if %rmap%=="state" XN.FX(r,'ele')$(SAMEAS(r,'HI') or SAMEAS(r,'AK')) = 0;

* Provide an allowable range on how SEDS data can shift (including byproduts):

YS.LO(r,ioe,dg) = 0.5 * ys0loop(r,ioe,dg);
*.YS.UP(r,ioe,dg) = 1.5 * ys0loop(r,ioe,dg);
YS.FX(r,ioe,dg)$(ys0loop(r,ioe,dg) = 0) = 0;
YS.FX(r,dg,ioe)$(ys0loop(r,dg,ioe) = 0) = 0;
ID.FX(r,dg,ioe)$(id0loop(r,dg,ioe) = 0) = 0;
ID.LO(r,ioe,dg) = 0.5 * id0loop(r,ioe,dg);
ID.UP(r,ioe,dg) = 1.5 * id0loop(r,ioe,dg);
MARD.LO(r,m,ioe) = 0.5 * md0loop(r,m,ioe);
MARD.UP(r,m,ioe) = 1.5 * md0loop(r,m,ioe);
CD.LO(r,ioe) = 0.5 * cd0loop(r,ioe);
CD.UP(r,ioe) = 1.5 * cd0loop(r,ioe);

regcalib.savepoint = 1;
$if exist regcalib_p.gdx execute_loadpoint 'regcalib_p.gdx';

* Solve the iteration of the calibration procedure:

$IFTHENI.a1 "%matbal%" == 'huber'
$IFTHENI.a2 "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_nlp%' /;
PUT 'neos_server %neosserver%' /;
PUTCLOSE opt;
$ENDIF.a2

SOLVE regcalib using NLP minimizing OBJ;
$ENDIF.a1

$IFTHENI.b1 "%matbal%" == 'ls'
$IFTHENI.b2 "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_qcp%' /;
PUT 'neos_server %neosserver%';
PUT 'numericalemphasis 1' ;
PUTCLOSE opt;
$ENDIF.b2

regcalib.optfile = 1;
SOLVE regcalib using QCP minimizing OBJ;
$ENDIF.b1

ABORT$(regcalib.modelstat > 2) "Optimal solution not found.";

* Reset parameter values (uncomment if running as a loop):

* ys0(yr,r,ds,dg) = YS.L(r,ds,dg);
* id0(yr,r,dg,ds) = ID.L(r,dg,ds);
* ld0(yr,r,ds) = LD.L(r,ds);
* kd0(yr,r,ds) = KD.L(r,ds);
* a0(yr,r,dg) = ARM.L(r,dg);
* nd0(yr,r,dg) = ND.L(r,dg);
* dd0(yr,r,dg) = DD.L(r,dg);
* m0(yr,r,dg) = IMP.L(r,dg);
* s0(yr,r,dg) = SUP.L(r,dg);
* xd0(yr,r,dg) = XD.L(r,dg);
* xn0(yr,r,dg) = XN.L(r,dg);
* x0(yr,r,dg) = XPT.L(r,dg);
* rx0(yr,r,dg) = RX.L(r,dg);
* nm0(yr,r,dg,m) = NM.L(r,dg,m);
* dm0(yr,r,dg,m) = DM.L(r,dg,m);
* md0(yr,r,m,dg) = MARD.L(r,m,dg);
* yh0(yr,r,dg) = YH.L(r,dg);
* cd0(yr,r,dg) = CD.L(r,dg);
* i0(yr,r,dg) = INV.L(r,dg);
* g0(yr,r,dg) = GD.L(r,dg);
* bopdef0(yr,r) = BOP.L(r);
* cd0_h(yr,r,dg,h) = CD_H.L(r,dg,h);
* le0(yr,r,q,h) = WAGE.L(r,q,h);
* ke0(yr,r,h) = INT.L(r,h);
* sav0(yr,r,h) = SAVE.L(r,h);

* Reset variables boundaries:

* RX.LO(r,dg) = 0;
* RX.UP(r,dg) = inf;
* XPT.LO(r,'ele') = 0;
* XPT.UP(r,'ele') = inf;
* IMP.LO(r,'ele') = 0;
* IMP.UP(r,'ele') = inf;
* ND.LO(r,'ele') = 0;
* ND.UP(r,'ele') = inf;
* XN.LO(r,'ele') = 0;
* XN.UP(r,'ele') = inf;
* YS.LO(r,ds,dg) = 0;
* YS.UP(r,ds,dg) = inf;
* MARD.LO(r,m,dg) = 0;
* MARD.UP(r,m,dg) = inf;
* CD.LO(r,dg) = 0;
* CD.UP(r,dg) = inf;
* ID.LO(r,dg,ds) = 0;
* ID.UP(r,dg,ds) = inf;
 
);



* Assign solution values to loop parameter:

ys0loop(r,ds,dg) = YS.L(r,ds,dg);
id0loop(r,dg,ds) = ID.L(r,dg,ds);
ld0loop(r,ds) = LD.L(r,ds);
kd0loop(r,ds) = KD.L(r,ds);
ty(r,dg) = ty0('%bnyear%',r,dg);
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
hhadjloop(r) = HHAD.L(r);
ta(r,dg) = ta0('%bnyear%',r,dg);
tm(r,dg) = tm0('%bnyear%',r,dg);
c0loop(r) = sum(dg, cd0loop(r,dg));
cd0_hloop(r,dg,h) = CD_H.L(r,dg,h);
le0loop(r,q,h) = WAGE.L(r,q,h);
ke0loop(r,h) = INT.L(r,h);
sav0loop(r,h) = SAVE.L(r,h);


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

dataconschk(r,h,'c0_h','new') = sum(dg, cd0_hloop(r,dg,h));
dataconschk(r,h,'le0','new') = sum(q, le0loop(r,q,h));
dataconschk(r,h,'ke0','new') = ke0loop(r,h);
dataconschk(r,h,'sav0','new') = sav0loop(r,h);
display dataconschk;

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

* Verify that byproducts are not spuriously generated:

PARAMETER bychk "Check on byproducts";

bychk(r,ds,'primary') = ys0loop(r,ds,ds);
bychk(r,ds,'orig prim') = saveys0('%bnyear%',r,ds,ds);
bychk(r,dg,'byproduct') = sum(ds$(not sameas(ds,dg)), ys0loop(r,ds,dg));
bychk(r,dg,'orig byproduct') = sum(ds$(not sameas(ds,dg)), saveys0('%bnyear%',r,ds,dg));
bychk(r,ds,'cal %')$bychk(r,ds,'primary') = 100 * bychk(r,ds,'byproduct')/bychk(r,ds,'primary');
bychk(r,ds,'orig %')$saveys0('%bnyear%',r,ds,ds) = 100 * sum(dg$(not sameas(ds,dg)), saveys0('%bnyear%',r,dg,ds)) / saveys0('%bnyear%',r,ds,ds);
bychk(r,ds,'diff') = bychk(r,ds,'cal %') - bychk(r,ds,'orig %');
display bychk;


* -------------------------------------------------------------------
* assess change in household data
* -------------------------------------------------------------------

* First assign exogenous parameters to loop:

c0_hloop(r,h) = sum(dg, CD_H.L(r,dg,h));
trn0loop(r,h) = trn0('%bnyear%',r,h);
hhtrn0loop(r,h,trn) = hhtrn0('%bnyear%',r,h,trn);
poploop(r,h) = pop('%bnyear%',r,h);

PARAMETER hhdatachk "Check on household data parameters";
PARAMETER wagechk "Check on bilateral wages";
PARAMETER cd0chk "Check on individual demands";

hhdatachk(r,h,'c0_h','old') = dataconschk(r,h,'c0_h','old');
hhdatachk(r,h,'c0_h','new') = sum(dg, CD_H.L(r,dg,h));

hhdatachk(r,h,'le0','old') = dataconschk(r,h,'le0','old');
hhdatachk(r,h,'le0','new') = sum(q, WAGE.L(r,q,h));

hhdatachk(r,h,'ke0','old') = dataconschk(r,h,'ke0','old');
hhdatachk(r,h,'ke0','new') = INT.L(r,h);

hhdatachk(r,h,'sav0','old') = dataconschk(r,h,'sav0','old');
hhdatachk(r,h,'sav0','new') = SAVE.L(r,h);
display hhdatachk;

wagechk(r,q,h,'old') = le0('%bnyear%',r,q,h);
wagechk(r,q,h,'new') = WAGE.L(r,q,h);
display wagechk;

cd0chk(r,dg,h,'old') = cd0_h('%bnyear%',r,dg,h);
cd0chk(r,dg,h,'new') = CD_H.L(r,dg,h);
display cd0chk;

* -------------------------------------------------------------------
* output regionalized dataset calibrated to SEDS with households:
* -------------------------------------------------------------------

execute_unload 'datasets%sep%WiNDC_bluenote_%hhdata%_%rmap%_%bnyear%.gdx',

* Sets:

r,ds=s,m,h,trn,

* Production data:

ys0loop=ys0,ld0loop=ld0,kd0loop=kd0,id0loop=id0,ty=ty0,

* Consumption data:

yh0loop=yh0,c0loop=c0,cd0loop=cd0,i0loop=i0,g0loop=g0,bopdef0loop=bopdef0,hhadjloop=hhadj,

* Household data:

poploop=pop, le0loop=le0, ke0loop=ke0, tk0loop=tk0, tl0loop=tl0, cd0_hloop=cd0_h, c0_hloop=c0_h,
sav0loop=sav0, fsav0loop=fsav0, trn0loop=trn0, hhtrn0loop=hhtrn0,

* Trade data:

s0loop=s0,xd0loop=xd0,xn0loop=xn0,x0loop=x0,rx0loop=rx0,a0loop=a0,
nd0loop=nd0,dd0loop=dd0,m0loop=m0,ta=ta0,tm=tm0,

* Margins:

md0loop=md0,nm0loop=nm0,dm0loop=dm0,

* Emissions:

resco2, secco2;
