$title	Translate GTAP 9 Distribution Data into GTAPinGAMS Format


$if not set yr		$set yr 2011

*	Use the GAMS scratch directory to hold temporary files:

$set tmpdir %gams.scrdir%

set	ii	Commodities in GTAP 9 nomenclature/
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

set	r	Regions in GTAP 9 /

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


set	ff(*)	Factors in GTAP 9 nomenclature /
	land		"Land"
	tech_aspros	"Technicians/AssocProfessional"
	clerks		"Clerks"
	service_shop	"Service/Shop workers"
	off_mgr_pros	"Officials and Managers"
	ag_othlowsk	"Agricultural and Unskilled"
	capital		"Capital"
	natlres		"Natural Resources" /;

$call gmsunzip -j %system.fp%/gtap9/%yr%/flexagg9a.zip -d %tmpdir%

*	Read these sets to verify that they are consistent:

set	rdomain(r),idomain(ii),fdomain(ff);

$gdxin '%tmpdir%gsdset.gdx'
$loaddc rdomain=reg idomain=PROD_COMM fdomain=ENDW_COMM

abort$(card(rdomain)<>card(r))	 "Set r  on gsdset.gdx is inconsistent.", rdomain, r;
abort$(card(idomain)<>card(ii)) "Set ii on gsdset.gdx is inconsistent.",  idomain, ii;
abort$(card(fdomain)<>card(ff))	 "Set ff on gsdset.gdx is inconsistent.", fdomain, ff;

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
	lea, lum, ppp, oil, crp, nmm, i_s, nfm, fmp, eeq, ome,
	mvh, otn, omf, ele, gdt, wtr, cns, trd, otp, wtp, atp, cmn,
	ofi, ins, obs, ros, osg, dwe /;

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
	crp	"Chemicals, pharmaceuticals, rubber, plastic prods",
*.	chm 	"Chemical products",
*.	bph 	"Basic pharmaceutical products",
*.	rpp 	"Rubber and plastic products",
	nmm 	"Mineral products nec",
	i_s 	"Ferrous metals",
	nfm 	"Metals nec",
	fmp 	"Metal products",
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
*.	afs 	"Accommodation, Food and service activities",
	otp 	"Transport nec",
	wtp 	"Water transport",
	atp 	"Air transport",
*.	whs 	"Warehousing and support activities",
	cmn 	"Communication",
	ofi 	"Financial services nec",
	ins 	"Insurance (formerly isr)",
*.	rsa 	"Real estate activities",
	obs 	"Business services nec",
	ros 	"Recreational and other services",
	osg 	"Public Administration and defense",
*.	edu 	"Education",
*.	hht 	"Human health and social work activities",
	dwe 	"Dwellings" /;

*	The only names changes here are those which conform to the
*	GTAPinGAMS conventions for energy goods:

*	oil.cru	! "Crude Oil",
*	coa.col	! "Coal",
*	p_c.oil	! "Petroleum, coal products",
*	ely.ele	! "Electricity",
*	ele.eeq	! "Computer, electronic and optical products",

SET mapi(ii,i) Mapping of Sectors and Goods (from-to) /
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
	omn.oxt 	"Other Extraction (formerly omn - minerals nec)",
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
	crp.crp		"Chemicals, pharmaceuticals, rubber, plastic prods",
*.	chm.chm 	"Chemical products",
*.	bph.bph 	"Basic pharmaceutical products",
*.	rpp.rpp 	"Rubber and plastic products",
	nmm.nmm 	"Mineral products nec",
	i_s.i_s 	"Ferrous metals",
	nfm.nfm 	"Metals nec",
	fmp.fmp 	"Metal products",
	ele.eeq 	"Electrical equipment",
	ome.ome 	"Machinery and equipment nec",
	mvh.mvh 	"Motor vehicles and parts",
	otn.otn 	"Transport equipment nec",
	omf.omf 	"Manufactures nec",
	ely.ele 	"Electricity",
	gdt.gdt 	"Gas manufacture, distribution",
	wtr.wtr 	"Water",
	cns.cns 	"Construction",
	trd.trd 	"Trade",
