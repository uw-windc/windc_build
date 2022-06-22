*	Energy-intensive sectors aggregated for use with WiNDC

set ii	Sectors in the aggregation /

	ele	"Utilities (electricity-gas-water)"
	ogs	"Crude oil and natural gas"
	col	"Coal",
	oil	"Petroleum, coal products",
	eis	"Energy-intensive manufactures"
	trn	Transportation
	agr	"Agriculture forestry and fishing"
	man	Other manufactured products
	cns	"Construction",
	ser	Other public and private services /;

alias (ui,*);

set	mapi(ui,ii)	Sectoral mapping /

$eolcom !

	(	! "Farms (111CA)"
		PDR		! "Paddy rice",
		WHT		! "Wheat",
		GRO		! "Cereal grains nec",
		V_F		! "Vegetables, fruit, nuts",
		OSD		! "Oil seeds",
		C_B		! "Sugar cane, sugar beet",
		PFB		! "Plant-based fibers",
		OCR		! "Crops nec",
		CTL		! "Bovine cattle, sheep and goats, horses",
		OAP		! "Animal products nec",
		RMK		! "Raw milk",
		WOL		! "Wool, silk-worm cocoons"
		FRS		! "Forestry",
		FSH		! "Fishing",
	).agr

	COL.col			! "Coal",
	OIL.oil			! "Petroleum, coal products",
	CRU.ogs			! "Crude oil and natural gas"
	GAS.ogs			! "Gas",
	GDT.ogs			! "Gas manufacture, distribution",
	ELE.ele			! "Electricity",

	tex.man		! "Textiles",

	lum.man		! "Wood products",
	nmm.man		! "Mineral products nec",
	FMP.man		! "Metal products",
	MVH.man		! "Motor vehicles and parts",
	OTN.man		! "Transport equipment nec",
	OME.man		! "Machinery and equipment nec",
	EEQ.man		! "Electronic equipment",
	CEO.man		! "Computer, electronic and optical products",
	OMF.man		! "Manufactures nec",

	CMT.man		! "Bovine meat products",
	OMT.man		! "Meat products nec",
	VOL.man		! "Vegetable oils and fats",
	MIL.man		! "Dairy products",
	PCR.man		! "Processed rice",
	SGR.man		! "Sugar",
	OFD.man		! "Food products nec",
	B_T.man		! "Beverages and tobacco products",
	WAP.man		! "Wearing apparel",
	LEA.man		! "Leather products",
	PPP.man		! "Paper products, publishing",

	(
		I_S		! "Ferrous metals",
		NFM		! "Metals nec",
		CHM		! "Chemical products",
		CRP		! "Chemical, rubber, plastic products",
		RPP		! "Rubber and plastic products",
	).eis

	(
		WTP	! "Water transport",
		ATP	! "Air transport",
		OTP	! "Transport nec",
	).trn

	TRD.ser		! "Trade",

	CNS.cns		! "Construction",

	(	INS		! "Insurance (formerly isr)"			
		ISR	 	! "Insurance (now INS)",
		OXT		! "Other Extraction (formerly omn Minerals nec)",
		OMN		! "Minerals nec",
		BPH		! "Basic pharmaceutical products",
		AFS		! "Accommodation, Food and service activities",
		CMN		! "Communication",
		OFI		! "Financial services nec",
		OBS		! "Business services nec",
		RSA		! "Real estate activities",
		ROS		! "Recreational and other services",
		WHS		! "Warehousing and support activities",
		OSG		! "Public Administration and defense",
		EDU		! "Education",
		HHT		! "Human health and social work activities",
		WTR		! "Water",
		DWE		! "Dwellings"
	).ser
/;

*	We define mappings for commodities in all GTAP versions.  
*	Remove those which are not in the current dataset.
set	noti(ui)	Labels which are not in i;
option noti<mapi;
noti(i) = no;

mapi(noti,ii) = no;

set	bug(ui)	Items from i not included in mapi;

option bug<mapi;
bug(i) = yes;
loop(mapi(i,ii), bug(i) = no;);

abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).", bug;
