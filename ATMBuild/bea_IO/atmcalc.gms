$title	Calculate ATMs

*	3:Commodity
*	4:Sector
*	5:Sector
*	6:Commodity


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

set	agg(g)  Agricultural goods/ 
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

set	mrg	/trade, trans/;


parameter
	io(s)		"Industry output",
	co(g)		"Commodity demand",
	mo(mrg)		"Margin output"

	id0(g,s)	"Intermediate demand"
	md0(mrg,g)	"Margin demand"
	ms0(g,mrg)	"Margin supply"
	ys0(s,g)	"Sectoral supply"
	mu(g,mrg)	"Fraction of output directed to margin supply"
	yd0(s,g)	"Domestic supply excluding margin supply",
	ym0(s,mrg)	"Margin supply";

*	Commodity-based:

variables	X(g)	Commodity content ($ agg per $ commodity),
		Y(s)	Sectoral content ($ agg per $ sector output);

*	ATM Calculation: variation 1.  Calculate agricultural commodity
*	output per dollar of commodity or sectoral supply.  Ignore margins.

equations	xdef_1, ydef_1;

*	Commodity composition:

xdef_1(g)..	co(g)*X(g) =e= sum(s,Y(s)*ys0(g,s)) + co(g)$agg(g);

*	Sectoral composition.

ydef_1(s)..	io(s)*Y(s) =e= sum(g, id0(s,g)*X(g));


model atm1 /xdef_1.X, ydef_1.Y/;

*	ATM Calculation: variation 2.  Calculate agricultural sectoral
*	supply per dollar of commodity or sectoral output.  Ignore margins.

equations	xdef_2, ydef_2;

xdef_2(g)..	co(g)*X(g) =e= sum(s,ys0(s,g)*Y(s));

ydef_2(s)..	io(s)*Y(s) =e= sum(g,id0(g,s)*X(g)) + io(s)$ags(s);

model atm2 /xdef_2.X, ydef_2.Y/;

*	ATM Calculation: variation 3.  Calculate agricultural commodity
*	output per dollar of commodity or sectoral supply, incorporating margins.

variable	Z(mrg)		Content of margins;

equations	xdef_3, ydef_3, zdef_3;

xdef_3(g)..	co(g)*X(g) =e=	sum(s,yd0(s,g)*Y(s)) + 
				sum(mrg, md0(mrg,g)*Z(mrg)) + co(g)$agg(g);

ydef_3(s)..	io(s)*Y(s) =e=  sum(g,id0(g,s)*X(g));

zdef_3(mrg)..	Z(mrg)*sum(s,ym0(s,mrg)) =e= sum(s, ym0(s,mrg)*Y(s));

model atm3 /xdef_3.X, ydef_3.Y, zdef_3.Z/;

*	ATM Calculation: variation 4.  Calculate agricultural sectoral
*	supply per dollar of commodity or sectoral output, accounting for
*	margins.

equations	xdef_4, ydef_4, zdef_4;

ydef_4(s)..	io(s)*Y(s) =e=  sum(g,id0(g,s)*X(g)) + io(s)$ags(s);

xdef_4(g)..	co(g)*X(g) =e= sum(s,yd0(s,g)*Y(s)) + 
				sum(mrg,md0(mrg,g)*Z(mrg));

zdef_4(mrg)..	Z(mrg)*sum(s,ym0(s,mrg)) =e= sum(s,ym0(s,mrg)*Y(s));

model atm4 /xdef_4.X, ydef_4.Y, zdef_4.Z/;

*	Identify the base year we are examining.

singleton set yb(yrs) /%yr%/;

parameter	atmval(*,*,*)	Trade multiplier for comparison;

loop(yb(yrs),
	io(s(cs))       = sum(rs(g), supply(yrs,rs,cs));
	co(g(ru))       = sum(cu, use(yrs,ru,cu));
	mo(mrg(cs))     = sum(rs(g),max(0,supply(yrs,rs,cs)));

	X.UP(g) = +inf; X.LO(g) = -inf;
	Y.UP(s) = +inf; Y.LO(s) = -inf;
	Z.UP(mrg) = +inf; Z.LO(mrg) = -inf;
	X.FX(g)$(not co(g)) = 0;
	Y.FX(s)$(not io(s)) = 0;
	Z.FX(mrg)$(not mo(mrg)) = 0;

	id0(g(ru),s(cu)) = use(yrs,ru,cu);
	md0(mrg(cs),g(rs)) = max(0,-supply(yrs,rs,cs));
	ms0(g(rs),mrg(cs)) = max(0, supply(yrs,rs,cs));
	ys0(s(cs),g(rs)) = supply(yrs,rs,cs);
	mu(g,mrg) = (ms0(g,mrg)/sum(s,ys0(s,g)))$sum(s,ys0(s,g));

	yd0(s,g) = ys0(s,g) * (1 - sum(mrg,mu(g,mrg)));

	ym0(s,mrg) = sum(g, ys0(s,g) * mu(g,mrg));

);

