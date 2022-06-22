$title	Translate GTAP Distribution Data into GDX

*	File separator:

$set fs %system.dirsep% 

*	GTAP release version and year

$if not set gtapv	$set gtapv 10a
$if not set yr		$set yr 14

*	Output data directory:

$if not set datadir	$set datadir "gamsdata%fs%gtap%gtapv%%fs%20%yr%%fs%"

*	Directory in which to find the GTAP zip files:

$if not set flexaggdir $set flexaggdir "%fs%gtapingams%fs%flexagg%fs%"
$if not dexist "%flexaggdir%" $abort Cannot find GTAP data directory: "%flexaggdir%".

$if %gtapv%==8		$set zipfile flexagg8aY%yr%
$if %gtapv%==81		$set zipfile flexagg81Y%yr%
$if %gtapv%==9		$set zipfile flexagg9aY%yr%
$if %gtapv%==10		$set zipfile flexagg10Y%yr%
$if %gtapv%==10a	$set zipfile flexagg10AY%yr%

$if not set zipfile $abort  "GTAP version is not recognized: %gtapv%.  Need to set zipfile identification."

$set zipid %zipfile%
$set gdxdatafile %flexaggdir%%zipfile%_gdx.zip
$set flexaggdatafile %flexaggdir%%zipfile%.zip
$if not exist "%flexaggdatafile%" $abort Cannot find GTAP data file: "%flexaggdatafile%".

*	Default is version 10 regions:

$set regions 10

$if %gtapv%==8		$set regions 8
$if %gtapv%==81		$set regions 81
$if %gtapv%==9		$set regions 9

$set	sectors 10
$if %gtapv%==8		$set sectors 8
$if %gtapv%==81		$set sectors 8
$if %gtapv%==9		$set sectors 8

*	Default is version 9 or later:

$if %gtapv%==8	$set factors five
$if %gtapv%==81	$set factors five

*	Use the GAMS scratch directory to hold temporary files:

$set tmpdir %gams.scrdir%

*	Use the following if temporary files are to be retained:

*.$if not dexist tmp $call mkdir tmp
*.$set tmpdir tmp%fs%

*	If we have the data files in GDX formta, use them:

$if exist %gdxdatafile% $call gmsunzip -j "%gdxdatafile%" -d %tmpdir%

$if exist %tmpdir%gsdset.gdx $goto load

*	Unload the har files:

$set zipfile %zipfile%%fs%
$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsdset.har	-d %tmpdir%
$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsddat.har	-d %tmpdir%
$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsdpar.har	-d %tmpdir%
$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsdvole.har	-d %tmpdir%
$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsdemiss.har -d %tmpdir%

*	Tax rates are computed on the basis of gross and net transactions,
*	so we do not need to read these from the database.  They are 
*	available, however.

*.$call gmsunzip -j "%flexaggdatafile%" %zipfile%gsdtax.har	-d %tmpdir%

$call 'har2gdx "%tmpdir%gsdset.har"   "%tmpdir%gsdset.gdx"'
$call 'har2gdx "%tmpdir%gsddat.har"   "%tmpdir%gsddat.gdx"'
$call 'har2gdx "%tmpdir%gsdpar.har"   "%tmpdir%gsdpar.gdx"'
$call 'har2gdx "%tmpdir%gsdvole.har"  "%tmpdir%gsdvole.gdx"'
$call 'har2gdx "%tmpdir%gsdemiss.har" "%tmpdir%gsdemiss.gdx"'

*.$call 'har2gdx "%tmpdir%gsdtax.har"   "%tmpdir%gsdtax.gdx"'

$if not exist %tmpdir%gsdset.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsddat.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdpar.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdemiss.gdx	$goto missinggdxfiles

*	After the har files have been translated to GDX create
*	a zip file with the GDX files:

*.$if set gdxarchive 

$log 'gmszip -j %flexaggdir%%zipid%_gdx.zip %tmpdir%*.gdx'

$call 'gmszip -j %flexaggdir%%zipid%_gdx.zip %tmpdir%*.gdx'


*.$if not exist %tmpdir%gsdvole.gdx	$goto missinggdxfiles
*.$if not exist %tmpdir%gsdtax.gdx	$goto missinggdxfiles

$label load

set	is8	Commodities in GTAP 8 to GTAP9/
	pdr	"Paddy rice",
	wht	"Wheat",
	gro	"Cereal grains nec",
	v_f	"Vegetables, fruit, nuts",
	osd	"Oil seeds",
	c_b	"Sugar cane, sugar beet",
	pfb	"Plant-based fibers",
	ocr	"Crops nec",
	ctl	"Bovine cattle, sheep, goats and horses",
	oap	"Animal products nec",
	rmk	"Raw milk",
	wol	"Wool, silk-worm cocoons",
	frs	"Forestry",
	fsh	"Fishing",
	coa	"Coal",
	oil	"Oil",
	gas	"Gas",
	omn	"Minerals nec",
	cmt	"Meat: cattle, sheep, goats, horse",
	omt	"Meat products nec",
	vol	"Vegetable oils and fats",
	mil	"Dairy products",
	pcr	"Processed rice",
	sgr	"Sugar",
	ofd	"Food products nec",
	b_t	"Beverages and tobacco products",
	tex	"Textiles",
	wap	"Wearing apparel",
	lea	"Leather products",
	lum	"Wood products",
	ppp	"Paper products, publishing",
	p_c	"Petroleum, coal products",
	crp	"Chemicals, pharmaceuticals, rubber, plastic prods",
	nmm	"Mineral products nec",
	i_s	"Ferrous metals",
	nfm	"Metals nec",
	fmp	"Metal products",
	mvh	"Motor vehicles and parts",
	otn	"Transport equipment nec",
	ele	"Electronic equipment",
	ome	"Machinery and equipment nec",
	omf	"Manufactures nec",
	ely	"Electricity",
	gdt	"Gas manufacture, distribution",
	wtr	"Water",
	cns	"Construction",
	trd	"Trade",
	otp	"Transport nec",
	wtp	"Sea transport",
	atp	"Air transport",
	cmn	"Communication",
	ofi	"Financial services nec",
	isr	"Insurance",
	obs	"Business services nec",
	ros	"Recreation and other services",
	osg	"PubAdmin/Defence/Health/Educat",
	dwe	"Dwellings"
	cgds	"Investment goods" /;

set	is10	Sectors in GTAP 10 or later /
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
	coa 	"Coal",
	oil 	"Oil",
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
	p_c 	"Petroleum, coal products",
	chm 	"Chemical products",
	bph 	"Basic pharmaceutical products",
	rpp 	"Rubber and plastic products",
	nmm 	"Mineral products nec",
	i_s 	"Ferrous metals",
	nfm 	"Metals nec",
	fmp 	"Metal products",
	ele 	"Computer, electronic and optical products",
	eeq 	"Electrical equipment",
	ome 	"Machinery and equipment nec",
	mvh 	"Motor vehicles and parts",
	otn 	"Transport equipment nec",
	omf 	"Manufactures nec",
	ely 	"Electricity",
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
	dwe 	"Dwellings",
	cgds	"Investment goods" /;

set	is(*)	Sectors in this dataset /set.is%sectors%/;

*	--------------------------------------------------------------