*.	afs.afs 	"Accommodation, Food and service activities",
	otp.otp 	"Transport nec",
	wtp.wtp 	"Water transport",
	atp.atp 	"Air transport",
*.	whs.whs 	"Warehousing and support activities",
	cmn.cmn 	"Communication",
	ofi.ofi 	"Financial services nec",
	isr.ins 	"Insurance (formerly isr)",
*.	rsa.rsa 	"Real estate activities",
	obs.obs 	"Business services nec",
	ros.ros 	"Recreational and other services",
	osg.osg 	"Public Administration and defense",
*.	edu.edu 	"Education",
*.	hht.hht 	"Human health and social work activities",
	dwe.dwe 	"Dwellings" 
/;

alias (i,j), (ii,jj), (mapi,mapj);

set	mapij(ii,jj,i,j)	Two-dimensional mapping;
mapij(ii,jj,i,j) = (mapi(ii,i) and mapj(jj,j));

set	ttype	Tariff type /
		adv	Ad-valorem,
		spe	Specific /;

alias (r,s);

parameters
	dpsm(r)		"Sum of distribution parameters in household demand system",
	evfa(ff,ii,r)	"Primary factor purchases, at agents' prices",
	evoa(ff,r)	"Primary factor sales, at agents' prices",
	fbep(ff,ii,r)	"Gross factor-based subsidies",
	ftrv(ff,ii,r)	"Gross factor employment tax revenue",
	isep(ii,jj,r,*)	"Net intermediate input subsidies",
	osep(ii,r)	"Net ordinary output subsidy",
	pop(r)		"Population",
	save(r)		"Net saving, by region",
	tvom(ii,r)	"Sales of domestic product, at market prices",
	vdep(r)		"Capital depreciation",

	vdfm_(ii,jj,r)	"Domestic purchases, by firms, at market prices",
	vifm_(ii,jj,r)	"Import purchases, by firms, at market prices",
	vst_(ii,r)	"Margin exports",

	vdfa(ii,jj,r)	"Domestic purchases, by firms, at agents' prices",

	vdga(ii,r)	"Domestic purchases, by government, at agents' prices",
	vdgm(ii,r)	"Domestic purchases, by government, at market prices",

	vdpa(ii,r)	"Domestic purchases, by households, at agents' prices",
	vdpm(ii,r)	"Domestic purchases, by households, at market prices",

	vfm_(ff,ii,r)	"Primary factor purchases, by firms, at market prices",

	vifa(ii,jj,r)	"Import purchases, by firms, at agents' prices",
	viga(ii,r)	"Import purchases, by government, at agents' prices",

	vigm(ii,r)	"Import purchases, by government, at market prices",
	vims(ii,r,s)	"Imports, at market prices",
	vipa(ii,r)	"Import purchases, by households, at agents' prices",
	vipm(ii,r)	"Import purchases, by households, at market prices",
	viws(ii,r,s)	"Imports, at world prices",
	vkb(r)		"Capital stock",

	vtwr_(ii,jj,r,s) "Margins by margin commodity",
	vxmd_(ii,r,s)	"Non-margin exports, at market prices",
	vxwd(ii,r,s)	"Non-margin exports, at world prices",

	adrev(ii,r,s)		"Anti-dumping duty",
	mfarev(ii,r,s)		"Export tax equivalent of MFA quota premia",
	purev(ii,r,s)		"Export tax equivalent of price undertakings",
	tfrv(ii,r,s)		"Ordinary import duty",
	verrev(ii,r,s)		"Export tax equivalent of voluntary export restraints",
	xtrev(ii,r,s)		"Ordinary export tax"
	tfrvsa(ttype,ii,r,s)	"Import tariff rev by type of tariffs paid";

$gdxin '%tmpdir%gsddat.gdx'
$loaddc dpsm evfa evoa fbep ftrv isep  osep pop  save 
$loaddc tvom vdep vdfa vdfm_=vdfm vdga vdgm vdpa vdpm vfm_=vfm vifa vifm_=vifm viga vigm vims vipa
$loaddc vipm viws vkb vst_=vst vxmd_=vxmd vxwd 
$loaddc adrev mfarev purev tfrv=tarifrev
$loaddc verrev tfrvsa xtrev vtwr_=vtwrini

