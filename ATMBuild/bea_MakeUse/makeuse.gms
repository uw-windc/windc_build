$title	Check Identities in the Make-Use Table

$ontext

----   1006 PARAMETER atm  Agricultural trade multiplier

                  X           E
bef_agr       1.737       1.421
egg_agr       1.463       1.251		X	Agricultural content of domestic output
dry_agr       1.264       1.029		E	Agricultural content of exports (net margins)
ota_agr       1.150       0.940
oth_agr       1.076       0.859
flo_agr       1.160       0.827
nut_agr       1.040       0.756
osd_agr       1.290       0.733
veg_agr       1.053       0.700
grn_agr       1.200       0.629

asp_fbp       0.902       0.797
chk_fbp       0.710       0.668
soy_fbp       0.730       0.558
chs_fbp       0.590       0.528
mlk_fbp       0.532       0.480
fat_fbp       0.542       0.435
flr_fbp       0.478       0.371
dry_fbp       0.401       0.321
wet_fbp       0.410       0.308
oaf_fbp       0.408       0.279
fzn_fbp       0.342       0.275
tea_fbp       0.291       0.232
dog_fbp       0.291       0.232
snk_fbp       0.267       0.230
ice_fbp       0.254       0.228
brk_fbp       0.265       0.214
can_fbp       0.195       0.156
cok_fbp       0.192       0.154
sug_fbp       0.177       0.152
brd_fbp       0.136       0.109

$offtext

parameter	scale	Scale factor /1e-3/;

