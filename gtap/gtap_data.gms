$title	GAMS Code to Read a GTAP Dataset

$set fs %system.dirsep% 

$if not set ds		$set ds windc7
$if not set yr		$set yr     14
$if not set gtapv	$set gtapv 10a

$if %yr%==2014 $set yr 14

*	Data directory is gamsdata\gtap<ver>\20<yr>\%ds%

$if not set datadir $set datadir "%system.fp%data_sources%fs%gtap%gtapv%%fs%20%yr%%fs%"

$setglobal ds      %ds%
$setglobal yr      %yr%
$setglobal gtapv   %gtapv%
$setglobal datadir %datadir%

set	g(*)	Goods plus C - SD - DD -- G and I;
$if exist     %ds%.gdx $gdxin "%ds%.gdx"
$if not exist %ds%.gdx $gdxin "%datadir%%ds%.gdx"
$load g

set	i(g)	Goods
	f(*)	Factors;
$load f i 
$if not defined r	set r(*)	Regions;
$if not defined r	$load r

set	cd(g)	Components of consumer demand /c,dd/,
	lesd(g)	Components of LES demand  /sd,dd/;

singleton set	rnum(r)	Numeraire region;

set	sf(f)	Sluggish primary factors (sector-specific),
	mf(f)	Mobile primary factors;

alias (r,rr,s), (i,j);

set	metadata(*,*,*)	Dataset information;
$if not set nometadata $load metadata

set		vtcomp /ad	"Anti-dumping duty",
			mfa	"Export tax equivalent of MFA quota premia",
			pu	"Export tax equivalent of price undertakings",
			ver	"Export tax equivalent of voluntary export restraints",
			xt	"Ordinary export tax"
			tarif	"Ordinary import duty",
			adv	"Import tariff revenue - levied on an ad-valorem basis",
			spe	"Import tariff revenue - levied on a specific basis" /

parameters
	vfm(f,g,r)		Endowments - Firms' purchases at market prices,
	vdfm(i,g,r)		Intermediates - firms' domestic purchases at market prices,
	vifm(i,g,r)		Intermediates - firms' imports at market prices,
	vxmd(i,r,s)		Trade - bilateral exports at market prices,
	vst(i,r)		Trade - exports for international transportation
	vtrev(vtcomp,i,r,s)	Components of trade taxes
	vtwr(i,j,r,s)		Trade - Margins for international transportation at world prices
	;

$load vfm vdfm vifm vxmd vst vtwr vtrev

*	Recalibrate trade margin supply to match trade margin demand:

vst(i,r) = vst(i,r)/sum(s,vst(i,s)) * sum((j,r.local,s),vtwr(i,j,r,s));


parameter
	pop(r)		Population,
	evt(i,r,r)	Volume of energy trade (mtoe),
	evd(i,g,r)	Domestic energy use (mtoe),
	evi(i,g,r)	Imported energy use (mtoe),
	eco2d(i,g,r)	CO2 emissions in domestic fuels - Mt CO2,
	eco2i(i,g,r)	CO2 emissions in foreign fuels - Mt CO2;

$loaddc pop evd evi evt eco2d eco2i

parameter
	rto(g,r)	Output (or income) subsidy rates
	rtf(f,g,r)	Primary factor and commodity rates taxes 
	rtfd(i,g,r)	Firms domestic tax rates
	rtfi(i,g,r)	Firms' import tax rates
	rtxs(i,r,s)	Export subsidy rates
	rtms(i,r,s)	Import taxes rates;

$load rto rtf rtfd rtfi rtxs rtms 

*	Apply common rates on LES demand:

rto(lesd,r) = rto("c",r);
rtfd(i,lesd,r) = rtfd(i,"c",r);
rtfi(i,lesd,r) = rtfi(i,"c",r);

parameter
	esubt(i)	Elasticity of top-level input substitution',
	esubd(i)	Elasticity of substitution (M versus D),
	esubva(g)	Elasticity of substitution between factors,
	esubm(i)	Intra-import elasticity of substitution,
	etrae(f)	Elasticity of transformation;

$load esubt esubd esubva esubm etrae 

*	Avoid numerical problems with high elasticities:

esubd(i) = min(8,esubd(i));

parameter
	incpar(i,r)	Expansion parameter in the CDE expenditure function,
	subpar(i,r)	Substitution parameter in CDE expenditure function,
	eta(i,r)	Income elasticity of demand,
	epsilon(i,r)	Own-price elasticity of demand,
	thetac(i,r)	Value share of commodity i in final demand,
	aues(i,j,r)	Allen-Uzawa elasticities of substitution;

$loaddc incpar subpar eta aues

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

epsilon(i,r) = aues(i,i,r)*thetac(i,r);

*	Declare some intermediate arrays which are required to 
*	evaluate tax rates:

parameter	vdm(g,r)	Aggregate demand for domestic output,
		vom(g,r)	Total supply at market prices;

*	Omit LES demand until it is required:

vdfm(i,lesd,r) = 0;
vifm(i,lesd,r) = 0;

vom("c",r) = sum(i, vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r)))/(1-rto("c",r));
vom("g",r) = sum(i, vdfm(i,"g",r)*(1+rtfd(i,"g",r)) + vifm(i,"g",r)*(1+rtfi(i,"g",r)))/(1-rto("g",r));
vom("i",r) = sum(i, vdfm(i,"i",r)*(1+rtfd(i,"i",r)) + vifm(i,"i",r)*(1+rtfi(i,"i",r)))/(1-rto("i",r));

vdm(i,r) = sum(g,vdfm(i,g,r));
vom(i,r) = vdm(i,r) + sum(s, vxmd(i,r,s)) + vst(i,r);

parameter
	rtf0(f,g,r)	Primary factor and commodity rates taxes 
	rtfd0(i,g,r)	Firms domestic tax rates
	rtfi0(i,g,r)	Firms' import tax rates
	rtxs0(i,r,s)	Export subsidy rates
	rtms0(i,r,s)	Import taxes rates;

rtf0(f,g,r) = rtf(f,g,r);
rtfd0(i,g,r) = rtfd(i,g,r);
rtfi0(i,g,r) = rtfi(i,g,r);

rtf0(f,lesd,r) = rtf(f,"c",r);
rtfd0(i,lesd,r) = rtfd(i,"c",r);
rtfi0(i,lesd,r) = rtfi(i,"c",r);

rtxs0(i,r,s) = rtxs(i,r,s);
rtms0(i,r,s) = rtms(i,r,s);

parameter	pvxmd(i,s,r)	Import price (power of benchmark tariff)
		pvtwr(i,s,r)	Import price for transport services;

pvxmd(i,s,r) = (1+rtms0(i,s,r)) * (1-rtxs0(i,s,r));
pvtwr(i,s,r) = 1+rtms0(i,s,r);

parameter	
	vtw(j)		Aggregate international transportation services,
	vpm(r)		Aggregate private demand,
	vgm(r)		Aggregate public demand,
	vim(i,r)	Aggregate imports,
	evom(f,r)	Aggregate factor endowment at market prices,
	vb(r)		Current account balance
	vbchksum	Check of aggregate income balance;

vtw(j) = sum(r, vst(j,r));
vom("c",r) = sum(i, vdfm(i,"c",r)*(1+rtfd0(i,"c",r)) + vifm(i,"c",r)*(1+rtfi0(i,"c",r)))/(1-rto("c",r));
vom("g",r) = sum(i, vdfm(i,"g",r)*(1+rtfd0(i,"g",r)) + vifm(i,"g",r)*(1+rtfi0(i,"g",r)))/(1-rto("g",r));
vom("i",r) = sum(i, vdfm(i,"i",r)*(1+rtfd0(i,"i",r)) + vifm(i,"i",r)*(1+rtfi0(i,"i",r)))/(1-rto("i",r));