set	r6	Regions in GTAP 6 (provided only for reference) /
	aus	Australia
	nzl	New Zealand
	xoc	Rest of Oceania
	chn	China
	hkg	Hong Kong
	jpn	Japan
	kor	Korea
	twn	Taiwan
	xea	Rest of East Asia
	idn	Indonesia
	mys	Malaysia
	phl	Philippines
	sgp	Singapore
	tha	Thailand
	vnm	Vietnam
	xse	Rest of Southeast Asia
	bgd	Bangladesh
	ind	India
	lka	Sri Lanka
	xsa	Rest of South Asia
	can	Canada
	usa	United States
	mex	Mexico
	xna	Rest of North America
	col	Colombia
	per	Peru
	ven	Venezuela
	xap	Rest of Andean Pact
	arg	Argentina
	bra	Brazil
	chl	Chile
	ury	Uruguay
	xsm	Rest of South America
	xca	Central America
	xfa	Rest of FTAA
	xcb	Rest of the Caribbean
	aut	Austria
	bel	Belgium
	dnk	Denmark
	fin	Finland
	fra	France
	deu	Germany
	gbr	United Kingdom
	grc	Greece
	irl	Ireland
	ita	Italy
	lux	Luxembourg
	nld	Netherlands
	prt	Portugal
	esp	Spain
	swe	Sweden
	che	Switzerland
	xef	Rest of EFTA
	xer	Rest of Europe
	alb	Albania
	bgr	Bulgaria
	hrv	Croatia
	cyp	Cyprus
	cze	Czech Republic
	hun	Hungary
	mlt	Malta
	pol	Poland
	rom	Romania
	svk	Slovakia
	svn	Slovenia
	est	Estonia
	lva	Latvia
	ltu	Lithuania
	rus	Russian Federation
	xsu	Rest of Former Soviet Union
	tur	Turkey
	xme	Rest of Middle East
	mar	Morocco
	tun	Tunisia
	xnf	Rest of North Africa
	bwa	Botswana
	zaf	South Africa
	xsc	Rest of South African Customs Union
	mwi	Malawi
	moz	Mozambique
	tza	Tanzania
	zmb	Zambia
	zwe	Zimbabwe
	xsd	Rest of SADC
	mdg	Madagascar
	uga	Uganda
	xss	Rest of Sub-Saharan Africa /;

set	r7	Regions in GTAP 7 (provided for reference) /

*	Drops: xap,xfa,rom,xme,xsd,xss
 
*	Adds:	khm,lao,mmr,pak,bol,ecu,pry,cri,gtm,nic,pan,
*		nor,blr,rou,ukr,xee,kaz,kgz,arm,aze,geo,irn,
*		xws,egy,nga,sen,xwf,xcf,xac,eth,mus,xec

*	N.B.  Country "rom" becomes "rou"

	aus	Australia
	nzl	New Zealand
	xoc	Rest of Oceania
	chn	China
	hkg	Hong Kong
	jpn	Japan
	kor	Korea
	twn	Taiwan
	xea	Rest of East Asia
	khm	Cambodia
	idn	Indonesia
	lao	Lao People's Democratic Republ
	mmr	Myanmar
	mys	Malaysia
	phl	Philippines
	sgp	Singapore
	tha	Thailand
	vnm	Viet Nam
	xse	Rest of Southeast Asia
	bgd	Bangladesh
	ind	India
	pak	Pakistan
	lka	Sri Lanka
	xsa	Rest of South Asia
	can	Canada
	usa	United States of America
	mex	Mexico
	xna	Rest of North America
	arg	Argentina
	bol	Bolivia
	bra	Brazil
	chl	Chile
	col	Colombia
	ecu	Ecuador
	pry	Paraguay
	per	Peru
	ury	Uruguay
	ven	Venezuela
	xsm	Rest of South America
	cri	Costa Rica
	gtm	Guatemala
	nic	Nicaragua
	pan	Panama
	xca	Rest of Central America
	xcb	Caribbean
	aut	Austria
	bel	Belgium
	cyp	Cyprus
	cze	Czech Republic
	dnk	Denmark
	est	Estonia
	fin	Finland
	fra	France
	deu	Germany
	grc	Greece
	hun	Hungary
	irl	Ireland
	ita	Italy
	lva	Latvia
	ltu	Lithuania
	lux	Luxembourg
	mlt	Malta
	nld	Netherlands
	pol	Poland
	prt	Portugal
	svk	Slovakia
	svn	Slovenia
	esp	Spain
	swe	Sweden
	gbr	United Kingdom
	che	Switzerland
	nor	Norway
	xef	Rest of EFTA
	alb	Albania
	bgr	Bulgaria
	blr	Belarus
	hrv	Croatia
	rou	Romania
	rus	Russian Federation
	ukr	Ukraine
	xee	Rest of Eastern Europe
	xer	Rest of Europe
	kaz	Kazakhstan
	kgz	Kyrgyztan
	xsu	Rest of Former Soviet Union
	arm	Armenia
	aze	Azerbaijan
	geo	Georgia
	irn	Iran Islamic Republic of
	tur	Turkey
	xws	Rest of Western Asia
	egy	Egypt
	mar	Morocco
	tun	Tunisia
	xnf	Rest of North Africa
	nga	Nigeria
	sen	Senegal
	xwf	Rest of Western Africa
	xcf	Central Africa
	xac	South Central Africa
	eth	Ethiopia
	mdg	Madagascar
	mwi	Malawi
	mus	Mauritius
	moz	Mozambique
	tza	Tanzania
	uga	Uganda
	zmb	Zambia
	zwe	Zimbabwe
	xec	Rest of Eastern Africa
	bwa	Botswana
	zaf	South Africa
	xsc	Rest of South African Customs Union
/;

set	r8	Regions in GTAP 8 /

*	Drops:	mmr

