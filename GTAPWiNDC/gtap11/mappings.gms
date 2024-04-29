$stitle		Single File Contains All Mappings

$eolcom !

$if "%1"=="msmr_regions" $goto msmr_regions	! MSMR regions

$if "%1"=="russia"	$goto russia		! Large countries plus Russia
$if "%1"=="g20"		$goto g20		! G20 regions (plus OEC, LIC and MIC)
$if "%1"=="ukrregions"	$goto ukrregions	! Regions in a model with Ukraine

$if "%1"=="nplusone"     $goto nplusone  	! 13 regions for WB BCA
$if "%1"=="wbregions_12" $goto wbregions_12	! 12 regions for WB BCA
$if "%1"=="wbregions_62" $goto wbregions_62	! 62 regions for WB BCA
$if "%1"=="wbsectors_14" $goto wbsectors_14	! 14 sector aggregation for WB BCA
$if "%1"=="wbsectors_12" $goto wbsectors_12	! 12 sector aggregation for WB BCA


$if "%1"=="windc_10"	$goto windc_10		! 10 sector aggregation compatible with WiNDC
$if "%1"=="windc_32"	$goto windc_32		! 32 sector aggregation compatible with WiNDC
$if "%1"=="windc_43"	$goto windc_43		! 43 sector aggregation compatible with WiNDC

$abort "Mapping is not defined: %1";

$label russia

set rr  Regions in the aggregation /
	RUS	Russia
	EUR	EU-27
	MEX	Mexico
	USA	United States of America
	CAN	Canada
	CHN	China 
	IND	India
	OEC	Other OECD countries
	OEX	Oil exporting countries
	ROW	Rest of world
	/;

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /

	RUS.RUS	Russia
	USA.USA	United States
	MEX.MEX	Mexico
	CAN.CAN	Canada
	IND.IND	India

	( 	! China including Hong Kong
		CHN	!	China
		HKG	!	Hong Kong
	).CHN	

	(	! EU-27
		DEU	!	Germany
		AUT	!	Austria
		BEL	!	Belgium
		BGR	!	Bulgaria
		CYP	!	Cyprus
		HRV	!	Croatia
		CZE	!	Czech Republic
		DNK	!	Denmark
		ESP	!	Spain
		EST	!	Estonia
		FIN	!	Finland
		FRA	!	France
		GRC	!	Greece
		HUN	!	Hungary
		IRL	!	Ireland
		ITA	!	Italy
		LTU	!	Lithuania
		LUX	!	Luxembourg
		LVA	!	Latvia
		MLT	!	Malta
		NLD	!	Netherlands
		POL	!	Poland
		PRT	!	Portugal
		ROU	!	Romania
		SVK	!	Slovakia
		SVN	!	Slovenia
		SWE	!	Sweden
	).EUR

	(	! RGT  - Remaining G20 countries
		BRA	!	Brazil
		IDN	!	Indonesia
		ARG	!	Argentina
		ZAF	!	South Africa
	).ROW	! RGT

	(	! OEC  - Other OECD countries
		GBR	!	United Kingdom
		JPN	!	Japan
		NOR	!	Norway 	
		CHE	!	Switzerland 	
		AUS	!	Australia 
		NZL	!	New Zealand
		KOR	!	Korea
		TUR	!	Turkey
		ISR	!	Israel
		CHL	!	Chile 	
		COL	!	Colombia 	
		CRI	!	Costa Rica 	
	).OEC

	(	! Oil exporting countires
		SAU	!	Saudi Arabia
		VEN	!	Venezuela
		KWT	!	Kuwait
		QAT	!	Qatar
		ARE	!	United Arab Emirates
		IRN	!	Iran- Islamic Republic of
		NGA	!	Nigeria
		DZA	!	Algeria
		COG	!	Congo
		IRQ	!	Iraq
		GAB	!	Gabon
		GNQ	!	Equitorial Guinea
		XNF	!	Libya (Rest of North Africa: Libya -- Western Sahara)

*	+8 associated countries
		SDN	!	Sudan			
		BHR	!	Bahrain			   
		OMN	!	Oman			   
		KAZ	!	Kazakhstan		   
		AZE	!	Azerbaijan		   
		MYS	!	Malaysia		   
		BRN	!	Brunei Darussalam	   
	).OEX
	( 	! WB Remaining low-income economies ($1,085 OR LESS)
			AFG	!	Afghanistan
			BFA	!	Burkina Faso
			CAF	!	Central African Republic
			TCD	!	Chad
			COD	!	Democratic Republic of the Congo
			ETH	!	Ethiopia
			GIN	!	Guinea
			MDG	!	Madagascar
			MWI	!	Malawi
			MLI	!	Mali
			MOZ	!	Mozambique
			NER	!	Niger
			RWA	!	Rwanda
			SYR	!	Syrian Arab Republic
			TGO	!	Togo
			UGA	!	Uganda
			ZMB	!	Zambia
			XWS	!	Rest of Western Asia (Yemen)
			XEC	!	Rest of Eastern Africa (Burundi, Eritrea, Somalia, South Sudan) % (Dijbouti, Mayotte, Seychelles)
			XWF	!	Rest of Western Africa (Gambia,Guinea-Bissau, Liberia, Sierra Leone) % (Cabo Verde, Mauritania,Saint Helena)
	).ROW	! LOI

	( 	! WB Remaining lower-middle income economies ($1,086 TO $4,255)
		      	BGD	!	Bangladesh
		      	BEN	!	Benin
		      	BOL	!	Bolivia
		      	KHM	!	Cambodia
		      	CMR	!	Cameroon
		      	COM	!	Comoros
		      	CIV	!	Côte d'Ivoire
		      	EGY	!	Egypt, Arab Rep.
		      	SLV	!	El Salvador
		      	GHA	!	Ghana
		      	HTI	!	Haiti
		      	HND	!	Honduras
		      	KEN	!	Kenya
		      	KGZ	!	Kyrgyz Republic
		      	LAO	!	Lao PDR
		      	LBN	!	Lebanon
		      	MNG	!	Mongolia
		      	MAR	!	Morocco
		      	NPL	!	Nepal
		      	PAK	!	Pakistan
		      	PHL	!	Philippines
		      	SEN	!	Senegal
		      	LKA	!	Sri Lanka
		      	TZA	!	Tanzania
		      	TJK	!	Tajikistan
		      	TUN	!	Tunisia
		      	UKR	!	Ukraine
		      	UZB	!	Uzbekistan
		      	VNM	!	Vietnam
		      	ZWE	!	Zimbabwe
		      	SWZ	!	Eswatini
		      	XSC	!	Lesotho (Rest of South African Customs Union)
		      	NIC	!	Nicaragua
			XAC	!	Rest of South and Central Africa (Angola, Sao Tome and Principe)
			XSA	!	Rest of South Asia (Bhutan) % (Maldives)
			XSE	!	Rest of Southeast Asia (Myanmar and Timor-Leste)
			XOC	!	Rest of Oceania
	).ROW	! LMI

	(	! WB Remaining upper-middle-income economies ($4,256 TO $13,205)
		ALB	!	Albania
		ARM	!	Armenia
		BLR	!	Belarus
		BWA	!	Botswana
		DOM	!	Dominican Republic  
		ECU	!	Ecuador
		GEO	!	Georgia
		JAM	!	Jamaica
		JOR	!	Jordan
		MUS	!	Mauritius
		NAM	!	Namibia
		PRY	!	Paraguay
		PER	!	Peru  
		SRB	!	Serbia
		THA	!	Thailand
		GTM	!	Guatemala
		XEE	!	Moldova (Rest of Eastern Europe)
		XER	!	Rest of Europe
		XCB	!	Rest of Caribbean
		XSM	!	Rest of South America
	).ROW,	! UMI,
	(	TWN	!	Taiwan
		XEA	!	Rest of East Asia
		SGP	!	Singapore
		XNA	!	Rest of North America
		URY	!	Uruguay
		PAN	!	Panama
		XCA	!	Rest of Central America
		PRI	!	Puerto Rico
		TTO	!	Trinidad and Tobago
		XEF	!	Rest of European Free Trade Association
		XSU	!	Rest of Former Soviet Union
		PSE	!	Occupied Palestineian Territory, 
		XTW	!	Rest of the World 

	).ROW	! HII