parameter
	vxmd(i,r,s)	"Non-margin exports, at market prices",
	vtwr(i,j,r,s)	"Trade margins",
	rtxs(i,r,s)	"Export subsidy rate"
	rtms(i,r,s)	"Import tariff rate"

	vdfm(i,g,r)	"Domestic purchases, by firms, at market prices",
	vifm(i,g,r)	"Import purchases, by firms, at market prices",
	vfm(f,g,r)	"Primary factor purchases, by firms, at market prices",

	rtfd(i,g,r)	"Taxes on firms' domestic purchases - % ad valorem rate,"
	rtfi(i,g,r)	"Taxes on firms' imports purchases -- % ad valorem rate",
	rtf(f,i,r)	"Taxes on primary factors - % ad valorem rate,",

	rto(g,r)	"Tax rate on output (gross basis)"

	vst(i,r)	"Margin exports";

vxmd(i,r,s)   = sum(mapi(ii,i),vxmd_(ii,r,s));
vtwr(i,j,r,s) = sum(mapij(ii,jj,i,j),vtwr_(ii,jj,r,s));

*	Change the sign of export taxes as export subsidies:

rtxs(i,r,s)$vxmd(i,r,s) = -sum(mapi(ii,i),vxwd(ii,r,s))/vxmd(i,r,s)-1;

rtms(i,r,s)$vxmd(i,r,s) = sum(mapi(ii,i),vims(ii,r,s))/sum(mapi(ii,i),viws(ii,r,s))-1;

vdfm(i,j,r) = sum(mapij(ii,jj,i,j),vdfm_(ii,jj,r));
vdfm(i,"c",r) = sum(mapi(ii,i),vdpm(ii,r));
vdfm(i,"g",r) = sum(mapi(ii,i),vdgm(ii,r));
vdfm(i,"i",r) = sum(mapi(ii,i),vdfm_(ii,"cgds",r));

rtfd(i,j,r)$vdfm(i,j,r) = sum(mapij(ii,jj,i,j),vdfa(ii,jj,r))/vdfm(i,j,r) - 1;
rtfd(i,"c",r)$vdfm(i,"c",r) = sum(mapi(ii,i),vdpa(ii,r))/vdfm(i,"c",r);
rtfd(i,"g",r)$vdfm(i,"g",r) = sum(mapi(ii,i),vdga(ii,r))/vdfm(i,"g",r);
rtfd(i,"i",r)$vdfm(i,"i",r) = sum(mapi(ii,i),vdfa(ii,"cgds",r))/vdfm(i,"i",r) - 1;

vifm(i,j,r) = sum(mapij(ii,jj,i,j),vifm_(ii,jj,r));
vifm(i,"c",r) = sum(mapi(ii,i),vipm(ii,r));
vifm(i,"g",r) = sum(mapi(ii,i),vigm(ii,r));
vifm(i,"i",r) = sum(mapi(ii,i),vifm_(ii,"cgds",r));

rtfi(i,j,r)$vifm(i,j,r) = sum(mapij(ii,jj,i,j),vifa(ii,jj,r))/vifm(i,j,r) - 1;
rtfi(i,"c",r)$vifm(i,"c",r) = sum(mapi(ii,i),vipa(ii,r))/vifm(i,"c",r);
rtfi(i,"g",r)$vifm(i,"g",r) = sum(mapi(ii,i),viga(ii,r))/vifm(i,"g",r);
rtfi(i,"i",r)$vifm(i,"i",r) = sum(mapi(ii,i),vifa(ii,"cgds",r))/vifm(i,"i",r) - 1;

vfm(f,i,r) = sum((mapf(ff,f),mapi(ii,i)),vfm_(ff,ii,r));
rtf(f,j,r)$vfm(f,j,r) = sum((mapf(ff,f),mapj(jj,j)),evfa(ff,jj,r))/vfm(f,j,r) - 1;

