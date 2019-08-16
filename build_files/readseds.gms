$TITLE	Read and partition the SEDS dataset

$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

$ONTEXT
		State Energy Data System (SEDS)

Data Series Names (MSN) and Descriptions:
	- The MSNs are five-character codes, most of which are structured
          as follows:
	- First and second characters - describes an energy source (for
          example, NG for natural gas, MG for motor gasoline)
	- Third and fourth characters - describes an energy sector or an
	  energy activity (for example, RC for residential consumption, PR
	  for production)
	- Fifth character - describes a type of data (for example, P for
	  data in physical unit, B for data in billion Btu)

Commercial sector:

An energy-consuming sector that consists of service-providing
facilities and equipment of: businesses; federal, state, and local
governments; and other private and public organizations, such as
religious, social, or fraternal groups. The commercial sector includes
institutional living quarters. It also includes sewage treatment
facilities. Common uses of energy associated with this sector include
space heating, water heating, air conditioning, lighting,
refrigeration, cooking, and running a wide variety of other equipment.
Note: This sector includes generators that produce electricity and/or
useful thermal output primarily to support the activities of the
above-mentioned commercial establishments.

Industrial sector:

An energy-consuming sector that consists of all facilities and
equipment used for producing, processing, or assembling goods.  The
industry setor encompasses the following types of activity:
manufacturing (NAICS codes 31-33); agriculture, forestry, fishing, and
hunting (NAICS code 11); mining, including oil and gas extraction
(NAICS code 21); and construction (NAICS code 23).  Overall energy use
in this sector is largely for process heat and cooling and powering
machinery, with lesser amounts used for facility heating, air
conditioning, and lighting. Fossil fuels are also used as raw material
inputs to manufactured products. Note: This sector includes generators
that produce electricity and/or useful thermal output primarily to
support the above-mentioned industrial activities.

Transportation sector:

An energy-consuming sector that consists of all vehicles whose primary
purpose is transporting people and/or goods from one physical location
to another. Included are automobiles; trucks; buses; motorcycles;
trains, subways, and other rail vehicles; aircraft; and ships, barges,
and other waterborne vehicles. Vehicles whose primary purpose is not
transportation (e.g., construction cranes and bulldozers, farming
vehicles, and warehouse tractors and forklifts) are classified in the
sector of their primary use. In this report, natural gas used in the
operation of natural gas pipelines is included in the transportation
sector.

Electric power sector:

An energy-consuming sector that consists of electricity-only and
combined-heat-and-power plants within the NAICS (North American
Industry Classification System) 22 category whose primary business is
to sell electricity, or electricity and heat, to the public. Note:
This sector includes electric utilities and independent power
producers.

The State Codes are 2-character codes, following the U.S. Postal
Service State abbreviations. Geographic areas used throughout SEDS
includes the 50 States and the District of Columbia, and the United
States.  For production of crude oil and natural gas, Federal offshore
regions are identified by X3 and X5.
$OFFTEXT

* Read in raw CFS data, map to sector list and generate RPCs to be used in disagg.gms.

SET source "Dynamically created set from seds_units parameter, EIA SEDS source codes";
SET sector "Dynamically created set from seds_units parameter, EIA SEDS sector codes";
SET co2dim "Dynamically created set from emissions_units parameter, EIA C02 sector codes";
SET src "SEDS energy technologies";

SET g "BEA Goods and sectors categories";
SET sr "Super set of Regions (states + US) in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";
SET yr "Years in WiNDC Database"


PARAMETER seds_units(source,sector,sr,yr,*) "Complete EIA SEDS data, with units as domain";
PARAMETER heatrate_units(yr,*,*) "EIA Elec Generator average heat rates, with units as domain";
PARAMETER emissions_units(co2dim,r,yr,*) "CO2 emissions, with units as domain";
PARAMETER co2perbtu_units(*,*) "Carbon dioxide -- not CO2e -- content, with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD src=seds_src
$LOAD sr
$LOAD r
$LOAD yr
$LOAD source<seds_units.dim1
$LOAD sector<seds_units.dim2
$LOAD seds_units
$LOAD heatrate_units
$LOAD co2dim<emissions_units.dim1
$LOAD emissions_units
$LOAD co2perbtu_units
$GDXIN


