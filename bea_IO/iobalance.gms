$title	Balance the Projected IO Matrices

set	stotal /
	T007    Total Commodity Output
	T013    Total product supply (basic prices)
	T014    Total trade and transportation margins
	T015    Total tax less subsidies on products
	T016    Total product supply (purchaser prices)
	T017	Total output /;

set gov(*) / F06C, F07C, F10C  /;

set inv(*) / F02E, F02N, F02R, F02S, F030, F06E, F06N,  F06S, F07E, F07N, F07S, F10E, F10N, F10S/

set fd(*) /
	F010	"Personal consumption expenditures",
	F02E	"Nonresidential private fixed investment in equipment",
	F02N	"Nonresidential private fixed investment in intellectual property products",
	F02R	"Residential private fixed investment",
	F02S	"Nonresidential private fixed investment in structures",
	F030	"Change in private inventories",
	F040	"Exports of goods and services",
	F06C	"Federal Government defense: Consumption expenditures",
	F06E	"Federal national defense: Gross investment in equipment",
	F06N	"Federal national defense: Gross investment in intellectual property products",
	F06S	"Federal national defense: Gross investment in structures",
	F07C	"Federal Government nondefense: Consumption expenditures",
	F07E	"Federal nondefense: Gross investment in equipment",
	F07N	"Federal nondefense: Gross investment in intellectual property products",
	F07S	"Federal nondefense: Gross investment in structures",
	F10C	"State and local government consumption expenditures",
	F10E	"State and local: Gross investment in equipment",
	F10N	"State and local: Gross investment in intellectual property products",
	F10S	"State and local: Gross investment in structures" /;

set	utotal	Use totals /
	T005    Total Intermediate
	VABAS	Value Added (basic prices)
	T018    Total industry output (basic prices)
	VAPRO	Value Added (producer prices) 
	T001    Total Intermediate
	T019    Total use of products/

alias (i,j,d), (ru,ru_d), (cu,cu_d), (rs,rs_d), (cs,cs_d);

set vabas(*) /v001,v003,t00otop, t00osub/, kl(*)/v001,v003/;

parameter	profit_s	Cross check on identities in the original data;
profit_s(cu_s(s),yrs,"interm")  = sum(ru_s(g), use_s(yrs,ru_s,cu_s));
profit_s(cu_s(s),yrs,vabas(ru_s)) = use_s(yrs,ru_s,cu_s);
profit_s(cs_s(s),yrs,"revenue") = sum(rs_s(g),supply_s(yrs,rs_s,cs_s));
profit_s(s,yrs,"balance") = profit_s(s,yrs,"interm") 
        + sum(vabas,profit_s(s,yrs,vabas)) - profit_s(s,yrs,"revenue");
option profit_s:3:2:1;
display profit_s;

parameter	market_s	Market balance;
*market_s(rs_s(g),yrs,"produc")  = sum(cs_s(s), supply_s(yrs,rs_s,cs_s));
market_s(g(rs_s),yrs,"produc")  = supply_s(yrs,rs_s,"t007");
*.market_s(g(rs_s),yrs,"import")  = supply_s(yrs,rs_s,"t013")-supply_s(yrs,rs_s,"t007");
market_s(g(rs_s),yrs,"import") = supply_s(yrs,rs_s,"MCIF") + supply_s(yrs,rs_s,"MADJ");
*.market_s(g(rs_s),yrs,"margins") = supply_s(yrs,rs_s,"T014");
market_s(g(rs_s),yrs,"margins") = supply_s(yrs,rs_s,"trade") + supply_s(yrs,rs_s,"trans");
*.market_s(g(rs_s),yrs,"taxes")   = supply_s(yrs,rs_s,"T015");
market_s(g(rs_s),yrs,"taxes")   = supply_s(yrs,rs_s,"MDTY") + supply_s(yrs,rs_s,"TOP") + supply_s(yrs,rs_s,"SUB");
*.market_s(g(ru_s),yrs,"interm")  = use_s(yrs,ru_s,"T001");
market_s(g(ru_s),yrs,"interm")  = sum(cu_s(s),use_s(yrs,ru_s,cu_s));
market_s(g(ru_s),yrs,"export")  = use_s(yrs,ru_s,"F040");
market_s(g(ru_s),yrs,"consum")  = use_s(yrs,ru_s,"F010");
market_s(g(ru_s),yrs,"invest")   = sum(inv(cu_s),use_s(yrs,ru_s,cu_s));
market_s(g(ru_s),yrs,"govt")   = sum(gov(cu_s),use_s(yrs,ru_s,cu_s));
market_s(g,yrs,"balance") = market_s(g,yrs,"produc") + 
				market_s(g,yrs,"import") +
				market_s(g,yrs,"margins") +
				market_s(g,yrs,"taxes") -
				market_s(g,yrs,"interm") - 
				market_s(g,yrs,"export") -
				market_s(g,yrs,"consum") -
				market_s(g,yrs,"invest") -
				market_s(g,yrs,"govt");