/;

option mapr:0:0:1;
abort$(card(mapr)<>card(r))	"Error: card(mapr)<>card(r).", mapr;
$exit


$label msmr_regions

set rr  Regions in the MSMR (ECCC) aggregation /
	CAN	Canada
	USA	United States
	MEX	Mexico
	AUS	Australia
	NZL	New Zealand
	JPN	Japan
	KOR	Korea
	GBR	United Kingdom
	EUR	European Union
	CHN	China and Hong Kong
	IND	India
	BRA	Brazil
	RUS	Russia
	ZAF	South Africa
	OPC	OPEC
	SAM	South America
	ROW	Rest of world /;

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /
	CAN.CAN	Canada
	USA.USA	United States
	MEX.MEX	Mexico
	AUS.AUS	Australia
	NZL.NZL	New Zealand
	JPN.JPN	Japan
	KOR.KOR	Korea
	GBR.GBR	United Kingdom
	IND.IND	India
	BRA.BRA	Brazil
	RUS.RUS	Russia
	ZAF.ZAF	South Africa
	( 	! China.China including Hong Kong
		CHN	!	China
		HKG	!	Hong Kong
	).CHN	

*	
        

	(       !       South America countries
		XNA     !Rest of North America
*                       - Bermuda
*                       - Greenland
*                       - Saint Pierre and Miquelon
		ARG     !Argentina
		BOL     !Bolivia, Plurinational Republic of
*               BRA     !       Brazil
		CHL     !Chile
		COL     !Colombia
*               ECU     !       Ecuador
		PRY     !Paraguay
		PER     !Peru
		URY     !Uruguay
*               VEN     !       Venezuela
		XSM     !Rest of South America
*                       - Falkland Islands (Malvinas)
*                       - French Guiana
*                       - Guyana
*                       - South Georgia and the South Sandwich Islands
*                       - Suriname
		CRI     !Costa Rica
		GTM     !Guatemala
		HND     !Honduras
		NIC     !Nicaragua
		PAN     !Panama
		SLV     !El Salvador
		XCA     !Rest of Central America
*                       - Belize
		XCB     !Caribbean
*                       - Anguilla
*                       - Antigua & Barbuda
*                       - Aruba
*                       - Bahamas
*                       - Barbados
*                       - Cayman Islands
*                       - Cuba
*                       - Dominica
		DOM     !Dominican Republic
*                       - Grenada
		HTI     !Haiti
		JAM     !Jamaica
*                       - Montserrat
*                       - Netherlands Antilles
		PRI     !Puerto Rico
*                       - Saint Kitts and Nevis
*                       - Saint Lucia
*                       - Saint Vincent and the Grenadines
		TTO     !Trinidad and Tobago
*                       - Turks and Caicos Islands
*                       - Virgin Islands British
*                       - Virgin Islands U.S.
                ).SAM   South American Countries except Brazil Ecuador and Venezuela

		(       ! European Union
		FRA     !France
		DEU     !Germany
		ITA     !Italy
		AUT     !Austria
		BEL     !Belgium
		DNK     !Denmark
		FIN     !Finland
		GRC     !Greece
		IRL     !Ireland
		LUX     !Luxembourg
		NLD     !Netherlands
		PRT     !Portugal
		ESP     !Spain
		SWE     !Sweden
		CZE     !Czech Republic
		HUN     !Hungary
		MLT     !Malta
		POL     !Poland
		ROU     !Romania
		SVK     !Slovakia
		SVN     !Slovenia
		EST     !Estonia
		LVA     !Latvia
		LTU     !Lithuania
		BGR     !Bulgaria
		CYP     !Cyprus
		HRV     !Croatia
*                       - Iceland
*                       - Liechtenstein
        ).EUR   European Union,

( ! Rest of world
		XOC     !Rest of Oceania
*                       - American Samoa
*                       - Cook Islands
*                       - Fiji
*                       - French Polynesia
*                       - Guam
*                       - Kiribati
*                       - Marshall Islands
*                       - Micronesia, Federated States of
*                       - Nauru
*                       - New Caledonia
*                       - Norfolk Island
*                       - Northern Mariana Islands
*                       - Niue
*                       - Palau
*                       - Papua New Guinea
*                       - Samoa
*                       - Solomon Islands
*                       - Tokelau
*                       - Tonga
*                       - Tuvalu
*                       - Vanuatu
*                       - Island of Wallis and Futuna
		XEA     !Rest of East Asia
		MYS     !Malaysia
		IDN     !Indonesia
		TWN     !Taiwan
		MNG     !Mongolia
*                       - Macau
*                       - Korea, Democratic Republic of
		KHM     !Cambodia
		LAO     !Lao People's Democratic Republic
		PHL     !Philippines
		SGP     !Singapore
		THA     !Thailand
		VNM     !Vietnam
		XSE     !Rest of Southeast Asia
		BRN     !Brunei Darassalam
*                       - Timor Leste
*                       - Myanmar
		BGD     !Bangladesh
		PAK     !Pakistan
		LKA     !Sri Lanka
		NPL     !Nepal
		XSA     !Rest of South Asia
		AFG     !Afghanistan
*                       - Bhutan
*                       - Maldives
*EFTA
		CHE     !Switzerland
		NOR     !Norway
		XEF     !Rest of EFTA
		ALB     !Albania
		BLR     !Belarus
*               HRV     !       Croatia
		UKR     !Ukraine
		XEE     !Rest of Eastern Europe
*                       - Moldova, Republic of
		XER     !Rest of Europe
*                       - Andorra
*                       - Bosnia and Herzegovina
*                       - Faroe Islands
*                       - Gibraltar
*                       - Macedonia, the former Yugoslav Republic of
*                       - Monaco
*                       - San Marino
*                       - Serbia and Montenegro
		SRB     !Serbia
		KAZ     !Kazakhstan
		KGZ     !Kyrgyzstan
		TJK     !Tajikistan
		XSU     !Rest of Former Soviet Union
*                       - Turkmenistan
		UZB     !Uzbekistan
		ARM     !Armenia
		AZE     !Azerbaijan
		GEO     !Georgia
*               IRN     !       Iran, Islamic Republic of
		EGY     !Egypt
		MAR     !Morocco
		TUN     !Tunisia
*               XNF     !       Rest of North Africa
*                       - Algeria
*                       - Libyan Arab Jamahiriya
*               NGA     !       Nigeria
		SEN     !Senegal
		XWF     !Rest of Western Africa
		BEN     !Benin
		BFA     !Burkina Faso
*                       - Cape Verde
*                       -
*                       - Gambia
*                       -
		GIN     !Guinea
*                       - Guinea-Bissau
*                       - Liberia
		MLI     !Mali
*                       - Mauritania
		NER     !Niger
*                       - Saint Helena
*                       - Sierra Leone
		TGO     !Togo
		CIV     !Cote d'Ivoire
		GHA     !Ghana
		CMR     !Cameroon

*                XCF     !       Rest of Central Africa
*                       -
*                       - Central African Republic
		TCD     !Chad
*                COG     !Congo (Already in OPEC)
		GNQ     !Equatorial Guinea
		GAB     !Gabon
*                       - Sao Tome and Principe
*               XAC     !       Rest of South Central Africa
*                       - Angola
*                       - Congo, Democratic Republic of the (Already in OPEC)
		ETH     !Ethiopia
		MDG     !Madagascar
		MWI     !Malawi
		MUS     !Mauritius
		MOZ     !Mozambique
		TZA     !Tanzania
		UGA     !Uganda
		ZMB     !Zambia
		ZWE     !Zimbabwe
		KEN     !Kenya
		SWZ     !Eswatini
		XEC     !Rest of Eastern Africa
*                       - Burundi
		COM     !Comoros
*                       - Djibouti
*                       - Eritrea
*                       -
*                       - Mayotte
*                       - Reunion
		RWA     !Rwanda
*                       - Seychelles
*                       - Somalia
		SDN     !Sudan
		NAM     !Namibia
		BWA     !Botswana
		XSC     !Rest of South African Customs Union
		XTW     !Rest of the World
*OMN     !Oman (Already in OPEC)
*                ISR     !Isreal (Already in OPEC)
*                TUR     !Turkey (Already in OPEC)
*                BHR     ! Bahrain (Already in OPEC)
        ).ROW     Rest of the World

