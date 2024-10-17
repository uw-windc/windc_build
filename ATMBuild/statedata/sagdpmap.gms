$title	Match NAICS 4 digit Sectors to SAGDP Rows

set	seq /0*10000/;

set	id	Sector UELs (WiNDC syntax) /
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
	ele_sle  State and local government electric utilities /,

	n4(*)	Corresponding 4 digit NAICs codes,

	n4_id(n4<,id) Detailed sectors: 4 digit NAICs codes corresponding WiNDC identifiers /

	4820.trn      Rail transportation (482000)
	531O.ORE      Other real estate (531ORE)
	2110.oil      Oil and gas extraction (211000)
	4410.mvt      Motor vehicle and parts dealers (441000)
	4450.fbt      Food and beverage stores (445000)
	4520.gmt      General merchandise stores (452000)
	4810.air      Air transportation (481000)
	4830.wtt      Water transportation (483000)
	4840.trk      Truck transportation (484000)
	4850.grd      Transit and ground passenger transportation (485000)
	4860.pip      Pipeline transportation (486000)
	4930.wrh      Warehousing and storage (493000)
	5250.fin      "Funds, trusts, and other financial vehicles (525000)"
	5411.leg      Legal services (541100)
	5500.man      Management of companies and enterprises (550000)
	5620.wst      Waste management and remediation services (562000)
	6220.hos      Hospitals (622000)
	7210.amd      Accommodation (721000)
	defe.fdd      Federal general government (defense) (S00500)
	nond.fnd      Federal general government (nondefense) (S00600)
	1111.osd_agr  Oilseed farming (1111A0)
	1111.grn_agr  Grain farming (1111B0)
	1112.veg_agr  Vegetable and melon farming (111200)
	1113.nut_agr  Fruit and tree nut farming (111300)
	1114.flo_agr  "Greenhouse, nursery, and floriculture production (111400)"
	1119.oth_agr  Other crop farming (111900)
	1121.dry_agr  Dairy cattle and milk production (112120)
	1121.bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)"
	1123.egg_agr  Poultry and egg production (112300)
	112A.ota_agr  "Animal production, except cattle and poultry and eggs (112A00)"
	1130.log_fof  Forestry and logging (113000)
	1140.fht_fof  "Fishing, hunting and trapping (114000)"
	1150.saf_fof  Support activities for agriculture and forestry (115000)
	2121.col_min  Coal mining (212100)
	2122.led_min  "Copper, nickel, lead, and zinc mining (212230)"
	2122.ore_min  "Iron, gold, silver, and other metal ore mining (2122A0)"
	2123.stn_min  Stone mining and quarrying (212310)
	2123.oth_min  Other nonmetallic mineral mining and quarrying (2123A0)
	2131.drl_smn  Drilling oil and gas wells (213111)
	2131.oth_smn  Other support activities for mining (21311A)
	2211.ele_uti  "Electric power generation, transmission, and distribution (221100)"
	2212.gas_uti  Natural gas distribution (221200)
	2213.wat_uti  "Water, sewage and other systems (221300)"
	2332.hcs_con  Health care structures (233210)
	2332.edu_con  Educational and vocational structures (233262)
	2303.nmr_con  Nonresidential maintenance and repair (230301)
	2303.rmr_con  Residential maintenance and repair (230302)
	2332.off_con  Office and commercial structures (2332A0)
	2334.mrs_con  Multifamily residential structures (233412)
	2334.ors_con  Other residential structures (2334A0)
	2332.mfs_con  Manufacturing structures (233230)
	2332.ons_con  Other nonresidential structures (2332D0)
	2332.pwr_con  Power and communication structures (233240)
	2334.srs_con  Single-family residential structures (233411)
	2332.trn_con  Transportation structures and highways and streets (2332C0)
	3211.saw_wpd  Sawmills and wood preservation (321100)
	3212.ven_wpd  "Veneer, plywood, and engineered wood product manufacturing (321200)"
	3219.mil_wpd  Millwork (321910)
	3219.owp_wpd  All other wood product manufacturing (3219A0)
	3271.cly_nmp  Clay product and refractory manufacturing (327100)
	3272.gla_nmp  Glass and glass product manufacturing (327200)
	3273.cmt_nmp  Cement manufacturing (327310)
	3273.cnc_nmp  Ready-mix concrete manufacturing (327320)
	3273.cpb_nmp  "Concrete pipe, brick, and block manufacturing (327330)"
	3273.ocp_nmp  Other concrete product manufacturing (327390)
	3274.lme_nmp  Lime and gypsum product manufacturing (327400)
	3279.abr_nmp  Abrasive product manufacturing (327910)
	3279.cut_nmp  Cut stone and stone product manufacturing (327991)
	3279.tmn_nmp  Ground or treated mineral and earth manufacturing (327992)
	3279.wol_nmp  Mineral wool manufacturing (327993)
	3279.mnm_nmp  Miscellaneous nonmetallic mineral products (327999)
	3311.irn_pmt  Iron and steel mills and ferroalloy manufacturing (331110)
	3312.stl_pmt  Steel product manufacturing from purchased steel                        (331200)
	3313.ala_pmt  Alumina refining and primary aluminum production (331313)
	3313.alu_pmt  Aluminum product manufacturing from purchased aluminum (33131B)
	3314.nms_pmt  Nonferrous metal (except aluminum) smelting and refining (331410)
	3314.cop_pmt  "Copper rolling, drawing, extruding and alloying (331420)"
	3314.nfm_pmt  "Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)"
	3315.fmf_pmt  Ferrous metal foundries (331510)
	3315.nff_pmt  Nonferrous metal foundries (331520)
	3321.rol_fmt  Custom roll forming (332114)
	3321.fss_fmt  "All other forging, stamping, and sintering (33211A)"
	3321.crn_fmt  "Metal crown, closure, and other metal stamping (except automotive) (332119)"
	3322.cut_fmt  Cutlery and handtool manufacturing (332200)
	3323.plt_fmt  Plate work and fabricated structural product manufacturing (332310)
	3323.orn_fmt  Ornamental and architectural metal products manufacturing (332320)
	3324.pwr_fmt  Power boiler and heat exchanger manufacturing (332410)
	3324.mtt_fmt  Metal tank (heavy gauge) manufacturing (332420)
	3324.mtc_fmt  "Metal can, box, and other metal container (light gauge) manufacturing (332430)"
	3325.hdw_fmt  Hardware manufacturing (332500)
	3326.spr_fmt  Spring and wire product manufacturing (332600)
	3327.mch_fmt  Machine shops (332710)
	3327.tps_fmt  "Turned product and screw, nut, and bolt manufacturing (332720)"
	3328.ceh_fmt  "Coating, engraving, heat treating and allied activities (332800)"
	3329.plb_fmt  Plumbing fixture fitting and trim manufacturing (332913)
	3329.vlv_fmt  Valve and fittings other than plumbing (33291A)
	3329.bbr_fmt  Ball and roller bearing manufacturing (332991)
	3329.fab_fmt  Fabricated pipe and pipe fitting manufacturing (332996)
	3329.amn_fmt  "Ammunition, arms, ordnance, and accessories manufacturing (33299A)"
	3329.omf_fmt  Other fabricated metal manufacturing (332999)
	3331.frm_mch  Farm machinery and equipment manufacturing (333111)
	3331.lwn_mch  Lawn and garden equipment manufacturing (333112)
	3331.con_mch  Construction machinery manufacturing (333120)
	3331.min_mch  Mining and oil and gas field machinery manufacturing (333130)
	3332.smc_mch  Semiconductor machinery manufacturing (333242)
	3332.oti_mch  Other industrial machinery manufacturing (33329A)
	3333.opt_mch  Optical instrument and lens manufacturing (333314)
	3333.pht_mch  Photographic and photocopying equipment manufacturing (333316)
	3333.oci_mch  Other commercial and service industry machinery manufacturing (333318)
	3334.hea_mch  Heating equipment (except warm air furnaces) manufacturing (333414)
	3334.acn_mch  "Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)"
	3334.air_mch  Industrial and commercial fan and blower and air purification equipment manufacturing (333413)
	3335.imm_mch  Industrial mold manufacturing (333511)
	3335.spt_mch  "Special tool, die, jig, and fixture manufacturing (333514)"
	3335.mct_mch  Machine tool manufacturing (333517)
	3335.cut_mch  "Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)"
	3336.tbn_mch  Turbine and turbine generator set units manufacturing (333611)
	3336.spd_mch  "Speed changer, industrial high-speed drive, and gear manufacturing (333612)"
	3336.mch_mch  Mechanical power transmission equipment manufacturing (333613)
	3336.oee_mch  Other engine equipment manufacturing (333618)
	3339.agc_mch  Air and gas compressor manufacturing (333912)
	3339.ppe_mch  "Measuring, dispensing, and other pumping equipment manufacturing (333914)"
	3339.mat_mch  Material handling equipment manufacturing (333920)
	3339.pwr_mch  Power-driven handtool manufacturing (333991)
	3339.pkg_mch  Packaging machinery manufacturing (333993)
	3339.ipf_mch  Industrial process furnace and oven manufacturing (333994)
	3339.ogp_mch  Other general purpose machinery manufacturing (33399A)
	3339.fld_mch  Fluid power process machinery (33399B)
	3341.ecm_cep  Electronic computer manufacturing (334111)
	3341.csd_cep  Computer storage device manufacturing (334112)
	3341.ctm_cep  Computer terminals and other computer peripheral equipment manufacturing (334118)
	3342.tel_cep  Telephone apparatus manufacturing (334210)
	3342.brd_cep  Broadcast and wireless communications equipment (334220)
	3342.oce_cep  Other communications equipment manufacturing (334290)
	3344.sem_cep  Semiconductor and related device manufacturing (334413)
	3344.prc_cep  Printed circuit assembly (electronic assembly) manufacturing (334418)
	3344.oec_cep  Other electronic component manufacturing (33441A)
	3345.eea_cep  Electromedical and electrotherapeutic apparatus manufacturing (334510)
	3345.sdn_cep  "Search, detection, and navigation instruments manufacturing (334511)"
	3345.aec_cep  Automatic environmental control manufacturing (334512)
	3345.ipv_cep  Industrial process variable instruments manufacturing (334513)
	3345.tfl_cep  Totalizing fluid meter and counting device manufacturing (334514)
	3345.els_cep  Electricity and signal testing instruments manufacturing (334515)
	3345.ali_cep  Analytical laboratory instrument manufacturing (334516)
	3345.irr_cep  Irradiation apparatus manufacturing (334517)
	3345.wcm_cep  "Watch, clock, and other measuring and controlling device manufacturing (33451A)"
	3343.aud_cep  Audio and video equipment manufacturing (334300)
	3346.mmo_cep  Manufacturing and reproducing magnetic and optical media (334610)
	3351.elb_eec  Electric lamp bulb and part manufacturing (335110)
	3351.ltf_eec  Lighting fixture manufacturing (335120)
	3352.sea_eec  Small electrical appliance manufacturing (335210)
	3352.ham_eec  Major household appliance manufacturing (335221)
	3353.pwr_eec  "Power, distribution, and specialty transformer manufacturing (335311)"
	3353.mtg_eec  Motor and generator manufacturing (335312)
	3353.swt_eec  Switchgear and switchboard apparatus manufacturing (335313)
	3353.ric_eec  Relay and industrial control manufacturing (335314)
	3359.sbt_eec  Storage battery manufacturing (335911)
	3359.pbt_eec  Primary battery manufacturing (335912)
	3359.cme_eec  Communication and energy wire and cable manufacturing (335920)
	3359.wdv_eec  Wiring device manufacturing (335930)
	3359.cbn_eec  Carbon and graphite product manufacturing (335991)
	3359.oee_eec  All other miscellaneous electrical equipment and component manufacturing (335999)
	3361.atm_mot  Automobile manufacturing (336111)
	3361.ltr_mot  Light truck and utility vehicle manufacturing (336112)
	3361.htr_mot  Heavy duty truck manufacturing (336120)
	3362.mbd_mot  Motor vehicle body manufacturing (336211)
	3362.trl_mot  Truck trailer manufacturing (336212)
	3362.hom_mot  Motor home manufacturing (336213)
	3362.cam_mot  Travel trailer and camper manufacturing (336214)
	3363.gas_mot  Motor vehicle gasoline engine and engine parts manufacturing (336310)
	3363.eee_mot  Motor vehicle electrical and electronic equipment manufacturing (336320)
	3363.tpw_mot  Motor vehicle transmission and power train parts manufacturing (336350)
	3363.trm_mot  Motor vehicle seating and interior trim manufacturing (336360)
	3363.stm_mot  Motor vehicle metal stamping (336370)
	3363.omv_mot  Other motor vehicle parts manufacturing (336390)
	3363.brk_mot  "Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)"
	3364.air_ote  Aircraft manufacturing (336411)
	3364.aen_ote  Aircraft engine and engine parts manufacturing (336412)
	3364.oar_ote  Other aircraft parts and auxiliary equipment manufacturing (336413)
	3364.mis_ote  Guided missile and space vehicle manufacturing (336414)
	3364.pro_ote  Propulsion units and parts for space vehicles and guided missiles (33641A)
	3365.rrd_ote  Railroad rolling stock manufacturing (336500)
	3366.shp_ote  Ship building and repairing (336611)
	3366.bot_ote  Boat building (336612)
	3369.mcl_ote  "Motorcycle, bicycle, and parts manufacturing (336991)"
	3369.mlt_ote  "Military armored vehicle, tank, and tank component manufacturing (336992)"
	3369.otm_ote  All other transportation equipment manufacturing (336999)
	3371.cab_fpd  Wood kitchen cabinet and countertop manufacturing (337110)
	3371.uph_fpd  Upholstered household furniture manufacturing (337121)
	3371.nup_fpd  Nonupholstered wood household furniture manufacturing (337122)
	3371.ifm_fpd  Institutional furniture manufacturing (337127)
	3371.ohn_fpd  Other household nonupholstered furniture (33712N)
	3372.shv_fpd  "Showcase, partition, shelving, and locker manufacturing (337215)"
	3372.off_fpd  Office furniture and custom architectural woodwork and millwork manufacturing (33721A)
	3379.ofp_fpd  Other furniture related product manufacturing (337900)
	3391.smi_mmf  Surgical and medical instrument manufacturing (339112)
	3391.sas_mmf  Surgical appliance and supplies manufacturing (339113)
	3391.dnt_mmf  Dental equipment and supplies manufacturing (339114)
	3391.oph_mmf  Ophthalmic goods manufacturing (339115)
	3391.dlb_mmf  Dental laboratories (339116)
	3399.jwl_mmf  Jewelry and silverware manufacturing (339910)
	3399.ath_mmf  Sporting and athletic goods manufacturing (339920)
	3399.toy_mmf  "Doll, toy, and game manufacturing (339930)"
	3399.ofm_mmf  Office supplies (except paper) manufacturing (339940)
	3399.sgn_mmf  Sign manufacturing (339950)
	3399.omm_mmf  All other miscellaneous manufacturing (339990)
	3111.dog_fbp  Dog and cat food manufacturing (311111)
	3111.oaf_fbp  Other animal food manufacturing (311119)
	3112.flr_fbp  Flour milling and malt manufacturing (311210)
	3112.wet_fbp  Wet corn milling (311221)
	3112.fat_fbp  Fats and oils refining and blending (311225)
	3112.soy_fbp  Soybean and other oilseed processing (311224)
	3112.brk_fbp  Breakfast cereal manufacturing (311230)
	3113.sug_fbp  Sugar and confectionery product manufacturing (311300)
	3114.fzn_fbp  Frozen food manufacturing (311410)
	3114.can_fbp  "Fruit and vegetable canning, pickling, and drying (311420)"
	3115.chs_fbp  Cheese manufacturing (311513)
	3115.dry_fbp  "Dry, condensed, and evaporated dairy product manufacturing (311514)"
	3115.mlk_fbp  Fluid milk and butter manufacturing (31151A)
	3115.ice_fbp  Ice cream and frozen dessert manufacturing (311520)
	3116.chk_fbp  Poultry processing (311615)
	3116.asp_fbp  "Animal (except poultry) slaughtering, rendering, and processing (31161A)"
	3117.sea_fbp  Seafood product preparation and packaging (311700)
	3118.brd_fbp  Bread and bakery product manufacturing (311810)
	3118.cok_fbp  "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)"
	3119.snk_fbp  Snack food manufacturing (311910)
	3119.tea_fbp  Coffee and tea manufacturing (311920)
	3119.syr_fbp  Flavoring syrup and concentrate manufacturing (311930)
	3119.spc_fbp  Seasoning and dressing manufacturing (311940)
	3119.ofm_fbp  All other food manufacturing (311990)
	3121.pop_fbp  Soft drink and ice manufacturing (312110)
	3121.ber_fbp  Breweries (312120)
	3121.wne_fbp  Wineries (312130)
	3121.why_fbp  Distilleries (312140)
	3122.cig_fbp  Tobacco manufacturing (312200)
	3131.fyt_tex  "Fiber, yarn, and thread mills (313100)"
	3132.fml_tex  Fabric mills (313200)
	3133.txf_tex  Textile and fabric finishing and fabric coating mills (313300)
	3141.rug_tex  Carpet and rug mills (314110)
	3141.lin_tex  Curtain and linen mills (314120)
	3149.otp_tex  Other textile product mills (314900)
	3150.app_alt  Apparel manufacturing (315000)
	3160.lea_alt  Leather and allied product manufacturing (316000)
	3221.plp_ppd  Pulp mills (322110)
	3221.ppm_ppd  Paper mills (322120)
	3221.pbm_ppd  Paperboard mills (322130)
	3222.pbc_ppd  Paperboard container manufacturing (322210)
	3222.ppb_ppd  Paper bag and coated and treated paper manufacturing (322220)
	3222.sta_ppd  Stationery product manufacturing (322230)
	3222.toi_ppd  Sanitary paper product manufacturing (322291)
	3222.opp_ppd  All other converted paper product manufacturing (322299)
	3231.pri_pri  Printing (323110)
	3231.sap_pri  Support activities for printing (323120)
	3241.ref_pet  Petroleum refineries (324110)
	3241.pav_pet  Asphalt paving mixture and block manufacturing (324121)
	3241.shn_pet  Asphalt shingle and coating materials manufacturing (324122)
	3241.oth_pet  Other petroleum and coal products manufacturing (324190)
	3251.ptr_che  Petrochemical manufacturing (325110)
	3251.igm_che  Industrial gas manufacturing (325120)
	3251.sdp_che  Synthetic dye and pigment manufacturing (325130)
	3251.obi_che  Other basic inorganic chemical manufacturing (325180)
	3251.obo_che  Other basic organic chemical manufacturing (325190)
	3252.pmr_che  Plastics material and resin manufacturing (325211)
	3252.srf_che  Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)
	3254.mbm_che  Medicinal and botanical manufacturing (325411)
	3254.phm_che  Pharmaceutical preparation manufacturing (325412)
	3254.inv_che  In-vitro diagnostic substance manufacturing (325413)
	3254.bio_che  Biological product (except diagnostic) manufacturing (325414)
	3253.fmf_che  Fertilizer manufacturing (325310)
	3253.pag_che  Pesticide and other agricultural chemical manufacturing (325320)
	3255.pnt_che  Paint and coating manufacturing (325510)
	3255.adh_che  Adhesive manufacturing (325520)
	3256.sop_che  Soap and cleaning compound manufacturing (325610)
	3256.toi_che  Toilet preparation manufacturing (325620)
	3259.pri_che  Printing ink manufacturing (325910)
	3259.och_che  All other chemical product and preparation manufacturing (3259A0)
	3261.plm_pla  Plastics packaging materials and unlaminated film and sheet manufacturing (326110)
	3261.ppp_pla  "Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)"
	3261.lam_pla  "Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)"
	3261.fom_pla  Polystyrene foam product manufacturing (326140)
	3261.ure_pla  Urethane and other foam product (except polystyrene) manufacturing (326150)
	3261.bot_pla  Plastics bottle manufacturing (326160)
	3261.opm_pla  Other plastics product manufacturing (326190)
	3262.tir_pla  Tire manufacturing (326210)
	3262.rbr_pla  Rubber and plastics hoses and belting manufacturing (326220)
	3262.orb_pla  Other rubber product manufacturing (326290)
	4231.mtv_wht  Motor vehicle and motor vehicle parts and supplies (423100)
	4234.pce_wht  Professional and commercial equipment and supplies (423400)
	4236.hha_wht  Household appliances and electrical and electronic goods (423600)
	4238.mch_wht  "Machinery, equipment, and supplies (423800)"
	423A.odg_wht  Other durable goods merchant wholesalers (423A00)
	4242.dru_wht  Drugs and druggists' sundries (424200)
	4244.gro_wht  Grocery and related product wholesalers (424400)
	4247.pet_wht  Petroleum and petroleum products (424700)
	424A.ndg_wht  Other nondurable goods merchant wholesalers (424A00)
	4250.ele_wht  Wholesale electronic markets and agents and brokers (425000)
	4200.dut_wht  Customs duties (4200ID)
	4440.bui_ott  Building material and garden equipment and supplies dealers (444000)
	4460.hea_ott  Health and personal care stores (446000)
	4470.gas_ott  Gasoline stations (447000)
	4480.clo_ott  Clothing and clothing accessories stores (448000)
	4540.non_ott  Nonstore retailers (454000)
	4B00.oth_ott  All other retail (4B0000)
	48A0.sce_otr  Scenic and sightseeing transportation and support activities (48A000)
	4920.mes_otr  Couriers and messengers (492000)
	5111.new_pub  Newspaper publishers (511110)
	5111.pdl_pub  Periodical publishers (511120)
	5111.bok_pub  Book publishers (511130)
	5111.mal_pub  "Directory, mailing list, and other publishers (5111A0)"
	5112.sfw_pub  Software publishers (511200)
	5121.pic_mov  Motion picture and video industries (512100)
	5122.snd_mov  Sound recording industries (512200)
	5151.rad_brd  Radio and television broadcasting (515100)
	5152.cbl_brd  Cable and other subscription programming (515200)
	5171.wtl_brd  Wired telecommunications carriers (517110)
	5172.wls_brd  Wireless telecommunications carriers (except satellite) (517210)
	517A.sat_brd  "Satellite, telecommunications resellers, and all other telecommunications (517A00)"
	5182.dpr_dat  "Data processing, hosting, and related services (518200)"
	5191.int_dat  Internet publishing and broadcasting and Web search portals (519130)
	5191.new_dat  "News syndicates, libraries, archives and all other information services (5191A0)"
	522A.cre_bnk  Nondepository credit intermediation and related activities (522A00)
	52A0.mon_bnk  Monetary authorities and depository credit intermediation (52A000)
	5239.ofi_sec  Other financial investment activities (523900)
	523A.com_sec  Securities and commodity contracts intermediation and brokerage (523A00)
	5241.dir_ins  Direct life insurance carriers (524113)
	5241.car_ins  "Insurance carriers, except direct life (5241XX)"
	5242.agn_ins  "Insurance agencies, brokerages, and related activities (524200)"
	531H.own_hou  Owner-occupied housing (531HSO)
	531H.rnt_hou  Tenant-occupied housing (531HST)
	5321.aut_rnt  Automotive equipment rental and leasing (532100)
	5324.com_rnt  Commercial and industrial machinery and equipment rental and leasing (532400)
	532A.cmg_rnt  General and consumer goods rental (532A00)
	5330.int_rnt  Lessors of nonfinancial intangible assets (533000)
	5415.cus_com  Custom computer programming services (541511)
	5415.sys_com  Computer systems design services (541512)
	5415.ocs_com  "Other computer related services, including facilities management (54151A)"
	5412.acc_tsv  "Accounting, tax preparation, bookkeeping, and payroll services (541200)"
	5413.arc_tsv  "Architectural, engineering, and related services (541300)"
	5416.mgt_tsv  Management consulting services (541610)
	5416.env_tsv  Environmental and other technical consulting services (5416A0)
	5417.sci_tsv  Scientific research and development services (541700)
	5418.adv_tsv  "Advertising, public relations, and related services (541800)"
	5414.des_tsv  Specialized design services (541400)
	5419.pht_tsv  Photographic services (541920)
	5419.vet_tsv  Veterinary services (541940)
	5419.mkt_tsv  "All other miscellaneous professional, scientific, and technical services (5419A0)"
	5613.emp_adm  Employment services (561300)
	5617.dwe_adm  Services to buildings and dwellings (561700)
	5611.off_adm  Office administrative services (561100)
	5612.fac_adm  Facilities support services (561200)
	5614.bsp_adm  Business support services (561400)
	5615.trv_adm  Travel arrangement and reservation services (561500)
	5616.inv_adm  Investigation and security services (561600)
	5619.oss_adm  Other support services (561900)
	6111.sec_edu  Elementary and secondary schools (611100)
	611A.uni_edu  "Junior colleges, colleges, universities, and professional schools (611A00)"
	611B.oes_edu  Other educational services (611B00)
	6211.phy_amb  Offices of physicians (621100)
	6212.dnt_amb  Offices of dentists (621200)
	6213.ohp_amb  Offices of other health practitioners (621300)
	6214.out_amb  Outpatient care centers (621400)
	6215.lab_amb  Medical and diagnostic laboratories (621500)
	6216.hom_amb  Home health care services (621600)
	6219.oas_amb  Other ambulatory health care services (621900)
	623A.ncc_nrs  Nursing and community care facilities (623A00)
	623B.res_nrs  "Residential mental health, substance abuse, and other residential care facilities (623B00)"
	6241.ifs_soc  Individual and family services (624100)
	6244.day_soc  Child day care services (624400)
	624A.cmf_soc  "Community food, housing, and other relief services, including vocational rehabilitation services (624A00)"
	7111.pfm_art  Performing arts companies (711100)
	7112.spr_art  Spectator sports (711200)
	7115.ind_art  "Independent artists, writers, and performers (711500)"
	711A.agt_art  Promoters of performing arts and sports and agents for public figures (711A00)
	7120.mus_art  "Museums, historical sites, zoos, and parks (712000)"
	7131.amu_rec  Amusement parks and arcades (713100)
	7132.cas_rec  Gambling industries (except casino hotels) (713200)
	7139.ori_rec  Other amusement and recreation industries (713900)
	7221.ful_res  Full-service restaurants (722110)
	7222.lim_res  Limited-service restaurants (722211)
	722A.ofd_res  All other food and drinking places (722A00)
	8111.atr_osv  Automotive repair and maintenance (including car washes) (811100)
	8112.eqr_osv  Electronic and precision equipment repair and maintenance (811200)
	8113.imr_osv  Commercial and industrial machinery and equipment repair and maintenance (811300)
	8114.hgr_osv  Personal and household goods repair and maintenance (811400)
	8121.pcs_osv  Personal care services (812100)
	8122.fun_osv  Death care services (812200)
	8123.dry_osv  Dry-cleaning and laundry services (812300)
	8129.ops_osv  Other personal services (812900)
	8131.rel_osv  Religious organizations (813100)
	813A.grt_osv  "Grantmaking, giving, and social advocacy organizations (813A00)"
	813B.civ_osv  "Civic, social, professional, and similar organizations (813B00)"
	8140.prv_osv  Private households (814000)
	4910.pst_fen  Postal service (491000)
	S001.ofg_fen  Other federal government enterprises (S00102)
	GSLG.edu_slg  State and local government (educational services) (GSLGE)
	GSLG.hea_slg  State and local government (hospitals and health services) (GSLGH)
	GSLG.oth_slg  State and local government (other services) (GSLGO)
	S002.osl_sle  Other state and local government enterprises (S00203)
	S004.srp_usd  Scrap (S00401)
	S004.sec_usd  Used and secondhand goods (S00402)
	S003.imp_oth  Noncomparable imports (S00300)
	S009.rwa_oth  Rest of the world adjustment (S00900)
	3313.sme_pmt  Secondary smelting and alloying of aluminum (331314)
	S001.ele_fen  Federal electric utilities (S00101)
	S002.trn_sle  State and local government passenger transit (S00201) 
	S002.ele_sle  State and local government electric utilities (S00202) /;