option market_s:3:2:1;
display market_s;

parameter	profit_d	Cross check on identities in the original data;
profit_d(cu_d(d),yrd,"interm")  = sum(ru_d(gg), use_d(yrd,ru_d,cu_d));
profit_d(cu_d(d),yrd,vabas(ru_d)) = use_d(yrd,ru_d,cu_d);
profit_d(cs_d(d),yrd,"revenue") = sum(rs_d(gg),supply_d(yrd,rs_d,cs_d));
profit_d(d,yrd,"balance") = profit_d(d,yrd,"interm") 
        + sum(vabas,profit_d(d,yrd,vabas)) - profit_d(d,yrd,"revenue");
option profit_d:3:2:1;
display profit_d;

parameter	market_d	Market balance;
*market_d(rs_d(g),yrd,"produc")  = sum(cs_d(d), supply_d(yrd,rs_d,cs_d));
market_d(g(rs_d),yrd,"produc")  = supply_d(yrd,rs_d,"t007");
*.market_d(g(rs_d),yrd,"import")  = supply_d(yrd,rs_d,"t013")-supply_d(yrd,rs_d,"t007");
market_d(g(rs_d),yrd,"import") = supply_d(yrd,rs_d,"MCIF") + supply_d(yrd,rs_d,"MADJ");
*.market_d(g(rs_d),yrd,"margins") = supply_d(yrd,rs_d,"T014");
market_d(g(rs_d),yrd,"margins") = supply_d(yrd,rs_d,"trade") + supply_d(yrd,rs_d,"trans");
*.market_d(g(rs_d),yrd,"taxes")   = supply_d(yrd,rs_d,"T015");
market_d(g(rs_d),yrd,"taxes")   = supply_d(yrd,rs_d,"MDTY") + supply_d(yrd,rs_d,"TOP") + supply_d(yrd,rs_d,"SUB");
*.market_d(g(ru_d),yrd,"interm")  = use_d(yrd,ru_d,"T001");
market_d(g(ru_d),yrd,"interm")  = sum(cu_d(d),use_d(yrd,ru_d,cu_d));
market_d(g(ru_d),yrd,"export")  = use_d(yrd,ru_d,"F040");
market_d(g(ru_d),yrd,"final")   = sum(fd(cu_d),use_d(yrd,ru_d,cu_d)) - use_d(yrd,ru_d,"F040");
market_d(g,yrd,"balance") = market_d(g,yrd,"produc") + 
				market_d(g,yrd,"import") +
				market_d(g,yrd,"margins") +
				market_d(g,yrd,"taxes") -
				market_d(g,yrd,"interm") - 
				market_d(g,yrd,"export") -
				market_d(g,yrd,"final");
option market_d:3:2:1;
display market_d;


parameter	utotchk(yrs,i,*,utotal)	Cross check on projected USE table totals;

utotchk(yrs,i(ru),"diff","T001") = use(yrs,ru,"T001") - sum(cu(j),use(yrs,ru,cu));
utotchk(yrs,i(ru),"diff","T019") = use(yrs,ru,"T019") - (use(yrs,ru,"T001") + sum(cu(fd),use(yrs,ru,cu)));
utotchk(yrs,j(cu),"diff","T005") = use(yrs,"T005",cu) - sum(ru(i),use(yrs,ru,cu));
utotchk(yrs,j(cu),"diff","T018") = use(yrs,"T018",cu) - use(yrs,"T005",cu) - use(yrs,"VABAS",cu);
utotchk(yrs,j(cu),"diff","VABAS") = use(yrs,"VABAS",cu) - (use(yrs,"T00OTOP",cu) + use(yrs,"V001",cu) + use(yrs,"V003",cu));
utotchk(yrs,j(cu),"diff","VAPRO") = use(yrs,"VAPRO",cu) - (use(yrs,"VABAS",cu) + use(yrs,"T00TOP",cu) - use(yrs,"T00SUB",cu));
utotchk(yrs,i(ru),"%","T001")$use(yrs,ru,"T001") = 100 * (sum(cu(j),use(yrs,ru,cu))/use(yrs,ru,"T001") - 1);
utotchk(yrs,i(ru),"%","T019")$use(yrs,ru,"T019") = 100 * ( (use(yrs,ru,"T001") + sum(cu(fd),use(yrs,ru,cu)))/use(yrs,ru,"T019") - 1);
utotchk(yrs,j(cu),"%","T005")$use(yrs,"T005",cu) = 100 * (use(yrs,"T005",cu) / sum(ru(i),use(yrs,ru,cu))-1);
utotchk(yrs,j(cu),"%","T018")$use(yrs,"T018",cu) = 100 * (use(yrs,"T018",cu)  / (use(yrs,"T005",cu) + use(yrs,"VABAS",cu)) - 1);
utotchk(yrs,j(cu),"%","VABAS")$use(yrs,"VABAS",cu) = 100 * (use(yrs,"VABAS",cu) / (use(yrs,"T00OTOP",cu) + use(yrs,"V001",cu) + use(yrs,"V003",cu))-1);
utotchk(yrs,j(cu),"%","VAPRO")$use(yrs,"VAPRO",cu) = 100 * (use(yrs,"VAPRO",cu) / (use(yrs,"VABAS",cu) + use(yrs,"T00TOP",cu) - use(yrs,"T00SUB",cu))-1);