* PA	"All Petroleum Products" -- See documentation for discription.
SET petr(source) "Petroleum products" /
	AR	"Asphalt and road oil"
	AV	"Aviation gasoline"
	DF	"Distillate fuel oil"
	JF	"Jet fuel"
	KS	"Kerosene"
	HL	"Hydrocarbon gas liquids"
	LU	"Lubricants"
	MG	"Motor gasoline"
	OP 	"Other petroleum products"
	PC	"Petroleum coke"
	RF	"Residual fuel oil" /;

SET s(sector) "End use sectors" /
	RC	"Residential sector"
	CC	"Commercial sector"
	IC	"Industrial sector"
	AC	"Transportation sector"
	EI	"Electric power sector" /;

SET petruse(source,*) "Mapping energy sources with demand categories" /
	(DF,HL,KS).RC			  "Residential sector"
	(DF,HL,KS,MG,RF,PC).CC		  "Commercial sector"
	(AR,DF,HL,KS,LU,MG,OP,PC,RF).IC	  "Industrial sector"
	(AV,DF,HL,JF,LU,MG,RF).AC	  "Transportation sector"
	(DF,PC,RF).EI		  "Electric power sector"
	(AR,AV,DF,HL,JF,KS,LU,MG,OP,PC,RF).TOTAL "All" /;

PARAMETER pet_chk "Cross check on petroleum demand";
PARAMETER pet_prc "Petroleum price";

pet_chk(petruse(petr,s)) = sum(sr, seds_units(petr,s,sr,'2016','billion btu'));
pet_prc(petruse(petr,s)) = sum(sr, seds_units(petr,s,sr,'2016','dollars per million btu'));

pet_chk(petr,'rowsum') = sum((sr,petruse(petr,s)), seds_units(petr,s,sr,'2016','billion btu'));

pet_chk(petr,'rowchk')$(NOT SAMEAS(petr,'PC'))
	= sum((sr,petruse(petr,s)), seds_units(petr,s,sr,'2016','billion btu')) - sum(sr, seds_units(petr,'TC',sr,'2016','billion btu'));

* TC: Total consumption. The above calculates how far off the listed
* disaggregate data is with provided totals. Hopefully the residual is due
* to rounding.

pet_chk('PO','rowchk') =
	sum(petruse(petr,s)$(SAMEAS(petr,'PO') OR SAMEAS(petr,'PC')), sum(sr, seds_units(petr,s,sr,'2016','billion btu'))) -
	sum(petruse(petr,"total")$(SAMEAS(petr,'PO') OR SAMEAS(petr,'PC')), sum(sr, seds_units(petr,'TC',sr,'2016','billion btu')));

pet_chk('colsum',s) = sum((sr,petruse(petr,s)), seds_units(petr,s,sr,'2016','billion btu'));

pet_chk('colchk',s) = sum((sr,petruse(petr,s)), seds_units(petr,s,sr,'2016','billion btu')) - sum(sr, seds_units('PA',s,sr,'2016','billion btu'));


* The column check verifies that summing across all petroleum type goods
* is equivalent to the listed total. Row check sums across demanding
* sectors for each petroleum product.

pet_prc('PA',s)$sum(sr, seds_units('PA',s,sr,'2016','billion btu'))
	= sum(sr, seds_units('PA',s,sr,'2016','billion btu') * seds_units('PA',s,sr,'2016','dollars per million btu')) / sum(sr, seds_units('PA',s,sr,'2016','billion btu'));

OPTION pet_chk:0;
DISPLAY pet_chk, pet_prc;


PARAMETER elechk "Check on electricity data";

* EX: exported from US.
* IM: imported into US.
* NI: Net imports expenditures.
* IS: industrial sector excluding refinery fuel.
* TC: total consumption.
* EL: Electricity aggregates
* ES: Also Electricity. (sector related categories)
* LO: Electrical system energy loss.