set  d	Detailed table sectors (and commodities) -- WiNDC labels /
	osd_agr  "Oilseed farming (1111A0)",
	grn_agr  "Grain farming (1111B0)",
	veg_agr  "Vegetable and melon farming (111200)",
	nut_agr  "Fruit and tree nut farming (111300)",
	flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
	oth_agr  "Other crop farming (111900)",
	dry_agr  "Dairy cattle and milk production (112120)",
	bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
	egg_agr  "Poultry and egg production (112300)",
	ota_agr  "Animal production, except cattle and poultry and eggs (112A00)",
	log_fof  "Forestry and logging (113000)",
	fht_fof  "Fishing, hunting and trapping (114000)",
	saf_fof  "Support activities for agriculture and forestry (115000)",
	oil      "Oil and gas extraction (211000)",
	col_min  "Coal mining (212100)",
	led_min  "Copper, nickel, lead, and zinc mining (212230)",
	ore_min  "Iron, gold, silver, and other metal ore mining (2122A0)",
	stn_min  "Stone mining and quarrying (212310)",
	oth_min  "Other nonmetallic mineral mining and quarrying (2123A0)",
	drl_smn  "Drilling oil and gas wells (213111)",
	oth_smn  "Other support activities for mining (21311A)",
	ele_uti  "Electric power generation, transmission, and distribution (221100)",
	gas_uti  "Natural gas distribution (221200)",
	wat_uti  "Water, sewage and other systems (221300)",
	hcs_con  "Health care structures (233210)",
	edu_con  "Educational and vocational structures (233262)",
	nmr_con  "Nonresidential maintenance and repair (230301)",
	rmr_con  "Residential maintenance and repair (230302)",
	off_con  "Office and commercial structures (2332A0)",
	mrs_con  "Multifamily residential structures (233412)",
	ors_con  "Other residential structures (2334A0)",
	mfs_con  "Manufacturing structures (233230)",
	ons_con  "Other nonresidential structures (2332D0)",
	pwr_con  "Power and communication structures (233240)",
	srs_con  "Single-family residential structures (233411)",
	trn_con  "Transportation structures and highways and streets (2332C0)",
	saw_wpd  "Sawmills and wood preservation (321100)",
	ven_wpd  "Veneer, plywood, and engineered wood product manufacturing (321200)",
	mil_wpd  "Millwork (321910)",
	owp_wpd  "All other wood product manufacturing (3219A0)",
	cly_nmp  "Clay product and refractory manufacturing (327100)",
	gla_nmp  "Glass and glass product manufacturing (327200)",
	cmt_nmp  "Cement manufacturing (327310)",
	cnc_nmp  "Ready-mix concrete manufacturing (327320)",
	cpb_nmp  "Concrete pipe, brick, and block manufacturing (327330)",
	ocp_nmp  "Other concrete product manufacturing (327390)",
	lme_nmp  "Lime and gypsum product manufacturing (327400)",
	abr_nmp  "Abrasive product manufacturing (327910)",
	cut_nmp  "Cut stone and stone product manufacturing (327991)",
	tmn_nmp  "Ground or treated mineral and earth manufacturing (327992)",
	wol_nmp  "Mineral wool manufacturing (327993)",
	mnm_nmp  "Miscellaneous nonmetallic mineral products (327999)",
	irn_pmt  "Iron and steel mills and ferroalloy manufacturing (331110)",
	stl_pmt  "Steel product manufacturing from purchased steel                        (331200)",
	ala_pmt  "Alumina refining and primary aluminum production (331313)",
	alu_pmt  "Aluminum product manufacturing from purchased aluminum (33131B)",
	nms_pmt  "Nonferrous metal (except aluminum) smelting and refining (331410)",
	cop_pmt  "Copper rolling, drawing, extruding and alloying (331420)",
	nfm_pmt  "Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)",
	fmf_pmt  "Ferrous metal foundries (331510)",
	nff_pmt  "Nonferrous metal foundries (331520)",
	rol_fmt  "Custom roll forming (332114)",
	fss_fmt  "All other forging, stamping, and sintering (33211A)",
	crn_fmt  "Metal crown, closure, and other metal stamping (except automotive) (332119)",
	cut_fmt  "Cutlery and handtool manufacturing (332200)",
	plt_fmt  "Plate work and fabricated structural product manufacturing (332310)",
	orn_fmt  "Ornamental and architectural metal products manufacturing (332320)",
	pwr_fmt  "Power boiler and heat exchanger manufacturing (332410)",
	mtt_fmt  "Metal tank (heavy gauge) manufacturing (332420)",
	mtc_fmt  "Metal can, box, and other metal container (light gauge) manufacturing (332430)",
	hdw_fmt  "Hardware manufacturing (332500)",
	spr_fmt  "Spring and wire product manufacturing (332600)",
	mch_fmt  "Machine shops (332710)",
	tps_fmt  "Turned product and screw, nut, and bolt manufacturing (332720)",
	ceh_fmt  "Coating, engraving, heat treating and allied activities (332800)",
	plb_fmt  "Plumbing fixture fitting and trim manufacturing (332913)",
	vlv_fmt  "Valve and fittings other than plumbing (33291A)",
	bbr_fmt  "Ball and roller bearing manufacturing (332991)",
	fab_fmt  "Fabricated pipe and pipe fitting manufacturing (332996)",
	amn_fmt  "Ammunition, arms, ordnance, and accessories manufacturing (33299A)",
	omf_fmt  "Other fabricated metal manufacturing (332999)",
	frm_mch  "Farm machinery and equipment manufacturing (333111)",
	lwn_mch  "Lawn and garden equipment manufacturing (333112)",
	con_mch  "Construction machinery manufacturing (333120)",
	min_mch  "Mining and oil and gas field machinery manufacturing (333130)",
	smc_mch  "Semiconductor machinery manufacturing (333242)",
	oti_mch  "Other industrial machinery manufacturing (33329A)",
	opt_mch  "Optical instrument and lens manufacturing (333314)",
	pht_mch  "Photographic and photocopying equipment manufacturing (333316)",
	oci_mch  "Other commercial and service industry machinery manufacturing (333318)",
	hea_mch  "Heating equipment (except warm air furnaces) manufacturing (333414)",
	acn_mch  "Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)",
	air_mch  "Industrial and commercial fan and blower and air purification equipment manufacturing (333413)",
	imm_mch  "Industrial mold manufacturing (333511)",
	spt_mch  "Special tool, die, jig, and fixture manufacturing (333514)",
	mct_mch  "Machine tool manufacturing (333517)",
	cut_mch  "Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)",
	tbn_mch  "Turbine and turbine generator set units manufacturing (333611)",
	spd_mch  "Speed changer, industrial high-speed drive, and gear manufacturing (333612)",
	mch_mch  "Mechanical power transmission equipment manufacturing (333613)",
	oee_mch  "Other engine equipment manufacturing (333618)",
	agc_mch  "Air and gas compressor manufacturing (333912)",
	ppe_mch  "Measuring, dispensing, and other pumping equipment manufacturing (333914)",
	mat_mch  "Material handling equipment manufacturing (333920)",
	pwr_mch  "Power-driven handtool manufacturing (333991)",
	pkg_mch  "Packaging machinery manufacturing (333993)",
	ipf_mch  "Industrial process furnace and oven manufacturing (333994)",
	ogp_mch  "Other general purpose machinery manufacturing (33399A)",
	fld_mch  "Fluid power process machinery (33399B)",
	ecm_cep  "Electronic computer manufacturing (334111)",
	csd_cep  "Computer storage device manufacturing (334112)",
	ctm_cep  "Computer terminals and other computer peripheral equipment manufacturing (334118)",
	tel_cep  "Telephone apparatus manufacturing (334210)",
	brd_cep  "Broadcast and wireless communications equipment (334220)",
	oce_cep  "Other communications equipment manufacturing (334290)",
	sem_cep  "Semiconductor and related device manufacturing (334413)",
	prc_cep  "Printed circuit assembly (electronic assembly) manufacturing (334418)",
	oec_cep  "Other electronic component manufacturing (33441A)",
	eea_cep  "Electromedical and electrotherapeutic apparatus manufacturing (334510)",
	sdn_cep  "Search, detection, and navigation instruments manufacturing (334511)",
	aec_cep  "Automatic environmental control manufacturing (334512)",
	ipv_cep  "Industrial process variable instruments manufacturing (334513)",
	tfl_cep  "Totalizing fluid meter and counting device manufacturing (334514)",
	els_cep  "Electricity and signal testing instruments manufacturing (334515)",
	ali_cep  "Analytical laboratory instrument manufacturing (334516)",
	irr_cep  "Irradiation apparatus manufacturing (334517)",
	wcm_cep  "Watch, clock, and other measuring and controlling device manufacturing (33451A)",
	aud_cep  "Audio and video equipment manufacturing (334300)",
	mmo_cep  "Manufacturing and reproducing magnetic and optical media (334610)",
	elb_eec  "Electric lamp bulb and part manufacturing (335110)",
	ltf_eec  "Lighting fixture manufacturing (335120)",
	sea_eec  "Small electrical appliance manufacturing (335210)",
	ham_eec  "Major household appliance manufacturing",
	pwr_eec  "Power, distribution, and specialty transformer manufacturing (335311)",
	mtg_eec  "Motor and generator manufacturing (335312)",
	swt_eec  "Switchgear and switchboard apparatus manufacturing (335313)",
	ric_eec  "Relay and industrial control manufacturing (335314)",
	sbt_eec  "Storage battery manufacturing (335911)",
	pbt_eec  "Primary battery manufacturing (335912)",
	cme_eec  "Communication and energy wire and cable manufacturing (335920)",
	wdv_eec  "Wiring device manufacturing (335930)",
	cbn_eec  "Carbon and graphite product manufacturing (335991)",
	oee_eec  "All other miscellaneous electrical equipment and component manufacturing (335999)",
	atm_mot  "Automobile manufacturing (336111)",
	ltr_mot  "Light truck and utility vehicle manufacturing (336112)",
	htr_mot  "Heavy duty truck manufacturing (336120)",
	mbd_mot  "Motor vehicle body manufacturing (336211)",
	trl_mot  "Truck trailer manufacturing (336212)",
	hom_mot  "Motor home manufacturing (336213)",
	cam_mot  "Travel trailer and camper manufacturing (336214)",
	gas_mot  "Motor vehicle gasoline engine and engine parts manufacturing (336310)",
	eee_mot  "Motor vehicle electrical and electronic equipment manufacturing (336320)",
	tpw_mot  "Motor vehicle transmission and power train parts manufacturing (336350)",
	trm_mot  "Motor vehicle seating and interior trim manufacturing (336360)",
	stm_mot  "Motor vehicle metal stamping (336370)",
	omv_mot  "Other motor vehicle parts manufacturing (336390)",
	brk_mot  "Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)",
	air_ote  "Aircraft manufacturing (336411)",
	aen_ote  "Aircraft engine and engine parts manufacturing (336412)",
	oar_ote  "Other aircraft parts and auxiliary equipment manufacturing (336413)",
	mis_ote  "Guided missile and space vehicle manufacturing (336414)",
	pro_ote  "Propulsion units and parts for space vehicles and guided missiles (33641A)",
	rrd_ote  "Railroad rolling stock manufacturing (336500)",
	shp_ote  "Ship building and repairing (336611)",
	bot_ote  "Boat building (336612)",
	mcl_ote  "Motorcycle, bicycle, and parts manufacturing (336991)",
	mlt_ote  "Military armored vehicle, tank, and tank component manufacturing (336992)",
	otm_ote  "All other transportation equipment manufacturing (336999)",
	cab_fpd  "Wood kitchen cabinet and countertop manufacturing (337110)",
	uph_fpd  "Upholstered household furniture manufacturing (337121)",
	nup_fpd  "Nonupholstered wood household furniture manufacturing (337122)",
	ifm_fpd  "Institutional furniture manufacturing (337127)",
	ohn_fpd  "Other household nonupholstered furniture (33712N)",
	shv_fpd  "Showcase, partition, shelving, and locker manufacturing (337215)",
	off_fpd  "Office furniture and custom architectural woodwork and millwork manufacturing (33721A)",
	ofp_fpd  "Other furniture related product manufacturing (337900)",
	smi_mmf  "Surgical and medical instrument manufacturing (339112)",
	sas_mmf  "Surgical appliance and supplies manufacturing (339113)",
	dnt_mmf  "Dental equipment and supplies manufacturing (339114)",
	oph_mmf  "Ophthalmic goods manufacturing (339115)",
	dlb_mmf  "Dental laboratories (339116)",
	jwl_mmf  "Jewelry and silverware manufacturing (339910)",
	ath_mmf  "Sporting and athletic goods manufacturing (339920)",
	toy_mmf  "Doll, toy, and game manufacturing (339930)",
	ofm_mmf  "Office supplies (except paper) manufacturing (339940)",
	sgn_mmf  "Sign manufacturing (339950)",
	omm_mmf  "All other miscellaneous manufacturing (339990)",
	dog_fbp  "Dog and cat food manufacturing (311111)",
	oaf_fbp  "Other animal food manufacturing (311119)",
	flr_fbp  "Flour milling and malt manufacturing (311210)",
	wet_fbp  "Wet corn milling (311221)",
	fat_fbp  "Fats and oils refining and blending (311225)",
	soy_fbp  "Soybean and other oilseed processing (311224)",
	brk_fbp  "Breakfast cereal manufacturing (311230)",
	sug_fbp  "Sugar and confectionery product manufacturing (311300)",
	fzn_fbp  "Frozen food manufacturing (311410)",
	can_fbp  "Fruit and vegetable canning, pickling, and drying (311420)",
	chs_fbp  "Cheese manufacturing (311513)",
	dry_fbp  "Dry, condensed, and evaporated dairy product manufacturing (311514)",
	mlk_fbp  "Fluid milk and butter manufacturing (31151A)",
	ice_fbp  "Ice cream and frozen dessert manufacturing (311520)",
	chk_fbp  "Poultry processing (311615)",
	asp_fbp  "Animal (except poultry) slaughtering, rendering, and processing (31161A)",
	sea_fbp  "Seafood product preparation and packaging (311700)",
	brd_fbp  "Bread and bakery product manufacturing (311810)",
	cok_fbp  "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)",
	snk_fbp  "Snack food manufacturing (311910)",
	tea_fbp  "Coffee and tea manufacturing (311920)",
	syr_fbp  "Flavoring syrup and concentrate manufacturing (311930)",
	spc_fbp  "Seasoning and dressing manufacturing (311940)",
	ofm_fbp  "All other food manufacturing (311990)",
	pop_fbp  "Soft drink and ice manufacturing (312110)",
	ber_fbp  "Breweries (312120)",
	wne_fbp  "Wineries (312130)",
	why_fbp  "Distilleries (312140)",
	cig_fbp  "Tobacco manufacturing (312200)",
	fyt_tex  "Fiber, yarn, and thread mills (313100)",
	fml_tex  "Fabric mills (313200)",
	txf_tex  "Textile and fabric finishing and fabric coating mills (313300)",
	rug_tex  "Carpet and rug mills (314110)",
	lin_tex  "Curtain and linen mills (314120)",
	otp_tex  "Other textile product mills (314900)",
	app_alt  "Apparel manufacturing (315000)",
	lea_alt  "Leather and allied product manufacturing (316000)",
	plp_ppd  "Pulp mills (322110)",
	ppm_ppd  "Paper mills (322120)",
	pbm_ppd  "Paperboard mills (322130)",
	pbc_ppd  "Paperboard container manufacturing (322210)",
	ppb_ppd  "Paper bag and coated and treated paper manufacturing (322220)",
	sta_ppd  "Stationery product manufacturing (322230)",
	toi_ppd  "Sanitary paper product manufacturing (322291)",
	opp_ppd  "All other converted paper product manufacturing (322299)",
	pri_pri  "Printing (323110)",
	sap_pri  "Support activities for printing (323120)",
	ref_pet  "Petroleum refineries (324110)",
	pav_pet  "Asphalt paving mixture and block manufacturing (324121)",
	shn_pet  "Asphalt shingle and coating materials manufacturing (324122)",
	oth_pet  "Other petroleum and coal products manufacturing (324190)",
	ptr_che  "Petrochemical manufacturing (325110)",
	igm_che  "Industrial gas manufacturing (325120)",
	sdp_che  "Synthetic dye and pigment manufacturing (325130)",
	obi_che  "Other basic inorganic chemical manufacturing (325180)",
	obo_che  "Other basic organic chemical manufacturing (325190)",
	pmr_che  "Plastics material and resin manufacturing (325211)",
	srf_che  "Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)",
	mbm_che  "Medicinal and botanical manufacturing (325411)",
	phm_che  "Pharmaceutical preparation manufacturing (325412)",
	inv_che  "In-vitro diagnostic substance manufacturing (325413)",
	bio_che  "Biological product (except diagnostic) manufacturing (325414)",
	fmf_che  "Fertilizer manufacturing (325310)",
	pag_che  "Pesticide and other agricultural chemical manufacturing (325320)",
	pnt_che  "Paint and coating manufacturing (325510)",
	adh_che  "Adhesive manufacturing (325520)",
	sop_che  "Soap and cleaning compound manufacturing (325610)",
	toi_che  "Toilet preparation manufacturing (325620)",
	pri_che  "Printing ink manufacturing (325910)",
	och_che  "All other chemical product and preparation manufacturing (3259A0)",
	plm_pla  "Plastics packaging materials and unlaminated film and sheet manufacturing (326110)",
	ppp_pla  "Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)",
	lam_pla  "Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)",
	fom_pla  "Polystyrene foam product manufacturing (326140)",
	ure_pla  "Urethane and other foam product (except polystyrene) manufacturing (326150)",
	bot_pla  "Plastics bottle manufacturing (326160)",
	opm_pla  "Other plastics product manufacturing (326190)",
	tir_pla  "Tire manufacturing (326210)",
	rbr_pla  "Rubber and plastics hoses and belting manufacturing (326220)",
	orb_pla  "Other rubber product manufacturing (326290)",
	mtv_wht  "Motor vehicle and motor vehicle parts and supplies (423100)",
	pce_wht  "Professional and commercial equipment and supplies (423400)",
	hha_wht  "Household appliances and electrical and electronic goods (423600)",
	mch_wht  "Machinery, equipment, and supplies (423800)",
	odg_wht  "Other durable goods merchant wholesalers (423A00)",
	dru_wht  "Drugs and druggists' sundries (424200)",
	gro_wht  "Grocery and related product wholesalers (424400)",
	pet_wht  "Petroleum and petroleum products (424700)",
	ndg_wht  "Other nondurable goods merchant wholesalers (424A00)",
	ele_wht  "Wholesale electronic markets and agents and brokers (425000)",
	mvt      "Motor vehicle and parts dealers (441000)",
	fbt      "Food and beverage stores (445000)",
	gmt      "General merchandise stores (452000)",
	bui_ott  "Building material and garden equipment and supplies dealers (444000)",
	hea_ott  "Health and personal care stores (446000)",
	gas_ott  "Gasoline stations (447000)",
	clo_ott  "Clothing and clothing accessories stores (448000)",
	non_ott  "Nonstore retailers (454000)",
	oth_ott  "All other retail (4B0000)",
	air      "Air transportation (481000)",
	trn      "Rail transportation (482000)",
	wtt      "Water transportation (483000)",
	trk      "Truck transportation (484000)",
	grd      "Transit and ground passenger transportation (485000)",
	pip      "Pipeline transportation (486000)",
	sce_otr  "Scenic and sightseeing transportation and support activities (48A000)",
	mes_otr  "Couriers and messengers (492000)",
	wrh      "Warehousing and storage (493000)",
	new_pub  "Newspaper publishers (511110)",
	pdl_pub  "Periodical publishers (511120)",
	bok_pub  "Book publishers (511130)",
	mal_pub  "Directory, mailing list, and other publishers (5111A0)",
	sfw_pub  "Software publishers (511200)",
	pic_mov  "Motion picture and video industries (512100)",
	snd_mov  "Sound recording industries (512200)",
	rad_brd  "Radio and television broadcasting (515100)",
	cbl_brd  "Cable and other subscription programming (515200)",
	wtl_brd  "Wired telecommunications carriers (517110)",
	wls_brd  "Wireless telecommunications carriers (except satellite) (517210)",
	sat_brd  "Satellite, telecommunications resellers, and all other telecommunications (517A00)",
	dpr_dat  "Data processing, hosting, and related services (518200)",
	int_dat  "Internet publishing and broadcasting and Web search portals (519130)",
	new_dat  "News syndicates, libraries, archives and all other information services (5191A0)",
	cre_bnk  "Nondepository credit intermediation and related activities (522A00)",
	mon_bnk  "Monetary authorities and depository credit intermediation (52A000)",
	ofi_sec  "Other financial investment activities (523900)",
	com_sec  "Securities and commodity contracts intermediation and brokerage (523A00)",
	dir_ins  "Direct life insurance carriers (524113)",
	car_ins  "Insurance carriers, except direct life (5241XX)",
	agn_ins  "Insurance agencies, brokerages, and related activities (524200)",
	fin      "Funds, trusts, and other financial vehicles (525000)",
	own_hou  "Owner-occupied housing (531HSO)",
	rnt_hou  "Tenant-occupied housing (531HST)",
	ORE      "Other real estate (531ORE)",
	aut_rnt  "Automotive equipment rental and leasing (532100)",
	com_rnt  "Commercial and industrial machinery and equipment rental and leasing (532400)",
	cmg_rnt  "General and consumer goods rental (532A00)",
	int_rnt  "Lessors of nonfinancial intangible assets (533000)",
	leg      "Legal services (541100)",
	cus_com  "Custom computer programming services (541511)",
	sys_com  "Computer systems design services (541512)",
	ocs_com  "Other computer related services, including facilities management (54151A)",
	acc_tsv  "Accounting, tax preparation, bookkeeping, and payroll services (541200)",
	arc_tsv  "Architectural, engineering, and related services (541300)",
	mgt_tsv  "Management consulting services (541610)",
	env_tsv  "Environmental and other technical consulting services (5416A0)",
	sci_tsv  "Scientific research and development services (541700)",
	adv_tsv  "Advertising, public relations, and related services (541800)",
	des_tsv  "Specialized design services (541400)",
	pht_tsv  "Photographic services (541920)",
	vet_tsv  "Veterinary services (541940)",
	mkt_tsv  "All other miscellaneous professional, scientific, and technical services (5419A0)",
	man      "Management of companies and enterprises (550000)",
	emp_adm  "Employment services (561300)",
	dwe_adm  "Services to buildings and dwellings (561700)",
	off_adm  "Office administrative services (561100)",
	fac_adm  "Facilities support services (561200)",
	bsp_adm  "Business support services (561400)",
	trv_adm  "Travel arrangement and reservation services (561500)",
	inv_adm  "Investigation and security services (561600)",
	oss_adm  "Other support services (561900)",
	wst      "Waste management and remediation services (562000)",
	sec_edu  "Elementary and secondary schools (611100)",
	uni_edu  "Junior colleges, colleges, universities, and professional schools (611A00)",
	oes_edu  "Other educational services (611B00)",
	phy_amb  "Offices of physicians (621100)",
	dnt_amb  "Offices of dentists (621200)",
	ohp_amb  "Offices of other health practitioners (621300)",
	out_amb  "Outpatient care centers (621400)",
	lab_amb  "Medical and diagnostic laboratories (621500)",
	hom_amb  "Home health care services (621600)",
	oas_amb  "Other ambulatory health care services (621900)",
	hos      "Hospitals (622000)",
	ncc_nrs  "Nursing and community care facilities (623A00)",
	res_nrs  "Residential mental health, substance abuse, and other residential care facilities (623B00)",
	ifs_soc  "Individual and family services (624100)",
	day_soc  "Child day care services (624400)",
	cmf_soc  "Community food, housing, and other relief services, including vocational rehabilitation services (624A00)",
	pfm_art  "Performing arts companies (711100)",
	spr_art  "Spectator sports (711200)",
	ind_art  "Independent artists, writers, and performers (711500)",
	agt_art  "Promoters of performing arts and sports and agents for public figures (711A00)",
	mus_art  "Museums, historical sites, zoos, and parks (712000)",
	amu_rec  "Amusement parks and arcades (713100)",
	cas_rec  "Gambling industries (except casino hotels) (713200)",
	ori_rec  "Other amusement and recreation industries (713900)",
	amd      "Accommodation (721000)",
	ful_res  "Full-service restaurants (722110)",
	lim_res  "Limited-service restaurants (722211)",
	ofd_res  "All other food and drinking places (722A00)",
	atr_osv  "Automotive repair and maintenance (including car washes) (811100)",
	eqr_osv  "Electronic and precision equipment repair and maintenance (811200)",
	imr_osv  "Commercial and industrial machinery and equipment repair and maintenance (811300)",
	hgr_osv  "Personal and household goods repair and maintenance (811400)",
	pcs_osv  "Personal care services (812100)",
	fun_osv  "Death care services (812200)",
	dry_osv  "Dry-cleaning and laundry services (812300)",
	ops_osv  "Other personal services (812900)",
	rel_osv  "Religious organizations (813100)",
	grt_osv  "Grantmaking, giving, and social advocacy organizations (813A00)",
	civ_osv  "Civic, social, professional, and similar organizations (813B00)",
	prv_osv  "Private households (814000)",
	fdd      "Federal general government (defense) (S00500)",
	fnd      "Federal general government (nondefense) (S00600)",
	pst_fen  "Postal service (491000)",
	ofg_fen  "Other federal government enterprises (S00102)",
	edu_slg  "State and local government (educational services) (GSLGE)",
	hea_slg  "State and local government (hospitals and health services) (GSLGH)",
	oth_slg  "State and local government (other services) (GSLGO)",
	osl_sle  "Other state and local government enterprises (S00203)",
	srp_usd  "Scrap (S00401)",
	sec_usd  "Used and secondhand goods (S00402)",
	imp_oth  "Noncomparable imports (S00300)",
	rwa_oth  "Rest of the world adjustment (S00900)"
	sme_pmt  "Secondary smelting and alloying of aluminum (331314)",
	ele_fen  "Federal electric utilities (S00101)",
	trn_sle  "State and local government passenger transit (S00201)",
	ele_sle  "State and local government electric utilities (S00202)" /;

