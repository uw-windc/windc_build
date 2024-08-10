$setglobal gtap_version gtap11c

$include "d:\GitHub\windc_build\GTAPWiNDC\gtap11\gtapdata"

set	sbea	Summary table sectors -- WiNDC labels /
	agr  "Farms (111CA)",
	fof  "Forestry, fishing, and related activities (113FF)",
	oil  "Oil and gas extraction (211)",
	min  "Mining, except oil and gas (212)",
	smn  "Support activities for mining (213)",
	uti  "Utilities (22)",
	con  "Construction (23)",
	wpd  "Wood products manufacturing (321)",
	nmp  "Nonmetallic mineral products manufacturing (327)",
	pmt  "Primary metals manufacturing (331)",
	fmt  "Fabricated metal products (332)",
	mch  "Machinery manufacturing (333)",
	cep  "Computer and electronic products manufacturing (334)",
	eec  "Electrical equipment, appliance, and components manufacturing (335)",
	mot  "Motor vehicles, bodies and trailers, and parts manufacturing (3361MV)",
	fpd  "Furniture and related products manufacturing (337)",
	mmf  "Miscellaneous manufacturing (339)",
	fbp  "Food and beverage and tobacco products manufacturing (311FT)",
	tex  "Textile mills and textile product mills (313TT)",
	alt  "Apparel and leather and allied products manufacturing (315AL)",
	ppd  "Paper products manufacturing (322)",
	pri  "Printing and related support activities (323)",
	pet  "Petroleum and coal products manufacturing (324)",
	che  "Chemical products manufacturing (325)",
	pla  "Plastics and rubber products manufacturing (326)",
	ote  "Other transportation equipment (3364OT)",
	wht  "Wholesale trade (42)",
	mvt  "Motor vehicle and parts dealers (441)",
	fbt  "Food and beverage stores (445)",
	gmt  "General merchandise stores (452)",
	ott  "Other retail (4A0)",
	air  "Air transportation (481)",
	trn  "Rail transportation (482)",
	wtt  "Water transportation (483)",
	trk  "Truck transportation (484)",
	grd  "Transit and ground passenger transportation (485)",
	pip  "Pipeline transportation (486)",
	otr  "Other transportation and support activities (487OS)",
	wrh  "Warehousing and storage (493)",
	pub  "Publishing industries, except Internet (includes software) (511)",
	mov  "Motion picture and sound recording industries (512)",
	brd  "Broadcasting and telecommunications (513)",
	dat  "Data processing, internet publishing, and other information services (514)",
	bnk  "Federal Reserve banks, credit intermediation, and related services (521ci)",
	sec  "Securities, commodity contracts, and investments (523)",
	ins  "Insurance carriers and related activities (524)",
	fin  "Funds, trusts, and other financial vehicles (525)",
	hou  "Housing (HS)",
	ore  "Other real estate (ORE)",
	rnt  "Rental and leasing services and lessors of intangible assets (532RL)",
	leg  "Legal services (5411)",
	tsv  "Miscellaneous professional, scientific, and technical services (5412OP)",
	com  "Computer systems design and related services (5415)",
	man  "Management of companies and enterprises (55)",
	adm  "Administrative and support services (561)",
	wst  "Waste management and remediation services (562)",
	edu  "Educational services (61)",
	amb  "Ambulatory health care services (621)",
	hos  "Hospitals (622)",
	nrs  "Nursing and residential care facilities (623)",
	soc  "Social assistance (624)",
	art  "Performing arts, spectator sports, museums, and related activities (711AS)",
	rec  "Amusements, gambling, and recreation industries (713)",
	amd  "Accommodation (721)",
	res  "Food services and drinking places (722)",
	osv  "Other services, except government (81)",
	fdd  "Federal general government (defense) (GFGD)",
	fnd  "Federal general government (nondefense) (GFGN)",
	slg  "State and local general government (GSLG)",
	fen  "Federal government enterprises (GFE)",
	sle  "State and local government enterprises (GSLE)",
	usd  "Scrap, used and secondhand goods",
	oth  "Noncomparable imports and rest-of-the-world adjustment" /;

