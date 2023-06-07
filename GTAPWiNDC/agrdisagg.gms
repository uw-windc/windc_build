$title	Disaggregate Agricultural Sectors in a WiNDC Dataset

*	Targetting is based on national totals from GTAP and state-level
*	values from USDA Cash Receipts dataset.

$if not set year  $set year 2017

$if not set datadir $set datadir ..\household\datasets\
$if not set ds $set ds cps_static_gtap_32_state

$if not set dsout $set dsout datasets\windc\43.gdx

set s	Sectors (to which we introduce /
	fbp  "Food and beverage and tobacco products (311FT)",
	tex  "Textiles",
	uti  "Utilities (electricity-gas-water)",
	oil  "Petroleum, coal products",
	fof  "Forestry and fishing",
	alt  "Apparel and leather and allied products (315AL)",
	pmt  "Primary metals (331)",
	trd  "Trade",
	oxt  "Coal, minining and supporting activities",
	ros  "Recreational and other services",
	dwe  "Dwellings and real estate activities",
	LUM  "Lumber and wood products",
	NMM  "Mineral products nec",
	FMP  "Metal products",
	MVH  "Motor vehicles and parts",
	OTN  "Transport equipment nec",
	OME  "Machinery and equipment nec",
	CNS  "Construction",
	WTP  "Water transport",
	ATP  "Air transport",
	ISR  "Insurance",
	OGS  "Crude oil and natural gas",
	PPP  "Paper products, publishing",
	CRP  "Chemical, rubber, plastic products",
	EEQ  "Electronic equipment",
	OMF  "Manufactures nec",
	OTP  "Transport nec",
	CMN  "Communication",
	OFI  "Financial services nec",
	OBS  "Business services nec",
	OSG  "Public Administration, Defense, Education, Health",

	agr  "Farms and farm products (111CA)",

	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk",
	wol  "Wool, silk-worm cocoons"/;

$include windc_data

alias (i,g);
*	-------------------------------------------------------------------------
*	Extract agricultural data totals from GTAP:

parameter	vafm(i,*)	GTAP intermediate demand
		v(i,*)		Totals (vom - vxm - vim);

$onechov >%gams.scrdir%gtapagr.gms
$title	Extract Agricultural Data from the GTAP Dataset

$include gtap11

$set ds g20_43

$include %gtap11%gtapdata

set	agr(g) /
	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk",
	wol  "Wool, silk-worm cocoons" /;

parameter	vafm(i,g)	Aggregate intermediate demand;
vafm(i,g) = sum(r$sameas(r,"usa"), vdfm(i,g,r)*(1+rtfd0(i,g,r))+vifm(i,g,r)*(1+rtfi0(i,g,r)));

parameter	v(i,*)		Totals;
v(i,"vom") = vom(i,"usa");
v(i,"vim") = vim(i,"usa");
v(i,"vxm") = sum(rm, vxmd(i,"usa",rm)) + vst(i,"usa");
$offecho
$call gams %gams.scrdir%gtapagr gdx=%gams.scrdir%gtapagr.gdx o=lst\gtapagr.lst
$gdxin '%gams.scrdir%gtapagr.gdx'
$loaddc vafm v

parameter	penalty	/10000/;

variables
	OBJ		Objective function;

nonnegative
variables
	A0_c(r,s)	Armington supply,
	CD0_h_c(r,g,h)	Final demand,
	ID0_c(r,s,g)	Intermediate demand,
	LD0_c(r,s)	Labor demand,
	KD0_c(r,s)      Capital demand,
	XN0_c(r,g)	Regional supply to national market,
	XD0_c(r,g)	Regional supply to local market,
	ND0_c(r,g)	National demand in local  market,
	DD0_c(r,g)	Regional demand in local  market,
	NM0_c(r,g,m)	Margin demand from national market,
	YS0_c(r,g,s)	Sectoral supply,
	X0_c(r,s)	Exports of goods and services,
	RX0_c(r,s)	Re-exports of goods and services,
	MD0_c(r,m,s)	Total margin demand,
	DM0_c(r,g,m)	Margin supply from local market,
	M0_c(r,s)	Imports;

$macro	target(a,b,d)  sum((&&d), ( abs(a(&&d))*sqr(b(&&d)/a(&&d)-1) )$a(&&d) \
                                       + (penalty * b(&&d))$(not a(&&d)))

equations	objdef, market_rks, market_pl, market_pa, market_pn, market_pd,
		profit_y, profit_X, profit_A, profit_MS, profit_C;

objdef..	OBJ =E= target(a0, a0_c, "r,s") +
			target(cd0_h, cd0_h_c, "r,g,h") +
			target(id0, id0_c, "r,s,g") +
			target(ld0, ld0_c, "r,s") +
			target(kd0, kd0_c, "r,s") +
			target(xn0, xn0_c, "r,g") +
			target(xd0, xd0_c, "r,g") +
			target(nd0, nd0_c, "r,g") +
			target(dd0, dd0_c, "r,g") +
			target(nm0, nm0_c, "r,g,m") +
			target(ys0, ys0_c, "r,g,s") +
			target(x0, x0_c, "r,s") +
			target(rx0, rx0_c, "r,s") +
			target(md0, md0_c, "r,m,s") +
			target(dm0, dm0_c, "r,g,m") +
			target(m0, m0_c, "r,s");

market_RKS..		sum((r,s),kd0(r,s)) =e= sum((r,s),KD0_c(r,s));

market_pl(r)..		sum((q,h), le0(q,r,h)) =e= sum(s, LD0_c(r,s));

market_pa(r,g)..	A0_c(r,g) =e= sum(h, CD0_h_c(r,g,h)) + 	sum(s,ID0_c(r,g,s)) + i0(r,g) + g0(r,g) ;

market_pn(g)..		sum(r, XN0_c(r,g)) =e= sum(r, ND0_c(r,g)) + sum((r,m),NM0_c(r,g,m))$gm(g);

market_pd(r,g)..	XD0_c(r,g) =e= DD0_c(r,g) + sum(m, DM0_c(r,g,m));

profit_y(r,s)..		sum(g,YS0_c(r,s,g)*(1-ty0(r,s))) =e= sum(g,ID0_c(r,g,s)) + LD0_c(r,s) + KD0_c(r,s)*(1+tk0(r));

* $prod:Y(r,s)$y_c(r,s)  s:0 va:1
* 	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
*         i:PA(r,g)       q:id0(r,g,s)
*         i:PL(r)         q:ld0(r,s)     va:
*         i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

profit_X(r,g)..		X0_c(r,g)-RX0_c(r,g) + XN0_c(r,g) + XD0_c(r,g) =e= sum(s,YS0_c(r,s,g)) + yh0(r,g);

* $prod:X(r,g)$x_c(r,g)  t:4
*         o:PFX           q:(x0(r,g)-rx0(r,g))
*         o:PN(g)         q:xn0(r,g)
*         o:PD(r,g)       q:xd0(r,g)
*         i:PY(r,g)       q:s0(r,g)

profit_A(r,g)..		A0_c(r,g)*(1-ta0(r,g)) + RX0_c(r,g) =e=

				ND0_c(r,g) + DD0_c(r,g) + M0_c(r,g)*(1+tm0(r,g)) + sum(m,MD0_c(r,m,g));

* $prod:A(r,g)$a_c(r,g)  s:0 dm:4  d(dm):2
*         o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
*         o:PFX           q:rx0(r,g)
*         i:PN(g)         q:nd0(r,g)      d:
*         i:PD(r,g)       q:dd0(r,g)      d:
*         i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
*         i:PM(r,m)       q:md0(r,m,g)


profit_MS(r,m)..	sum(g, MD0_c(r,m,g)) =e= sum(gm,NM0_c(r,gm,m) + DM0_c(r,gm,m));

profit_C(r,h)..		c0_h(r,h) =e= sum(g,CD0_H_c(r,g,h))

model lsqcalib /objdef, market_rks, market_pl, market_pa, market_pn, market_pd, 
		profit_y, profit_X, profit_A, profit_MS, profit_C /;


set	params /a0, cd0_h, id0, ld0, kd0, xn0, xd0, nd0, 
		dd0, nm0, ys0, x0, rx0, md0, dm0, m0/;

parameter	nz(params)		Nonzero count,
		nzlog(*,*)		Nonzero log;

$macro initialize(a,b,d) b.l(&&d) = a(&&d); nz("&&a") = card(a);

initialize(a0,	  a0_c,   "r,s")
initialize(cd0_h, cd0_h_c,"r,g,h") 	
initialize(id0,   id0_c, "r,s,g") 	
initialize(ld0,   ld0_c, "r,s") 	
initialize(kd0,   kd0_c, "r,s") 	
initialize(xn0,   xn0_c, "r,g") 	
initialize(xd0,   xd0_c, "r,g") 	
initialize(nd0,   nd0_c, "r,g") 	
initialize(dd0,   dd0_c, "r,g") 	
initialize(nm0,   nm0_c, "r,g,m") 	
initialize(ys0,   ys0_c, "r,g,s") 	
initialize(x0,    x0_c, "r,s") 	
initialize(rx0,   rx0_c, "r,s") 	
initialize(md0,   md0_c, "r,m,s") 	
initialize(dm0,   dm0_c, "r,g,m") 
initialize(m0,    m0_c, "r,s")
nzlog(params,"windc_agr") = nz(params);


parameters	market_RKS_chk, market_pl_chk(r), market_pa_chk(r,g),
		market_pn_chk(g), profit_y_chk(r,s), profit_X_chk(r,g),
		profit_A_chk(r,g), profit_MS_chk(r,m), profit_c_chk(r,h);

market_RKS_chk = ROUND( sum((r,s),kd0(r,s)) - (  sum((r,s),KD0_c.L(r,s)) ), 3);

market_pl_chk(r) = ROUND( sum((q,h), le0(q,r,h)) - (  sum(s, LD0_c.L(r,s)) ), 3);

market_pa_chk(r,g) = ROUND( A0_c.L(r,g) - (  sum(h, CD0_h_c.L(r,g,h)) + 	sum(s,ID0_c.L(r,g,s)) + i0(r,g) + g0(r,g)  ), 3);

market_pn_chk(g) = ROUND( sum(r, XN0_c.L(r,g)) - (  sum(r, ND0_C.L(r,g)) + sum((r,m),NM0_c.L(r,g,m))$gm(g) ), 3);

profit_y_chk(r,s) = ROUND( sum(g,YS0_c.L(r,s,g)*(1-ty0(r,s))) - (  sum(g,ID0_c.L(r,g,s)) + LD0_c.L(r,s) + KD0_c.L(r,s)*(1+tk0(r)) ), 3);

profit_X_chk(r,g) = ROUND( X0_c.L(r,g)-RX0_c.L(r,g) + XN0_c.L(r,g) + XD0_c.L(r,g) - (  sum(s,YS0_c.L(r,s,g)) + yh0(r,g) ), 3);

profit_A_chk(r,g) = ROUND( A0_c.L(r,g)*(1-ta0(r,g)) + RX0_c.L(r,g) - ( 

				ND0_c.L(r,g) + DD0_c.L(r,g) + M0_c.L(r,g)*(1+tm0(r,g)) + sum(m,MD0_c.L(r,m,g)) ), 3);

profit_MS_chk(r,m) = ROUND( sum(gm, MD0_c.L(r,m,gm)) - (  sum(gm,NM0_c.L(r,gm,m) + DM0_c.L(r,gm,m)) ), 3);

profit_c_chk(r,h) = ROUND( c0_h(r,h) - (  sum(g,CD0_H_c.L(r,g,h))), 3);

display market_RKS_chk, market_pl_chk, market_pa_chk,
		market_pn_chk, profit_y_chk, profit_X_chk,
		profit_A_chk, profit_MS_chk, profit_c_chk;

*	Demonstrate that we have a handshake on the WINDC dataset:

option qcp=cplex;
solve lsqcalib using qcp minimizing OBJ;

table cr_data(r,s)	Cash receipts data 

           pdr         wht         gro         v_f         osd         c_b         pfb         ocr         ctl         oap         rmk         wol	       
al                   46369      166868       10009      327020                  313164      483753      595173     4417416       19412          39	       
ak                                1471        2057                                           30159        2052        4957         645		  	       
az                   86368       54027     2113020                              228738      789301      954398      114777      982883         792	       
ar     1157443       34316      489597       35045     1884310                  428170      187695      633317     5625128       17104          47	       
ca      820152       85579       98717    35955920       46032       62275      597351     7350610     3104985     2307082     7694595        4614	       
co                  376207      724547      320660       16325       31987                 1084072     4073219      551784      884444        4448	       
ct                                           23330                    1313                  478238       16205       90605       90953          30	       
de                   22378      124761       35628       75331                               64909        6744     1221453       18946          10	       
fl                    1772       24138     3291596      172625      751750       84776     2934775      686903      658811      627778          34	       
ga                   16847      224471      924082      845767                  975950      679580      439230     6029590      408176          81	       
hi                                          137457                   47818                  386474       49040      123448       12979           4	       
id                  492679      373051     1279306       15959      339917                  968680     1931336      190134     2944958        3202	       
il                  196355     8298082      113364     6383133                              670931      911267     1694538      411378         173	       
in                  101915     3895850      112147     3470989         824                  472104      455269     3153463      877559         169	       
ia                    3249     9311835                 5791159                              337359     4798256     9900926     1095844         518	       
ks                 1639130     3130848       16080     1917372                   48421      442040     9772885      767910      690649         318	       
ky                  138540      818157                  965481                              873305      875420     2630668      229388          89	       
la      359082        3302      378541       65354      750137      349626      165359      216970      247844      996592       34647          20	       
me                                2772      219054                   28256                  202810       26980      161049      143145          39	       
md                   71805      264853       70361      235967                              428164       72535     1354698      197878         150	       
ma                                           91691                    4945                  292401       10821       64042       46076          60	       
mi                  189690     1141498     1264587     1077869      173049                 1120871      674677      973042     2153153         253	       
mn                  494686     5230346      448864     3905893      539789                  560661     2359806     4579802     2038890         516	       
ms      152104        8345      447467      113700     1241475                  560505      150450      227238     3380012       29920          26	       
mo      179448      198450     2070686       57171     3005683                  285876      448587     2276460     2813196      267528         236	       
mt                  957886      226973      311743       51909       67912                  519381     1764320      192568       58075        3904	       
ne                  254344     6142772      228699     3274782       47499                  430519    11910336     1207883      306901         443	       
nv                    5584                                                                  201416      361161       31756      147563        1009	       
nh                                                                    8162                  132212        9069       50302       58791          41	       
nj                    6067       41800      388236       41312                              731361        7309      100967       25108          99	       
nm                   18463       33712      410243       10321                   52587      360001      946301       86355     1561055        1203	       
ny                   45353      301753      821472      125511       34757                  930793      389124      299135     3174014         317	       
nc                  106404      574922      732185      873492                  225098     1728259      360665     8479703      208553          46	       
nd                 1787230     1686046      765032     3083718      290237                  125917     1194442      192059       70171         541	       
oh                  237963     1975080      156214     2739830        3792                  819486      707929     2163635     1206140         281	       
ok                  474773      206804       28413      207467                  363072      376374     4041954     2146272      162332         110	       
or                  284033       47055     1362692        5301       19702                 2269056      968649      275232      582319        1612	       
pa                   59863      490060      283795      285168        6637                 1774096      734730     1937560     2359544         222	       
ri                                                                                           51100         677       27769        2799           4	       
sc                   16107      201108      101042      245507                  145941      468136      156835     1378313       54874          21	       
sd                  389643     2642047        6895     2658799                              215192     3072973      972695      575395        3071	       
tn                  110200      447997       72772      834024                  308007      738257      672449      852185      152482          63	       
tx      173431      232824     1564770      774001      266641       25171     4038134     2077878    10436385     3872664     2595251        7079	       
ut                   37019       22568       14694        2849                              460474      585564      534360      457045        4648	       
vt                                           26724                   63323                  128984       70752       33708      591740          48	       
va                   50792      201432      169445      272325                   60011      736148      549958     1791673      392655         237	       
wa                  842018      114344     5734292       23796        4440                 1739661      897184      579954     1390018         586	       
wv                    1419       20066       28495       13848         474                  117424      227857      415679       26174         180	       
wi                   65387     1550291      758687     1043600        7622                  667950     2164751      627562     6384465         272	       
wy                   14764       67243       26656                   33211                  259833     1059859      207076       28694        5514;


set	agr(g) /
	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk",
	wol  "Wool, silk-worm cocoons"/;

parameter	agrcompare(*,*)		Comparison of datasets;
agrcompare("total","gtap") = sum(agr,v(agr,"vom"));
agrcompare("total","windc") = sum((r,g),ys0(r,"agr",g));
agrcompare("total","cr") = sum((r,agr),cr_data(r,agr))/1e6;
agrcompare("total","%(gtap-cr)") = 100*(agrcompare("total","gtap")/agrcompare("total","cr")-1);


agrcompare(agr,"gtap") = v(agr,"vom");
agrcompare(agr,"cr") = sum(r,cr_data(r,agr))/1e6;
agrcompare(agr,"%(gtap-cr)") = 100*(agrcompare(agr,"gtap")/agrcompare(agr,"cr")-1);

agrcompare(r,"windc") = ys0(r,"agr","agr");
agrcompare(r,"cr") = sum(agr,cr_data(r,agr))/1e6;
agrcompare(r,"%(windc-cr)")$agrcompare(r,"cr") = 100 * (agrcompare(r,"windc")/agrcompare(r,"cr")-1);
display "Comparison of CR, GTAP and WINDC totals:", agrcompare;

parameter	theta_agr(r,agr)	Agricultural shares by state
		theta_agrtot(r)		State share of aggregate agricultural supply
		theta_r(r,agr)		Share of aggregate agricutural supply by state,
		thetac(agr)
		thetai(agr)
		thetag(agr)
		thetam(agr),
		thetax(agr);

set	rag(r)	Regions with agricultural production;
rag(r) = yes$sum(agr,cr_data(r,agr));

theta_agr(r,agr) = cr_data(r,agr)/sum(r.local, cr_data(r,agr));
theta_agrtot(rag(r)) = sum(agr,cr_data(r,agr))/sum((r.local,agr), cr_data(r,agr));
theta_r(r,agr)$cr_data(r,agr) = cr_data(r,agr)/sum(agr.local, cr_data(r,agr));
thetac(agr) = vafm(agr,"c")/sum(agr.local,vafm(agr,"c"));
thetai(agr) = vafm(agr,"i")/sum(agr.local,vafm(agr,"i"));
thetag(agr) = vafm(agr,"g")/sum(agr.local,vafm(agr,"g"));
thetam(agr) = v(agr,"vim") / (sum(s,vafm(agr,s))+vafm(agr,"c")+vafm(agr,"i")+vafm(agr,"g"));
thetax(agr) = v(agr,"vxm") / sum(agr.local,v(agr,"vxm"));

*	Production of agricultural goods:

ys0(r,agr,agr) = theta_agr(r,agr) * v(agr,"vom");
ys0(r,agr,g)$(not agr(g)) = theta_agrtot(r)*ys0(r,"agr",g);
ty0(r,agr) = ty0(r,"agr");
ys0(r,"agr",g) = 0;
ys0(r,s,"agr") = 0;
ty0(r,"agr") = 0;

*	Intermediate demand for agricultural goods:

id0(r,g,agr) = vafm(g,agr)/v(agr,"vom") * ys0(r,agr,agr);
id0(r,agr,s) = vafm(agr,s)/v(s,"vom") * sum(g,ys0(r,s,g));
id0(r,"agr",s) = 0;
id0(r,g,"agr") = 0;

*	Primary factor demand (need to include land here):

ld0(r,agr) = ld0(r,"agr")*theta_r(r,agr);
kd0(r,agr) = kd0(r,"agr")*theta_r(r,agr);
ld0(r,"agr") = 0;
kd0(r,"agr") = 0;

s0(r,agr) = ys0(r,agr,agr);

*	First pass: assume all agricultural goods move through
*	the national market:

x0(r,agr) = x0(r,"agr")*thetax(agr);
x0(r,"agr") = 0;
xd0(r,agr) = 0;
rx0(r,agr) = 0;
xn0(r,agr) = max(0,s0(r,agr) - x0(r,agr));

xd0(r,"agr")  = 0;
rx0(r,"agr") = 0;
xn0(r,"agr") = 0;

cd0_h(r,agr,h) = cd0_h(r,"agr",h)  * thetac(agr);
i0(r,agr) = i0(r,"agr") * thetai(agr);
g0(r,agr) = i0(r,"agr") * thetag(agr);

cd0_h(r,"agr",h) = 0;
i0(r,"agr") = 0;
g0(r,"agr") = 0;

a0(r,agr) = sum(s,id0(r,agr,s)) + sum(h,cd0_h(r,agr,h)) +  i0(r,agr) + g0(r,agr);
ta(r,agr) = ta(r,"agr");
ta(r,"agr") = 0;
dd0(r,agr) = 0;
dd0(r,"agr") = 0;

m0(r,agr) = a0(r,agr) * thetam(agr);
m0(r,"agr") = 0;
md0(r,m,agr) = md0(r,m,"agr")/a0(r,"agr") * a0(r,agr);
a0(r,"agr") = 0;
md0(r,m,"agr") = 0;

nd0(r,agr) = a0(r,agr)*(1-ta(r,agr)) - m0(r,agr);
nd0(r,"agr") = 0;

ta0(r,agr) = ta0(r,"agr");
ta0(r,"agr") = 0;

tm0(r,agr) = tm0(r,"agr");
tm0(r,"agr") = 0;

ty0(r,agr) = ty0(r,"agr");
ty0(r,"agr") = 0;

initialize(a0,	  a0_c,   "r,s")	display a0;	
initialize(cd0_h, cd0_h_c,"r,g,h")	display cd0_h;	
initialize(id0,   id0_c, "r,s,g")	display id0;	
initialize(ld0,   ld0_c, "r,s")		display ld0;	
initialize(kd0,   kd0_c, "r,s")		display kd0;	
initialize(xn0,   xn0_c, "r,g")		display xn0;	
initialize(xd0,   xd0_c, "r,g")		display xd0;	
initialize(nd0,   nd0_c, "r,g")		display nd0;	
initialize(dd0,   dd0_c, "r,g")		display dd0;	
initialize(nm0,   nm0_c, "r,g,m")	display nm0;	
initialize(ys0,   ys0_c, "r,g,s")	display ys0;	
initialize(x0,    x0_c, "r,s")		display x0;	
initialize(rx0,   rx0_c, "r,s")		display rx0;	
initialize(md0,   md0_c, "r,m,s")	display md0;	
initialize(dm0,   dm0_c, "r,g,m")	display dm0;	
initialize(m0,    m0_c, "r,s")		display m0;	

NM0_C.fx(r,agr,m) = 0;
DM0_C.fx(r,agr,m) = 0;

option qcp=cplex;
solve lsqcalib using qcp minimizing OBJ;

nzlog(params,"firstsolution") = nz(params);


$macro extract(a,b,d) a(&&d) = b.l(&&d)$round(b.l(&&d),6); nz("&&a") = card(a); b.fx(&&d)$(not a(&&d)) = 0;

set		iter	Iterations to impose sparsity	/iter1*iter10/;

parameter	dev	Deviation /1/;

file kput /con:/; kput.lw=0; put kput;

loop(iter$dev,
	extract(a0,    a0_c,   "r,s")
	extract(cd0_h, cd0_h_c,"r,g,h")
	extract(id0,   id0_c, "r,s,g")
	extract(ld0,   ld0_c, "r,s")
	extract(kd0,   kd0_c, "r,s")
	extract(xn0,   xn0_c, "r,g")
	extract(xd0,   xd0_c, "r,g")
	extract(nd0,   nd0_c, "r,g")
	extract(dd0,   dd0_c, "r,g")
	extract(nm0,   nm0_c, "r,g,m")
	extract(ys0,   ys0_c, "r,g,s")
	extract(x0,    x0_c, "r,s")
	extract(rx0,   rx0_c, "r,s")
	extract(md0,   md0_c, "r,m,s")
	extract(dm0,   dm0_c, "r,g,m")
	extract(m0,    m0_c, "r,s")

	nzlog(params,iter) = nz(params);	
	dev = sum(params,abs(nz(params)-nzlog(params,iter-1)));
	nzlog("total",iter) = dev;
	solve lsqcalib using qcp minimizing OBJ;

	put 'Iteration: ',iter.tl,' deviation = ',dev/;
);

option nzlog:0;
display nzlog;

set	s_(s)	Sectors (excluding agr);
s_(s) = s(s)$(not sameas(s,"agr"));

set	gm_(s)	Sectors providing margins (excluding agr);
gm_(s) = gm(s)$(not sameas(s,"agr"));

cd0(r,g) = sum(h,cd0_h(r,g,h));

s0(r,g) = sum(s,ys0(r,s,g)) + yh0(r,g);

execute_unload '%dsout%',s_=s, r, m, gm_=gm, h, trn,
		ys0,ld0,kd0,id0,ty0,
		yh0,cd0,c0_h, cd0_h,c0,i0,g0,bopdef0,hhadj,
		s0,xd0,xn0,x0,rx0,a0,nd0,dd0,m0,ta0,tm0,
		md0,nm0,dm0,
		le0,ke0,tk0,tl0,sav0,hhtrn0,pop;