(      !OPEC contries

$ontext
13 OPEC Countries gathered from https://www.opec.org/opec_web/en/about_us/25.htm

	Algeria, Angola, Congo, Equatorial Guinea, Gabon, Iran, Iraq, Kuwait,
	Libya, Nigeria, Saudi Arabia, United Arab Emirates, Venezuela

$offtext
BHR     ! Bahrain 
IRN     !Iran
ISR     !Isreal
KWT     !Kuwait
OMN     !Oman
QAT     !Qatar
SAU     !Saudi Arabia
TUR     !Turkey
ARE     !United Arab Emirates
NGA     !Nigeria
VEN     !Venezuela
ECU     !Ecuador
XAC     !Rest of South Central Africa
*                       - Angola
CAF     !Central African Republic
COD     !Congo, Democratic Republic of the
COG     !Congo 
XNF     !Rest of North Africa
DZA     !Algeria 
*                       - Libyan Arab Jamahiriya
XWS     !Rest of Western Asia
IRQ     !Iraq
JOR     !Jordan
LBN     !Lebanon
PSE     !Palestinian Territory, Occupied
SYR     !Syrian Arab Republic
*                       - Yemen
        ).opc  13 countries comprising OPEC + othr

/;
option mapr:0:0:1;
abort$(card(mapr)<>card(r))	"Error: card(mapi)<>card(i).", mapr;

$exit



$label g20
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

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /
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
NGA		!	Nigeria
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
SRB	!	Serbia (xer) 
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

	(
KHM	!	Cambodia
LAO	!	Lao People's Democratic Republic
BGD	!	Bangladesh
XSA	!	Rest of South Asia
KGZ	!	Kyrgyzstan
XWF	!	Rest of Western Africa
XAC	!	Rest of South Central Africa
KEN	!	Kenya
ETH	!	Ethiopia
MDG	!	Madagascar
MWI	!	Malawi
MOZ	!	Mozambique
TZA	!	Tanzania
UGA	!	Uganda
ZMB	!	Zambia
ZWE	!	Zimbabwe
XEC	!	Rest of Eastern Africa
afg	!	Afghanistan (xsa)
BEN	!	Benin
BFA	!	Burkina Faso
GIN	!	Guinea
TGO	!	Togo
RWA	!	Rwanda
ner	!	Niger (xwf)
caf	!	Central African Republic (xcf)
tcd	!	Chad (xcf) 
cog	!	Congo (xcf)
cod	!	Democratic Republic of the Congo (xac), 
gnq	!	Equatorial Guinea (xcf)
gab	!	Gabon (xcf)
com	!	Comoros (xec)
sdn	!	Sudan (xec)
swz	!	Eswatini - Swaziland (xsc)
mli	!	Mali (xwf)
hti	!	Haiti (xcb)
	).LIC	

	(
MYS	!	Malaysia
XOC	!	Rest of Oceania
TWN	!	Taiwan
XEA	!	Rest of East Asia
PHL	!	Philippines
SGP	!	Singapore
THA	!	Thailand
VNM	!	Vietnam
XSE	!	Rest of Southeast Asia
PAK	!	Pakistan
LKA	!	Sri Lanka
XNA	!	Rest of North America
BOL	!	Bolivia
CHL	!	Chile
COL	!	Colombia
ECU	!	Ecuador
PRY	!	Paraguay
PER	!	Peru
URY	!	Uruguay
XSM	!	Rest of South America
CRI	!	Costa Rica
GTM	!	Guatemala
NIC	!	Nicaragua
PAN	!	Panama
XCA	!	Rest of Central America
XCB	!	Caribbean
ALB	!	Albania
BLR	!	Belarus
HRV	!	Croatia
UKR	!	Ukraine
XEE	!	Rest of Eastern Europe
KAZ	!	Kazakhstan
XSU	!	Rest of Former Soviet Union
ARM	!	Armenia
AZE	!	Azerbaijan
GEO	!	Georgia
EGY	!	Egypt
MAR	!	Morocco
TUN	!	Tunisia
XNF	!	Rest of North Africa
SEN	!	Senegal
MUS	!	Mauritius
BWA	!	Botswana
XSC	!	Rest of South African Customs Union 
OMN	!	Oman
ISR	!	Israel
MNG	!	Mongolia
NPL	!	Nepal
HND	!	Honduras
SLV	!	El Salvador
XWS	!	Rest of Western Asia
CMR	!	Cameroon
CIV	!	Cote d'Ivoire
GHA	!	Ghana
NAM	!	Namibia
XTW	!	Rest of the World 
BRN	!	Brunei Darussalam
DOM	!	Dominican Republic
JAM	!	Jamaica
PRI	!	Puerto Rico
TTO	!	Trinidad and Tobago
JOR	!	Jordan
uzb	!	Uzbekistan (xsu)
tjk	!	Tajikistan (xsu)
irq	!	Iraq (xws)
lbn	!	Lebanon (xws)
pse	!	State of Palestine (xws)
syr	!	Syrian Arab Republic (xws)
dza	!	Algeria (xnf)
	).MIC

/;
option mapr:0:0:1;
abort$(card(mapr)<>card(r))	"Error: card(mapi)<>card(i).", mapr;