vst(i,r) = sum(mapi(ii,i),vst_(ii,r));

rto(j,r) = 1 - ( sum(i,vdfm(i,j,r)*(1+rtfd(i,j,r)) + vifm(i,j,r)*(1+rtfi(i,j,r)))
	+  sum(f,vfm(f,j,r)*(1+rtf(f,j,r))) ) /
		( vst(j,r) + sum(s,vxmd(j,r,s)) + sum(g,vdfm(j,g,r)) );

parameter
	edf(ii,jj,r)	"Usage of domestic product by firms, Mtoe",
	edg(ii,r)	"Government consumption of domestic product, Mtoe",
	edp(ii,r)	"Private consumption of domestic product, Mtoe",
	eif(ii,jj,r)	"Usage of imports by firms, Mtoe",
	eig(ii,r)	"Government consumption of imports, Mtoe",
	eip(ii,r)	"Private consumption of imports, Mtoe";

*	GTAP is unable to include energy data for 2004, so we skip
*	those data files if the file is not found.

$gdxin "%tmpdir%gsdvole.gdx"
$loaddc edf edg edp eif eig eip 

parameters
	evd(i,g,r)	Domestic energy use (mtoe),
	evi(i,g,r)	Imported energy use (mtoe);

evd(i,j,r)   = sum(mapij(ii,jj,i,j),edf(ii,jj,r));
evd(i,"c",r) = sum(mapi(ii,i),edp(ii,r));
evd(i,"g",r) = sum(mapi(ii,i),edg(ii,r));
evi(i,j,r)   = sum(mapij(ii,jj,i,j),eif(ii,jj,r));
evi(i,"c",r) = sum(mapi(ii,i),eip(ii,r));
evi(i,"g",r) = sum(mapi(ii,i),eig(ii,r));

parameter
	mdf(ii,jj,r)	'Emissions from domestic product in current production, Mt CO2',
	mdg(ii,r)	'Emissions from govt consumption of domestic product, Mt CO2',
	mdp(ii,r)	'Emissions from private consumption of domestic product, Mt CO2',
	mif(ii,jj,r)	'Emissions from imports in current production, Mt CO2',
	mig(ii,r)	'Emissions from government consumption of imports, Mt CO2',
	mip(ii,r)	'Emissions from private consumption of imports, Mt CO2';

$gdxin '%tmpdir%gsdemiss.gdx'
$loaddc mdf mdg mdp mif mig mip

parameter
	eco2d(i,g,r)	"CO2 emissions from domestic product (Mt)"
	eco2i(i,g,r)	"CO2 Emissions from imported product (Mt)";

eco2d(i,j,r) = sum(mapij(ii,jj,i,j), mdf(ii,jj,r));
eco2i(i,j,r) = sum(mapij(ii,jj,i,j), mif(ii,jj,r));

eco2d(i,"c",r) = sum(mapi(ii,i),mdp(ii,r));
eco2i(i,"c",r) = sum(mapi(ii,i),mip(ii,r));

eco2d(i,"g",r) = sum(mapi(ii,i),mdg(ii,r));
eco2i(i,"g",r) = sum(mapi(ii,i),mig(ii,r));

eco2d(i,"i",r) = sum(mapi(ii,i),mdf(ii,"cgds",r));
eco2i(i,"i",r) = sum(mapi(ii,i),mif(ii,"cgds",r));

parameter	
	esubd_(ii)	"Elasticity of domestic-import substitution",
	esubm_(ii)	"Elasticity of import source substitution",
	esubt_(ii)	"Elasticity of top-level input substitution",
	esubva_(ii)	"Elasticity of factor substitution",
	etrae_(ff)	"Elasticity of transformation for sluggish endowments",
	incpar_(ii,r)	"Expansion parameter in the CDE minimum expenditure function",
	subpar_(ii,r)	"Substitution parameter in CDE minimum expenditure function",
	rorflex(r)	"Flexibility of expected net ROR wrt investment";

$gdxin '%tmpdir%gsdpar.gdx'
$loaddc esubd_=esubd esubm_=esubm esubt_=esubt esubva_=esubva etrae_=etrae incpar_=incpar rorflex subpar_=subpar

