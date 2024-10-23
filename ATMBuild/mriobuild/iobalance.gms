$title	Create an MRIO Dataset with Uniform Import and Local Shares

$if not set yr $set yr 2022

set	s(*)	Sectors,

	s_row(*) Supply table rows (in addition to commodities) 
	s_col(*) Supply table columns (in addition to sectors) 

	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors) ;


$call gams ..\bea_IO\mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s=d s_row s_col u_row u_col

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

	mrg(cs)		Margin accounts /
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


set		yr	Year to balance /%yr%/;

singleton set	yb(yr)	Year to balance /%yr%/;

parameter
	use_n(yr,ru,cu)		The BEA Domestic Use of Commodities by Industries - (Billion of dollars),
	supply_n(yr,rs,cs)	The BEA Domestic Supply of Commodities by Industries - (Billions of dollars);

$gdxin '..\bea_IO\data\iobalanced.gdx'
$load use_n=use  supply_n=supply

*	Convert from millions to billions:

use_n(yr,ru,cu) = use_n(yr,ru,cu) / 1e3;
supply_n(yr,rs,cs) = supply_n(yr,rs,cs) / 1e3;


*	Assess consistency of the interpolated benchmarks:

parameter	profit	Cross check on identities in the original data;
profit(cu(s),yr,"interm")  = sum(ru(g), use_n(yr,ru,cu));
profit(cu(s),yr,vabas(ru)) = use_n(yr,ru,cu);
profit(cs(s),yr,"revenue") = sum(rs(g),supply_n(yr,rs,cs));
profit(s,yr,"balance") = profit(s,yr,"interm") 
        + sum(vabas,profit(s,yr,vabas)) - profit(s,yr,"revenue");
option profit:3:2:1;
display profit;

parameter	impdata(yr,g,imp)	Import data;
impdata(yr,g(rs),imp) = supply_n(yr,rs,imp);
option impdata:3:2:1;
display impdata;

parameter	market	Aggregate market balance;
market(g(rs),yr,"produc")  = sum(cs(s),supply_n(yr,rs,cs));
market(g(rs),yr,"import")  = sum(imp,supply_n(yr,rs,imp));
market(g(rs),yr,"taxes")   = sum(txs,supply_n(yr,rs,txs));
market(g(ru),yr,"interm")  = sum(cu(s),use_n(yr,ru,cu));
market(g(rs),yr,"margins") = sum(mrg,supply_n(yr,rs,mrg));
market(g(ru),yr,"export")  = use_n(yr,ru,"F040");
market(g(ru),yr,"consum") = use_n(yr,ru,"F010");
market(g(ru),yr,"invest")   = sum(inv(cu),use_n(yr,ru,cu));
market(g(ru),yr,"govt")   = sum(gov(cu),use_n(yr,ru,cu));
market(g,yr,"balance") = 
	market(g,yr,"produc") 
	+ market(g,yr,"import") 
	+ market(g,yr,"taxes") 
	+ market(g,yr,"margins") 
	- market(g,yr,"interm") 
	- market(g,yr,"export") 
	- market(g,yr,"consum") 
	- market(g,yr,"invest") 
	- market(g,yr,"govt");
option market:3:2:1;
display market;

parameter	mktchk	Cross check on market clearance;
mktchk(yr,g,"y0") = market(g,yr,"produc")
	+ market(g,yr,"taxes")
	+ market(g,yr,"margins");

mktchk(yr,g,"m0-x0") = market(g,yr,"import")  - market(g,yr,"export");

mktchk(yr,g,"z0") = market(g,yr,"interm") 
	+ market(g,yr,"consum") 
	+ market(g,yr,"invest") 
	+ market(g,yr,"govt");

option mktchk:3:2:1;
display mktchk;

parameter	mrgchk	Cross check on market for margins;
mrgchk(yr,mrg) = sum(g(rs),supply_n(yr,rs,mrg));
option mrgchk:1:1:1;
display mrgchk;

alias (u,*);
profit(s,yr,u)$(not round(profit(s,yr,"balance"),0)) = 0;
market(g,yr,u)$(not round(market(g,yr,"balance"),0)) = 0;
display "Egregious violations of adding-up:", profit, market;

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

parameter
	use(ru,cu,r)		Target use table,
	supply(rs,cs,r)		Target supply table;

set	snz_yr(yr,rs,cs)	Supply table nonzeros, 
	unz_yr(yr,ru,cu)	Use table nonzeros,
	snz_n(rs,cs)		Supply nonzeros in the national table, 
	unz_n(ru,cu)		Use nonzeros in the national table,
	unz(ru,cu,r)		Use table nonzeros - MRIO,
	snz(rs,cs,r)		Supply table nonzeros - MRIO;

option	snz_yr<supply_n,   unz_yr<use_n;
snz_n(rs,cs) = snz_yr(yb,rs,cs);
unz_n(ru,cu) = unz_yr(yb,ru,cu);

*	================================================================================
*	Next, read state-level data used to target the calibration:

set	sagdptbl /
	t1	State annual gross domestic product (GDP) summary
	t2	Gross domestic product (GDP) by state
	t3	Taxes on production and imports less subsidies
	t4	Compensation of employees
	t5	Subsidies
	t6	Taxes on production and imports
	t7	Gross operating surplus
	t8	Chain-type quantity indexes for real GDP by state (2017=100.0)
	t9	Real GDP by state
	t11	Contributions to percent change in real GDP /

