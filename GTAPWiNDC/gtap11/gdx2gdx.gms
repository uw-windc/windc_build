$title	Read the GTAP 11 Data (GDX format) and Write in GTAPinGAMS Format

$set fs %system.dirsep%
$call mkdir %gams.scrdir%%fs%gtapingams
$set tmpdir %gams.scrdir%%fs%gtapingams%fs%


*	Which year? (NB! GTAP uses two digit years in Zip file names)

$if not set yr $set yr 2004

$if "%yr%"=="2004" $set syr 04
$if "%yr%"=="2007" $set syr 07
$if "%yr%"=="2011" $set syr 11
$if "%yr%"=="2014" $set syr 14
$if "%yr%"=="2017" $set syr 17

$if not set syr $abort "Year is not valid: %yr%"

$if not dexist %yr% $call mkdir %yr%

$ontext
Archive:  GDX_AY1017.zip
  Length     Date   Time    Name
 --------    ----   ----    ----
 52930993  04-27-23 16:30   GDX04.zip
 54369371  04-27-23 16:30   GDX07.zip
 56027868  04-27-23 16:30   GDX11.zip
 56111941  04-27-23 16:30   GDX14.zip
 56161607  04-27-23 16:30   GDX17.zip
$offtext

*	Factor accounts are relabeled as the data are transferred.  All commodity
*	and region identifiers are read verbatim.

set	ff(*)	Factor labels in GTAP data /
	land		"Land"
	tech_aspros	"Technicians/AssocProfessional"
	clerks		"Clerks"
	service_shop	"Service/Shop workers"
	off_mgr_pros	"Officials and Managers"
	ag_othlowsk	"Agricultural and Unskilled"
	capital		"Capital"
	natlres		"Natural Resources" /;

set	f	Factor labels for GTAPinGAMS  /
	mgr	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tec	Technicians technicians and associate professionals
	clk	Clerks
	srv	Service and market sales workers
	lab	Agricultural and unskilled workers (Major Groups 6-9)
	cap     Capital,    
	lnd     Land,    
	res     Natural resources /;

set mapf(ff,f) /
	off_mgr_pros.mgr	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tech_aspros.tec		Technicians technicians and associate professionals
	clerks.clk		Clerks
	service_shop.srv	Service and market sales workers,
	ag_othlowsk.lab		Agricultural and unskilled workers (Major Groups 6-9)
	Land.lnd		Land,    
	Capital.cap		Capital,    
	NatlRes.res		Natural resources/;

set	g	Goods plus final demand /
		c	Household consumption, 
		i	Investment, 
		g	Public expenditure,
	pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk, wol, frs, fsh,
	col, cru, gas, oxt, cmt, omt, vol, mil, pcr, sgr, ofd, b_t, tex, wap,
	lea, lum, ppp, oil, chm, bph, rpp, nmm, i_s, nfm, fmp, ceo, eeq, ome,
	mvh, otn, omf, ele, gdt, wtr, cns, trd, afs, otp, wtp, atp, whs, cmn,
	ofi, ins, rsa, obs, ros, osg, edu, hht, dwe /;

set	i(g)	Commodites in the GTAPinGAMS /
	pdr 	"Paddy rice",
	wht 	"Wheat",
	gro 	"Cereal grains nec",
	v_f 	"Vegetables, fruit, nuts",
	osd 	"Oil seeds",
	c_b 	"Sugar cane, sugar beet",
	pfb 	"Plant-based fibers",
	ocr 	"Crops nec",
	ctl 	"Bovine cattle, sheep, goats and horses",
	oap 	"Animal products nec",
	rmk 	"Raw milk",
	wol 	"Wool, silk-worm cocoons",
	frs 	"Forestry",
	fsh 	"Fishing",
	col 	"Coal",
	cru 	"Crude oil",
	gas 	"Gas",
	oxt 	"Other Extraction (formerly omn - minerals nec)",
	cmt 	"Meat: cattle, sheep, goats, horse",
	omt 	"Meat products nec",
	vol 	"Vegetable oils and fats",
	mil 	"Dairy products",
	pcr 	"Processed rice",
	sgr 	"Sugar",
	ofd 	"Food products nec",
	b_t 	"Beverages and tobacco products",
	tex 	"Textiles",
	wap 	"Wearing apparel",
	lea 	"Leather products",
	lum 	"Wood products",
	ppp 	"Paper products, publishing",
	oil 	"Petroleum, coal products",
	chm 	"Chemical products",
	bph 	"Basic pharmaceutical products",
	rpp 	"Rubber and plastic products",
	nmm 	"Mineral products nec",
	i_s 	"Ferrous metals",
	nfm 	"Metals nec",
	fmp 	"Metal products",
	ceo 	"Computer, electronic and optical products",
	eeq 	"Electrical equipment",
	ome 	"Machinery and equipment nec",
	mvh 	"Motor vehicles and parts",
	otn 	"Transport equipment nec",
	omf 	"Manufactures nec",
	ele 	"Electricity",
	gdt 	"Gas manufacture, distribution",
	wtr 	"Water",
	cns 	"Construction",
	trd 	"Trade",
	afs 	"Accommodation, Food and service activities",
	otp 	"Transport nec",
	wtp 	"Water transport",
	atp 	"Air transport",
	whs 	"Warehousing and support activities",
	cmn 	"Communication",
	ofi 	"Financial services nec",
	ins 	"Insurance (formerly isr)",
	rsa 	"Real estate activities",
	obs 	"Business services nec",
	ros 	"Recreational and other services",
	osg 	"Public Administration and defense",
	edu 	"Education",
	hht 	"Human health and social work activities",
	dwe 	"Dwellings" /;

