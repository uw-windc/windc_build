$stitle	Extract Gravity Estimation Data

set	trd	Trade sectors used in gravity calculation /

*	Aggregated sectors:

	fof	"Forestry and fishing",
	fbp	"Food and beverage and tobacco products (311FT)"
	alt	"Apparel and leather and allied products (315AL)"
	pmt	"Primary metals (331)"
	ogs	"Crude oil and natural gas"
	uti	"Utilities (electricity-gas-water)"
	oxt	"Coal, minining and supporting activities"

*	Individual agricultural sectors:

	PDR 	"Paddy rice (not used)",
	WHT 	"Wheat (not used)",
	GRO 	"Cereal grains nec",
	V_F 	"Vegetables, fruit, nuts",
	OSD 	"Oil seeds",
	C_B 	"Sugar cane, sugar beet",
	PFB 	"Plant-based fibers",
	OCR 	"Crops nec",
	CTL 	"Bovine cattle, sheep, goats and horses",
	OAP 	"Animal products nec",
	WOL 	"Wool, silk-worm cocoons",
	RMK	"Milk"

	TEX	"Textiles",
	LUM	"Lumber and wood products",
	NMM	"Mineral products nec",
	FMP	"Metal products",
	MVH	"Motor vehicles and parts",
	OTN	"Transport equipment nec",
	OME	"Machinery and equipment nec",
	OIL	"Petroleum, coal products",
	PPP	"Paper products, publishing",
	CRP	"Chemical, rubber, plastic products",
	EEQ	"Electronic equipment",
	OMF	"Manufactures nec"
/;

