$title	Create a Symmetric Table and Calculate ATMs

$set suffix 

$if not set ds $set ds supplyusegravity_2022
$gdxin '%ds%.gdx'

set	s(*)	Sectors;
$load s=s%suffix%

alias (s,g,gg);

sets	rs(*)	Rows in the supply table / (set.s),
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

	mrg(*)		Margin accounts /
		TRADE 	"Trade margins",
		TRANS	"Transportation costs" /,

	imp(cs)		Import accounts /
		MDTY	"Import duties",
		MCIF	"Imports",
		MCIF_N	"Imports from the national market"
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
		F040  	"Exports of goods and services"
		F040_N	"Exports of goods and services to the national market" /,

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


set	r	Regions /	
	AL	"Alabama",
	AR	"Arizona",
	AZ	"Arkansas",
	CA	"California",
	CO	"Colorado",
	CT	"Connecticut",
	DE	"Delaware",
	FL	"Florida",
	GA	"Georgia",
	IA	"Iowa",
	ID	"Idaho",
	IL	"Illinois",
	IN	"Indiana",
	KS	"Kansas",
	KY	"Kentucky",
	LA	"Louisiana",
	MA	"Massachusetts",
	MD	"Maryland",	
	ME	"Maine",
	MI	"Michigan",
	MN	"Minnesota",
	MO	"Missouri",
	MS	"Mississippi",	
	MT	"Montana",
	NC	"North Carolina",
	ND	"North Dakota",
	NE	"Nebraska",
	NH	"New Hampshire",
	NJ	"New Jersey",
	NM	"New Mexico",
	NV	"Nevada",
	NY	"New York",
	OH	"Ohio",
	OK	"Oklahoma",
	OR	"Oregon",
	PA	"Pennsylvania",
	RI	"Rhode Island",
	SC	"South Carolina",
	SD	"South Dakota",
	TN	"Tennessee",
	TX	"Texas",
	UT	"Utah",
	VA	"Virginia",
	VT	"Vermont",
	WA	"Washington",
	WV	"West Virginia",
	WI	"Wisconsin",
	WY	"Wyoming"/;

alias (r,rr);

set	totacct(*)	Totals accounts /
*S_ROW
		T017	"Total industry supply" 
*S_COL
		T007	"Total Commodity Output",
		T013	"Total product supply (basic prices)",
		T014	"Total trade and transportation margins",
		T015	"Total tax less subsidies on products",
		T016	"Total product supply (purchaser prices)",

*U_ROW
		T005	"Total intermediate inputs",
		VABAS	"Value added (basic value)",
		T00TOP	"Plus: Taxes on products and imports",
		T00SUB	"Less: Subsidies",
		T018	"Total industry output (basic value)",
		VAPRO	"Value added (producer value)",
*U_COL
		T001	"Total Intermediate",
		T019	"Total use of products" /;

set	census      Census divisions /
		neg     "New England" 
		mid     "Mid Atlantic" 
		enc     "East North Central" 
		wnc     "West North Central" 
		sac     "South Atlantic" 
		esc     "East South Central" 
		wsc     "West South Central" 
		mtn     "Mountain" 
		pac     "Pacific" /;

$if not set mkt $set mkt state
$if %mkt%==national $set mktdomain national
$if %mkt%==census   $set mktdomain set.census
$if %mkt%==state    $set mktdomain set.r

set	mkt	Markets /%mktdomain%/;

set	tp(*)			Trade partner; 

parameter
	use(ru,cu,r)		Projected Use of Commodities by Industries - (Millions of dollars),
	supply(rs,cs,r)		Projected Supply of Commodities by Industries - (Millions of dollars),
	ys0(g,r,mkt)		Market supply,
	d0(g,mkt,r)		Market demand,
	bx0(g,r,tp)		Bilateral exports by commodity-state-trade partner;

$onundf
$loaddc use=use%suffix% supply=supply%suffix% tp
$load ys0=ys0%suffix% d0=d0%suffix% bx0=bx0%suffix%

