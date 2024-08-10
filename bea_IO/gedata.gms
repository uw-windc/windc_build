$title	Partition the Supply and Use Tables to Create a GE Dataset

set	yr	Years with summary tables /1997*2022/,
	s(*)	Sectors
	mrg	Margins /trd,trn/,
	s_row(*) Summary table rows (in addition to commodities) 
	s_col(*) Summary table columns (in addition to sectors) 
	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors) 

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s=d s_row s_col u_row u_col

alias (s,g);


set	rs(*)	Rows in the supply table / (set.s),
		T017	"Total industry supply" /,
	cs(*)	Colums in the supply table / (set.s),
		T007	"Total Commodity Output",
		MCIF	"Imports",
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

	xd(cu)	Exogenous demand /
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
	use(yr,ru,cu)	 The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
	supply(yr,rs,cs) The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

$gdxin 'data\projected.gdx'
$loaddc use  supply

*	Verify consistency of the supply-use table:

set vabas(ru) Value-added at basic prices /V001, V003, T00OTOP, T00OSUB/;

set gov(cu) / F06C, F07C, F10C  /;

set inv(*) / F02E, F02N, F02R, F02S, F030, F06E, F06N,  F06S, F07E, F07N, F07S, F10E, F10N, F10S/

parameter	profit	Cross check on identities in the original data;
profit(cu(s),yr,"interm")  = sum(ru(g), use(yr,ru,cu));
profit(cu(s),yr,vabas(ru)) = use(yr,ru,cu);
profit(cs(s),yr,"revenue") = sum(rs(g),supply(yr,rs,cs));
profit(s,yr,"balance") = profit(s,yr,"interm") 
        + sum(vabas,profit(s,yr,vabas)) - profit(s,yr,"revenue");
option profit:3:2:1;
display profit;

set	mgn(cs) /trade,trans/, imp(cs) /mcif,madj/, txs(cs)/mdty,top,sub/;

parameter	market	Market balance;
market(g(rs),yr,"produc")  = sum(cs(s),supply(yr,rs,cs));
market(g(rs),yr,"import")  = sum(imp,supply(yr,rs,imp));
market(g(rs),yr,"margins") = sum(mgn,supply(yr,rs,mgn));
parameter	margins;
margins(g(rs),yr,mgn) = supply(yr,rs,mgn);
option margins:3:0:1;
display margins;

market(g(rs),yr,"taxes")   = sum(txs,supply(yr,rs,txs));
market(g(ru),yr,"interm")  = sum(cu(s),use(yr,ru,cu));
market(g(ru),yr,"export")  = use(yr,ru,"F040");
market(g(ru),yr,"consum")  = use(yr,ru,"F010");
market(g(ru),yr,"invest")   = sum(inv(cu),use(yr,ru,cu));
market(g(ru),yr,"govt")   = sum(gov(cu),use(yr,ru,cu));
market(g,yr,"balance") = market(g,yr,"produc") + market(g,yr,"import") + market(g,yr,"taxes") -
	market(g,yr,"margins") - market(g,yr,"interm") - market(g,yr,"export") - market(g,yr,"consum") 
	- market(g,yr,"invest") - market(g,yr,"govt");
option market:3:2:1;
display market;

alias (u,*);
profit(s,yr,u)$(not round(profit(s,yr,"balance"),6)) = 0;
market(g,yr,u)$(not round(market(g,yr,"balance"),6)) = 0;
abort$(card(profit)+card(market)) "Inconsistency in projected dataset.",profit,market;

set	r	Regions (singleton for now)   / usa	National data /;

parameter	
	ys0(yr,r,s,g)	Make matrix
	y0(yr,r,g)	Aggregate supply
	ld0(yr,r,s)	Labor demand
	kd0(yr,r,s)	Capital demand
	id0(yr,r,g,s)	Intermediate demand,
	ty0(yr,r,s)	Output tax rate
	vx0(yr,g)	Aggregate exports
	rx0(yr,g)	Re-exports
	x0(yr,r,g)	Regional exports
	ms0(yr,r,g,mrg)	Margin supply,
	yd0(yr,r,g)	Domestic demand,
	ns0(yr,r,g)	Supply to the national market 
	n0(yr,g)	National market aggregate supply
	fd0(yr,r,g,xd)	Final demand
	cd0(yr,r,g)	Consumer demand
	a0(yr,r,g)	Absorption
	nd0(yr,r,g)	National market demand
	m0(yr,r,g)	Imports
	tm0(yr,r,g)	Import tariff
	ta0(yr,r,g)	Product tax
	md0(yr,r,mrg,g)	Margin demand;

set y_(yr,r,s)	Active sectors;

ys0(yr,r,s(cs),g(rs)) = supply(yr,rs,cs);
y0(yr,r,g) = sum(s,ys0(yr,r,s,g));
y_(yr,r,s) = yes$sum(g,ys0(yr,r,s,g));
ld0(yr,r,s(cu)) = use(yr,"v001",cu);
kd0(yr,r,s(cu)) = use(yr,"v003",cu);
id0(yr,r,g(ru),s(cu)) = use(yr,ru,cu);
ty0(y_(yr,r,s(cu))) = (use(yr,"T00OTOP",cu)+use(yr,"T00OSUB",cu))/sum(g,ys0(yr,r,s,g));

vx0(yr,g(ru)) = use(yr,ru,"F040");
rx0(yr,g) = 0;
x0(yr,r,g) = vx0(yr,g);
ms0(yr,r,g(rs),"trd") = max(0,-supply(yr,rs,"trade"));
ms0(yr,r,g(rs),"trn") = max(0,-supply(yr,rs,"trans"));
yd0(yr,r,g)= 0;
ns0(yr,r,g) = y0(yr,r,g) - sum(mrg,ms0(yr,r,g,mrg)) - x0(yr,r,g);
n0(yr,g) = sum(r,ns0(yr,r,g));
fd0(yr,r,g(ru),xd(cu)) = use(yr,ru,cu);
cd0(yr,r,g(ru)) = use(yr,ru,"F010");
a0(yr,r,g) = sum(s,id0(yr,r,g,s)) + cd0(yr,r,g) + sum(xd,fd0(yr,r,g,xd));
nd0(yr,r,g) = ns0(yr,r,g);
m0(yr,r,g(rs)) = supply(yr,rs,"MCIF") + supply(yr,rs,"MADJ");
tm0(yr,r,g(rs))$supply(yr,rs,"MDTY") = supply(yr,rs,"MDTY")/m0(yr,r,g);
ta0(yr,r,g(rs))$(supply(yr,rs,"TOP")+supply(yr,rs,"SUB")) = 
	(supply(yr,rs,"TOP")+supply(yr,rs,"SUB")) / a0(yr,r,g);
md0(yr,r,"trd",g(rs)) = max(0,supply(yr,rs,"trade"));
md0(yr,r,"trn",g(rs)) = max(0,supply(yr,rs,"trans"));

execute_unload 'data\gedata.gdx', yr, r, s, mrg, ys0, y0, ld0, kd0,
	id0, ty0, vx0, rx0, x0, ms0, yd0, ns0, n0, fd0, cd0, a0, nd0, 
	m0, tm0, ta0, md0;

