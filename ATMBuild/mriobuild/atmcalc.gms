$title	Create a Symmetric Table and Calculate ATMs

$if not set yr $set yr 2022
$if not set ds $set ds supplyusegravity_%yr%
$if not set output $set output atmcalc

$if not set suffix $set suffix 

$gdxin '%ds%.gdx'

set	s(*)	Sectors;
$load s=s%suffix%

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
		T019	"Total use of products" /,

	fd(cu)	Components of final demand /
		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
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
		F10S  	"State and local: Gross investment in structures" /,

	mrg(*)		Margin accounts /
		TRADE 	"Trade margins",
		TRANS	"Transportation costs" /,

	imp(cs)		Import accounts /
		MDTY	"Import duties",
		MCIF	"Imports",
		MCIF_N	"Imports from the national market"
		MADJ	"CIF/FOB Adjustments on Imports" /,

	txs(cs)		Tax flows /
		TOP	"Tax on products",
		SUB	"Subsidies" /,

	txd(cs)		Domestic taxes /
		TOP	"Tax on products",
		SUB	"Subsidies" /,


	vabas(ru) Value-added at basic prices /
		V001	"Compensation of employees",
		V003	"Gross operating surplus",
		T00OTOP	"Other taxes on production",
		T00OSUB	"Less: other subsidies on production" /,

	pce(cu) 	Final demand -- consumption /
		F010  	"Personal consumption expenditures" /

	demacct(cs)   Accounts assumed proportional to demand /
		MCIF	"Imports",
		MADJ	"CIF/FOB Adjustments on Imports",
		MDTY	"Import duties"
		TOP	"Tax on products",
		SUB	"Subsidies"/,

	export(cu)    Export account /
		F040  	"Exports of goods and services"
		F040_N	"Exports of goods and services to the national market" /,

	gov(cu) Government expenditure / 
		F06C  	"Federal Government defense: Consumption expenditures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F10C  	"State and local government consumption expenditures" /,

	fed(cu) State and local government expenditure / 
		F06C  	"Federal Government defense: Consumption expenditures",
		F07C  	"Federal Government nondefense: Consumption expenditures"/

	slg(cu) State and local government expenditure / 
		F10C  	"State and local government consumption expenditures" /,

	inv(cu)	Investment / 
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",

		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",

		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",

		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /;


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

alias (r,rr);

set	totacct(*)	Totals accounts /
*S_ROW
		T017	"Total industry supply" 
*S_COL
		T007	"Total Commodity Output",
		T013	"Total product supply (basic prices)",
		T014	"Total trade and transportation margins",
		T015	"Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)",

*U_ROW
		T005	"Total intermediate inputs",
		VABAS	"Value added (basic value)",
		T00TOP	"Plus: Taxes on products and imports",
		T00SUB	"Less: Subsidies",
		T018	"Total industry output (basic value)",
		VAPRO	"Value added (producer value)",
*U_COL
		T001	"Total Intermediate",
		T019	"Total use of products" /;

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

$if not set mkt $set mkt state
$if %mkt%==national $set mktdomain national
$if %mkt%==census   $set mktdomain set.census
$if %mkt%==state    $set mktdomain set.r

set	mkt	Markets /%mktdomain%/;

set	tp(*)			Trade partner;

parameter
	use(ru,cu,r)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply(rs,cs,r)		Projected Supply of Commodities by Industries - (Millions of dollars),
	ys0(g,r,mkt)		Market supply,
	d0(g,mkt,r)		Market demand;

$onundf
$loaddc use=use%suffix% supply=supply%suffix% 

parameter	thetax(g,r,tp)	Region r fraction of g exports to tp;

$ifthen.tradedata set tradedata

set	i_trade(*)	Traded goods;

$gdxin '%tradedata%'
$load i_trade=i tp=r

	thetax(g,r,tp) = 1/card(tp);

$else.tradedata

$load   ys0=ys0%suffix% d0=d0%suffix% 

parameter	bx0(g,r,tp)	Bilateral exports by commodity-state-trade partner;

$load tp
$loaddc	bx0=bx0%suffix%

thetax(g,r,tp)$bx0(g,r,tp) = bx0(g,r,tp) / sum(rr,bx0(g,rr,tp));

$endif.tradedata

$gdxin

option thetax:2:2:1;
display thetax;