*	Adds:	omn,isr,mng,npl,hnd,slv,bhr,kwt,qat,
*		sau,are,cmr,civ,gha,ken,nam,xtw,

	aus	"Australia", 
	nzl	"New Zealand", 
	xoc	"Rest of Oceania", 
	chn	"China", 
	hkg	"Hong Kong", 
	jpn	"Japan", 
	kor	"Korea", 
	mng	"Mongolia", 
	twn	"Taiwan", 
	xea	"Rest of East Asia", 
	khm	"Cambodia", 
	idn	"Indonesia", 
	lao	"Lao People's Democratic Republ", 
	mys	"Malaysia", 
	phl	"Philippines", 
	sgp	"Singapore", 
	tha	"Thailand", 
	vnm	"Viet Nam", 
	xse	"Rest of Southeast Asia", 
	bgd	"Bangladesh", 
	ind	"India", 
	npl	"Nepal", 
	pak	"Pakistan", 
	lka	"Sri Lanka", 
	xsa	"Rest of South Asia", 
	can	"Canada", 
	usa	"United States of America", 
	mex	"Mexico", 
	xna	"Rest of North America", 
	arg	"Argentina", 
	bol	"Bolivia", 
	bra	"Brazil", 
	chl	"Chile", 
	col	"Colombia", 
	ecu	"Ecuador", 
	pry	"Paraguay", 
	per	"Peru", 
	ury	"Uruguay", 
	ven	"Venezuela", 
	xsm	"Rest of South America", 
	cri	"Costa Rica", 
	gtm	"Guatemala", 
	hnd	"Honduras", 
	nic	"Nicaragua", 
	pan	"Panama", 
	slv	"El Salvador", 
	xca	"Rest of Central America", 
	xcb	"Caribbean", 
	aut	"Austria", 
	bel	"Belgium", 
	cyp	"Cyprus", 
	cze	"Czech Republic", 
	dnk	"Denmark", 
	est	"Estonia", 
	fin	"Finland", 
	fra	"France", 
	deu	"Germany", 
	grc	"Greece", 
	hun	"Hungary", 
	irl	"Ireland", 
	ita	"Italy", 
	lva	"Latvia", 
	ltu	"Lithuania", 
	lux	"Luxembourg", 
	mlt	"Malta", 
	nld	"Netherlands", 
	pol	"Poland", 
	prt	"Portugal", 
	svk	"Slovakia", 
	svn	"Slovenia", 
	esp	"Spain", 
	swe	"Sweden", 
	gbr	"United Kingdom", 
	che	"Switzerland", 
	nor	"Norway", 
	xef	"Rest of EFTA", 
	alb	"Albania", 
	bgr	"Bulgaria", 
	blr	"Belarus", 
	hrv	"Croatia", 
	rou	"Romania", 
	rus	"Russian Federation", 
	ukr	"Ukraine", 
	xee	"Rest of Eastern Europe", 
	xer	"Rest of Europe", 
	kaz	"Kazakhstan", 
	kgz	"Kyrgyzstan", 
	xsu	"Rest of Former Soviet Union", 
	arm	"Armenia", 
	aze	"Azerbaijan", 
	geo	"Georgia", 
	bhr	"Bahrain", 
	irn	"Iran Islamic Republic of", 
	isr	"Israel", 
	kwt	"Kuwait", 
	omn	"Oman", 
	qat	"Qatar", 
	sau	"Saudi Arabia", 
	tur	"Turkey", 
	are	"United Arab Emirates", 
	xws	"Rest of Western Asia", 
	egy	"Egypt", 
	mar	"Morocco", 
	tun	"Tunisia", 
	xnf	"Rest of North Africa", 
	cmr	"Cameroon", 
	civ	"Cote d'Ivoire", 
	gha	"Ghana", 
	nga	"Nigeria", 
	sen	"Senegal", 
	xwf	"Rest of Western Africa", 
	xcf	"Central Africa", 
	xac	"South Central Africa", 
	eth	"Ethiopia", 
	ken	"Kenya", 
	mdg	"Madagascar", 
	mwi	"Malawi", 
	mus	"Mauritius", 
	moz	"Mozambique", 
	tza	"Tanzania", 
	uga	"Uganda", 
	zmb	"Zambia", 
	zwe	"Zimbabwe", 
	xec	"Rest of Eastern Africa", 
	bwa	"Botswana", 
	nam	"Namibia"
	zaf	"South Africa", 
	xsc	"Rest of South African Customs", 
	xtw	"Rest of the World"
	/;

set	r81	Regions in GTAP 8.1 /

*	Adds: ben,bfa,gin,tgo,rwa

	aus	"Australia", 
	nzl	"New Zealand", 
	xoc	"Rest of Oceania", 
	chn	"China", 
	hkg	"Hong Kong", 
	jpn	"Japan", 
	kor	"Korea", 
	mng	"Mongolia", 
	twn	"Taiwan", 
	xea	"Rest of East Asia", 
	khm	"Cambodia", 
	idn	"Indonesia", 
	lao	"Lao People's Democratic Republ", 
	mys	"Malaysia", 
	phl	"Philippines", 
	sgp	"Singapore", 
	tha	"Thailand", 
	vnm	"Viet Nam", 
	xse	"Rest of Southeast Asia", 
	bgd	"Bangladesh", 
	ind	"India", 
	npl	"Nepal", 
	pak	"Pakistan", 
	lka	"Sri Lanka", 
	xsa	"Rest of South Asia", 
	can	"Canada", 
	usa	"United States of America", 
	mex	"Mexico", 
	xna	"Rest of North America", 
	arg	"Argentina", 
	bol	"Bolivia", 
	bra	"Brazil", 
	chl	"Chile", 
	col	"Colombia", 
	ecu	"Ecuador", 
	pry	"Paraguay", 
	per	"Peru", 
	ury	"Uruguay", 
	ven	"Venezuela", 
	xsm	"Rest of South America", 
	cri	"Costa Rica", 
	gtm	"Guatemala", 
	hnd	"Honduras", 
	nic	"Nicaragua", 
	pan	"Panama", 
	slv	"El Salvador", 
	xca	"Rest of Central America", 
	xcb	"Caribbean", 
	aut	"Austria", 
	bel	"Belgium", 
	cyp	"Cyprus", 
	cze	"Czech Republic", 
	dnk	"Denmark", 
	est	"Estonia", 
	fin	"Finland", 
	fra	"France", 
	deu	"Germany", 
	grc	"Greece", 
	hun	"Hungary", 
	irl	"Ireland", 
	ita	"Italy", 
	lva	"Latvia", 
	ltu	"Lithuania", 
	lux	"Luxembourg", 
	mlt	"Malta", 
	nld	"Netherlands", 
	pol	"Poland", 
	prt	"Portugal", 
	svk	"Slovakia", 
	svn	"Slovenia", 
	esp	"Spain", 
	swe	"Sweden", 
	gbr	"United Kingdom", 
	che	"Switzerland", 
	nor	"Norway", 
	xef	"Rest of EFTA", 
	alb	"Albania", 
	bgr	"Bulgaria", 
	blr	"Belarus", 
	hrv	"Croatia", 
	rou	"Romania", 
	rus	"Russian Federation", 
	ukr	"Ukraine", 
	xee	"Rest of Eastern Europe", 
	xer	"Rest of Europe", 
	kaz	"Kazakhstan", 
	kgz	"Kyrgyzstan", 
	xsu	"Rest of Former Soviet Union", 
	arm	"Armenia", 
	aze	"Azerbaijan", 
	geo	"Georgia", 
	bhr	"Bahrain", 
	irn	"Iran Islamic Republic of", 
	isr	"Israel", 
	kwt	"Kuwait", 
	omn	"Oman", 
	qat	"Qatar", 
	sau	"Saudi Arabia", 
	tur	"Turkey", 
	are	"United Arab Emirates", 
	xws	"Rest of Western Asia", 
	egy	"Egypt", 
	mar	"Morocco", 
	tun	"Tunisia", 
	xnf	"Rest of North Africa", 
	ben	"Benin",
	bfa	"Burkina Faso",
	cmr	"Cameroon",
	civ	"Cote dIvoire",
	gha	"Ghana",
	gin	"Guinea",
	nga	"Nigeria",
	sen	"Senegal",
	tgo	"Togo",
	xwf	"Rest of Western Africa",
	xcf	"Central Africa",
	xac	"South Central Africa",
	eth	"Ethiopia",
	ken	"Kenya",
	mdg	"Madagascar",
	mwi	"Malawi",
	mus	"Mauritius",
	moz	"Mozambique",
	rwa	"Rwanda",
	tza	"Tanzania",
	uga	"Uganda",
	zmb	"Zambia",
	zwe	"Zimbabwe",
	xec	"Rest of Eastern Africa",
	bwa	"Botswana",
	nam	"Namibia",
	zaf	"South Africa",
	xsc	"Rest of South African Customs",
	xtw	"Rest of the World"  /;