set	row(*)	Rows in the SAGDP database;
set	nr(*)	NAICS codes assigned to SAGDP rows;

set nrm(nr<,row<)	NAICs codes in SAGDP descriptions /
	(11).3		"Agriculture, forestry, fishing and hunting (11)",
	(111*112).4	"Farms (111-112)",
	(113*115).5	"Forestry, fishing, and related activities (113-115)",
	(21).6		"Mining, quarrying, and oil and gas extraction (21)",
	(211).7		"Oil and gas extraction (211)",
	(212).8		"Mining (except oil and gas) (212)",
	(213).9		"Support activities for mining (213)",
	(22).10		"Utilities (22)",
	(23).11		"Construction  (23)",
	(31*33).12	"Manufacturing (31-33)",
	(321).14	"Wood product manufacturing (321)",
	(327).15	"Nonmetallic mineral product manufacturing (327)",
	(331).16	"Primary metal manufacturing (331)",
	(332).17	"Fabricated metal product manufacturing (332)",
	(333).18	"Machinery manufacturing (333)",
	(334).19	"Computer and electronic product manufacturing (334)",
	(335).20	"Electrical equipment, appliance, and component manufacturing (335)",
	(3361*3363).21	"Motor vehicles, bodies and trailers, and parts manufacturing (3361-3363)",
	(3364*3466).22	"Other transportation equipment manufacturing (3364-3466)",
	(337).23	"Furniture and related product manufacturing (337)",
	(339).24	"Miscellaneous manufacturing (339)",
	(311*312).26	"Food and beverage and tobacco product manufacturing (311-312)",
	(313*314).27	"Textile mills and textile product mills (313-314)",
	(315*316).28	"Apparel, leather, and allied product manufacturing (315-316)",
	(322).29	"Paper manufacturing (322)",
	(323).30	"Printing and related support activities (323)",
	(324).31	"Petroleum and coal products manufacturing (324)",
	(325).32	"Chemical manufacturing (325)",
	(326).33	"Plastics and rubber products manufacturing (326)",
	(42).34		"Wholesale trade (42)",
	(44*45).35	"Retail trade (44-45)",
	(48*49).36	"Transportation and warehousing (48-49)",
	(481).37	"Air transportation (481)",
	(482).38	"Rail transportation (482)",
	(483).39	"Water transportation (483)",
	(484).40	"Truck transportation (484)",
	(485).41	"Transit and ground passenger transportation (485)",
	(486).42	"Pipeline transportation (486)",
	(487*488,491*492).43	 "Other transportation and support activities  (487-488,492)",
	(493).44	"Warehousing and storage (493)",
	(51).45		"Information (51)",
	(511).46	"Publishing industries (except Internet) (511)",
	(512).47	"Motion picture and sound recording industries (512)",
	(515, 517).48	"Broadcasting (except Internet) and telecommunications (515, 517)",
	(518*519).49	"Data processing, hosting, and other information services (518-519)",
	(52,53).50	"Finance, insurance, real estate, rental, and leasing (52,53)",
	(52).51		"Finance and insurance (52)",
	(521*522).52	"Monetary Authorities- central bank, credit intermediation, and related services (521-522)",
	(523).53	"Securities, commodity contracts, and other financial investments and related activities (523)",
	(524).54	"Insurance carriers and related activities (524)",
	(525).55	"Funds, trusts, and other financial vehicles (525)",
	(53).56		"Real estate and rental and leasing (53)",
	(531).57	"Real estate (531)",
	(532*533).58	"Rental and leasing services and lessors of nonfinancial intangible assets (532-533)",
	(54).60		"Professional, scientific, and technical services (54)",
	(5411).61	"Legal services (5411)",
	(5415).62	"Computer systems design and related services (5415)",
	(5412*5414,5416*5419).63	 "Miscellaneous professional, scientific, and technical services (5412-5414,5416-5419)",
	(55).64		"Management of companies and enterprises (55)",
	(56).65		"Administrative and support and waste management and remediation services (56)",
	(561).66	"Administrative and support services (561)",
	(562).67	"Waste management and remediation services (562)",
	(61).69		"Educational services (61)",
	(62).70		"Health care and social assistance (62)",
	(621).71	"Ambulatory health care services (621)",
	(622).72	"Hospitals (622)",
	(623).73	"Nursing and residential care facilities (623)",
	(624).74	"Social assistance (624)",
	(71,72).75	"Arts, entertainment, recreation, accommodation, and food services (71,72)",
	(71).76		"Arts, entertainment, and recreation (71)",
	(711*712).77	"Performing arts, spectator sports, museums, and related activities (711-712)",
	(713).78	"Amusement, gambling, and recreation industries (713)",
	(72).79		"Accommodation and food services (72)",
	(721).80	"Accommodation (721)",
	(722).81	"Food services and drinking places (722)",
	(81).82		"Other services (except government and government enterprises) (81)",
	(92).83		"Government and government enterprises (92)",
	(11,21).87	"Natural resources and mining (11,21)",