*.execute_unload 'thetax.gdx',thetax;
*.execute 'gdxxrw i=thetax.gdx o=atm.xlsx par=thetax rng=thetax!a2 cdim=0';

*	Drop the tiny numbers:

use(ru,cu,r)$(not round(use(ru,cu,r),6)) = 0;
supply(rs,cs,r)$(not round(supply(rs,cs,r),6)) = 0;

set	unz(ru,cu,r), snz(rs,cs,r);
option unz<use, snz<supply;

use(unz(ru,cu,r))$(totacct(ru) or totacct(cu)) = 0;
supply(snz(rs,cs,r))$(totacct(rs) or totacct(cs)) = 0;

option unz<use, snz<supply;

parameter	balance(*,*,*)	Cross check on balance;
balance(r,g(ru),"use")     = sum(unz(ru,cu,r), use(unz));
balance(r,g(rs),"supply")  = sum(snz(rs,cs,r), supply(snz));
balance(r,s(cu),"cost")    = sum(unz(ru,cu,r), use(unz));
balance(r,s(cs),"revenue") = sum(snz(rs,cs,r), supply(snz));
option balance:3:2:1;
display balance;

parameter	aggsupply(g,r)	Aggregate supply by sector s in state r
		theta(*,*,r)	Fraction of sector s in state r is good g;

aggsupply(s,r) = sum(snz(rs(g),cs(s),r), supply(snz));
theta(snz(rs(g),cs(s),r))$aggsupply(s,r) = supply(snz) / aggsupply(s,r);

parameter	thetasum(s,r)	Sum of theta over goods;
thetasum(s,r)$aggsupply(s,r) = round(1 - sum(snz(rs(g),cs(s),r),theta(snz)),3);
abort$card(thetasum) "Imbalanced theta!", thetasum, aggsupply;

parameter	iot(*,*,*)	Input-output table;
iot(ru,g,r) = sum(cu(s), theta(g,s,r)*use(ru,cu,r));
iot(unz(ru(g),cu,r))$(not g(cu)) = use(unz);
iot(snz(rs(g),cs,r))$(not g(cs)) = -supply(snz);

set	c(*)		Columns in the IOT;
c(s) = s(s); c(cu) = cu(cu); c(cs) = cs(cs);

*	Filter the tiny numbers:

iot(ru,c,r)$(not round(iot(ru,c,r),6)) = 0;

balance(r,g(c), "iorow") = sum(ru,iot(ru,c,r));
balance(r,g(ru),"iocol") = sum(c,iot(ru,c,r));
balance(r,g,    "iochk") = balance(g,"iorow",r) - balance(g,"iocol",r);
option balance:3:2:1;
display balance;

set	xd(*)	Exogenous demand /
		F02E  	"Nonresential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
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
		F10S  	"State and local: Gross investment in structures" /;

parameter
	y0(r,g)		Aggregate supply,
	yd0(r,g)	Domestic supply,
	s0(g,mkt)	Aggregate supply to market
	va0(r,s)	Value-added,
	id0(r,g,s)	Intermediate demand,
	x0(r,g)		Regional exports,
	x0n(g)		National exports
	ms0(r,g,mrg)	Margin supply,
	md0(r,g,mrg)	Margin demand,
	fd0(r,g,xd)	Final demand,
	cd0(r,g)	Consumer demand,
	a0(r,g)		Absorption,
	m0(r,g)		Imports;

y0(r,g) = sum(ru,iot(ru,g,r));

$if not defined ys0 ys0(g,r,mkt) = sum(unz(ru(g),cu("F040_N"),r),use(unz));
$if not defined d0  d0(g,mkt,r) = sum(snz(rs(g),cs("MCIF_N"),r),supply(snz));
s0(g,mkt) = sum(r,ys0(g,r,mkt));

x0(r,g(ru)) = iot(ru,"f040",r);
x0n(g) = sum(r,x0(r,g));
ms0(r,g(ru),mrg(c)) = max(0,iot(ru,c,r));
yd0(r,g) = y0(r,g) - x0(r,g) - sum(mkt,ys0(g,r,mkt)) - sum(mrg,ms0(r,g,mrg));
va0(r,g(cu)) = sum(ru$(not g(ru)), use(ru,cu,r));
m0(r,g(ru)) = iot(ru,"mcif",r) + iot(ru,"madj",r) + iot(ru,"mdty",r);
md0(r,g(ru),mrg(c)) = max(0,-iot(ru,c,r));
cd0(r,g(ru)) = iot(ru,"F010",r);
fd0(r,g(ru),xd(cu)) = iot(ru,cu,r);
id0(r,g(ru),s(cu)) = iot(ru,cu,r);
a0(r,g) = sum(s,id0(r,g,s)) + cd0(r,g) + sum(xd,fd0(r,g,xd));

