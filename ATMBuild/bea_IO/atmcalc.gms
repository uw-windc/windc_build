$title	Create a Symmetric Table and Calculate ATMs

$if not set yr $set yr 2022

set	yrs(*), ru(*), cu(*), rs(*), cs(*);

set	s(*)	Sectors;

set	s_row(*) Summary table rows (in addition to commodities) 
	s_col(*) Summary table columns (in addition to sectors) 
	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors);

$call gams %system.fp%mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s=d s_row s_col u_row u_col

alias (s,g);

sets	rs(*) / (set.s), (set.s_row) /,
	cs(*) / (set.s), (set.s_col) /,
	ru(*) / (set.s), (set.u_row) /,
	cu(*) / (set.s), (set.u_col) /,
	g_s(rs) / (set.s) /,
	s_s(cs) / (set.s) /,
	g_u(ru) / (set.s) /,
	s_u(cu) / (set.s) /;

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
	use(yrs,ru,cu)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply(yrs,rs,cs)	Projected Supply of Commodities by Industries - (Millions of dollars);

$gdxin '%system.fp%data\iobalanced.gdx'
$load yrs<use.dim1
$loaddc use supply

set	unz(yrs,ru,cu)	Nonzero coefficients in the USE tables,
	snz(yrs,rs,cs)	Nonzero coefficients in the SUPPLY tables; 

option unz<use, snz<supply;

*	Drop data for totals and subtotals:

use(unz(yrs,ru,cu))$(totacct(ru) or totacct(cu)) = 0;
supply(snz(yrs,rs,cs))$(totacct(rs) or totacct(cs)) = 0;

option unz<use, snz<supply;

parameter	balance(*,*,*)	Cross check on balance;
balance(yrs,g(ru),"use")     = sum(unz(yrs,ru,cu), use(unz));
balance(yrs,g(rs),"supply")  = sum(snz(yrs,rs,cs), supply(snz));
balance(yrs,s(cu),"cost")    = sum(unz(yrs,ru,cu), use(unz));
balance(yrs,s(cs),"revenue") = sum(snz(yrs,rs,cs), supply(snz));
option balance:3:2:1;
display balance;

parameter	theta(yrs,*,*)		Fraction of good g provided by sector s
		aggsupply(yrs,g)	Aggregate supply;

aggsupply(yrs,s) = sum(snz(yrs,rs(g),cs(s)), supply(snz));
theta(snz(yrs,rs(g),cs(s)))$aggsupply(yrs,s) = supply(snz) / aggsupply(yrs,s);

parameter	thetasum(yrs,s)	Sum of theta over goods;
thetasum(yrs,s)$aggsupply(yrs,s) = round(1 - sum(snz(yrs,rs(g),cs(s)),theta(snz)),3);
abort$card(thetasum) "Imbalanced theta!", thetasum, aggsupply;

parameter	iot(yrs,*,*)	Input-output table;
iot(yrs,ru,g) = sum(cu(s), theta(yrs,g,s)*use(yrs,ru,cu));
iot(yrs,g(ru),cu(u_col)) = use(yrs,ru,cu);
iot(yrs,g(rs),cs(s_col)) = sum(snz(yrs,rs,cs), -supply(yrs,rs,cs));

set	c(*)	/set.s, set.s_col, set.u_col/;

balance(yrs,g(c), "iorow") = sum(ru,iot(yrs,ru,c));
balance(yrs,g(ru),"iocol") = sum(c,iot(yrs,ru,c));
balance(yrs,g,    "iochk") = balance(yrs,g,"iorow") - balance(yrs,g,"iocol");
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

set	mrg	/trade, trans/;

*	Partition the supply-use tables to obtain coeffient arrays which defined
*	ATMs:

parameter
	y0(g)		Aggregate supply,
	yd0(g)		Domestic supply,
	va0(s)		Value-added,
	id0(g,s)	Intermediate demand,
	x0(g)		Regional exports
	ms0(g,mrg)	Margin supply,
	md0(g,mrg)	Margin demand,
	fd0(g,xd)	Final demand,
	cd0(g)		Consumer demand,
	a0(g)		Absorption,
	m0(g)		Imports;

