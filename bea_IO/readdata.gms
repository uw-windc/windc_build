$title	Read the Summary Supply and Use Tables

set	i /
	111CA   "Farms",
	113FF   "Forestry, fishing, and related activities",
	211     "Oil and gas extraction",
	212     "Mining, except oil and gas",
	213     "Support activities for mining",
	22      "Utilities",
	23      "Construction",
	321     "Wood products",
	327     "Nonmetallic mineral products",
	331     "Primary metals",
	332     "Fabricated metal products",
	333     "Machinery",
	334     "Computer and electronic products",
	335     "Electrical equipment, appliances, and components",
	3361MV  "Motor vehicles, bodies and trailers, and parts",
	3364OT  "Other transportation equipment",
	337     "Furniture and related products",
	339     "Miscellaneous manufacturing",
	311FT   "Food and beverage and tobacco products",
	313TT   "Textile mills and textile product mills",
	315AL   "Apparel and leather and allied products",
	322     "Paper products",
	323     "Printing and related support activities",
	324     "Petroleum and coal products",
	325     "Chemical products",
	326     "Plastics and rubber products",
	42      "Wholesale trade",
	441     "Motor vehicle and parts dealers",
	445     "Food and beverage stores",
	452     "General merchandise stores",
	4A0     "Other retail",
	481     "Air transportation",
	482     "Rail transportation",
	483     "Water transportation",
	484     "Truck transportation",
	485     "Transit and ground passenger transportation",
	486     "Pipeline transportation",
	487OS   "Other transportation and support activities",
	493     "Warehousing and storage",
	511     "Publishing industries, except internet (includes software)",
	512     "Motion picture and sound recording industries",
	513     "Broadcasting and telecommunications",
	514     "Data processing, internet publishing, and other information services",
	521CI   "Federal Reserve banks, credit intermediation, and related activities",
	523     "Securities, commodity contracts, and investments",
	524     "Insurance carriers and related activities",
	525     "Funds, trusts, and other financial vehicles",
	HS      "Housing",
	ORE     "Other real estate",
	532RL   "Rental and leasing services and lessors of intangible assets",
	5411    "Legal services",
	5415    "Computer systems design and related services",
	5412OP  "Miscellaneous professional, scientific, and technical services",
	55      "Management of companies and enterprises",
	561     "Administrative and support services",
	562     "Waste management and remediation services",
	61      "Educational services",
	621     "Ambulatory health care services",
	622     "Hospitals",
	623     "Nursing and residential care facilities",
	624     "Social assistance",
	711AS   "Performing arts, spectator sports, museums, and related activities",
	713     "Amusements, gambling, and recreation industries",
	721     "Accommodation",
	722     "Food services and drinking places",
	81      "Other services, except government",
	GFGD    "Federal general government (defense)",
	GFGN    "Federal general government (nondefense)",
	GFE     "Federal government enterprises",
	GSLG    "State and local general government",
	GSLE    "State and local government enterprises",
	Used	"Scrap, used and secondhand goods",
	Other	"Noncomparable imports and rest-of-the-world adjustment"/;

alias (i,j);

$set wb Supply_Tables_1997-2022_Summary

$onecho >%gams.scrdir%sets.rsp
set=rs values=dense rng=2022!a8..b81 rdim=1 cdim=0
set=cs values=dense rng=2022!c6..cg6 rdim=0 cdim=1
$offecho

$call gdxxrw i="data\%wb%.xlsx" o=ssets.gdx @%gams.scrdir%sets.rsp
$gdxin ssets.gdx

set	rs(*)	IO Supply Table rows
	cs(*)	IO Supply Table columns;

$load rs cs

option rs:0:0:1,cs:0:0:1;
display rs, cs;


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
$call gdxxrw i="data\Supply_Tables_1997-2022_Summary.xlsx" o=sdata.gdx NAin='...'  @%gams.scrdir%data.rsp