*	Drop the tiny numbers:

use(ru,cu,r)$(not round(use(ru,cu,r),6)) = 0;
supply(rs,cs,r)$(not round(supply(rs,cs,r),6)) = 0;

set	unz(ru,cu,r), snz(rs,cs,r);
option unz<use, snz<supply;

use(unz(ru,cu,r))$(totacct(ru) or totacct(cu)) = 0;
supply(snz(rs,cs,r))$(totacct(rs) or totacct(cs)) = 0;

option unz<use, snz<supply;

parameter	balance(*,*,*)	Cross check on balance;
balance(r,g(ru),"use")     = sum(unz(ru,cu,r), use(unz));
balance(r,g(rs),"supply")  = sum(snz(rs,cs,r), supply(snz));
balance(r,s(cu),"cost")    = sum(unz(ru,cu,r), use(unz));
balance(r,s(cs),"revenue") = sum(snz(rs,cs,r), supply(snz));
option balance:3:2:1;
display balance;

parameter	aggsupply(g,r)	Aggregate supply by sector s in state r
		theta(*,*,r)	Fraction of sector s in state r is good g;

aggsupply(s,r) = sum(snz(rs(g),cs(s),r), supply(snz));
theta(snz(rs(g),cs(s),r))$aggsupply(s,r) = supply(snz) / aggsupply(s,r);

parameter	thetasum(s,r)	Sum of theta over goods;
thetasum(s,r)$aggsupply(s,r) = round(1 - sum(snz(rs(g),cs(s),r),theta(snz)),3);
abort$card(thetasum) "Imbalanced theta!", thetasum, aggsupply;

parameter	iot(*,*,*)	Input-output table;
iot(ru,g,r) = sum(cu(s), theta(g,s,r)*use(ru,cu,r));
iot(unz(ru(g),cu,r))$(not g(cu)) = use(unz);
iot(snz(rs(g),cs,r))$(not g(cs)) = -supply(snz);

set	c(*)		Columns in the IOT;
c(s) = s(s); c(cu) = cu(cu); c(cs) = cs(cs);

*	Filter the tiny numbers:

iot(ru,c,r)$(not round(iot(ru,c,r),6)) = 0;

balance(r,g(c), "iorow") = sum(ru,iot(ru,c,r));
balance(r,g(ru),"iocol") = sum(c,iot(ru,c,r));
balance(r,g,    "iochk") = balance(g,"iorow",r) - balance(g,"iocol",r);
option balance:3:2:1;
display balance;

set	xd(*)	Exogenous demand /
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
		F10S  	"State and local: Gross investment in structures" /;

parameter
	y0(r,g)		Aggregate supply,
	yd0(r,g)	Domestic supply,
	s0(g,mkt)	Aggregate supply to market
	va0(r,s)	Value-added,
	id0(r,g,s)	Intermediate demand,
	x0(r,g)		Regional exports,
	x0n(g)		National exports
	ms0(r,g,mrg)	Margin supply,
	md0(r,g,mrg)	Margin demand,
	fd0(r,g,xd)	Final demand,
	cd0(r,g)	Consumer demand,
	a0(r,g)		Absorption,
	m0(r,g)		Imports;

y0(r,g) = sum(ru,iot(ru,g,r));
s0(g,mkt) = sum(r,ys0(g,r,mkt));

x0(r,g(ru)) = iot(ru,"f040",r);
x0n(g) = sum(r,x0(r,g));
ms0(r,g(ru),mrg(c)) = max(0,iot(ru,c,r));
yd0(r,g) = y0(r,g) - x0(r,g) - sum(mkt,ys0(g,r,mkt)) - sum(mrg,ms0(r,g,mrg));
va0(r,g(cu)) = sum(ru$(not g(ru)), use(ru,cu,r));
m0(r,g(ru)) = iot(ru,"mcif",r) + iot(ru,"madj",r) + iot(ru,"mdty",r);
md0(r,g(ru),mrg(c)) = max(0,-iot(ru,c,r));
cd0(r,g(ru)) = iot(ru,"F010",r);
fd0(r,g(ru),xd(cu)) = iot(ru,cu,r);
id0(r,g(ru),s(cu)) = iot(ru,cu,r);
a0(r,g) = sum(s,id0(r,g,s)) + cd0(r,g) + sum(xd,fd0(r,g,xd));