set	yr /2007,2012,2017/

set	r_make(*)	Rows,
	c_make(*)	Columns,
	r_pro(*)	Rows,
	c_pro(*)	Columns,
	r_pur(*)	Rows,
	c_pur(*)	Columns

parameter	make(yr,r_make,c_make)	Make matrix
		use_pro(yr,r_pro,c_pro)	Use at producer prices,
		use_pur(yr,r_pur,c_pur)	Use at purchaser prices;

$gdxin data\AllTablesIO\make_.gdx
$load r_make=r c_make=c
$loaddc make

$gdxin data\AllTablesIO\use_pro_.gdx
$load r_pro=r c_pro=c
$loaddc use_pro=use

$gdxin data\AllTablesIO\use_pur_.gdx
$load r_pur=r c_pur=c
$loaddc use_pur=use

set	s_m(*)	Sectors in margins
	g_m(*)	Goods in margins;

$gdxin data\margins_.gdx
$load s_m=s g_m=g

set	mc  Margin columns /
	pro	"Producers' Value"
	trn	"Transportation Costs"		
	whl	"Wholesale"
	rtl	"Retail"
	pur	"Purchasers' Value" /;

parameter	margins(yr,s_m,g_m,mc)	Margins After Redefinitions [Millions of dollars];
$loaddc margins