$gdxin sdata.gdx

$loaddc supply1997 supply1998 supply1999 supply2000 supply2001
$loaddc supply2002 supply2003 supply2004 supply2005 supply2006 supply2007
$loaddc supply2008 supply2009 supply2010 supply2011 supply2012 supply2013
$loaddc supply2014 supply2015 supply2016 supply2017 supply2018 supply2019
$loaddc supply2020 supply2021 supply2022

set	yr/1997*2022/;

parameter	supply(yr,rs,cs)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

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

$set wb Use_Tables_Supply-Use_Framework_1997-2022_Summary

$onecho >%gams.scrdir%sets.rsp
set=ru values=dense rng=2022!a8..b90 rdim=1 cdim=0
set=cu values=dense rng=2022!c6..cp6 rdim=0 cdim=1
$offecho

$call gdxxrw i="data\%wb%.xlsx" o=usets.gdx @%gams.scrdir%sets.rsp
$gdxin usets.gdx

set	ru(*)	IO Supply Table rows
	cu(*)	IO Supply Table columns;

$load ru cu

option ru:0:0:1,cu:0:0:1;
display ru, cu;

parameter	use1997(ru,cu), use1998(ru,cu),
		use1999(ru,cu), use2000(ru,cu), use2001(ru,cu),
		use2002(ru,cu), use2003(ru,cu), use2004(ru,cu),
		use2005(ru,cu), use2006(ru,cu), use2007(ru,cu),
		use2008(ru,cu), use2009(ru,cu), use2010(ru,cu),
		use2011(ru,cu), use2012(ru,cu), use2013(ru,cu),
		use2014(ru,cu), use2015(ru,cu), use2016(ru,cu),
		use2017(ru,cu), use2018(ru,cu), use2019(ru,cu),
		use2020(ru,cu), use2021(ru,cu), use2022(ru,cu);

$set wb data\Use_Tables_Supply-Use_Framework_1997-2022_Summary
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
$call gdxxrw i="%wb%.xlsx" o=udata.gdx NAin='...'  @%gams.scrdir%data.rsp

$gdxin udata.gdx

$loaddc use1997 use1998 use1999 use2000 use2001
$loaddc use2002 use2003 use2004 use2005 use2006 use2007
$loaddc use2008 use2009 use2010 use2011 use2012 use2013
$loaddc use2014 use2015 use2016 use2017 use2018 use2019
$loaddc use2020 use2021 use2022

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

set	fd(cu) /
	F010    "Personal consumption expenditures",
	F02E    "Nonresidential private fixed investment in equipment",
	F02N    "Nonresidential private fixed investment in intellectual property products",
	F02R    "Residential private fixed investment",
	F02S    "Nonresidential private fixed investment in structures",
	F030    "Change in private inventories",
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
	F10S    "State and local: Gross investment in structures" /

F040    Exports of goods and services


set	utotal	Use totals /
	T001    Total Intermediate
	T005    Total Intermediate
	T018    Total industry output (basic prices)
	T019    Total use of products
	VABAS	Value Added (basic prices)
	VAPRO	Value Added (producer prices) /;

parameter	utotchk(yr,i,*,utotal)	Cross check on totals;
utotchk(yr,i(ru),"diff","T001") = use(yr,ru,"T001") - sum(cu(j),use(yr,ru,cu));
utotchk(yr,i(ru),"diff","T019") = use(yr,ru,"T019") - (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)) + use(yr,ru,"F040"));

utotchk(yr,j(cu),"diff","T005") = use(yr,"T005",cu) - sum(ru(i),use(yr,ru,cu));
utotchk(yr,j(cu),"diff","T018") = use(yr,"T018",cu) - use(yr,"T005",cu) - use(yr,"VABAS",cu);
utotchk(yr,j(cu),"diff","VABAS") = use(yr,"VABAS",cu) - (use(yr,"T00OTOP",cu) - use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu));
utotchk(yr,j(cu),"diff","VAPRO") = use(yr,"VAPRO",cu) - (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) - use(yr,"T00SUB",cu));