set	ii(*)	Commodities in the GTAP nomenclature;

*	The only names changes here are those which conform to the
*	GTAPinGAMS conventions for energy goods:

*	oil.cru	! "Crude Oil",
*	coa.col	! "Coal",
*	p_c.oil	! "Petroleum, coal products",
*	ely.ele	! "Electricity",
*	ele.ceo	! "Computer, electronic and optical products",

SET mapi(ii<,i) Mapping of Sectors and Goods (from-to) /
	pdr.pdr 	"Paddy rice",
	wht.wht 	"Wheat",
	gro.gro 	"Cereal grains nec",
	v_f.v_f 	"Vegetables, fruit, nuts",
	osd.osd 	"Oil seeds",
	c_b.c_b 	"Sugar cane, sugar beet",
	pfb.pfb 	"Plant-based fibers",
	ocr.ocr 	"Crops nec",
	ctl.ctl 	"Bovine cattle, sheep, goats and horses",
	oap.oap 	"Animal products nec",
	rmk.rmk 	"Raw milk",
	wol.wol 	"Wool, silk-worm cocoons",
	frs.frs 	"Forestry",
	fsh.fsh 	"Fishing",
	coa.col 	"Coal",
	oil.cru 	"Crude oil",
	gas.gas 	"Gas",
	oxt.oxt 	"Other Extraction (formerly omn - minerals nec)",
	cmt.cmt 	"Meat: cattle, sheep, goats, horse",
	omt.omt 	"Meat products nec",
	vol.vol 	"Vegetable oils and fats",
	mil.mil 	"Dairy products",
	pcr.pcr 	"Processed rice",
	sgr.sgr 	"Sugar",
	ofd.ofd 	"Food products nec",
	b_t.b_t 	"Beverages and tobacco products",
	tex.tex 	"Textiles",
	wap.wap 	"Wearing apparel",
	lea.lea 	"Leather products",
	lum.lum 	"Wood products",
	ppp.ppp 	"Paper products, publishing",
	p_c.oil 	"Petroleum, coal products",
	chm.chm 	"Chemical products",
	bph.bph 	"Basic pharmaceutical products",
	rpp.rpp 	"Rubber and plastic products",
	nmm.nmm 	"Mineral products nec",
	i_s.i_s 	"Ferrous metals",
	nfm.nfm 	"Metals nec",
	fmp.fmp 	"Metal products",
	ele.ceo 	"Computer, electronic and optical products",
	eeq.eeq 	"Electrical equipment",
	ome.ome 	"Machinery and equipment nec",
	mvh.mvh 	"Motor vehicles and parts",
	otn.otn 	"Transport equipment nec",
	omf.omf 	"Manufactures nec",
	ely.ele 	"Electricity",
	gdt.gdt 	"Gas manufacture, distribution",
	wtr.wtr 	"Water",
	cns.cns 	"Construction",
	trd.trd 	"Trade",
	afs.afs 	"Accommodation, Food and service activities",
	otp.otp 	"Transport nec",
	wtp.wtp 	"Water transport",
	atp.atp 	"Air transport",
	whs.whs 	"Warehousing and support activities",
	cmn.cmn 	"Communication",
	ofi.ofi 	"Financial services nec",
	ins.ins 	"Insurance (formerly isr)",
	rsa.rsa 	"Real estate activities",
	obs.obs 	"Business services nec",
	ros.ros 	"Recreational and other services",
	osg.osg 	"Public Administration and defense",
	edu.edu 	"Education",
	hht.hht 	"Human health and social work activities",
	dwe.dwe 	"Dwellings" 
/;

