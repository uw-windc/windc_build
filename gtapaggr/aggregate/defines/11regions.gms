$title	Define an Aggregation to 10 Regions

set rr  Regions in the aggregation /

*	India?  Importers of Russian oil and gas?

	USA	United States
	EUR	The European Union (Western Europe incl UK)
	CAN	Canada
	LAC	Latin America
	OEC	Other OECD
	IND	India
	CHN	China and Hong Kong
	RUS	Russia
	UKR	Ukraine
	OPC	Other OPEC
	ROW	Rest of World
/;

alias (ur,*);

SET mapr(ur,rr) Mapping of GTAP Regions (from-to) /

	ARG.LAC	Argentina
	BRA.LAC	Brazil
	PRY.LAC	Paraguay
	URY.LAC	Uruguay
	CHL.LAC Chile
	MEX.LAC	Mexico
	CRI.LAC	Costa Rica
	GTM.LAC	Guatemala
	NIC.LAC	Nicaragua
	PAN.LAC	Panama
	XCA.LAC	Rest of Central America
	XCB.LAC	Caribbean

	CAN.CAN	Canada
	FRA.EUR	France
	DEU.EUR	Germany
	ITA.EUR	Italy

	IND.IND	India

	IDN.ROW	Indonesia
	ZAF.ROW	South Africa
	KOR.OEC	Korea
	GBR.EUR	United Kingdom
	USA.USA	United States
	UKR.UKR	Ukraine
	RUS.RUS	Russia

	AUS.OEC Australia
	JPN.OEC	Japan
	NZL.OEC New Zealand
	ISR.OEC	Israel
	CHE.OEC	Switzerland
	TUR.OEC	Turkey

$onembedded
$eolcom !

	( 	! China including Hong Kong
		CHN	!	China
		HKG	!	Hong Kong
	).CHN	

	(	! Other oil exporters 
		
		SAU		!	Saudi Arabia
		BHR		!	Bahrain
		KWT		!	Kuwait
		QAT		!	Qatar
		ARE		!	United Arab Emirates
		IRN		!	Iran, Islamic Republic of
		VEN		!	Venezuela
	).OPC


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

	).EUR,

	KHM.ROW		!	Cambodia
	LAO.ROW		!	Lao People's Democratic RepubROW
	BGD.ROW		!	Bangladesh
	XSA.ROW		!	Rest of South Asia
	KGZ.ROW		!	Kyrgyzstan
	XWF.ROW		!	Rest of Western Africa
	XCF.ROW		!	Rest of Central Africa
	XAC.ROW		!	Rest of South Central Africa
	KEN.ROW		!	Kenya
	ETH.ROW		!	Ethiopia
	MDG.ROW		!	Madagascar
	MWI.ROW		!	Malawi
	MOZ.ROW		!	Mozambique
	TZA.ROW		!	Tanzania
	UGA.ROW		!	Uganda
	ZMB.ROW		!	Zambia
	ZWE.ROW		!	Zimbabwe
	XEC.ROW		!	Rest of Eastern Africa


	MYS.ROW		!	Malaysia
	XOC.ROW		!	Rest of Oceania
	TWN.ROW		!	Taiwan
	XEA.ROW		!	Rest of East Asia
	PHL.ROW		!	Philippines
	SGP.ROW		!	Singapore
	THA.ROW		!	Thailand
	VNM.ROW		!	Vietnam
	XSE.ROW		!	Rest of Southeast Asia
	PAK.ROW		!	Pakistan
	LKA.ROW		!	Sri Lanka
	XNA.ROW		!	Rest of North America
	BOL.ROW		!	Bolivia
	COL.ROW		!	Colombia
	ECU.ROW		!	Ecuador
	PER.ROW		!	Peru
	XSM.ROW		!	Rest of South America
	ALB.ROW		!	Albania
	BLR.ROW		!	Belarus
	HRV.ROW		!	Croatia
	XEE.ROW		!	Rest of Eastern Europe
	KAZ.ROW		!	Kazakhstan
	XSU.ROW		!	Rest of Former Soviet Union
	ARM.ROW		!	Armenia
	AZE.ROW		!	Azerbaijan
	GEO.ROW		!	Georgia
	EGY.ROW		!	Egypt
	MAR.ROW		!	Morocco
	TUN.ROW		!	Tunisia
	XNF.ROW		!	Rest of North Africa
	NGA.ROW		!	Nigeria
	SEN.ROW		!	Senegal
	MUS.ROW		!	Mauritius
	BWA.ROW		!	Botswana
	XSC.ROW		!	Rest of South African Customs Union 

	OMN.ROW		!	Oman
	MNG.ROW		!	Mongolia
	NPL.ROW		!	Nepal
	HND.ROW		!	Honduras
	SLV.ROW		!	El Salvador
	XWS.ROW		!	Rest of Western Asia
	CMR.ROW		!	Cameroon
	CIV.ROW		!	Cote d'Ivoire
	GHA.ROW		!	Ghana
	NAM.ROW		!	Namibia

	XTW.ROW		!	Rest of the World 

	BRN.ROW		!	Brunei Darussalam
	DOM.ROW		!	Dominican Republic
	JAM.ROW		!	Jamaica
	PRI.ROW		!	Puerto Rico
	TTO.ROW		!	Trinidad and Tobago
	JOR.ROW		!	Jordan
	BEN.ROW		!	Benin
	BFA.ROW		!	Burkina Faso
	GIN.ROW		!	Guinea
	TGO.ROW		!	Togo
	RWA.ROW		!	Rwanda
	TJK.ROW		!	Tajikistan


	/;

*	We define mappings for regions in all GTAP versions.  
*	Remove those which are not in the current dataset.

set	notr(ur)	Labels which are not in r;
option notr<mapr;
notr(r) = no;
mapr(notr,rr) = no;

parameter	mapbug(r);
mapbug(r) = sum(mapr(r,rr),1) - 1;


*	See that each region in the source data has been mapped:

abort$(card(mapr)<>card(r))	"Error: card(mapr)<>card(r).", mapbug;