set	r9	Regions in GTAP 9 /

*	Adds: brn(xse),dom(xcb),jam,pri,tto,jor

	aus	"Australia",
	nzl	"New Zealand",
	xoc	"Rest of Oceania",
	chn	"China",
	hkg	"Hong Kong",
	jpn	"Japan",
	kor	"Korea",
	mng	"Mongolia",
	twn	"Taiwan",
	xea	"Rest of East Asia",
	brn	"Brunei Darussalam",
	khm	"Cambodia",
	idn	"Indonesia",
	lao	"Lao People's Democratic Republ",
	mys	"Malaysia",
	phl	"Philippines",
	sgp	"Singapore",
	tha	"Thailand",
	vnm	"Viet Nam",
	xse	"Rest of Southeast Asia",
	bgd	"Bangladesh",
	ind	"India",
	npl	"Nepal",
	pak	"Pakistan",
	lka	"Sri Lanka",
	xsa	"Rest of South Asia",
	can	"Canada",
	usa	"United States of America",
	mex	"Mexico",
	xna	"Rest of North America",
	arg	"Argentina",
	bol	"Bolivia",
	bra	"Brazil",
	chl	"Chile",
	col	"Colombia",
	ecu	"Ecuador",
	pry	"Paraguay",
	per	"Peru",
	ury	"Uruguay",
	ven	"Venezuela",
	xsm	"Rest of South America",
	cri	"Costa Rica",
	gtm	"Guatemala",
	hnd	"Honduras",
	nic	"Nicaragua",
	pan	"Panama",
	slv	"El Salvador",
	xca	"Rest of Central America",
	dom	"Dominican Republic",
	jam	"Jamaica",
	pri	"Puerto Rico",
	tto	"Trinidad and Tobago",
	xcb	"Caribbean",
	aut	"Austria",
	bel	"Belgium",
	cyp	"Cyprus",
	cze	"Czech Republic",
	dnk	"Denmark",
	est	"Estonia",
	fin	"Finland",
	fra	"France",
	deu	"Germany",
	grc	"Greece",
	hun	"Hungary",
	irl	"Ireland",
	ita	"Italy",
	lva	"Latvia",
	ltu	"Lithuania",
	lux	"Luxembourg",
	mlt	"Malta",
	nld	"Netherlands",
	pol	"Poland",
	prt	"Portugal",
	svk	"Slovakia",
	svn	"Slovenia",
	esp	"Spain",
	swe	"Sweden",
	gbr	"United Kingdom",
	che	"Switzerland",
	nor	"Norway",
	xef	"Rest of EFTA",
	alb	"Albania",
	bgr	"Bulgaria",
	blr	"Belarus",
	hrv	"Croatia",
	rou	"Romania",
	rus	"Russian Federation",
	ukr	"Ukraine",
	xee	"Rest of Eastern Europe",
	xer	"Rest of Europe",
	kaz	"Kazakhstan",
	kgz	"Kyrgyzstan",
	xsu	"Rest of Former Soviet Union",
	arm	"Armenia",
	aze	"Azerbaijan",
	geo	"Georgia",
	bhr	"Bahrain",
	irn	"Iran Islamic Republic of",
	isr	"Israel",
	jor	"Jordan",
	kwt	"Kuwait",
	omn	"Oman",
	qat	"Qatar",
	sau	"Saudi Arabia",
	tur	"Turkey",
	are	"United Arab Emirates",
	xws	"Rest of Western Asia",
	egy	"Egypt",
	mar	"Morocco",
	tun	"Tunisia",
	xnf	"Rest of North Africa",
	ben	"Benin",
	bfa	"Burkina Faso",
	cmr	"Cameroon",
	civ	"Cote d'Ivoire",
	gha	"Ghana",
	gin	"Guinea",
	nga	"Nigeria",
	sen	"Senegal",
	tgo	"Togo",
	xwf	"Rest of Western Africa",
	xcf	"Central Africa",
	xac	"South Central Africa",
	eth	"Ethiopia",
	ken	"Kenya",
	mdg	"Madagascar",
	mwi	"Malawi",
	mus	"Mauritius",
	moz	"Mozambique",
	rwa	"Rwanda",
	tza	"Tanzania",
	uga	"Uganda",
	zmb	"Zambia",
	zwe	"Zimbabwe",
	xec	"Rest of Eastern Africa",
	bwa	"Botswana",
	nam	"Namibia",
	zaf	"South Africa",
	xsc	"Rest of South African Customs",
	xtw	"Rest of the World"  /;

set	r10	Regions in GTAP 10 /	

*	Adds: tjk(xsu)

	aus	"Australia",
	nzl	"New Zealand",
	xoc	"Rest of Oceania",
	chn	"China",
	hkg	"Hong Kong",
	jpn	"Japan",
	kor	"Korea",
	mng	"Mongolia",
	twn	"Taiwan",
	xea	"Rest of East Asia",
	brn	"Brunei Darussalam",
	khm	"Cambodia",
	idn	"Indonesia",
	lao	"Lao People's Democratic Republ",
	mys	"Malaysia",
	phl	"Philippines",
	sgp	"Singapore",
	tha	"Thailand",
	vnm	"Viet Nam",
	xse	"Rest of Southeast Asia",
	bgd	"Bangladesh",
	ind	"India",
	npl	"Nepal",
	pak	"Pakistan",
	lka	"Sri Lanka",
	xsa	"Rest of South Asia",
	can	"Canada",
	usa	"United States of America",
	mex	"Mexico",
	xna	"Rest of North America",
	arg	"Argentina",
	bol	"Bolivia",
	bra	"Brazil",
	chl	"Chile",
	col	"Colombia",
	ecu	"Ecuador",
	pry	"Paraguay",
	per	"Peru",
	ury	"Uruguay",
	ven	"Venezuela",
	xsm	"Rest of South America",
	cri	"Costa Rica",
	gtm	"Guatemala",
	hnd	"Honduras",
	nic	"Nicaragua",
	pan	"Panama",
	slv	"El Salvador",
	xca	"Rest of Central America",
	dom	"Dominican Republic",
	jam	"Jamaica",
	pri	"Puerto Rico",
	tto	"Trinidad and Tobago",
	xcb	"Caribbean",
	aut	"Austria",
	bel	"Belgium",
	cyp	"Cyprus",
	cze	"Czech Republic",
	dnk	"Denmark",
	est	"Estonia",
	fin	"Finland",
	fra	"France",
	deu	"Germany",
	grc	"Greece",
	hun	"Hungary",
	irl	"Ireland",
	ita	"Italy",
	lva	"Latvia",
	ltu	"Lithuania",
	lux	"Luxembourg",
	mlt	"Malta",
	nld	"Netherlands",
	pol	"Poland",
	prt	"Portugal",
	svk	"Slovakia",
	svn	"Slovenia",
	esp	"Spain",
	swe	"Sweden",
	gbr	"United Kingdom",
	che	"Switzerland",
	nor	"Norway",
	xef	"Rest of EFTA",
	alb	"Albania",
	bgr	"Bulgaria",
	blr	"Belarus",
	hrv	"Croatia",
	rou	"Romania",
	rus	"Russian Federation",
	ukr	"Ukraine",
	xee	"Rest of Eastern Europe",
	xer	"Rest of Europe",
	kaz	"Kazakhstan",
	kgz	"Kyrgyzstan",
	tjk	"Tajikistan",
	xsu	"Rest of Former Soviet Union",
	arm	"Armenia",
	aze	"Azerbaijan",
	geo	"Georgia",
	bhr	"Bahrain",
	irn	"Iran Islamic Republic of",
	isr	"Israel",
	jor	"Jordan",
	kwt	"Kuwait",
	omn	"Oman",
	qat	"Qatar",
	sau	"Saudi Arabia",
	tur	"Turkey",
	are	"United Arab Emirates",
	xws	"Rest of Western Asia",
	egy	"Egypt",
	mar	"Morocco",
	tun	"Tunisia",
	xnf	"Rest of North Africa",
	ben	"Benin",
	bfa	"Burkina Faso",
	cmr	"Cameroon",
	civ	"Cote d'Ivoire",
	gha	"Ghana",
	gin	"Guinea",
	nga	"Nigeria",
	sen	"Senegal",
	tgo	"Togo",
	xwf	"Rest of Western Africa",
	xcf	"Central Africa",
	xac	"South Central Africa",
	eth	"Ethiopia",
	ken	"Kenya",
	mdg	"Madagascar",
	mwi	"Malawi",
	mus	"Mauritius",
	moz	"Mozambique",
	rwa	"Rwanda",
	tza	"Tanzania",
	uga	"Uganda",
	zmb	"Zambia",
	zwe	"Zimbabwe",
	xec	"Rest of Eastern Africa",
	bwa	"Botswana",
	nam	"Namibia",
	zaf	"South Africa",
	xsc	"Rest of South African Customs",
	xtw	"Rest of the World"  /;