*	No NAICs codes are given -- these are assigned with declaration of ID_ROW:
	(" ").84	"Federal civilian",
	(" ").85	"Military",
	(" ").86	"State and local",
	(" ").92	"Private services-providing industries",

*	These are all redundant rows -- totals of values in other rows:

	(" ").1		"All industry total",
	(" ").2		"Private industries",
	(" ").13	 "Durable goods manufacturing (321,327-339)",
	(" ").25	"Nondurable goods manufacturing (311-316,322-326)",
	(" ").59	"Professional and business services (54,55,56)",
	(" ").68	"Educational services, health care, and social assistance (61,62)",
	(" ").88	"Trade (42,44-45)",						
	(" ").89	"Transportation and utilities (22,48-49)",
	(" ").90	"Manufacturing and information (31-33,51)",
	(" ").91	"Private goods-producing industries",
	(" ").100	  "All industry total, overseas activity "
	(" ").101	  "Government and government enterprises, overseas activity"
	(" ").102	  "Federal civilian, overseas activity ",
	(" ").103	  "Military, overseas activity " /;

*	Determine whether two UELs "match", look at characters defined by set k:

set	k		Characters to compare /1*4/;

$macro	tlmatch(i,j)	((sum(k$(k.val<=min(card(i.tl),card(j.tl))),1$(ord(i.tl,k.val)=ord(j.tl,k.val)))=min(card(i.tl),card(j.tl)))$min(card(i.tl),card(j.tl)>0))

