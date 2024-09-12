$title	Read the SAINC datasets

*	https://apps.bea.gov/regional/downloadzip.htm

parameter
*	---------------------- Labor market data -- could be useful
	d_5n	"Personal income by major component and earnings by NAICS industry",
	d_6N	"Compensation of employees by NAICS industry",
	d_7N	"Wages and salaries by industry (NAICS)",
	d_25N	"Total full-time and part-time employment by NAICS industry",
	d_27N	"Full-time and part-time wage and salary employment by NAICs industry",
*	----------------------  Summary data -- could be useful
	d_1	"State annual personal income summary: personal income, population, per capita personal income",
	d_4	"Personal income and employment by major component",
	d_30	"Economic profile",
	d_35	"Personal current transfer receipts",
	d_40	"Property income",
	d_45	"Farm income and expenses",
	d_50	"Personal current taxes",
	d_51	"State annual disposable personal income summary: disposable personal income, population, and per capita disposable personal income",
	d_5H	"Personal income by major component and earnings by industry (historical)",
	d_70	"Transactions of state and local government defined benefit pension plans",
	d_91	"Gross flow of earnings",
*	----------------------	SIC and historical data -- not used.
	d_5S	"Personal income by major component and earnings by SIC industry",
	d_6S	"Compensation of employees by SIC industry",
	d_7H	"Wages and salaries by industry (historical)",
	d_7S	"Wages and salaries by industry (SIC)",
	d_25S	"Total full-time and part-time employment by SIC industry";


set	seq /0*3000/;
set	yr /1900*2024/,	row /r1*r2000/;

set	s(*)	States (USPS codes)

set	rmap(s<,*) /
	AL."Alabama",
	AK."Alaska",
	AR."Arizona",
	AZ."Arkansas",
	CA."California",
	CO."Colorado",
	CT."Connecticut",
	DC."District of Columbia",
	DE."Delaware",
	FL."Florida",
	GA."Georgia",
	HI."Hawaii",
	IA."Iowa",
	ID."Idaho",
	IL."Illinois",
	IN."Indiana",
	KS."Kansas",
	KY."Kentucky",
	LA."Louisiana",
	MA."Massachusetts",
	MD."Maryland",	
	ME."Maine",
	MI."Michigan",
	MN."Minnesota",
	MO."Missouri",
	MS."Mississippi",	
	MT."Montana",
	NC."North Carolina",
	ND."North Dakota",
	NE."Nebraska",
	NH."New Hampshire",
	NJ."New Jersey",
	NM."New Mexico",
	NV."Nevada",
	NY."New York",
	OH."Ohio",
	OK."Oklahoma",
	OR."Oregon",
	PA."Pennsylvania",
	RI."Rhode Island",
	SC."South Carolina",
	SD."South Dakota",
	TN."Tennessee",
	TX."Texas",
	UT."Utah",
	VA."Virginia",
	VT."Vermont",
	WA."Washington",
	WV."West Virginia",
	WI."Wisconsin",
	WY."Wyoming"/;

alias (u,*);

$onechov >%gams.scrdir%readtable.gms

$eval lc %lyr%-%fyr%+9
$call csv2gdx i=sainc\%prefix%%t%__ALL_AREAS_%fyr%_%lyr%.csv o=sainc\%t%.gdx id=v index=2,5 useheader=y values=9..%lc% >sainc\%t%.log
$call csv2gdx i=sainc\%prefix%%t%__ALL_AREAS_%fyr%_%lyr%.csv o=sainc\%t%_rows.gdx id=iv index=5,6 autorow=r text=7 useheader=y >sainc\%t%_rows.log

set	i_%t%(*), j_%t%(*), iv_%t%(row,i_%t%<,j_%t%<), k_%t%(i_%t%,j_%t%);
$gdxin sainc\%t%_rows.gdx
$load iv_%t%=iv
loop(iv_%t%(row,i_%t%,j_%t%),k_%t%(i_%t%,j_%t%) = iv_%t%(row,i_%t%,j_%t%););
option k_%t%:0:0:1; display k_%t%;

set	r_%t%(*);

parameter	v_%t%(r_%t%<,i_%t%,yr)  "%title%";
$gdxin sainc\%t%.gdx
$onUNDF
$loaddc v_%t%=v

option r_%t%:0:0:1;
*.display r_%t%;

parameter	d_%t%(s,i_%t%,yr)	"%title%";
d_%t%(s,i_%t%,yr) = sum(rmap(s,r_%t%),v_%t%(r_%t%,i_%t%,yr));

$offecho

$set t 25N
$set title Total full-time and part-time employment by NAICS industry
$set fyr 1998
$set lyr 2022
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      25S
$set title Total full-time and part-time employment by SIC industry
$set fyr    1969
$set lyr    2001
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      27N
$set title Full-time and part-time wage and salary employment by NAICs industry
$set fyr    1998
$set lyr    2022
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      27S
$set title Full-time and part-time wage and salary employment by SIC industry
$set fyr    1969
$set lyr    2001
$set prefix SAEMP
$batinclude %gams.scrdir%readtable 

$set t      1
$set title  State annual personal income summary: personal income, population, per capita personal income
$set fyr    1929
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      30
$set title Economic profile
$set fyr    1958
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      35
$set title  Personal current transfer receipts
$set fyr    1929
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      40
$set title  Property income
$set fyr    1958
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      45
$set title  Farm income and expenses
$set fyr    1969
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      4
$set title  Personal income and employment by major component
$set fyr    1929
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      50
$set title  Personal current taxes
$set fyr    1948
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      51
$set title  State annual disposable personal income summary: disposable personal income, population, and per capita disposable personal income
$set fyr    1948
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5H
$set title  Personal income by major component and earnings by industry (historical)
$set fyr    1929
$set lyr    1957
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5n
$set title  Personal income by major component and earnings by NAICS industry
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      5S
$set title  Personal income by major component and earnings by SIC industry
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      6N
$set title  Compensation of employees by NAICS industry
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      6S
$set title  Compensation of employees by SIC industry
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      70
$set title  Transactions of state and local government defined benefit pension plans
$set fyr    2000
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7H
$set title  Wages and salaries by industry (historical)
$set fyr    1929
$set lyr    1957
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7N
$set title  Wages and salaries by industry (NAICS)
$set fyr    1998
$set lyr    2023
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      7S
$set title  Wages and salaries by industry (SIC)
$set fyr    1958
$set lyr    2001
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$set t      91
$set title  Gross flow of earnings
$set fyr    1990
$set lyr    2022
$set prefix SAINC
$batinclude %gams.scrdir%readtable 

$exit

parameter
	d_5n(s,i_5n,yr)		"Personal income by major component and earnings by NAICS industry",
	d_6N(s,i_6N,yr)		"Compensation of employees by NAICS industry",
	d_7N(s,i_7N,yr)		"Wages and salaries by industry (NAICS)",
	d_25N(s,i_25N,yr)	"Total full-time and part-time employment by NAICS industry",
	d_27N(s,i_27N,yr)	"Full-time and part-time wage and salary employment by NAICs industry",

	d_1(s,i_1,yr)		"State annual personal income summary: personal income, population, per capita personal income",
	d_4(s,i_4,yr)		"Personal income and employment by major component",
	d_5S(s,i_5S,yr)		"Personal income by major component and earnings by SIC industry",
	d_6S(s,i_6S,yr)		"Compensation of employees by SIC industry",
	d_7H(s,i_7H,yr)		"Wages and salaries by industry (historical)",
	d_7S(s,i_7S,yr)		"Wages and salaries by industry (SIC)",
	d_25S(s,i_25S,yr)	"Total full-time and part-time employment by SIC industry",
	d_27N(s,i_27N,yr)	"Full-time and part-time wage and salary employment by NAICs industry",
	d_30(s,i_30,yr)		"Economic profile",
	d_35(s,i_35,yr)		"Personal current transfer receipts",
	d_40(s,i_40,yr)		"Property income",
	d_45(s,i_45,yr)		"Farm income and expenses",
	d_50(s,i_50,yr)		"Personal current taxes",
	d_51(s,i_51,yr)		"State annual disposable personal income summary: disposable personal income, population, and per capita disposable personal income",
	d_5H(s,i_5H,yr)		"Personal income by major component and earnings by industry (historical)",
	d_70(s,i_70,yr)		"Transactions of state and local government defined benefit pension plans",
	d_91(s,i_91,yr)		"Gross flow of earnings";

