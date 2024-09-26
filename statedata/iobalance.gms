$title	Partition the Supply and Use Tables to Create a GE Dataset

set	yrs	Years with summary tables /1997*2022/,
	yr(yrs)	Years with summary tables /1998*2022/,
	s(*)	Sectors

	s_row(*) Supply table rows (in addition to commodities) 
	s_col(*) Supply table columns (in addition to sectors) 

	u_row(*) Use table rows (in addition to commodities) 
	u_col(*) Use table columns (in addition to sectors) 

$call gams ..\bea_IO\mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc s=d s_row s_col u_row u_col

alias (s,g,gg);

set	rs(*)	Rows in the supply table / (set.s),
		T017	"Total industry supply" /,

	cs(*)	Columns in the supply table / (set.s),
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

	mrg(cs)		Margin accounts /trade,trans/, 
	imp(cs)		Import accounts /mcif,madj/, 
	txs(cs)		Tax flows /mdty,top,sub/,

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
		F10S  	"State and local: Gross investment in structures" /

	vabas(ru) Value-added at basic prices /V001, V003, T00OTOP, T00OSUB/,

	gov(cu) Government expenditure / F06C, F07C, F10C  /,

	inv(*)	Investment / F02E, F02N, F02R, F02S, F030, F06E, F06N,  F06S, F07E, F07N, F07S, F10E, F10N, F10S/;

parameter
	use_n(yrs,ru,cu)	The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
	supply_n(yrs,rs,cs)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

$gdxin '..\bea_IO\data\iobalanced.gdx'
$loaddc use_n=use  supply_n=supply

*	Assess consistency of the interpolated benchmarks:

parameter	profit	Cross check on identities in the original data;
profit(cu(s),yr,"interm")  = sum(ru(g), use_n(yr,ru,cu));
profit(cu(s),yr,vabas(ru)) = use_n(yr,ru,cu);
profit(cs(s),yr,"revenue") = sum(rs(g),supply_n(yr,rs,cs));
profit(s,yr,"balance") = profit(s,yr,"interm") 
        + sum(vabas,profit(s,yr,vabas)) - profit(s,yr,"revenue");
option profit:3:2:1;
display profit;

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
	- market(g,yr,"margins") 
	- market(g,yr,"interm") 
	- market(g,yr,"export") 
	- market(g,yr,"consum") 
	- market(g,yr,"invest") 
	- market(g,yr,"govt");
option market:3:2:1;
display market;

parameter	mrgchk	Cross check on market for margins;
mrgchk(yr,mrg) = sum(g(rs),supply_n(yr,rs,mrg));
option mrgchk:1:1:1;
display mrgchk;

parameter investinfo;
investinfo(g(ru),inv(cu)) = use_n("2006",ru,cu);
display investinfo;

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

parameter
	use(yr,ru,cu,r)		Target use table,
	supply(yr,rs,cs,r)	Target supply table;

set	unz(ru,cu)		Use table nonzeros,
	snz(rs,cs)		Supply table nonzeros,
	yb(yr)			Year to be balanced;

variables	OBJ, USE_(ru,cu,r), SUPPLY_(rs,cs,r), DX(gg,r), DM(gg,r);
equations	objdef, profitbal, marginbal, marketbal, netsupply, nationalmarket;

objdef..	OBJ =e= sum((yb,snz(rs,cs),r)$supply(yb,snz,r), 
				abs(supply(yb,snz,r)) * sqr(SUPPLY_(snz,r)/supply(yb,snz,r) - 1)) +

			sum((yb,unz(ru,cu),r)$use(yb,unz,r), 
				abs(use(yb,unz,r))    * sqr(USE_(unz,r)/use(yb,unz,r)       - 1));

profitbal(s,r)..

	sum(unz(ru(gg),cu(s)),    USE_(ru,cu,r)) + 

	sum(unz(ru(vabas),cu(s)), USE_(ru,cu,r)) =e= 

		sum(snz(rs(gg),cs(s)), SUPPLY_(rs,cs,r));

marginbal(mrg,r)..
	sum(snz(rs(gg),cs(mrg)), SUPPLY_(rs,cs,r)) =e= 0;


marketbal(gg,r)..

*	Production:
	sum(snz(rs(gg),cs(s)), SUPPLY_(rs,cs,r)) + 

*	International imports:
	sum(snz(rs(gg),imp),     SUPPLY_(rs,imp,r)) +

*	Domestic imports:
	DM(gg,r) +

*	Taxes on imports and domestic:
	sum((rs(gg),txs), SUPPLY_(rs,txs,r)) =e=

*	Supply to margins:
	sum(snz(rs(gg),mrg), SUPPLY_(snz,r)) + 

*	Intermediate demand:
	sum(unz(ru(gg),cu(s)), USE_(ru,cu,r)) + 

*	Final demand plus international exports:
	sum(unz(ru(gg),cu(fd)), USE_(ru,cu,r)) +

*	Domestic exports:
	DX(gg,r);
	
*	Production must be sufficient to cover margins and exports:

netsupply(gg,r)..

*	Domestic supply:
	sum(snz(rs(gg),cs(s)), SUPPLY_(snz,r)) +

*	Margins:
	sum(snz(rs(gg),cs(mrg))$(SUPPLY_.UP(snz,r)=0), SUPPLY_(snz,r))  =g= 

*	Exports:
	sum(unz(ru(gg),"F040"), USE_(ru,"F040",r)) + 