set trdmap(s,trd) /
	oil.ogs      "Oil and gas extraction (211000)",
	osd_agr.osd  "Oilseed farming (1111A0)",
	grn_agr.gro  "Grain farming (1111B0)",
	veg_agr.v_f  "Vegetable and melon farming (111200)",
	nut_agr.v_f  "Fruit and tree nut farming (111300)",
	flo_agr.v_f  "Greenhouse, nursery, and floriculture production (111400)",
	oth_agr.ocr  "Other crop farming (111900)",
	bef_agr.ctl  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
	egg_agr.oap  "Poultry and egg production (112300)",
	ota_agr.oap  "Animal production, except cattle and poultry and eggs (112A00)",
	log_fof.fof  "Forestry and logging (113000)",
	fht_fof.fof  "Fishing, hunting and trapping (114000)",
	saf_fof.fof  "Support activities for agriculture and forestry (115000)",
	col_min.oxt  "Coal mining (212100)",
	led_min.oxt  "Copper, nickel, lead, and zinc mining (212230)",
	ore_min.oxt  "Iron, gold, silver, and other metal ore mining (2122A0)",
	stn_min.oxt  "Stone mining and quarrying (212310)",
	oth_min.oxt  "Other nonmetallic mineral mining and quarrying (2123A0)",
	drl_smn.ogs  "Drilling oil and gas wells (213111)",
	oth_smn.ogs  "Other support activities for mining (21311A)",
	ele_uti.uti  "Electric power generation, transmission, and distribution (221100)",
	gas_uti.uti  "Natural gas distribution (221200)",
	wat_uti.uti  "Water, sewage and other systems (221300)",
	saw_wpd.lum  "Sawmills and wood preservation (321100)",
	ven_wpd.lum  "Veneer, plywood, and engineered wood product manufacturing (321200)",
	mil_wpd.lum  "Millwork (321910)",
	owp_wpd.lum  "All other wood product manufacturing (3219A0)",
	cly_nmp.nmm  "Clay product and refractory manufacturing (327100)",
	gla_nmp.nmm  "Glass and glass product manufacturing (327200)",
	cmt_nmp.nmm  "Cement manufacturing (327310)",
	cnc_nmp.nmm  "Ready-mix concrete manufacturing (327320)",
	cpb_nmp.nmm  "Concrete pipe, brick, and block manufacturing (327330)",
	ocp_nmp.nmm  "Other concrete product manufacturing (327390)",
	lme_nmp.nmm  "Lime and gypsum product manufacturing (327400)",
	abr_nmp.nmm  "Abrasive product manufacturing (327910)",
	cut_nmp.nmm  "Cut stone and stone product manufacturing (327991)",
	tmn_nmp.nmm  "Ground or treated mineral and earth manufacturing (327992)",
	wol_nmp.nmm  "Mineral wool manufacturing (327993)",
	mnm_nmp.nmm  "Miscellaneous nonmetallic mineral products (327999)",
	irn_pmt.pmt  "Iron and steel mills and ferroalloy manufacturing (331110)",
	stl_pmt.pmt  "Steel product manufacturing from purchased steel                        (331200)",
	ala_pmt.pmt  "Alumina refining and primary aluminum production (331313)",
	alu_pmt.pmt  "Aluminum product manufacturing from purchased aluminum (33131B)",
	nms_pmt.pmt  "Nonferrous metal (except aluminum) smelting and refining (331410)",
	cop_pmt.pmt  "Copper rolling, drawing, extruding and alloying (331420)",
	nfm_pmt.pmt  "Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)",
	fmf_pmt.pmt  "Ferrous metal foundries (331510)",
	nff_pmt.pmt  "Nonferrous metal foundries (331520)",
	rol_fmt.fmp  "Custom roll forming (332114)",
	fss_fmt.fmp  "All other forging, stamping, and sintering (33211A)",
	crn_fmt.fmp  "Metal crown, closure, and other metal stamping (except automotive) (332119)",
	cut_fmt.fmp  "Cutlery and handtool manufacturing (332200)",
	plt_fmt.fmp  "Plate work and fabricated structural product manufacturing (332310)",
	orn_fmt.fmp  "Ornamental and architectural metal products manufacturing (332320)",
	pwr_fmt.fmp  "Power boiler and heat exchanger manufacturing (332410)",
	mtt_fmt.fmp  "Metal tank (heavy gauge) manufacturing (332420)",
	mtc_fmt.fmp  "Metal can, box, and other metal container (light gauge) manufacturing (332430)",
	hdw_fmt.fmp  "Hardware manufacturing (332500)",
	spr_fmt.fmp  "Spring and wire product manufacturing (332600)",
	mch_fmt.fmp  "Machine shops (332710)",
	tps_fmt.fmp  "Turned product and screw, nut, and bolt manufacturing (332720)",
	ceh_fmt.fmp  "Coating, engraving, heat treating and allied activities (332800)",
	plb_fmt.fmp  "Plumbing fixture fitting and trim manufacturing (332913)",
	vlv_fmt.fmp  "Valve and fittings other than plumbing (33291A)",
	bbr_fmt.fmp  "Ball and roller bearing manufacturing (332991)",
	fab_fmt.fmp  "Fabricated pipe and pipe fitting manufacturing (332996)",
	amn_fmt.fmp  "Ammunition, arms, ordnance, and accessories manufacturing (33299A)",
	omf_fmt.fmp  "Other fabricated metal manufacturing (332999)",
	frm_mch.ome  "Farm machinery and equipment manufacturing (333111)",
	lwn_mch.ome  "Lawn and garden equipment manufacturing (333112)",
	con_mch.ome  "Construction machinery manufacturing (333120)",
	min_mch.ome  "Mining and oil and gas field machinery manufacturing (333130)",
	smc_mch.ome  "Semiconductor machinery manufacturing (333242)",
	oti_mch.ome  "Other industrial machinery manufacturing (33329A)",
	opt_mch.ome  "Optical instrument and lens manufacturing (333314)",
	pht_mch.ome  "Photographic and photocopying equipment manufacturing (333316)",
	oci_mch.ome  "Other commercial and service industry machinery manufacturing (333318)",
	hea_mch.ome  "Heating equipment (except warm air furnaces) manufacturing (333414)",
	acn_mch.ome  "Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)",
	air_mch.ome  "Industrial and commercial fan and blower and air purification equipment manufacturing (333413)",
	imm_mch.ome  "Industrial mold manufacturing (333511)",
	spt_mch.ome  "Special tool, die, jig, and fixture manufacturing (333514)",
	mct_mch.ome  "Machine tool manufacturing (333517)",
	cut_mch.ome  "Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)",
	tbn_mch.ome  "Turbine and turbine generator set units manufacturing (333611)",
	spd_mch.ome  "Speed changer, industrial high-speed drive, and gear manufacturing (333612)",
	mch_mch.ome  "Mechanical power transmission equipment manufacturing (333613)",
	oee_mch.ome  "Other engine equipment manufacturing (333618)",
	agc_mch.ome  "Air and gas compressor manufacturing (333912)",
	ppe_mch.ome  "Measuring, dispensing, and other pumping equipment manufacturing (333914)",
	mat_mch.ome  "Material handling equipment manufacturing (333920)",
	pwr_mch.ome  "Power-driven handtool manufacturing (333991)",
	pkg_mch.ome  "Packaging machinery manufacturing (333993)",
	ipf_mch.ome  "Industrial process furnace and oven manufacturing (333994)",
	ogp_mch.ome  "Other general purpose machinery manufacturing (33399A)",
	fld_mch.ome  "Fluid power process machinery (33399B)",
	ecm_cep.eeq  "Electronic computer manufacturing (334111)",
	csd_cep.eeq  "Computer storage device manufacturing (334112)",
	ctm_cep.eeq  "Computer terminals and other computer peripheral equipment manufacturing (334118)",
	tel_cep.eeq  "Telephone apparatus manufacturing (334210)",
	brd_cep.eeq  "Broadcast and wireless communications equipment (334220)",
	oce_cep.eeq  "Other communications equipment manufacturing (334290)",
	sem_cep.eeq  "Semiconductor and related device manufacturing (334413)",
	prc_cep.eeq  "Printed circuit assembly (electronic assembly) manufacturing (334418)",
	oec_cep.eeq  "Other electronic component manufacturing (33441A)",
	eea_cep.eeq  "Electromedical and electrotherapeutic apparatus manufacturing (334510)",
	sdn_cep.eeq  "Search, detection, and navigation instruments manufacturing (334511)",
	aec_cep.eeq  "Automatic environmental control manufacturing (334512)",
	ipv_cep.eeq  "Industrial process variable instruments manufacturing (334513)",
	tfl_cep.eeq  "Totalizing fluid meter and counting device manufacturing (334514)",
	els_cep.eeq  "Electricity and signal testing instruments manufacturing (334515)",
	ali_cep.eeq  "Analytical laboratory instrument manufacturing (334516)",
	irr_cep.eeq  "Irradiation apparatus manufacturing (334517)",
	wcm_cep.eeq  "Watch, clock, and other measuring and controlling device manufacturing (33451A)",
	aud_cep.eeq  "Audio and video equipment manufacturing (334300)",
	mmo_cep.eeq  "Manufacturing and reproducing magnetic and optical media (334610)",
	elb_eec.eeq  "Electric lamp bulb and part manufacturing (335110)",
	ltf_eec.eeq  "Lighting fixture manufacturing (335120)",
	sea_eec.eeq  "Small electrical appliance manufacturing (335210)",
	ham_eec.eeq  "Major household appliance manufacturing",
	pwr_eec.eeq  "Power, distribution, and specialty transformer manufacturing (335311)",
	mtg_eec.eeq  "Motor and generator manufacturing (335312)",
	swt_eec.eeq  "Switchgear and switchboard apparatus manufacturing (335313)",
	ric_eec.eeq  "Relay and industrial control manufacturing (335314)",
	sbt_eec.eeq  "Storage battery manufacturing (335911)",
	pbt_eec.eeq  "Primary battery manufacturing (335912)",
	cme_eec.eeq  "Communication and energy wire and cable manufacturing (335920)",
	wdv_eec.eeq  "Wiring device manufacturing (335930)",
	cbn_eec.eeq  "Carbon and graphite product manufacturing (335991)",
	oee_eec.eeq  "All other miscellaneous electrical equipment and component manufacturing (335999)",
	atm_mot.mvh  "Automobile manufacturing (336111)",
	ltr_mot.mvh  "Light truck and utility vehicle manufacturing (336112)",
	htr_mot.mvh  "Heavy duty truck manufacturing (336120)",
	mbd_mot.mvh  "Motor vehicle body manufacturing (336211)",
	trl_mot.mvh  "Truck trailer manufacturing (336212)",
	hom_mot.mvh  "Motor home manufacturing (336213)",
	cam_mot.mvh  "Travel trailer and camper manufacturing (336214)",
	gas_mot.mvh  "Motor vehicle gasoline engine and engine parts manufacturing (336310)",
	eee_mot.mvh  "Motor vehicle electrical and electronic equipment manufacturing (336320)",
	tpw_mot.mvh  "Motor vehicle transmission and power train parts manufacturing (336350)",
	trm_mot.mvh  "Motor vehicle seating and interior trim manufacturing (336360)",
	stm_mot.mvh  "Motor vehicle metal stamping (336370)",
	omv_mot.mvh  "Other motor vehicle parts manufacturing (336390)",
	brk_mot.mvh  "Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)",
	air_ote.otn  "Aircraft manufacturing (336411)",
	aen_ote.otn  "Aircraft engine and engine parts manufacturing (336412)",
	oar_ote.otn  "Other aircraft parts and auxiliary equipment manufacturing (336413)",
	mis_ote.otn  "Guided missile and space vehicle manufacturing (336414)",
	pro_ote.otn  "Propulsion units and parts for space vehicles and guided missiles (33641A)",
	rrd_ote.otn  "Railroad rolling stock manufacturing (336500)",
	shp_ote.otn  "Ship building and repairing (336611)",
	bot_ote.otn  "Boat building (336612)",
	mcl_ote.otn  "Motorcycle, bicycle, and parts manufacturing (336991)",
	mlt_ote.otn  "Military armored vehicle, tank, and tank component manufacturing (336992)",
	otm_ote.otn  "All other transportation equipment manufacturing (336999)",
	cab_fpd.omf  "Wood kitchen cabinet and countertop manufacturing (337110)",
	uph_fpd.omf  "Upholstered household furniture manufacturing (337121)",
	nup_fpd.omf  "Nonupholstered wood household furniture manufacturing (337122)",
	ifm_fpd.omf  "Institutional furniture manufacturing (337127)",
	ohn_fpd.omf  "Other household nonupholstered furniture (33712N)",
	shv_fpd.omf  "Showcase, partition, shelving, and locker manufacturing (337215)",
	off_fpd.omf  "Office furniture and custom architectural woodwork and millwork manufacturing (33721A)",
	ofp_fpd.omf  "Other furniture related product manufacturing (337900)",
	smi_mmf.omf  "Surgical and medical instrument manufacturing (339112)",
	sas_mmf.omf  "Surgical appliance and supplies manufacturing (339113)",
	dnt_mmf.omf  "Dental equipment and supplies manufacturing (339114)",
	oph_mmf.omf  "Ophthalmic goods manufacturing (339115)",
	dlb_mmf.omf  "Dental laboratories (339116)",
	jwl_mmf.omf  "Jewelry and silverware manufacturing (339910)",
	ath_mmf.omf  "Sporting and athletic goods manufacturing (339920)",
	toy_mmf.omf  "Doll, toy, and game manufacturing (339930)",
	ofm_mmf.omf  "Office supplies (except paper) manufacturing (339940)",
	sgn_mmf.omf  "Sign manufacturing (339950)",
	omm_mmf.omf  "All other miscellaneous manufacturing (339990)",
	dog_fbp.fbp  "Dog and cat food manufacturing (311111)",
	oaf_fbp.fbp  "Other animal food manufacturing (311119)",
	flr_fbp.fbp  "Flour milling and malt manufacturing (311210)",
	wet_fbp.fbp  "Wet corn milling (311221)",
	fat_fbp.fbp  "Fats and oils refining and blending (311225)",
	soy_fbp.fbp  "Soybean and other oilseed processing (311224)",
	brk_fbp.fbp  "Breakfast cereal manufacturing (311230)",
	sug_fbp.c_b  "Sugar and confectionery product manufacturing (311300)",
	fzn_fbp.fbp  "Frozen food manufacturing (311410)",
	can_fbp.fbp  "Fruit and vegetable canning, pickling, and drying (311420)",
	chs_fbp.fbp  "Cheese manufacturing (311513)",
	dry_fbp.fbp  "Dry, condensed, and evaporated dairy product manufacturing (311514)",
	mlk_fbp.rmk  "Fluid milk and butter manufacturing (31151A)",
	ice_fbp.fbp  "Ice cream and frozen dessert manufacturing (311520)",
	chk_fbp.fbp  "Poultry processing (311615)",
	asp_fbp.fbp  "Animal (except poultry) slaughtering, rendering, and processing (31161A)",
	sea_fbp.fbp  "Seafood product preparation and packaging (311700)",
	brd_fbp.fbp  "Bread and bakery product manufacturing (311810)",
	cok_fbp.fbp  "Cookie, cracker, pasta, and tortilla manufacturing (3118A0)",
	snk_fbp.fbp  "Snack food manufacturing (311910)",
	tea_fbp.fbp  "Coffee and tea manufacturing (311920)",
	syr_fbp.fbp  "Flavoring syrup and concentrate manufacturing (311930)",
	spc_fbp.fbp  "Seasoning and dressing manufacturing (311940)",
	ofm_fbp.fbp  "All other food manufacturing (311990)",
	pop_fbp.fbp  "Soft drink and ice manufacturing (312110)",
	ber_fbp.fbp  "Breweries (312120)",
	wne_fbp.fbp  "Wineries (312130)",
	why_fbp.fbp  "Distilleries (312140)",
	cig_fbp.fbp  "Tobacco manufacturing (312200)",
	fyt_tex.tex  "Fiber, yarn, and thread mills (313100)",
	fml_tex.tex  "Fabric mills (313200)",
	txf_tex.tex  "Textile and fabric finishing and fabric coating mills (313300)",
	rug_tex.tex  "Carpet and rug mills (314110)",
	lin_tex.tex  "Curtain and linen mills (314120)",
	otp_tex.tex  "Other textile product mills (314900)",
	app_alt.alt  "Apparel manufacturing (315000)",
	lea_alt.alt  "Leather and allied product manufacturing (316000)",
	plp_ppd.ppp  "Pulp mills (322110)",
	ppm_ppd.ppp  "Paper mills (322120)",
	pbm_ppd.ppp  "Paperboard mills (322130)",
	pbc_ppd.ppp  "Paperboard container manufacturing (322210)",
	ppb_ppd.ppp  "Paper bag and coated and treated paper manufacturing (322220)",
	sta_ppd.ppp  "Stationery product manufacturing (322230)",
	toi_ppd.ppp  "Sanitary paper product manufacturing (322291)",
	opp_ppd.ppp  "All other converted paper product manufacturing (322299)",
	pri_pri.ppp  "Printing (323110)",
	sap_pri.ppp  "Support activities for printing (323120)",
	ref_pet.ogs  "Petroleum refineries (324110)",
	pav_pet.ogs  "Asphalt paving mixture and block manufacturing (324121)",
	shn_pet.ogs  "Asphalt shingle and coating materials manufacturing (324122)",
	oth_pet.ogs  "Other petroleum and coal products manufacturing (324190)",
	ptr_che.crp  "Petrochemical manufacturing (325110)",
	igm_che.crp  "Industrial gas manufacturing (325120)",
	sdp_che.crp  "Synthetic dye and pigment manufacturing (325130)",
	obi_che.crp  "Other basic inorganic chemical manufacturing (325180)",
	obo_che.crp  "Other basic organic chemical manufacturing (325190)",
	pmr_che.crp  "Plastics material and resin manufacturing (325211)",
	srf_che.crp  "Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)",
	mbm_che.crp  "Medicinal and botanical manufacturing (325411)",
	phm_che.crp  "Pharmaceutical preparation manufacturing (325412)",
	inv_che.crp  "In-vitro diagnostic substance manufacturing (325413)",
	bio_che.crp  "Biological product (except diagnostic) manufacturing (325414)",
	fmf_che.crp  "Fertilizer manufacturing (325310)",
	pag_che.crp  "Pesticide and other agricultural chemical manufacturing (325320)",
	pnt_che.crp  "Paint and coating manufacturing (325510)",
	adh_che.crp  "Adhesive manufacturing (325520)",
	sop_che.crp  "Soap and cleaning compound manufacturing (325610)",
	toi_che.crp  "Toilet preparation manufacturing (325620)",
	pri_che.crp  "Printing ink manufacturing (325910)",
	och_che.crp  "All other chemical product and preparation manufacturing (3259A0)",
	plm_pla.crp  "Plastics packaging materials and unlaminated film and sheet manufacturing (326110)",
	ppp_pla.crp  "Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)",
	lam_pla.crp  "Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)",
	fom_pla.crp  "Polystyrene foam product manufacturing (326140)",
	ure_pla.crp  "Urethane and other foam product (except polystyrene) manufacturing (326150)",
	bot_pla.crp  "Plastics bottle manufacturing (326160)",
	opm_pla.crp  "Other plastics product manufacturing (326190)",
	tir_pla.crp  "Tire manufacturing (326210)",
	rbr_pla.crp  "Rubber and plastics hoses and belting manufacturing (326220)",
	orb_pla.crp  "Other rubber product manufacturing (326290)" /,

	g_(s)			Goods with gravity data;

