$title	Aggregate from Detailed to Summary

*	NB  -- New names here.

set	s(*)	Detailed sectors;

$call gams ..\bea_IO\mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s=d 

alias (s,g,gg);

sets	rs(*)	Rows in the supply table / (set.s),
		T017	"Total industry supply" /,

	cs(*)	Columns in the supply table / (set.s),
		T007	"Total Commodity Output",
		MCIF	"Imports",
		MCIF_N	"Imports from the national market"
		MADJ	"CIF/FOB Adjustments on Imports",
		T013	"Total product supply (basic prices)",
		TRADE 	"Trade margins",
		TRANS	"Transportation costs",
		T014	"Total trade and transportation margins",
		MDTY	"Import duties",
		TOP	"Tax on products",
		SUB	"Subsidies",
		T015	"Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)" /,

	ru(*)	Rows in the use table / (set.s), 
		T005	"Total intermediate inputs",
		V001	"Compensation of employees",
		T00OTOP	"Other taxes on production",
		T00OSUB	"Less: other subsidies on production",
		V003	"Gross operating surplus",
		VABAS	"Value added (basic value)",
		T018	"Total industry output (basic value)",
		T00TOP	"Plus: Taxes on products and imports",
		T00SUB	"Less: Subsidies",
		VAPRO	"Value added (producer value)" /,

	cu(*)	Columns in the use table/ (set.s),
		T001	"Total Intermediate",
		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F040  	"Exports of goods and services",
		F040_N	"Exports of goods and services to the national market",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures",
		T019	"Total use of products" /;

set	r	Regions /	
	AL	"Alabama",
	AR	"Arizona",
	AZ	"Arkansas",
	CA	"California",
	CO	"Colorado",
	CT	"Connecticut",
	DE	"Delaware",
	FL	"Florida",
	GA	"Georgia",
	IA	"Iowa",
	ID	"Idaho",
	IL	"Illinois",
	IN	"Indiana",
	KS	"Kansas",
	KY	"Kentucky",
	LA	"Louisiana",
	MA	"Massachusetts",
	MD	"Maryland",	
	ME	"Maine",
	MI	"Michigan",
	MN	"Minnesota",
	MO	"Missouri",
	MS	"Mississippi",	
	MT	"Montana",
	NC	"North Carolina",
	ND	"North Dakota",
	NE	"Nebraska",
	NH	"New Hampshire",
	NJ	"New Jersey",
	NM	"New Mexico",
	NV	"Nevada",
	NY	"New York",
	OH	"Ohio",
	OK	"Oklahoma",
	OR	"Oregon",
	PA	"Pennsylvania",
	RI	"Rhode Island",
	SC	"South Carolina",
	SD	"South Dakota",
	TN	"Tennessee",
	TX	"Texas",
	UT	"Utah",
	VA	"Virginia",
	VT	"Vermont",
	WA	"Washington",
	WV	"West Virginia",
	WI	"Wisconsin",
	WY	"Wyoming"/;


parameter
	use(ru,cu,r)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply(rs,cs,r)		Projected Supply of Commodities by Industries - (Millions of dollars);

set		tp(*)		Trade partners;

set	census      Census divisions /
		neg     "New England" 
		mid     "Mid Atlantic" 
		enc     "East North Central" 
		wnc     "West North Central" 
		sac     "South Atlantic" 
		esc     "East South Central" 
		wsc     "West South Central" 
		mtn     "Mountain" 
		pac     "Pacific" /;

set	mkt /national, (set.census), (set.r)/;

parameter	ys0(g,r,mkt)	Market supply,
		d0(g,mkt,r)	Market demand,
		bx0(g,r,tp)	Bilateral exports by commodity-state-trade partner;

$if not set ds $set ds supplyusegravity_2022
$gdxin '%ds%.gdx'
$onundf
$loaddc use supply tp ys0 d0 bx0
$gdxin 

set	i	Aggregated sectors -- WiNDC labels /