vdm("c",r) = vom("c",r);
vdm("g",r) = vom("g",r);
vdm("i",r) = vom("i",r);
vim(i,r) =  sum(g, vifm(i,g,r));
evom(f,r) = sum(g, vfm(f,g,r));
vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, evom(f,r))
	- sum(g,  vom(g,r)*rto(g,r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + vifm(i,g,r)*rtfi(i,g,r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
	- sum((i,s), rtms(i,s,r) *  (vxmd(i,s,r) * (1-rtxs(i,s,r)) + sum(j,vtwr(j,i,s,r))))
	+ sum((i,s), rtxs(i,r,s) * vxmd(i,r,s));
vbchksum = sum(r, vb(r));
display vbchksum;

*	Determine which factors are sector-specific 

mf(f) = yes$(1/etrae(f)=0);
sf(f) = yes$(1/etrae(f)>0);
display etrae, mf,sf;

parameter       mprofit Zero profit for m,
                yprofit Zero profit for y;

mprofit(i,r) = round(vim(i,r) - sum(s, pvxmd(i,s,r)*vxmd(i,s,r)+sum(j, vtwr(j,i,s,r))*pvtwr(i,s,r)),3);
display mprofit;

yprofit(g,r) = 0;
yprofit(g,r)$vom(g,r) = round(vom(g,r)*(1-rto(g,r))
	- sum(i, vdfm(i,g,r)*(1+rtfd0(i,g,r)) + vifm(i,g,r)*(1+rtfi0(i,g,r))) 
        - sum(f, vfm(f,g,r)*(1+rtf0(f,g,r))),3);
display yprofit;

*	Define a numeraire region for denominating international
*	transfers:

rnum(r) = yes$(vom("c",r)=smax(s,vom("c",s)));
display rnum;

*	Export supply elasticity:

parameter       etadx(g)        Export elasticity of transformation D vs E,
		esubdm(i)	Elasticity of substitution D vs M,
                vxm(g,r)        Export market supply;

$if not set thetadx $set thetadx 0.5
etadx(i)$(1-%thetadx%) = esubd(i)/(1-%thetadx%);
etadx(i)$(not (1-%thetadx%)) = +inf;
esubdm(i) = esubd(i)/%thetadx%;
vxm(i,s) = (vst(i,s) + sum(r,vxmd(i,s,r)))$(1/etadx(i));

*	Elasticity of substitution in final demand:

parameter	esub(g,r)	Top-level elasticity;
esub(i,r)   = esubt(i);
esub("c",r) = 1;


parameter	gtapelasticities	Database elasticities;
gtapelasticities(i,"esubt") = esubt(i);
gtapelasticities(i,"etadx") = etadx(i);
gtapelasticities(i,"esubm") = esubm(i);
gtapelasticities(i,"esubva") = esubva(i);
gtapelasticities(i,"esubd") = esubd(i);
display gtapelasticities;

*	Small open economy framework:

parameter
	rowpfx		Rest of world endowment of foreign exchange,
	vem(g,r)	Bilateral exports outside model,
	rtxs_row(i,r)	Subsidies on exports to ROW,
	pem0(i,r)	Reference price of exports;

set	rm(r)		Regions include in the model
	rx(r)		Regions excluded from the model;

*	Default model is GMR, not SOE:

rm(r) = yes;
rx(r) = (not rm(r)); 
rowpfx = sum(rx(r), vom("c",r)); 
vem(i,rm(r)) = sum(rx(s),vxmd(i,r,s)); 
rtxs_row(i,r) = (sum(rx(s),vxmd(i,r,s)*rtxs(i,r,s))/vem(i,r))$vem(i,r);
pem0(i,r) = (1-rtxs_row(i,r));

*	Parameters for the CDE demand model:

parameter
	betales(r)	Non-subsistence expenditure share,
	sigmales(r)	Elasticity of substitution in the LES model,
	vcm(i,r)	CDE demand vector;

set	cde(r)		Regions with CDE demand,
	les(r)		Regions with LES demand;

betales(r)$sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1))
	= sum(i, thetac(i,r)*epsilon(i,r))/sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1));

$if %nnsd%==yes betales(r) = max(betales(r), smin(i,1/eta(i,r)));

sigmales(r)$sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1))
	= (1/betales(r)) * sum(i, thetac(i,r)*epsilon(i,r))/sum(i,eta(i,r)*thetac(i,r)*(eta(i,r)*thetac(i,r)-1)); 

display sigmales;

vcm(i,r) = 0;
cde(r) = no;
les(r) = no;