set	r	Regions /
        AUS	Australia
        NZL	New Zealand
        XOC	Rest of Oceania
        CHN	China
        HKG	Special Administrative Region of China -- Hong Kong, 
        JPN	Japan
        KOR	Republic of Korea, 
        MNG	Mongolia
        TWN	Taiwan
        XEA	Rest of East Asia
        BRN	Brunei Darussalam
        KHM	Cambodia
        IDN	Indonesia
        LAO	Lao PDR
        MYS	Malaysia
        PHL	Philippines
        SGP	Singapore
        THA	Thailand
        VNM	Viet Nam
        XSE	Rest of Southeast Asia
        AFG	Afghanistan
        BGD	Bangladesh
        IND	India
        NPL	Nepal
        PAK	Pakistan
        LKA	Sri Lanka
        XSA	Rest of South Asia
        CAN	Canada
        USA	United States of America
        MEX	Mexico
        XNA	Rest of North America
        ARG	Argentina
        BOL	Bolivia
        BRA	Brazil
        CHL	Chile
        COL	Colombia
        ECU	Ecuador
        PRY	Paraguay
        PER	Peru
        URY	Uruguay
        VEN	Venezuela (Bolivarian Republic of)
        XSM	Rest of South America
        CRI	Costa Rica
        GTM	Guatemala
        HND	Honduras
        NIC	Nicaragua
        PAN	Panama
        SLV	El Salvador
        XCA	Rest of Central America
        DOM	Dominican Republic
        HTI	Haiti
        JAM	Jamaica
        PRI	Puerto Rico
        TTO	Trinidad and Tobago
        XCB	Rest of Caribbean
        AUT	Austria
        BEL	Belgium
        BGR	Bulgaria
        HRV	Croatia
        CYP	Cyprus
        CZE	Czech Republic
        DNK	Denmark
        EST	Estonia
        FIN	Finland
        FRA	France
        DEU	Germany
        GRC	Greece
        HUN	Hungary
        IRL	Ireland
        ITA	Italy
        LVA	Latvia
        LTU	Lithuania
        LUX	Luxembourg
        MLT	Malta
        NLD	Netherlands
        POL	Poland
        PRT	Portugal
        ROU	Romania
        SVK	Slovakia
        SVN	Slovenia
        ESP	Spain
        SWE	Sweden
        GBR	United Kingdom
        CHE	Switzerland
        NOR	Norway
        XEF	Rest of European Free Trade Association
        ALB	Albania
        SRB	Serbia
        BLR	Belarus
        RUS	Russian Federation
        UKR	Ukraine
        XEE	Rest of Eastern Europe
        XER	Rest of Europe
        KAZ	Kazakhstan
        KGZ	Kyrgyzstan
        TJK	Tajikistan
        UZB	Uzbekistan
        XSU	Rest of Former Soviet Union
        ARM	Armenia
   	AZE	Azerbaijan
   	GEO	Georgia
   	BHR	Bahrain
   	IRN	Islamic Republic of Iran, 
   	IRQ	Iraq
   	ISR	Israel
   	JOR	Jordan
   	KWT	Kuwait
   	LBN	Lebanon
   	OMN	Oman
   	PSE	Occupied Palestineian Territory, 
   	QAT	Qatar
   	SAU	Saudi Arabia
   	SYR	Syrian Arab Republic
   	TUR	Turkey
   	ARE	United Arab Emirates
   	XWS	Rest of Western Asia
   	DZA	Algeria
   	EGY	Egypt
   	MAR	Morocco
   	TUN	Tunisia
   	XNF	Rest of North Africa
   	BEN	Benin
   	BFA	Burkina Faso
   	CMR	Cameroon
   	CIV	Côte d'Ivoire
   	GHA	Ghana
   	GIN	Guinea
   	MLI	Mali
   	NER	Niger
   	NGA	Nigeria
   	SEN	Senegal
   	TGO	Togo
   	XWF	Rest of Western Africa
   	CAF	Central African Republic
   	TCD	Chad
   	COG	Congo
   	COD	Democratic Republic of the Congo
   	GNQ	Equatorial Guinea
   	GAB	Gabon
   	XAC	Rest of South and Central Africa
   	COM	Comoros
   	ETH	Ethiopia
   	KEN	Kenya
   	MDG	Madagascar
   	MWI	Malawi
   	MUS	Mauritius
   	MOZ	Mozambique
   	RWA	Rwanda
   	SDN	Sudan
   	TZA	United Republic of Tanzania, 
   	UGA	Uganda
   	ZMB	Zambia
   	ZWE	Zimbabwe
   	XEC	Rest of Eastern Africa
   	BWA	Botswana
   	SWZ	Eswatini
   	NAM	Namibia
   	ZAF	South Africa
   	XSC	Rest of South African Customs Union
   	XTW	Rest of the World /;

set	pol	Pollutants /
		CO2         Carbon dioxide
		CH4         Methane
		N2O         Nitrous oxide
		C2F6        Hexafluoroethane (PFC-116)
		C3F8        Octafluoropropane (PFC-218)
		C4F10       Perfluorobutane (PFC-31-10)
		C5F12       Perfluoropentane (PFC-41-12)
		C6F14       Perfluorohexane (PFC-51-14)
		cC4F8       Octafluorocyclobutane (PFC-318)
		CF4         Carbon tetrafluoride (PFC-14)
		HCFC141b    "1,1-Dichloro-1-fluoroethane"
		HCFC142b    "1-Chloro-1,1-difluoroethane"
		HFC125      Pentafluoroethane
		HFC134      "1,1,2,2-Tetrafluoroethane",
		HFC134a     "1,1,1,2-Tetrafluoroethane",
		HFC143      "1,1,2-Trifluoroethane",
		HFC143a     "1,1,1-Trifluoroethane",
		HFC152a     "1,1-Difluoroethane",
		HFC227ea    "1,1,1,2,3,3,3-Heptafluoropropane",
		HFC23       Trifluoromethane
		HFC236fa    "1,1,1,3,3,3-Hexafluoropropane",
		HFC245fa    "1,1,1,3,3-Pentafluoropropane",
		HFC32       Difluoromethane
		HFC365mfc   "1,1,1,3,3-Pentafluorobutane",
		HFC41       Fluoromethane
		HFC4310mee  "1,1,1,2,2,3,4,5,5,5-Decafluoropentane",
		NF3         Nitrogen trifluoride
		SF6         Sulfur hexafluoride
		BC          Black carbon
		CO          Carbon monoxide
		NH3         Ammonia
		NMVOC       Non-methane volatile organic compounds
		NOX         Nitrogen oxides
		OC          Organic carbon
		PM10        Particulate matter 10
		PM2_5       Particulate matter 2.5
		SO2         Sulfur dioxide /;

set fgas(pol) F-gases /
	C2F6, C3F8, C4F10, C5F12, C6F14, cC4F8, CF4, HCFC141b, HCFC142b,
	HFC125, HFC134, HFC134a, HFC143, HFC143a, HFC152a, HFC227ea, HFC23,
	HFC236fa, HFC245fa, HFC32, HFC365mfc, HFC41, HFC4310mee, NF3, SF6/;

set nghg(pol)  Set of non-GHG emissions /
	BC	"Black carbon",
	CO	"Carbon monoxide",
	NH3	"Ammoni",
	NMVOC	"Non-methane volatile organic compounds", 
	NOX	"Nitrogen oxides",
	OC	"Organic carbon", 
	PM10	"Particulate matter 10", 
	PM2_5	"Particulate matter 2.5", 
	SO2	"Sulfur dioxide" /;

set	ghg(pol)	Set of greenhouse gases;
ghg(pol) = yes$(not nghg(pol));