parameter	sagdp(r,s,yr,sagdptbl)	State Annual GDP dataset;
$gdxin '..\statedata\sagdp.gdx'
$onUNDF
$load sagdp
sagdp(r,s,yr,sagdptbl)$(sagdp(r,s,yr,sagdptbl) = undf) = 0;

set	sagdpyr(yr);
option sagdpyr<sagdp;
sagdpyr(yr) = not sagdpyr(yr);
option sagdpyr:0:0:1;
display sagdpyr;

parameter	cr(yr,r,s)	Cash receipts for agricultural sectors;
$gdxin '..\statedata\fiws.gdx'
$load cr
cr(yr,r,s) = 1e-6*cr(yr,r,s);

set	cryr(yr)	Years with missing cash receipts;
option cryr<cr;
cryr(yr) = not cryr(yr);
option cryr:0:0:1;
display cryr;

set	ags(s)		Agricultural sectors;
option ags<cr;
ags(ags) = s(ags);
option ags:0:0:1;
display ags;

option cr:3:2:1;
display cr;

parameter	totgdp(yr,s)	Total GDP,
		crtot(yr,s)	Total cash receipts;

totgdp(yr,s)   = sum(r,sagdp(r,s,yr,"t2"));
crtot(yr,ags(s)) = sum(r,cr(yr,r,s));
display crtot;

set	sarow	Data rows in the summary table /
	1	"Real GDP (millions of chained 2017 dollars) 1/"
	2	"Real personal income (millions of constant (2017) dollars) 2/"
	3	"Real PCE (millions of constant (2017) dollars) 3/"
	4	"Gross domestic product (GDP) ",
	5	"Personal income ",
	6	"Disposable personal income ",
	7	"Personal consumption expenditures ",
	8	"Real per capita personal income 4/",
	9	"Real per capita PCE 5/"
	10	"Per capita personal income 6/"
	11	"Per capita disposable personal income 7/"
	12	"Per capita personal consumption expenditures (PCE) 8/"
	13	"Regional price parities (RPPs) 9/"
	14	"Implicit regional price deflator 10/"
	15	"Total employment (number of jobs) "/;

parameter	sasummary(r,sarow,yr)	Summary data;
$gdxin '..\statedata\sasummary.gdx'
$load sasummary

set	sayr(yr)	Years missing from sasummary;
option sayr<sasummary;
sayr(yr) = not sayr(yr);
option sayr:0:0:1;
display sayr;
*	================================================================================

*	N.B. Here is where the state-level data are used to target disaggregation of
*	the national table.  More work is warranted to reflect on the state data targets.

parameter	theta(u,r)		State shares of economic activity;

*	Shares of sectoral GDP:

theta(s,r)$sagdp(r,s,yb,"t2") = sagdp(r,s,yb,"t2")/totgdp(yb,s);

*	Use cash receipts to target agricultural sectors:

theta(ags(s),r) = 0;
theta(ags(s),r)$cr(yb,r,s) = cr(yb,r,s)/crtot(yb,s);

theta("pce",r) = sasummary(r,"7",yb)/sum(r.local,sasummary(r,"7",yb));
theta("gdp",r) = sasummary(r,"4",yb)/sum(r.local,sasummary(r,"4",yb));

parameter	gdpshr;
gdpshr(r,yr) = sasummary(r,"4",yb)/sum(r.local,sasummary(r,"4",yb));
display gdpshr;

*	At a later point we will find data sources for slg, fed and inv:

theta("slg",r) = theta("gdp",r);
theta("fed",r) = theta("gdp",r);
theta("inv",r) = theta("gdp",r);

parameter	scaling		Report on nonzero scale factors;
scaling("nonzeros","snz") = card(snz_n);
scaling("nonzeros","unz") = card(unz_n);
scaling("aveabs","snz") = sum(snz_n,abs(supply_n(yb,snz_n)))/card(snz_n);;
scaling("aveabs","unz") = sum(unz_n,abs(use_n(yb,unz_n)))/card(unz_n);;
option scaling:1:1:1;
display scaling;

*	Insert values which permit us to find coefficients which 
*	have been ignored:

use(unz(ru,cu,r))    = UNDF;
supply(snz(rs,cs,r)) = UNDF;

*	National tables are use_n and supply_n.  State tables are
*	use and supply.

*	Sectoral activity projected with sagdp and cr data:

use(unz(unz_n(ru,cu(s)),r))     = theta(s,r)*use_n(yb,unz_n);
supply(snz(snz_n(rs,cs(s)),r))	= theta(s,r)*supply_n(yb,snz_n);

*	Components of final demand:

use(unz(unz_n(ru,pce),r))	= theta("pce",r)*use_n(yb,unz_n);
use(unz(unz_n(ru,inv),r))	= theta("inv",r)*use_n(yb,unz_n);
use(unz(unz_n(ru,fed),r))	= theta("fed",r)*use_n(yb,unz_n);
use(unz(unz_n(ru,slg),r))	= theta("slg",r)*use_n(yb,unz_n);

parameter	sshare(g,r)	Regional shares of good supply,
		dshare(g,r)	Regional shares of demand
		mshare(mrg,r)	Margin shares,
		totd(g)		Total demand
		tots(g)		Total supply,
		totm(mrg)	Total margin demand;