utotchk(yr,i(ru),"%","T001")$use(yr,ru,"T001") = 100 * (sum(cu(j),use(yr,ru,cu))/use(yr,ru,"T001") - 1);
utotchk(yr,i(ru),"%","T019")$use(yr,ru,"T019") = 100 * ( (use(yr,ru,"T001") + sum(cu(fd),use(yr,ru,cu)) + use(yr,ru,"F040"))/use(yr,ru,"T019") - 1);
utotchk(yr,j(cu),"%","T005")$use(yr,"T005",cu) = 100 * (use(yr,"T005",cu) / sum(ru(i),use(yr,ru,cu))-1);
utotchk(yr,j(cu),"%","T018")$use(yr,"T018",cu) = 100 * (use(yr,"T018",cu)  / (use(yr,"T005",cu) + use(yr,"VABAS",cu)) - 1);
utotchk(yr,j(cu),"%","VABAS")$use(yr,"VABAS",cu) = 100 * (use(yr,"VABAS",cu) / (use(yr,"T00OTOP",cu) - use(yr,"T00OSUB",cu) + use(yr,"V001",cu) + use(yr,"V003",cu))-1);
utotchk(yr,j(cu),"%","VAPRO")$use(yr,"VAPRO",cu) = 100 * (use(yr,"VAPRO",cu) / (use(yr,"VABAS",cu) + use(yr,"T00TOP",cu) - use(yr,"T00SUB",cu))-1);

option utotchk:3:2:2;
display utotchk; 

*	Relabel the data and save:


set	s(*)	Sectors in output data;

alias (s,g);