set ar	IPCC Assessment Reports /
	AR2 'IPPC AR2', 
	AR4 'IPCC AR4', 
	AR5 'IPCC AR5' /;

set lu_cat(*) Land-use category /
	'CrpLand' 'Crop land', 
	'GrsLand' 'Grass land', 
	'FrsLand' 'Forest land', 
	'BrnBiom' 'Burning biomass' /;

set lu_subcat(*) Land-use sub-category /
	'FrsLand' 'Forest land', 
	'OrgSoil' 'Organic soil', 
	'FrsConv' 'Forest conversion', 
	'TropFrs' 'Tropical forest', 
	'OthrFrs' 'Other forest' /;

alias (i,j), (ii,jj), (r,rr,r1,r2,rx), (g,gg), (mapi,mapj);

*	Parameters which are read from the GTAP container:

parameters
	maks(ii,jj,r)	'MAKE matrix (before output tax/subsidy)'
	makb(ii,jj,r)	'MAKE matrix at basic prices'
	evfb(ff,jj,r)	'Primary factor purchases, by firms, at basic prices'
	evfp(ff,jj,r)	'Primary factor purchases, at producers prices'
	vdfb(ii,jj,r)	'Domestic purchases, by firms, at basic prices' 
	vdfp(ii,jj,r)	'Domestic purchases, by firms, at producers prices'
	vdpb(ii,r)	'Domestic purchases, by households, at basic prices' 
	vdpp(ii,r)	'Domestic purchases, by households, at producers prices'
	vdgb(ii,r)	'Domestic purchases, by government, at basic prices' 
	vdgp(ii,r)	'Domestic purchases, by government, at producers prices' 
	vdib(ii,r)	'Domestic purchases, by investment, at basic prices'
	vdip(ii,r)	'Domestic purchases, by investment, at producers prices'
	vmfb(ii,jj,r)	'Imported purchases, by firms, at basic prices' 
	vmfp(ii,jj,r)	'Imported purchases, by firms, at producers prices' 
	vmpb(ii,r)	'Import purchases, by households, at basic prices'
	vmpp(ii,r)	'Import purchases, by households, at producers prices'
	vmgb(ii,r)	'Import purchases, by government, at basic prices'
	vmgp(ii,r)	'Import purchases, by government, at producers prices'
	vmib(ii,r)	'Import purchases, by investment, at basic prices'
	vmip(ii,r)	'Import purchases, by investment, at producers prices'
	vfob(ii,r,rr)	'Non-margin exports, at FOB prices'
	vxsb(ii,r,rr)	'Non-margin exports, at basic prices'
	vcif(ii,r,rr)	'Imports, at CIF prices'
	vmsb(ii,r,rr)	'Imports, at basic prices'
	pop(r)		'Population'
	vst_(ii,r)		"Trade - Exports for International Transportation, Market Prices",
	vtwr_(ii,jj,r,r)	"Trade - Margins for International Transportation, World Prices",
	subp_(ii,r)	"CDE substitution parameter",
	incp_(ii,r)	"CDE expansion parameter",
     	esubva_(ii,r)	"CES elast. of subs. for primary factors in production",
     	esubdm_(ii,r)	"Armington CES elast. of subs. for domestic/imported allocation",
     	etaf_(ff,r)	"CET elast. of transformation bet. sectors for sluggish primary factors",

	mdf(ii,jj,r) "Emissions from intermediate usage of domestic product, Mt CO2",
	mmf(ii,jj,r) "Emissions from intermediate usage of imports, Mt CO2",
	mdg(ii,r) "Emissions from government consumption of domestic product, Mt CO2",
	mmg(ii,r) "Emissions from government consumption of imports, Mt CO2",
	mdp(ii,r) "Emissions from private consumption of domestic product, Mt CO2",
	mmp(ii,r) "Emissions from private consumption of imports, Mt CO2",
	mdi(ii,r) "Emissions from investment of domestic product, Mt CO2",
	mmi(ii,r) "Emissions from investment of imports, Mt CO2",

	emi_io(pol,ii,jj,r)	'Non-CO2 industrial emissions, mmt'
	emi_endw(pol,ff,jj,r)	'Endowment based emissions, mmt'
	emi_qo(pol,jj,r)	'Output-based emissions, mmt'
	emi_hh(pol,ii,r)	'Household emissions, mmt'
	emi_iop(pol,ii,jj,r)	'Process emissions, mmt'
	emi_lu(pol,lu_cat,lu_subcat,r)	'Land-use emissions, mmt' 

	gwp(pol,r,ar)		Global warming potential


	edf(ii,jj,r)	"Usage of domestic product by firms, Mtoe",
	emf(ii,jj,r)	"Usage of imports by firms, Mtoe",
	edg(ii,r)	"Government consumption of domestic product, Mtoe",
	emg(ii,r)	"Government consumption of imports, Mtoe",
	edp(ii,r)	"Private consumption of domestic product, Mtoe",
	emp(ii,r)	"Private consumption of imports, Mtoe",
	edi(ii,r)	"Investment consumption of domestic goods, Mtoe",
	emi(ii,r)	"Investment consumption of imported goods, Mtoe",
	exi(ii,r,rr)	"Bilateral trade in energy, Mtoe";

*	Read the economic values for this base year;

*	GDX file names in this archive:
*	NB! File names are case-sensitivity with unzip. 

$set datfile   GSDFDAT
$set parfile   GSDFPAR
$set emissfile GSDFEMISS
$set nco2file  GSDFNCO2
$set volefile  GSDFVOLE	

*	Some parameters change names from one release to the next:

$set subp subpar
$set incp incpar
$set esubva ESUBVA
$set esubdm ESUBD
$set etaf etrae

$if not set yr $set yr 2017
$if "%yr%"=="2004" $set syr 04
$if "%yr%"=="2007" $set syr 07
$if "%yr%"=="2011" $set syr 11
$if "%yr%"=="2014" $set syr 14
$if "%yr%"=="2017" $set syr 17

$if not set zipfile $abort zipfile must point to you GTAP distribution (e.g., --zipfile=c:\GDX_AY1017.zip)

$call gmsunzip -j %zipfile% *GDX%syr%.zip   -d %tmpdir%
$call gmsunzip -j %tmpdir%GDX%syr%.zip -d %tmpdir%

*	This program can be included or it can run "stand-alone":

$ifthen.standalone not defined ff 

alias (ff,ii,jj,r,rr,ghg,lu_cat,lu_subcat,pol,ar,*);

*	GTAP 11 parameters (new names):

parameters
	maks(ii,jj,r)	'MAKE matrix (before output tax/subsidy)'
	makb(ii,jj,r)	'MAKE matrix at basic prices'
	evfb(ff,jj,r)	'Primary factor purchases, by firms, at basic prices'
	evfp(ff,jj,r)	'Primary factor purchases, at producers prices'
	vdfb(ii,jj,r)	'Domestic purchases, by firms, at basic prices' 
	vdfp(ii,jj,r)	'Domestic purchases, by firms, at producers prices'
	vdpb(ii,r)	'Domestic purchases, by households, at basic prices' 
	vdpp(ii,r)	'Domestic purchases, by households, at producers prices'
	vdgb(ii,r)	'Domestic purchases, by government, at basic prices' 
	vdgp(ii,r)	'Domestic purchases, by government, at producers prices' 
	vdib(ii,r)	'Domestic purchases, by investment, at basic prices'
	vdip(ii,r)	'Domestic purchases, by investment, at producers prices'
	vmfb(ii,jj,r)	'Imported purchases, by firms, at basic prices' 
	vmfp(ii,jj,r)	'Imported purchases, by firms, at producers prices' 
	vmpb(ii,r)	'Import purchases, by households, at basic prices'
	vmpp(ii,r)	'Import purchases, by households, at producers prices'
	vmgb(ii,r)	'Import purchases, by government, at basic prices'
	vmgp(ii,r)	'Import purchases, by government, at producers prices'
	vmib(ii,r)	'Import purchases, by investment, at basic prices'
	vmip(ii,r)	'Import purchases, by investment, at producers prices'
	vfob(ii,r,rr)	'Non-margin exports, at FOB prices'
	vxsb(ii,r,rr)	'Non-margin exports, at basic prices'
	vcif(ii,r,rr)	'Imports, at CIF prices'
	vmsb(ii,r,rr)	'Imports, at basic prices'
	pop(r)		'Population'
	vst_(ii,r)		"Trade - Exports for International Transportation, Market Prices",
	vtwr_(ii,jj,r,r)	"Trade - Margins for International Transportation, World Prices",
	subp_(ii,r)	"CDE substitution parameter",
	incp_(ii,r)	"CDE expansion parameter",
     	esubva_(ii,r)	"CES elast. of subs. for primary factors in production",
     	esubdm_(ii,r)	"Armington CES elast. of subs. for domestic/imported allocation",
     	etaf_(ff,r)	"CET elast. of transformation bet. sectors for sluggish primary factors",

	mdf(ii,jj,r) "Emissions from intermediate usage of domestic product, Mt CO2",
	mmf(ii,jj,r) "Emissions from intermediate usage of imports, Mt CO2",
	mdg(ii,r) "Emissions from government consumption of domestic product, Mt CO2",
	mmg(ii,r) "Emissions from government consumption of imports, Mt CO2",
	mdp(ii,r) "Emissions from private consumption of domestic product, Mt CO2",
	mmp(ii,r) "Emissions from private consumption of imports, Mt CO2",
	mdi(ii,r) "Emissions from investment of domestic product, Mt CO2",
	mmi(ii,r) "Emissions from investment of imports, Mt CO2",

	emi_io(pol,ii,jj,r)	'IO-based non-CO2 emissions, mmt',
	emi_endw(pol,ff,jj,r)	'Endowment based emissions, mmt',
	emi_qo(pol,jj,r)	'Output-based emissions, mmt',
	emi_hh(pol,ii,r)	'Private-based emissions, mmt',
	emi_iop(pol,ii,jj,r)	'IO-based process emissions, mmt',
	emi_lu(pol,lu_cat,lu_subcat,r) 'Land-use emissions, mmt',
	gwp(pol,r,ar)		Global warming potential

	edf(ii,jj,r)	"Usage of domestic product by firms, Mtoe",
	emf(ii,jj,r)	"Usage of imports by firms, Mtoe",
	edg(ii,r)	"Government consumption of domestic product, Mtoe",
	emg(ii,r)	"Government consumption of imports, Mtoe",
	edp(ii,r)	"Private consumption of domestic product, Mtoe",
	emp(ii,r)	"Private consumption of imports, Mtoe",
	edi(ii,r)	"Investment consumption of domestic goods, Mtoe",
	emi(ii,r)	"Investment consumption of imported goods, Mtoe",
	exi(ii,r,rr)	"Bilateral trade in energy, Mtoe";

$endif.standalone

*	Read the economic data tables:

$gdxin '%tmpdir%%datfile%.gdx'
$loaddc maks makb evfb evfp vdfb vdfp vdpb vdpp vdgb vdgp 
$loaddc vdib vdip vmfb vmfp vmpb vmpp vmgb vmgp vmib vmip
$loaddc vfob vxsb vcif vmsb pop
$loaddc vst_=vst vtwr_=vtwr