*	Share of supply:

tots(g(rs)) = sum((cs(s),r), supply(rs,cs,r));
sshare(g,r)$tots(g) = sum(snz(rs(g),cs(s),r),supply(snz))/tots(g);

*	Starting point assumption: exports are proportional to production:

use(unz(unz_n(ru(g),export),r)) = sshare(g,r) * use_n(yb,unz_n);

*	Share of demand:

totd(g(ru)) = sum((unz(ru,cu(s),r)), use(unz)) +
	      sum((unz(ru,fd,r)),    use(unz)); 

*	Region r share of good g demand:

dshare(g(ru),r)$totd(g) = 

*		Intermediate demand:
		( sum(unz(ru,cu(s),r), use(unz)) +

*		Final demand:
		  sum(unz(ru,fd,r),  use(unz)) ) / totd(g);

*	Demand share scales all elements of demacct (which include imports and taxes):

supply(snz(snz_n(rs(g),demacct),r)) = dshare(g,r) * supply_n(yb,snz_n);

*	Margin demand follows absorption:

supply(snz(snz_n(rs(g),mrg),r))$(supply_n(yb,snz_n)>0) = dshare(g,r) * supply_n(yb,snz_n);

*	Total margin use from the national table:

totm(mrg) = sum(snz_n(rs(g),mrg),max(0,supply_n(yb,snz_n)));

*	Region r share of margin demand:

mshare(mrg,r)$totm(mrg) = 
	sum(snz_n(rs(g),mrg), dshare(g,r)*max(0,supply_n(yb,snz_n))) / totm(mrg);

*	Margin demand or supply:

supply(snz_n(rs(g),mrg),r) = dshare(g,r) * max(0,supply_n(yb,snz_n)) +
		mshare(mrg,r) * min(0,supply_n(yb,snz_n));

set	missing		Coefficients which are not targetted;
missing("use",unz(ru,cu,r)) = yes$(use(unz)=UNDF);
missing("supply",snz(rs,cs,r)) = yes$(supply(snz)=UNDF);

*	Identify accounts which are totals and can therefore be omitted:

set	cu_totals(cu) /
		T001	"Total intermediate",
		T019	"Total use of products" /,

	cs_totals(cs) /
		T007	"Total commodity output",
		T013	"Total product supply (basic prices)",
		T014	"Total trade and transportation margins",
                T015    "Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)" /;

missing("use",   unz(ru,cu_totals,r)) = no;
missing("supply",snz(rs,cs_totals,r)) = no;
option missing:0:0:1;
display missing;
abort$card(missing) "Missing coefficients!";

*	Set up a proportional dataset:

parameter	asupply(g,r)	Aggregate supply
		ademand(g,r)	Aggregate demand,
		aimport(g)	Aggregate imports,
		aexport(g)	Aggregate exports;

set		gb(g)	Market to balance;	

*	At this point we have production and absoprtion by commodity and
*	state, and we have imports and exports for the nation.  We set up 
*	a linear program to identify a feasible set of state-level imports
*	and exports.

nonnegative
variables
	YN(g,r)		Interstate sales of good g from state s,
	YX(g,r)		Export supply of good g from state s,
	YD(g,r)		Local demand and supply of good g in state s,
	ND(g,r)		National market demand for good g in state s,
	MD(g,r)		Import market demand for good g in state s
	THETAD(g)	Average local domestic share
	THETAM(g)	Average import share;

variable
	OBJ		Objective function;

equations objdef, output, demand, national, imports, exports, MDdef, YDdef;

objdef..		OBJ =e= sum(gb(g),THETAD(g));

output(gb(g),r)..	YD(g,r) + YN(g,r) + YX(g,r) =e= asupply(g,r);

demand(gb(g),r)..	YD(g,r) + ND(g,r) + MD(g,r) =e= ademand(g,r);

national(gb(g))..	sum(r,YN(g,r))  =e= sum(r,ND(g,r));

imports(gb(g))..	sum(r, MD(g,r)) =e= aimport(g);

exports(gb(g))..	sum(r, YX(g,r)) =e= aexport(g);

MDdef(gb(g),r)..	MD(g,r)         =e= THETAM(g) * ademand(g,r);
	
YDdef(gb(g),r)..	YD(g,r)         =e= THETAD(g) * asupply(g,r);

model calibrate /objdef, output, demand, national, imports, exports, MDdef, YDdef/;

option snz<supply, unz<use;

parameter	inventory	Negative investment treated as inventory release;
inventory(g,r) = -sum(unz(ru(g),inv,r),   min(0,use(unz)));
display inventory;

aimport(g) = round(sum(snz_n(rs(g),imp), supply_n(yb,snz_n)),6);

THETAM.LO(g)$(aimport(g)<0) = -inf;
MD.LO(g,r)$(aimport(g)<0) = -inf;

aexport(g)   =	sum(unz_n(ru(g),export), use_n(yb,unz_n));

asupply(g,r) =	sum(snz(rs(g),cs(s),r), supply(snz)) + inventory(g,r);

ademand(g,r) =  sum(unz(ru(g),cu(s),r),	use(unz)) +
		sum(unz(ru(g),fd,r),    use(unz))  -
		sum(snz(rs(g),mrg,r), supply(snz)) -
		sum(snz(rs(g),txs,r), supply(snz)) +
		inventory(g,r);