parameter	
	esubdm(i)	"Elasticity of domestic-import substitution",
	esubm(i)	"Elasticity of import source substitution",
	esubt(i)	"Elasticity of top-level input substitution",
	esubva(i)	"Elasticity of factor substitution",
	etaf(f)		"Elasticity of transformation for sluggish endowments",
	incp(i,r)	"Expansion parameter in the CDE minimum expenditure function",
	subp(i,r)	"Substitution parameter in CDE minimum expenditure function";

esubdm(i) = sum(mapi(ii,i),esubd_(ii));
esubm(i) = sum(mapi(ii,i),esubm_(ii));
esubt(i) = sum(mapi(ii,i),esubt_(ii));
esubva(i) = sum(mapi(ii,i),esubva_(ii));

*	Convert sign of etrae so that it is interpreted as
*	non-negative elasticity of transformation:

etaf(f) = -sum(mapf(ff,f),etrae_(ff));

incp(i,r) = sum(mapi(ii,i),incpar_(ii,r));
subp(i,r) = sum(mapi(ii,i),subpar_(ii,r));

set	sf(f)	Sluggish primary factors (sector-specific)
	mf(f)	Mobile primary factors;

sf(f) = yes$(etaf(f)<>0);
mf(f) = yes$(not sf(f));

*	-------------------------------------------------------------------
*	Scale economic data from millions to billions of dollars:

vfm(f,i,r)    = vfm(f,i,r)/1000;
vdfm(i,g,r)   = vdfm(i,g,r)/1000;
vifm(i,g,r)   = vifm(i,g,r)/1000;
vxmd(i,r,s)   = vxmd(i,r,s)/1000;
vst(i,r)      = vst(i,r)/1000;
vtwr(i,j,r,s) = vtwr(i,j,r,s)/1000;

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


set	vtcomp	/	ad	"Anti-dumping duty",
			mfa	"Export tax equivalent of MFA quota premia",
			pu	"Export tax equivalent of price undertakings",
			ver	"Export tax equivalent of voluntary export restraints",
			xt	"Ordinary export tax"
			tarif	"Ordinary import duty",
			adv	"Import tariff revenue - levied on an ad-valorem basis",
			spe	"Import tariff revenue - levied on a specific basis" /

parameter	vtrev(vtcomp,i,r,s)	All components of import and export taxes;
vtrev("tarif",i,r,s) = sum(mapi(ii,i),tfrv(ii,r,s))/1000;
vtrev("ad",i,r,s)    = sum(mapi(ii,i),adrev(ii,r,s))/1000;
vtrev("mfa",i,r,s)   = sum(mapi(ii,i),mfarev(ii,r,s))/1000;
vtrev("pu",i,r,s)    = sum(mapi(ii,i),purev(ii,r,s))/1000;
vtrev("ver",i,r,s)   = sum(mapi(ii,i),verrev(ii,r,s))/1000;
vtrev("xt",i,r,s)    = sum(mapi(ii,i),xtrev(ii,r,s))/1000;
vtrev(vtcomp(ttype),i,r,s)   = sum(mapi(ii,i),tfrvsa(ttype,ii,r,s))/1000;

set	metadata	Information about the dataset aggregation /
	gtapversion	"11",
	gtapdate	"MAR2023",
	rundate		"%system.date%",
	filesys		"%system.filesys%",
	username	"%system.username%",
	computername	"%system.computername%",
	gamsversion	"%system.gamsversion%",
	gamsprogram	"%system.fp%/%system.fn%%system.fe%"/;

option metadata:0:0:1;
display metadata;

execute_unload '%system.fp%/gtap9/%yr%%system.dirsep%gtapingams.gdx',
		r, f, g, i,  vfm, 
		vdfm, vifm, vxmd, vst, vtwr, vtrev,
		rto, rtf, rtfd, rtfi, rtxs, rtms, 
		esubdm, esubva, etaf, esubt,
*	esubm, 
		eta, aues, incp, subp, 
		pop, evd, evi, eco2d, eco2i, metadata;