set	id(*) /
	trn      Rail transportation (482000)
	ORE      Other real estate (531ORE)
	oil      Oil and gas extraction (211000)
	mvt      Motor vehicle and parts dealers (441000)
	fbt      Food and beverage stores (445000)
	gmt      General merchandise stores (452000)
	air      Air transportation (481000)
	wtt      Water transportation (483000)
	trk      Truck transportation (484000)
	grd      Transit and ground passenger transportation (485000)
	pip      Pipeline transportation (486000)
	wrh      Warehousing and storage (493000)
	fin      "Funds, trusts, and other financial vehicles (525000)"
	leg      Legal services (541100)
	man      Management of companies and enterprises (550000)
	wst      Waste management and remediation services (562000)
	hos      Hospitals (622000)
	amd      Accommodation (721000)
	fdd      Federal general government (defense) (S00500)
	fnd      Federal general government (nondefense) (S00600)
	osd_agr  Oilseed farming (1111A0)
	grn_agr  Grain farming (1111B0)
	veg_agr  Vegetable and melon farming (111200)
	nut_agr  Fruit and tree nut farming (111300)
	flo_agr  "Greenhouse, nursery, and floriculture production (111400)"
	oth_agr  Other crop farming (111900)
	dry_agr  Dairy cattle and milk production (112120)
	bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)"
	egg_agr  Poultry and egg production (112300)
	ota_agr  "Animal production, except cattle and poultry and eggs (112A00)"
	log_fof  Forestry and logging (113000)
	fht_fof  "Fishing, hunting and trapping (114000)"
	saf_fof  Support activities for agriculture and forestry (115000)
	col_min  Coal mining (212100)
	led_min  "Copper, nickel, lead, and zinc mining (212230)"
	ore_min  "Iron, gold, silver, and other metal ore mining (2122A0)"
	stn_min  Stone mining and quarrying (212310)
	oth_min  Other nonmetallic mineral mining and quarrying (2123A0)
	drl_smn  Drilling oil and gas wells (213111)
	oth_smn  Other support activities for mining (21311A)
	ele_uti  "Electric power generation, transmission, and distribution (221100)"
	gas_uti  Natural gas distribution (221200)
	wat_uti  "Water, sewage and other systems (221300)"
	hcs_con  Health care structures (233210)
	edu_con  Educational and vocational structures (233262)
	nmr_con  Nonresidential maintenance and repair (230301)
	rmr_con  Residential maintenance and repair (230302)
	off_con  Office and commercial structures (2332A0)
	mrs_con  Multifamily residential structures (233412)
	ors_con  Other residential structures (2334A0)
	mfs_con  Manufacturing structures (233230)
	ons_con  Other nonresidential structures (2332D0)
	pwr_con  Power and communication structures (233240)
	srs_con  Single-family residential structures (233411)
	trn_con  Transportation structures and highways and streets (2332C0)
	saw_wpd  Sawmills and wood preservation (321100)
	ven_wpd  "Veneer, plywood, and engineered wood product manufacturing (321200)"
	mil_wpd  Millwork (321910)
	owp_wpd  All other wood product manufacturing (3219A0)
	cly_nmp  Clay product and refractory manufacturing (327100)
	gla_nmp  Glass and glass product manufacturing (327200)
	cmt_nmp  Cement manufacturing (327310)
	cnc_nmp  Ready-mix concrete manufacturing (327320)
	cpb_nmp  "Concrete pipe, brick, and block manufacturing (327330)"
	ocp_nmp  Other concrete product manufacturing (327390)
	lme_nmp  Lime and gypsum product manufacturing (327400)
	abr_nmp  Abrasive product manufacturing (327910)
	cut_nmp  Cut stone and stone product manufacturing (327991)
	tmn_nmp  Ground or treated mineral and earth manufacturing (327992)
	wol_nmp  Mineral wool manufacturing (327993)
	mnm_nmp  Miscellaneous nonmetallic mineral products (327999)
	irn_pmt  Iron and steel mills and ferroalloy manufacturing (331110)
	stl_pmt  Steel product manufacturing from purchased steel                        (331200)
	ala_pmt  Alumina refining and primary aluminum production (331313)
	alu_pmt  Aluminum product manufacturing from purchased aluminum (33131B)
	nms_pmt  Nonferrous metal (except aluminum) smelting and refining (331410)
	cop_pmt  "Copper rolling, drawing, extruding and alloying (331420)"
	nfm_pmt  "Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)"
	fmf_pmt  Ferrous metal foundries (331510)
	nff_pmt  Nonferrous metal foundries (331520)
	rol_fmt  Custom roll forming (332114)
	fss_fmt  "All other forging, stamping, and sintering (33211A)"
	crn_fmt  "Metal crown, closure, and other metal stamping (except automotive) (332119)"
	cut_fmt  Cutlery and handtool manufacturing (332200)
	plt_fmt  Plate work and fabricated structural product manufacturing (332310)
	orn_fmt  Ornamental and architectural metal products manufacturing (332320)
	pwr_fmt  Power boiler and heat exchanger manufacturing (332410)
	mtt_fmt  Metal tank (heavy gauge) manufacturing (332420)
	mtc_fmt  "Metal can, box, and other metal container (light gauge) manufacturing (332430)"
	hdw_fmt  Hardware manufacturing (332500)
	spr_fmt  Spring and wire product manufacturing (332600)
	mch_fmt  Machine shops (332710)
	tps_fmt  "Turned product and screw, nut, and bolt manufacturing (332720)"
	ceh_fmt  "Coating, engraving, heat treating and allied activities (332800)"
	plb_fmt  Plumbing fixture fitting and trim manufacturing (332913)
	vlv_fmt  Valve and fittings other than plumbing (33291A)
	bbr_fmt  Ball and roller bearing manufacturing (332991)
	fab_fmt  Fabricated pipe and pipe fitting manufacturing (332996)
	amn_fmt  "Ammunition, arms, ordnance, and accessories manufacturing (33299A)"
	omf_fmt  Other fabricated metal manufacturing (332999)
	frm_mch  Farm machinery and equipment manufacturing (333111)
	lwn_mch  Lawn and garden equipment manufacturing (333112)
	con_mch  Construction machinery manufacturing (333120)
	min_mch  Mining and oil and gas field machinery manufacturing (333130)
	smc_mch  Semiconductor machinery manufacturing (333242)
	oti_mch  Other industrial machinery manufacturing (33329A)
	opt_mch  Optical instrument and lens manufacturing (333314)
	pht_mch  Photographic and photocopying equipment manufacturing (333316)
	oci_mch  Other commercial and service industry machinery manufacturing (333318)
	hea_mch  Heating equipment (except warm air furnaces) manufacturing (333414)
	acn_mch  "Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)"
	air_mch  Industrial and commercial fan and blower and air purification equipment manufacturing (333413)
	imm_mch  Industrial mold manufacturing (333511)
	spt_mch  "Special tool, die, jig, and fixture manufacturing (333514)"
	mct_mch  Machine tool manufacturing (333517)
	cut_mch  "Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)"
	tbn_mch  Turbine and turbine generator set units manufacturing (333611)
	spd_mch  "Speed changer, industrial high-speed drive, and gear manufacturing (333612)"
	mch_mch  Mechanical power transmission equipment manufacturing (333613)
	oee_mch  Other engine equipment manufacturing (333618)
	agc_mch  Air and gas compressor manufacturing (333912)
	ppe_mch  "Measuring, dispensing, and other pumping equipment manufacturing (333914)"
	mat_mch  Material handling equipment manufacturing (333920)
	pwr_mch  Power-driven handtool manufacturing (333991)
	pkg_mch  Packaging machinery manufacturing (333993)
	ipf_mch  Industrial process furnace and oven manufacturing (333994)
	ogp_mch  Other general purpose machinery manufacturing (33399A)
	fld_mch  Fluid power process machinery (33399B)
	ecm_cep  Electronic computer manufacturing (334111)
	csd_cep  Computer storage device manufacturing (334112)
	ctm_cep  Computer terminals and other computer peripheral equipment manufacturing (334118)
	tel_cep  Telephone apparatus manufacturing (334210)
	brd_cep  Broadcast and wireless communications equipment (334220)
	oce_cep  Other communications equipment manufacturing (334290)
	sem_cep  Semiconductor and related device manufacturing (334413)
	prc_cep  Printed circuit assembly (electronic assembly) manufacturing (334418)
	oec_cep  Other electronic component manufacturing (33441A)
	eea_cep  Electromedical and electrotherapeutic apparatus manufacturing (334510)
	sdn_cep  "Search, detection, and navigation instruments manufacturing (334511)"
	aec_cep  Automatic environmental control manufacturing (334512)
	ipv_cep  Industrial process variable instruments manufacturing (334513)
	tfl_cep  Totalizing fluid meter and counting device manufacturing (334514)
	els_cep  Electricity and signal testing instruments manufacturing (334515)
	ali_cep  Analytical laboratory instrument manufacturing (334516)
	irr_cep  Irradiation apparatus manufacturing (334517)
	wcm_cep  "Watch, clock, and other measuring and controlling device manufacturing (33451A)"
	aud_cep  Audio and video equipment manufacturing (334300)
	mmo_cep  Manufacturing and reproducing magnetic and optical media (334610)
	elb_eec  Electric lamp bulb and part manufacturing (335110)
	ltf_eec  Lighting fixture manufacturing (335120)
	sea_eec  Small electrical appliance manufacturing (335210)
	ham_eec  Major household appliance manufacturing (335221)
	pwr_eec  "Power, distribution, and specialty transformer manufacturing (335311)"
	mtg_eec  Motor and generator manufacturing (335312)
	swt_eec  Switchgear and switchboard apparatus manufacturing (335313)
	ric_eec  Relay and industrial control manufacturing (335314)
	sbt_eec  Storage battery manufacturing (335911)
	pbt_eec  Primary battery manufacturing (335912)
	cme_eec  Communication and energy wire and cable manufacturing (335920)
	wdv_eec  Wiring device manufacturing (335930)
	cbn_eec  Carbon and graphite product manufacturing (335991)
	oee_eec  All other miscellaneous electrical equipment and component manufacturing (335999)
	atm_mot  Automobile manufacturing (336111)
	ltr_mot  Light truck and utility vehicle manufacturing (336112)
	htr_mot  Heavy duty truck manufacturing (336120)
	mbd_mot  Motor vehicle body manufacturing (336211)
	trl_mot  Truck trailer manufacturing (336212)
	hom_mot  Motor home manufacturing (336213)
	cam_mot  Travel trailer and camper manufacturing (336214)
	gas_mot  Motor vehicle gasoline engine and engine parts manufacturing (336310)
	eee_mot  Motor vehicle electrical and electronic equipment manufacturing (336320)
	tpw_mot  Motor vehicle transmission and power train parts manufacturing (336350)
	trm_mot  Motor vehicle seating and interior trim manufacturing (336360)
	stm_mot  Motor vehicle metal stamping (336370)
	omv_mot  Other motor vehicle parts manufacturing (336390)
	brk_mot  "Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)"
	air_ote  Aircraft manufacturing (336411)
	aen_ote  Aircraft engine and engine parts manufacturing (336412)
	oar_ote  Other aircraft parts and auxiliary equipment manufacturing (336413)
	mis_ote  Guided missile and space vehicle manufacturing (336414)
	pro_ote  Propulsion units and parts for space vehicles and guided missiles (33641A)
	rrd_ote  Railroad rolling stock manufacturing (336500)
	shp_ote  Ship building and repairing (336611)
	bot_ote  Boat building (336612)
	mcl_ote  "Motorcycle, bicycle, and parts manufacturing (336991)"
	mlt_ote  "Military armored vehicle, tank, and tank component manufacturing (336992)"
	otm_ote  All other transportation equipment manufacturing (336999)
	cab_fpd  Wood kitchen cabinet and countertop manufacturing (337110)
	uph_fpd  Upholstered household furniture manufacturing (337121)
	nup_fpd  Nonupholstered wood household furniture manufacturing (337122)
	ifm_fpd  Institutional furniture manufacturing (337127)
	ohn_fpd  Other household nonupholstered furniture (33712N)
	shv_fpd  "Showcase, partition, shelving, and locker manufacturing (337215)"
	off_fpd  Office furniture and custom architectural woodwork and millwork manufacturing (33721A)
	ofp_fpd  Other furniture related product manufacturing (337900)
	smi_mmf  Surgical and medical instrument manufacturing (339112)
	sas_mmf  Surgical appliance and supplies manufacturing (339113)
	dnt_mmf  Dental equipment and supplies manufacturing (339114)
	oph_mmf  Ophthalmic goods manufacturing (339115)
	dlb_mmf  Dental laboratories (339116)
	jwl_mmf  Jewelry and silverware manufacturing (339910)
	ath_mmf  Sporting and athletic goods manufacturing (339920)
	toy_mmf  "Doll, toy, and game manufacturing (339930)"
	ofm_mmf  Office supplies (except paper) manufacturing (339940)
	sgn_mmf  Sign manufacturing (339950)
	omm_mmf  All other miscellaneous manufacturing (339990)
	dog_fbp  Dog and cat food manufacturing (311111)
	oaf_fbp  Other animal food manufacturing (311119)
	flr_fbp  Flour milling and malt manufacturing (311210)
	wet_fbp  Wet corn milling (311221)
	fat_fbp  Fats and oils refining and blending (311225)
	soy_fbp  Soybean and other oilseed processing (311224)
	brk_fbp  Breakfast cereal manufacturing (311230)
	sug_fbp  Sugar and confectionery product manufacturing (311300)
	fzn_fbp  Frozen food manufacturing (311410)
	can_fbp  "Fruit and vegetable canning, pickling, and drying (311420)"
	chs_fbp  Cheese manufacturing (311513)
	dry_fbp  "Dry, condensed, and evaporated dairy product manufacturing (311514)"
	mlk_fbp  Fluid milk and butter manufacturing (31151A)
	ice_fbp  Ice cream and frozen dessert manufacturing (311520)
	chk_fbp  Poultry processing (311615)
	asp_fbp  "Animal (except poultry) slaughtering, rendering, and processing (31161A)"
	sea_fbp  Seafood product preparation and packaging (311700)
	brd_fbp  Bread and bakery product manufacturing (311810)
	cok_fbp  "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)"
	snk_fbp  Snack food manufacturing (311910)
	tea_fbp  Coffee and tea manufacturing (311920)
	syr_fbp  Flavoring syrup and concentrate manufacturing (311930)
	spc_fbp  Seasoning and dressing manufacturing (311940)
	ofm_fbp  All other food manufacturing (311990)
	pop_fbp  Soft drink and ice manufacturing (312110)
	ber_fbp  Breweries (312120)
	wne_fbp  Wineries (312130)
	why_fbp  Distilleries (312140)
	cig_fbp  Tobacco manufacturing (312200)
	fyt_tex  "Fiber, yarn, and thread mills (313100)"
	fml_tex  Fabric mills (313200)
	txf_tex  Textile and fabric finishing and fabric coating mills (313300)
	rug_tex  Carpet and rug mills (314110)
	lin_tex  Curtain and linen mills (314120)
	otp_tex  Other textile product mills (314900)
	app_alt  Apparel manufacturing (315000)
	lea_alt  Leather and allied product manufacturing (316000)
	plp_ppd  Pulp mills (322110)
	ppm_ppd  Paper mills (322120)
	pbm_ppd  Paperboard mills (322130)
	pbc_ppd  Paperboard container manufacturing (322210)
	ppb_ppd  Paper bag and coated and treated paper manufacturing (322220)
	sta_ppd  Stationery product manufacturing (322230)
	toi_ppd  Sanitary paper product manufacturing (322291)
	opp_ppd  All other converted paper product manufacturing (322299)
	pri_pri  Printing (323110)
	sap_pri  Support activities for printing (323120)
	ref_pet  Petroleum refineries (324110)
	pav_pet  Asphalt paving mixture and block manufacturing (324121)
	shn_pet  Asphalt shingle and coating materials manufacturing (324122)
	oth_pet  Other petroleum and coal products manufacturing (324190)
	ptr_che  Petrochemical manufacturing (325110)
	igm_che  Industrial gas manufacturing (325120)
	sdp_che  Synthetic dye and pigment manufacturing (325130)
	obi_che  Other basic inorganic chemical manufacturing (325180)
	obo_che  Other basic organic chemical manufacturing (325190)
	pmr_che  Plastics material and resin manufacturing (325211)
	srf_che  Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)
	mbm_che  Medicinal and botanical manufacturing (325411)
	phm_che  Pharmaceutical preparation manufacturing (325412)
	inv_che  In-vitro diagnostic substance manufacturing (325413)
	bio_che  Biological product (except diagnostic) manufacturing (325414)
	fmf_che  Fertilizer manufacturing (325310)
	pag_che  Pesticide and other agricultural chemical manufacturing (325320)
	pnt_che  Paint and coating manufacturing (325510)
	adh_che  Adhesive manufacturing (325520)
	sop_che  Soap and cleaning compound manufacturing (325610)
	toi_che  Toilet preparation manufacturing (325620)
	pri_che  Printing ink manufacturing (325910)
	och_che  All other chemical product and preparation manufacturing (3259A0)
	plm_pla  Plastics packaging materials and unlaminated film and sheet manufacturing (326110)
	ppp_pla  "Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)"
	lam_pla  "Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)"
	fom_pla  Polystyrene foam product manufacturing (326140)
	ure_pla  Urethane and other foam product (except polystyrene) manufacturing (326150)
	bot_pla  Plastics bottle manufacturing (326160)
	opm_pla  Other plastics product manufacturing (326190)
	tir_pla  Tire manufacturing (326210)
	rbr_pla  Rubber and plastics hoses and belting manufacturing (326220)
	orb_pla  Other rubber product manufacturing (326290)
	mtv_wht  Motor vehicle and motor vehicle parts and supplies (423100)
	pce_wht  Professional and commercial equipment and supplies (423400)
	hha_wht  Household appliances and electrical and electronic goods (423600)
	mch_wht  "Machinery, equipment, and supplies (423800)"
	odg_wht  Other durable goods merchant wholesalers (423A00)
	dru_wht  Drugs and druggists' sundries (424200)
	gro_wht  Grocery and related product wholesalers (424400)
	pet_wht  Petroleum and petroleum products (424700)
	ndg_wht  Other nondurable goods merchant wholesalers (424A00)
	ele_wht  Wholesale electronic markets and agents and brokers (425000)
	dut_wht  Customs duties (4200ID)
	bui_ott  Building material and garden equipment and supplies dealers (444000)
	hea_ott  Health and personal care stores (446000)
	gas_ott  Gasoline stations (447000)
	clo_ott  Clothing and clothing accessories stores (448000)
	non_ott  Nonstore retailers (454000)
	oth_ott  All other retail (4B0000)
	sce_otr  Scenic and sightseeing transportation and support activities (48A000)
	mes_otr  Couriers and messengers (492000)
	new_pub  Newspaper publishers (511110)
	pdl_pub  Periodical publishers (511120)
	bok_pub  Book publishers (511130)
	mal_pub  "Directory, mailing list, and other publishers (5111A0)"
	sfw_pub  Software publishers (511200)
	pic_mov  Motion picture and video industries (512100)
	snd_mov  Sound recording industries (512200)
	rad_brd  Radio and television broadcasting (515100)
	cbl_brd  Cable and other subscription programming (515200)
	wtl_brd  Wired telecommunications carriers (517110)
	wls_brd  Wireless telecommunications carriers (except satellite) (517210)
	sat_brd  "Satellite, telecommunications resellers, and all other telecommunications (517A00)"
	dpr_dat  "Data processing, hosting, and related services (518200)"
	int_dat  Internet publishing and broadcasting and Web search portals (519130)
	new_dat  "News syndicates, libraries, archives and all other information services (5191A0)"
	cre_bnk  Nondepository credit intermediation and related activities (522A00)
	mon_bnk  Monetary authorities and depository credit intermediation (52A000)
	ofi_sec  Other financial investment activities (523900)
	com_sec  Securities and commodity contracts intermediation and brokerage (523A00)
	dir_ins  Direct life insurance carriers (524113)
	car_ins  "Insurance carriers, except direct life (5241XX)"
	agn_ins  "Insurance agencies, brokerages, and related activities (524200)"
	own_hou  Owner-occupied housing (531HSO)
	rnt_hou  Tenant-occupied housing (531HST)
	aut_rnt  Automotive equipment rental and leasing (532100)
	com_rnt  Commercial and industrial machinery and equipment rental and leasing (532400)
	cmg_rnt  General and consumer goods rental (532A00)
	int_rnt  Lessors of nonfinancial intangible assets (533000)
	cus_com  Custom computer programming services (541511)
	sys_com  Computer systems design services (541512)
	ocs_com  "Other computer related services, including facilities management (54151A)"
	acc_tsv  "Accounting, tax preparation, bookkeeping, and payroll services (541200)"
	arc_tsv  "Architectural, engineering, and related services (541300)"
	mgt_tsv  Management consulting services (541610)
	env_tsv  Environmental and other technical consulting services (5416A0)
	sci_tsv  Scientific research and development services (541700)
	adv_tsv  "Advertising, public relations, and related services (541800)"
	des_tsv  Specialized design services (541400)
	pht_tsv  Photographic services (541920)
	vet_tsv  Veterinary services (541940)
	mkt_tsv  "All other miscellaneous professional, scientific, and technical services (5419A0)"
	emp_adm  Employment services (561300)
	dwe_adm  Services to buildings and dwellings (561700)
	off_adm  Office administrative services (561100)
	fac_adm  Facilities support services (561200)
	bsp_adm  Business support services (561400)
	trv_adm  Travel arrangement and reservation services (561500)
	inv_adm  Investigation and security services (561600)
	oss_adm  Other support services (561900)
	sec_edu  Elementary and secondary schools (611100)
	uni_edu  "Junior colleges, colleges, universities, and professional schools (611A00)"
	oes_edu  Other educational services (611B00)
	phy_amb  Offices of physicians (621100)
	dnt_amb  Offices of dentists (621200)
	ohp_amb  Offices of other health practitioners (621300)
	out_amb  Outpatient care centers (621400)
	lab_amb  Medical and diagnostic laboratories (621500)
	hom_amb  Home health care services (621600)
	oas_amb  Other ambulatory health care services (621900)
	ncc_nrs  Nursing and community care facilities (623A00)
	res_nrs  "Residential mental health, substance abuse, and other residential care facilities (623B00)"
	ifs_soc  Individual and family services (624100)
	day_soc  Child day care services (624400)
	cmf_soc  "Community food, housing, and other relief services, including vocational rehabilitation services (624A00)"
	pfm_art  Performing arts companies (711100)
	spr_art  Spectator sports (711200)
	ind_art  "Independent artists, writers, and performers (711500)"
	agt_art  Promoters of performing arts and sports and agents for public figures (711A00)
	mus_art  "Museums, historical sites, zoos, and parks (712000)"
	amu_rec  Amusement parks and arcades (713100)
	cas_rec  Gambling industries (except casino hotels) (713200)
	ori_rec  Other amusement and recreation industries (713900)
	ful_res  Full-service restaurants (722110)
	lim_res  Limited-service restaurants (722211)
	ofd_res  All other food and drinking places (722A00)
	atr_osv  Automotive repair and maintenance (including car washes) (811100)
	eqr_osv  Electronic and precision equipment repair and maintenance (811200)
	imr_osv  Commercial and industrial machinery and equipment repair and maintenance (811300)
	hgr_osv  Personal and household goods repair and maintenance (811400)
	pcs_osv  Personal care services (812100)
	fun_osv  Death care services (812200)
	dry_osv  Dry-cleaning and laundry services (812300)
	ops_osv  Other personal services (812900)
	rel_osv  Religious organizations (813100)
	grt_osv  "Grantmaking, giving, and social advocacy organizations (813A00)"
	civ_osv  "Civic, social, professional, and similar organizations (813B00)"
	prv_osv  Private households (814000)
	pst_fen  Postal service (491000)
	ofg_fen  Other federal government enterprises (S00102)
	edu_slg  State and local government (educational services) (GSLGE)
	hea_slg  State and local government (hospitals and health services) (GSLGH)
	oth_slg  State and local government (other services) (GSLGO)
	osl_sle  Other state and local government enterprises (S00203)
	srp_usd  Scrap (S00401)
	sec_usd  Used and secondhand goods (S00402)
	imp_oth  Noncomparable imports (S00300)
	rwa_oth  Rest of the world adjustment (S00900)
	sme_pmt  Secondary smelting and alloying of aluminum (331314)
	ele_fen  Federal electric utilities (S00101)
	trn_sle  State and local government passenger transit 
	ele_sle  State and local government electric utilities /;