*	Read the elasticity parameters:

$gdxin %tmpdir%%parfile%.gdx
$loaddc subp_=%subp% incp_=%incp% etaf_=%etaf% esubva_=%esubva% esubdm_=%esubdm% 

*	Read the CO2 emissions data:

$gdxin '%tmpdir%%emissfile%.gdx'
$loaddc    mdf mmf mdg mmg mdp mmp mdi mmi 
$gdxin

*	Read the NCO2 emissions data:

$gdxin %tmpdir%%nco2file%.gdx
$loaddc emi_io emi_endw emi_qo emi_hh emi_iop emi_lu gwp
$gdxin

*	Read the energy data:

$gdxin '%tmpdir%%volefile%.gdx'
$loaddc    edf emf edg emg edp emp edi emi exi 
$gdxin

*	Remove the temporary directory:

$call rmdir /q /s %tmpdir%


*	Scale data from millions to billions of dollars:

maks(ii,jj,r) = maks(ii,jj,r) / 1000;
makb(ii,jj,r) = makb(ii,jj,r) / 1000;
evfb(ff,jj,r) = evfb(ff,jj,r) / 1000;
evfp(ff,jj,r) = evfp(ff,jj,r) / 1000;
vdfb(ii,jj,r) = vdfb(ii,jj,r) / 1000;
vdfp(ii,jj,r) = vdfp(ii,jj,r) / 1000;
vdpb(ii,r) = vdpb(ii,r) / 1000;
vdpp(ii,r) = vdpp(ii,r) / 1000;
vdgb(ii,r) = vdgb(ii,r) / 1000;
vdgp(ii,r) = vdgp(ii,r) / 1000;
vdib(ii,r) = vdib(ii,r) / 1000;
vdip(ii,r) = vdip(ii,r) / 1000;
vmfb(ii,jj,r) = vmfb(ii,jj,r) / 1000;
vmfp(ii,jj,r) = vmfp(ii,jj,r) / 1000;
vmpb(ii,r) = vmpb(ii,r) / 1000;
vmpp(ii,r) = vmpp(ii,r) / 1000;
vmgb(ii,r) = vmgb(ii,r) / 1000;
vmgp(ii,r) = vmgp(ii,r) / 1000;
vmib(ii,r) = vmib(ii,r) / 1000;
vmip(ii,r) = vmip(ii,r) / 1000;
vfob(ii,r,rr) = vfob(ii,r,rr) / 1000;
vxsb(ii,r,rr) = vxsb(ii,r,rr) / 1000;
vcif(ii,r,rr) = vcif(ii,r,rr) / 1000;
vmsb(ii,r,rr) = vmsb(ii,r,rr) / 1000;
vst_(ii,r) = vst_(ii,r) / 1000;
vtwr_(ii,jj,r,rr) = vtwr_(ii,jj,r,rr) / 1000;

*	GTAPinGAMS parameters (pre-GTAP 11 nomenclature):

parameters
	vom(g,r)	"Gross output",
	vfm(f,g,r)	"Endowments - Firms' purchases at market prices",
	vdfm(i,g,r)	"Intermediates - firms' domestic purchases at market prices",
	vifm(i,g,r)	"Intermediates - firms' imports at market prices",
	vxmd(i,r,rr)	"Trade - bilateral exports at market prices",
	vst(i,r)	"Trade - Exports for International Transportation, Market Prices",
	vtwr(i,j,r,r)	"Trade - Margins for International Transportation, World Prices",

	rto(g,r)	"Output (or income) subsidy rates",
	rtf(f,g,r)	"Primary factor and commodity rates taxes",
	rtfd(i,g,r)	"Firms' domestic tax rates",
	rtfi(i,g,r)	"Firms' import tax rates",
	rtxs(i,r,rr)	"Export subsidy rates",
	rtms(i,r,rr)	"Import taxes rates";


set	mapij(ii,jj,i,j)	Two-dimensional mapping;

mapij(ii,jj,i,j) = (mapi(ii,i) and mapj(jj,j));

*	Output taxes are defined on a gross basis:
*		(1-rto)*makb = maks

rto(j,r) = sum(mapj(jj,j)$makb(jj,jj,r), 1 - maks(jj,jj,r)/makb(jj,jj,r));
rtf(f,j,r)$sum((mapj(jj,j),mapf(ff,f)),evfb(ff,jj,r)) = sum((mapj(jj,j),mapf(ff,f)),evfp(ff,jj,r))/sum((mapj(jj,j),mapf(ff,f)),evfb(ff,jj,r))-1;
rtfd(i,j,r)$sum(mapij(ii,jj,i,j),vdfb(ii,jj,r)) = sum(mapij(ii,jj,i,j),vdfp(ii,jj,r))/sum(mapij(ii,jj,i,j),vdfb(ii,jj,r))-1;
rtfd(i,"c",r)$sum(mapi(ii,i),vdpb(ii,r)) = sum(mapi(ii,i),vdpp(ii,r))/sum(mapi(ii,i),vdpb(ii,r))-1;
rtfd(i,"g",r)$sum(mapi(ii,i),vdgb(ii,r)) = sum(mapi(ii,i),vdgp(ii,r))/sum(mapi(ii,i),vdgb(ii,r))-1;
rtfd(i,"i",r)$sum(mapi(ii,i),vdib(ii,r)) = sum(mapi(ii,i),vdip(ii,r))/sum(mapi(ii,i),vdib(ii,r))-1;
rtfi(i,j,r)$sum(mapij(ii,jj,i,j),vmfb(ii,jj,r)) = sum(mapij(ii,jj,i,j),vmfp(ii,jj,r))/sum(mapij(ii,jj,i,j),vmfb(ii,jj,r))-1;
rtfi(i,"c",r)$sum(mapi(ii,i),vmpb(ii,r)) = sum(mapi(ii,i),vmpp(ii,r))/sum(mapi(ii,i),vmpb(ii,r))-1;
rtfi(i,"g",r)$sum(mapi(ii,i),vmgb(ii,r)) = sum(mapi(ii,i),vmgp(ii,r))/sum(mapi(ii,i),vmgb(ii,r))-1;
rtfi(i,"i",r)$sum(mapi(ii,i),vmib(ii,r)) = sum(mapi(ii,i),vmip(ii,r))/sum(mapi(ii,i),vmib(ii,r))-1;

