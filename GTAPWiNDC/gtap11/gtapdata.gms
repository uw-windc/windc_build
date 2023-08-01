$stitle	Read the GTAPinGAMS Data

$if not set yr $set yr 2017
$if not set ds $set ds gtapingams
$setglobal ds %ds%
$if not set fs $set fs %system.dirsep%
$if not set datadir $set datadir %system.fp%%yr%%fs%

set	f	Factor labels for GTAPinGAMS,
	g(*)	Goods and final demand,
	i(g)	Commodities,
	r(*)	Regions ;

$set fs %system.dirsep%

$gdxin %datadir%%ds%.gdx
$loaddc f g r i

alias (r,r1,r2,rx,rm),(i,j);

set	lu	Land use emissions category/
		ForestLand	Forest land use,
		ForestConv	Forest conversion,
		BurnOrgSoil	Burning on organic soil,
		BurnTropFor	Burning tropical forest
		BurnOthrFor	Burning other forests/;

set	pol	Pollutants /
		CO2         Carbon dioxide
		CH4         Methane
		N2O         Nitrous oxide
		C2F6        Hexafluoroethane (PFC-116)
		C3F8        Octafluoropropane (PFC-218)
		C4F10       Perfluorobutane (PFC-31-10)
		C5F12       Perfluoropentane (PFC-41-12)
		C6F14       Perfluorohexane (PFC-51-14)
		cC4F8       Octafluorocyclobutane (PFC-318)
		CF4         Carbon tetrafluoride (PFC-14)
		HCFC141b    "1,1-Dichloro-1-fluoroethane"
		HCFC142b    "1-Chloro-1,1-difluoroethane"
		HFC125      Pentafluoroethane
		HFC134      "1,1,2,2-Tetrafluoroethane",
		HFC134a     "1,1,1,2-Tetrafluoroethane",
		HFC143      "1,1,2-Trifluoroethane",
		HFC143a     "1,1,1-Trifluoroethane",
		HFC152a     "1,1-Difluoroethane",
		HFC227ea    "1,1,1,2,3,3,3-Heptafluoropropane",
		HFC23       Trifluoromethane
		HFC236fa    "1,1,1,3,3,3-Hexafluoropropane",
		HFC245fa    "1,1,1,3,3-Pentafluoropropane",
		HFC32       Difluoromethane
		HFC365mfc   "1,1,1,3,3-Pentafluorobutane",
		HFC41       Fluoromethane
		HFC4310mee  "1,1,1,2,2,3,4,5,5,5-Decafluoropentane",
		NF3         Nitrogen trifluoride
		SF6         Sulfur hexafluoride
		BC          Black carbon
		CO          Carbon monoxide
		NH3         Ammonia
		NMVOC       Non-methane volatile organic compounds
		NOX         Nitrogen oxides
		OC          Organic carbon
		PM10        Particulate matter 10
		PM2_5       Particulate matter 2.5
		SO2         Sulfur dioxide /;

set	i_f(*)	 /set.i, set.f, "output"/;

parameters

	vfm(f,g,r)	"Endowments - Firms' purchases at market prices",
	vdfm(i,g,r)	"Intermediates - firms' domestic purchases at market prices",
	vifm(i,g,r)	"Intermediates - firms' imports at market prices",
	vxmd(i,r,r)	"Trade - bilateral exports at market prices",
	vst(i,r)	"Trade - Exports for International Transportation, Market Prices",
	vtwr(i,j,r,r)	"Trade - Margins for International Transportation, World Prices",

	rto(g,r)	"Output (or income) subsidy rates",
	rtf(f,g,r)	"Primary factor and commodity rates taxes",
	rtfd(i,g,r)	"Firms' domestic tax rates",
	rtfi(i,g,r)	"Firms' import tax rates",
	rtxs(i,r,r)	"Export subsidy rates",
	rtms(i,r,r)	"Import taxes rates"

	subp(i,r)	"CDE substitution parameter",
	incp(i,r)	"CDE expansion parameter",

     	esubva(g)	"CES elasticity of substitution for primary factors",
     	esubdm(i)	"Armington elasticity of substitution D versus M",
	etaf(f)		"CET elasticity of transformation for sluggish factors",

	eta(i,r)	"Income elasticity of demand",
	aues(i,j,r)	"Allen-Uzawa elasticities of substitution",

	eco2d(i,g,r)	"CO2 emissions from domestic product (Mt)",
	eco2i(i,g,r)	"CO2 Emissions from imported product (Mt)",

	evd(i,g,r)	"Domestic energy use (mtoe)"
	evi(i,g,r)	"Imported energy use (mtoe)"
	evt(i,r,r)	"Volume of energy trade (mtoe)"

	nco2emit(pol,i_f,g,r)	'Industrial and household non-CO2 emissions, mmt',
	nco2process(pol,i,j,r)	'IO-based process emissions, mmt',
	landuse(pol,lu,r)	'Land-use emissions, mmt',

	pop(r)		"Regional population";