set  imap(i,s<) /
	322.ppd  	"Paper products manufacturing (322)",
	722.res  	"Food services and drinking places (722)",
	5415.com  	"Computer systems design and related services (5415)",
	621.amb  	"Ambulatory health care services (621)",
	311FT.fbp  	"Food and beverage and tobacco products manufacturing (311FT)",
	713.rec  	"Amusements, gambling, and recreation industries (713)",
	23.con  	"Construction (23)",
	111CA.agr  	"Farms (111CA)",
	335.eec  	"Electrical equipment, appliance, and components manufacturing (335)",
	GFGN.fnd  	"Federal general government (nondefense) (GFGN)",
	511.pub  	"Publishing industries, except Internet (includes software) (511)",
	HS.hou  	"Housing (HS)",
	445.fbt  	"Food and beverage stores (445)",
	524.ins  	"Insurance carriers and related activities (524)",
	313TT.tex  	"Textile mills and textile product mills (313TT)",
	5411.leg  	"Legal services (5411)",
	GFE.fen  	"Federal government enterprises (GFE)",
	22.uti  	"Utilities (22)",
	327.nmp  	"Nonmetallic mineral products manufacturing (327)",
	513.brd  	"Broadcasting and telecommunications (513)",
	521ci.bnk  	"Federal Reserve banks, credit intermediation, and related services (521ci)",
	ORE.ore  	"Other real estate (ORE)",
	61.edu  	"Educational services (61)",
	487OS.ote  	"Other transportation equipment manufacturing (487OS)",
	55.man  	"Management of companies and enterprises (55)",
	333.mch  	"Machinery manufacturing (333)",
	514.dat  	"Data processing, internet publishing, and other information services (514)",
	721.amd  	"Accommodation (721)",
	211.oil  	"Oil and gas extraction (211)",
	622.hos  	"Hospitals (622)",
	532RL.rnt  	"Rental and leasing services and lessors of intangible assets (532RL)",
	326.pla  	"Plastics and rubber products manufacturing (326)",
	113FF.fof  	"Forestry, fishing, and related activities (113FF)",
	525.fin  	"Funds, trusts, and other financial vehicles (525)",
	5412OP.tsv  	"Miscellaneous professional, scientific, and technical services (5412OP)",
	623.nrs  	"Nursing and residential care facilities (623)",
	523.sec  	"Securities, commodity contracts, and investments (523)",
	711AS.art  	"Performing arts, spectator sports, museums, and related activities (711AS)",
	512.mov  	"Motion picture and sound recording industries (512)",
	337.fpd  	"Furniture and related products manufacturing (337)",
	GSLG.slg  	"State and local general government (GSLG)",
	323.pri  	"Printing and related support activities (323)",
	485.grd  	"Transit and ground passenger transportation (485)",
	486.pip  	"Pipeline transportation (486)",
	GSLE.sle  	"State and local government enterprises (GSLE)",
	81.osv  	"Other services, except government (81)",
	482.trn  	"Rail transportation (482)",
	213.smn  	"Support activities for mining (213)",
	332.fmt  	"Fabricated metal products (332)",
	324.pet  	"Petroleum and coal products manufacturing (324)",
	441.mvt  	"Motor vehicle and parts dealers (441)",
	334.cep  	"Computer and electronic products manufacturing (334)",
	562.wst  	"Waste management and remediation services (562)",
	3361MV.mot  	"Motor vehicles, bodies and trailers, and parts manufacturing (3361MV)",
	561.adm  	"Administrative and support services (561)",
	624.soc  	"Social assistance (624)",
	315AL.alt  	"Apparel and leather and allied products manufacturing (315AL)",
	331.pmt  	"Primary metals manufacturing (331)",
	484.trk  	"Truck transportation (484)",
	GFGD.fdd  	"Federal general government (defense) (GFGD)",
	452.gmt  	"General merchandise stores (452)",
	483.wtt  	"Water transportation (483)",
	321.wpd  	"Wood products manufacturing (321)",
	42.wht  	"Wholesale trade (42)",
	493.wrh  	"Warehousing and storage (493)",
	4A0.ott  	"Other retail (4A0)",
	325.che  	"Chemical products manufacturing (325)",
	481.air  	"Air transportation (481)",
	339.mmf  	"Miscellaneous manufacturing (339)",
	487OS.otr  	"Other transportation and support activities (487OS)",
	212.min  	"Mining, except oil and gas (212)",
	Used.usd	"Scrap, used and secondhand goods",
	Other.oth	"Noncomparable imports and rest-of-the-world adjustment"/; 

alias (imap,jmap);

parameter	use_(yr,*,*)		The BEA Domestic Use of Commodities by Industries - (Millions of dollars),
		supply_(yr,*,*)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

use_(yr,g,cu)$(not i(cu)) = sum(imap(i(ru),g),use(yr,ru,cu));
use_(yr,ru,s)$(not i(ru)) = sum(imap(i(cu),s),use(yr,ru,cu));
use_(yr,g,s) = sum((imap(i(ru),g),jmap(j(cu),s)),use(yr,ru,cu));

supply_(yr,g,cs)$(not i(cs)) = sum(imap(i(rs),g),supply(yr,rs,cs));
supply_(yr,rs,s)$(not i(rs)) = sum(imap(i(cs),s),supply(yr,rs,cs));
supply_(yr,g,s) = sum((imap(i(rs),g),jmap(j(cs),s)),supply(yr,rs,cs));

option use:3:0:1, use_:3:0:1;
display use, use_;

set	ru_(*), cu_(*), rs_(*), cs_(*);
ru_(ru) = yes$(not i(ru));  ru_(g) = yes;
cu_(cu) = yes$(not i(cu));  cu_(g) = yes;
rs_(rs) = yes$(not i(rs));  rs_(g) = yes;
cs_(cs) = yes$(not i(cs));  cs_(g) = yes;

execute_unload 'bea_summary.gdx',yr,ru_=ru,cu_=cu,rs_=rs,cs_=cs,s, use_=use, supply_=supply;