vom(j,r) = sum(mapj(jj,j),makb(jj,jj,r));
vfm(f,j,r) = sum((mapj(jj,j),mapf(ff,f)),evfb(ff,jj,r));
vdfm(i,j,r) = sum((mapij(ii,jj,i,j)),vdfb(ii,jj,r));
vdfm(i,"c",r) = sum(mapi(ii,i),vdpb(ii,r));
vdfm(i,"g",r) = sum(mapi(ii,i),vdgb(ii,r));
vdfm(i,"i",r) = sum(mapi(ii,i),vdib(ii,r));
vifm(i,j,r) = sum(mapij(ii,jj,i,j),vmfb(ii,jj,r));
vifm(i,"c",r) = sum(mapi(ii,i),vmpb(ii,r));
vifm(i,"g",r) = sum(mapi(ii,i),vmgb(ii,r));
vifm(i,"i",r) = sum(mapi(ii,i),vmib(ii,r));
vtwr(j,i,r,rr) = sum(mapij(ii,jj,i,j),vtwr_(jj,ii,r,rr));
vst(i,r) = sum(mapi(ii,i),vst_(ii,r));

*	No factor inputs to final demand sectors:

vom(g,r)$(not j(g)) = sum(i,vdfm(i,g,r)*(1+rtfd(i,g,r))+vifm(i,g,r)*(1+rtfi(i,g,r)))/(1-rto(g,r));;
vxmd(i,r,rr) = sum(mapi(ii,i),vxsb(ii,r,rr));

*	rtxs is defined on a gross basis:
*	vfob = vxsb*(1-rtxs)

rtxs(i,r,rr)$vxmd(i,r,rr) = 1 - sum(mapi(ii,i),vfob(ii,r,rr))/vxmd(i,r,rr);

*	vmsb=vcif*(1+rtms)

rtms(i,r,rr)$sum(mapi(ii,i),vmsb(ii,r,rr)) = sum(mapi(ii,i),vmsb(ii,r,rr))/sum(mapi(ii,i),vcif(ii,r,rr))-1;

parameter	vdbchk(i,r)	Cross check on output;
vdbchk(i,r) = round(vom(i,r) - sum(rr,vxmd(i,r,rr)) - vst(i,r) - sum(g,vdfm(i,g,r)),3);
display vdbchk;

parameter	vstchk(i)	Cross check on sum(vst)=sum(vtwr);
vstchk(i) = round(sum(r,vst(i,r)) - sum((j,r,rr),vtwr(i,j,r,rr)),3);
display vstchk;

parameter	vomchk(g,r)	Cross check on profit;
vomchk(g,r) = round(vom(g,r)*(1-rto(g,r))  
		- sum(i,vdfm(i,g,r)*(1+rtfd(i,g,r))+vifm(i,g,r)*(1+rtfi(i,g,r))) 
		- sum(f,vfm(f,g,r)*(1+rtf(f,g,r))), 3);
option vomchk:3;
display vomchk;
vomchk(g,r) = round(vomchk(g,r),3);
display vomchk;

parameter	pvxmd(i,r,r)	Import price (power of benchmark tariff)
		pvtwr(i,r,r)	Import price for transport services;

pvxmd(i,rr,r) = (1+rtms(i,rr,r)) * (1-rtxs(i,rr,r));
pvtwr(i,rr,r) = 1+rtms(i,rr,r);

*	vim = (vxmd*(1-rtxs)+vtwr)*(1+rtms) = vxmd*pvxmd + vtwr*ptwr

parameter	vim(i,r)	Imports at basic prices;
vim(i,r) = sum(rr,vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))*pvtwr(i,rr,r));

parameter	vimchk	Check on supply and demand for imports;
vimchk(i,r) = round(vim(i,r) - sum(g,vifm(i,g,r)),3);
display vimchk;

parameter
	subp(i,r)	"CDE substitution parameter",
	incp(i,r)	"CDE expansion parameter",
     	esubva(i)	"CES elasticity of substitution for primary factors",
     	esubdm(i)	"Armington elasticity of substitution D versus M",
	etaf(f)		"CET elasticity of transformation for sluggish factors";

subp(i,r) = sum(mapi(ii,i),subp_(ii,r));
incp(i,r) = sum(mapi(ii,i),incp_(ii,r));
esubva(i) = sum(mapi(ii,i),esubva_(ii,"usa"));
esubdm(i) = sum(mapi(ii,i),esubdm_(ii,"usa"));

*	Save the elasticity of transformation:

etaf(f)   = abs(sum(mapf(ff,f),etaf_(ff,"usa")));

*	Add income elasticities and AUES matrices to the dataset:

parameter	thetac(i,r)	Final demand value shares,
		eta(i,r)	Income elasticity of demand,
		aues(i,j,r)	Allen-Uzawa elasticities of substitution;