*	agr  "Farms (111CA)",

	osd_agr  "Oilseed farming (1111A0)",
	grn_agr  "Grain farming (1111B0)",
	veg_agr  "Vegetable and melon farming (111200)",
	nut_agr  "Fruit and tree nut farming (111300)",
	flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
	oth_agr  "Other crop farming (111900)",
	dry_agr  "Dairy cattle and milk production (112120)",
	bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
	egg_agr  "Poultry and egg production (112300)",
	ota_agr  "Animal production, except cattle and poultry and eggs (112A00)",

	fof  "Forestry, fishing, and related activities (113FF)",
	oil  "Oil and gas extraction (211)",
	min  "Mining, except oil and gas (212)",
	smn  "Support activities for mining (213)",
	uti  "Utilities (22)",
	con  "Construction (23)",
	wpd  "Wood products manufacturing (321)",
	nmp  "Nonmetallic mineral products manufacturing (327)",
	pmt  "Primary metals manufacturing (331)",
	fmt  "Fabricated metal products (332)",
	mch  "Machinery manufacturing (333)",
	cep  "Computer and electronic products manufacturing (334)",
	eec  "Electrical equipment, appliance, and components manufacturing (335)",
	mot  "Motor vehicles, bodies and trailers, and parts manufacturing (3361MV)",
	fpd  "Furniture and related products manufacturing (337)",
	mmf  "Miscellaneous manufacturing (339)",
	fbp  "Food and beverage and tobacco products manufacturing (311FT)",
	tex  "Textile mills and textile product mills (313TT)",
	alt  "Apparel and leather and allied products manufacturing (315AL)",
	ppd  "Paper products manufacturing (322)",
	pri  "Printing and related support activities (323)",
	pet  "Petroleum and coal products manufacturing (324)",
	che  "Chemical products manufacturing (325)",
	pla  "Plastics and rubber products manufacturing (326)",
	ote  "Other transportation equipment (3364OT)",
	wht  "Wholesale trade (42)",
	mvt  "Motor vehicle and parts dealers (441)",
	fbt  "Food and beverage stores (445)",
	gmt  "General merchandise stores (452)",
	ott  "Other retail (4A0)",
	air  "Air transportation (481)",
	trn  "Rail transportation (482)",
	wtt  "Water transportation (483)",
	trk  "Truck transportation (484)",
	grd  "Transit and ground passenger transportation (485)",
	pip  "Pipeline transportation (486)",
	otr  "Other transportation and support activities (487OS)",
	wrh  "Warehousing and storage (493)",
	pub  "Publishing industries, except Internet (includes software) (511)",
	mov  "Motion picture and sound recording industries (512)",
	brd  "Broadcasting and telecommunications (513)",
	dat  "Data processing, internet publishing, and other information services (514)",
	bnk  "Federal Reserve banks, credit intermediation, and related services (521ci)",
	sec  "Securities, commodity contracts, and investments (523)",
	ins  "Insurance carriers and related activities (524)",
	fin  "Funds, trusts, and other financial vehicles (525)",
	hou  "Housing (HS)",
	ORE  "Other real estate (ORE)",
	rnt  "Rental and leasing services and lessors of intangible assets (532RL)",
	leg  "Legal services (5411)",
	tsv  "Miscellaneous professional, scientific, and technical services (5412OP)",
	com  "Computer systems design and related services (5415)",
	man  "Management of companies and enterprises (55)",
	adm  "Administrative and support services (561)",
	wst  "Waste management and remediation services (562)",
	edu  "Educational services (61)",
	amb  "Ambulatory health care services (621)",
	hos  "Hospitals (622)",
	nrs  "Nursing and residential care facilities (623)",
	soc  "Social assistance (624)",
	art  "Performing arts, spectator sports, museums, and related activities (711AS)",
	rec  "Amusements, gambling, and recreation industries (713)",
	amd  "Accommodation (721)",
	res  "Food services and drinking places (722)",
	osv  "Other services, except government (81)",
	fdd  "Federal general government (defense) (GFGD)",
	fnd  "Federal general government (nondefense) (GFGN)",
	slg  "State and local general government (GSLG)",
	fen  "Federal government enterprises (GFE)",
	sle  "State and local government enterprises (GSLE)",
	usd  "Scrap, used and secondhand goods",
	oth  "Noncomparable imports and rest-of-the-world adjustment" /;

set	is(*,*)	Mapping from aggregate sectors to detailed sectors;

$gdxin %gams.scrdir%mappings.gdx
$load is=sd
$gdxin
option is:0:0:1;
display is;
$exit



set	agr(s)	Agricultural sectors;
agr(s) = s(s)$is("agr",s);
option agr:0:0:1;
display agr;

*	Remove the aggregate agr sector and add the constituents from the mapping:

is(agr,agr) = yes;
is("agr",agr) = no;
	