$exit


$label ukrregions

set rr  Regions in the aggregation /
	UKR	Ukraine
	RUS	Russia
	EGY	Egypt
	IND	India
	CHN	China and Hong Kong
	TUR	Turkey
	BGD	Bangladesh
	TUN	Tunisia
	EUR	Europe
	LIC	Other low income countries
	ROW	Rest of world /;

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /
	UKR.UKR		Ukraine
	RUS.RUS		Russia
	EGY.EGY		Egypt
	IND.IND		India
	TUR.TUR		Turkey
	BGD.BGD		Bangladesh
	TUN.TUN		Tunisia

	(	! Other G20
ARG    	! Argentina
BRA    	! Brazil
CAN    	! Canada
JPN    	! Japan
MEX    	! Mexico
SAU    	! Saudi Arabia
IDN    	! Indonesia
ZAF    	! South Africa
KOR    	! Korea
USA    	! United States
	).ROW

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
NGA		!	Nigeria
	).ROW

	(	 ! Australia and New Zealand
AUS	!	Australia
NZL	!	New Zealand
	).ROW,

	(	! Europe
GBR	!	United Kingdom

FRA	!	France
DEU	!	Germany
ITA	!	Italy

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
SRB	!	Serbia (xer) 

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

	(
KHM	!	Cambodia
LAO	!	Lao People's Democratic Republic
XSA	!	Rest of South Asia
KGZ	!	Kyrgyzstan
XWF	!	Rest of Western Africa
XAC	!	Rest of South Central Africa
KEN	!	Kenya
ETH	!	Ethiopia
MDG	!	Madagascar
MWI	!	Malawi
MOZ	!	Mozambique
TZA	!	Tanzania
UGA	!	Uganda
ZMB	!	Zambia
ZWE	!	Zimbabwe
XEC	!	Rest of Eastern Africa
afg	!	Afghanistan (xsa)
BEN	!	Benin
BFA	!	Burkina Faso
GIN	!	Guinea
TGO	!	Togo
RWA	!	Rwanda
ner	!	Niger (xwf)
caf	!	Central African Republic (xcf)
tcd	!	Chad (xcf) 
cog	!	Congo (xcf)
cod	!	Democratic Republic of the Congo (xac), 
gnq	!	Equatorial Guinea (xcf)
gab	!	Gabon (xcf)
com	!	Comoros (xec)
sdn	!	Sudan (xec)
swz	!	Eswatini - Swaziland (xsc)
mli	!	Mali (xwf)
hti	!	Haiti (xcb)
	).LIC	

	(
MYS	!	Malaysia
XOC	!	Rest of Oceania
TWN	!	Taiwan
XEA	!	Rest of East Asia
PHL	!	Philippines
SGP	!	Singapore
THA	!	Thailand
VNM	!	Vietnam
XSE	!	Rest of Southeast Asia
PAK	!	Pakistan
LKA	!	Sri Lanka
XNA	!	Rest of North America
BOL	!	Bolivia
CHL	!	Chile
COL	!	Colombia
ECU	!	Ecuador
PRY	!	Paraguay
PER	!	Peru
URY	!	Uruguay
XSM	!	Rest of South America
CRI	!	Costa Rica
GTM	!	Guatemala
NIC	!	Nicaragua
PAN	!	Panama
XCA	!	Rest of Central America
XCB	!	Caribbean
ALB	!	Albania
BLR	!	Belarus
HRV	!	Croatia

XEE	!	Rest of Eastern Europe
KAZ	!	Kazakhstan
XSU	!	Rest of Former Soviet Union
ARM	!	Armenia
AZE	!	Azerbaijan
GEO	!	Georgia

MAR	!	Morocco
XNF	!	Rest of North Africa
SEN	!	Senegal
MUS	!	Mauritius
BWA	!	Botswana
XSC	!	Rest of South African Customs Union 
OMN	!	Oman
ISR	!	Israel
MNG	!	Mongolia
NPL	!	Nepal
HND	!	Honduras
SLV	!	El Salvador
XWS	!	Rest of Western Asia
CMR	!	Cameroon
CIV	!	Cote d'Ivoire
GHA	!	Ghana
NAM	!	Namibia
XTW	!	Rest of the World 
BRN	!	Brunei Darussalam
DOM	!	Dominican Republic
JAM	!	Jamaica
PRI	!	Puerto Rico
TTO	!	Trinidad and Tobago
JOR	!	Jordan
uzb	!	Uzbekistan (xsu)
tjk	!	Tajikistan (xsu)
irq	!	Iraq (xws)
lbn	!	Lebanon (xws)
pse	!	State of Palestine (xws)
syr	!	Syrian Arab Republic (xws)
dza	!	Algeria (xnf)
	).ROW

/;
$exit

$label wbregions_62

set rr  Regions in the aggregation /
	EUR	EU-27
	USA	United States of America
	RG7	Remaining G7 countries
	CHN	China 
	IND	India
	RGT	Remaining G20 countries
	OEC	Other OECD countries
	OEX	Oil exporting countries

*	Explicit low-income economies
	AFG	Afghanistan
	BFA	Burkina Faso
	CAF	Central African Republic
	TCD	Chad
	COD	Democratic Republic of the Congo
	ETH	Ethiopia
	GIN	Guinea
	MDG	Madagascar
	MWI	Malawi
	MLI	Mali
	MOZ	Mozambique
	NER	Niger
	RWA	Rwanda
	SYR	Syrian Arab Republic
	TGO	Togo
	UGA	Uganda
	ZMB	Zambia

*	Explicit lower-middle income economies
	BGD	Bangladesh
	BEN	Benin
	BOL	Bolivia
	KHM	Cambodia
	CMR	Cameroon
	COM	Comoros
	CIV	"Côte d'Ivoire"
	EGY	"Egypt, Arab Rep."
	SLV	El Salvador
	GHA	Ghana
	HTI	Haiti
	HND	Honduras
	KEN	Kenya
	KGZ	Kyrgyz Republic
	LAO	Lao PDR
	LBN	Lebanon
	MNG	Mongolia
	MAR	Morocco
	NPL	Nepal
	PAK	Pakistan
	PHL	Philippines
	SEN	Senegal
	LKA	Sri Lanka
	TZA	Tanzania
	TJK	Tajikistan
	TUN	Tunisia
	UKR	Ukraine
	UZB	Uzbekistan
	VNM	Vietnam
	ZWE	Zimbabwe
	SWZ	Eswatini
	XSC	Lesotho (Rest of South African Customs Union)
	NIC	Nicaragua

	LOI	'Remaining WB low-income economies ($1,085 OR LESS)' 
	LMI	'Remaining WB lower-middle income economies ($1,086 TO $4,255)'

	UMI	'Remaining WB upper-middle-income economies ($4,256 TO $13,205)'
	HII	'Remaining WB high-income economies ($13,205 OR MORE)'
/;

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /
	USA.USA	United States
	IND.IND	India

	( 	! China including Hong Kong
CHN	!	China
HKG	!	Hong Kong
	).CHN	

	(	! EU-27
DEU	!	Germany
AUT	!	Austria
BEL	!	Belgium
BGR	!	Bulgaria
CYP	!	Cyprus
HRV	!	Croatia
CZE	!	Czech Republic
DNK	!	Denmark
ESP	!	Spain
EST	!	Estonia
FIN	!	Finland
FRA	!	France
GRC	!	Greece
HUN	!	Hungary
IRL	!	Ireland
ITA	!	Italy
LTU	!	Lithuania
LUX	!	Luxembourg
LVA	!	Latvia
MLT	!	Malta
NLD	!	Netherlands
POL	!	Poland
PRT	!	Portugal
ROU	!	Romania
SVK	!	Slovakia
SVN	!	Slovenia
SWE	!	Sweden
	).EUR


	(	! RG7  - Remaining G7 countries
GBR	!	United Kingdom
JPN	!	Japan
CAN	!	Canada
NOR	!	Norway 	
CHE	!	Switzerland 	
	).RG7

	(	! RGT  - Remaining G20 countries
BRA	!	Brazil
IDN	!	Indonesia
ARG	!	Argentina
ZAF	!	South Africa
	).RGT

	(	! OEC  - Other OECD countries
AUS	!	Australia 
NZL	!	New Zealand
KOR	!	Korea
TUR	!	Turkey
ISR	!	Israel
CHL	!	Chile 	
COL	!	Colombia 	
CRI	!	Costa Rica 	
	).OEC

	(	! Oil exporting countries
SAU	!	Saudi Arabia
VEN	!	Venezuela
KWT	!	Kuwait
QAT	!	Qatar
ARE	!	United Arab Emirates
IRN	!	Iran- Islamic Republic of
NGA	!	Nigeria
DZA	!	Algeria
COG	!	Congo
IRQ	!	Iraq
GAB	!	Gabon
GNQ	!	Equitorial Guinea
XNF	!	Libya (Rest of North Africa: Libya -- Western Sahara)
*	+10 associated countries
RUS	!	Russia
MEX	!	Mexico
SDN	!	Sudan			
BHR	!	Bahrain			   
OMN	!	Oman			   
KAZ	!	Kazakhstan		   
AZE	!	Azerbaijan		   
MYS	!	Malaysia		   
BRN	!	Brunei Darussalam	   
	).OEX

*	Explicit low-income economies
	AFG.AFG	Afghanistan
	BFA.BFA	Burkina Faso
	CAF.CAF	Central African Republic
	TCD.TCD	Chad
	COD.COD	Democratic Republic of the Congo
	ETH.ETH	Ethiopia
	GIN.GIN	Guinea
	MDG.MDG	Madagascar
	MWI.MWI	Malawi
	MLI.MLI	Mali
	MOZ.MOZ	Mozambique
	NER.NER	Niger
	RWA.RWA	Rwanda
	SYR.SYR	Syrian Arab Republic
	TGO.TGO	Togo
	UGA.UGA	Uganda
	ZMB.ZMB	Zambia

	( 	! WB Remaining low-income economies ($1,085 OR LESS)
XWS	!	Rest of Western Asia (Yemen)
XEC	!	Rest of Eastern Africa (Burundi, Eritrea, Somalia, South Sudan) % (Dijbouti, Mayotte, Seychelles)
XWF	!	Rest of Western Africa (Gambia,Guinea-Bissau, Liberia, Sierra Leone) % (Cabo Verde, Mauritania,Saint Helena)
	).LOI

*	Explicit lower-middle income economies
	BGD.BGD	Bangladesh
	BEN.BEN	Benin
	BOL.BOL	Bolivia
	KHM.KHM	Cambodia
	CMR.CMR	Cameroon
	COM.COM	Comoros
	CIV.CIV	"Côte d'Ivoire"
	EGY.EGY	"Egypt, Arab Rep."
	SLV.SLV	El Salvador
	GHA.GHA	Ghana
	HTI.HTI	Haiti
	HND.HND	Honduras
	KEN.KEN	Kenya
	KGZ.KGZ	Kyrgyz Republic
	LAO.LAO	Lao PDR
	LBN.LBN	Lebanon
	MNG.MNG	Mongolia
	MAR.MAR	Morocco
	NPL.NPL	Nepal
	PAK.PAK	Pakistan
	PHL.PHL	Philippines
	SEN.SEN	Senegal
	LKA.LKA	Sri Lanka
	TZA.TZA	Tanzania
	TJK.TJK	Tajikistan
	TUN.TUN	Tunisia
	UKR.UKR	Ukraine
	UZB.UZB	Uzbekistan
	VNM.VNM	Vietnam
	ZWE.ZWE	Zimbabwe
	SWZ.SWZ	Eswatini
	XSC.XSC	Lesotho (Rest of South African Customs Union)
	NIC.NIC	Nicaragua

	( 	! WB Remaining lower-middle income economies ($1,086 TO $4,255)
XAC	!	Rest of South and Central Africa (Angola, Sao Tome and Principe)
XSA	!	Rest of South Asia (Bhutan) % (Maldives)
XSE	!	Rest of Southeast Asia (Myanmar and Timor-Leste)
XOC	!	Rest of Oceania
	).LMI

	(	! WB Remaining upper-middle-income economies ($4,256 TO $13,205)
ALB	!	Albania
ARM	!	Armenia
BLR	!	Belarus
BWA	!	Botswana
DOM	!	Dominican Republic  
ECU	!	Ecuador
GEO	!	Georgia
JAM	!	Jamaica
JOR	!	Jordan
MUS	!	Mauritius
NAM	!	Namibia
PRY	!	Paraguay
PER	!	Peru  
SRB	!	Serbia
THA	!	Thailand
GTM	!	Guatemala
XEE	!	Moldova (Rest of Eastern Europe)
XER	!	Rest of Europe
XCB	!	Rest of Caribbean
XSM	!	Rest of South America
	).UMI,
	(	TWN	!	Taiwan
XEA	!	Rest of East Asia
SGP	!	Singapore
XNA	!	Rest of North America
URY	!	Uruguay
PAN	!	Panama
XCA	!	Rest of Central America
PRI	!	Puerto Rico
TTO	!	Trinidad and Tobago
XEF	!	Rest of European Free Trade Association
XSU	!	Rest of Former Soviet Union
PSE	!	Occupied Palestineian Territory, 
XTW	!	Rest of the World 

	).HII

/;


option mapr:0:0:1;
*.abort$(card(mapr)<>card(r))	"Error: card(mapr)<>card(r).", mapr;
$exit

*	WBREGIONS_12 permits distinguishing a single developing country
*	through the np1 environment variable.

$label wbregions_12

set rr  Regions in the aggregation /
	EUR	EU-27
	USA	United States of America
	RG7	Remaining G7 countries
	CHN	China 
	IND	India
	RGT	Remaining G20 countries
	OEC	Other OECD countries
	OEX	Oil exporting countries
	LOI	'Remaining WB low-income economies ($1,085 OR LESS)' 
	LMI	'Remaining WB lower-middle income economies ($1,086 TO $4,255)'
	UMI	'Remaining WB upper-middle-income economies ($4,256 TO $13,205)'
	HII	'Remaining WB high-income economies ($13,205 OR MORE)'

$if set np1  %np1%	

	/;

$if "%2"=="loadset" $exit

SET mapr(r,rr) Mapping of GTAP Regions (from-to) /
$if set np1	%np1%.%np1%

	USA.USA	United States
	IND.IND	India

	( 	! China including Hong Kong
CHN	!	China
HKG	!	Hong Kong
	).CHN	

	(	! EU-27
DEU	!	Germany
AUT	!	Austria
BEL	!	Belgium
BGR	!	Bulgaria
CYP	!	Cyprus
HRV	!	Croatia
CZE	!	Czech Republic
DNK	!	Denmark
ESP	!	Spain
EST	!	Estonia
FIN	!	Finland
FRA	!	France
GRC	!	Greece
HUN	!	Hungary
IRL	!	Ireland
ITA	!	Italy
LTU	!	Lithuania
LUX	!	Luxembourg
LVA	!	Latvia
MLT	!	Malta
NLD	!	Netherlands
POL	!	Poland
PRT	!	Portugal
ROU	!	Romania
SVK	!	Slovakia
SVN	!	Slovenia
SWE	!	Sweden
	).EUR


	(	! RG7  - Remaining G7 countries
GBR	!	United Kingdom
JPN	!	Japan
CAN	!	Canada
NOR	!	Norway 	
CHE	!	Switzerland 	
	).RG7

	(	! RGT  - Remaining G20 countries
BRA	!	Brazil
IDN	!	Indonesia
ARG	!	Argentina
ZAF	!	South Africa
	).RGT

	(	! OEC  - Other OECD countries
AUS	!	Australia 
NZL	!	New Zealand
KOR	!	Korea
TUR	!	Turkey
ISR	!	Israel
CHL	!	Chile 	
COL	!	Colombia 	
CRI	!	Costa Rica 	
	).OEC

	(	! Oil exporting countires
SAU	!	Saudi Arabia
VEN	!	Venezuela
KWT	!	Kuwait
QAT	!	Qatar
ARE	!	United Arab Emirates
IRN	!	Iran- Islamic Republic of
NGA	!	Nigeria
DZA	!	Algeria
COG	!	Congo
IRQ	!	Iraq
GAB	!	Gabon
GNQ	!	Equitorial Guinea
XNF	!	Libya (Rest of North Africa: Libya -- Western Sahara)
*	+10 associated countries
RUS	!	Russia
MEX	!	Mexico
SDN	!	Sudan			
BHR	!	Bahrain			   
OMN	!	Oman			   
KAZ	!	Kazakhstan		   
AZE	!	Azerbaijan		   
MYS	!	Malaysia		   
BRN	!	Brunei Darussalam	   
	).OEX
	( 	! WB Remaining low-income economies ($1,085 OR LESS)
$if not "%np1%"=="AFG"	AFG	!	Afghanistan
$if not "%np1%"=="BFA"	BFA	!	Burkina Faso
$if not "%np1%"=="CAF"	CAF	!	Central African Republic
$if not "%np1%"=="TCD"	TCD	!	Chad
$if not "%np1%"=="COD"	COD	!	Democratic Republic of the Congo
$if not "%np1%"=="ETH"	ETH	!	Ethiopia
$if not "%np1%"=="GIN"	GIN	!	Guinea
$if not "%np1%"=="MDG"	MDG	!	Madagascar
$if not "%np1%"=="MWI"	MWI	!	Malawi
$if not "%np1%"=="MLI"	MLI	!	Mali
$if not "%np1%"=="MOZ"	MOZ	!	Mozambique
$if not "%np1%"=="NER"	NER	!	Niger
$if not "%np1%"=="RWA"	RWA	!	Rwanda
$if not "%np1%"=="SYR"	SYR	!	Syrian Arab Republic
$if not "%np1%"=="TGO"	TGO	!	Togo
$if not "%np1%"=="UGA"	UGA	!	Uganda
$if not "%np1%"=="ZMB"	ZMB	!	Zambia
XWS	!	Rest of Western Asia (Yemen)
XEC	!	Rest of Eastern Africa (Burundi, Eritrea, Somalia, South Sudan) % (Dijbouti, Mayotte, Seychelles)
XWF	!	Rest of Western Africa (Gambia,Guinea-Bissau, Liberia, Sierra Leone) % (Cabo Verde, Mauritania,Saint Helena)
	).LOI

	( 	! WB Remaining lower-middle income economies ($1,086 TO $4,255)
$if not "%np1%"=="BGD"	BGD	!	Bangladesh
$if not "%np1%"=="BEN"	BEN	!	Benin
$if not "%np1%"=="BOL"	BOL	!	Bolivia
$if not "%np1%"=="KHM"	KHM	!	Cambodia
$if not "%np1%"=="CMR"	CMR	!	Cameroon
$if not "%np1%"=="COM"	COM	!	Comoros
$if not "%np1%"=="CIV"	CIV	!	Côte d'Ivoire
$if not "%np1%"=="EGY"	EGY	!	Egypt, Arab Rep.
$if not "%np1%"=="SLV"	SLV	!	El Salvador
$if not "%np1%"=="GHA"	GHA	!	Ghana
$if not "%np1%"=="HTI"	HTI	!	Haiti
$if not "%np1%"=="HND"	HND	!	Honduras
$if not "%np1%"=="KEN"	KEN	!	Kenya
$if not "%np1%"=="KGZ"	KGZ	!	Kyrgyz Republic
$if not "%np1%"=="LAO"	LAO	!	Lao PDR
$if not "%np1%"=="LBN"	LBN	!	Lebanon
$if not "%np1%"=="MNG"	MNG	!	Mongolia
$if not "%np1%"=="MAR"	MAR	!	Morocco
$if not "%np1%"=="NPL"	NPL	!	Nepal
$if not "%np1%"=="PAK"	PAK	!	Pakistan
$if not "%np1%"=="PHL"	PHL	!	Philippines
$if not "%np1%"=="SEN"	SEN	!	Senegal
$if not "%np1%"=="LKA"	LKA	!	Sri Lanka
$if not "%np1%"=="TZA"	TZA	!	Tanzania
$if not "%np1%"=="TJK"	TJK	!	Tajikistan
$if not "%np1%"=="TUN"	TUN	!	Tunisia
$if not "%np1%"=="UKR"	UKR	!	Ukraine
$if not "%np1%"=="UZB"	UZB	!	Uzbekistan
$if not "%np1%"=="VNM"	VNM	!	Vietnam
$if not "%np1%"=="ZWE"	ZWE	!	Zimbabwe
$if not "%np1%"=="SWZ"	SWZ	!	Eswatini
$if not "%np1%"=="XSC"	XSC	!	Lesotho (Rest of South African Customs Union)
$if not "%np1%"=="NIC"	NIC	!	Nicaragua
XAC	!	Rest of South and Central Africa (Angola, Sao Tome and Principe)
XSA	!	Rest of South Asia (Bhutan) % (Maldives)
XSE	!	Rest of Southeast Asia (Myanmar and Timor-Leste)
XOC	!	Rest of Oceania
	).LMI
	(	! WB Remaining upper-middle-income economies ($4,256 TO $13,205)
ALB	!	Albania
ARM	!	Armenia
BLR	!	Belarus
BWA	!	Botswana
DOM	!	Dominican Republic  
ECU	!	Ecuador
GEO	!	Georgia
JAM	!	Jamaica
JOR	!	Jordan
MUS	!	Mauritius
NAM	!	Namibia
PRY	!	Paraguay
PER	!	Peru  
SRB	!	Serbia
THA	!	Thailand
GTM	!	Guatemala
XEE	!	Moldova (Rest of Eastern Europe)
XER	!	Rest of Europe
XCB	!	Rest of Caribbean
XSM	!	Rest of South America
	).UMI,
	(	TWN	!	Taiwan
XEA	!	Rest of East Asia
SGP	!	Singapore
XNA	!	Rest of North America
URY	!	Uruguay
PAN	!	Panama
XCA	!	Rest of Central America
PRI	!	Puerto Rico
TTO	!	Trinidad and Tobago
XEF	!	Rest of European Free Trade Association
XSU	!	Rest of Former Soviet Union
PSE	!	Occupied Palestineian Territory, 
XTW	!	Rest of the World 

	).HII
/;

option mapr:0:0:1;
abort$(card(mapr)<>card(r))	"Error: card(mapr)<>card(r).", mapr;
$exit


$label windc_10

set ii	10 sector aggregation compatible with WiNDC /

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

$if "%2"=="loadset" $exit

set	mapi(i,ii)	Sectoral mapping /


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
OXT		! "Other Extraction (formerly omn Minerals nec)",
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

option mapi:0:0:1;
abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).", mapi;