singleton set yb(yrs) /%yr%/;

va0(g(cu)) = sum(ru$(not g(ru)), use(yb,ru,cu));
y0(g) = sum(ru,iot(yb,ru,g));
x0(g(ru)) = iot(yb,ru,"f040");
m0(g(ru)) = iot(yb,ru,"mcif") + iot(yb,ru,"madj") + iot(yb,ru,"mdty");
md0(g(ru),mrg(c)) = max(0,-iot(yb,ru,c));
ms0(g(ru),mrg(c)) = max(0,iot(yb,ru,c));
yd0(g) = y0(g) - x0(g);
cd0(g(ru)) = iot(yb,ru,"F010");
fd0(g(ru),xd(cu)) = iot(yb,ru,cu);
id0(g(ru),s(cu)) = iot(yb,ru,cu);
a0(g) = sum(s,id0(g,s)) + cd0(g) + sum(xd,fd0(g,xd));
display md0, ms0;

set	ags(s)  Agricultural sectors/ 
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

parameter	atmval(g,*)	Trade multiplier for comparison;

*	1. Set up a least squares model to compute the ATMs.

variables	v_PY(g)		Content of domestic commodity,
		v_PA(g)		Content of absorption,
		v_PI(mrg)	Content of margin;

equations	def_PY, def_PI, def_PA;

def_PY(s)$y0(s)..	v_PY(s) * y0(s) =e= sum(g,v_PA(g)*id0(g,s)) + y0(s)$ags(s);
def_PI(mrg)..		v_PI(mrg)*sum(g,ms0(g,mrg))  =e= sum(g,v_PY(g)*ms0(g,mrg));
def_PA(g)$a0(g)..	v_PA(g)*a0(g) =e= v_PY(g)*(y0(g)-x0(g)) + sum(mrg,v_PI(mrg)*md0(g,mrg));

v_PY.FX(g)$(not y0(g)) = 0;
v_PA.FX(g)$(not a0(g)) = 0;

model atmsys /def_PY.v_PY, def_PI.v_PI, def_PA.v_PA /;

solve atmsys using mcp;

$ondotl
atmval(g,"mcp")$x0(g) = (v_PY(g) - 1$ags(g));

*	2. Compute ATM values iteratively.

parameter	v_PYn(g)	Lagged content
		dev		Deviation /1/
		iter_log	Iteration log;

set	iter /iter1*iter25/;

v_PY(ags(s)) = 1$y0(s);
loop(iter$round(dev,2),
	v_PI(mrg) =  sum(g,v_PY(g)*ms0(g,mrg))/sum(g,ms0(g,mrg));
	v_PA(g)$a0(g) = ( v_PY(g)*yd0(g) + sum(mrg,v_PI(mrg)*md0(g,mrg))) / a0(g);
	v_PYn(s)$y0(s) = ( sum(g,v_PA(g)*id0(g,s)) + y0(s)$ags(s) ) / y0(s);
	dev = sum(s, abs(v_PYn(s)-v_PY(s)));
	v_PY(s) = v_PYn(s);
	iter_log(iter,"dev") = dev;
);
display iter_log;

atmval(g,"iter")$x0(g) = (v_PY(g) - 1$ags(g));

option atmval:0:1:1;
display atmval;

set	r	States (inserted to produce output data compatible with the state model) /
	AL, AR, AZ, CA, CO, CT, DE, FL, GA, IA, ID, IL, IN, KS, KY, LA, MA,
	MD, ME, MI, MN, MO, MS, MT, NC, ND, NE, NH, NJ, NM, NV, NY, OH, OK,
	OR, PA, RI, SC, SD, TN, TX, UT, VA, VT, WA, WV, WI, WY /;

set	tp	Trade parnters (inserted for compatibility) /
	CHN,CAN,MEX,EUR,OEC,ROW /;

parameter	atm(*,g,*)	Agricultural trade multipliers (summary);
atm("state",g,r) = atmval(g,"mcp");
atm("market",g,tp) = atmval(g,"mcp");
execute_unload 'national.gdx', atm;

