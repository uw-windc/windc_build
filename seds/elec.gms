$title	Read the ELEC Dataset (U.S. Electricity)

set	seq /0*99999/;

set	m	Month  /01*12/
	q	Quarter /q1*q4/,
	yr	Year /2001*2023/;

$if not exist ELEC.gdx $call gams readbulk --dataset=ELEC

$gdxin 'ELEC.gdx'

set
  t  'date/year'
  id 'series_id from txt file, explanatory text has name'
  e  'error strings where we have for NA (not available)'
  errors(id,t,e<) 'could not extract a value from these';

parameter
   series(id,t<) 'data for each series';

$load id 
$loaddc series errors

option id:0:0:1;
display id;

option t:0:0:15;
display t;

set	r	Regions /
	CA, CT, SC, AL, AR, AZ, CO, DE, FL, GA, HI, IA, ID, IL, IN, KS, KY,
	LA, MA, MD, ME, MI, MN, MO, MS, NC, NE, NH, NJ, NM, NV, NY, OH, OK,
	PA, TN, US, UT, VA, WI, WV, WY, AK, MT, ND, OR, RI, SD, TX, WA, DC, VT, 

	NEW	New England
	MAT	Middle Atlantic
	SAT	South Atlantic
	ENC	East North Central
	ESC	East South Central
	WNC	West North Central
	WSC	West South Central
	MTN	Mountain
	PCC	Pacific Contiguous
	PCN	Pacific Noncontiguous/,

	st(r)	States /
	CA, CT, SC, AL, AR, AZ, CO, DE, FL, GA, HI, IA, ID, IL, IN, KS, KY,
	LA, MA, MD, ME, MI, MN, MO, MS, NC, NE, NH, NJ, NM, NV, NY, OH, OK,
	PA, TN, UT, VA, WI, WV, WY, AK, MT, ND, OR, RI, SD, TX, WA, DC, VT/

	census(r) Census Divisions /
		NEW	New England
		MAT	Middle Atlantic
		SAT	South Atlantic
		ENC	East North Central
		ESC	East South Central
		WNC	West North Central
		WSC	West South Central
		MTN	Mountain
		PCC	Pacific Contiguous
		PCN	Pacific Noncontiguous /;

set     rmap(census,st)      Mapping of census regions to states /
		NEW.(ct,me,ma,nh,ri,vt)
		MAT.(nj,ny,pa)
		ENC.(il,in,mi,oh,wi)
		WNC.(ia,ks,mn,mo,ne,nd,sd)
		SAT.(de,fl,ga,md,dc,nc,sc,va,wv)
		ESC.(al,ky,ms,tn)
		WSC.(ar,la,ok,tx)
		MTN.(az,co,id,mt,nv,nm,ut,wy)
		PCC.(ca,or,wa) 
		PCN.(ak,hi) /;

set s	Sectors /
		ALL	All sectors
		COM	Commercial
		IND	Industrial
		RES	Residential
		TRA	Transportation
		OTH	Other /;

set	pfuel	Plant-level fuels /
		SC	Synthetic coal
		ALL	All fuels
		BIT	Bituminous coal
		NG	Natural gas
		PC	Petroleum coke
		SUB	Subbituminous coal
		WO	"Waste/other oil"
		OTH	Other
		WH	Waste heat
		WND	Wind
		DFO	Distillate fuel oil
		MSB	Biogenic municipal solid waste
		MSN	Non-biogenic municipal solid waste
		MSW	Municipal solid waste
		WAT	Conventional hydroelectric
		BLQ	Black liquour
		OBS	Other biomass solids
		RFO	Residual fuel oil
		SLW	Sludge waste
		WDS	"Wood/wood waste solids"
		GEO	Geothermal
		OBG	Other biomass gas
		SUN	Solar
		JF	Jet fuel
		KER	Kerosene
		LFG	Landfill gas
		SGC	Coal-derived synthetic gas
		PG	Gaseous propane
		OG	Other gas
		WC	"Waste/other coal"
		OBL	Other biomass liquids
		MWH	Batteries or other use of electricity as an energy source
		TDF	Tire-derived fuels
		BFG	Blast furnace gas
		AB	Agricultural by-products
		PUR	Purchased steam
		LIG	Lignite coal
		WDL	Wood waste liquids ex. black liqour
		NUC	Nuclear
		RC	Refined coal
		SGP	?
		H2	? /

	ptech	Plant technology /
		CA	Combined-cycle - steam part
		CT	Combined-cycle combustion turbine part
		ALL	All primemovers
		ST	Steam turbine
		WT	"Wind turbine, onshore"
		GT	Combustion (gas) turbine (including jet engine design)
		IC	"Internal combustion (diesel, piston) engine"
		HY	Hydraulic turbine
		BT	Turbines used in a binary cycle
		PV	Photovoltaic
		BA	?
		CP	"Energy storage, concentrated solar power"
		OT	Other
		CS	Fuel cell
		CC	?
		FW	?
		WS	"Wind turbine, offshore"
		CE	Compressed air energy storage 
		FC	Fuel cell/;