$exit

$label windc_32 

set ii	Sectors in the aggregation /

*	Aggregated sectors:

	agr	"Farms and farm products (111CA)"
	fof	"Forestry and fishing",
	fbp	"Food and beverage and tobacco products (311FT)"
	alt	"Apparel and leather and allied products (315AL)"
	pmt	"Primary metals (331)"
	ogs	"Crude oil and natural gas"
	uti	"Utilities (electricity-gas-water)"
	oxt	"Coal, minining and supporting activities"
	ros	"Recreational and other services",
	dwe	"Dwellings and real estate activities"

*	Individual sectors:

	TEX	"Textiles",
	LUM	"Lumber and wood products",
	NMM	"Mineral products nec",
	FMP	"Metal products",
	MVH	"Motor vehicles and parts",
	OTN	"Transport equipment nec",
	OME	"Machinery and equipment nec",
	CNS	"Construction",
	WTP	"Water transport",
	ATP	"Air transport",
	OIL	"Petroleum, coal products",
	PPP	"Paper products, publishing",
	CRP	"Chemical, rubber, plastic products",
	EEQ	"Electronic equipment",
	OMF	"Manufactures nec",
	TRD	"Trade",
	OTP	"Transport nec",
	CMN	"Communication",
	ISR	"Insurance"
	OFI	"Financial services nec",
	OBS	"Business services nec",
	OSG	"Public Administration, Defense, Education, Health"	/;