$eolcom !
set	map(i,sbea) GTAPinGAMS mapping  /

	(	! "Forestry, fishing, and related activities (113FF)"
		FRS		! "Forestry",
		FSH		! "Fishing",
	).fof	

	(	! "Food and beverage and tobacco products (311FT)"
		CMT    		! "Bovine meat products",
		OMT    		! "Meat products nec",
		VOL    		! "Vegetable oils and fats",
		MIL    		! "Dairy products",
		PCR    		! "Processed rice",
		SGR    		! "Sugar",
		OFD    		! "Food products nec",
		B_T    		! "Beverages and tobacco products",
	).fbp

	(	! "Apparel and leather and allied products (315AL)"
		WAP		! "Wearing apparel",
		LEA		! "Leather products",
	).alt

	(	! "Primary metals (331)"
		I_S		! "Ferrous metals",
		NFM		! "Metals nec",
	).pmt

	(	! "Crude oil and natural gas"
		CRU		! "Crude Oil",
		GAS		! "Gas",
	).oil

	(	! "Utilities"
		ELE		! "Electricity",
		GDT		! "Gas manufacture, distribution",
		WTR		! "Water",
	).uti
	
	(	! "Mining"
		COL		! "Coal",
		OXT		! "Other mining extraction",
	).(min,smn)
	
	(	! "Recreational and other services"
		AFS		! "Accommodation, Food and service activities",
		ROS		! "Recreational and other services",
	).(rec,art,amd,res)
	
	(	! "Dwellings and real estate activities"
		DWE		! "Dwellings",
		RSA		! "Real estate activities",
	).(hou,ore,rnt)

	
	INS.ins			! "Insurance",
	(CHM,BPH).che		! "Chemical, rubber, plastic products",
	RPP.pla
	(CEO,EEQ).(cep,eec)	! "Electronic equipment",
	(OTP,WHS).(wrh,trn,trk,grd,pip,otr)		! "Transport nec",
	(OSG).(fdd,fnd,fen,slg,sle) ! "Public Administration, Defense, Health",

	EDU.edu		! Education, 
	HHT.(amb, hos, nrs, soc)


*	The rest are one-to-one:

	(PDR,		! "Paddy rice",
	WHT,		! "Wheat",
	GRO,		! "Cereal grains nec",
	V_F,		! "Vegetables, fruit, nuts",
	OSD,		! "Oil seeds",
	C_B,		! "Sugar cane, sugar beet",
	PFB,		! "Plant-based fibers",
	OCR,		! "Crops nec",
	CTL,		! "Bovine cattle, sheep and goats, horses",
	OAP,		! "Animal products nec",
	RMK,		! "Raw milk",
	WOL).agr	! "Wool, silk-worm cocoons"

	TEX.tex		! "Textiles",
	LUM.(wpd,fpd)		! "Wood products",
	NMM.nmp		! "Mineral products nec",
	FMP.fmt		! "Metal products",
	MVH.(mot,ote)	! "Motor vehicles and parts",
	OTN.mot		! "Transport equipment nec",
	OME.mch		! "Machinery and equipment nec",
	CNS.con		! "Construction",
	WTP.wtt		! "Water transport",
	ATP.air		! "Air transport",

	OIL.(pet)	! "Petroleum, coal products",
	PPP.(ppd,pri,pub)	! "Paper products, publishing",
	OMF.mmf		! "Manufactures nec",
	CMN.(brd,mov)		! "Communication",
	OFI.(fin,bnk,sec)	! "Financial services nec",
	OBS.(leg,tsv,com,man,adm,wst,dat,osv) ! "Business services nec"
	trd.(wht,mvt,fbt,gmt,ott,usd,oth)	! "Trade",
/;

set sbeamapped(sbea),unmapped(*);
option sbeamapped<map;
unmapped(sbea) = sbea(sbea)$(not sbeamapped(sbea));
option unmapped:0:0:1;
display unmapped;

set	imapped(i);
option imapped<map;
unmapped(i) = i(i)$(not imapped(i));
display unmapped;

parameter	fshare(sbea,f)		Factor shares;
fshare(sbea,f) = sum(map(i,sbea),vfm(f,i,"usa")*(1+rtf0(f,i,"usa"))) /
		 sum((f.local,map(i,sbea)),vfm(f,i,"usa")*(1+rtf0(f,i,"usa")));
display fshare;

parameter	elast		Elasticities;
elast(sbea,"esubva") =	 sum(map(i,sbea),vom(i,"usa")*esubva(i))/
			 sum(map(i,sbea),vom(i,"usa"));
elast(sbea,"esubdm") = sum(map(i,sbea),vim(i,"usa")*esubdm(i))/
			 sum(map(i,sbea),vim(i,"usa"));
display elast;

parameter	rpc(sbea)	Regional purchase fraction;
rpc(sbea) = sum((map(i,sbea),g),vdfm(i,g,"usa")*(1+rtfd0(i,g,"usa"))) /
	sum((map(i,sbea),g),vdfm(i,g,"usa")*(1+rtfd0(i,g,"usa"))+vifm(i,g,"usa")*(1+rtfi0(i,g,"usa")));
option rpc:3:0:1;
display rpc;

execute_unload 'gtapinfo.gdx',f,fshare,elast,rpc;

$exit



set	f	Factor labels for GTAPinGAMS  /
	mgr	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tec	Technicians technicians and associate professionals
	clk	Clerks
	srv	Service and market sales workers
	lab	Agricultural and unskilled workers (Major Groups 6-9)
	cap     Capital,    
	lnd     Land,    
	res     Natural resources /;