set	ags(*)  Agricultural sectors/ 
		osd_agr  "Oilseed farming (1111A0)",
		grn_agr  "Grain farming (1111B0)",
		veg_agr  "Vegetable and melon farming (111200)",
		nut_agr  "Fruit and tree nut farming (111300)",
		flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
		oth_agr  "Other crop farming (111900)",
		dry_agr  "Dairy cattle and milk production (112120)",
		bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
		egg_agr  "Poultry and egg production (112300)",
		ota_agr  "Animal production, except cattle and poultry and eggs (112A00)" /;

variables	v_PY(r,g)	Content of domestic commodity,
		v_P(g,mkt)	Content of market commodity,
		v_PA(r,g)	Content of absorption,
		v_PI(r,mrg)	Content of margin;
$ondotl

*	First solve the model iteratively:

parameter	v_PYn(r,g)	Lagged content
		dev		Deviation /1/
		iter_log	Iteration log;

set	iter /iter1*iter25/;

v_PY(r,s) = 1$ags(s);
dev = 1;
loop(iter$round(dev,2),
	v_PI(r,mrg) =  sum(g,v_PY(r,g)*ms0(r,g,mrg))/sum(g,ms0(r,g,mrg));

	v_P(g,mkt)$s0(g,mkt) = sum(r,v_PY(r,g)*ys0(g,r,mkt))/s0(g,mkt);

	v_PA(r,g)$a0(r,g) = (v_PY(r,g)*yd0(r,g) + 
			sum(mkt,v_P(g,mkt)*d0(g,mkt,r)) +
			sum(mrg,v_PI(r,mrg)*md0(r,g,mrg))) / a0(r,g);

	v_PYn(r,s)$y0(r,s) = ( sum(g,v_PA(r,g)*id0(r,g,s)) +  y0(r,s)$ags(s) ) / y0(r,s);

	dev = sum((r,s)$y0(r,s), abs(v_PYn(r,s)-v_PY(r,s)));

	v_PY(r,s) = v_PYn(r,s);
	iter_log(iter,"dev") = dev;
);
display iter_log;

$exit


set	agr(g)	Agricultural and food products /

	osd_agr	     "Oilseed farming (1111A0)",
	grn_agr	     "Grain farming (1111B0)",
	veg_agr	     "Vegetable and melon farming (111200)",
	nut_agr	     "Fruit and tree nut farming (111300)",
	flo_agr	     "Greenhouse, nursery, and floriculture production (111400)",
	oth_agr	     "Other crop farming (111900)",
	bef_agr	     "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
	egg_agr	     "Poultry and egg production (112300)",
	ota_agr	     "Animal production, except cattle and poultry and eggs (112A00)",

	dog_fbp	     "Dog and cat food manufacturing (311111)",
	oaf_fbp	     "Other animal food manufacturing (311119)",
	flr_fbp	     "Flour milling and malt manufacturing (311210)",
	wet_fbp	     "Wet corn milling (311221)",
	fat_fbp	     "Fats and oils refining and blending (311225)",
	soy_fbp	     "Soybean and other oilseed processing (311224)",
	brk_fbp	     "Breakfast cereal manufacturing (311230)",
	sug_fbp	     "Sugar and confectionery product manufacturing (311300)",
	fzn_fbp	     "Frozen food manufacturing (311410)",
	can_fbp	     "Fruit and vegetable canning, pickling, and drying (311420)",
	chs_fbp	     "Cheese manufacturing (311513)",
	dry_fbp	     "Dry, condensed, and evaporated dairy product manufacturing (311514)",
	mlk_fbp	     "Fluid milk and butter manufacturing (31151A)",
	ice_fbp	     "Ice cream and frozen dessert manufacturing (311520)",
	chk_fbp	     "Poultry processing (311615)",
	asp_fbp	     "Animal (except poultry) slaughtering, rendering, and processing (31161A)",
	sea_fbp	     "Seafood product preparation and packaging (311700)",
	brd_fbp	     "Bread and bakery product manufacturing (311810)",
	cok_fbp	     "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)",
	snk_fbp	     "Snack food manufacturing (311910)",
	tea_fbp	     "Coffee and tea manufacturing (311920)",
	syr_fbp	     "Flavoring syrup and concentrate manufacturing (311930)",
	spc_fbp	     "Seasoning and dressing manufacturing (311940)",
	ofm_fbp	     "All other food manufacturing (311990)",
	pop_fbp	     "Soft drink and ice manufacturing (312110)",
	ber_fbp	     "Breweries (312120)",
	wne_fbp	     "Wineries (312130)",
	why_fbp	     "Distilleries (312140)",
	cig_fbp	     "Tobacco manufacturing (312200)" /;