set	match(n4,nr)	Labels in n4 which match to labels in nr;
match(n4,nr) = tlmatch(n4,nr);

parameter	nmatch(n4)	Maximum number of characters which match;
nmatch(n4) = smax(match(n4,nr),card(nr.tl));

set	goodmatch(n4,nr)	Matches with largest number of characters,
	nomatch(n4)		Labels with no mapping;

loop(n4_id(n4,id),
	goodmatch(match(n4,nr)) = n4_id(n4_id)$(card(nr.tl)=nmatch(n4));
	nomatch(n4) = n4_id(n4_id)$(not sum(match(n4,nr),1));
);

option nomatch:0:0:1, goodmatch:0:0:1;
display goodmatch,nomatch;

set	id_row(id,row)	Assignment of sectors to SAGDP rows /

*	Initialize with "exogenous" assignments:

	oth_ott.35  All other retail				(4B0000)
	fdd.85  Federal general government (defense)	(S00500)
	fnd.84  Federal general government (nondefense)	(S00600)
	(srp_usd,sec_usd).1					(S00402)
	imp_oth.1  Noncomparable imports			(S00300)
	rwa_oth.1  Rest of the world adjustment			(S00900) 
	(edu_slg,hea_slg,oth_slg).86				(GSLGO)
	(trn_sle,ele_sle,osl_sle).86				(S00203)
	(ele_fen,ofg_fen).92					(S00102)