set	ags(*)  Agricultural sectors/ 
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

variables	v_PY(r,g)	Content of domestic commodity,
		v_P(g,mkt)	Content of market commodity,
		v_PA(r,g)	Content of absorption,
		v_PI(r,mrg)	Content of margin;
$ondotl

*	First solve the model iteratively:

parameter	v_PYn(r,g)	Lagged content
		dev		Deviation /1/
		iter_log	Iteration log;

set	iter /iter1*iter25/;

v_PY(r,s) = 1$ags(s);
dev = 1;
loop(iter$round(dev,2),
	v_PI(r,mrg) =  sum(g,v_PY(r,g)*ms0(r,g,mrg))/sum(g,ms0(r,g,mrg));

	v_P(g,mkt)$s0(g,mkt) = sum(r,v_PY(r,g)*ys0(g,r,mkt))/s0(g,mkt);

	v_PA(r,g)$a0(r,g) = (v_PY(r,g)*yd0(r,g) + 
			sum(mkt,v_P(g,mkt)*d0(g,mkt,r)) +
			sum(mrg,v_PI(r,mrg)*md0(r,g,mrg))) / a0(r,g);

	v_PYn(r,s)$y0(r,s) = ( sum(g,v_PA(r,g)*id0(r,g,s)) +  y0(r,s)$ags(s) ) / y0(r,s);

	dev = sum((r,s)$y0(r,s), abs(v_PYn(r,s)-v_PY(r,s)));

	v_PY(r,s) = v_PYn(r,s);
	iter_log(iter,"dev") = dev;
);
display iter_log;

$ifthen.agg "%suffix%"=="_"
	alias (i,g);
	set i_g(g,g);
	i_g(g,g) = yes;