$if "%2"=="loadset" $exit

set	mapi(i,ii)	Sectoral mapping /

	(	! "Farms (111CA)"
PDR		! "Paddy rice",
Wht		! "Wheat",
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
	).agr

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
	).ogs

	(	! "Utilities"
ELE		! "Electricity",
GDT		! "Gas manufacture, distribution",
WTR		! "Water",
	).uti
	
	(	! "Mining"
COL		! "Coal",
OXT		! "Other mining extraction",
	).oxt
	
	(	! "Recreational and other services"
AFS		! "Accommodation, Food and service activities",
ROS		! "Recreational and other services",
	).ros
	
	(	! "Dwellings and real estate activities"
DWE		! "Dwellings",
RSA		! "Real estate activities",
	).dwe
	
*	The rest are one-to-one:

	TEX.TEX	! "Textiles",
	LUM.LUM	! "Wood products",
	NMM.NMM	! "Mineral products nec",
	FMP.FMP	! "Metal products",
	MVH.MVH	! "Motor vehicles and parts",
	OTN.OTN	! "Transport equipment nec",
	OME.OME	! "Machinery and equipment nec",
	CNS.CNS	! "Construction",
	WTP.WTP	! "Water transport",
	ATP.ATP	! "Air transport",

	INS.ISR		        ! "Insurance",
	OIL.OIL			! "Petroleum, coal products",
	PPP.PPP			! "Paper products, publishing",
	(CHM,BPH,RPP).CRP	! "Chemical, rubber, plastic products",
	(CEO,EEQ).EEQ		! "Electronic equipment",
	OMF.OMF			! "Manufactures nec",
	TRD.TRD			! "Trade",
	(OTP,WHS).OTP		! "Transport nec",
	CMN.CMN			! "Communication",
	OFI.OFI			! "Financial services nec",
	OBS.OBS			! "Business services nec",
	(OSG,EDU,HHT).OSG	! "Public Administration, Defense, Education, Health",