alias (i,j,d);

singleton set	yb(yr) /2017/;

set	totals /
		T005    Total Intermediate
		T006    Total Value Added
		T008    Total Industry Output /;

parameter	profit	Cross check on profit;
profit(c_pur(j),totals(r_pur)) = use_pur(yb,r_pur,c_pur);
profit(c_pur(j),"id") = sum(r_pur(i),use_pur(yb,r_pur,c_pur));
profit(j,"pro-pur") =  sum((r_pro(i),c_pro(j)),use_pro(yb,r_pro,c_pro))
		     - sum((r_pur(i),c_pur(j)),use_pur(yb,r_pur,c_pur));
profit(r_make(j),"make") = sum(c_make(i),make(yb,r_make,c_make));
option profit:3;
display profit;

parameter	market	Market clearance condition;
market(r_pro(i),"id") = sum(c_pro(j),use_pro(yb,r_pro,c_pro));
market(r_pro(i),"T001") = use_pro(yb,r_pro,"T001");

set	fd(c_pro) /
	F01000  Personal consumption expenditures

	F02E00  Nonresidential private fixed investment in equipment
	F02N00  Nonresidential private fixed investment in intellectual property products
	F02R00  Residential private fixed investment
	F02S00  Nonresidential private fixed investment in structures
	F03000  Change in private inventories

	F04000  Exports of goods and services
	F05000  Imports of goods and services

	F06C00  Federal Government defense: Consumption expenditures
	F06E00  Federal national defense: Gross investment in equipment
	F06N00  Federal national defense: Gross investment in intellectual property products
	F06S00  Federal national defense: Gross investment in structures
	F07C00  Federal government nondefense: consumption expenditures
	F07E00  Federal nondefense: gross investment in equipment
	F07N00  Federal nondefense: gross investment in intellectual property products
	F07S00  Federal nondefense: gross investment in structures
	F10C00  State and local government consumption expenditures
	F10E00  State and local: gross investment in equipment
	F10N00  State and local: gross investment in intellectual property products
	F10S00  State and local: gross investment in structures/;

