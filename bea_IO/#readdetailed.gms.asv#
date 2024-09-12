$title	Read the Detailed Supply-Use Table

set yr /2007,2012,2017/;

set	j(*)	Detailed labels (numeric)
	d(*)	Detailed labels (WiNDC alpha)
	jd(j,d)	Mapping from j to d;

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc j d jd

alias (d,s,g), (i,j), (jd,is,ig,js);

set	rs(*)	Supply rows /
	(set.i) ,
	T017	"Total industry supply" /

	cs(*)	Supply columns /
	(set.i)
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
	T016	"Total product supply (purchaser prices)" /;

$onecho >%gams.scrdir%gdxxrw.rsp
par=supply2007 rng=2007!a6..oz409 ignorecolumns=b rdim=1 cdim=1
par=supply2012 rng=2012!a6..oz409 ignorecolumns=b rdim=1 cdim=1
par=supply2017 rng=2017!a6..oz409 ignorecolumns=b rdim=1 cdim=1
$offecho
$set wb data\Supply_2017_DET
$if not exist %wb%.gdx $call gdxxrw i=%wb%.xlsx o=%wb%.gdx @%gams.scrdir%gdxxrw.rsp

parameter	supply2007(rs,cs), supply2012(rs,cs), supply2017(rs,cs),
		supply(yr,rs,cs)  The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

$gdxin '%wb%.gdx'
$load supply2007 supply2012 supply2017
supply("2007",rs,cs) = supply2007(rs,cs);
supply("2012",rs,cs) = supply2012(rs,cs);
supply("2017",rs,cs) = supply2017(rs,cs);

set ru(*)	Use table rows /
	(set.i),
	T005	"Total intermediate inputs",
	V001	"Compensation of employees",
	T00OTOP	"Other taxes on production",
	T00OSUB	"Less: other subsidies on production",
	V003	"Gross operating surplus",
	VABAS	"Value added (basic value)",
	T018	"Total industry output (basic value)",
	T00TOP	"Plus: Taxes on products and imports",
	T00SUB	"Less: Subsidies",
	VAPRO	"Value added (producer value)" /;
	      
set cu(*) 	Use table columns /
	(set.i),
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
	T019	"Total use of products" /;

$onecho >%gams.scrdir%gdxxrw.rsp
par=use2007 rng=2007!a6..pi417 ignorecolumns=b rdim=1 cdim=1
par=use2012 rng=2012!a6..pi417 ignorecolumns=b rdim=1 cdim=1
par=use2017 rng=2017!a6..pi417 ignorecolumns=b rdim=1 cdim=1
$offecho

$set wb data\Use_SUT_Framework_2017_DET
$if not exist %wb%.gdx $call gdxxrw i=%wb%.xlsx o=%wb%.gdx @%gams.scrdir%gdxxrw.rsp

set ru_d(*)	Use table rows -- labels are different ? /
	(set.i),
	T005	"Total intermediate inputs",
	V00100	"Compensation of employees",
	T00OTOP	"Other taxes on production",
	T00OSUB	"Less: other subsidies on production",
	V00300	"Gross operating surplus",
	VABAS	"Value added (basic value)",
	T018	"Total industry output (basic value)",
	T00TOP	"Plus: Taxes on products and imports",
	T00SUB	"Less: Subsidies",
	VAPRO	"Value added (producer value)" /;
	      
set cu_d(*) 	Use table columns -- labels are different ?/
	(set.i),
	T001	"Total Intermediate",
	F01000 	"Personal consumption expenditures",
	F02E00 	"Nonresidential private fixed investment in equipment",
	F02N00 	"Nonresidential private fixed investment in intellectual property products",
	F02R00 	"Residential private fixed investment",
	F02S00 	"Nonresidential private fixed investment in structures",
	F03000 	"Change in private inventories",
	F04000 	"Exports of goods and services",
	F06C00 	"Federal Government defense: Consumption expenditures",
	F06E00 	"Federal national defense: Gross investment in equipment",
	F06N00 	"Federal national defense: Gross investment in intellectual property products",
	F06S00 	"Federal national defense: Gross investment in structures",
	F07C00 	"Federal Government nondefense: Consumption expenditures",
	F07E00 	"Federal nondefense: Gross investment in equipment",
	F07N00 	"Federal nondefense: Gross investment in intellectual property products",
	F07S00 	"Federal nondefense: Gross investment in structures",
	F10C00 	"State and local government consumption expenditures",
	F10E00 	"State and local: Gross investment in equipment",
	F10N00 	"State and local: Gross investment in intellectual property products",
	F10S00 	"State and local: Gross investment in structures",
	T019	"Total use of products" /;

