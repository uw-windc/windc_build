$title	Read the Summary Supply and Use Tables

set	yr/1997*2022/;

set	i(*)	Summary labels (BEA numeric)
	s(*)	Summary labels (WiNDC alpha)
	is(i,s)	Mapping from i to s;

$call gams mappings gdx=%gams.scrdir%mappings.gdx
$gdxin %gams.scrdir%mappings.gdx
$loaddc i s is

alias (i,j), (s,g), (is,js,ig);

$onecho >%gams.scrdir%sets.rsp
set=rs values=dense rng=2022!a8..b81 rdim=1 cdim=0
set=cs values=dense rng=2022!c6..cg6 rdim=0 cdim=1
$offecho

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

parameter	supply1997(rs,cs), supply1998(rs,cs),
		supply1999(rs,cs), supply2000(rs,cs), supply2001(rs,cs),
		supply2002(rs,cs), supply2003(rs,cs), supply2004(rs,cs),
		supply2005(rs,cs), supply2006(rs,cs), supply2007(rs,cs),
		supply2008(rs,cs), supply2009(rs,cs), supply2010(rs,cs),
		supply2011(rs,cs), supply2012(rs,cs), supply2013(rs,cs),
		supply2014(rs,cs), supply2015(rs,cs), supply2016(rs,cs),
		supply2017(rs,cs), supply2018(rs,cs), supply2019(rs,cs),
		supply2020(rs,cs), supply2021(rs,cs), supply2022(rs,cs);

$onecho >%gams.scrdir%data.rsp
par=supply1997 rng=1997!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply1998 rng=1998!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply1999 rng=1999!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2000 rng=2000!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2001 rng=2001!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2002 rng=2002!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2003 rng=2003!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2004 rng=2004!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2005 rng=2005!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2006 rng=2006!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2007 rng=2007!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2008 rng=2008!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2009 rng=2009!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2010 rng=2010!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2011 rng=2011!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2012 rng=2012!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2013 rng=2013!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2014 rng=2014!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2015 rng=2015!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2016 rng=2016!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2017 rng=2017!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2018 rng=2018!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2019 rng=2019!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2020 rng=2020!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2021 rng=2021!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=supply2022 rng=2022!a6..cg81 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
$offecho

$set wb data\Supply_Tables_1997-2022_Summary
$if not exist %wb%.gdx $call gdxxrw i="%wb%.xlsx" o=%wb%.gdx NAin='...'  @%gams.scrdir%data.rsp
$gdxin %wb%.gdx

$loaddc supply1997 supply1998 supply1999 supply2000 supply2001
$loaddc supply2002 supply2003 supply2004 supply2005 supply2006 supply2007
$loaddc supply2008 supply2009 supply2010 supply2011 supply2012 supply2013
$loaddc supply2014 supply2015 supply2016 supply2017 supply2018 supply2019
$loaddc supply2020 supply2021 supply2022


parameter	supply(yr,rs,cs) The BEA Domestic Supply of Commodities by Industries - (Millions of dollars);

supply("1997",rs,cs) = supply1997(rs,cs);
supply("1998",rs,cs) = supply1998(rs,cs);
supply("1999",rs,cs) = supply1999(rs,cs);
supply("2000",rs,cs) = supply2000(rs,cs);
supply("2001",rs,cs) = supply2001(rs,cs);
supply("2002",rs,cs) = supply2002(rs,cs);
supply("2003",rs,cs) = supply2003(rs,cs);
supply("2004",rs,cs) = supply2004(rs,cs);
supply("2005",rs,cs) = supply2005(rs,cs);
supply("2006",rs,cs) = supply2006(rs,cs);
supply("2007",rs,cs) = supply2007(rs,cs);
supply("2008",rs,cs) = supply2008(rs,cs);
supply("2009",rs,cs) = supply2009(rs,cs);
supply("2010",rs,cs) = supply2010(rs,cs);
supply("2011",rs,cs) = supply2011(rs,cs);
supply("2012",rs,cs) = supply2012(rs,cs);
supply("2013",rs,cs) = supply2013(rs,cs);
supply("2014",rs,cs) = supply2014(rs,cs);
supply("2015",rs,cs) = supply2015(rs,cs);
supply("2016",rs,cs) = supply2016(rs,cs);
supply("2017",rs,cs) = supply2017(rs,cs);
supply("2018",rs,cs) = supply2018(rs,cs);
supply("2019",rs,cs) = supply2019(rs,cs);
supply("2020",rs,cs) = supply2020(rs,cs);
supply("2021",rs,cs) = supply2021(rs,cs);
supply("2022",rs,cs) = supply2022(rs,cs);