market(r_pro(i),"fd") = sum(c_pro(fd),use_pro(yb,r_pro,c_pro));
market(r_pro(i),"T004") = use_pro(yb,r_pro,"T004");
display market;

alias (d,s,ss,g,gg);

parameter	ys0(s,g)	Make matrix
		id0(g,s)	Intermediate deman
		md0(g,s,*)	Margin demand check,
		yva0(s)		Value-added
		m0(g)		Imports,
		e0(g)		Exports
		d0(g)		Final demand;

ys0(s,g) = sum((r_make(s),c_make(g)),make(yb,r_make,c_make)) * scale;
id0(g,s) = sum((r_pro(g),c_pro(s)),use_pro(yb,r_pro,c_pro)) * scale;
yva0(s) = sum(c_pur(s),use_pur(yb,"T006",c_pur))  * scale;
m0(g) = -sum(r_pro(g),use_pro(yb,r_pro,"F05000"))  * scale;
e0(g) = sum(r_pro(g),use_pro(yb,r_pro,"F04000"))  * scale;
d0(g) = sum((r_pro(g),c_pro(fd)),use_pro(yb,r_pro,c_pro))* scale - e0(g) + m0(g);

option ys0:3:0:1, id0:3:0:1;
display ys0, id0, yva0, m0, e0;