THETAD.UP(g) = 1;
THETAM.UP(g) = 1;

PARAMETER	caliblog	Log of calibration;
calibrate.solvelink = 5;
calibrate.holdfixed = 1;
option solprint=off, sysout=off, limrow=0, limcol=0;
loop(gg,
	gb(g) = yes$sameas(g,gg);
	option qcp=cplex;
	solve calibrate using qcp maximizing OBJ;
	caliblog(gg,"THETAM") = THETAM.L(gg);
	caliblog(gg,"THETAD") = THETAD.L(gg);
	caliblog(gg,"modelstat") = calibrate.modelstat;
	caliblog(gg,"solvestat") = calibrate.solvestat;
);
display caliblog;

*	Introduce inter-state trade flows into the MRIO accounts.  For the present
*	this only include shipments to and from the merged national market.

parameter	alpham(g,r)	Regional share of imports;

set	iimp(cs)	International imports /
		MDTY	"Import duties",
		MCIF	"Imports",
		MADJ	"CIF/FOB Adjustments on Imports" /;

alpham(g(rs),r)$sum(snz_n(rs,iimp),1) = MD.L(g,r)/sum(iimp,supply_n(yb,rs,iimp));
supply(snz_n(rs(g),iimp),r) = alpham(g,r) * supply_n(yb,snz_n);
supply(rs(g),"MCIF_N",r) = ND.L(g,r);
use(ru(g),"F040",r)   = YX.L(g,r);
use(ru(g),"F040_N",r) = YN.L(g,r);
option snz<supply, unz<use;

parameter	rmarket	Regional market;
rmarket(r,g,"supply") = sum(snz(rs(g),cs(s),r),supply(snz)) + 
			sum(snz(rs(g),txs,r),supply(snz)) +
			sum(snz(rs(g),mrg,r),supply(snz)) + inventory(g,r);
rmarket(r,g,"import") = sum(snz(rs(g),imp,r), supply(snz));
rmarket(r,g,"export") = sum(unz(ru(g),export,r),use(unz));
rmarket(r,g,"demand") =   sum(unz(ru(g),cu(s),r),use(unz))
			+ sum(unz(ru(g),fd,r),use(unz))+inventory(g,r);
rmarket(r,g,"chk") =	rmarket(r,g,"supply") +
			rmarket(r,g,"import") -
			rmarket(r,g,"export") - 
			rmarket(r,g,"demand");
option rmarket:3:2:1;
display rmarket;

parameter	details		Market details;
details(r,g,"product") = sum(snz(rs(g),cs(s),r), supply(snz));
details(r,g,"import") = sum(snz(rs(g),imp,r), supply(snz));
details(r,g,"export") = sum(unz(ru(g),export,r),use(unz));
details(r,g,"taxes")  = sum(snz(rs(g),txs,r),supply(snz));
details(r,g,"margin") = sum(snz(rs(g),mrg,r),supply(snz));
details(r,g,"intdmd") = sum(unz(ru(g),cu(s),r),use(unz));
details(r,g,"gov") = sum(unz(ru(g),gov,r),use(unz));
details(r,g,"inventory") = inventory(g,r);
details(r,g,"inv") = sum(unz(ru(g),inv,r),use(unz)) + inventory(g,r);
details(r,g,"pce") = sum(unz(ru(g),pce,r),use(unz));
option details:1:2:1;
display details;

set	gtrd	Trade sectors in gravity routine /

*	Aggregated sectors:

	fof	"Forestry and fishing",
	fbp	"Food and beverage and tobacco products (311FT)"
	alt	"Apparel and leather and allied products (315AL)"
	pmt	"Primary metals (331)"
	ogs	"Crude oil and natural gas"
	uti	"Utilities (electricity-gas-water)"
	oxt	"Coal, minining and supporting activities"

*	Individual agricultural sectors:

	PDR 	"Paddy rice (not used)",
	WHT 	"Wheat (not used)",
	GRO 	"Cereal grains nec",
	V_F 	"Vegetables, fruit, nuts",
	OSD 	"Oil seeds",
	C_B 	"Sugar cane, sugar beet",
	PFB 	"Plant-based fibers",
	OCR 	"Crops nec",
	CTL 	"Bovine cattle, sheep, goats and horses",
	OAP 	"Animal products nec",
	WOL 	"Wool, silk-worm cocoons",
	RMK	"Milk"

	TEX	"Textiles",
	LUM	"Lumber and wood products",
	NMM	"Mineral products nec",
	FMP	"Metal products",
	MVH	"Motor vehicles and parts",
	OTN	"Transport equipment nec",
	OME	"Machinery and equipment nec",
	OIL	"Petroleum, coal products",
	PPP	"Paper products, publishing",
	CRP	"Chemical, rubber, plastic products",
	EEQ	"Electronic equipment",
	OMF	"Manufactures nec"
/;