$exit


set rmap(r,s,sr) /
"Alabama".						al.total
"Alabama (Metropolitan Portion)".			al.metro
"Alabama (Nonmetropolitan Portion) *".			al.rural
"Alaska".						ak.total
"Alaska (Metropolitan Portion)".			ak.metro
"Alaska (Nonmetropolitan Portion) *".			ak.rural
"Arizona".						az.total
"Arizona (Metropolitan Portion)".			az.metro
"Arizona (Nonmetropolitan Portion) *".			az.rural
"Arkansas".						ak.total
"Arkansas (Metropolitan Portion)".			ak.metro
"Arkansas (Nonmetropolitan Portion) *".			ak.rural
"California".						ca.total
"California (Metropolitan Portion)".			ca.metro
"California (Nonmetropolitan Portion) *".		ca.rural
"Colorado".						co.total
"Colorado (Metropolitan Portion)".			co.metro
"Colorado (Nonmetropolitan Portion) *".			co.rural
"Connecticut".						ct.total
"Connecticut (Metropolitan Portion)".			ct.metro
"Connecticut (Nonmetropolitan Portion) *".		ct.rural
"Delaware".						de.total
"Delaware (Metropolitan Portion)".			de.metro
"Delaware (Nonmetropolitan Portion) *".			de.rural
"District of Columbia".					dc.total
"District of Columbia (Metropolitan Portion)".		dc.metro
"District of Columbia (Nonmetropolitan Portion) 	dc.rural*".
"Florida".						fl.total
"Florida (Metropolitan Portion)".			fl.metro
"Florida (Nonmetropolitan Portion) *".			fl.rural
"Georgia".						ga.total
"Georgia (Metropolitan Portion)".			ga.metro
"Georgia (Nonmetropolitan Portion) *".			ga.rural
"Hawaii".						hi.total
"Hawaii (Metropolitan Portion)".			hi.metro
"Hawaii (Nonmetropolitan Portion) *".			hi.rural
"Idaho".						id.total
"Idaho (Metropolitan Portion)".				id.metro
"Idaho (Nonmetropolitan Portion) *".			id.rural
"Illinois".						il.total
"Illinois (Metropolitan Portion)".			il.metro
"Illinois (Nonmetropolitan Portion) *".			il.rural
"Indiana".						in.total
"Indiana (Metropolitan Portion)".			in.metro
"Indiana (Nonmetropolitan Portion) *".			in.rural
"Iowa".							ia.total
"Iowa (Metropolitan Portion)".				ia.metro
"Iowa (Nonmetropolitan Portion) *".			ia.rural
"Kansas".						ks.total
"Kansas (Metropolitan Portion)".			ks.metro
"Kansas (Nonmetropolitan Portion) *".			ks.rural
"Kentucky".						ky.total
"Kentucky (Metropolitan Portion)".			ky.metro
"Kentucky (Nonmetropolitan Portion) *".			ky.rural
"Louisiana".						la.total
"Louisiana (Metropolitan Portion)".			la.metro
"Louisiana (Nonmetropolitan Portion) *".		la.rural
"Maine".						me.total
"Maine (Metropolitan Portion)".				me.metro
"Maine (Nonmetropolitan Portion) *".			me.rural
"Maryland".						md.total
"Maryland (Metropolitan Portion)".			md.metro
"Maryland (Nonmetropolitan Portion) *".			md.rural
"Massachusetts".					ma.total
"Massachusetts (Metropolitan Portion)".			ma.metro
"Massachusetts (Nonmetropolitan Portion) *".		ma.rural
"Michigan".						mi.total
"Michigan (Metropolitan Portion)".			mi.metro
"Michigan (Nonmetropolitan Portion) *".			mi.rural
"Minnesota".						mn.total
"Minnesota (Metropolitan Portion)".			mn.metro
"Minnesota (Nonmetropolitan Portion) *".		mn.rural
"Mississippi".						ms.total
"Mississippi (Metropolitan Portion)".			ms.metro
"Mississippi (Nonmetropolitan Portion) *".		ms.rural
"Missouri".						mo.total
"Missouri (Metropolitan Portion)".			mo.metro
"Missouri (Nonmetropolitan Portion) *".			mo.rural
"Montana".						mt.total
"Montana (Metropolitan Portion)".			mt.metro
"Montana (Nonmetropolitan Portion) *".			mt.rural
"Nebraska".						nb.total
"Nebraska (Metropolitan Portion)".			nb.metro
"Nebraska (Nonmetropolitan Portion) *".			nb.rural
"Nevada".						nv.total
"Nevada (Metropolitan Portion)".			nv.metro
"Nevada (Nonmetropolitan Portion) *".			nv.rural
"New Hampshire".					nh.total
"New Hampshire (Metropolitan Portion)".			nh.metro	
"New Hampshire (Nonmetropolitan Portion) *".		nh.rural	
"New Jersey".						nj.total	
"New Jersey (Metropolitan Portion)".			nj.metro	
"New Jersey (Nonmetropolitan Portion) *".		nj.rural	
"New Mexico".						nm.total	
"New Mexico (Metropolitan Portion)".			nm.metro	
"New Mexico (Nonmetropolitan Portion) *".		nm.rural	
"New York".						ny.total	
"New York (Metropolitan Portion)".			ny.metro	
"New York (Nonmetropolitan Portion) *".			ny.rural	
"North Carolina".					nc.total	
"North Carolina (Metropolitan Portion)".		nc.metro	
"North Carolina (Nonmetropolitan Portion) *".		nc.rural	
"North Dakota".						nd.total	
"North Dakota (Metropolitan Portion)".			nd.metro	
"North Dakota (Nonmetropolitan Portion) *".		nd.rural	
"Ohio".							oh.total	
"Ohio (Metropolitan Portion)".				oh.metro	
"Ohio (Nonmetropolitan Portion) *".			oh.rural	
"Oklahoma".						ok.total	
"Oklahoma (Metropolitan Portion)".			ok.metro	
"Oklahoma (Nonmetropolitan Portion) *".			ok.rural	
"Oregon".						or.total	
"Oregon (Metropolitan Portion)".			or.metro	
"Oregon (Nonmetropolitan Portion) *".			or.rural	
"Pennsylvania".						pa.total	
"Pennsylvania (Metropolitan Portion)".			pa.metro	
"Pennsylvania (Nonmetropolitan Portion) *".		pa.rural	
"Rhode Island".						ri.total	
"Rhode Island (Metropolitan Portion)".			ri.metro	
"Rhode Island (Nonmetropolitan Portion) *".		ri.rural	
"South Carolina".					sc.total	
"South Carolina (Metropolitan Portion)".		sc.metro	
"South Carolina (Nonmetropolitan Portion) *".		sc.rural	
"South Dakota".						sd.total	
"South Dakota (Metropolitan Portion)".			sd.metro	
"South Dakota (Nonmetropolitan Portion) *".		sd.rural	
"Tennessee".						tn.total	
"Tennessee (Metropolitan Portion)".			tn.metro	
"Tennessee (Nonmetropolitan Portion) *".		tn.rural	
"Texas".						tx.total	
"Texas (Metropolitan Portion)".				tx.metro	
"Texas (Nonmetropolitan Portion) *".			tx.rural	
"Utah".							ut.total	
"Utah (Metropolitan Portion)".				ut.metro	
"Utah (Nonmetropolitan Portion) *".			ut.rural	
"Vermont".						vt.total	
"Vermont (Metropolitan Portion)".			vt.metro	
"Vermont (Nonmetropolitan Portion) *".			vt.rural	
"Virginia".						va.total	
"Virginia (Metropolitan Portion)".			va.metro	
"Virginia (Nonmetropolitan Portion) *".			va.rural	
"Washington".						wa.total	
"Washington (Metropolitan Portion)".			wa.metro	
"Washington (Nonmetropolitan Portion) *".		wa.rural	
"West Virginia".					wv.total	
"West Virginia (Metropolitan Portion)".			wv.metro	
"West Virginia (Nonmetropolitan Portion) *".		wv.rural	
"Wisconsin".						wi.total	
"Wisconsin (Metropolitan Portion)".			wi.metro	
"Wisconsin (Nonmetropolitan Portion) *".		wi.rural	
"Wyoming".						wy.total
"Wyoming (Metropolitan Portion)".			wy.metro
"Wyoming (Nonmetropolitan Portion) *".			wy.rural

