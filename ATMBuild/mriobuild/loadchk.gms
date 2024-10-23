$title		Merge the Gravity Trade Estimates into the Supply-Use Table

$if not set yr $set yr 2022

$if not exist gravityoutput_%yr%.gdx $call 'gams gravitycalc'

parameter	gravitycalc(g,*,*)	Output from gravitycalc
		gravitytrade(g,*,*)	Trade flows in the gravity estimate;

set		tp(*)		Trade partners;

$gdxin 'gravityoutput_%yr%.gdx'
$loaddc gravitycalc tp=r  gravitytrade

parameter	statechk;
statechk(gt(g),r,"y0")  = gravitydata(gt,r,"y0");
statechk(gt(g),r,"y0*") = gravitycalc(gt,r,"yd0") + gravitycalc(gt,r,"yn0") + gravitycalc(gt,r,"yx0");
statechk(gt(g),r,"a0") = gravitydata(gt,r,"a0");
statechk(gt(g),r,"a0*") = gravitycalc(gt,r,"yd0") + gravitycalc(gt,r,"nd0") + gravitycalc(gt,r,"md0");
option statechk:3:2:1;
display statechk;

parameter	nationchk;
nationchk(gt(g),"yn0") = sum(r,gravitycalc(gt,r,"yn0"));
nationchk(gt(g),"nd0") = sum(r,gravitycalc(gt,r,"nd0"));
display nationchk;

parameter	gravitychk;
gravitychk(gt(g),"y0") = sum(r,gravitydata(gt,r,"y0")) ;
gravitychk(gt(g),"y0*") = 
	  sum(r,gravitycalc(gt,r,"yd0"))
	+ sum(r,gravitycalc(gt,r,"yn0"))
	+ sum(r,gravitycalc(gt,r,"yx0"));

gravitychk(gt(g),"a0") = sum(r,gravitydata(gt,r,"a0")) ;
gravitychk(gt(g),"a0*") = 
	sum(r,gravitycalc(gt,r,"yd0")) +
	sum(r,gravitycalc(gt,r,"nd0")) +
	sum(r,gravitycalc(gt,r,"md0"));
	
display gravitychk;

parameter	supplydemand	Benchmark data;
supplydemand(gt(g),"a0") = sum(r,gravitydata(gt,r,"a0"));
supplydemand(gt(g),"y0") = sum(r,gravitydata(gt,r,"y0"));

parameter	echoprint	Comparison of values;

echoprint(gt(g),r,"MD/A","Uniform") = THETAM.L(g);
echoprint(gt(g),r,"MD/A","Gravity")$gravitycalc(gt,r,"md0") = gravitycalc(gt,r,"md0")/gravitydata(gt,r,"a0");

echoprint(gt(g),r,"YD/A","Uniform") = THETAD.L(g);
echoprint(gt(g),r,"YD/A","Gravity")$gravitycalc(gt,r,"yd0") = gravitycalc(gt,r,"yd0")/gravitydata(gt,r,"a0");

echoprint(gt(g),r,"YD/Y","Uniform")$YD.L(g,r) = YD.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YD/Y","Gravity")$gravitycalc(gt,r,"yd0") = gravitycalc(gt,r,"yd0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"YX/Y","Uniform")$YX.L(g,r) = YX.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YX/Y","Gravity")$gravitycalc(gt,r,"yx0") = gravitycalc(gt,r,"yx0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"YN/Y","Uniform")$YN.L(g,r) = YN.L(g,r)/asupply(g,r);
echoprint(gt(g),r,"YN/Y","Gravity")$gravitycalc(gt,r,"yn0") = gravitycalc(gt,r,"yn0")/gravitydata(gt,r,"y0");

echoprint(gt(g),r,"ND/A","Uniform")$ND.L(g,r) = ND.L(g,r)/ademand(g,r);
echoprint(gt(g),r,"ND/A","Gravity")$gravitycalc(gt,r,"nd0") = gravitycalc(gt,r,"nd0")/gravitydata(gt,r,"a0");

*.execute_unload 'echoprint.gdx',echoprint, supplydemand;
*.execute 'gdxxrw i=echoprint.gdx o=echoprint.xlsx par=echoprint rng=PivotData!a2 cdim=0 par=supplydemand rng=SupplyDemand!a1 rdim=1 cdim=1';

*	Move the gravity estimates into the input-output table:

*	Share of national import demand for good gt which is in state r:

alpham(gt(g(rs)),r)$sum(snz_n(rs,iimp),1) = gravitycalc(gt,r,"md0")/sum(iimp,supply_n(yb,rs,iimp));

*	Use this to share out both import accounts:

supply(snz_n(rs(g),iimp),r) = alpham(g,r) * supply_n(yb,snz_n);

*	Set up national markets:

supply(rs(gt),"MCIF_N",r) = gravitycalc(gt,r,"nd0");
use(ru(gt),"F040",r)   = gravitycalc(gt,r,"yx0");
use(ru(gt),"F040_N",r) = gravitycalc(gt,r,"yn0");

option snz<supply, unz<use;

rmarket(r,g,"supply") = sum(snz(rs(g),cs(s),r),supply(snz)) + 
			sum(snz(rs(g),txs,r),supply(snz)) +
			sum(snz(rs(g),mrg,r),supply(snz)) + inventory(g,r);
rmarket(r,g,"import") = sum(snz(rs(g),imp,r), supply(snz));
rmarket(r,g,"export") = sum(unz(ru(g),export,r),use(unz));
rmarket(r,g,"demand") =   sum(unz(ru(g),cu(s),r),use(unz))
			+ sum(unz(ru(g),fd,r),use(unz))+inventory(g,r);