parameter	use2007(ru_d,cu_d), use2012(ru_d,cu_d), use2017(ru_d,cu_d),
		use(yr,ru,cu)  The BEA Domestic Use of Commodities by Industries - (Millions of dollars) ;

$gdxin '%wb%.gdx'
$load use2007 use2012 use2017

set swap(*,*)	Mapping from detailed data labels to summary data labels /
	V00100.V001
	V00300.V003
	F01000.F010
	F02E00.F02E
	F02N00.F02N
	F02R00.F02R
	F02S00.F02S
	F03000.F030
	F04000.F040
	F06C00.F06C
	F06E00.F06E
	F06N00.F06N
	F06S00.F06S
	F07C00.F07C
	F07E00.F07E
	F07N00.F07N
	F07S00.F07S
	F10C00.F10C
	F10E00.F10E
	F10N00.F10N
	F10S00.F10S /;

set	mapr(*,*);
	mapr(ru,ru) = yes;
	mapr(cu,cu) = yes;
	mapr(swap) = yes;

alias (mapr,mapc);

use("2007",ru,cu) = sum((mapr(ru_d,ru),mapc(cu_d,cu)), use2007(ru_d,cu_d));
use("2012",ru,cu) = sum((mapr(ru_d,ru),mapc(cu_d,cu)), use2012(ru_d,cu_d));
use("2017",ru,cu) = sum((mapr(ru_d,ru),mapc(cu_d,cu)), use2017(ru_d,cu_d));

set	stotal /
	T007    Total Commodity Output
	T013    Total product supply (basic prices)
	T014    Total trade and transportation margins
	T015    Total tax less subsidies on products
	T016    Total product supply (purchaser prices)
	T017	Total output /;

parameter	stotchk(yr,i,*,stotal)	Cross check on SUPPLY table totals;

stotchk(yr,i(rs),"diff","T007") = supply(yr,rs,"T007") - sum(cs(j),supply(yr,rs,cs));
stotchk(yr,i(rs),"diff","T013") = supply(yr,rs,"T013") - (supply(yr,rs,"T007") + supply(yr,rs,"MCIF") + supply(yr,rs,"MADJ"));
stotchk(yr,i(rs),"diff","T014") = supply(yr,rs,"T014") - (supply(yr,rs,"trade")+supply(yr,rs,"trans"));
stotchk(yr,i(rs),"diff","T015") = supply(yr,rs,"T015") - (supply(yr,rs,"MDTY")+ supply(yr,rs,"TOP")  + supply(yr,rs,"SUB"));
stotchk(yr,i(rs),"diff","T016") = supply(yr,rs,"T016") - (supply(yr,rs,"T013") + supply(yr,rs,"T014") + supply(yr,rs,"T015"));
stotchk(yr,j(cs),"diff","T017") = supply(yr,"T017",cs) - sum(rs(i),supply(yr,rs,cs));

stotchk(yr,i(rs),"%","T007")$supply(yr,rs,"T007") = 100 * ( supply(yr,rs,"T007") / sum(cs(j),supply(yr,rs,cs)) - 1);
stotchk(yr,i(rs),"%","T013")$supply(yr,rs,"T013") = 100 * ( supply(yr,rs,"T013") / (supply(yr,rs,"T007") + supply(yr,rs,"MCIF") + supply(yr,rs,"MADJ")) - 1);
stotchk(yr,i(rs),"%","T014")$supply(yr,rs,"T014") = 100 * ( supply(yr,rs,"T014") / (supply(yr,rs,"trade")+supply(yr,rs,"trans")) - 1);
stotchk(yr,i(rs),"%","T015")$supply(yr,rs,"T015") = 100 * ( supply(yr,rs,"T015") / (supply(yr,rs,"MDTY")+ supply(yr,rs,"TOP")  + supply(yr,rs,"SUB")) - 1);
stotchk(yr,i(rs),"%","T016")$supply(yr,rs,"T016") = 100 * ( supply(yr,rs,"T016") / (supply(yr,rs,"T013") + supply(yr,rs,"T014") + supply(yr,rs,"T015")) - 1);
stotchk(yr,j(cs),"%","T017")$supply(yr,"T017",cs) = 100 * ( supply(yr,"T017",cs) / sum(rs(i),supply(yr,rs,cs)) - 1);