parameter	nd0(g,s)	Negative demand;
nd0(g,s) = min(0,id0(g,s));
option nd0:0:0:1;
display nd0;

*	Treat negative demands as outputs:

ys0(s,g) = ys0(s,g) - nd0(g,s);
id0(g,s) = max(0,id0(g,s));

option ys0:3:0:1, id0:3:0:1, yva0:3:0:1;
display ys0, id0, yva0;

*	Compare the margin data with the basic price input:

md0(g(g_m),s(s_m),mc) = margins(yb,s_m,g_m,mc) * scale;
md0(g,s,"id0") = id0(g,s);
option md0:3:2:1;
display md0;

*	Create a diagonal production dataset -- commodity by commodity:

parameter	zs0(g)			Supply,
		zd0(g,gg)		Intermediate demand
		zva0(g)			Value-added
		alpha(s,g)		Output share;

alpha(s,g)$ys0(s,g) = ys0(s,g)/sum(gg,ys0(s,gg));
zs0(g) = sum(s,ys0(s,g));
zd0(gg,g) = sum(s,alpha(s,g)*id0(gg,s));
zva0(g) = sum(s,alpha(s,g)*yva0(s));

parameter	chk;
chk(g,"zs0") = zs0(g) - sum(s,ys0(s,g));
chk(g,"ad0") = sum(gg,zd0(g,gg)) - sum(s,id0(g,s));
chk(".","zva0") = sum(g,zva0(g)) - sum(s,yva0(s));
display chk;