$else.agg
	set i(*)	Aggregated sectors
	set	i_g(i<,g) /
	agr.osd_agr, agr.grn_agr, agr.veg_agr, agr.nut_agr, agr.flo_agr,
	agr.oth_agr, agr.dry_agr, agr.bef_agr, agr.egg_agr, agr.ota_agr,
	agr.log_fof, agr.fht_fof, agr.saf_fof, min.oil, min.col_min,
	min.led_min, min.ore_min, min.stn_min, min.oth_min, min.drl_smn,
	min.oth_smn, con.hcs_con, con.edu_con, con.nmr_con, con.rmr_con,
	con.off_con, con.mrs_con, con.ors_con, con.mfs_con, con.ons_con,
	con.pwr_con, con.srs_con, con.trn_con, trn.air, trn.trn, trn.wtt,
	trn.trk, trn.grd, trn.pip, trn.wrh, trn.sce_otr, trn.mes_otr,
	fin.fin, fin.cre_bnk, fin.mon_bnk, fin.ofi_sec, fin.com_sec,
	fin.dir_ins, fin.car_ins, fin.agn_ins, adm.wst, adm.emp_adm,
	adm.dwe_adm, adm.off_adm, adm.fac_adm, adm.bsp_adm, adm.trv_adm,
	adm.inv_adm, adm.oss_adm, edu.sec_edu, edu.uni_edu, edu.oes_edu,
	rec.pfm_art, rec.spr_art, rec.ind_art, rec.agt_art, rec.mus_art,
	rec.amu_rec, rec.cas_rec, rec.ori_rec, usd.srp_usd, usd.sec_usd,
	oth.imp_oth, oth.rwa_oth, utl.ele_uti, utl.gas_uti, utl.wat_uti,
	drg.saw_wpd, drg.ven_wpd, drg.mil_wpd, drg.owp_wpd, drg.cly_nmp,
	drg.gla_nmp, drg.cmt_nmp, drg.cnc_nmp, drg.cpb_nmp, drg.ocp_nmp,
	drg.lme_nmp, drg.abr_nmp, drg.cut_nmp, drg.tmn_nmp, drg.wol_nmp,
	drg.mnm_nmp, drg.irn_pmt, drg.stl_pmt, drg.ala_pmt, drg.alu_pmt,
	drg.nms_pmt, drg.cop_pmt, drg.nfm_pmt, drg.fmf_pmt, drg.nff_pmt,
	drg.rol_fmt, drg.fss_fmt, drg.crn_fmt, drg.cut_fmt, drg.plt_fmt,
	drg.orn_fmt, drg.pwr_fmt, drg.mtt_fmt, drg.mtc_fmt, drg.hdw_fmt,
	drg.spr_fmt, drg.mch_fmt, drg.tps_fmt, drg.ceh_fmt, drg.plb_fmt,
	drg.vlv_fmt, drg.bbr_fmt, drg.fab_fmt, drg.amn_fmt, drg.omf_fmt,
	drg.frm_mch, drg.lwn_mch, drg.con_mch, drg.min_mch, drg.smc_mch,
	drg.oti_mch, drg.opt_mch, drg.pht_mch, drg.oci_mch, drg.hea_mch,
	drg.acn_mch, drg.air_mch, drg.imm_mch, drg.spt_mch, drg.mct_mch,
	drg.cut_mch, drg.tbn_mch, drg.spd_mch, drg.mch_mch, drg.oee_mch,
	drg.agc_mch, drg.ppe_mch, drg.mat_mch, drg.pwr_mch, drg.pkg_mch,
	drg.ipf_mch, drg.ogp_mch, drg.fld_mch, drg.ecm_cep, drg.csd_cep,
	drg.ctm_cep, drg.tel_cep, drg.brd_cep, drg.oce_cep, drg.sem_cep,
	drg.prc_cep, drg.oec_cep, drg.eea_cep, drg.sdn_cep, drg.aec_cep,
	drg.ipv_cep, drg.tfl_cep, drg.els_cep, drg.ali_cep, drg.irr_cep,
	drg.wcm_cep, drg.aud_cep, drg.mmo_cep, drg.elb_eec, drg.ltf_eec,
	drg.sea_eec, drg.ham_eec, drg.pwr_eec, drg.mtg_eec, drg.swt_eec,
	drg.ric_eec, drg.sbt_eec, drg.pbt_eec, drg.cme_eec, drg.wdv_eec,
	drg.cbn_eec, drg.oee_eec, drg.atm_mot, drg.ltr_mot, drg.htr_mot,
	drg.mbd_mot, drg.trl_mot, drg.hom_mot, drg.cam_mot, drg.gas_mot,
	drg.eee_mot, drg.tpw_mot, drg.trm_mot, drg.stm_mot, drg.omv_mot,
	drg.brk_mot, drg.air_ote, drg.aen_ote, drg.oar_ote, drg.mis_ote,
	drg.pro_ote, drg.rrd_ote, drg.shp_ote, drg.bot_ote, drg.mcl_ote,
	drg.mlt_ote, drg.otm_ote, drg.cab_fpd, drg.uph_fpd, drg.nup_fpd,
	drg.ifm_fpd, drg.ohn_fpd, drg.shv_fpd, drg.off_fpd, drg.ofp_fpd,
	drg.smi_mmf, drg.sas_mmf, drg.dnt_mmf, drg.oph_mmf, drg.dlb_mmf,
	drg.jwl_mmf, drg.ath_mmf, drg.toy_mmf, drg.ofm_mmf, drg.sgn_mmf,
	drg.omm_mmf, ndg.dog_fbp, ndg.oaf_fbp, ndg.flr_fbp, ndg.wet_fbp,
	ndg.fat_fbp, ndg.soy_fbp, ndg.brk_fbp, ndg.sug_fbp, ndg.fzn_fbp,
	ndg.can_fbp, ndg.chs_fbp, ndg.dry_fbp, ndg.mlk_fbp, ndg.ice_fbp,
	ndg.chk_fbp, ndg.asp_fbp, ndg.sea_fbp, ndg.brd_fbp, ndg.cok_fbp,
	ndg.snk_fbp, ndg.tea_fbp, ndg.syr_fbp, ndg.spc_fbp, ndg.ofm_fbp,
	ndg.pop_fbp, ndg.ber_fbp, ndg.wne_fbp, ndg.why_fbp, ndg.cig_fbp,
	ndg.fyt_tex, ndg.fml_tex, ndg.txf_tex, ndg.rug_tex, ndg.lin_tex,
	ndg.otp_tex, ndg.app_alt, ndg.lea_alt, ndg.plp_ppd, ndg.ppm_ppd,
	ndg.pbm_ppd, ndg.pbc_ppd, ndg.ppb_ppd, ndg.sta_ppd, ndg.toi_ppd,
	ndg.opp_ppd, ndg.pri_pri, ndg.sap_pri, ndg.ref_pet, ndg.pav_pet,
	ndg.shn_pet, ndg.oth_pet, ndg.ptr_che, ndg.igm_che, ndg.sdp_che,
	ndg.obi_che, ndg.obo_che, ndg.pmr_che, ndg.srf_che, ndg.mbm_che,
	ndg.phm_che, ndg.inv_che, ndg.bio_che, ndg.fmf_che, ndg.pag_che,
	ndg.pnt_che, ndg.adh_che, ndg.sop_che, ndg.toi_che, ndg.pri_che,
	ndg.och_che, ndg.plm_pla, ndg.ppp_pla, ndg.lam_pla, ndg.fom_pla,
	ndg.ure_pla, ndg.bot_pla, ndg.opm_pla, ndg.tir_pla, ndg.rbr_pla,
	ndg.orb_pla, whl.mtv_wht, whl.pce_wht, whl.hha_wht, whl.mch_wht,
	whl.odg_wht, whl.dru_wht, whl.gro_wht, whl.pet_wht, whl.ndg_wht,
	whl.ele_wht, rtl.mvt, rtl.fbt, rtl.gmt, rtl.bui_ott, rtl.hea_ott,
	rtl.gas_ott, rtl.clo_ott, rtl.non_ott, rtl.oth_ott, inf.new_pub,
	inf.pdl_pub, inf.bok_pub, inf.mal_pub, inf.sfw_pub, inf.pic_mov,
	inf.snd_mov, inf.rad_brd, inf.cbl_brd, inf.wtl_brd, inf.wls_brd,
	inf.sat_brd, inf.dpr_dat, inf.int_dat, inf.new_dat, rst.ORE,
	rst.own_hou, rst.rnt_hou, rst.aut_rnt, rst.com_rnt, rst.cmg_rnt,
	rst.int_rnt, pts.leg, pts.cus_com, pts.sys_com, pts.ocs_com,
	pts.acc_tsv, pts.arc_tsv, pts.mgt_tsv, pts.env_tsv, pts.sci_tsv,
	pts.adv_tsv, pts.des_tsv, pts.pht_tsv, pts.vet_tsv, pts.mkt_tsv,
	mgr.man, hea.hos, hea.phy_amb, hea.dnt_amb, hea.ohp_amb,
	hea.out_amb, hea.lab_amb, hea.hom_amb, hea.oas_amb, hea.ncc_nrs,
	hea.res_nrs, hea.ifs_soc, hea.day_soc, hea.cmf_soc, acc.amd,
	acc.ful_res, acc.lim_res, acc.ofd_res, ots.atr_osv, ots.eqr_osv,
	ots.imr_osv, ots.hgr_osv, ots.pcs_osv, ots.fun_osv, ots.dry_osv,
	ots.ops_osv, ots.rel_osv, ots.grt_osv, ots.civ_osv, ots.prv_osv,
	gov.fdd, gov.fnd, gov.pst_fen, gov.ofg_fen, gov.edu_slg,
	gov.hea_slg, gov.oth_slg, gov.osl_sle /;