alias (i,k);

*	Final consumption value shares:

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

*	Drop references to commodities with zero value shares:

subp(i,r)$(not thetac(i,r)) = 0;
incp(i,r)$(not thetac(i,r)) = 0;

*	Income elasticity of demand:

eta(i,r)$(not thetac(i,r)) = 0;
eta(i,r)$thetac(i,r) = subp(i,r) - sum(k,thetac(k,r)*subp(k,r)) + 
	(incp(i,r)*(1-subp(i,r)) + sum(k,thetac(k,r)*incp(k,r)*subp(k,r))) / 
	sum(k,thetac(k,r)*incp(k,r));

*	The Allen-Uzawa matrix of own- and cross-price elasticities
*	of substitution:

aues(i,j,r)$(not (thetac(i,r) and thetac(j,r))) = 0;
aues(i,j,r)$(thetac(i,r) and thetac(j,r)) = subp(i,r) + subp(j,r) 
		- sum(k,thetac(k,r)*subp(k,r))
		- (subp(i,r)/thetac(i,r))$sameas(i,j);

*	Add descriptions to set g:

set	g_(g)	Set elements with descriptions;
g_(g) = g(g);
g_(i) = i(i);

parameter	eco2d(i,g,r)	"CO2 emissions from domestic product (Mt)"
		eco2i(i,g,r)	"CO2 Emissions from imported product (Mt)";

eco2d(i,j,r) = sum(mapij(ii,jj,i,j), mdf(ii,jj,r));
eco2i(i,j,r) = sum(mapij(ii,jj,i,j), mmf(ii,jj,r));
eco2d(i,"c",r) = sum(mapi(ii,i),mdp(ii,r));
eco2i(i,"c",r) = sum(mapi(ii,i),mmp(ii,r));
eco2d(i,"g",r) = sum(mapi(ii,i),mdg(ii,r));
eco2i(i,"g",r) = sum(mapi(ii,i),mmg(ii,r));
eco2d(i,"i",r) = sum(mapi(ii,i),mdi(ii,r));
eco2i(i,"i",r) = sum(mapi(ii,i),mmi(ii,r));


parameter	evd(i,g,r)	"Domestic energy use (mtoe)"
		evi(i,g,r)	"Imported energy use (mtoe)"
		evt(i,r,rr)	"Volume of energy trade (mtoe)";

evd(i,j,r)   = sum(mapij(ii,jj,i,j), edf(ii,jj,r));
evi(i,j,r)   = sum(mapij(ii,jj,i,j), emf(ii,jj,r));
evd(i,"c",r) = sum(mapi(ii,i),edp(ii,r));
evi(i,"c",r) = sum(mapi(ii,i),emp(ii,r));
evd(i,"g",r) = sum(mapi(ii,i),edg(ii,r));
evi(i,"g",r) = sum(mapi(ii,i),emg(ii,r));
evd(i,"i",r) = sum(mapi(ii,i),edi(ii,r));
evi(i,"i",r) = sum(mapi(ii,i),emi(ii,r));

evt(i,r,rr) = sum(mapi(ii,i),exi(ii,r,rr));

set	lu	Land use emissions category/
		ForestLand	Forest land use,
		ForestConv	Forest conversion,
		BurnOrgSoil	Burning on organic soil,
		BurnTropFor	Burning tropical forest
		BurnOthrFor	Burning other forests/

set	lumap(lu_cat, lu_subcat, lu) /
		FrsLand.FrsLand.ForestLand
		FrsLand.FrsConv.ForestConv
		BrnBiom.OrgSoil.BurnOrgSoil
		BrnBiom.TropFrs.BurnTropFor
		BrnBiom.OthrFrs.BurnOthrFor/

set	i_f /set.i, set.f, output/;

parameter
	nco2emit(pol,i_f,g,r)	'Industrial and household non-CO2 emissions, mmt',
	nco2process(pol,i,j,r)	'IO-based process emissions, mmt',
	landuse(pol,lu,r)	'Land-use emissions, mmt';

nco2emit(pol,i_f(i),j,r)	= sum(mapij(ii,jj,i,j),emi_io(pol,ii,jj,r));
nco2emit(pol,i_f(i),"c",r)	= sum(mapi(ii,i),emi_hh(pol,ii,r));
nco2emit(pol,i_f(f),j,r)	= sum((mapf(ff,f),mapj(jj,j)),emi_endw(pol,ff,jj,r));
nco2emit(pol,"output",j,r)	= sum(mapj(jj,j),emi_qo(pol,jj,r));
nco2process(pol,i,j,r)	= sum(mapij(ii,jj,i,j),emi_iop(pol,ii,jj,r));
landuse(pol,lu,r)	= sum(lumap(lu_cat,lu_subcat,lu),emi_lu(pol,lu_cat, lu_subcat,r));

set	metadata	Information about the dataset aggregation /
	gtapversion	"11",
	gtapdate	"MAR2023",
	rundate		"%system.date%",
	filesys		"%system.filesys%",
	username	"%system.username%",
	computername	"%system.computername%",
	gamsversion	"%system.gamsversion%",
	gamsprogram	"%system.fp%%system.fn%%system.fe%"/;

option metadata:0:0:1;
display metadata;

execute_unload '%yr%%system.dirsep%gtapingams.gdx',g_=g,i,f,r,pol,
	vst, vtwr, vfm, vdfm, vifm, vxmd, rto, rtf, rtfd, rtfi, rtxs, rtms,
	subp, incp, etaf, esubva, esubdm, eta, aues, pop, 
	eco2d, eco2i, 
	nco2emit, nco2process, landuse, gwp, metadata,
	evd, evi, evt;