parameter	equilchk	Check of equilibrium;
equilchk("profit",s,"y") = sum(g,ys0(s,g)-id0(g,s)) - yva0(s);
equilchk("profit",g,"z") = zs0(g) - sum(gg,zd0(gg,g)) - zva0(g);
equilchk("market",g,"y") = sum(s,ys0(s,g)-id0(g,s)) - d0(g) - e0(g) + m0(g);
equilchk("market",g,"z") = zs0(g) - sum(gg,zd0(g,gg)) - d0(g) - e0(g) + m0(g);
display equilchk;

set	y_(s)	Sector flag (joint products),
	z_(g)	Sector flag (diagonal)
	p_(g)	Market flag;

y_(s) = sum(g,ys0(s,g));
z_(g) = no;
p_(g) = sum(s,ys0(s,g)) + m0(g);;

parameter	echoprint(g,*);
echoprint(g,"ys0") = sum(s,ys0(s,g));
echoprint(g,"id0") = sum(s,id0(g,s));
echoprint(g,"d0") = d0(g);
echoprint(g,"e0") = e0(g);
echoprint(g,"m0") = m0(g);
display echoprint;

parameter	va0(s)	Value-added;

$ontext
$model:makeuse

$sectors:
	Y(s)$y_(s)	! Production (joint products)
	Z(g)$z_(g)	! Production (diagonal model)