supply(yr,rs,cs)$(supply(yr,rs,cs)=na) = 0;

parameter imports;
imports(yr,i(rs),"mcif") = supply(yr,rs,"mcif");
imports(yr,i(rs),"madj") = supply(yr,rs,"madj");
option imports:3:1:1;
display imports;

set	stotal /
	T007    Total Commodity Output
	T013    Total product supply (basic prices)
	T014    Total trade and transportation margins
	T015    Total tax less subsidies on products
	T016    Total product supply (purchaser prices)
	T017	Total output /;

parameter	stotchk(yr,i,*,stotal)	Cross check on totals;

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

parameter	use1997(ru,cu), use1998(ru,cu),
		use1999(ru,cu), use2000(ru,cu), use2001(ru,cu),
		use2002(ru,cu), use2003(ru,cu), use2004(ru,cu),
		use2005(ru,cu), use2006(ru,cu), use2007(ru,cu),
		use2008(ru,cu), use2009(ru,cu), use2010(ru,cu),
		use2011(ru,cu), use2012(ru,cu), use2013(ru,cu),
		use2014(ru,cu), use2015(ru,cu), use2016(ru,cu),
		use2017(ru,cu), use2018(ru,cu), use2019(ru,cu),
		use2020(ru,cu), use2021(ru,cu), use2022(ru,cu);

$onecho >%gams.scrdir%data.rsp
par=use1997 rng=1997!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use1998 rng=1998!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use1999 rng=1999!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2000 rng=2000!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2001 rng=2001!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2002 rng=2002!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2003 rng=2003!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2004 rng=2004!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2005 rng=2005!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2006 rng=2006!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2007 rng=2007!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2008 rng=2008!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2009 rng=2009!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2010 rng=2010!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2011 rng=2011!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2012 rng=2012!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2013 rng=2013!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2014 rng=2014!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2015 rng=2015!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2016 rng=2016!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2017 rng=2017!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2018 rng=2018!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2019 rng=2019!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2020 rng=2020!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2021 rng=2021!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
par=use2022 rng=2022!a6..cp90 ignorecolumns=b ignorerows=7 rdim=1 cdim=1
$offecho

$set wb data\Use_Tables_Supply-Use_Framework_1997-2022_Summary
$if not exist %wb%.gdx $call gdxxrw i="%wb%.xlsx" o=%wb%.gdx NAin='...'  @%gams.scrdir%data.rsp
$gdxin %wb%.gdx

$loaddc use1997 use1998 use1999 use2000 use2001 use2002 use2003 use2004 
$loaddc use2005 use2006 use2007 use2008 use2009 use2010 use2011 use2012 
$loaddc use2013 use2014 use2015 use2016 use2017 use2018 use2019 use2020 
$loaddc use2021 use2022

parameter	use(yr,ru,cu)	The BEA Domestic Use of Commodities by Industries - (Millions of dollaru) ;
use("1997",ru,cu) = use1997(ru,cu);
use("1998",ru,cu) = use1998(ru,cu);
use("1999",ru,cu) = use1999(ru,cu);
use("2000",ru,cu) = use2000(ru,cu);
use("2001",ru,cu) = use2001(ru,cu);
use("2002",ru,cu) = use2002(ru,cu);
use("2003",ru,cu) = use2003(ru,cu);
use("2004",ru,cu) = use2004(ru,cu);
use("2005",ru,cu) = use2005(ru,cu);
use("2006",ru,cu) = use2006(ru,cu);
use("2007",ru,cu) = use2007(ru,cu);
use("2008",ru,cu) = use2008(ru,cu);
use("2009",ru,cu) = use2009(ru,cu);
use("2010",ru,cu) = use2010(ru,cu);
use("2011",ru,cu) = use2011(ru,cu);
use("2012",ru,cu) = use2012(ru,cu);
use("2013",ru,cu) = use2013(ru,cu);
use("2014",ru,cu) = use2014(ru,cu);
use("2015",ru,cu) = use2015(ru,cu);
use("2016",ru,cu) = use2016(ru,cu);
use("2017",ru,cu) = use2017(ru,cu);
use("2018",ru,cu) = use2018(ru,cu);
use("2019",ru,cu) = use2019(ru,cu);
use("2020",ru,cu) = use2020(ru,cu);
use("2021",ru,cu) = use2021(ru,cu);
use("2022",ru,cu) = use2022(ru,cu);

use(yr,ru,cu)$(use(yr,ru,cu)=na) = 0;

set	yrd(yr) Years with detailed tables /2007,2012,2017/;