set g_gtrd(g,gtrd)	Mapping from detailed commodities to traded commodities /
	oil.ogs      "Oil and gas extraction (211000)",
	osd_agr.osd  "Oilseed farming (1111A0)",
	grn_agr.gro  "Grain farming (1111B0)",
	veg_agr.v_f  "Vegetable and melon farming (111200)",
	nut_agr.v_f  "Fruit and tree nut farming (111300)",
	flo_agr.v_f  "Greenhouse, nursery, and floriculture production (111400)",
	oth_agr.ocr  "Other crop farming (111900)",
	bef_agr.ctl  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
	egg_agr.oap  "Poultry and egg production (112300)",
	ota_agr.oap  "Animal production, except cattle and poultry and eggs (112A00)",
	log_fof.fof  "Forestry and logging (113000)",
	fht_fof.fof  "Fishing, hunting and trapping (114000)",
	saf_fof.fof  "Support activities for agriculture and forestry (115000)",
	col_min.oxt  "Coal mining (212100)",
	led_min.oxt  "Copper, nickel, lead, and zinc mining (212230)",
	ore_min.oxt  "Iron, gold, silver, and other metal ore mining (2122A0)",
	stn_min.oxt  "Stone mining and quarrying (212310)",
	oth_min.oxt  "Other nonmetallic mineral mining and quarrying (2123A0)",
	drl_smn.ogs  "Drilling oil and gas wells (213111)",
	oth_smn.ogs  "Other support activities for mining (21311A)",
	ele_uti.uti  "Electric power generation, transmission, and distribution (221100)",
	gas_uti.uti  "Natural gas distribution (221200)",
	wat_uti.uti  "Water, sewage and other systems (221300)",
	saw_wpd.lum  "Sawmills and wood preservation (321100)",
	ven_wpd.lum  "Veneer, plywood, and engineered wood product manufacturing (321200)",
	mil_wpd.lum  "Millwork (321910)",
	owp_wpd.lum  "All other wood product manufacturing (3219A0)",
	cly_nmp.nmm  "Clay product and refractory manufacturing (327100)",
	gla_nmp.nmm  "Glass and glass product manufacturing (327200)",
	cmt_nmp.nmm  "Cement manufacturing (327310)",
	cnc_nmp.nmm  "Ready-mix concrete manufacturing (327320)",
	cpb_nmp.nmm  "Concrete pipe, brick, and block manufacturing (327330)",
	ocp_nmp.nmm  "Other concrete product manufacturing (327390)",
	lme_nmp.nmm  "Lime and gypsum product manufacturing (327400)",
	abr_nmp.nmm  "Abrasive product manufacturing (327910)",
	cut_nmp.nmm  "Cut stone and stone product manufacturing (327991)",
	tmn_nmp.nmm  "Ground or treated mineral and earth manufacturing (327992)",
	wol_nmp.nmm  "Mineral wool manufacturing (327993)",
	mnm_nmp.nmm  "Miscellaneous nonmetallic mineral products (327999)",
	irn_pmt.pmt  "Iron and steel mills and ferroalloy manufacturing (331110)",
	stl_pmt.pmt  "Steel product manufacturing from purchased steel                        (331200)",
	ala_pmt.pmt  "Alumina refining and primary aluminum production (331313)",
	alu_pmt.pmt  "Aluminum product manufacturing from purchased aluminum (33131B)",
	nms_pmt.pmt  "Nonferrous metal (except aluminum) smelting and refining (331410)",
	cop_pmt.pmt  "Copper rolling, drawing, extruding and alloying (331420)",
	nfm_pmt.pmt  "Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)",
	fmf_pmt.pmt  "Ferrous metal foundries (331510)",
	nff_pmt.pmt  "Nonferrous metal foundries (331520)",
	rol_fmt.fmp  "Custom roll forming (332114)",
	fss_fmt.fmp  "All other forging, stamping, and sintering (33211A)",
	crn_fmt.fmp  "Metal crown, closure, and other metal stamping (except automotive) (332119)",
	cut_fmt.fmp  "Cutlery and handtool manufacturing (332200)",
	plt_fmt.fmp  "Plate work and fabricated structural product manufacturing (332310)",
	orn_fmt.fmp  "Ornamental and architectural metal products manufacturing (332320)",
	pwr_fmt.fmp  "Power boiler and heat exchanger manufacturing (332410)",
	mtt_fmt.fmp  "Metal tank (heavy gauge) manufacturing (332420)",
	mtc_fmt.fmp  "Metal can, box, and other metal container (light gauge) manufacturing (332430)",
	hdw_fmt.fmp  "Hardware manufacturing (332500)",
	spr_fmt.fmp  "Spring and wire product manufacturing (332600)",
	mch_fmt.fmp  "Machine shops (332710)",
	tps_fmt.fmp  "Turned product and screw, nut, and bolt manufacturing (332720)",
	ceh_fmt.fmp  "Coating, engraving, heat treating and allied activities (332800)",
	plb_fmt.fmp  "Plumbing fixture fitting and trim manufacturing (332913)",
	vlv_fmt.fmp  "Valve and fittings other than plumbing (33291A)",
	bbr_fmt.fmp  "Ball and roller bearing manufacturing (332991)",
	fab_fmt.fmp  "Fabricated pipe and pipe fitting manufacturing (332996)",
	amn_fmt.fmp  "Ammunition, arms, ordnance, and accessories manufacturing (33299A)",
	omf_fmt.fmp  "Other fabricated metal manufacturing (332999)",
	frm_mch.ome  "Farm machinery and equipment manufacturing (333111)",
	lwn_mch.ome  "Lawn and garden equipment manufacturing (333112)",
	con_mch.ome  "Construction machinery manufacturing (333120)",
	min_mch.ome  "Mining and oil and gas field machinery manufacturing (333130)",
	smc_mch.ome  "Semiconductor machinery manufacturing (333242)",
	oti_mch.ome  "Other industrial machinery manufacturing (33329A)",
	opt_mch.ome  "Optical instrument and lens manufacturing (333314)",
	pht_mch.ome  "Photographic and photocopying equipment manufacturing (333316)",
	oci_mch.ome  "Other commercial and service industry machinery manufacturing (333318)",
	hea_mch.ome  "Heating equipment (except warm air furnaces) manufacturing (333414)",
	acn_mch.ome  "Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)",
	air_mch.ome  "Industrial and commercial fan and blower and air purification equipment manufacturing (333413)",
	imm_mch.ome  "Industrial mold manufacturing (333511)",
	spt_mch.ome  "Special tool, die, jig, and fixture manufacturing (333514)",
	mct_mch.ome  "Machine tool manufacturing (333517)",
	cut_mch.ome  "Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)",
	tbn_mch.ome  "Turbine and turbine generator set units manufacturing (333611)",
	spd_mch.ome  "Speed changer, industrial high-speed drive, and gear manufacturing (333612)",
	mch_mch.ome  "Mechanical power transmission equipment manufacturing (333613)",
	oee_mch.ome  "Other engine equipment manufacturing (333618)",
	agc_mch.ome  "Air and gas compressor manufacturing (333912)",
	ppe_mch.ome  "Measuring, dispensing, and other pumping equipment manufacturing (333914)",
	mat_mch.ome  "Material handling equipment manufacturing (333920)",
	pwr_mch.ome  "Power-driven handtool manufacturing (333991)",
	pkg_mch.ome  "Packaging machinery manufacturing (333993)",
	ipf_mch.ome  "Industrial process furnace and oven manufacturing (333994)",
	ogp_mch.ome  "Other general purpose machinery manufacturing (33399A)",
	fld_mch.ome  "Fluid power process machinery (33399B)",
	ecm_cep.eeq  "Electronic computer manufacturing (334111)",
	csd_cep.eeq  "Computer storage device manufacturing (334112)",
	ctm_cep.eeq  "Computer terminals and other computer peripheral equipment manufacturing (334118)",
	tel_cep.eeq  "Telephone apparatus manufacturing (334210)",
	brd_cep.eeq  "Broadcast and wireless communications equipment (334220)",
	oce_cep.eeq  "Other communications equipment manufacturing (334290)",
	sem_cep.eeq  "Semiconductor and related device manufacturing (334413)",
	prc_cep.eeq  "Printed circuit assembly (electronic assembly) manufacturing (334418)",
	oec_cep.eeq  "Other electronic component manufacturing (33441A)",
	eea_cep.eeq  "Electromedical and electrotherapeutic apparatus manufacturing (334510)",
	sdn_cep.eeq  "Search, detection, and navigation instruments manufacturing (334511)",
	aec_cep.eeq  "Automatic environmental control manufacturing (334512)",
	ipv_cep.eeq  "Industrial process variable instruments manufacturing (334513)",
	tfl_cep.eeq  "Totalizing fluid meter and counting device manufacturing (334514)",
	els_cep.eeq  "Electricity and signal testing instruments manufacturing (334515)",
	ali_cep.eeq  "Analytical laboratory instrument manufacturing (334516)",
	irr_cep.eeq  "Irradiation apparatus manufacturing (334517)",
	wcm_cep.eeq  "Watch, clock, and other measuring and controlling device manufacturing (33451A)",
	aud_cep.eeq  "Audio and video equipment manufacturing (334300)",
	mmo_cep.eeq  "Manufacturing and reproducing magnetic and optical media (334610)",
	elb_eec.eeq  "Electric lamp bulb and part manufacturing (335110)",
	ltf_eec.eeq  "Lighting fixture manufacturing (335120)",
	sea_eec.eeq  "Small electrical appliance manufacturing (335210)",
	ham_eec.eeq  "Major household appliance manufacturing",
	pwr_eec.eeq  "Power, distribution, and specialty transformer manufacturing (335311)",
	mtg_eec.eeq  "Motor and generator manufacturing (335312)",
	swt_eec.eeq  "Switchgear and switchboard apparatus manufacturing (335313)",
	ric_eec.eeq  "Relay and industrial control manufacturing (335314)",
	sbt_eec.eeq  "Storage battery manufacturing (335911)",
	pbt_eec.eeq  "Primary battery manufacturing (335912)",
	cme_eec.eeq  "Communication and energy wire and cable manufacturing (335920)",
	wdv_eec.eeq  "Wiring device manufacturing (335930)",
	cbn_eec.eeq  "Carbon and graphite product manufacturing (335991)",
	oee_eec.eeq  "All other miscellaneous electrical equipment and component manufacturing (335999)",
	atm_mot.mvh  "Automobile manufacturing (336111)",
	ltr_mot.mvh  "Light truck and utility vehicle manufacturing (336112)",
	htr_mot.mvh  "Heavy duty truck manufacturing (336120)",
	mbd_mot.mvh  "Motor vehicle body manufacturing (336211)",
	trl_mot.mvh  "Truck trailer manufacturing (336212)",
	hom_mot.mvh  "Motor home manufacturing (336213)",
	cam_mot.mvh  "Travel trailer and camper manufacturing (336214)",
	gas_mot.mvh  "Motor vehicle gasoline engine and engine parts manufacturing (336310)",
	eee_mot.mvh  "Motor vehicle electrical and electronic equipment manufacturing (336320)",
	tpw_mot.mvh  "Motor vehicle transmission and power train parts manufacturing (336350)",
	trm_mot.mvh  "Motor vehicle seating and interior trim manufacturing (336360)",
	stm_mot.mvh  "Motor vehicle metal stamping (336370)",
	omv_mot.mvh  "Other motor vehicle parts manufacturing (336390)",
	brk_mot.mvh  "Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)",
	air_ote.otn  "Aircraft manufacturing (336411)",
	aen_ote.otn  "Aircraft engine and engine parts manufacturing (336412)",
	oar_ote.otn  "Other aircraft parts and auxiliary equipment manufacturing (336413)",
	mis_ote.otn  "Guided missile and space vehicle manufacturing (336414)",
	pro_ote.otn  "Propulsion units and parts for space vehicles and guided missiles (33641A)",
	rrd_ote.otn  "Railroad rolling stock manufacturing (336500)",
	shp_ote.otn  "Ship building and repairing (336611)",
	bot_ote.otn  "Boat building (336612)",
	mcl_ote.otn  "Motorcycle, bicycle, and parts manufacturing (336991)",
	mlt_ote.otn  "Military armored vehicle, tank, and tank component manufacturing (336992)",
	otm_ote.otn  "All other transportation equipment manufacturing (336999)",
	cab_fpd.omf  "Wood kitchen cabinet and countertop manufacturing (337110)",
	uph_fpd.omf  "Upholstered household furniture manufacturing (337121)",
	nup_fpd.omf  "Nonupholstered wood household furniture manufacturing (337122)",
	ifm_fpd.omf  "Institutional furniture manufacturing (337127)",
	ohn_fpd.omf  "Other household nonupholstered furniture (33712N)",
	shv_fpd.omf  "Showcase, partition, shelving, and locker manufacturing (337215)",
	off_fpd.omf  "Office furniture and custom architectural woodwork and millwork manufacturing (33721A)",
	ofp_fpd.omf  "Other furniture related product manufacturing (337900)",
	smi_mmf.omf  "Surgical and medical instrument manufacturing (339112)",
	sas_mmf.omf  "Surgical appliance and supplies manufacturing (339113)",
	dnt_mmf.omf  "Dental equipment and supplies manufacturing (339114)",
	oph_mmf.omf  "Ophthalmic goods manufacturing (339115)",
	dlb_mmf.omf  "Dental laboratories (339116)",
	jwl_mmf.omf  "Jewelry and silverware manufacturing (339910)",
	ath_mmf.omf  "Sporting and athletic goods manufacturing (339920)",
	toy_mmf.omf  "Doll, toy, and game manufacturing (339930)",
	ofm_mmf.omf  "Office supplies (except paper) manufacturing (339940)",
	sgn_mmf.omf  "Sign manufacturing (339950)",
	omm_mmf.omf  "All other miscellaneous manufacturing (339990)",
	dog_fbp.fbp  "Dog and cat food manufacturing (311111)",
	oaf_fbp.fbp  "Other animal food manufacturing (311119)",
	flr_fbp.fbp  "Flour milling and malt manufacturing (311210)",
	wet_fbp.fbp  "Wet corn milling (311221)",
	fat_fbp.fbp  "Fats and oils refining and blending (311225)",
	soy_fbp.fbp  "Soybean and other oilseed processing (311224)",
	brk_fbp.fbp  "Breakfast cereal manufacturing (311230)",
	sug_fbp.c_b  "Sugar and confectionery product manufacturing (311300)",
	fzn_fbp.fbp  "Frozen food manufacturing (311410)",
	can_fbp.fbp  "Fruit and vegetable canning, pickling, and drying (311420)",
	chs_fbp.fbp  "Cheese manufacturing (311513)",
	dry_fbp.fbp  "Dry, condensed, and evaporated dairy product manufacturing (311514)",
	mlk_fbp.rmk  "Fluid milk and butter manufacturing (31151A)",
	ice_fbp.fbp  "Ice cream and frozen dessert manufacturing (311520)",
	chk_fbp.fbp  "Poultry processing (311615)",
	asp_fbp.fbp  "Animal (except poultry) slaughtering, rendering, and processing (31161A)",
	sea_fbp.fbp  "Seafood product preparation and packaging (311700)",
	brd_fbp.fbp  "Bread and bakery product manufacturing (311810)",
	cok_fbp.fbp  "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)",
	snk_fbp.fbp  "Snack food manufacturing (311910)",
	tea_fbp.fbp  "Coffee and tea manufacturing (311920)",
	syr_fbp.fbp  "Flavoring syrup and concentrate manufacturing (311930)",
	spc_fbp.fbp  "Seasoning and dressing manufacturing (311940)",
	ofm_fbp.fbp  "All other food manufacturing (311990)",
	pop_fbp.fbp  "Soft drink and ice manufacturing (312110)",
	ber_fbp.fbp  "Breweries (312120)",
	wne_fbp.fbp  "Wineries (312130)",
	why_fbp.fbp  "Distilleries (312140)",
	cig_fbp.fbp  "Tobacco manufacturing (312200)",
	fyt_tex.tex  "Fiber, yarn, and thread mills (313100)",
	fml_tex.tex  "Fabric mills (313200)",
	txf_tex.tex  "Textile and fabric finishing and fabric coating mills (313300)",
	rug_tex.tex  "Carpet and rug mills (314110)",
	lin_tex.tex  "Curtain and linen mills (314120)",
	otp_tex.tex  "Other textile product mills (314900)",
	app_alt.alt  "Apparel manufacturing (315000)",
	lea_alt.alt  "Leather and allied product manufacturing (316000)",
	plp_ppd.ppp  "Pulp mills (322110)",
	ppm_ppd.ppp  "Paper mills (322120)",
	pbm_ppd.ppp  "Paperboard mills (322130)",
	pbc_ppd.ppp  "Paperboard container manufacturing (322210)",
	ppb_ppd.ppp  "Paper bag and coated and treated paper manufacturing (322220)",
	sta_ppd.ppp  "Stationery product manufacturing (322230)",
	toi_ppd.ppp  "Sanitary paper product manufacturing (322291)",
	opp_ppd.ppp  "All other converted paper product manufacturing (322299)",
	pri_pri.ppp  "Printing (323110)",
	sap_pri.ppp  "Support activities for printing (323120)",
	ref_pet.ogs  "Petroleum refineries (324110)",
	pav_pet.ogs  "Asphalt paving mixture and block manufacturing (324121)",
	shn_pet.ogs  "Asphalt shingle and coating materials manufacturing (324122)",
	oth_pet.ogs  "Other petroleum and coal products manufacturing (324190)",
	ptr_che.crp  "Petrochemical manufacturing (325110)",
	igm_che.crp  "Industrial gas manufacturing (325120)",
	sdp_che.crp  "Synthetic dye and pigment manufacturing (325130)",
	obi_che.crp  "Other basic inorganic chemical manufacturing (325180)",
	obo_che.crp  "Other basic organic chemical manufacturing (325190)",
	pmr_che.crp  "Plastics material and resin manufacturing (325211)",
	srf_che.crp  "Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)",
	mbm_che.crp  "Medicinal and botanical manufacturing (325411)",
	phm_che.crp  "Pharmaceutical preparation manufacturing (325412)",
	inv_che.crp  "In-vitro diagnostic substance manufacturing (325413)",
	bio_che.crp  "Biological product (except diagnostic) manufacturing (325414)",
	fmf_che.crp  "Fertilizer manufacturing (325310)",
	pag_che.crp  "Pesticide and other agricultural chemical manufacturing (325320)",
	pnt_che.crp  "Paint and coating manufacturing (325510)",
	adh_che.crp  "Adhesive manufacturing (325520)",
	sop_che.crp  "Soap and cleaning compound manufacturing (325610)",
	toi_che.crp  "Toilet preparation manufacturing (325620)",
	pri_che.crp  "Printing ink manufacturing (325910)",
	och_che.crp  "All other chemical product and preparation manufacturing (3259A0)",
	plm_pla.crp  "Plastics packaging materials and unlaminated film and sheet manufacturing (326110)",
	ppp_pla.crp  "Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)",
	lam_pla.crp  "Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)",
	fom_pla.crp  "Polystyrene foam product manufacturing (326140)",
	ure_pla.crp  "Urethane and other foam product (except polystyrene) manufacturing (326150)",
	bot_pla.crp  "Plastics bottle manufacturing (326160)",
	opm_pla.crp  "Other plastics product manufacturing (326190)",
	tir_pla.crp  "Tire manufacturing (326210)",
	rbr_pla.crp  "Rubber and plastics hoses and belting manufacturing (326220)",
	orb_pla.crp  "Other rubber product manufacturing (326290)" /;