elechk(sr,'EX') = seds_units('EL','EX',sr,'2016','billion btu');
elechk(sr,'IM') = seds_units('EL','IM',sr,'2016','billion btu');
elechk(sr,'NI') = seds_units('EL','NI',sr,'2016','billion btu');
elechk(sr,'IS') = seds_units('EL','IS',sr,'2016','billion btu');
elechk(sr,'LO') = seds_units('LO','TC',sr,'2016','billion btu');
elechk(sr,'TC') = seds_units('ES','TC',sr,'2016','billion btu');
elechk(sr,'C') = sum(s, seds_units('ES',s,sr,'2016','billion btu'));
elechk(sr,'PR') = sum(s, seds_units('ES',s,sr,'2016','billion btu')) - seds_units('EL','IS',sr,'2016','billion btu')- seds_units('EL','NI',sr,'2016','billion btu');


PARAMETER elegen "Electricity generation by source (mill. btu or tkwh for ele)";

loop(sr,

* Initial data is in billions of btu. Scaling by htrate converts to billions of kwh.

	elegen(sr,'col',yr) = seds_units('CL','EI',sr,yr,'billion btu') / heatrate_units(yr,'col','btu per kWh generated');
	elegen(sr,'gas',yr) = seds_units('NG','EI',sr,yr,'billion btu') / heatrate_units(yr,'gas','btu per kWh generated');
	elegen(sr,'oil',yr) = seds_units('PA','EI',sr,yr,'billion btu') / heatrate_units(yr,'oil','btu per kWh generated');

* Initial data is in millions of kwh. Scaling by 1000 converts to billions of kwh.

	elegen(sr,'NU',yr) = seds_units('NU','EG',sr,yr,'million kilowatthours') / 1000;
	elegen(sr,'HY',yr) = seds_units('HY','EG',sr,yr,'million kilowatthours') / 1000;
	elegen(sr,'GE',yr) = seds_units('GE','EG',sr,yr,'million kilowatthours') / 1000;
	elegen(sr,'SO',yr) = seds_units('SO','EG',sr,yr,'million kilowatthours') / 1000;
	elegen(sr,'WY',yr) = seds_units('WY','EG',sr,yr,'million kilowatthours') / 1000;
);



elegen('total',src,yr) = sum(sr, elegen(sr,src,yr));
elegen(sr,'total',yr) = sum(src, elegen(sr,src,yr));
elegen('total','total',yr) = sum(src, elegen('total',src,yr));

DISPLAY elegen;


PARAMETER gas_chk "Cross check on natural gas demand"
PARAMETER gas_prc "Gas price";

gas_chk(s) = sum(sr, seds_units('NG',s,sr,'2016','billion btu')) / 1e6;
gas_chk('demand') = sum(s, gas_chk(s));
gas_chk('supply') = sum(sr, seds_units('NG','MP',sr,'2016','billion btu')) / 1e6;
DISPLAY gas_chk;

gas_prc(sr,s)$seds_units('NG',s,sr,'2016','billion btu') = seds_units('NG',s,sr,'2016','dollars per million btu') + eps;
DISPLAY gas_prc;

SET col(source) "Coal Index" / CL /;

PARAMETER col_chk "Cross check on coal demand"
PARAMETER col_prc "Coal price";

col_chk(s) = sum(sr, seds_units('CL',s,sr,'2016','billion btu')) / 1000;
col_chk('demand') = sum(s, col_chk(s));
col_chk('supply') = sum(sr, seds_units('CL','PR',sr,'2016','billion btu')) / 1000;
col_chk('ccexb') =  sum(sr, seds_units('CC','EX',sr,'2016','billion btu')) / 1000;
col_chk('ccimb') =  sum(sr, seds_units('CC','IM',sr,'2016','billion btu')) / 1000;
col_chk('ccexp') =  sum(sr, seds_units('CC','EX',sr,'2016','thousand short tons')) / 1000;
col_chk('ccimp') =  sum(sr, seds_units('CC','IM',sr,'2016','thousand short tons')) / 1000;

SET sec "End use sectors" /
	res	"Residential sector"
	com	"Commercial sector"
	ind	"Industrial sector"
	trn	"Transportation sector"
	ele	"Electric power sector" /;