set	ti	Time interval /
		A	Annual,
		M	Monthly,
		Q	Quarterly /;

set	eledat	/
		GEN             Net generation

		CONS_EG         Consumption for electricity generation
		CONS_EG_BTU     Consumption for electricity generation (BTU)

		CONS_UTO        Consumption for useful thermal output
		CONS_UTO_BTU    Consumption for useful thermal output (BTU)

		CONS_TOT        Total consumption
		CONS_TOT_BTU    Total consumption (BTU)

		COST            Average cost of fossil fuels for electricity generation
		COST_BTU        Average cost of fossil fuels for electricity generation (per BTU)

		RECEIPTS        Receipts of fossil fuels by electricity plants
		RECEIPTS_BTU    Receipts of fossil fuels by electricity plants (BTU)

		STOCKS          Fossil-fuel stocks for electricity generation

		ASH_CONTENT     Ash content of fossil fuels in electricity generation
		SULFUR_CONTENT  Sulfur content of fossil fuels in electricity generation/,

	fuel /	ALL	All fuels

		NG	Natural gas
		OOG	Other gases 
		PEL	Petroleum liquids 

		COW	Coal 
		COL	Coal  
		LIG	Lignite coal 
		BIT	Bituminous coal
		PC	Petroleum coke
		SUB	Subbituminous coal
		BIS	Bituminous coal 

		NUC	Nuclear 

		HYC	Conventional hydroelectric 
		HPS	Hydro-electric pumped storage 

		TSN	All solar 
		SUN	All utility-scale solar 
		SPV	Utility-scale photovoltaic 
		DPV	Small-scale solar photovoltaic 
		WND	Wind

		WWW	Wood and wood-derived fuels 
		WAS	Other biomass 
		GEO	Geothermal 
		STH	Utility-scale thermal 
		AOR	Other renewables (total) 

		OTH	Other /

	src	/
		1	Electric utility

		2	Electric utility non-cogen
		3	Electric utility cogen

		4	Commercial non-cogen
		5	Commercial cogen

		6	Industrial non-cogen
		7	Industrial cogen

		8	Residential

		94	Independent power producers (total)

		96	All commercial (total)
		97	All industrial (total)
		98	Electric power (total)

		99	All sectors /;

set	tyrm(t,yr,m)	Mapping of time records corresponding to months, 
	tyrq(t,yr,q)	Mapping of time records corresponding to quarters;

tyrm(t,yr,m) =  ord(t.tl,1)=ord(yr.tl,1) and
		ord(t.tl,2)=ord(yr.tl,2) and
		ord(t.tl,3)=ord(yr.tl,3) and
		ord(t.tl,4)=ord(yr.tl,4) and
		ord(t.tl,5)=ord(m.tl,1) and
		ord(t.tl,6)=ord(m.tl,2);

tyrq(t,yr,q) =  ord(t.tl,1)=ord(yr.tl,1) and
		ord(t.tl,2)=ord(yr.tl,2) and
		ord(t.tl,3)=ord(yr.tl,3) and
		ord(t.tl,4)=ord(yr.tl,4) and
		ord(t.tl,5)=ord("Q",1) and
		ord(t.tl,6)=ord(q.tl,2);

option tyrm:0:0:1, tyrq:0:0:1;
display tyrm, tyrq;

set	mktdat /
	customers	Number of customer accounts, 
	price		Average retail price of electricity, 
	rev		Revenue from retail sales of electricity,
	sales		Retail sales of electricity /;


set	pdata	Plant-level data /
	CONS_EG_BTU   Electric fuel consumption MMBtu
	CONS_TOT_BTU  Fuel consumption MMBtu
	GEN           Net generation
	AVG_HEAT      MMBtu per unit
	CONS_EG       Electric fuel consumption quantity
	CONS_TOT      Fuel consumption quantity /;

set	p(*)	Plants in the ELEC.TXT dataset;

*	Read the label mappings:

$include elecmap

set	id_i(id)	Data records mapped to I,
	id_j(id)	Data records mapped to J,
	id_k(id)	Data records mapped to K;

option id_i<imap, id_j<jmap, id_k<kmap;

set	notmapped(id)	Data records which are not mapped ;
notmapped(id) = id(id)$(not (id_i(id) or id_j(id) or id_k(id)));
option notmapped:0:0:1;
display notmapped;

