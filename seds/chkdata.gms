
*	annnual - monthly - quarterly

$set time annual

*	census - states - national

$set regions national

$if %time%==annual    $set t yr
$if %time%==monthly   $set t yr,m
$if %time%==quarterly $set t yr,q

$if %time%==annual    $set td 1
$if %time%==monthly   $set td 2
$if %time%==quarterly $set td 2

set	m	Month  /01*12/
	q	Quarter /q1*q4/,
	yr	Year /2003*2023/;

set	t(%t%)	Time periods/
$if %time%==annual    set.yr
$if %time%==monthly   (set.yr).(set.m)
$if %time%==quarterly (set.yr).(set.q)
		/;

parameter	year(%t%);
year(%t%) = yr.val;

set	rr	Regions /
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
	PCN	Pacific Noncontiguous/;

set r(rr)	Regions to include /

$ifthen.census %regions%==census
	NEW	New England
	MAT	Middle Atlantic
	SAT	South Atlantic
	ENC	East North Central
	ESC	East South Central
	WNC	West North Central
	WSC	West South Central
	MTN	Mountain
	PCC	Pacific Contiguous
	PCN	Pacific Noncontiguous

$elseif.census %regions%==states

	CA, CT, SC, AL, AR, AZ, CO, DE, FL, GA, HI, IA, ID, IL, IN, KS, KY,
	LA, MA, MD, ME, MI, MN, MO, MS, NC, NE, NH, NJ, NM, NV, NY, OH, OK,
	PA, TN, UT, VA, WI, WV, WY, AK, MT, ND, OR, RI, SD, TX, WA, DC, VT

$else.census
	US 

$endif.census
	/;

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
		SULFUR_CONTENT  Sulfur content of fossil fuels in electricity generation/;

set	mktdat /
		customers	Number of customer accounts, 
		price		Average retail price of electricity, 
		rev		Revenue from retail sales of electricity,
		sales		Retail sales of electricity /;

set s	Sectors /
		ALL	All sectors
		COM	Commercial
		IND	Industrial
		RES	Residential
		TRA	Transportation
		OTH	Other /;

set	src	/
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

set	fuel /	ALL	All fuels

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

		STH	Utility-scale thermal 
		SUN	All utility-scale solar (excluded after 2002)
		SPV	Utility-scale photovoltaic 
*.		TSN	All solar (excluded from all)
*.		DPV	Small-scale solar photovoltaic (excluded from all)
		WND	Wind

		WWW	Wood and wood-derived fuels 
		WAS	Other biomass 
		GEO	Geothermal 
*		AOR	Other renewables (total) 

		OTH	Other /


parameter
	demand(mktdat,r,s,%t%)			Market data (annual)
	supply(eledat,fuel,r,src,%t%)		Electricity generation and fuel use (annual);

$gdxin elec_%time%.gdx
$load demand supply

*	2023:
*	12.7 cents per kWh 
*	3.984 BkWh 

parameter	pqchk;
pqchk(r,s,t,"p") = demand("price",r,s,t);
pqchk(r,s,t,"q") = demand("sales",r,s,t)/1e6;
pqchk(r,s,t,"r") = demand("rev",r,s,t)/1e6;
pqchk(r,s,t,"dif") = demand("price",r,s,t)/100*demand("sales",r,s,t)/1e6-demand("rev",r,s,t)/1e6;
pqchk(r,s,t,"dif%")$pqchk(r,s,t,"q") 
	= 100 * pqchk(r,s,t,"dif")/pqchk(r,s,t,"r")/1e6;

display pqchk;

$exit



SET	elefuel(eledat,fuel);
option elefuel<supply;
option elefuel:0:0:1;
display elefuel;

parameter	balance		Supply-demand market balance;
balance(t,"gen")   = sum(r, supply("gen","all",r,"99",t));
balance(t,"sales") = sum(r, demand("sales",r,"all",t));
balance(t,"sales%gen") = 100 * balance(t,"sales")/balance(t,"gen");

*	The ALL column in supply excludes TSN, DPV, AOR and (after 2002) SUN:

balance(t,"sum")   = sum((r,fuel)$(not sameas(fuel,"all")), supply("gen",fuel,r,"99",t)) 
		- sum(r,supply("gen","sun",r,"99",t)$(year(t)<>2001 and year(t)<>2002));

balance(t,"dif")   = balance(t,"gen") - balance(t,"sum");
option balance:0:%td%:1;
display balance;

parameter	fuelgen;
fuelgen(t,fuel) = sum(r,supply("gen",fuel,r,"99",t));
option fuelgen:0:%td%:1;
display fuelgen;