SET secmap(sec,s) "Remapping nameas" /
	res.RC	"Residential sector"
	com.CC	"Commercial sector"
	ind.IC	"Industrial sector"
	trn.AC	"Transportation sector"
	ele.EI	"Electric power sector" /;

PARAMETER fuelexpend "Fuel expenditures in electric utilities";
PARAMETER fueluse "Fuel useitures in electric utilities";
PARAMETER fuelprice "Fuel price in electric utilities";

fuelexpend('col',sr,yr) = seds_units('CL','EI',sr,yr,'million dollars');
fuelexpend('gas',sr,yr) = seds_units('NG','EI',sr,yr,'million dollars');
fuelexpend('oil',sr,yr) = seds_units('PA','EI',sr,yr,'million dollars');

fueluse('col',sr,yr) = seds_units('CL','EI',sr,yr,'billion btu') / 1000;
fueluse('gas',sr,yr) = seds_units('NG','EI',sr,yr,'billion btu') / 1000;
fueluse('oil',sr,yr) = seds_units('PA','EI',sr,yr,'billion btu') / 1000;

fuelprice('col',sr,yr)$fueluse('col',sr,yr) = fuelexpend('col',sr,yr) / fueluse('col',sr,yr) + eps;
fuelprice('gas',sr,yr)$fueluse('gas',sr,yr) = fuelexpend('gas',sr,yr) / fueluse('gas',sr,yr) + eps;
fuelprice('oil',sr,yr)$fueluse('oil',sr,yr) = fuelexpend('oil',sr,yr) / fueluse('oil',sr,yr) + eps;

SET e "Energy sectors" / oil,gas,col,ele,cru /;
SET ff(e) "Fossil Fuels" / col,gas,oil /;
SET pq "Price vs. quantities" / p,q /;
SET ed(*) "Energy data" / supply, set.sec, ref /;

PARAMETER ngp;
ngp(sr,'d',sec) = sum(secmap(sec,s), seds_units('NG',s,sr,'2016','dollars per million btu'));
ngp(sr,'v',sec) = sum(secmap(sec,s), seds_units('NG',s,sr,'2016','million dollars'));
ngp(sr,'b',sec) = sum(secmap(sec,s), seds_units('NG',s,sr,'2016','billion btu'));
ngp(sr,'d*b',sec) = sum(secmap(sec,s), seds_units('NG',s,sr,'2016','billion btu') * seds_units('NG',s,sr,'2016','dollars per million btu'));

OPTION ngp:1:1:2;
DISPLAY ngp;

* Btu prices for states are calculated by dividing the physical unit prices by the
* conversion factor 3,412 Btu per kilowatthour. U.S. Btu prices are calculated as
* the average of the state Btu prices, weighted by consumption data from SEDS,
* adjusted for process fuel consumption in the industrial sector.

* Note that electricity data is in billions of kwh.

PARAMETER energydata(sr,pq,e,*,yr) "Benchmark energy data (trillion btu and $ per btu)";