set	r(*)	Regions in this dataset /set.r%regions%/;


set	f(*)	Factors /

$ifthen.factors %factors%==five

	land		Land,
	capital		Capital,
	natlres		Natural resources,
	UnskLab		Unskilled laboer,
	SkLab		Skilled labor /;

$else.factors

	land		"Land"
	tech_aspros	"Technicians/AssocProfessional"
	clerks		"Clerks"
	service_shop	"Service/Shop workers"
	off_mgr_pros	"Officials and Managers"
	ag_othlowsk	"Agricultural and Unskilled"
	capital		"Capital"
	natlres		"Natural Resources" /;

$endif.factors


*	Read these sets to verify that they are consistent:

set	rdomain(r),isdomain(is),fdomain(f);
$gdxin '%tmpdir%gsdset.gdx'
$loaddc rdomain=reg isdomain=PROD_COMM fdomain=ENDW_COMM

abort$(card(rdomain)<>card(r))	 "Set r  on gsdset.gdx is inconsistent.", rdomain, r;
abort$(card(isdomain)<>card(is)) "Set is on gsdset.gdx is inconsistent.", rdomain, r;
abort$(card(fdomain)<>card(f))	 "Set f  on gsdset.gdx is inconsistent.", rdomain, r;

set	g	/c,g,i,sd,dd,set.is/,
	i(g)	/set.is/;

alias (i,j),(r,s), (u,*);

set	ttype	Tariff type /
		adv	Ad-valorem,
		spe	Specific /;

parameter
	mdf(i,j,r)	'Emissions from domestic product in current production, Mt CO2',
	mdg(i,r)	'Emissions from govt consumption of domestic product, Mt CO2',
	mdp(i,r)	'Emissions from private consumption of domestic product, Mt CO2',
	mif(i,j,r)	'Emissions from imports in current production, Mt CO2',
	mig(i,r)	'Emissions from government consumption of imports, Mt CO2',
	mip(i,r)	'Emissions from private consumption of imports, Mt CO2';

$gdxin '%tmpdir%gsdemiss.gdx'
$loaddc mdf mdg mdp mif mig mip

parameters
	dpsm(r)		"Sum of distribution parameters in household demand system",
	evfa(f,i,r)	"Primary factor purchases, at agents' prices",
	evoa(f,r)	"Primary factor sales, at agents' prices",
	fbep(f,i,r)	"Gross factor-based subsidies",
	ftrv(f,i,r)	"Gross factor employment tax revenue",
	isep(i,j,r,*)	"Net intermediate input subsidies",
	osep(i,r)	"Net ordinary output subsidy",
	pop(r)		"Population",
	save(r)		"Net saving, by region",
	tvom(i,r)	"Sales of domestic product, at market prices",
	vdep(r)		"Capital depreciation",

	vdfa(i,j,r)	"Domestic purchases, by firms, at agents' prices",
	vdfm(i,g,r)	"Domestic purchases, by firms, at market prices",
	vdga(i,r)	"Domestic purchases, by government, at agents' prices",
	vdgm(i,r)	"Domestic purchases, by government, at market prices",
	vdpa(i,r)	"Domestic purchases, by households, at agents' prices",
	vdpm(i,r)	"Domestic purchases, by households, at market prices",

	vfm(f,i,r)	"Primary factor purchases, by firms, at market prices",
	vifa(i,j,r)	"Import purchases, by firms, at agents' prices",
	vifm(i,g,r)	"Import purchases, by firms, at market prices",
	viga(i,r)	"Import purchases, by government, at agents' prices",
	vigm(i,r)	"Import purchases, by government, at market prices",
	vims(i,r,s)	"Imports, at market prices",
	vipa(i,r)	"Import purchases, by households, at agents' prices",
	vipm(i,r)	"Import purchases, by households, at market prices",
	viws(i,r,s)	"Imports, at world prices",
	vkb(r)		"Capital stock",
	vst(i,r)	"Margin exports",

	vtwr(i,j,r,s)	"Margins by margin commodity",
	vxmd(i,r,s)	"Non-margin exports, at market prices",
	vxwd(i,r,s)	"Non-margin exports, at world prices",

	adrev(i,r,s)		"Anti-dumping duty",
	mfarev(i,r,s)		"Export tax equivalent of MFA quota premia",
	purev(i,r,s)		"Export tax equivalent of price undertakings",
	tfrv(i,r,s)		"Ordinary import duty",
	verrev(i,r,s)		"Export tax equivalent of voluntary export restraints",
	xtrev(i,r,s)		"Ordinary export tax"
	tfrvsa(ttype,i,r,s)	"Import tariff rev by type of tariffs paid";

$gdxin '%tmpdir%gsddat.gdx'

$loaddc dpsm evfa evoa fbep ftrv isep  osep pop  save 
$loaddc tvom vdep vdfa vdfm vdga vdgm vdpa vdpm vfm vifa vifm viga vigm vims vipa
$loaddc vipm viws vkb vst vxmd vxwd 

*	Data version 10 is slightly different than versions 8, 8.1 or 9:

$set version 9
$if %gtapv%==10  $set version 10
$if %gtapv%==10a $set version 10

$ifthen.gtap10load  %version%==10
$load adrev=adrv mfarev=mfrv purev=purv tfrv xtrev=xtrv vtwr

*	These arrays are not included in the GTAP10 dataset:

	verrev(i,r,s) = 0;
	tfrvsa(ttype,i,r,s) = 0;