option stotchk:3:2:2;
display stotchk; 

set	utotal	Use totals /
	T005    Total Intermediate
	VABAS	Value Added (basic prices)
	T018    Total industry output (basic prices)
	VAPRO	Value Added (producer prices) 
	T001    Total Intermediate
	T019    Total use of products/

set fd(cu) /
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

*	Convert sign of subsidies so value-added equals a simple sum:

use(yr,"T00SUB",cu) = -use(yr,"T00SUB",cu);
use(yr,"T00OSUB",cu) = -use(yr,"T00OSUB",cu);

parameter imports;
imports(yr,i(rs),"mcif") = supply(yr,rs,"mcif");
imports(yr,i(rs),"madj") = supply(yr,rs,"madj");
option imports:3:1:1;
display imports;


parameter	utotchk(yr,i,*,utotal)	Cross check on USE table totals;

utotchk(yr,i(ru),"diff","T001") = use(yr,ru,"T001") - sum(cu(j),use(yr,ru,cu));
utotchk(yr,i(ru),"diff","T019") = use(yr,ru,"T019") - (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)));
utotchk(yr,j(cu),"diff","T005") = use(yr,"T005",cu) - sum(ru(i),use(yr,ru,cu));
utotchk(yr,j(cu),"diff","T018") = use(yr,"T018",cu) - use(yr,"T005",cu) - use(yr,"VABAS",cu);
utotchk(yr,j(cu),"diff","VABAS") = use(yr,"VABAS",cu) - (use(yr,"T00OTOP",cu)  + use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu));
utotchk(yr,j(cu),"diff","VAPRO") = use(yr,"VAPRO",cu) - (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) + use(yr,"T00SUB",cu));

utotchk(yr,i(ru),"%","T001")$use(yr,ru,"T001") = 100 * (sum(cu(j),use(yr,ru,cu))/use(yr,ru,"T001") - 1);
utotchk(yr,i(ru),"%","T019")$use(yr,ru,"T019") = 100 * ( (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)))/use(yr,ru,"T019") - 1);
utotchk(yr,j(cu),"%","T005")$use(yr,"T005",cu) = 100 * (use(yr,"T005",cu) / sum(ru(i),use(yr,ru,cu))-1);
utotchk(yr,j(cu),"%","T018")$use(yr,"T018",cu) = 100 * (use(yr,"T018",cu)  / (use(yr,"T005",cu) + use(yr,"VABAS",cu)) - 1);
utotchk(yr,j(cu),"%","VABAS")$use(yr,"VABAS",cu) = 100 * (use(yr,"VABAS",cu) / (use(yr,"T00OTOP",cu) + use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu))-1);
utotchk(yr,j(cu),"%","VAPRO")$use(yr,"VAPRO",cu) = 100 * (use(yr,"VAPRO",cu) / (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) + use(yr,"T00SUB",cu))-1);

option utotchk:3:2:2;
display utotchk; 

*	Relabel commodity and sector names, converting from the BEA codes
*	to the WiNDC 3/7 character acronyms:

parameter	use_(yr,*,*)	The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
		supply_(yr,*,*)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

use_(yr,g,cu)$(not i(cu)) = sum(ig(i(ru),g),			use(yr,ru,cu));
use_(yr,ru,s)$(not i(ru)) = sum(is(i(cu),s),			use(yr,ru,cu));
use_(yr,g,s)		  = sum((ig(i(ru),g),js(j(cu),s)),	use(yr,ru,cu));

supply_(yr,g,cs)$(not i(cs)) = sum(ig(i(rs),g),			supply(yr,rs,cs));
supply_(yr,rs,s)$(not i(rs)) = sum(is(i(cs),s),			supply(yr,rs,cs));
supply_(yr,g,s)              = sum((ig(i(rs),g),js(j(cs),s)),	supply(yr,rs,cs));

imports(yr,i,"mcif") = 0;
imports(yr,i,"madj") = 0;
imports(yr,g,"mcif") = supply_(yr,g,"mcif");
imports(yr,g,"madj") = supply_(yr,g,"madj");
display imports;

execute_unload 'data\bea_detailed.gdx', use_=use, supply_=supply;