set	is(*)	Summary sectors;

set	smap(u,id,is<) /
	(111,"111-112").oil_agr.agr	"Oilseed farming (1111A0)"
	(111,"111-112").grn_agr.agr	"Grain farming (1111B0)"
	(111,"111-112").veg_agr.agr	"Vegetable and melon farming (111200)"
	(111,"111-112").nut_agr.agr	"Fruit and tree nut farming (111300)"
	(111,"111-112").flo_agr.agr	"Greenhouse, nursery, and floriculture production (111400)"
	(111,"111-112").oth_agr.agr	"Other crop farming (111900)"
	(112,"111-112").bef_agr.agr	"Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)"
	(112,"111-112").dry_agr.agr	"Dairy cattle and milk production (112120)"
	(112,"111-112").ota_agr.agr	"Animal production, except cattle and poultry and eggs (112A00)"
	(112,"111-112").egg_agr.agr	"Poultry and egg production (112300)"
	113.log_fof.fof	"Forestry and logging (113000)"
	114.fht_fof.fof	"Fishing, hunting and trapping (114000)"
	115.saf_fof.fof	"Support activities for agriculture and forestry (115000)"
	211.oil_oil.oil	"Oil and gas extraction (211000)"
	212.col_min.min	"Coal mining (212100)"
	212.ore_min.min	"Iron, gold, silver, and other metal ore mining (2122A0)"
	212.led_min.min	"Copper, nickel, lead, and zinc mining (212230)"
	212.stn_min.min	"Stone mining and quarrying (212310)"
	212.oth_min.min	"Other nonmetallic mineral mining and quarrying (2123A0)"
	213.drl_smn.smn	"Drilling oil and gas wells (213111)"
	213.oth_smn.smn	"Other support activities for mining (21311A)"
	(22,221).ele_uti.uti	"Electric power generation, transmission, and distribution (221100)"
	(22,221).gas_uti.uti	"Natural gas distribution (221200)"
	(22,221).wat_uti.uti	"Water, sewage and other systems (221300)"
	(23,230).nmr_con.con	"Nonresidential maintenance and repair (230301)"
	(23,230).rmr_con.con	"Residential maintenance and repair (230302)"
	(233,236,237,238).hcs_con.con	"Health care structures (233210)"
	(233,236,237,238).mfs_con.con	"Manufacturing structures (233230)"
	(233,236,237,238).pwr_con.con	"Power and communication structures (233240)"
	(233,236,237,238).edu_con.con	"Educational and vocational structures (233262)"
	(233,236,237,238).off_con.con	"Office and commercial structures (2332A0)"
	(233,237).trn_con.con	"Transportation structures and highways and streets (2332C0)"
	(233,236).ons_con.con	"Other nonresidential structures (2332D0)"
	(23,233).srs_con.con	"Single-family residential structures (233411)"
	(23,233).mrs_con.con	"Multifamily residential structures (233412)"
	(23,233).ors_con.con	"Other residential structures (2334A0)"
	311.dog_fbp.fbp	"Dog and cat food manufacturing (311111)"
	311.oaf_fbp.fbp	"Other animal food manufacturing (311119)"
	311.flr_fbp.fbp	"Flour milling and malt manufacturing (311210)"
	311.wet_fbp.fbp	"Wet corn milling (311221)"
	311.soy_fbp.fbp	"Soybean and other oilseed processing (311224)"
	311.fat_fbp.fbp	"Fats and oils refining and blending (311225)"
	311.brk_fbp.fbp	"Breakfast cereal manufacturing (311230)"
	311.sug_fbp.fbp	"Sugar and confectionery product manufacturing (311300)"
	311.fzn_fbp.fbp	"Frozen food manufacturing (311410)"
	311.can_fbp.fbp	"Fruit and vegetable canning, pickling, and drying (311420)"
	311.mlk_fbp.fbp	"Fluid milk and butter manufacturing (31151A)"
	311.chs_fbp.fbp	"Cheese manufacturing (311513)"
	311.dry_fbp.fbp	"Dry, condensed, and evaporated dairy product manufacturing (311514)"
	311.ice_fbp.fbp	"Ice cream and frozen dessert manufacturing (311520)"
	311.asp_fbp.fbp	"Animal (except poultry) slaughtering, rendering, and processing (31161A)"
	311.chk_fbp.fbp	"Poultry processing (311615)"
	311.sea_fbp.fbp	"Seafood product preparation and packaging (311700)"
	311.brd_fbp.fbp	"Bread and bakery product manufacturing (311810)"
	311.cok_fbp.fbp	"Cookie, cracker, pasta, and tortilla manufacturing (3118A0)"
	311.snk_fbp.fbp	"Snack food manufacturing (311910)"
	311.tea_fbp.fbp	"Coffee and tea manufacturing (311920)"
	311.syr_fbp.fbp	"Flavoring syrup and concentrate manufacturing (311930)"
	311.spc_fbp.fbp	"Seasoning and dressing manufacturing (311940)"
	311.ofm_fbp.fbp	"All other food manufacturing (311990)"
	312.pop_fbp.fbp	"Soft drink and ice manufacturing (312110)"
	312.ber_fbp.fbp	"Breweries (312120)"
	312.wne_fbp.fbp	"Wineries (312130)"
	312.why_fbp.fbp	"Distilleries (312140)"
	312.cig_fbp.fbp	"Tobacco manufacturing (312200)"
	313.fyt_tex.tex	"Fiber, yarn, and thread mills (313100)"
	313.fml_tex.tex	"Fabric mills (313200)"
	313.txf_tex.tex	"Textile and fabric finishing and fabric coating mills (313300)"
	314.rug_tex.tex	"Carpet and rug mills (314110)"
	314.lin_tex.tex	"Curtain and linen mills (314120)"
	314.otp_tex.tex	"Other textile product mills (314900)"
	315.app_alt.alt	"Apparel manufacturing (315000)"
	316.lea_alt.alt	"Leather and allied product manufacturing (316000)"
	321.saw_wpd.wpd	"Sawmills and wood preservation (321100)"
	321.ven_wpd.wpd	"Veneer, plywood, and engineered wood product manufacturing (321200)"
	321.mil_wpd.wpd	"Millwork (321910)"
	321.owp_wpd.wpd	"All other wood product manufacturing (3219A0)"
	322.plp_ppd.ppd	"Pulp mills (322110)"
	322.ppm_ppd.ppd	"Paper mills (322120)"
	322.pbm_ppd.ppd	"Paperboard mills (322130)"
	322.pbc_ppd.ppd	"Paperboard container manufacturing (322210)"
	322.ppb_ppd.ppd	"Paper bag and coated and treated paper manufacturing (322220)"
	322.sta_ppd.ppd	"Stationery product manufacturing (322230)"
	322.toi_ppd.ppd	"Sanitary paper product manufacturing (322291)"
	322.opp_ppd.ppd	"All other converted paper product manufacturing (322299)"
	323.pri_pri.pri	"Printing (323110)"
	323.sap_pri.pri	"Support activities for printing (323120)"
	324.ref_pet.pet	"Petroleum refineries (324110)"
	324.pav_pet.pet	"Asphalt paving mixture and block manufacturing (324121)"
	324.shn_pet.pet	"Asphalt shingle and coating materials manufacturing (324122)"
	324.oth_pet.pet	"Other petroleum and coal products manufacturing (324190)"
	325.ptr_che.che	"Petrochemical manufacturing (325110)"
	325.igm_che.che	"Industrial gas manufacturing (325120)"
	325.sdp_che.che	"Synthetic dye and pigment manufacturing (325130)"
	325.obi_che.che	"Other basic inorganic chemical manufacturing (325180)"
	325.obo_che.che	"Other basic organic chemical manufacturing (325190)"
	325.pmr_che.che	"Plastics material and resin manufacturing (325211)"
	325.srf_che.che	"Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)"
	325.fmf_che.che	"Fertilizer manufacturing (325310)"
	325.pag_che.che	"Pesticide and other agricultural chemical manufacturing (325320)"
	325.mbm_che.che	"Medicinal and botanical manufacturing (325411)"
	325.phm_che.che	"Pharmaceutical preparation manufacturing (325412)"
	325.inv_che.che	"In-vitro diagnostic substance manufacturing (325413)"
	325.bio_che.che	"Biological product (except diagnostic) manufacturing (325414)"
	325.pnt_che.che	"Paint and coating manufacturing (325510)"
	325.adh_che.che	"Adhesive manufacturing (325520)"
	325.sop_che.che	"Soap and cleaning compound manufacturing (325610)"
	325.toi_che.che	"Toilet preparation manufacturing (325620)"
	325.pri_che.che	"Printing ink manufacturing (325910)"
	325.och_che.che	"All other chemical product and preparation manufacturing (3259A0)"
	326.plm_pla.pla	"Plastics packaging materials and unlaminated film and sheet manufacturing (326110)"
	326.ppp_pla.pla	"Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)"
	326.lam_pla.pla	"Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)"
	326.fom_pla.pla	"Polystyrene foam product manufacturing (326140)"
	326.ure_pla.pla	"Urethane and other foam product (except polystyrene) manufacturing (326150)"
	326.bot_pla.pla	"Plastics bottle manufacturing (326160)"
	326.opm_pla.pla	"Other plastics product manufacturing (326190)"
	326.tir_pla.pla	"Tire manufacturing (326210)"
	326.rbr_pla.pla	"Rubber and plastics hoses and belting manufacturing (326220)"
	326.orb_pla.pla	"Other rubber product manufacturing (326290)"
	327.cly_nmp.nmp	"Clay product and refractory manufacturing (327100)"
	327.gla_nmp.nmp	"Glass and glass product manufacturing (327200)"
	327.cmt_nmp.nmp	"Cement manufacturing (327310)"
	327.cnc_nmp.nmp	"Ready-mix concrete manufacturing (327320)"
	327.cpb_nmp.nmp	"Concrete pipe, brick, and block manufacturing (327330)"
	327.ocp_nmp.nmp	"Other concrete product manufacturing (327390)"
	327.lme_nmp.nmp	"Lime and gypsum product manufacturing (327400)"
	327.abr_nmp.nmp	"Abrasive product manufacturing (327910)"
	327.cut_nmp.nmp	"Cut stone and stone product manufacturing (327991)"
	327.tmn_nmp.nmp	"Ground or treated mineral and earth manufacturing (327992)"
	327.wol_nmp.nmp	"Mineral wool manufacturing (327993)"
	327.mnm_nmp.nmp	"Miscellaneous nonmetallic mineral products (327999)"
	331.irn_pmt.pmt	"Iron and steel mills and ferroalloy manufacturing (331110)"
	331.stl_pmt.pmt	"Steel product manufacturing from purchased steel			 (331200)"
	331.ala_pmt.pmt	"Alumina refining and primary aluminum production (331313)"
	331.sme_pmt.pmt	"Secondary smelting and alloying of aluminum (331314)"
	331.alu_pmt.pmt	"Aluminum product manufacturing from purchased aluminum (33131B)"
	331.nms_pmt.pmt	"Nonferrous metal (except aluminum) smelting and refining (331410)"
	331.cop_pmt.pmt	"Copper rolling, drawing, extruding and alloying (331420)"
	331.nfm_pmt.pmt	"Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)"
	331.fmf_pmt.pmt	"Ferrous metal foundries (331510)"
	331.nff_pmt.pmt	"Nonferrous metal foundries (331520)"
	332.fss_fmt.fmt	"All other forging, stamping, and sintering (33211A)"
	332.rol_fmt.fmt	"Custom roll forming (332114)"
	332.crn_fmt.fmt	"Metal crown, closure, and other metal stamping (except automotive) (332119)"
	332.cut_fmt.fmt	"Cutlery and handtool manufacturing (332200)"
	332.plt_fmt.fmt	"Plate work and fabricated structural product manufacturing (332310)"
	332.orn_fmt.fmt	"Ornamental and architectural metal products manufacturing (332320)"
	332.pwr_fmt.fmt	"Power boiler and heat exchanger manufacturing (332410)"
	332.mtt_fmt.fmt	"Metal tank (heavy gauge) manufacturing (332420)"
	332.mtc_fmt.fmt	"Metal can, box, and other metal container (light gauge) manufacturing (332430)"
	332.hdw_fmt.fmt	"Hardware manufacturing (332500)"
	332.spr_fmt.fmt	"Spring and wire product manufacturing (332600)"
	332.mch_fmt.fmt	"Machine shops (332710)"
	332.tps_fmt.fmt	"Turned product and screw, nut, and bolt manufacturing (332720)"
	332.ceh_fmt.fmt	"Coating, engraving, heat treating and allied activities (332800)"
	332.vlv_fmt.fmt	"Valve and fittings other than plumbing (33291A)"
	332.plb_fmt.fmt	"Plumbing fixture fitting and trim manufacturing (332913)"
	332.bbr_fmt.fmt	"Ball and roller bearing manufacturing (332991)"
	332.amn_fmt.fmt	"Ammunition, arms, ordnance, and accessories manufacturing (33299A)"
	332.fab_fmt.fmt	"Fabricated pipe and pipe fitting manufacturing (332996)"
	332.omf_fmt.fmt	"Other fabricated metal manufacturing (332999)"
	333.frm_mch.mch	"Farm machinery and equipment manufacturing (333111)"
	333.lwn_mch.mch	"Lawn and garden equipment manufacturing (333112)"
	333.con_mch.mch	"Construction machinery manufacturing (333120)"
	333.min_mch.mch	"Mining and oil and gas field machinery manufacturing (333130)"
	333.smc_mch.mch	"Semiconductor machinery manufacturing (333242)"
	333.oti_mch.mch	"Other industrial machinery manufacturing (33329A)"
	333.opt_mch.mch	"Optical instrument and lens manufacturing (333314)"
	333.pht_mch.mch	"Photographic and photocopying equipment manufacturing (333316)"
	333.oci_mch.mch	"Other commercial and service industry machinery manufacturing (333318)"
	333.air_mch.mch	"Industrial and commercial fan and blower and air purification equipment manufacturing (333413)"
	333.hea_mch.mch	"Heating equipment (except warm air furnaces) manufacturing (333414)"
	333.acn_mch.mch	"Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)"
	333.imm_mch.mch	"Industrial mold manufacturing (333511)"
	333.mct_mch.mch	"Machine tool manufacturing (333517)"
	333.spt_mch.mch	"Special tool, die, jig, and fixture manufacturing (333514)"
	333.cut_mch.mch	"Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)"
	333.tbn_mch.mch	"Turbine and turbine generator set units manufacturing (333611)"
	333.spd_mch.mch	"Speed changer, industrial high-speed drive, and gear manufacturing (333612)"
	333.mch_mch.mch	"Mechanical power transmission equipment manufacturing (333613)"
	333.oee_mch.mch	"Other engine equipment manufacturing (333618)"
	333.ppe_mch.mch	"Pump and pumping equipment manufacturing (33391A)"
	333.agc_mch.mch	"Air and gas compressor manufacturing (333912)"
	333.mat_mch.mch	"Material handling equipment manufacturing (333920)"
	333.pwr_mch.mch	"Power-driven handtool manufacturing (333991)"
	333.ogp_mch.mch	"Other general purpose machinery manufacturing (33399A)"
	333.pkg_mch.mch	"Packaging machinery manufacturing (333993)"
	333.ipf_mch.mch	"Industrial process furnace and oven manufacturing (333994)"
	333.fld_mch.mch	"Fluid power process machinery (33399B)"
	334.ecm_cep.cep	"Electronic computer manufacturing (334111)"
	334.csd_cep.cep	"Computer storage device manufacturing (334112)"
	334.ctm_cep.cep	"Computer terminals and other computer peripheral equipment manufacturing (334118)"
	334.tel_cep.cep	"Telephone apparatus manufacturing (334210)"
	334.brd_cep.cep	"Broadcast and wireless communications equipment (334220)"
	334.oce_cep.cep	"Other communications equipment manufacturing (334290)"
	334.aud_cep.cep	"Audio and video equipment manufacturing (334300)"
	334.oec_cep.cep	"Other electronic component manufacturing (33441A)"
	334.sem_cep.cep	"Semiconductor and related device manufacturing (334413)"
	334.prc_cep.cep	"Printed circuit assembly (electronic assembly) manufacturing (334418)"
	334.eea_cep.cep	"Electromedical and electrotherapeutic apparatus manufacturing (334510)"
	334.sdn_cep.cep	"Search, detection, and navigation instruments manufacturing (334511)"
	334.aec_cep.cep	"Automatic environmental control manufacturing (334512)"
	334.ipv_cep.cep	"Industrial process variable instruments manufacturing (334513)"
	334.tfl_cep.cep	"Totalizing fluid meter and counting device manufacturing (334514)"
	334.els_cep.cep	"Electricity and signal testing instruments manufacturing (334515)"
	334.ali_cep.cep	"Analytical laboratory instrument manufacturing (334516)"
	334.irr_cep.cep	"Irradiation apparatus manufacturing (334517)"
	334.wcm_cep.cep	"Watch, clock, and other measuring and controlling device manufacturing (33451A)"
	334.mmo_cep.cep	"Manufacturing and reproducing magnetic and optical media (334610)"
	335.elb_eec.eec	"Electric lamp bulb and part manufacturing (335110)"
	335.ltf_eec.eec	"Lighting fixture manufacturing (335120)"
	335.sea_eec.eec	"Small electrical appliance manufacturing (335210)"
	335.hca_eec.eec	"Household cooking appliance manufacturing (335221)"
	335.hrf_eec.eec	"Household refrigerator and home freezer manufacturing (335222)"
	335.hle_eec.eec	"Household laundry equipment manufacturing (335224)"
	335.omh_eec.eec	"Other major household appliance manufacturing (335228)"
	335.pwr_eec.eec	"Power, distribution, and specialty transformer manufacturing (335311)"
	335.mtg_eec.eec	"Motor and generator manufacturing (335312)"
	335.swt_eec.eec	"Switchgear and switchboard apparatus manufacturing (335313)"
	335.ric_eec.eec	"Relay and industrial control manufacturing (335314)"
	335.sbt_eec.eec	"Storage battery manufacturing (335911)"
	335.pbt_eec.eec	"Primary battery manufacturing (335912)"
	335.cme_eec.eec	"Communication and energy wire and cable manufacturing (335920)"
	335.wdv_eec.eec	"Wiring device manufacturing (335930)"
	335.cbn_eec.eec	"Carbon and graphite product manufacturing (335991)"
	335.oee_eec.eec	"All other miscellaneous electrical equipment and component manufacturing (335999)"
	(336,"3361-3363").atm_mot.mot	"Automobile manufacturing (336111)"
	(336,"3361-3363").ltr_mot.mot	"Light truck and utility vehicle manufacturing (336112)"
	(336,"3361-3363").htr_mot.mot	"Heavy duty truck manufacturing (336120)"
	(336,"3361-3363").mbd_mot.mot	"Motor vehicle body manufacturing (336211)"
	(336,"3361-3363").trl_mot.mot	"Truck trailer manufacturing (336212)"
	(336,"3361-3363").hom_mot.mot	"Motor home manufacturing (336213)"
	(336,"3361-3363").cam_mot.mot	"Travel trailer and camper manufacturing (336214)"
	(336,"3361-3363").gas_mot.mot	"Motor vehicle gasoline engine and engine parts manufacturing (336310)"
	(336,"3361-3363").eee_mot.mot	"Motor vehicle electrical and electronic equipment manufacturing (336320)"
	(336,"3361-3363").brk_mot.mot	"Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)"
	(336,"3361-3363").tpw_mot.mot	"Motor vehicle transmission and power train parts manufacturing (336350)"
	(336,"3361-3363").trm_mot.mot	"Motor vehicle seating and interior trim manufacturing (336360)"
	(336,"3361-3363").stm_mot.mot	"Motor vehicle metal stamping (336370)"
	(336,"3364-3466,3369").omv_mot.mot	"Other motor vehicle parts manufacturing (336390)"
	(336,"3364-3466,3369").air_ote.ote	"Aircraft manufacturing (336411)"
	(336,"3364-3466,3369").aen_ote.ote	"Aircraft engine and engine parts manufacturing (336412)"
	(336,"3364-3466,3369").oar_ote.ote	"Other aircraft parts and auxiliary equipment manufacturing (336413)"
	(336,"3364-3466,3369").mis_ote.ote	"Guided missile and space vehicle manufacturing (336414)"
	(336,"3364-3466,3369").pro_ote.ote	"Propulsion units and parts for space vehicles and guided missiles (33641A)"
	(336,"3364-3466,3369").rrd_ote.ote	"Railroad rolling stock manufacturing (336500)"
	(336,"3364-3466,3369").shp_ote.ote	"Ship building and repairing (336611)"
	(336,"3364-3466,3369").bot_ote.ote	"Boat building (336612)"
	(336,"3364-3466,3369").mcl_ote.ote	"Motorcycle, bicycle, and parts manufacturing (336991)"
	(336,"3364-3466,3369").mlt_ote.ote	"Military armored vehicle, tank, and tank component manufacturing (336992)"
	(336,"3364-3466,3369").otm_ote.ote	"All other transportation equipment manufacturing (336999)"
	337.cab_fpd.fpd	"Wood kitchen cabinet and countertop manufacturing (337110)"
	337.uph_fpd.fpd	"Upholstered household furniture manufacturing (337121)"
	337.nup_fpd.fpd	"Nonupholstered wood household furniture manufacturing (337122)"
	337.ohn_fpd.fpd	"Other household nonupholstered furniture (33712N)"
	337.ifm_fpd.fpd	"Institutional furniture manufacturing (337127)"
	337.off_fpd.fpd	"Office furniture and custom architectural woodwork and millwork manufacturing (33721A)"
	337.shv_fpd.fpd	"Showcase, partition, shelving, and locker manufacturing (337215)"
	337.ofp_fpd.fpd	"Other furniture related product manufacturing (337900)"
	339.smi_mmf.mmf	"Surgical and medical instrument manufacturing (339112)"
	339.sas_mmf.mmf	"Surgical appliance and supplies manufacturing (339113)"
	339.dnt_mmf.mmf	"Dental equipment and supplies manufacturing (339114)"
	339.oph_mmf.mmf	"Ophthalmic goods manufacturing (339115)"
	339.dlb_mmf.mmf	"Dental laboratories (339116)"
	339.jwl_mmf.mmf	"Jewelry and silverware manufacturing (339910)"
	339.ath_mmf.mmf	"Sporting and athletic goods manufacturing (339920)"
	339.toy_mmf.mmf	"Doll, toy, and game manufacturing (339930)"
	339.ofm_mmf.mmf	"Office supplies (except paper) manufacturing (339940)"
	339.sgn_mmf.mmf	"Sign manufacturing (339950)"
	339.omm_mmf.mmf	"All other miscellaneous manufacturing (339990)"
	(423,42).mtv_wht.wht	"Motor vehicle and motor vehicle parts and supplies (423100)"
	(423,42).pce_wht.wht	"Professional and commercial equipment and supplies (423400)"
	(423,42).hha_wht.wht	"Household appliances and electrical and electronic goods (423600)"
	(423,42).mch_wht.wht	"Machinery, equipment, and supplies (423800)"
	(423,42).odg_wht.wht	"Other durable goods merchant wholesalers (423A00)"
	(424,42).dru_wht.wht	"Drugs and druggists' sundries (424200)"
	(424,42).gro_wht.wht	"Grocery and related product wholesalers (424400)"
	(424,42).pet_wht.wht	"Petroleum and petroleum products (424700)"
	(424,42).ndg_wht.wht	"Other nondurable goods merchant wholesalers (424A00)"
	(425,42).ele_wht.wht	"Wholesale electronic markets and agents and brokers (425000)"
	(420,42).dut_wht.wht	"Customs duties (4200ID)"

	441.mvt_mvt.mvt	"Motor vehicle and parts dealers (441000)"
	445.fbt_fbt.fbt	"Food and beverage stores (445000)"
	(452,442,443,451,453).gmt_gmt.gmt	"General merchandise stores (452000)"
	(444,442).bui_ott.ott	"Building material and garden equipment and supplies dealers (444000)"
	446.hea_ott.ott	"Health and personal care stores (446000)"
	447.gas_ott.ott	"Gasoline stations (447000)"
	448.clo_ott.ott	"Clothing and clothing accessories stores (448000)"
	454.non_ott.ott	"Nonstore retailers (454000)"
	(4B0,"44-45").oth_ott.ott	"All other retail (4B0000)"
	481.air_air.air	"Air transportation (481000)"
	482.trn_trn.trn	"Rail transportation (482000)"
	483.wtt_wtt.wtt	"Water transportation (483000)"
	484.trk_trk.trk	"Truck transportation (484000)"
	485.grd_grd.grd	"Transit and ground passenger transportation (485000)"
	486.pip_pip.pip	"Pipeline transportation (486000)"
	(48A,487,488).sce_otr.otr	"Scenic and sightseeing transportation and support activities (48A000)"
	492.mes_otr.otr	"Couriers and messengers (492000)"
	493.wrh_wrh.wrh	"Warehousing and storage (493000)"
	511.new_pub.pub	"Newspaper publishers (511110)"
	511.pdl_pub.pub	"Periodical publishers (511120)"
	511.bok_pub.pub	"Book publishers (511130)"
	511.mal_pub.pub	"Directory, mailing list, and other publishers (5111A0)"
	511.sfw_pub.pub	"Software publishers (511200)"
	512.pic_mov.mov	"Motion picture and video industries (512100)"
	512.snd_mov.mov	"Sound recording industries (512200)"
	515.rad_brd.brd	"Radio and television broadcasting (515100)"
	515.cbl_brd.brd	"Cable and other subscription programming (515200)"
	517.wtl_brd.brd	"Wired telecommunications carriers (517110)"
	517.wls_brd.brd	"Wireless telecommunications carriers (except satellite) (517210)"
	517.sat_brd.brd	"Satellite, telecommunications resellers, and all other telecommunications (517A00)"
	518.dpr_dat.dat	"Data processing, hosting, and related services (518200)"
	519.new_dat.dat	"News syndicates, libraries, archives and all other information services (5191A0)"
	(519,516).int_dat.dat	"Internet publishing and broadcasting and Web search portals (519130)"
	(52A,521).mon_bnk.bnk	"Monetary authorities and depository credit intermediation (52A000)"
	522.cre_bnk.bnk	"Nondepository credit intermediation and related activities (522A00)"
	523.com_sec.sec	"Securities and commodity contracts intermediation and brokerage (523A00)"
	523.ofi_sec.sec	"Other financial investment activities (523900)"
	524.dir_ins.ins	"Direct life insurance carriers (524113)"
	524.car_ins.ins	"Insurance carriers, except direct life (5241XX)"
	524.agn_ins.ins	"Insurance agencies, brokerages, and related activities (524200)"
	525.fin_fin.fin	"Funds, trusts, and other financial vehicles (525000)"
	531.own_hou.hou	"Owner-occupied housing (531HSO)"
	531.rnt_hou.hou	"Tenant-occupied housing (531HST)"
	531.ore_ore.ore	"Other real estate (531ORE)"
	532.aut_rnt.rnt	"Automotive equipment rental and leasing (532100)"
	532.cmg_rnt.rnt	"General and consumer goods rental (532A00)"
	532.com_rnt.rnt	"Commercial and industrial machinery and equipment rental and leasing (532400)"
	533.int_rnt.rnt	"Lessors of nonfinancial intangible assets (533000)"
	(541,54).leg_leg.leg	"Legal services (541100)"
	(541,54).acc_tsv.tsv	"Accounting, tax preparation, bookkeeping, and payroll services (541200)"
	(541,54).arc_tsv.tsv	"Architectural, engineering, and related services (541300)"
	(541,54).des_tsv.tsv	"Specialized design services (541400)"
	(541,54).mgt_tsv.tsv	"Management consulting services (541610)"
	(541,54).env_tsv.tsv	"Environmental and other technical consulting services (5416A0)"
	(541,54).sci_tsv.tsv	"Scientific research and development services (541700)"
	(541,54).adv_tsv.tsv	"Advertising, public relations, and related services (541800)"
	(541,54).mkt_tsv.tsv	"All other miscellaneous professional, scientific, and technical services (5419A0)"
	(541,54).pht_tsv.tsv	"Photographic services (541920)"
	(541,54).vet_tsv.tsv	"Veterinary services (541940)"
	(541,54).cus_com.com	"Custom computer programming services (541511)"
	(541,54).sys_com.com	"Computer systems design services (541512)"
	(541,54).ocs_com.com	"Other computer related services, including facilities management (54151A)"
	(550,55).man_man.man	"Management of companies and enterprises (550000)"
	561.off_adm.adm	"Office administrative services (561100)"
	561.fac_adm.adm	"Facilities support services (561200)"
	561.emp_adm.adm	"Employment services (561300)"
	561.bsp_adm.adm	"Business support services (561400)"
	561.trv_adm.adm	"Travel arrangement and reservation services (561500)"
	561.inv_adm.adm	"Investigation and security services (561600)"
	561.dwe_adm.adm	"Services to buildings and dwellings (561700)"
	561.oss_adm.adm	"Other support services (561900)"
	562.wst_wst.wst	"Waste management and remediation services (562000)"
	(611,61).sec_edu.edu	"Elementary and secondary schools (611100)"
	(611,61).uni_edu.edu	"Junior colleges, colleges, universities, and professional schools (611A00)"
	(611,61).oes_edu.edu	"Other educational services (611B00)"
	621.phy_amb.amb	"Offices of physicians (621100)"
	621.dnt_amb.amb	"Offices of dentists (621200)"
	621.ohp_amb.amb	"Offices of other health practitioners (621300)"
	621.out_amb.amb	"Outpatient care centers (621400)"
	621.lab_amb.amb	"Medical and diagnostic laboratories (621500)"
	621.hom_amb.amb	"Home health care services (621600)"
	621.oas_amb.amb	"Other ambulatory health care services (621900)"
	622.hos_hos.hos	"Hospitals (622000)"
	623.ncc_nrs.nrs	"Nursing and community care facilities (623A00)"
	623.res_nrs.nrs	"Residential mental health, substance abuse, and other residential care facilities (623B00)"
	624.ifs_soc.soc	"Individual and family services (624100)"
	624.cmf_soc.soc	"Community food, housing, and other relief services, including vocational rehabilitation services (624A00)"
	624.day_soc.soc	"Child day care services (624400)"
	711.pfm_art.art	"Performing arts companies (711100)"
	711.spr_art.art	"Spectator sports (711200)"
	711.agt_art.art	"Promoters of performing arts and sports and agents for public figures (711A00)"
	711.ind_art.art	"Independent artists, writers, and performers (711500)"
	712.mus_art.art	"Museums, historical sites, zoos, and parks (712000)"
	713.amu_rec.rec	"Amusement parks and arcades (713100)"
	713.cas_rec.rec	"Gambling industries (except casino hotels) (713200)"
	713.ori_rec.rec	"Other amusement and recreation industries (713900)"
	721.amd_amd.amd	"Accommodation (721000)"
	722.ful_res.res	"Full-service restaurants (722110)"
	722.lim_res.res	"Limited-service restaurants (722211)"
	722.ofd_res.res	"All other food and drinking places (722A00)"
	811.atr_osv.osv	"Automotive repair and maintenance (including car washes) (811100)"
	811.eqr_osv.osv	"Electronic and precision equipment repair and maintenance (811200)"
	811.imr_osv.osv	"Commercial and industrial machinery and equipment repair and maintenance (811300)"
	811.hgr_osv.osv	"Personal and household goods repair and maintenance (811400)"
	812.pcs_osv.osv	"Personal care services (812100)"
	812.fun_osv.osv	"Death care services (812200)"
	812.dry_osv.osv	"Dry-cleaning and laundry services (812300)"
	812.ops_osv.osv	"Other personal services (812900)"
	813.rel_osv.osv	"Religious organizations (813100)"
	813.grt_osv.osv	"Grantmaking, giving, and social advocacy organizations (813A00)"
	813.civ_osv.osv	"Civic, social, professional, and similar organizations (813B00)"
	814.prv_osv.osv	"Private households (814000)"
	(fdd,S00).fdd_fdd.fdd	"Federal general government (defense) (S00500)"
	(fnd,S00).fnd_fnd.fnd	"Federal general government (nondefense) (S00600)"
	491.pst_fen.fen	"Postal service (491000)"
	(fnd,S00).ele_fen.fen	"Federal electric utilities (S00101)"
	(fnd,S00).ofg_fen.fen	"Other federal government enterprises (S00102)"
	gsl.edu_slg.slg	"State and local government (educational services) (GSLGE)"
	gsl.hea_slg.slg	"State and local government (hospitals and health services) (GSLGH)"
	gsl.oth_slg.slg	"State and local government (other services) (GSLGO)"
	(gsl,S00).trn_sle.sle	"State and local government passenger transit (S00201)"
	(gsl,S00).ele_sle.sle	"State and local government electric utilities (S00202)"
	(gsl,S00).ent_sle.sle	"Other state and local government enterprises (S00203)"
	S00.srp_usd.usd	"Scrap (S00401)"
	S00.sec_usd.usd	"Used and secondhand goods (S00402)"
	S00.imp_oth.oth	"Noncomparable imports (S00300)"
	S00.rwa_oth.oth	"Rest of the world adjustment (S00900)" /;