*	Domestic exports:

	DX(gg,r);

*	National market for goods:

nationalmarket(gg)..
	sum(r, DX(gg,r)) =e= sum(r, DM(gg,r));

model lsqcalib /objdef, profitbal, marginbal, marketbal, netsupply, nationalmarket/;

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
$gdxin 'sagdp.gdx'
$onUNDF
$load sagdp
sagdp(r,s,yr,sagdptbl)$(sagdp(r,s,yr,sagdptbl) = undf) = 0;

set	sagdpyr(yr);
option sagdpyr<sagdp;
sagdpyr(yr) = not sagdpyr(yr);
option sagdpyr:0:0:1;
display sagdpyr;

parameter	cr(yr,r,s)	Cash receipts for agricultural sectors;
$gdxin 'fiws.gdx'
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

parameter	totgdp(yr,s)	Total GDP,
		crtot(yr,s)	Total cash receipts;

totgdp(yr,s)   = sum(r,sagdp(r,s,yr,"t2"));
crtot(yr,ags(s)) = sum(r,cr(yr,r,s));
display crtot;

parameter	sshare(yr,s,r)		State shares of sectoral GDP;
sshare(yr,s,r)$sagdp(r,s,yr,"t2") = sagdp(r,s,yr,"t2")/totgdp(yr,s);
sshare(yr,ags(s),r)$cr(yr,r,s) = cr(yr,r,s)/crtot(yr,s);


set	missing(s)	Missing sectors;
option missing<sshare;
missing(s) = s(s)$(not missing(s));
option missing:0:0:1;
display missing;

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
$gdxin 'sasummary.gdx'
$load sasummary

set	sayr(yr)	Years missing from sasummary;
option sayr<sasummary;
sayr(yr) = not sayr(yr);
option sayr:0:0:1;
display sayr;

parameter	cshare(yr,r)	Regional share of consumption;
cshare(yr,r) = sasummary(r,"7",yr)/sum(r.local,sasummary(r,"7",yr));
display cshare;

parameter	gdpshare(yr,r)	Regional shares of GDP;
gdpshare(yr,r) = sasummary(r,"4",yr)/sum(r.local,sasummary(r,"4",yr));
display gdpshare;

*	Default values:

use(yr,ru,cu,r)    = gdpshare(yr,r) *    use_n(yr,ru,cu);
supply(yr,rs,cs,r) = gdpshare(yr,r) * supply_n(yr,rs,cs);

*	GDP shares:

use(yr,ru,cu(s),r) = sshare(yr,s,r)*use_n(yr,ru,cu);
supply(yr,rs,cs(s),r) = sshare(yr,s,r)*supply_n(yr,rs,cs);
supply(yr,rs(g),mrg,r)$sum(cs(s),supply_n(yr,rs,cs))
	= supply_n(yr,rs,mrg)*sum(cs(s),supply(yr,rs,cs,r))/sum(cs(s),supply_n(yr,rs,cs));
use(yr,ru,fd,r) = cshare(yr,r)*use_n(yr,ru,fd);
use(yr,ru,gov,r) = gdpshare(yr,r)*use_n(yr,ru,gov);
use(yr,ru,cu(inv),r) = gdpshare(yr,r)*use_n(yr,ru,cu);

set	snz_yr(yrs,rs,cs), unz_yr(yrs,ru,cu)
option	snz_yr<supply_n,   unz_yr<use_n;

set	run(yr) /set.yr/;

file kput; kput.lw=0; put kput;
option limrow=0, limcol=0;

loop(run(yr),
	yb(yr) = yes;
 
	snz(rs,cs) = snz_yr(yr,rs,cs);
	SUPPLY_.FX(rs,cs,r) = 0;
	SUPPLY_.UP(snz,r) = +inf;  
	SUPPLY_.LO(snz,r) = -inf; 
	SUPPLY_.L(snz,r) = supply_n(yr,snz);

	unz(ru,cu) = unz_yr(yr,ru,cu);
	USE_.FX(ru,cu,r) = 0;
	USE_.UP(unz,r) = +INF; 
	USE_.LO(unz,r) = -INF; 
	USE_.L(unz,r) = use(yr,unz,r);

*	Impose non-negative conditions:

	SUPPLY_.LO(rs(gg),cs(s),r) = 0;
	SUPPLY_.LO(rs(gg),cs(mrg),r)$(supply(yr,rs,cs,r)>0) = 0;
	SUPPLY_.UP(rs(gg),cs(mrg),r)$(supply(yr,rs,cs,r)<0) = 0;
	USE_.LO(ru(gg),cu(s),r) = 0;
	USE_.LO("v001",cu(s),r) = 0;
	USE_.LO("v003",cu(s),r) = 0;
	USE_.LO(ru(gg),"F010",r) = 0;
	USE_.LO(ru(gg),"F040",r) = 0;
	SUPPLY_.LO(snz(rs(gg),"MCIF"),r) = 0;

	put_utility 'title' /'Solving for ',yr.tl;

	option qcp=cplex;
	solve lsqcalib using qcp minimizing obj;

	abort$(lsqcalib.solvestat<>1 or lsqcalib.modelstat<>1) "Error -- least squares calibration problem.";

	supply(yr,rs,cs,r) = SUPPLY_.L(rs,cs,r);
	use(yr,ru,cu,r)    = USE_.L(ru,cu,r);
);

execute_unload 'data\iobalanced.gdx', use, supply;