sets	rs_(*)	Rows in the supply table / (set.i),
		T017	"Total industry supply" /,

	cs_(*)	Columns in the supply table / (set.i),
		T007	"Total Commodity Output",
		MCIF	"Imports",
		MCIF_N	"Imports from the national market"
		MADJ	"CIF/FOB Adjustments on Imports",
		T013	"Total product supply (basic prices)",
		TRADE 	"Trade margins",
		TRANS	"Transportation costs",
		T014	"Total trade and transportation margins",
		MDTY	"Import duties",
		TOP	"Tax on products",
		SUB	"Subsidies",
		T015	"Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)" /,

	ru_(*)	Rows in the use table / (set.i), 
		T005	"Total intermediate inputs",
		V001	"Compensation of employees",
		T00OTOP	"Other taxes on production",
		T00OSUB	"Less: other subsidies on production",
		V003	"Gross operating surplus",
		VABAS	"Value added (basic value)",
		T018	"Total industry output (basic value)",
		T00TOP	"Plus: Taxes on products and imports",
		T00SUB	"Less: Subsidies",
		VAPRO	"Value added (producer value)" /,

	cu_(*)	Columns in the use table/ (set.i),
		T001	"Total Intermediate",
		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F040  	"Exports of goods and services",
		F040_N	"Exports of goods and services to the national market",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures",
		T019	"Total use of products" /,

	rumap(ru_,ru),	cumap(cu_,cu),	rsmap(rs_,rs),	csmap(cs_,cs);

parameter
	use_(ru_,cu_,r)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply_(rs_,cs_,r)	Projected Supply of Commodities by Industries - (Millions of dollars);
	
	rumap(ru_,ru)$sameas(ru_,ru) = yes;
	cumap(cu_,cu)$sameas(cu_,cu) = yes;
	rsmap(rs_,rs)$sameas(rs_,rs) = yes;
	csmap(cs_,cs)$sameas(cs_,cs) = yes;

	rumap(ru_,ru)$is(ru_,ru) = yes;
	cumap(cu_,cu)$is(cu_,cu) = yes;
	rsmap(rs_,rs)$is(rs_,rs) = yes;
	csmap(cs_,cs)$is(cs_,cs) = yes;

option rumap:0:0:1, cumap:0:0:1, rsmap:0:0:1, csmap:0:0:1;
display rumap, cumap, rsmap, csmap;

set	bugmap(*);

bugmap(ru) = sum(rumap(ru_,ru),1) - 1;
abort$card(bugmap) "Bug in ru:", bugmap;

bugmap(cu) = sum(cumap(cu_,cu),1) - 1;
abort$card(bugmap) "Bug in cu:", bugmap;

bugmap(rs) = sum(rsmap(rs_,rs),1) - 1;
abort$card(bugmap) "Bug in rs:", bugmap;

bugmap(cs) = sum(csmap(cs_,cs),1) - 1;
abort$card(bugmap) "Bug in cs:", bugmap;

set	missingmap(*);

missingmap(ru_) = not sum(rumap(ru_,ru),1);
abort$card(bugmap) "Bug in ru:", missingmap;

missingmap(cu_) = not sum(cumap(cu_,cu),1);
abort$card(bugmap) "Bug in cu:", missingmap;

missingmap(rs_) = not sum(rsmap(rs_,rs),1);
abort$card(bugmap) "Bug in rs:", missingmap;

missingmap(cs_) = not sum(csmap(cs_,cs),1);
abort$card(bugmap) "Bug in cs:", missingmap;

use_(ru_,cu_,r)	 = sum((rumap(ru_,ru),cumap(cu_,cu)),use(ru,cu,r));
supply_(rs_,cs_,r) = sum((rsmap(rs_,rs),csmap(cs_,cs)),supply(rs,cs,r));

parameter	ys0_(i,r,mkt)	Market supply,
		d0_(i,mkt,r)	Market demand,
		bx0_(i,r,tp)	Bilateral exports by commodity-state-trade partner;
ys0_(i,r,mkt) = sum(is(i,s),ys0(s,r,mkt));
d0_(i,mkt,r) = sum(is(i,s),d0(s,mkt,r));
bx0_(i,r,tp) = sum(is(i,s),bx0(s,r,tp));

execute_unload '%ds%.gdx', supply, use, bx0, ys0, d0, supply_, use_,  tp, bx0_, ys0_, d0_, s, i=s_;