option g_<trdmap;

set	rs(*)	Rows in the supply table / (set.s),
		T017	"Total industry supply" /,

	cs(*)	Columns in the supply table / (set.s),
		T007	"Total Commodity Output",
		MCIF	"Imports",
		MCIF_N	"Imports from the national market"
		MADJ	"CIF/FOB Adjustments on Imports",
		T013	"Total product supply (basic prices)",
		TRADE 	"Trade margins",
		TRANS	"Transportation costs",
		T014	"Total trade and transportation margins",
		MDTY	"Import duties",
		TOP	"Tax on products",
		SUB	"Subsidies",
		T015	"Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)" /,

	ru(*)	Rows in the use table / (set.s), 
		T005	"Total intermediate inputs",
		V001	"Compensation of employees",
		T00OTOP	"Other taxes on production",
		T00OSUB	"Less: other subsidies on production",
		V003	"Gross operating surplus",
		VABAS	"Value added (basic value)",
		T018	"Total industry output (basic value)",
		T00TOP	"Plus: Taxes on products and imports",
		T00SUB	"Less: Subsidies",
		VAPRO	"Value added (producer value)" /,

	cu(*)	Columns in the use table/ (set.s),
		T001	"Total Intermediate",
		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F040  	"Exports of goods and services",
		F040_N	"Exports of goods and services to the national market",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures",
		T019	"Total use of products" /,

	fd(cu)	Components of final demand /
		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /,

	mrg(cs)		Margin accounts /
		TRADE 	"Trade margins",
		TRANS	"Transportation costs" /,

	imp(cs)		Import accounts /
		MDTY	"Import duties",
		MCIF	"Imports",
		MADJ	"CIF/FOB Adjustments on Imports" /,

	txs(cs)		Tax flows /
		TOP	"Tax on products",
		SUB	"Subsidies" /,

	txd(cs)		Domestic taxes /
		TOP	"Tax on products",
		SUB	"Subsidies" /,


	vabas(ru) Value-added at basic prices /
		V001	"Compensation of employees",
		V003	"Gross operating surplus",
		T00OTOP	"Other taxes on production",
		T00OSUB	"Less: other subsidies on production" /,

	pce(cu) 	Final demand -- consumption /
		F010  	"Personal consumption expenditures" /

	demacct(cs)   Accounts assumed proportional to demand /
		MCIF	"Imports",
		MADJ	"CIF/FOB Adjustments on Imports",
		MDTY	"Import duties"
		TOP	"Tax on products",
		SUB	"Subsidies"/,

	export(cu)    Export account /
		F040  	"Exports of goods and services"/,

	gov(cu) Government expenditure / 
		F06C  	"Federal Government defense: Consumption expenditures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F10C  	"State and local government consumption expenditures" /,

	fed(cu) State and local government expenditure / 
		F06C  	"Federal Government defense: Consumption expenditures",
		F07C  	"Federal Government nondefense: Consumption expenditures"/

	slg(cu) State and local government expenditure / 
		F10C  	"State and local government consumption expenditures" /,

	inv(cu)	Investment / 
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",

		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",

		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",

		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /;


