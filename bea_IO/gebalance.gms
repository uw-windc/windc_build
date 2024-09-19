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
		F10S  	"State and local: Gross investment in structures" /;

parameter
	use(yr,ru,cu)	 The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
	supply(yr,rs,cs) The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

$gdxin 'data\iounbalanced.gdx'
$loaddc use  supply

set	vabas(ru) Value-added at basic prices /V001, V003, T00OTOP, T00OSUB/,
	gov(cu) Government expenditure / F06C, F07C, F10C  /,
	inv(*)	Investment / F02E, F02N, F02R, F02S, F030, F06E, F06N,  F06S, F07E, F07N, F07S, F10E, F10N, F10S/,
	mgn(cs) Margins /trade,trans/, 
	imp(cs) Imports /mcif,madj/, 
	txs(cs)	Tax flows /mdty,top,sub/;

*	Assess consistency of the interpolated benchmarks:

parameter	profit	Cross check on identities in the original data;
profit(cu(s),yr,"interm")  = sum(ru(g), use(yr,ru,cu));
profit(cu(s),yr,vabas(ru)) = use(yr,ru,cu);
profit(cs(s),yr,"revenue") = sum(rs(g),supply(yr,rs,cs));
profit(s,yr,"balance") = profit(s,yr,"interm") 
        + sum(vabas,profit(s,yr,vabas)) - profit(s,yr,"revenue");
option profit:3:2:1;
display profit;

parameter	market	Aggregate market balance;
market(g(rs),yr,"produc")  = sum(cs(s),supply(yr,rs,cs));
market(g(rs),yr,"import")  = sum(imp,supply(yr,rs,imp));
market(g(rs),yr,"margins") = sum(mgn,supply(yr,rs,mgn));
market(g(rs),yr,"taxes")   = sum(txs,supply(yr,rs,txs));
market(g(ru),yr,"interm")  = sum(cu(s),use(yr,ru,cu));
market(g(ru),yr,"export")  = use(yr,ru,"F040");
market(g(ru),yr,"consum") = use(yr,ru,"F010");
market(g(ru),yr,"invest")   = sum(inv(cu),use(yr,ru,cu));
market(g(ru),yr,"govt")   = sum(gov(cu),use(yr,ru,cu));
market(g,yr,"balance") = market(g,yr,"produc") + market(g,yr,"import") + market(g,yr,"taxes") 
	+ market(g,yr,"margins") - market(g,yr,"interm") - market(g,yr,"export") - market(g,yr,"consum") 
	- market(g,yr,"invest") - market(g,yr,"govt");
option market:3:2:1;
display market;

parameter investinfo;
investinfo(g(ru),inv(cu)) = use("2006",ru,cu);
display investinfo;

alias (u,*);

profit(s,yr,u)$(not round(profit(s,yr,"balance"),0)) = 0;
market(g,yr,u)$(not round(market(g,yr,"balance"),0)) = 0;
display "Egregious violations of adding-up:", profit, market;

*	Partition the supply and use tables:

set	r	Regions (singleton for now)   / usa	National data /;

parameter	
	ld0(yr,r,s)	Labor demand
	kd0(yr,r,s)	Capital demand
	lvs(yr,r,s)	Labor value share
	kl0(yr,r,s)	Aggregate factor earnings (K+L)
	x0(yr,r,g)	Regional exports
	d0(yr,r,g)	Domestic demand,
	rx0(yr,r,g)	Re-exports
	ns0(yr,r,g)	Supply to the national market 
	n0(yr,g)	National market aggregate supply
	a0(yr,r,g)	Absorption
	m0(yr,r,g)	Imports
	ty0(yr,r,s)	Output tax rate
	tm0(yr,r,g)	Import tariff
	ta0(yr,r,g)	Product tax
	nd0(yr,r,g)	National market demand,
	am(yr,r,mrg,g)	Trade and transport margin,
	ms0(yr,r,g,mrg)	Margin supply,
	ys0(yr,r,s,g)	Make matrix
	id0(yr,r,g,s)	Intermediate demand,
	id0(yr,r,g,s)	Intermediate demand,
	cd0(yr,r,g)	Final demand
	fd0(yr,r,g,fd)	Investment and government demand
	md0(yr,r,mrg,g)	Margin demand;

ys0(yr,r,s(cs),g(rs)) = supply(yr,rs,cs); 
ld0(yr,r,s(cu)) = use(yr,"v001",cu);
kd0(yr,r,s(cu)) = use(yr,"v003",cu); 
kl0(yr,r,s) = ld0(yr,r,s) + kd0(yr,r,s);
lvs(yr,r,s)$kl0(yr,r,s) = max(0,min(1,ld0(yr,r,s)/kl0(yr,r,s)));
id0(yr,r,g(ru),s(cu)) = use(yr,ru,cu); 
ms0(yr,r,g(rs),"trd") = max(0,-supply(yr,rs,"trade")); 
ms0(yr,r,g(rs),"trn") = max(0,-supply(yr,rs,"trans")); 
x0(yr,r,g(ru)) = use(yr,ru,"F040");

