$title	Set Up Two Trade Datasets (tradedata.gdx and aggtradedata.gdx)

*	This trade data based on GTAP flows.  An HS6 dataset might be 
*	better, perhaps using TASTE.

set	i	Commodities in the trade dataset /
	fof	"Forestry and fishing",
	fbp	"Food and beverage and tobacco products (311FT)"
	alt	"Apparel and leather and allied products (315AL)"
	pmt	"Primary metals (331)"
	ogs	"Crude oil and natural gas"
	uti	"Utilities (electricity-gas-water)"
	oxt	"Coal, minining and supporting activities"
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
	RMK	"Raw milk",
	WOL 	"Wool, silk-worm cocoons",
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

set	s	States in the Lower 48 /
	AL    Alabama
	AR    Arizona
	AZ    Arkansas
	CA    California
	CO    Colorado
	CT    Connecticut
	DE    Delaware
	DC    District of Columbia
	FL    Florida
	GA    Georgia
	ID    Idaho
	IL    Illinois
	IN    Indiana
	IA    Iowa
	KS    Kansas
	KY    Kentucky
	LA    Louisiana
	ME    Maine
	MD    Maryland
	MA    Massachusetts
	MI    Michigan
	MN    Minnesota
	MS    Mississippi
	MO    Missouri
	MT    Montana
	NE    Nebraska
	NV    Nevada
	NH    New Hampshire
	NJ    New Jersey
	NM    New Mexico
	NY    New York
	NC    North Carolina
	ND    North Dakota
	OH    Ohio
	OK    Oklahoma
	OR    Oregon
	PA    Pennsylvania
	RI    Rhode Island
	SC    South Carolina
	SD    South Dakota
	TN    Tennessee
	TX    Texas
	UT    Utah
	VT    Vermont
	VA    Virginia
	WA    Washington
	WV    West Virginia
	WI    Wisconsin
	WY    Wyoming /;

set	pd	Port districts /
	MD_Balt  Baltimore - MD
	MA_Bost  Boston - MA
	NY_Buff  Buffalo - NY
	SC_Char  Charleston - SC
	IL_Chic  Chicago - IL
	OH_Clev  Cleveland - OH
	OR_Colu  Columbia-Snake - OR
	TX_Dall  Dallas-Fort Worth - TX
	MI_Detr  Detroit - MI
	MN_Dulu  Duluth - MN
	TX_ElPa  El Paso - TX
	MT_Grea  Great Falls - MT
	TX_Hous  Houston-Galveston - TX
	TX_Lare  Laredo - TX
	CA_LosA  Los Angeles - CA
	FL_Miam  Miami - FL
	WI_Milw  Milwaukee - WI
	MN_Minn  Minneapolis - MN
	AL_Mobi  Mobile - AL
	LA_NewO  New Orleans - LA
	NY_NewY  New York City - NY
	AZ_Noga  Nogales - AZ
	VA_Norf  Norfolk - VA
	NY_Ogde  Ogdensburg - NY
	ND_Pemb  Pembina - ND
	PA_Phil  Philadelphia - PA
	TX_PrtA  Port Arthur - TX
	ME_Port  Portland - ME
	RI_Prov  Providence - RI
	CA_SanD  San Diego - CA
	CA_SanF  San Francisco - CA
	GA_Sava  Savannah - GA
	WA_Seat  Seattle - WA
	VT_StAl  St. Albans - VT
	MO_StLo  St. Louis - MO
	FL_Tamp  Tampa - FL
	DC_Wash  Washington - DC
	NC_Wilm  Wilmington - NC
	NJ_Newk  Newark - NJ
	NC_Char  Charlotte - NC
	NY_Jama  Jamaica - NY /;

set	r	Trade parnters (countries and regions) /
	CHN  China (including Hong Kong)
	JPN  Japan
	KOR  Korea
	IDN  Indonesia
	IND  India
	CAN  Canada
	MEX  Mexico
	ARG  Argentina
	BRA  Brazil
	FRA  France
	DEU  Germany
	ITA  Italy
	GBR  United Kingdom
	RUS  Russia
	SAU  Saudi Arabia
	TUR  Turkey
	ZAF  South Africa
	ANZ  Australia and New Zealand
	REU  Rest of European Union (excluding FRA - DEU - GBR - ITA)
	OEX  Other oil exporters
	LIC  Other low-income countries
	MIC  Other middle-income countries/;

set	rr	Aggregate regions (to create smaller model) /
		CHN  China and Hong Kong
		CAN  Canada
		MEX  Mexico
		EUR  Europe
		OEC  Other OECD
		ROW  Rest of world /;
		
set	rmap(rr,r) /
	CHN.CHN  China and Hong Kong
	CAN.CAN  Canada
	MEX.MEX  Mexico
	EUR.(FRA, DEU, ITA, GBR, REU)
	OEC.(JPN,KOR,ANZ,TUR),
	ROW.(IDN, IND, ARG, BRA, RUS, SAU, ZAF, OEX, LIC, MIC) /;

set	flow /	export, import /;

parameter	trade(i,r,pd,flow)	Trade data;
$gdxin '..\tradedata\tradedata.gdx'
$loaddc trade


parameter	md_0(i,r,pd)	Bilateral imports
		xs_0(i,pd,r)	Bilater exports;

md_0(i,r,pd) = trade(i,r,pd,"import");
xs_0(i,pd,r) = trade(i,r,pd,"export");


set		loc		Locations (states and port districts) /set.s, set.pd/;
parameter	dist(s,loc)	Distances from states to locations;
$gdxin 'datasets\geography.gdx'
$load dist
$gdxin

*	Replace zeros by one mile:

dist(s,loc) = max(1,dist(s,loc));

execute_unload 'tradedata.gdx', i, r, pd, loc, md_0, xs_0, dist;


parameter	md_0_(i,rr,pd)	Bilateral imports
		xs_0_(i,pd,rr)	Bilater exports;

md_0_(i,rr,pd)	= sum(rmap(rr,r),md_0(i,r,pd));
xs_0_(i,pd,rr)	= sum(rmap(rr,r),xs_0(i,pd,r));

execute_unload 'aggtradedata.gdx', i, rr=r, pd, loc, md_0_=md_0, xs_0_=xs_0, dist;

parameter	echoprint	Echo-print of dataset;
echoprint("Commodity",i,"Import") = sum((r,pd),md_0(i,r,pd));
echoprint("Commodity",i,"Export") = sum((r,pd),xs_0(i,pd,r));
echoprint("Country",r,"Import") = sum((i,pd),md_0(i,r,pd));
echoprint("Country",r,"Export") = sum((i,pd),xs_0(i,pd,r));
echoprint("Port",pd,"Import") = sum((i,r),md_0(i,r,pd));
echoprint("Port",pd,"Export") = sum((i,r),xs_0(i,pd,r));
echoprint("AggCountry",rr,"Import") = sum((i,pd),md_0_(i,rr,pd));
echoprint("AggCountry",rr,"Export") = sum((i,pd),xs_0_(i,pd,rr));
option echoprint:3:1:1;
display echoprint;

parameter	porttrade		Echo-print of port trade flows;
porttrade("Imports",pd,rr) = sum(i,md_0_(i,rr,pd));
porttrade("Exports",pd,rr) = sum(i,xs_0_(i,pd,rr));
option porttrade:3:2:1;
display porttrade;

