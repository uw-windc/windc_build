
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
$call gdxxrw i="data\Supply_Tables_1997-2022_Summary.xlsx" o=data.gdx NAin='...'  @%gams.scrdir%data.rsp

$gdxin data.gdx

$loaddc supply1997 supply1998 supply1999 supply2000 supply2001
$loaddc supply2002 supply2003 supply2004 supply2005 supply2006 supply2007
$loaddc supply2008 supply2009 supply2010 supply2011 supply2012 supply2013
$loaddc supply2014 supply2015 supply2016 supply2017 supply2018 supply2019
$loaddc supply2020 supply2021 supply2022

set	yr/1997*2022/;

set	supply(yr,rs,cs)	The BEA Domestic Supply of Commodities by Industries - (Millions of dollars) ;

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
	GSLE    "State and local government enterprises" /;

alias (i,j);

set	total /
	T007    Total Commodity Output
	T013    Total product supply (basic prices)
	T014    Total trade and transportation margins
	T015    Total tax less subsidies on products
	T016    Total product supply (purchaser prices)
	T017	Total output /;

parameter	totchk(yr,i,total)	Cross check on totals;

totchk(yr,i(rs),"T007") = supply(yr,rs,"T007") - sum(cs(j),supply(yr,rs,cs));
totchk(yr,i(rs),"T013") = supply(yr,rs,"T013") - (supply(yr,rs,"T007") + supply(yr,rs,"MCIF") + supply(yr,rs,"MADJ"));
totchk(yr,i(rs),"T014") = supply(yr,rs,"T014") - (supply(yr,rs,"trade")+supply(yr,rs,"trans"));
totchk(yr,i(rs),"T015") = supply(yr,rs,"T015") - (supply(yr,rs,"MDTY")+ supply(yr,rs,"TOP")  - supply(yr,rs,"SUB"));
totchk(yr,i(rs),"T016") = supply(yr,rs,"T016") - supply(yr,rs,"T013") + supply(yr,rs,"T014") + supply(yr,rs,"T015");
totchk(yr,j(cs),"T017") = supply(yr,"T017",cs) - sum(rs(i),supply(yr,rs,cs));

option totchk:3:2:1;
display totchk; 

$set wb Use_Tables_Supply-Use_Framework_1997-2022_Summary

$onecho >%gams.scrdir%sets.rsp
set=ru values=dense rng=2022!a8..b81 rdim=1 cdim=0
set=cu values=dense rng=2022!c6..cg6 rdim=0 cdim=1
$offecho

$call gdxxrw i="data\%wb%.xlsx" o=usets.gdx @%gams.scrdir%sets.rsp
$gdxin usets.gdx

set	ru(*)	IO Supply Table rows
	cu(*)	IO Supply Table columns;

$load ru cu

option ru:0:0:1,cu:0:0:1;
display ru, cu;