$else.gtap10load

*	Version 8, 8.1 or 9:

$loaddc adrev mfarev purev tfrv=tarifrev
$loaddc verrev tfrvsa xtrev vtwr=vtwrini

$endif.gtap10load

parameter	
	esubd(i)	"Elasticity of domestic-import substitution",
	esubm(i)	"Elasticity of import source substitution",
	esubt(i)	"Elasticity of top-level input substitution",
	esubva(i)	"Elasticity of factor substitution",
	etrae(f)	"Elasticity of transformation for sluggish endowments",
	incpar(i,r)	"Expansion parameter in the CDE minimum expenditure function",
	rorflex(r)	"Flexibility of expected net ROR wrt investment",
	subpar(i,r)	"Substitution parameter in CDE minimum expenditure function";

$gdxin '%tmpdir%gsdpar.gdx'
$loaddc esubd esubm esubt esubva etrae incpar rorflex subpar

set	fg(*) /set.f, set.g/;

parameter
	rtf(f,i,r)	"Taxes on primary factors - % ad valorem rate,",
	rtfd(i,g,r)	"Taxes on firms' domestic purchases - % ad valorem rate,"
	rtfi(i,g,r)	"Taxes on firms' imports purchases -- % ad valorem rate",
	rtgd(i,r)	"Government domestic purchases taxes -- % ad valorem rate",
	rtgi(i,r)	"Government import purchases taxes -- % ad valorem rate",
	rtms(i,r,s)	"Import taxes, by source -- % ad valorem rate",
	rto(fg,r)	"Output (or income) subsidies in region r -- % ad valorem rate",
	rtpd(i,r)	"Private domestic consumption taxes -- % ad valorem rate",
	rtpi(i,r)	"Private import consumption taxes -- % ad valorem rate",
	rtxs(i,r,s)	"Export subsidies, by destination -- % ad valorem rate";

*.$gdxin "%tmpdir%gsdtax.gdx"
*.$loaddc rtf rtfd rtfi rtgd rtgi rtms rto rtpd rtpi rtxs

parameter
	edf(i,j,r)	"Usage of domestic product by firms, Mtoe",
	edg(i,r)	"Government consumption of domestic product, Mtoe",
	edp(i,r)	"Private consumption of domestic product, Mtoe",
	eif(i,j,r)	"Usage of imports by firms, Mtoe",
	eig(i,r)	"Government consumption of imports, Mtoe",
	eip(i,r)	"Private consumption of imports, Mtoe",
	exidag(i,r,s)	"Volume of trade, Mtoe";

*	GTAP is unable to include energy data for 2004, so we skip
*	those data files if the file is not found.

$ifthen.gsdvole exist "%tmpdir%gsdvole.gdx"
$gdxin "%tmpdir%gsdvole.gdx"
$loaddc edf edg edp eif eig eip 
$if %gtapv%==10a $loaddc exidag=exi
$if %gtapv%==10  $loaddc exidag
$else.gsdvole
	edf(i,j,r) = 0;
	edg(i,r) = 0;
	edp(i,r) = 0;
	eif(i,j,r) = 0;
	eig(i,r) = 0;
	eip(i,r) = 0;
	exidag(i,r,s) = 0;
$endif.gsdvole

parameters
	echop_f		Check on factor markets,
	echop_m		Check on import markets,
	echop_b(*,*)	Regional budget balance,
	echop_t		Check on market for bilateral trade 
	echop_tm	Check on market for transport margins
	echop_y		Check on market for produced goods and services
	echop_tax	Regional tax revenue

parameters
	vfa(fg,j,r)	Firm's expenditure on factor by industry j
	voa(fg,r)	Value of commodity i output in region r
	vdm(i,r)	Domestic sales of i in r at market prices (tradeables only)
	vom(fg,r)	Value of commodity i output in region r at market prices
	vpa(i,r)	Private household expenditure on i in r at agent's prices
	vga(i,r)	Government household expenditure on i in r at agent's prices

	echop_f		Check on factor markets,
	echop_m		Check on import markets,
	echop_b(*,*)	Regional budget balance,
	echop_t		Check on market for bilateral trade 
	echop_tm	Check on market for transport margins
	echop_y		Check on market for produced goods and services
	echop_tax	Regional tax revenue

	evt(i,r,r)	Volume of energy trade (mtoe);

*	Assign some intermediate arrays:

vfa(fg(f),j,r) = evfa(f,j,r);
vfa(fg(i),j,s) = vdfa(i,j,s) + vifa(i,j,s);
voa(fg(f),r) = evoa(f,r);

alias (fg,ffg);

voa(fg(i),r) = sum(ffg, vfa(ffg,i,r));

vdm(i,r) = vdpm(i,r) + vdgm(i,r) + sum(j, vdfm(i,j,r));

vom(fg(f),r) = sum(j, vfm(f,j,r));
vom(fg(i),r) = vdm(i,r) + sum(s, vxmd(i,r,s)) + vst(i,r);

vom("cgds",r) = voa("cgds",r);

vpa(i,s) = vdpa(i,s) + vipa(i,s);
vga(i,s) = vdga(i,s) + viga(i,s);

evt(i,r,s) = exidag(i,r,s);

*	Compute tax rates from gross and net transactions:

rto(fg(i),r) = (1 - voa(fg,r)/vom(fg,r))$voa(fg,r);

rtf(f,j,r)$evfa(f,j,r) = evfa(f,j,r)/vfm(f,j,r) - 1;

*	Load private and public consumption in vdfm:

vdfm(i,"c",r) = vdpm(i,r);
vdfm(i,"g",r) = vdgm(i,r);

vom("c",r) = sum(i,vdpa(i,r)+vipa(i,r));

rtfd(i,j,r)$vdfa(i,j,r) = vdfa(i,j,r)/vdfm(i,j,r) - 1;
rtfd(i,"c",r)$vdpa(i,r) = vdpa(i,r)/vdpm(i,r) - 1;
rtfd(i,"g",r)$vdga(i,r) = vdga(i,r)/vdgm(i,r) - 1;

*	Load private and public consumption in vifm:

vifm(i,"c",r) = vipm(i,r);
vifm(i,"g",r) = vigm(i,r);

rtfi(i,j,r)$vifa(i,j,r) = vifa(i,j,r)/vifm(i,j,r)-1;
rtfi(i,"c",r)$vipa(i,r) = vipa(i,r)/vipm(i,r)-1;
rtfi(i,"g",r)$viga(i,r) = viga(i,r)/vigm(i,r)-1;

vom("g",r) = sum(i,vdga(i,r)+viga(i,r));

rtxs(i,r,s)$vxwd(i,r,s) = vxwd(i,r,s)/vxmd(i,r,s)-1;
rtms(i,r,s)$vims(i,r,s) = vims(i,r,s)/viws(i,r,s)-1;

*	Provide an consistency check echoprint:

echop_m(i,s,"supply") = sum(r, vims(i,r,s));
echop_m(i,s,"demand") = sum(j, vifm(i,j,s)) + vifm(i,"c",s) + vifm(i,"g",s);
echop_m(i,s,"diff") = round(sum(r, vims(i,r,s)) - 
	(sum(j, vifm(i,j,s)) + vifm(i,"c",s) + vifm(i,"g",s)),3);