option utotchk:3:2:2;
display utotchk; 

parameter	stotchk(yrs,i,*,stotal)	Cross check on SUPPLY table totals;

stotchk(yrs,i(rs),"diff","T007") = supply(yrs,rs,"T007") - sum(cs(j),supply(yrs,rs,cs));
stotchk(yrs,i(rs),"diff","T013") = supply(yrs,rs,"T013") - (supply(yrs,rs,"T007") + supply(yrs,rs,"MCIF") + supply(yrs,rs,"MADJ"));
stotchk(yrs,i(rs),"diff","T014") = supply(yrs,rs,"T014") - (supply(yrs,rs,"trade")+supply(yrs,rs,"trans"));
stotchk(yrs,i(rs),"diff","T015") = supply(yrs,rs,"T015") - (supply(yrs,rs,"MDTY")+ supply(yrs,rs,"TOP")  + supply(yrs,rs,"SUB"));
stotchk(yrs,i(rs),"diff","T016") = supply(yrs,rs,"T016") - (supply(yrs,rs,"T013") + supply(yrs,rs,"T014") + supply(yrs,rs,"T015"));
stotchk(yrs,j(cs),"diff","T017") = supply(yrs,"T017",cs) - sum(rs(i),supply(yrs,rs,cs));

stotchk(yrs,i(rs),"%","T007")$supply(yrs,rs,"T007") = 100 * ( supply(yrs,rs,"T007") / sum(cs(j),supply(yrs,rs,cs)) - 1);
stotchk(yrs,i(rs),"%","T013")$supply(yrs,rs,"T013") = 100 * ( supply(yrs,rs,"T013") / (supply(yrs,rs,"T007") + supply(yrs,rs,"MCIF") + supply(yrs,rs,"MADJ")) - 1);
stotchk(yrs,i(rs),"%","T014")$supply(yrs,rs,"T014") = 100 * ( supply(yrs,rs,"T014") / (supply(yrs,rs,"trade")+supply(yrs,rs,"trans")) - 1);
stotchk(yrs,i(rs),"%","T015")$supply(yrs,rs,"T015") = 100 * ( supply(yrs,rs,"T015") / (supply(yrs,rs,"MDTY")+ supply(yrs,rs,"TOP")  + supply(yrs,rs,"SUB")) - 1);
stotchk(yrs,i(rs),"%","T016")$supply(yrs,rs,"T016") = 100 * ( supply(yrs,rs,"T016") / (supply(yrs,rs,"T013") + supply(yrs,rs,"T014") + supply(yrs,rs,"T015")) - 1);
stotchk(yrs,j(cs),"%","T017")$supply(yrs,"T017",cs) = 100 * ( supply(yrs,"T017",cs) / sum(rs(i),supply(yrs,rs,cs)) - 1);

option stotchk:3:2:2;
display stotchk; 

parameter	dev	Unweighted average deviation;
dev(yrs,"use",utotal) = sum(j,utotchk(yrs,j,"%",utotal))/card(j);
dev(yrs,"supply",stotal) = sum(j,stotchk(yrs,j,"%",stotal))/card(j);
*.execute_unload 'dev.gdx', dev;
*.execute 'gdxxrw i=dev.gdx o=dev.xlsx par=dev rng="PivotData!a2" cdim=0';