*	These get mapped to multiple rows -- here we make an exogenous assignment to 
*	the seemingly correct row:

	sce_otr.43	Scenic and sightseeing transportation and support activities	(48A000),
	mon_bnk.52	Monetary authorities and depository credit intermediation	(52A000) /;

set	assigned(id)	Sectors are assigned explicitly;
option assigned<id_row;

*	Explicit assignments first:

loop((n4_id(n4,id),goodmatch(n4,nr),nrm(nr,row))$((not assigned(id)) and sameas(n4,nr)),
	id_row(id,row) = n4_id(n4_id);
);
option assigned<id_row;

*	Then the rest:

loop((n4_id(n4,id),goodmatch(n4,nr))$(not assigned(id)),
	id_row(id,row)$nrm(nr,row) = n4_id(n4_id);
);
option id_row:0:0:1;
display id_row;

*	Verify that all the sectors are uniquely assigned:
parameter	mapbug;
mapbug(id) = sum(id_row(id,row),1)-1;
option mapbug:0:0:1;
abort$card(mapbug)	"Error in mapping", mapbug;

parameter	nmap(row)	Number of sectors to which row is mapped;
nmap(row) = sum(id_row(id,row),1);
option nmap:0:0:8;
display nmap;

set	ignored(row)	Rows which are ignored;
loop(nrm(nr,row), ignored(row) = nrm(nrm)$(nmap(row)<0.5));

option ignored:0:0:1;
display ignored;

*	Retrieve descriptive text for the rows:

set	rowtext(row); loop(nrm(nr,row), rowtext(row) = nrm(nrm););

file ktxt /SAGDPmap.txt/; put ktxt; ktxt.lw=0;
loop(row,
	put row.tl,@20,rowtext.te(row)/;
	  loop((id_row(id,row),n4_id(n4,id)),
		put '     ---- ',id.tl,'.',n4.tl,@25,n4_id.te(n4,id)/;);
);

execute_unload 'SAGDPmap.gdx',id_row;