echop_m(i,s,u)$(not round(echop_m(i,s,"diff"),3)) = 0;
option echop_m:3:2:1;
display echop_m;

*	Generate an echo print of regional 
*	budget constraints:

echop_b(r,"voa") = sum(fg(f), voa(fg,r));
echop_b(r,"taxrev") = 
	+ sum(fg(f), vom(fg,r)-voa(fg,r))
        + sum(fg(i), rto(fg,r)*vom(fg,r))
        + sum(j, sum(f, rtf(f,j,r)*vfm(f,j,r)))
        + sum(i, sum(g, rtfi(i,g,r)*vifm(i,g,r)))
        + sum(i, sum(g, rtfd(i,g,r)*vdfm(i,g,r)))
        + sum(i, sum(s, rtxs(i,r,s)*vxmd(i,r,s)))
	+ sum(i, sum(s, rtms(i,s,r)*
			((1+rtxs(i,s,r))*vxmd(i,s,r)+sum(j,vtwr(j,i,s,r)))));

echop_b(r,"saving") = save(r) + vdep(r);
echop_b(r,"expend") = sum(i, (1+rtfd(i,"c",r))*vdfm(i,"c",r) +
					(1+rtfi(i,"c",r))*vifm(i,"c",r) +
					(1+rtfd(i,"g",r))*vdfm(i,"g",r) +
					(1+rtfi(i,"g",r))*vifm(i,"g",r) );
echop_b(r,"diff") = round(echop_b(r,"voa") + echop_b(r,"taxrev") 
	- echop_b(r,"saving") - echop_b(r,"expend"),3);
echop_b(r,u)$(not round(echop_b(r,"diff"),3)) = 0;

option echop_b:3:1:1;
display echop_b;

*	Generate an echo print of regional 
*	tax revenue:

echop_tax(r,"1f") = sum(fg(f), vom(fg,r)-voa(fg,r));
echop_tax(r,"1i") = sum(fg(i), rto(fg,r)*vom(fg,r));
echop_tax(r,"2") = sum(j, sum(f, rtf(f,j,r)*vfm(f,j,r)));
echop_tax(r,"3") = sum(i, rtfi(i,"c",r)*vifm(i,"c",r));
echop_tax(r,"4") = sum(i, rtfd(i,"c",r)*vdfm(i,"c",r));
echop_tax(r,"5") = sum(i, rtfi(i,"g",r)*vifm(i,"g",r));
echop_tax(r,"6") = sum(i, rtfd(i,"g",r)*vdfm(i,"g",r));
echop_tax(r,"7") = sum(i, sum(j, rtfi(i,j,r)*vifm(i,j,r)));
echop_tax(r,"8") = sum(i, sum(j, rtfd(i,j,r)*vdfm(i,j,r)));

echop_tax(r,"9") = sum(i, sum(s, rtxs(i,r,s)*vxmd(i,r,s)));
echop_tax(r,"10") = sum(i, sum(s, rtms(i,s,r)*
		((1+rtxs(i,s,r))*vxmd(i,s,r)+sum(j,vtwr(j,i,s,r)))))
display echop_tax;

*	Generate an echo print of bilateral trade:

echop_t(i,r,s,"demand") = vims(i,r,s);
echop_t(i,r,s,"supply") = (1+rtms(i,r,s))*((1+rtxs(i,r,s))*vxmd(i,r,s) + 
						sum(j, vtwr(j,i,r,s)));
echop_t(i,r,s,"diff") = echop_t(i,r,s,"demand") - echop_t(i,r,s,"supply");

echop_t(i,r,s,u)$(not round(echop_t(i,r,s,"diff"),3)) = 0;

option echop_t:3:3:1;
display echop_t;

*	Generate an echo print of the market for 
*	transportation margins:

echop_tm(j,"supply") = sum(r, vst(j,r));
echop_tm(j,"demand") = sum((i,r,s), vtwr(j,i,r,s));
echop_tm(j,"diff") = round(echop_tm(j,"supply") - echop_tm(j,"demand"),3);
echop_tm(j,u)$(not round(echop_tm(j,"diff"),3)) = 0;
display echop_tm;

*	Generate an echo print of the market for output:

echop_y(fg(i),r,"supply")$(not sameas(i,"cgds")) = vom(fg,r);
echop_y(i,r,"demand")$(not sameas(i,"cgds")) = 
	sum(s, vxmd(i,r,s)) + vst(i,r) + sum(g,vdfm(i,g,r));
echop_y(i,r,"diff")$(not sameas(i,"cgds")) = 
	round(echop_y(i,r,"supply") - echop_y(i,r,"demand"),3);
echop_y(i,r,u)$(not echop_y(i,r,"diff")) = 0;
option echop_y:3:2:1;
display echop_y;

set	sf(f)	Sluggish primary factors (sector-specific)
	mf(f)	Mobile primary factors;
mf(f) = yes$(etrae(f)=0);
sf(f) = yes$(etrae(f)<0);

*	Convert sign of etrae() so that it is interpreted as
*	non-negative elasticity of transformation:

etrae(f) = -etrae(f);
etrae(mf) = +inf;

*	-------------------------------------------------------------------
*	Scale data from millions to billions of dollars:

vfm(f,i,r)    = vfm(f,i,r)/1000;
vdfm(i,g,r)   = vdfm(i,g,r)/1000;
vifm(i,g,r)   = vifm(i,g,r)/1000;
vxmd(i,r,s)   = vxmd(i,r,s)/1000;
vst(i,r)      = vst(i,r)/1000;
vtwr(i,j,r,s) = vtwr(i,j,r,s)/1000;

*	Change the sign of export taxes as export subsidies:

rtxs(i,s,r) = - rtxs(i,s,r);

$ontext
set	ghg		Greenhouse gases /
	co2		Carbon dioxide Mt (CO2 - 81% - GWP 1)
	n2o		Nitrous oxide (Gg - 6%)
	ch4		Methane (Gg - 11%)
	fg		Florinated gases (Gg - 3%) /

$call 'har2gdx "%flexaggdir%consld_2011.har"   "%tmpdir%consld_2011.gdx"'

set	nco2		Non-co2 /n2o,ch4,fg/;
$offtext

parameter
	evd(i,*,r)	Domestic energy use (mtoe),
	evi(i,*,r)	Imported energy use (mtoe),
	eco2d(i,*,r)	CO2 emissions in domestic fuels - Mt CO2",
	eco2i(i,*,r)	CO2 emissions in foreign fuels - Mt CO2";
	
evd(i,j,r)   = edf(i,j,r);
evd(i,"c",r) = edp(i,r);
evd(i,"g",r) = edg(i,r);
evi(i,j,r)   = eif(i,j,r);
evi(i,"c",r) = eip(i,r);
evi(i,"g",r) = eig(i,r);

eco2d(i,j,r)   = mdf(i,j,r);
eco2d(i,"g",r) = mdg(i,r);
eco2d(i,"c",r) = mdp(i,r);

eco2i(i,j,r)   = mif(i,j,r);
eco2i(i,"g",r) = mig(i,r);
eco2i(i,"c",r) = mip(i,r);

*	Finally, remove the CGDS commodity and transfer all production
*	coefficients into the I (investment) activity:

$onuni
rto("i",r) = rto("cgds",r); rto("cgds",r) = 0;

vdfm(i,"i",r) = vdfm(i,"cgds",r); vdfm(i,"cgds",r) = 0;
vifm(i,"i",r) = vifm(i,"cgds",r); vifm(i,"cgds",r) = 0;

vdfm("cgds",g,r) = 0;
vifm("cgds",g,r) = 0;

rtfd(i,"i",r) = rtfd(i,"cgds",r); rtfd(i,"cgds",r) = 0;
rtfi(i,"i",r) = rtfi(i,"cgds",r); rtfi(i,"cgds",r) = 0;

rtfd("cgds",g,r) = 0;
vifm("cgds",g,r) = 0;

evd(i,"i",r) = evd(i,"cgds",r); evd(i,"cgds",r) = 0;
evi(i,"i",r) = evi(i,"cgds",r); evi(i,"cgds",r) = 0;

eco2d(i,"i",r) = eco2d(i,"cgds",r); eco2d(i,"cgds",r) = 0;
eco2i(i,"i",r) = eco2i(i,"cgds",r); eco2i(i,"cgds",r) = 0;

evd("cgds",j,r) = 0;
evi("cgds",j,r) = 0;

eco2d("cgds",j,r) = 0;
eco2i("cgds",j,r) = 0;

set	ii(*)	Commodities (excluding cgds),
	gg(*)	Sectors (excluding cgds) and elements of final demand;

ii(i) = yes$(not sameas(i,"cgds"));
gg(g) = yes$(not sameas(g,"cgds"));

*	Add explanatory text:

ii(i)$is(i) = is(i);
gg(i)$is(i) = is(i);

ii("cgds") = no;
gg("cgds") = no;


parameter	thetac(i,r)	Final demand value shares,
		eta(i,r)	Income elasticity of demand,
		aues(i,j,r)	Allen-Uzawa elasticities of substitution;

alias (i,k);

*	Final consumption value shares:

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

*	Drop references to commodities with zero value shares:

subpar(i,r)$(not thetac(i,r)) = 0;
incpar(i,r)$(not thetac(i,r)) = 0;

*	Income elasticity of demand:

eta(i,r)$(not thetac(i,r)) = 0;
eta(i,r)$thetac(i,r) = subpar(i,r) - sum(k,thetac(k,r)*subpar(k,r)) + 
	(incpar(i,r)*(1-subpar(i,r)) + sum(k,thetac(k,r)*incpar(k,r)*subpar(k,r))) / 
	sum(k,thetac(k,r)*incpar(k,r));

*	The Allen-Uzawa matrix of own- and cross-price elasticities
*	of substitution:

aues(i,j,r)$(not (thetac(i,r) and thetac(j,r))) = 0;
aues(i,j,r)$(thetac(i,r) and thetac(j,r)) = subpar(i,r) + subpar(j,r) 
		- sum(k,thetac(k,r)*subpar(k,r))
		- (subpar(i,r)/thetac(i,r))$sameas(i,j);

*	Include GDP and population forecast data:

set		fyr	Years in the GDP and population forecast /2010*2030/
		fitem	Forecast items /gdp, pop/;

parameter	forecast(r,fitem,fyr)	GTAP regional population and GDP forecast;

$gdxin %system.fp%..%fs%forecasts%fs%usda%fs%forecast%gtapv%.gdx
$loaddc forecast

set		vtcomp /ad	"Anti-dumping duty",
			mfa	"Export tax equivalent of MFA quota premia",
			pu	"Export tax equivalent of price undertakings",
			ver	"Export tax equivalent of voluntary export restraints",
			xt	"Ordinary export tax"
			tarif	"Ordinary import duty",
			adv	"Import tariff revenue - levied on an ad-valorem basis",
			spe	"Import tariff revenue - levied on a specific basis" /

parameter	vtrev(vtcomp,i,r,s)	All components of import and export taxes;
vtrev("tarif",i,r,s) = tfrv(i,r,s)/1000;

vtrev("ad",i,r,s)    = adrev(i,r,s)/1000;
vtrev("mfa",i,r,s)   = mfarev(i,r,s)/1000;
vtrev("pu",i,r,s)    = purev(i,r,s)/1000;
vtrev("ver",i,r,s)   = verrev(i,r,s)/1000;
vtrev("xt",i,r,s)    = xtrev(i,r,s)/1000;
vtrev(ttype,i,r,s)   = tfrvsa(ttype,i,r,s)/1000;

set	metadata(*,*,*)	Dataset information;
metadata("flex2gdx","date","%system.date%") = yes;
metadata("flex2gdx","time","%system.time%") = yes;
metadata("flex2gdx","filesys","%system.filesys%") = yes;
metadata("flex2gdx","username","%system.username%") = yes;
metadata("flex2gdx","computername","%system.computername%") = yes;
metadata("flex2gdx","gamsversion","%system.gamsversion%") = yes;
metadata("flex2gdx","program","%system.fp%%system.fn%%system.fe%")   = yes;
metadata("flex2gdx","input","%flexaggdatafile%") = yes;
metadata("flex2gdx","output","%datadir%gsd.gdx") = yes;
option metadata:0:0:1;
display metadata;

$if not dexist "%datadir%" $call mkdir "%datadir%"
execute_unload '%datadir%gsd.gdx',
		r, f, gg=g, ii=i,  vfm, 
		vdfm, vifm, vxmd, vst, vtwr, vtrev,
		rto, rtf, rtfd, rtfi, rtxs, rtms, 
		esubd, esubva, esubm, etrae, esubt,
		eta, aues, incpar, subpar, 
		pop, evd, evi, evt, eco2d, eco2i, forecast, metadata;

$exit

$label missinggdxfiles
$log	
$log	*** Error *** Missing GDX files.
$log	
$log	Reading from FLEXAGG archive %flexaggdatafile%.
$log
$log	The following GDX files (translations from HAR) are missing:
$if not exist %tmpdir%gsdset.gdx	$log	%tmpdir%gsdset.gdx
$if not exist %tmpdir%gsddat.gdx	$log	%tmpdir%gsddat.gdx
$if not exist %tmpdir%gsdpar.gdx	$log	%tmpdir%gsdpar.gdx
$if not exist %tmpdir%gsdvole.gdx	$log	%tmpdir%gsdvole.gdx
$if not exist %tmpdir%gsdemiss.gdx	$log	%tmpdir%gsdemiss.gdx
*.$log		har2gdx "%gams.scrdir%gsdtax.har" "%gams.scrdir%gsdtax.gdx"
$log	

*	*** Error *** Missing GDX files.
*
*	Reading from FLEXAGG archive %flexaggdatafile%.
*
*	The following GDX files (translations from HAR) are missing:
$if not exist %tmpdir%gsdset.gdx	*	%tmpdir%gsdset.gdx
$if not exist %tmpdir%gsddat.gdx	*	%tmpdir%gsddat.gdx
$if not exist %tmpdir%gsdpar.gdx	*	%tmpdir%gsdpar.gdx
$if not exist %tmpdir%gsdvole.gdx	*	%tmpdir%gsdvole.gdx
$if not exist %tmpdir%gsdemiss.gdx	*	%tmpdir%gsdemiss.gdx


$abort "Error -- see listing file."