$endif.agg

parameter	thetax(g,r,tp)	Region r fraction of g exports to tp,
		thetay(g,r,i)	Output fraction,
		atm(i,*)	Agricultural trade multipliers (summary)
		atmd(g,r)	Agricultural trade multipliers (detailed);

thetay(g,r,i)$y0(r,g) = y0(r,g) / sum(i_g(i,gg),y0(r,gg));
thetax(g,r,tp)$bx0(g,r,tp) = bx0(g,r,tp) / sum(rr,bx0(g,rr,tp));

atm(i,tp) = sum((r,i_g(i,g)), thetax(g,r,tp) * thetay(g,r,i) * (V_PY.L(r,g) - 1$ags(g)));
atm(i,r) = sum(i_g(i,g), thetay(g,r,i) * (V_PY.L(r,g) - 1$ags(g)));
atmd(g,r) = (V_PY.L(r,g) - 1$ags(g));

$exit

*	Save results from the iterative calculation and verify consistency 
*	with the direct calculation:

parameter	compare		Comparison of results;
compare(mkt,g,"P","iTER")  = v_P.L(g,mkt);
compare(r,mrg,"PI","Iter") = v_PI.L(r,mrg);
compare(r,s,"PY","Iter")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","Iter")$a0(r,g) = v_PA.L(r,g);