loop(sr,

* Supply data is in trillions of btu.

	energydata(sr,'q','gas','supply',yr) = seds_units('NG',"MP",sr,yr,'billion btu') / 1000;
	energydata(sr,'q','cru','supply',yr) = seds_units('PA','PR',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','col','supply',yr) = seds_units('CL','PR',sr,yr,'billion btu') / 1000;

* Supply of electricity is in billions of kwh.

	energydata(sr,'q','ele','supply',yr) = sum(src, elegen(sr,src,yr));

* Sector level demands of electricity are scaled to be in billions of kwh.

	energydata(sr,'q','ele',ed(sec),yr) = sum(secmap(sec,s), seds_units('ES',s,sr,yr,'million kilowatthours')) / 1000;

* Sector level demands of gas, coal and oil in trillions of btu's.

	energydata(sr,'q','gas',ed(sec),yr) = sum(secmap(sec,s), seds_units('NG',s,sr,yr,'billion btu')) / 1000;
	energydata(sr,'q','oil',ed(sec),yr) = sum(secmap(sec,s), seds_units('PA',s,sr,yr,'billion btu')) / 1000;
	energydata(sr,'q','oil','trn',yr) = sum(petruse(source,"AC"), seds_units(source,"ac",sr,yr,'billion btu')) / 1000;
	energydata(sr,'q','col',ed(sec),yr) = sum(secmap(sec,s), seds_units('CL',s,sr,yr,'billion btu')) / 1000;

	energydata(sr,'q','col','ele',yr) = seds_units('CL','EI',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','gas','ele',yr) = seds_units('NG','EI',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','oil','ele',yr) = seds_units('PA','EI',sr,yr,'billion btu') / 1000;

* Refinery demands are included in the industrial category. See appendix
* in documentation.

	energydata(sr,'q','gas','ref',yr) = seds_units('NG','RF',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','gas','ind',yr) = energydata(sr,'q','gas','ind',yr) - energydata(sr,'q','gas','ref',yr);

	energydata(sr,'q','col','ref',yr) = seds_units('CL','RF',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','col','ind',yr) = energydata(sr,'q','col','ind',yr) - energydata(sr,'q','col','ref',yr);

* Amount of refined oil used in other refining processes include LPG +
* Distillate Fuel + Petroleum Coke + Residual Fuel Oil.

	energydata(sr,'q','oil','ref',yr) =
		(seds_units('DF','RF',sr,yr,'billion btu') + seds_units('HL','RF',sr,yr,'billion btu') +
		 seds_units('PC','RF',sr,yr,'billion btu') + seds_units('RF','RF',sr,yr,'billion btu') ) / 1000;

	energydata(sr,'q','cru','ind',yr) = seds_units('CO','IC',sr,yr,'billion btu') / 1000;

* Assume that the amount of crude oil consumed in the production of
* refined oils is equal to the sum of other types of oils consumed in the
* refining process.

	energydata(sr,'q','cru','ref',yr) = seds_units('P5','RF',sr,yr,'billion btu') / 1000;
	energydata(sr,'q','oil','ind',yr) = energydata(sr,'q','oil','ind',yr) - energydata(sr,'q','oil','ref',yr);

* Need to include electricity sales to refineries.
*	= electricity consumed by refineries (trillion btu) *
*	(elec consumed by ind sector (million kwh) / elec consumed by ind
*	sector (billion btu))
* In doing so, convert trillion btu's to billions of kwh in line with the
* above data.

	energydata(sr,'q','ele','ref',yr) = seds_units('ES','RF',sr,yr,'billion btu') / 1000 *
		(seds_units('ES','IC',sr,yr,'million kilowatthours') / seds_units('ES','IC',sr,yr,'billion btu'));

	energydata(sr,'q','ele','ind',yr) = energydata(sr,'q','ele','ind',yr) - energydata(sr,'q','ele','ref',yr);

* Prices in dollars per million btu. Crude oil energy prices? No. Keeping
* these units, multiplying price x quantity will result in millions of
* dollars.

	energydata(sr,'p','gas',ed(sec),yr) = sum(secmap(sec,s), seds_units('NG',s,sr,yr,'dollars per million btu'));
	energydata(sr,'p','oil',ed(sec),yr) = sum(secmap(sec,s), seds_units('PA',s,sr,yr,'dollars per million btu'));
	energydata(sr,'p','col',ed(sec),yr) = sum(secmap(sec,s), seds_units('CL',s,sr,yr,'dollars per million btu'));

 	energydata(sr,'p','col','ele',yr)$seds_units('CL','EI',sr,yr,'billion btu') = seds_units('CL','EI',sr,yr,'million dollars') / (seds_units('CL','EI',sr,yr,'billion btu') / 1000);

	energydata(sr,'p','gas','ele',yr)$seds_units('NG','EI',sr,yr,'billion btu') = seds_units('NG','EI',sr,yr,'million dollars') / (seds_units('NG','EI',sr,yr,'billion btu') / 1000);

	energydata(sr,'p','oil','ele',yr)$seds_units('PA','EI',sr,yr,'billion btu') = seds_units('PA','EI',sr,yr,'million dollars') / (seds_units('PA','EI',sr,yr,'billion btu') / 1000);


* Prices of electricity are millions of dollars per thousand kilowatt
* hours. Not quite. Millions of dollars divided by billions of kwh. So the
* price for electricity is dollars per thousand kwh as written below. If I
* keep these units, by multiplying by quantity, will end up with millions
* of dollars.

	energydata(sr,'p','ele',ed(sec),yr)$energydata(sr,'q','ele',ed,yr)
		 = sum(secmap(sec,s), seds_units('ES',s,sr,yr,'million dollars')) / energydata(sr,'q','ele',ed,yr);

);

OPTION energydata:3:3:1;
DISPLAY energydata;

* Report the inputs to refinery fuels:

PARAMETER refinputs "Inputs to Refinery Fuel (RF)";

refinputs('DF',sr,yr) = seds_units('DF','RF',sr,yr,'billion btu');
refinputs('HL',sr,yr) = seds_units('HL','RF',sr,yr,'billion btu');
refinputs('PC',sr,yr) = seds_units('PC','RF',sr,yr,'billion btu');
refinputs('RF',sr,yr) = seds_units('RF','RF',sr,yr,'billion btu');
refinputs('P5',sr,yr) = seds_units('P5','RF',sr,yr,'billion btu');

EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%refinputs.gdx',refinputs;


* Taken from https://www.eia.gov/environment/emissions/co2_vol_mass.cfm:

PARAMETER totals "BTU use totals";

* Scaling to billions of btus. Note that 1000kg = 1 metric tonne -->
* Totals below are denominated in metric tonnes.

totals(e,yr,'seds_btu') = sum((r,ed(sec)), energydata(r,'q',e,ed,yr)) / 1000;
totals(ed(sec),yr,'seds_btu') = sum((r,e), energydata(r,'q',e,ed,yr)) / 1000;

totals(e,yr,'seds_co2') = sum((r,ed(sec)), energydata(r,'q',e,ed,yr)) / 1000 * co2perbtu_units(e,'kilograms CO2 per million btu');
totals(ed(sec),yr,'seds_co2') = sum((r,e), energydata(r,'q',e,ed,yr) / 1000 * co2perbtu_units(e,'kilograms CO2 per million btu'));


* Only output data for 50 states + Distric of Columbia:
* Compare calculated emissions from SEDS with published CO2 emissionsn
* from EPA:


totals(co2dim,yr,'epa') = sum(r, emissions_units(co2dim,r,yr,'million metric tons of carbon dioxide'));

OPTION totals:1:2:1;
DISPLAY totals;

* Report other aggregate social and economic data in SEDS:
PARAMETER otherdata "Other SEDS data";

otherdata(sr,'rgdp',yr) = seds_units('GD','PR',sr,yr,'million chained (2009) dollars') / 1000 + eps;
otherdata(sr,'gdp',yr) = seds_units('GD','PR',sr,yr,'million dollars') / 1000 + eps;
otherdata(sr,'pop',yr) = seds_units('TP','OP',sr,yr,'thousand') + eps;

* Only output data from 1997-2016 in accordance with national Input Output
* tables for the United States.


PARAMETER sedsenergy(r,pq,e,ed,yr) "SEDS energy data for IO integration";
PARAMETER sedsother(r,*,yr) "Other SEDS data";
PARAMETER sedsco2compare(co2dim,yr,*) "CO2 comparison between computed and EPA estimates";
PARAMETER co2emis(r,yr,*,*,*) "CO2 regional emissions by source";

ALIAS(u,*);

* just converting names here to be a bit more explicit
sedsenergy(r,pq,e,ed,yr) = energydata(r,pq,e,ed,yr);
sedsother(r,u,yr) = otherdata(r,u,yr);
sedsco2compare(co2dim,yr,u) = totals(co2dim,yr,u);
co2emis(r,yr,co2dim,'total','epa') = emissions_units(co2dim,r,yr,"million metric tons of carbon dioxide");
co2emis(r,yr,e,sec,'seds') = energydata(r,'q',e,sec,yr) / 1000 * co2perbtu_units(e,'kilograms CO2 per million btu');

EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%seds.gdx', sedsenergy, sedsother, sedsco2compare, co2emis,
    elegen, src, e, sec, co2dim;