ys0(s,g)$(not sameas(g,"pip")) = 0;
yd0(s,g)$(not sameas(g,"pip")) = 0;
md0(mrg,g)$(not sameas(g,"pip")) = 0;
id0(g,s)$(not sameas(g,"pip")) = 0;
co(g)$(not sameas(g,"pip")) = 0;
display yd0, ys0, id0;

$exit

	solve atm1 using mcp;
	atmval("X",g,"atm1") = X.L(g)-1$agg(g);
	atmval("Y",s,"atm1") = Y.L(s);

	solve atm2 using mcp;
	atmval("X",g,"atm2") = X.L(g);
	atmval("Y",s,"atm2") = Y.L(s)-1$ags(s);

	solve atm3 using mcp;
	atmval("X",g,"atm3") = X.L(g)-1$agg(g);
	atmval("Y",s,"atm3") = Y.L(s);
	atmval("Z",mrg,"atm3") = Z.L(mrg);

	solve atm4 using mcp;
	atmval("X",g,"atm4") = X.L(g);
	atmval("Y",s,"atm4") = Y.L(s)-1$ags(s);
	atmval("Z",mrg,"atm4") = Z.L(mrg);

);
option atmval:3:2:1;
display atmval; 

*	Create a diagonal production dataset -- commodity by commodity:

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

*	Partition the supply-use tables to obtain coeffient arrays which defined
*	ATMs:

parameter
	id0(g,s)	Intermediate demand,
	x0(g)		Regional exports
	m0(g)		Imports
	fd0(g,xd)	Final demand,
	cd0(g)		Consumer demand;

x0(g(ru)) = iot(yb,ru,"f040");
m0(g(ru)) = iot(yb,ru,"mcif") + iot(yb,ru,"madj") + iot(yb,ru,"mdty");
md0(mrg(c),g(ru)) = max(0,-iot(yb,ru,c));
ms0(g(ru),mrg(c)) = max(0,iot(yb,ru,c));
cd0(g(ru)) = iot(yb,ru,"F010");
fd0(g(ru),xd(cu)) = iot(yb,ru,cu);
id0(g(ru),s(cu)) = iot(yb,ru,cu);

io(s) = sum(ru,iot(yb,ru,s));
co(g) = sum(s,id0(g,s)) + cd0(g) + sum(xd,fd0(g,xd)) + x0(g);
mo(mrg(c))     = sum(ru(g),max(0,-iot(yb,ru,c)));

equations	xdef_5, ydef_5, zdef_5;

ydef_5(s)..	Y(s)*io(s) =e= sum(g,X(g)*id0(g,s)) + io(s)$ags(s);

xdef_5(g)..	X(g)*co(g) =e= Y(g)*(io(g)-sum(mrg,ms0(g,mrg))) + 
			sum(mrg,Z(mrg)*md0(mrg,g));

zdef_5(mrg)..	Z(mrg)*sum(g,ms0(g,mrg))  =e= sum(g,Y(g)*ms0(g,mrg));

model atm5 /xdef_5.X, ydef_5.Y, zdef_5.Z/;

X.UP(g) = +inf; X.LO(g) = -inf;
Y.UP(s) = +inf; Y.LO(s) = -inf;
Z.UP(mrg) = +inf; Z.LO(mrg) = -inf;
X.FX(g)$(not co(g)) = 0;
Y.FX(s)$(not io(s)) = 0;
Z.FX(mrg)$(not mo(mrg)) = 0;

solve atm5 using mcp;

atmval("X",g,"atm5") = X.L(g);
atmval("Y",s,"atm5") = Y.L(s)-1$ags(s);
atmval("Z",mrg,"atm5") = Z.L(mrg);

equations	xdef_6, ydef_6, zdef_6;

ydef_6(s)..	Y(s)*io(s) =e= sum(g,X(g)*id0(g,s));

xdef_6(g)..	X(g)*co(g) =e= Y(g)*(io(g)-sum(mrg,ms0(g,mrg))) + 
			sum(mrg,Z(mrg)*md0(mrg,g)) + co(g)$agg(g);

zdef_6(mrg)..	Z(mrg)*sum(g,ms0(g,mrg))  =e= sum(g,Y(g)*ms0(g,mrg));

model atm6 /xdef_6.X, ydef_6.Y, zdef_6.Z/;

X.UP(g) = +inf; X.LO(g) = -inf;
Y.UP(s) = +inf; Y.LO(s) = -inf;
Z.UP(mrg) = +inf; Z.LO(mrg) = -inf;
X.FX(g)$(not co(g)) = 0;
Y.FX(s)$(not io(s)) = 0;
Z.FX(mrg)$(not mo(mrg)) = 0;

solve atm6 using mcp;

atmval("X",g,"atm6") = X.L(g)-1$agg(g);
atmval("Y",s,"atm6") = Y.L(s);
atmval("Z",mrg,"atm6") = Z.L(mrg);

option atmval:0:1:1;
display atmval;

execute_unload 'atmval.gdx',atmval;
execute 'gdxxrw i=atmval.gdx o=atmval.xlsx par=atmval rng=PivotData!a2 cdim=0';


$exit


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