/;

*	We define mappings for commodities in all GTAP versions.  
*	Remove those which are not in the current dataset.

option mapi:0:0:1;
abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).", mapi;

$exit

$label wbsectors_14

*	Includes CHM, RPP and PPP as separate sectors.

set ii	Sectors in the aggregation /

*	Primary and secondary energy goods
	COL	Coal 
	CRU	Crude oil
	GAS	Natural gas 
	OIL	Refined oil products
	ELE	Electricity and heat 

*.	Energy-intensive and trade-exposed goods (subjected to BCA)
	I_S	Ferrous metals
	NFM	Metals nec
	NMM	Mineral products nec
	CHM 	Chemical products
	RPP 	Rubber and plastic products
	PPP	'Paper products, publishing'

*	Other composite sectors
	TRN	Transport
	AGR	Agriculture
	MAN	Manufacturing
	SER	Services
	/;

$if "%2"=="loadset" $exit

set	mapi(i,ii)	Sectoral mapping /

	CRU.CRU		! Crude Oil
	ELE.ELE		! Electricity
	GDT.GAS		! Gas manufacture, distribution
	GAS.GAS		! Gas
	COL.COL		! Coal
	OIL.OIL		! Petroleum, coal products

	I_S.I_S		! Ferrous metals
	NFM.NFM		! Metals nec
	NMM.NMM		! Mineral products nec
	CHM.CHM		! Chemical products
	RPP.RPP		! Rubber and plastic products
	PPP.PPP		! Paper products, publishing
	(	! Agriculture
PDR		! "Paddy rice",
Wht		! "Wheat",
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
	).AGR

	(	! Manufacturing
                TEX		! "Textiles",
                LUM		! "Wood products",
                FMP		! "Metal products",
                MVH		! "Motor vehicles and parts",
                OTN		! "Transport equipment nec",
                OME		! "Machinery and equipment nec",
                EEQ		! "Electronic equipment",
                CEO		! "Computer, electronic and optical products",
                OMF		! "Manufactures nec",
   
                CMT		! "Bovine meat products",
                OMT		! "Meat products nec",
                VOL		! "Vegetable oils and fats",
                MIL		! "Dairy products",
                PCR		! "Processed rice",
                SGR		! "Sugar",
                OFD		! "Food products nec",
                B_T		! "Beverages and tobacco products",
                WAP		! "Wearing apparel",
                LEA		! "Leather products",
                CNS		! "Construction",
	).MAN


	(	! Transport
WTP	! "Water transport",
ATP	! "Air transport",
OTP	! "Transport nec",
	).TRN



	(	! Services
TRD		! "Trade",	
INS		! "Insurance (formerly isr)"			
OXT		! "Other Extraction (formerly omn Minerals nec)",
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
	).SER