equations	def_PY, def_PI, def_P, def_PA;

def_PY(r,s)$y0(r,s)..	v_PY(r,s) * y0(r,s) =e= sum(g,v_PA(r,g)*id0(r,g,s)) + y0(r,s)$ags(s);

def_PI(r,mrg)..		v_PI(r,mrg)*sum(g,ms0(r,g,mrg))  =e= sum(g,v_PY(r,g)*ms0(r,g,mrg));

def_P(g,mkt)$s0(g,mkt).. v_P(g,mkt)*s0(g,mkt) =e= sum(r,v_PY(r,g)*ys0(g,r,mkt));

def_PA(r,g)$a0(r,g)..	v_PA(r,g)*a0(r,g) =e= v_PY(r,g)*yd0(r,g) + 
					sum(mkt,v_P(g,mkt)*d0(g,mkt,r)) + 
					sum(mrg,v_PI(r,mrg)*md0(r,g,mrg));

v_PY.FX(r,g)$(not y0(r,g)) = 0;
v_P.FX(g,mkt)$(not s0(g,mkt)) = 0;
v_PA.FX(r,g)$(not a0(r,g)) = 0;
v_P.FX(g,mkt)$(not s0(g,mkt)) = 0;

model atmMCP /def_PY.v_PY, def_PI.v_PI, def_P.v_P, def_PA.v_PA /;

$ifthen.mcpsolve "%suffix%"=="_"

solve atmMCP using mcp;
compare(mkt,g,"P","MCP")  = v_P.L(g,mkt);
compare(r,mrg,"PI","MCP") = v_PI.L(r,mrg);
compare(r,s,"PY","MCP")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","MCP")$a0(r,g) = v_PA.L(r,g);

$endif.mcpsolve

variable	obj	Dummy objective;
equation	objdef;
objdef..		OBJ =e= 0;
model atmLP /objdef, def_PY, def_P, def_PI, def_PA /;

option lp=ipopt;
solve atmLP using LP minimizing obj;

compare(mkt,g,"P","LP")  = v_P.L(g,mkt);
compare(r,mrg,"PI","LP") = v_PI.L(r,mrg);
compare(r,s,"PY","LP")$y0(r,s) = v_PY.L(r,s);
compare(r,g,"PA","LP")$a0(r,g) = v_PA.L(r,g);
option compare:3:2:2;
display compare;

$exit

parameter	atm(s,r,g,tp)	Agricultural trade multipliers;
atm(s,r,g,tp) = thetax(s,r,tp) * (V_PY.L(r,g) - 1$ags(g));