*	Set re-exports so that domestic sales are at least 50% of production:

rx0(yr,r,g) = max(0, min(x0(yr,r,g), sum(mrg,ms0(yr,r,g,mrg)) + x0(yr,r,g) - 0.5*sum(s,ys0(yr,r,s,g))));

ns0(yr,r,g) = sum(s,ys0(yr,r,s,g)) - sum(mrg,ms0(yr,r,g,mrg)) - x0(yr,r,g) + rx0(yr,r,g); 
fd0(yr,r,g(ru),fd(cu)) = use(yr,ru,cu); 
a0(yr,r,g) = sum(s,id0(yr,r,g,s)) + sum(fd,fd0(yr,r,g,fd)); 
m0(yr,r,g(rs)) = supply(yr,rs,"MCIF") + supply(yr,rs,"MADJ");
md0(yr,r,"trd",g(rs)) = max(0,supply(yr,rs,"trade")); 
md0(yr,r,"trn",g(rs)) = max(0,supply(yr,rs,"trans")); 
ty0(yr,r,s(cu))$(use(yr,"T00OTOP",cu)+use(yr,"T00OSUB",cu)) 
	= (use(yr,"T00OTOP",cu)+use(yr,"T00OSUB",cu))/sum(g,ys0(yr,r,s,g)); 
tm0(yr,r,g(rs))$supply(yr,rs,"MDTY") = supply(yr,rs,"MDTY")/(m0(yr,r,g)-rx0(yr,r,g)); 
ta0(yr,r,g(rs))$(supply(yr,rs,"TOP")+supply(yr,rs,"SUB")) =  
	(supply(yr,rs,"TOP")+supply(yr,rs,"SUB"))/a0(yr,r,g); 
am(yr,r,mrg,g)$md0(yr,r,mrg,g) = md0(yr,r,mrg,g)/a0(yr,r,g); 

*.execute_unload 'margins.gdx', am;
*.execute 'gdxxrw i=margins.gdx o=margins.xlsx par=am rng=PivotData!a2 cdim=0';

*	Adjust imports for markets in which implicit demand for domestic goods is negative:

m0(yr,r,g) = min(m0(yr,r,g), a0(yr,r,g)*(1-ta0(yr,r,g)-sum(mrg,am(yr,r,mrg,g)))/(1+tm0(yr,r,g))) - rx0(yr,r,g);

nd0(yr,r,g) = a0(yr,r,g)*(1-ta0(yr,r,g)-sum(mrg,am(yr,r,mrg,g))) - (m0(yr,r,g)-rx0(yr,r,g))*(1+tm0(yr,r,g));

cd0(yr,r,g) = fd0(yr,r,g,"F010");

parameter	negatives(yr,g,*);
negatives(yr,g,"nd0") = min(0,nd0(yr,"usa",g));
negatives(yr,g,"ns0") = min(0,ns0(yr,"usa",g));
set yr_g(yr,g);
option yr_g<negatives;
negatives(yr_g(yr,g),"ys0") = eps + sum(s,ys0(yr,"usa",s,g));
option negatives:3:2:1;
display negatives;

execute_unload 'data\geunbalanced.gdx', yr, r, s, mrg, ys0, ld0, kd0,
	id0, rx0, x0, ms0, ns0, nd0, fd0, cd0, a0, 
	m0, ty0, tm0, ta0, md0;


set		param /a0, ys0, id0, kl0, cd0, ms0, m0, x0, rx0, nd0, ns0/

singleton set yb(yr)	Region to balance;

parameter	nzc(param)	Nonzero count
		penalty		Penalty on nonzero structure /1e3/;

$if not set abstol $set abstol 6

$macro	target(a,b,d)  sum((&&d), ( abs(a(yb,&&d))*sqr(b(&&d)/a(yb,&&d)-1) )$a(yb,&&d) + (penalty * b(&&d))$(not a(yb,&&d)))
$macro	setlevel(a,b,d)  a.L(&&d) = b(yb,&&d); a.LO(&&d) = 0; a.UP(&&d) = +inf; nzc("&&b") = sum((&&d)$b(yb,&&d),1);
$macro	readsolution(a,b,d)  b(yb,&&d) = a.L(&&d)$round(a.L(&&d),%abstol%); itlog(iter,"&&b") = sum((&&d)$b(yb,&&d),1);