set	i(pdata,pfuel,ptech)	Data labels in I, 
	j(eledat,fuel,r,src)	Data labels in J, 
	k(mktdat,r,s)		Data labels in K;

option i<imap, j<jmap, k<kmap;
option i:0:0:1, j:0:0:1, k:0:0:1;
display i,j,k;

parameter
	demand(mktdat,r,s,yr)			Market data (annual)
	demand_m(mktdat,r,s,yr,m)		Market data (monthly)
	demand_q(mktdat,r,s,yr,q)		Market data (quarterly)

	supply(eledat,fuel,r,src,yr)		Electricity generation and fuel use (annual),
	supply_m(eledat,fuel,r,src,yr,m)	Electricity generation and fuel use (monthly),
	supply_q(eledat,fuel,r,src,yr,q)	Electricity generation and fuel use (quarterly);

demand(mktdat,r,s,yr(t))  = sum(kmap(id,mktdat,r,s,"a"), series(id,t));
demand_m(mktdat,r,s,yr,m) = sum((kmap(id,mktdat,r,s,"m"),tyrm(t,yr,m)), series(id,t));
demand_q(mktdat,r,s,yr,q) = sum((kmap(id,mktdat,r,s,"q"),tyrq(t,yr,q)), series(id,t));

supply(eledat,fuel,r,src,yr(t))	 = sum(jmap(id,eledat,fuel,r,src,"a"),series(id,t));
supply_m(eledat,fuel,r,src,yr,m) = sum((jmap(id,eledat,fuel,r,src,"m"),tyrm(t,yr,m)), series(id,t));
supply_q(eledat,fuel,r,src,yr,q) = sum((jmap(id,eledat,fuel,r,src,"q"),tyrq(t,yr,q)), series(id,t));

*	Only return supply and demand data unless plant data is requested:

$if not set plantdata $set plantdata no

$ifthen.noplantdata  %plantdata%==no

*	Omit plant data:

execute_unload 'elec_annual.gdx',     demand,supply,
	yr,mktdat,r,s,eledat,fuel,src;

execute_unload 'elec_monthly.gdx',    demand_m=demand,supply_m=supply,
	yr,m,mktdat,r,s,eledat,fuel,src;

execute_unload 'elec_quarterly.gdx',demand_q=demand,supply_q=supply,
	yr,q,mktdat,r,s,eledat,fuel,src;

$exit

$endif.noplantdata

*	Read plan information from Form 860:

set	p860(*)	Plants in Form 860 (2___Plant_Y2022.xlsx);

$if not exist plantinfo.gdx $call gams plantinfo gdx=plantinfo.gdx
$gdxin plantinfo.gdx
$load p860=p

set	pnew(p)		Plants in ELEC but not in 860,
	pmissing(p860)	Plants in 860 but not in ELEC;

pmissing(p860) = p860(p860)$(not p(p860));
option pmissing:0:0:1;
display pmissing;

pnew(p) = not p860(p);
loop(imap(id,pdata,p,pfuel,ptech,ti)$pnew(p),
	pnew(p) = id(id);
);

option pnew:0:0:1;
display pnew;

parameter	cardp	Number of plants;
cardp("ELEC") = card(p);
cardp("860") = card(p860);
cardp("missing") = card(pmissing);
cardp("new") = card(pnew);
cardp("both") = sum(p$p860(p),1);
option cardp:0:0:1;
display cardp;

parameter	
	plant(pdata,p,pfuel,ptech,yr)		Plant data (annual)
	plant_m(pdata,p,pfuel,ptech,yr,m)	Plant data (monthly)
	plant_q(pdata,p,pfuel,ptech,yr,q)	Plant data (quarterly);

plant(pdata,p,pfuel,ptech,yr(t))	= sum(imap(id,pdata,p,pfuel,ptech,"a"), series(id,t));
plant_m(pdata,p,pfuel,ptech,yr,m)	= sum((imap(id,pdata,p,pfuel,ptech,"m"),tyrm(t,yr,m)), series(id,t));
plant_q(pdata,p,pfuel,ptech,yr,q)	= sum((imap(id,pdata,p,pfuel,ptech,"q"),tyrq(t,yr,q)), series(id,t));

execute_unload 'elec_annual.gdx',     plant,demand,supply,
	p,pdata,ptech,yr,mktdat,r,s,eledat,fuel,src;

execute_unload 'elec_monthly.gdx',    plant_m=plant,demand_m=demand,supply_m=supply,
	p,pdata,ptech,yr,m,mktdat,r,s,eledat,fuel,src;

execute_unload 'elec_quarterly_q.gdx',plant_q=plant,demand_q=demand,supply_q=supply,
	p,pdata,ptech,yr,q,mktdat,r,s,eledat,fuel,src;