parameter	chk			Cross check on adding-up of regional values and national totals,
		gravitydata(yr,g,*,*)	Benchmark data for the gravity estimation,
		x0(g)			Aggregate (national) exports,
		m0(g)			Aggregate (national) imports,
		y0(g,r)			Production by state,
		a0(g,r)			Absorption by state;

loop(yr,

*	Retrieve nonzero structure for this year:

	snz_n(rs,cs) = snz_yr(yr,rs,cs);
	unz_n(ru,cu) = unz_yr(yr,ru,cu);

	chk(yr,g_(g),"y0") =  ( sum(snz_n(rs(g),cs(s)), supply_n(yr,snz_n))
			      + sum(snz_n(rs(g),txs),  supply_n(yr,snz_n)) 
			      + sum(snz_n(rs(g),mrg),  supply_n(yr,snz_n)) );

	chk(yr,g_(g),"m0-x0") = sum(snz_n(rs(g),imp),    supply_n(yr,snz_n)) - 
			        sum(unz_n(ru(g),export), use_n(yr,unz_n));

	chk(yr,g_(g),"z0") = ( sum(unz_n(ru(g),cu(s)),  use_n(yr,unz_n)) + 
			       sum(unz_n(ru(g),cu(fd)), use_n(yr,unz_n)) );

	chk(yr,g_(g),"chk") = chk(yr,g,"y0") + chk(yr,g,"m0-x0") - chk(yr,g,"z0");


*	Extract data for use in the gravity calculation.  These are based on the default
*	assignments.  First, aggregate exports and aggregate imports, based on the national table:

	gravitydata(yr,g_(g),"total","e0") = round(sum(unz_n(ru(g),export), use_n(yr,unz_n)),3);

	gravitydata(yr,g_(g),"total","m0") = round(sum(snz_n(rs(g),imp),    supply_n(yr,snz_n)),3);

*	State-level production and demand, based on default assignments -- proportional scaling:

	gravitydata(yr,g_(g),r,"y0") = round((  sum(snz_n(rs(g),cs(s)), supply(yr,snz_n,r))
				              + sum(snz_n(rs(g),txs),   supply(yr,snz_n,r)) 
					      + sum(snz_n(rs(g),mrg),   supply(yr,snz_n,r)) ),3);

	gravitydata(yr,g_(g),r,"d0") = round( (  sum(unz_n(ru(g),cu(s)),  use(yr,unz_n,r)) + 
					         sum(unz_n(ru(g),cu(fd)), use(yr,unz_n,r))),3);