parameter	profit	Cross check on identities in the original data;
profit(cu_d(d),yrs,"interm")  = sum(ru_d(gg), use(yrs,ru_d,cu_d));
profit(cu_d(d),yrs,vabas(ru_d)) = use(yrs,ru_d,cu_d);
profit(cs_d(d),yrs,"revenue") = sum(rs_d(gg),supply(yrs,rs_d,cs_d));
profit(d,yrs,"balance") = profit(d,yrs,"interm") 
        + sum(vabas,profit(d,yrs,vabas)) - profit(d,yrs,"revenue");
option profit:3:2:1;
display profit;

parameter	market	Market balance;
market(gg(rs_d),yrs,"produc")  = sum(cs_d(d),supply(yrs,rs_d,cs_d));
market(gg(rs_d),yrs,"import") = supply(yrs,rs_d,"MCIF") + supply(yrs,rs_d,"MADJ");
market(gg(rs_d),yrs,"margins") = supply(yrs,rs_d,"trade") + supply(yrs,rs_d,"trans");
market(gg(rs_d),yrs,"taxes")   = supply(yrs,rs_d,"MDTY") + supply(yrs,rs_d,"TOP") + supply(yrs,rs_d,"SUB");
market(gg(ru_d),yrs,"interm")  = sum(cu_d(d),use(yrs,ru_d,cu_d));
market(gg(ru_d),yrs,"export")  = use(yrs,ru_d,"F040");
market(gg(ru_d),yrs,"final")   = sum(fd(cu_d),use(yrs,ru_d,cu_d)) - use(yrs,ru_d,"F040");
market(gg,yrs,"balance") = market(gg,yrs,"produc") + 
				market(gg,yrs,"import") +
				market(gg,yrs,"margins") +
				market(gg,yrs,"taxes") -
				market(gg,yrs,"interm") - 
				market(gg,yrs,"export") -
				market(gg,yrs,"final");
option market:3:2:1;
display market;

set		snz(rs_d,cs_d), unz(ru_d,cu_d), yb(yrs);
variables	OBJ, USE_(ru_d,cu_d), SUPPLY_(rs_d,cs_d);
equations	objdef, profitbal, marketbal,netsupply;

objdef..	OBJ =e= sum((yb,snz(rs_d,cs_d)), 
				abs(supply(yb,snz)) * sqr(SUPPLY_(snz)/supply(yb,snz) - 1)) +

			sum((yb,unz(ru_d,cu_d)), 
				abs(use(yb,unz))    * sqr(USE_(unz)/use(yb,unz)       - 1));

profitbal(d)..
	sum(unz(ru_d(gg),cu_d(d)),   USE_(ru_d,cu_d)) + 

	sum(unz(ru_d(vabas),cu_d(d)),USE_(ru_d,cu_d)) =e= 

		sum(snz(rs_d(gg),cs_d(d)), SUPPLY_(rs_d,cs_d));

set	mrg(cs_d)/trade,trans/, imp(cs_d) /mcif,madj/, txs(cs_d)/mdty,top,sub/;

marketbal(gg)..

*	Production:
	sum(snz(rs_d(gg),cs_d(d)), SUPPLY_(rs_d,cs_d)) + 

*	Imports:
	sum(snz(rs_d(gg),imp),     SUPPLY_(rs_d,imp)) +

*	Taxes on imports and domestic:
	sum((rs_d(gg),txs), SUPPLY_(rs_d,txs)) =e=

*	Supply to margins:
	sum(snz(rs_d(gg),mrg), SUPPLY_(snz)) + 

*	Intermediate demand:
	sum(unz(ru_d(gg),cu_d( d)), USE_(ru_d,cu_d)) + 

*	Final demand plus exports:
	sum(unz(ru_d(gg),cu_d(fd)), USE_(ru_d,cu_d));
	
*	Production must be sufficient to cover margins and exports:

netsupply(gg)..

*	Domestic supply:
	sum(snz(rs_d(gg),cs_d(d)), SUPPLY_(snz)) +

*	Margins:
	sum(snz(rs_d(gg),cs_d(mrg))$(SUPPLY_.UP(snz)=0), SUPPLY_(snz))  =g= 

*	Exports:
	sum(unz(ru_d(gg),"F040"), USE_(ru_d,"F040"));

model lsqcalib /objdef, profitbal, marketbal, netsupply/;

set snz_yrs(yrs,rs_d,cs_d), unz_yrs(yrs,ru_d,cu_d)

option snz_yrs<supply, unz_yrs<use;

alias (yr,yrs);

set	cs_nz(cs_d) /MCIF,MADJ,TRADE,TRANS,MDTY,TOP,SUB/


set	run(yr) /set.yr/;

