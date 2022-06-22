*	Define the G20 regions and their mapping to GTAPinGAMS

set rr  Regions in the G20 aggregation /

	ARG	Argentina
	ANZ	Australia and New Zealand
	BRA	Brazil
	CAN	Canada
	CHN	China and Hong Kong
	FRA	France
	DEU	Germany
	IND	India
	IDN	Indonesia
	ITA	Italy
	JPN	Japan
	MEX	Mexico
	RUS	Russia
	SAU	Saudi Arabia
	ZAF	South Africa
	KOR	Korea
	TUR	Turkey
	GBR	United Kingdom
	USA	United States
	REU	Rest of European Union (excluding FRA - DEU - GBR - ITA)
	OEX	Other oil exporters
	LIC	Other low-income countries
	MIC	Other middle-income countries

/;

*	Permit the mapping to cover GTAP Versions 8, 9 and 10:

alias (ur,*);

$onembedded

SET mapr(ur,rr) Mapping of GTAP Regions (from-to) /
	ARG.ARG	Argentina
	BRA.BRA	Brazil
	CAN.CAN	Canada
	FRA.FRA	France
	DEU.DEU	Germany
	ITA.ITA	Italy
	JPN.JPN	Japan
	MEX.MEX	Mexico
	RUS.RUS	Russia
	SAU.SAU	Saudi Arabia
	IND.IND	India
	IDN.IDN	Indonesia
	ZAF.ZAF	South Africa
	KOR.KOR	Korea
	TUR.TUR	Turkey
	GBR.GBR	United Kingdom
	USA.USA	United States

$eolcom !

	( 	! China including Hong Kong
		CHN	!	China
		HKG	!	Hong Kong
	).CHN	

	(	! Other oil exporters 
		VEN		!	Venezuela
		BHR		!	Bahrain
		KWT		!	Kuwait
		QAT		!	Qatar
		ARE		!	United Arab Emirates
		IRN		!	Iran, Islamic Republic of
	).OEX

	(	 ! Australia and New Zealand
		AUS	!	Australia
		NZL	!	New Zealand
	).ANZ,

	(	! Rest of Europe
		AUT	!	Austria
		BEL	!	Belgium
		DNK	!	Denmark
		FIN	!	Finland
		GRC	!	Greece
		IRL	!	Ireland
		LUX	!	Luxembourg
		NLD	!	Netherlands
		PRT	!	Portugal
		ESP	!	Spain
		SWE	!	Sweden
		CZE	!	Czech Republic
		HUN	!	Hungary
		MLT	!	Malta
		POL	!	Poland
		ROU	!	Romania
		SVK	!	Slovakia
		SVN	!	Slovenia
		EST	!	Estonia
		LVA	!	Latvia
		LTU	!	Lithuania
		BGR	!	Bulgaria
		CYP	!	Cyprus

		CHE	!	Switzerland
		NOR	!	Norway
		XEF	!	Rest of EFTA
		XER	!	Rest of Europe
*			- Andorra
*			- Bosnia and Herzegovina
*			- Faroe Islands
*			- Gibraltar
*			- Macedonia, the former Yugoslav Republic of
*			- Monaco
*			- San Marino
*			- Serbia and Montenegro
*			- Iceland
*			- Liechtenstein

	).REU,

	KHM.LIC		!	Cambodia
	LAO.LIC		!	Lao People's Democratic Republic
	BGD.LIC		!	Bangladesh
	XSA.LIC		!	Rest of South Asia
	KGZ.LIC		!	Kyrgyzstan
	XWF.LIC		!	Rest of Western Africa
	XCF.LIC		!	Rest of Central Africa
	XAC.LIC		!	Rest of South Central Africa
	KEN.LIC		!	Kenya
	ETH.LIC		!	Ethiopia
	MDG.LIC		!	Madagascar
	MWI.LIC		!	Malawi
	MOZ.LIC		!	Mozambique
	TZA.LIC		!	Tanzania
	UGA.LIC		!	Uganda
	ZMB.LIC		!	Zambia
	ZWE.LIC		!	Zimbabwe
	XEC.LIC		!	Rest of Eastern Africa


	MYS.MIC		!	Malaysia
	XOC.MIC		!	Rest of Oceania
	TWN.MIC		!	Taiwan
	XEA.MIC		!	Rest of East Asia
	PHL.MIC		!	Philippines
	SGP.MIC		!	Singapore
	THA.MIC		!	Thailand
	VNM.MIC		!	Vietnam
	XSE.MIC		!	Rest of Southeast Asia
	PAK.MIC		!	Pakistan
	LKA.MIC		!	Sri Lanka
	XNA.MIC		!	Rest of North America
	BOL.MIC		!	Bolivia
	CHL.MIC		!	Chile
	COL.MIC		!	Colombia
	ECU.MIC		!	Ecuador
	PRY.MIC		!	Paraguay
	PER.MIC		!	Peru
	URY.MIC		!	Uruguay
	XSM.MIC		!	Rest of South America
	CRI.MIC		!	Costa Rica
	GTM.MIC		!	Guatemala
	NIC.MIC		!	Nicaragua
	PAN.MIC		!	Panama
	XCA.MIC		!	Rest of Central America
	XCB.MIC		!	Caribbean
	ALB.MIC		!	Albania
	BLR.MIC		!	Belarus
	HRV.MIC		!	Croatia
	UKR.MIC		!	Ukraine
	XEE.MIC		!	Rest of Eastern Europe
	KAZ.MIC		!	Kazakhstan
	XSU.MIC		!	Rest of Former Soviet Union
	ARM.MIC		!	Armenia
	AZE.MIC		!	Azerbaijan
	GEO.MIC		!	Georgia
	EGY.MIC		!	Egypt
	MAR.MIC		!	Morocco
	TUN.MIC		!	Tunisia
	XNF.MIC		!	Rest of North Africa
	NGA.MIC		!	Nigeria
	SEN.MIC		!	Senegal
	MUS.MIC		!	Mauritius
	BWA.MIC		!	Botswana
	XSC.MIC		!	Rest of South African Customs Union 

	OMN.MIC		!	Oman
	ISR.MIC		!	Israel
	MNG.MIC		!	Mongolia
	NPL.MIC		!	Nepal
	HND.MIC		!	Honduras
	SLV.MIC		!	El Salvador
	XWS.MIC		!	Rest of Western Asia
	CMR.MIC		!	Cameroon
	CIV.MIC		!	Cote d'Ivoire
	GHA.MIC		!	Ghana
	NAM.MIC		!	Namibia

	XTW.MIC		!	Rest of the World 

*	Regions added in GTAP version 9:

	BRN.MIC		!	Brunei Darussalam
	DOM.MIC		!	Dominican Republic
	JAM.MIC		!	Jamaica
	PRI.MIC		!	Puerto Rico
	TTO.LIC		!	Trinidad and Tobago
	JOR.LIC		!	Jordan
	BEN.LIC		!	Benin
	BFA.LIC		!	Burkina Faso
	GIN.LIC		!	Guinea
	TGO.LIC		!	Togo
	RWA.LIC		!	Rwanda

*	Region added in GTAP version 10:

	TJK.MIC		!	Tajikistan

	/;

*	We define mappings for regions in all GTAP versions.  
*	Remove those which are not in the current dataset.

set	notr(ur)	Labels which are not in r;
option notr<mapr;
notr(r) = no;
mapr(notr,rr) = no;

*	See that each region in the source data has been mapped:

abort$(card(mapr)<>card(r))	"Error: card(mapr)<>card(r).";
