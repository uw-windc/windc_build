$title	Create a Symmetric Table and Calculate ATMs

$set suffix _

$if not set ds $set ds supplyusegravity_2022
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

parameter
	use(ru,cu,r)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply(rs,cs,r)		Projected Supply of Commodities by Industries - (Millions of dollars);

$onundf
$loaddc use=use%suffix% supply=supply%suffix%

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

parameter	theta(*,*,*)		Fraction of good g provided by sector s
		aggsupply(g,r)	Aggregate supply;

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
c(s) = s(s);
c(cu) = cu(cu);
c(cs) = cs(cs);

balance(r,g(c), "iorow") = sum(ru,iot(ru,c,r));
balance(r,g(ru),"iocol") = sum(c,iot(ru,c,r));
balance(r,g,    "iochk") = balance(g,"iorow",r) - balance(g,"iocol",r);
option balance:3:2:1;
display balance;

set	xd(*)	Exogenous demand /
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
		F10S  	"State and local: Gross investment in structures" /;

parameter
	y0(r,g)		Aggregate supply,
	yd0(r,g)	Domestic supply,
	yn0(r,g)	National market supply,
	n0(g)		Aggregate national supply,
	dn0(r,g)	National market demand,
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
yn0(r,g(ru)) = iot(ru,"F040_N",r);
dn0(r,g(ru)) = -iot(ru,"MCIF_N",r);
n0(g) = sum(r,yn0(r,g));
x0(r,g(ru)) = iot(ru,"f040",r);
x0n(g) = sum(r,x0(r,g));
ms0(r,g(ru),mrg(c)) = max(0,iot(ru,c,r));
yd0(r,g) = y0(r,g) - x0(r,g) - yn0(r,g) - sum(mrg,ms0(r,g,mrg));
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

variables
		v_PY(r,g)	Content of domestic commodity,
		v_PN(g)		Content of national market commodity,
		v_PA(r,g)	Content of absorption,
		v_PI(r,mrg)	Content of margin,
		DC(r,s)		Direct content;

$ondotl

equations	objdef, def_PY, def_PI, def_PN, def_PA;

variable	obj	Dummy objective;

objdef..		OBJ =e= 0;

def_PY(r,s)$y0(r,s)..	v_PY(r,s) * y0(r,s) =e= sum(g,v_PA(r,g)*id0(r,g,s)) + DC(r,s)$DC.UP(r,s);
def_PI(r,mrg)..		v_PI(r,mrg)*sum(g,ms0(r,g,mrg))  =e= sum(g,v_PY(r,g)*ms0(r,g,mrg));
def_PN(g)$n0(g)..	v_PN(g)*n0(g) =e= sum(r,v_PY(r,g)*yn0(r,g));
def_PA(r,g)$a0(r,g)..	v_PA(r,g)*a0(r,g) =e= v_PY(r,g)*yd0(r,g) + v_PN(g)*dn0(r,g) + 
					sum(mrg,v_PI(r,mrg)*md0(r,g,mrg));

v_PY.FX(r,g)$(not y0(r,g)) = 0;
v_PA.FX(r,g)$(not a0(r,g)) = 0;
v_PN.FX(g)$(not n0(g)) = 0;

model atmMCP /def_PY.v_PY, def_PN.v_PN, def_PI.v_PI, def_PA.v_PA /;

DC.FX(r,s) = y0(r,s)$ags(s);

parameter	compare		Comparison of results;

$ifthen.mcpsolve "%suffix%"=="_"

solve atmMCP using mcp;
compare("_",g,"PN","MCP")$n0(g) = v_PN.L(g);
compare(r,mrg,"PI","MCP") = v_PI.L(r,mrg);
compare(r,s,"PY","MCP")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","MCP")$a0(r,g) = v_PA.L(r,g);
$endif.mcpsolve

model atmLP /objdef, def_PY, def_PN, def_PI, def_PA /;
option lp=ipopt;
solve atmLP using LP minimizing obj;

compare("_",g,"PN","LP")$n0(g) = v_PN.L(g);
compare(r,mrg,"PI","LP") = v_PI.L(r,mrg);
compare(r,s,"PY","LP")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","LP")$a0(r,g) = v_PA.L(r,g);
option compare:3:2:2;
display compare;

$exit

parameter	pivotdata;

alias	(r,rloop), (s,sloop),
loop((rloop,sloop)$ags(sloop),
	DC.FX(r,s) = y0(rloop(r),sloop(r));
	solve atmLP using LP minimizing obj;
	pivotdata(rloop,sloop,r,s) = v_PY.L(r,s);
);