set	gtmap(g)	Goods with corresponding trade sector;
option gtmap<g_gtrd;

set	gt(g)	Goods selected for gravity estimation;

*	Select goods with non-negligible international and interstate
*	imports.

gt(g) = g(g)$((THETAM.L(g)>0.1) and (THETAD.L(g)<0.75) and gtmap(g));

*	But always include the agricultural and food products:
 
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

gt(agr(g)) = g(g)$((THETAM.L(g)>0.01) and (THETAD.L(g)<0.99));

*	Generate a dictionary:

gt(gt) = g(gt);
option gt:0:0:1;
display gt;

*	Only include the selected goods:

g_gtrd(g,gtrd)$(not gt(g)) = no;

parameter	gravitydata(g,*,*)	Benchmark data for the gravity estimation;
gravitydata(gt(g),"total","x0") = sum(unz(ru(g),"F040",r),use(unz));
gravitydata(gt(g),"total","m0") = sum(snz(rs(g),iimp,r),supply(snz));
gravitydata(gt(g),r,"y0") = sum(snz(rs(g),cs(s),r), supply(snz)) + 
			sum(snz(rs(g),txs,r),supply(snz)) +
			sum(snz(rs(g),mrg,r),supply(snz)) + inventory(g,r);
gravitydata(gt(g),r,"a0") = sum(unz(ru(g),cu(s),r),use(unz))
		      + sum(unz(ru(g),fd,r),use(unz))+inventory(g,r);

execute_unload 'gravityinput_%yr%.gdx', gt=g,g_gtrd=g_i,gravitydata;

*	Unload the multi-regional dataset with uniform domestic and import
*	shares across all states:

execute_unload 'supplyuse_%yr%.gdx', supply, use, s;