rmarket(r,g,"chk") =	rmarket(r,g,"supply") +
			rmarket(r,g,"import") -
			rmarket(r,g,"export") - 
			rmarket(r,g,"demand");
option rmarket:3:2:1;
display rmarket;

set	gs(rs)	Goods in the supply table, 
	gu(ru)	Goods in the use table, 
	ss(cs)	Sectors in the supply table, 
	su(cu)	Sectors in the use table;

option gs<snz, gu<unz, ss<snz, su<unz;

gs(rs)$(not g(rs)) = no;
gu(ru)$(not g(ru)) = no;

gs(rs(g)) = g(g);
gu(ru(g)) = g(g);

ss(cs(s)) = s(s);
su(cu(s)) = s(s);

option gs:0:0:1, gu:0:0:1, ss:0:0:1, su:0:0:1;
display gs, gu, ss, su;

set	g_(*)	Goods in either use or supply table, 
	s_(*)	Sectors in either use or supply;

g_(gs) = gs(gs);
g_(gu) = gu(gu);
s_(ss) = ss(ss);
s_(su) = su(su);
option g_:0:0:1, s_:0:0:1;
display g_, s_;

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

$eolcom !

set     censusmap(census,r)      Mapping of census regions to states /
		neg.(ct,me,ma,nh,ri,vt)
		mid.(nj,ny,pa)
		enc.(il,in,mi,oh,wi)
		wnc.(ia,ks,mn,mo,ne,nd,sd)
		sac.(de,fl,ga,md,nc,sc,va,wv)	! dc
		esc.(al,ky,ms,tn)
		wsc.(ar,la,ok,tx)
		mtn.(az,co,id,mt,nv,nm,ut,wy)
		pac.(ca,or,wa) /;		! ak,hi

set	mkt /national, (set.census), (set.r)/;

parameter	ys0(g,r,mkt)	Market supply,
		d0(g,mkt,r)	Market demand,
		bx0(g,r,tp)	Bilateral exports,
		bm0(g,tp,r)	Bilateral imports;

*	Provide three alternative market structures: national, census or state:

ys0(gt,r,"national") = gravitycalc(gt,r,"yn0");
d0(gt,"national",r) =  gravitycalc(gt,r,"nd0");

ys0(gt,r,mkt(census)) = sum(censusmap(census,rr),gravitytrade(gt,r,rr));
d0(gt,mkt(census),r) =  sum(censusmap(census,rr),gravitytrade(gt,rr,r));

ys0(gt,r,mkt(rr)) = gravitytrade(gt,r,rr);
d0(gt,mkt(rr),r) =  gravitytrade(gt,rr,r);

bx0(gt,r,tp) = gravitytrade(gt,r,tp);
bm0(gt,tp,r) = gravitytrade(gt,tp,r);

execute_unload 'supplyusegravity_%yr%.gdx', supply, use, ys0, d0, s, tp, bx0, bm0, gt;

$exit

*	Generate data for visualization:


set	st(*)	State identifiers;

set r_st(r,st<)		Mapping to state name /
	AL."Alabama",
	AR."Arizona",
	AZ."Arkansas",
	CA."California",
	CO."Colorado",
	CT."Connecticut",
	DE."Delaware",
	FL."Florida",
	GA."Georgia",
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

	set af(g)	Agriculture and food products /
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
		cig_fbp  Tobacco manufacturing (312200) /;


parameter	dx0(*,g,r,st)		Domestic exports under different trade structures;
loop(r_st(rr,st),
  dx0("state",af(gt),r,st) = gravitytrade(gt,r,rr);
);

parameter	d0tot(g,*);
d0tot(gt,census) = sum((censusmap(census,r),rr),gravitytrade(gt,r,rr));

loop(r_st(rr,st),
  dx0("census",af(gt),r,st) = 
	sum(mkt(census)$ys0(gt,r,mkt), ys0(gt,r,mkt) * d0(gt,mkt,rr)/d0tot(gt,census));
);

parameter	nd0tot(g);
nd0tot(gt) = sum(r,gravitycalc(gt,r,"nd0"));

loop(r_st(rr,st),
  dx0("national",af(gt),r,st)$gravitycalc(gt,r,"yn0") = 
	gravitycalc(gt,r,"yn0")*gravitycalc(gt,rr,"nd0")/nd0tot(gt);
);

execute_unload 'dexport.gdx',dx0,r,af;
execute 'gdxxrw i=dexport.gdx o=dexport.xlsx par=dx0 rng=PivotData!a2 cdim=0';
*.execute 'gdxxrw i=dexport.gdx o=dexport.xlsx set=r rng=States!a1 values=string rdim=1 cdim=0';

parameter	ftrade		Foreign trade
		maxtrade	Maximum value of foreign trade;

maxtrade(tp,"export") = smax((r,gt),gravitytrade(gt,r,tp));
maxtrade(tp,"import") = smax((r,gt),gravitytrade(gt,tp,r));
display maxtrade;

loop(r_st(r,st),
	ftrade("export",gt,st,tp) = gravitytrade(gt,r,tp);
	ftrade("import",gt,st,tp) = gravitytrade(gt,tp,r);
);


*	Be sure we have all the descriptions:

gt(gt) = g(gt);

execute_unload 'ftrade.gdx',ftrade,r,tp,gt;
execute 'gdxxrw i=ftrade.gdx o=ftrade.xlsx par=ftrade rng=PivotData!a2 cdim=0';
*.execute 'gdxxrw i=ftrade.gdx o=ftrade.xlsx set=tp rng=Countries!a1 values=string rdim=1 cdim=0';
*.execute 'gdxxrw i=ftrade.gdx o=ftrade.xlsx set=gt rng=Goods!a1 values=string rdim=1 cdim=0';