set	metadata(*)	"Information about GTAP version etc";

$loaddc vfm vdfm vifm vxmd vst vtwr rto rtf rtfd rtfi rtxs rtms 
$loaddc subp incp esubva esubdm etaf eta aues eco2d eco2i nco2emit nco2process landuse pop metadata
$loaddc evd evi evt

parameter
	thetac(i,r)	Value share of commodity i in final demand,
	epsilon(i,r)	Own-price elasticity of demand;

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

epsilon(i,r) = aues(i,i,r)*thetac(i,r);

parameter	pvxmd(i,r,r)	Import price (power of benchmark tariff)
		pvtwr(i,r,r)	Import price for transport services;

pvxmd(i,rx,rm) = (1+rtms(i,rx,rm)) * (1-rtxs(i,rx,rm));
pvtwr(i,rx,rm) = 1+rtms(i,rx,rm);

parameter	vim(i,r)	Imports at basic prices,
		vom(g,r)	Gross output,
		evom(f,r)	Factor endowments,
		vb(*)		Current account balance;

vom(g,r) = (sum(i,vdfm(i,g,r)*(1+rtfd(i,g,r))+vifm(i,g,r)*(1+rtfi(i,g,r)))
		+  sum(f,vfm(f,g,r)*(1+rtf(f,g,r))))/(1-rto(g,r));
vim(i,r) = sum(rx,vxmd(i,rx,r)*pvxmd(i,rx,r)+sum(j,vtwr(j,i,rx,r))*pvtwr(i,rx,r));

evom(f,r) = sum(j,vfm(f,j,r));

vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, evom(f,r))
	- sum(g,  vom(g,r)*rto(g,r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + vifm(i,g,r)*rtfi(i,g,r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
	- sum((i,rx), rtms(i,rx,r) *  (vxmd(i,rx,r) * (1-rtxs(i,rx,r)) + sum(j,vtwr(j,i,rx,r))))
	+ sum((i,rm), rtxs(i,r,rm) * vxmd(i,r,rm));
vb("chksum") = sum(r, vb(r));
display vb;

set	chkdim /
	tmargin		Trade margin supply and demand,
	dmarket		Domestic market, 
	mmarket		Import market, 
	profit		Zero profit/;

parameter	bmkchk(g,*,chkdim)	Cross check on market and zero profit conditions;
bmkchk(i,".","tmargin") = sum(r,vst(i,r)) - sum((j,rx,rm),vtwr(i,j,rx,rm));
bmkchk(i,r,"dmarket") = vom(i,r) - ( sum(rx,vxmd(i,r,rx)) + vst(i,r) + sum(g,vdfm(i,g,r)) );
bmkchk(i,r,"mmarket") = vim(i,r) - sum(g, vifm(i,g,r));
bmkchk(g,r,"profit")  = vom(g,r)*(1-rto(g,r)) 
			- sum(i,vdfm(i,g,r)*(1+rtfd(i,g,r))+vifm(i,g,r)*(1+rtfi(i,g,r)))
			- sum(f,vfm(f,g,r)*(1+rtf(f,g,r)));
option bmkchk:3:2:1;
display bmkchk;

bmkchk(g,r,chkdim) = round(bmkchk(g,r,chkdim),3);
bmkchk(i,r,"tmargin") = round(bmkchk(i,r,"tmargin"),3);
display bmkchk;

*	Parameters for the LES demand system:

parameter
	betales(r)	Non-subsistence expenditure share,
	sigmales(r)	Elasticity of substitution in the LES model;

betales(r) =	sum(i, thetac(i,r)*epsilon(i,r)) /
		sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1));

*	Non-negative subsistence demand?

$if %nnsd%==yes betales(r) = max(betales(r), smin(i,1/eta(i,r)));

sigmales(r) = (1/betales(r)) *	sum(i, thetac(i,r)*epsilon(i,r)) /
				sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1)); 

*	Benchmark tax rates:

parameters
	rto0(g,r)	"Output (or income) subsidy rates",
	rtf0(f,g,r)	"Primary factor and commodity rates taxes",
	rtfd0(i,g,r)	"Firms' domestic tax rates",
	rtfi0(i,g,r)	"Firms' import tax rates",
	rtxs0(i,r,r)	"Export subsidy rates",
	rtms0(i,r,r)	"Import taxes rates";

alias (r,rm);


rto0(g,r) = rto(g,r);
rtf0(f,g,r) = rtf(f,g,r);
rtfd0(i,g,r) = rtfd(i,g,r);
rtfi0(i,g,r) = rtfi(i,g,r);
rtxs0(i,r,rm) = rtxs(i,r,rm);
rtms0(i,r,rm) = rtms(i,r,rm);