parameter	atm(*,g,*)	Agricultural trade multipliers (summary);

atm("y0",agr(g),tp) = sum(r,y0(r,g));
atm("y0%",agr(g),tp) = sum(r,y0(r,g))/sum((r,gg),y0(r,gg));
atm("atm_trade",agr(g),tp) = sum(r, thetax(g,r,tp) * (V_PY.L(r,g) - 1$ags(g)));
atm("atm_output",agr(g),r) = (V_PY.L(r,g) - 1$ags(g));

$exit

parameter	v_D(r,s)	Locally sourced agricultural content
		v_M(r,s)	Interstate sourced agricultural content;

	v_D(r,s) = sum(g$a0(r,g), id0(r,g,s)/y0(r,s) * v_PY(r,g)*yd0(r,g)/a0(r,g));
	v_M(r,s) = sum(g$a0(r,g), id0(r,g,s)/y0(r,s) * 
			sum(mkt, v_P(g,mkt)*d0(g,mkt,r)/a0(r,g)));




atm("atm_agr",agr(g),tp) = sum(ags(g),v_PA(r,g)*id0(r,g,s) 
atm("atm_fbp",agr(g),r) = (V_PY.L(r,g) - 1$ags(g));

*	Save the results:

execute_unload '%output%.gdx', atm;

$exit

*	Remaining code verifies that the iterative solution is consistent
*	with a direct method (system of equations).

*	Save results from the iterative calculation and verify consistency 
*	with the direct calculation:

parameter	compare		Comparison of results;
compare(mkt,g,"P","iter")  = v_P.L(g,mkt);
compare(r,mrg,"PI","Iter") = v_PI.L(r,mrg);
compare(r,s,"PY","Iter")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","Iter")$a0(r,g) = v_PA.L(r,g);

equations	def_PY, def_PI, def_P, def_PA;

def_PY(r,s)$y0(r,s)..	v_PY(r,s) * y0(r,s) =e= sum(g,v_PA(r,g)*id0(r,g,s)) + y0(r,s)$ags(s);

def_PI(r,mrg)..		v_PI(r,mrg)*sum(g,ms0(r,g,mrg))  =e= sum(g,v_PY(r,g)*ms0(r,g,mrg));

def_P(g,mkt)$s0(g,mkt).. v_P(g,mkt)*s0(g,mkt) =e= sum(r,v_PY(r,g)*ys0(g,r,mkt));

def_PA(r,g)$a0(r,g)..	v_PA(r,g)*a0(r,g) =e= v_PY(r,g)*yd0(r,g) + 
					sum(mkt,v_P(g,mkt)*d0(g,mkt,r)) + 
					sum(mrg,v_PI(r,mrg)*md0(r,g,mrg));

v_PY.FX(r,g)$(not y0(r,g)) = 0;
v_P.FX(g,mkt)$(not s0(g,mkt)) = 0;
v_PA.FX(r,g)$(not a0(r,g)) = 0;
v_P.FX(g,mkt)$(not s0(g,mkt)) = 0;

variable	obj	Dummy LP objective;
equation	objdef;
objdef..		OBJ =e= 0;
model atmLP /objdef, def_PY, def_P, def_PI, def_PA /;

option lp=ipopt;
solve atmLP using LP minimizing obj;

compare(mkt,g,"P","LP")  = v_P.L(g,mkt);
compare(r,mrg,"PI","LP") = v_PI.L(r,mrg);
compare(r,s,"PY","LP")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","LP")$a0(r,g) = v_PA.L(r,g);
option compare:3:2:2;
display compare;