file kput; kput.lw=0; put kput;
option limrow=0, limcol=0;
loop(run(yr),
	yb(yrs) = yes$sameas(yrs,yr);

	snz(rs_d,cs_d) = snz_yrs(yr,rs_d,cs_d);
	SUPPLY_.FX(rs_d,cs_d) = 0;
	SUPPLY_.UP(snz) = +inf;  SUPPLY_.LO(snz) = -inf; SUPPLY_.L(snz) = supply(yr,snz);

	unz(ru_d,cu_d) = unz_yrs(yr,ru_d,cu_d);
	USE_.FX(ru_d,cu_d) = 0;
	USE_.UP(unz) = +INF; USE_.LO(unz) = -INF; USE_.L(unz) = use(yr,unz);

*	Impose non-negative conditions:

	SUPPLY_.LO(rs_d(gg),cs_d(d)) = 0;
	SUPPLY_.LO(rs_d(gg),mrg)$(supply(yr,rs_d,mrg)>0) = 0;
	SUPPLY_.UP(rs_d(gg),mrg)$(supply(yr,rs_d,mrg)<0) = 0;
	USE_.LO(ru_d(gg),cu_d(d)) = 0;
	USE_.LO("v001",cu_d(d)) = 0;
	USE_.LO("v003",cu_d(d)) = 0;
	USE_.LO(ru_d(gg),"F010") = 0;
	USE_.LO(ru_d(gg),"F040") = 0;
	SUPPLY_.LO(snz(rs_d(gg),"MCIF")) = 0;

	put_utility 'title' /'Solving for ',yr.tl;

	option qcp=cplex;
	solve lsqcalib using qcp minimizing obj;

	abort$(lsqcalib.solvestat<>1 or lsqcalib.modelstat<>1) "Error -- least squares calibration problem.";

	supply(yr,rs_d,cs_d) = SUPPLY_.L(rs_d,cs_d);
	use(yr,ru_d,cu_d)    = USE_.L(ru_d,cu_d);
);

parameter	profitcal	Cross check on identities in the calibrated data;

loop(run(yrs),
	profitcal(cu_d(d),yrs,"interm")  = sum(ru_d(gg), use(yrs,ru_d,cu_d));
	profitcal(cu_d(d),yrs,vabas(ru_d)) = use(yrs,ru_d,cu_d);
	profitcal(cs_d(d),yrs,"revenue") = sum(rs_d(gg),supply(yrs,rs_d,cs_d));
	profitcal(d,yrs,"balance") = profitcal(d,yrs,"interm") 
		+ sum(vabas,profitcal(d,yrs,vabas)) - profitcal(d,yrs,"revenue");
);
option profitcal:3:2:1;
display profitcal;

parameter	marketcal	Market balance;
loop(run(yrs),
	marketcal(gg(rs_d),yrs,"produc")  = sum(cs_d(d),supply(yrs,rs_d,cs_d));
	marketcal(gg(rs_d),yrs,"import")  = sum(imp,supply(yrs,rs_d,imp));
	marketcal(gg(rs_d),yrs,"margins") = sum(mrg,supply(yrs,rs_d,mrg));
	marketcal(gg(rs_d),yrs,"taxes")   = sum(txs,supply(yrs,rs_d,txs));
	marketcal(gg(ru_d),yrs,"interm")  = sum(cu_d(d),use(yrs,ru_d,cu_d));
	marketcal(gg(ru_d),yrs,"export")  = use(yrs,ru_d,"F040");
	marketcal(gg(ru_d),yrs,"consum")   = use(yrs,ru_d,"F010");
	marketcal(gg(ru_d),yrs,"G+I") = sum(fd(cu_d),use(yrs,ru_d,cu_d)) - use(yrs,ru_d,"F040") - use(yrs,ru_d,"F010");
	marketcal(gg,yrs,"balance") = 
		marketcal(gg,yrs,"produc") + marketcal(gg,yrs,"import") + marketcal(gg,yrs,"taxes") 
		- marketcal(gg,yrs,"margins") - marketcal(gg,yrs,"interm") 
		- marketcal(gg,yrs,"export")  - marketcal(gg,yrs,"consum") - marketcal(gg,yrs,"G+I");
);
option marketcal:3:2:1;
display marketcal;

display "Egregious violations of benchmark equilibrium:";

profitcal(d,yrs,u)$(not round(profitcal(d,yrs,"balance"),3)) = 0;
display profitcal;

marketcal(d,yrs,u)$(not round(marketcal(d,yrs,"balance"),3)) = 0;
display marketcal;

execute_unload 'data\iobalanced.gdx', use, supply;