$commodities:
	P(g)$p_(g)	! Commodity market
	PVA(s)$va0(s)	! Value-added

$consumer:
	RA		! Representative agent

$prod:Y(s)$y_(s)
	o:P(g)		q:ys0(s,g)
	i:P(g)		q:id0(g,s)
	i:PVA(s)	q:(max(0,va0(s)))
	o:PVA(s)	q:(max(0,-va0(s)))

$prod:Z(g)$z_(g)
	o:P(g)		q:zs0(g)
	i:P(gg)		q:zd0(gg,g)
	i:PVA(g)	q:va0(g)

$demand:RA
	d:P(g)		q:d0(g)
	e:P(g)		q:(m0(g)-e0(g))	
	e:PVA(s)	Q:va0(s)

$offtext
$sysinclude mpsgeset makeuse
makeuse.iterlim = 0;
makeuse.workspace = 64;

va0(s) = yva0(s);

$include MAKEUSE.GEN
solve makeuse using mcp;

y_(s) = no;
z_(g) = yes$zs0(g);
va0(g) = zva0(g);
$include MAKEUSE.GEN
solve makeuse using mcp;

set	ag(g)  Agricultural goods/ 
		osd_agr  "Oilseed farming (1111A0)",
		grn_agr  "Grain farming (1111B0)",
		veg_agr  "Vegetable and melon farming (111200)",
		nut_agr  "Fruit and tree nut farming (111300)",
		flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
		oth_agr  "Other crop farming (111900)",
		dry_agr  "Dairy cattle and milk production (112120)",
		bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
		egg_agr  "Poultry and egg production (112300)",
		ota_agr  "Animal production, except cattle and poultry and eggs (112A00)" /;

variable	X(g)	Agricultural content;

equation	xdef;

xdef(z_(g))..	zs0(g)*X(g) =e= sum(gg,zd0(gg,g)*X(gg)) + zs0(g)$ag(g);

model io /xdef.X/;

X.FX(g)$(not z_(g)) = 0;

solve io using mcp;

parameter	atm(g,*)	Agricultural trade multiplier;

*	Output value:

atm(g,"X") = X.L(g);
atm(g,"E") = X.L(g);

*	Content of exports, net of trade and transport margins:

atm(g(g_m),"E")$margins(yb,"F04000",g_m,"pur") = margins(yb,"F04000",g_m,"pro")*X.L(g)/margins(yb,"F04000",g_m,"pur");
display atm;