/;

*	We define mappings for commodities in all GTAP versions.  
*	Remove those which are not in the current dataset.

option mapi:0:0:1;
abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).", mapi;

$exit

$label wbsectors_12

*	Includes RPP and PPP within CHM

set ii	Sectors in the aggregation /

*	Primary and secondary energy goods
	COL	Coal 
	CRU	Crude oil
	GAS	Natural gas 
	OIL	Refined oil products
	ELE	Electricity and heat 

*.	Energy-intensive and trade-exposed goods (subjected to BCA)
	I_S	Ferrous metals
	NFM	Metals nec
	NMM	Mineral products nec
	CHM 	Chemical products including rubber and plastics

*	Other composite sectors
	TRN	Transport
	AGR	Agriculture
	MAN	Manufacturing
	SER	Services
	/;

$if "%2"=="loadset" $exit

set	mapi(i,ii)	Sectoral mapping /

	CRU.CRU		! Crude Oil
	ELE.ELE		! Electricity
	GDT.GAS		! Gas manufacture, distribution
	GAS.GAS		! Gas
	COL.COL		! Coal
	OIL.OIL		! Petroleum, coal products

	I_S.I_S		! Ferrous metals
	NFM.NFM		! Metals nec
	NMM.NMM		! Mineral products nec
	CHM.CHM		! Chemical products
	RPP.CHM		! Rubber and plastic products
	PPP.CHM		! Paper products, publishing
	(	! Agriculture
PDR		! "Paddy rice",
Wht		! "Wheat",
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
	).AGR

	(	! Manufacturing
                TEX		! "Textiles",
                LUM		! "Wood products",
                FMP		! "Metal products",
                MVH		! "Motor vehicles and parts",
                OTN		! "Transport equipment nec",
                OME		! "Machinery and equipment nec",
                EEQ		! "Electronic equipment",
                CEO		! "Computer, electronic and optical products",
                OMF		! "Manufactures nec",
   
                CMT		! "Bovine meat products",
                OMT		! "Meat products nec",
                VOL		! "Vegetable oils and fats",
                MIL		! "Dairy products",
                PCR		! "Processed rice",
                SGR		! "Sugar",
                OFD		! "Food products nec",
                B_T		! "Beverages and tobacco products",
                WAP		! "Wearing apparel",
                LEA		! "Leather products",
                CNS		! "Construction",
	).MAN


	(	! Transport
WTP	! "Water transport",
ATP	! "Air transport",
OTP	! "Transport nec",
	).TRN



	(	! Services
TRD		! "Trade",	
INS		! "Insurance (formerly isr)"			
OXT		! "Other Extraction (formerly omn Minerals nec)",
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
	).SER

/;

*	We define mappings for commodities in all GTAP versions.  
*	Remove those which are not in the current dataset.

option mapi:0:0:1;
abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).", mapi;

$exit

$label windc_43

set ii	Sectors in the aggregation /

*	Aggregated sectors:

	fof	"Forestry and fishing",
	fbp	"Food and beverage and tobacco products (311FT)"
	alt	"Apparel and leather and allied products (315AL)"
	pmt	"Primary metals (331)"
	ogs	"Crude oil and natural gas"
	uti	"Utilities (electricity-gas-water)"
	oxt	"Coal, minining and supporting activities"
	ros	"Recreational and other services",
	dwe	"Dwellings and real estate activities"

*	Individual agricultural sectors:

	PDR 	"Paddy rice",
	WHT 	"Wheat",
	GRO 	"Cereal grains nec",
	V_F 	"Vegetables, fruit, nuts",
	OSD 	"Oil seeds",
	C_B 	"Sugar cane, sugar beet",
	PFB 	"Plant-based fibers",
	OCR 	"Crops nec",
	CTL 	"Bovine cattle, sheep, goats and horses",
	OAP 	"Animal products nec",
	RMK 	"Raw milk",
	WOL 	"Wool, silk-worm cocoons",

	TEX	"Textiles",
	LUM	"Lumber and wood products",
	NMM	"Mineral products nec",
	FMP	"Metal products",
	MVH	"Motor vehicles and parts",
	OTN	"Transport equipment nec",
	OME	"Machinery and equipment nec",
	CNS	"Construction",
	WTP	"Water transport",
	ATP	"Air transport",
	ISR	"Insurance",
	OIL	"Petroleum, coal products",
	PPP	"Paper products, publishing",
	CRP	"Chemical, rubber, plastic products",
	EEQ	"Electronic equipment",
	OMF	"Manufactures nec",
	TRD	"Trade",
	OTP	"Transport nec",
	CMN	"Communication",
	OFI	"Financial services nec",
	OBS	"Business services nec",
	OSG	"Public Administration, Defense, Education, Health"
	
/;

$if "%2"=="loadset" $exit

set	mapi(i,ii)	Sectoral mapping /

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
	).ogs

	(	! "Utilities"
ELE		! "Electricity",
GDT		! "Gas manufacture, distribution",
WTR		! "Water",
	).uti
	
	(	! "Mining"
COL		! "Coal",
OXT		! "Other mining extraction",
	).oxt
	
	(	! "Recreational and other services"
AFS		! "Accommodation, Food and service activities",
ROS		! "Recreational and other services",
	).ros
	
	(	! "Dwellings and real estate activities"
DWE		! "Dwellings",
RSA		! "Real estate activities",
	).dwe
	
	INS.ISR			! "Insurance",
	(CHM,BPH,RPP).CRP	! "Chemical, rubber, plastic products",
	(CEO,EEQ).EEQ		! "Electronic equipment",
	(OTP,WHS).OTP		! "Transport nec",
	(OSG,EDU,HHT).OSG	! "Public Administration, Defense, Education, Health",

*	The rest are one-to-one:

	PDR.PDR		! "Paddy rice",
	WHT.WHT		! "Wheat",
	GRO.GRO		! "Cereal grains nec",
	V_F.V_F		! "Vegetables, fruit, nuts",
	OSD.OSD		! "Oil seeds",
	C_B.C_B		! "Sugar cane, sugar beet",
	PFB.PFB		! "Plant-based fibers",
	OCR.OCR		! "Crops nec",
	CTL.CTL		! "Bovine cattle, sheep and goats, horses",
	OAP.OAP		! "Animal products nec",
	RMK.RMK		! "Raw milk",
	WOL.WOL		! "Wool, silk-worm cocoons"

	TEX.TEX		! "Textiles",
	LUM.LUM		! "Wood products",
	NMM.NMM		! "Mineral products nec",
	FMP.FMP		! "Metal products",
	MVH.MVH		! "Motor vehicles and parts",
	OTN.OTN		! "Transport equipment nec",
	OME.OME		! "Machinery and equipment nec",
	CNS.CNS		! "Construction",
	WTP.WTP		! "Water transport",
	ATP.ATP		! "Air transport",

	OIL.OIL		! "Petroleum, coal products",
	PPP.PPP		! "Paper products, publishing",
	OMF.OMF		! "Manufactures nec",
	TRD.TRD		! "Trade",
	CMN.CMN		! "Communication",
	OFI.OFI		! "Financial services nec",
	OBS.OBS		! "Business services nec"
/;

option mapi:0:0:1;
abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).",mapi;

$exit