*	Convert sign of subsidies so value-added equals a simple sum:

use(yr,"T00SUB",cu) = - use(yr,"T00SUB",cu);
use(yr,"T00OSUB",cu) = - use(yr,"T00OSUB",cu);

set	fd(cu) /
	F010    "Personal consumption expenditures",
	F02E    "Nonresidential private fixed investment in equipment",
	F02N    "Nonresidential private fixed investment in intellectual property products",
	F02R    "Residential private fixed investment",
	F02S    "Nonresidential private fixed investment in structures",
	F030    "Change in private inventories",
	F040    "Exports of goods and services",
	F06C    "National defense: Consumption expenditures",
	F06E    "Federal national defense: Gross investment in equipment",
	F06N    "Federal national defense: Gross investment in intellectual property products",
	F06S    "Federal national defense: Gross investment in structures",
	F07C    "Nondefense: Consumption expenditures",
	F07E    "Federal nondefense: Gross investment in equipment",
	F07N    "Federal nondefense: Gross investment in intellectual property products",
	F07S    "Federal nondefense: Gross investment in structures",
	F10C    "State and local government consumption expenditures",
	F10E    "State and local: Gross investment in equipment",
	F10N    "State and local: Gross investment in intellectual property products",
	F10S    "State and local: Gross investment in structures" /;


set	utotal	Use totals /
	T001    Total Intermediate
	T005    Total Intermediate
	T018    Total industry output (basic prices)
	T019    Total use of products
	VABAS	Value Added (basic prices)
	VAPRO	Value Added (producer prices) /;

parameter	utotchk(yr,i,*,utotal)	Cross check on totals;
utotchk(yr,i(ru),"diff","T001") = use(yr,ru,"T001") - sum(cu(j),use(yr,ru,cu));
utotchk(yr,i(ru),"diff","T019") = use(yr,ru,"T019") - (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)));
utotchk(yr,j(cu),"diff","T005") = use(yr,"T005",cu) - sum(ru(i),use(yr,ru,cu));
utotchk(yr,j(cu),"diff","T018") = use(yr,"T018",cu) - use(yr,"T005",cu) - use(yr,"VABAS",cu);
utotchk(yr,j(cu),"diff","VABAS") = use(yr,"VABAS",cu) - (use(yr,"T00OTOP",cu) + use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu));
utotchk(yr,j(cu),"diff","VAPRO") = use(yr,"VAPRO",cu) - (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) + use(yr,"T00SUB",cu));
utotchk(yr,i(ru),"%","T001")$use(yr,ru,"T001") = 100 * (sum(cu(j),use(yr,ru,cu))/use(yr,ru,"T001") - 1);
utotchk(yr,i(ru),"%","T019")$use(yr,ru,"T019") = 100 * ( (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)))/use(yr,ru,"T019") - 1);
utotchk(yr,j(cu),"%","T005")$use(yr,"T005",cu) = 100 * (use(yr,"T005",cu) / sum(ru(i),use(yr,ru,cu))-1);
utotchk(yr,j(cu),"%","T018")$use(yr,"T018",cu) = 100 * (use(yr,"T018",cu)  / (use(yr,"T005",cu) + use(yr,"VABAS",cu)) - 1);
utotchk(yr,j(cu),"%","VABAS")$use(yr,"VABAS",cu) = 100 * (use(yr,"VABAS",cu) / (use(yr,"T00OTOP",cu) + use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu))-1);
utotchk(yr,j(cu),"%","VAPRO")$use(yr,"VAPRO",cu) = 100 * (use(yr,"VAPRO",cu) / (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) + use(yr,"T00SUB",cu))-1);
option utotchk:3:2:2;
display utotchk; 

*	Relabel the data and save:

parameter	use_(yr,*,*)	The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
		supply_(yr,*,*)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

use_(yr,g,cu)$(not j(cu))	= sum(ig(i(ru),g),			use(yr,ru,cu));
use_(yr,ru,s)$(not i(ru))	= sum(js(j(cu),s),			use(yr,ru,cu));
use_(yr,g,s)			= sum((ig(i(ru),g),js(j(cu),s)),	use(yr,ru,cu));

supply_(yr,g,cs)$(not i(cs))	= sum(ig(i(rs),g),			supply(yr,rs,cs));
supply_(yr,rs,s)$(not i(rs))	= sum(js(j(cs),s),			supply(yr,rs,cs));
supply_(yr,g,s)			= sum((ig(i(rs),g),js(j(cs),s)),	supply(yr,rs,cs));

execute_unload 'data\bea_summary.gdx',	use_=use, supply_=supply;