variables	OBJ, A0_(r,g), ND0_(r,g), M0_(r,g), YS0_(r,s,g), CD0_(r,g),
		ID0_(r,g,s), KL0_(r,s), NS0_(r,g), MS0_(r,g,mrg), RX0_(r,g);

equations	objdef, profit_a, profit_y, profit_n, market_pi, market_py, market_pa, rxlim;

objdef..	OBJ =e= target(a0, A0_, "r,g") + 
			target(m0, M0_, "r,g") +
			target(rx0,RX0_,"r,g") +
			target(ys0,YS0_,"r,s,g") +
			target(id0,ID0_,"r,g,s") +
			target(kl0,KL0_,"r,s") +
			target(cd0,CD0_,"r,g") +
			target(ms0,MS0_,"r,g,mrg");

profit_a(yb,r,g)..
	A0_(r,g)*(1-ta0(yb,r,g)-sum(mrg,am(yb,r,mrg,g))) =e= ND0_(r,g) + (M0_(r,g)-RX0_(r,g))*(1+tm0(yb,r,g));

profit_y(r,s)..
	sum(g,YS0_(r,s,g))*(1-ty0(yb,r,s)) =e= sum(g,ID0_(r,g,s)) + KL0_(r,s);

profit_n(g)..
	sum(r,ND0_(r,g)) =e= sum(r,NS0_(r,g));

market_pi(mrg)..
	sum((r,g), am(yb,r,mrg,g)*A0_(r,g)) =e= sum((r,g),MS0_(r,g,mrg));

market_py(r,g)..
	sum(s, YS0_(r,s,g)) =e= x0(yb,r,g) - RX0_(r,g) + NS0_(r,g) + sum(mrg,MS0_(r,g,mrg));

market_pa(r,g)..
	A0_(r,g) =e= sum(s,ID0_(r,g,s)) + CD0_(r,g) + sum(fd$(inv(fd) or gov(fd)),fd0(yb,r,g,fd));

rxlim(r,g)..	RX0_(r,g) =l= M0_(r,g);

model calib /objdef, profit_a, profit_y, profit_n, market_pi, market_py, market_pa, rxlim/;

parameter	dev	Deviation (change in nonzero count);

set	iter /iter1/;

parameter	itlog(iter,*)		Iteration log,
		iterlog(yr,iter)	Iteration log of deviation;

file kput; kput.lw=0; put kput;
loop(yr,
  yb(yr) = yes;	
  dev = 1;
  loop(iter$dev,

	put_utility 'title' / yr.tl,' : ',iter.tl;

*	This assigns initial values and counts nonzeros:

	setlevel(A0_, a0, "r,g")
	setlevel(ND0_, nd0, "r,g")
	setlevel(M0_,  m0, "r,g")
	setlevel(RX0_,  rx0, "r,g")
	setlevel(YS0_, ys0, "r,s,g")
	setlevel(ID0_, id0, "r,g,s")
	setlevel(KL0_, kl0, "r,s")
	setlevel(CD0_, cd0, "r,s")
	setlevel(NS0_, ns0, "r,g")
	setlevel(MS0_, ms0, "r,g,mrg")

	RX0_.UP(r,g) = x0(yb,r,g);

	option qcp = cplex;
	solve calib using qcp minimizing obj;

	abort$(calib.modelstat>2) "Calibration fails -- you will need to check this dataset more carefully";

	readsolution(A0_,  a0, "r,g")
	readsolution(ND0_, nd0, "r,g")
	readsolution(M0_,  m0, "r,g")
	readsolution(YS0_, ys0, "r,s,g")
	readsolution(CD0_, cd0, "r,g")
	readsolution(ID0_, id0, "r,g,s")
	readsolution(KL0_, kl0, "r,s")
	readsolution(NS0_, ns0, "r,g")
	readsolution(MS0_, ms0, "r,g,mrg")
	readsolution(RX0_,  rx0, "r,g")

	md0(yb,r,mrg,g) = am(yr,r,mrg,g)*a0(yr,r,g);
	ld0(yr,r,s) = lvs(yr,r,s)*kl0(yr,r,s);
	kd0(yr,r,s) = (1-lvs(yr,r,s))*kl0(yr,r,s);

	dev$(ord(iter)>1) = sum(param, abs(itlog(iter,param)-nzc(param)));
	itlog(iter,"dev") = dev;
  )
  display itlog;
  iterlog(yr,iter) = itlog(iter,"dev");
  itlog(iter,param) = 0;
  itlog(iter,"dev") = 0;
);

option iterlog:0;
display iterlog;

execute_unload 'data\gebalanced.gdx', yr, r, s, mrg, ys0, ld0, kd0,
	id0, rx0, x0, ms0, ns0, nd0, fd0, cd0, a0, 
	m0, ty0, tm0, ta0, md0;
