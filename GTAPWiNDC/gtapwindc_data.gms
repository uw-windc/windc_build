$title	GAMS Code to Read a GTAPWINDC Dataset

*.$set fs %system.dirsep% 

$if not set ds                 $set ds 32
$if not set gtapwindc_datafile $set gtapwindc_datafile datasets/gtapwindc/%ds%.gdx

sets	
	r(*)		Regions (countries)
	s(*)		Subregions
	g(*)		Commodities (plus I and G)
	i(g)		Commodities
	h(*)		Households
	f(*)		Factors of production
	sf(f)		Specific factors
	mf(f)		Mobile factors;

$gdxin "%gtapwindc_datafile%"

$load r g i f 

set	trn	Transfer types /
		hucval   unemployment compensation
		hwcval   workers compensation
		hssval   social security
		hssival  supplemental security
		hpawval  public assistance or welfare
		hvetval  veterans benefits
		hsurval  survivors income
		hdisval  disability
		hedval   educational assistance
		hcspval  child support
		hfinval  financial assistance /;


*	These sets are defined prior to reading the dataset in the disaggregation routine:

$if not defined s $load s
$if not defined h $load h

$loaddc sf mf

alias (i,j), (r,rr);

parameters
	vom(g,r,s)	Total supply at market prices
	rto(g,r)	Output (or income) subsidy rates
	vafm(i,g,r,s)	Intermediate demand at market prices,
	vfm(f,g,r,s)	Factor demand at market prices,
	rtf0(f,g,r)	Benchmark primary factor tax rate
	rtf(f,g,r)	Primary factor tax rate

	xn0(i,r,s)	Commodity supply to national market
	xd0(i,r,s)	Local domestic absorption
	a0(i,r,s)	Absorption
	rtd(i,r,s)	Tax rate on domestic demand
	rtd0(i,r,s)	Benchmark tax rate on domestic demand
	md0(i,r,s)	Import absorption
	rtm(i,r,s)	Tax rate on import demand
	rtm0(i,r,s)	Benchmark tax rate on import demand
	nd0(i,r,s)	National market domestic absorption
	c0(r,s,h)	Total household consumption
	cd0(i,r,s,h)	Household consumption at market prices
	evom(f,r,s)	Primary factor supply
	evomh(f,r,s,h)	Household primary factor endowment
	hhtrn0(r,s,h,trn)	Household transfers
	sav0(r,s,h)		Household saving
	vim(i,r)		Aggregate imports at market prices

	vxmd(i,r,rr)	Trade - bilateral exports at market prices,
	pvxmd(i,rr,r)	Import price (power of benchmark tariff)
	pvtwr(i,rr,r)	Import price for transport services (power of tariff)
	rtxs(i,rr,r)	Export subsidy rates
	rtms(i,rr,r)	Import taxes rates
	vtwr(j,i,rr,r)	Trade margins on international transport
	vtw(j)		Aggregate international transportation services,
	vst(j,r)	Trade - exports for international transportation
	vb(r)		Current account balance

	esube(g)	Energy demand elasticity
	esubva(g)	Elasticity of substitution between factors,
	etrndn(i)	Elasticity of transformation -- local goods supply
	etrae(f)	Elasticity of transformation -- sluggish factors,
	esubdm(i)	Elasticity of substitution (M versus D),
	esubm(i)	Intra-import elasticity of substitution;

$loaddc	vom
$loaddc	rto
$loaddc	vafm
$loaddc	vfm
$loaddc	rtf0
$loaddc	rtf
$loaddc	xn0
$loaddc	xd0
$loaddc	a0
$loaddc	rtd0
$loaddc	md0
$loaddc	rtm0
$loaddc	nd0
$loaddc	c0
$loaddc	cd0
$loaddc	evom
$loaddc	evomh
$loaddc	hhtrn0
$loaddc	sav0
$loaddc	vim
$loaddc	vxmd
$loaddc	pvxmd
$loaddc	pvtwr
$loaddc	rtxs
$loaddc	rtms
$loaddc	vtwr
$loaddc	vtw
$loaddc	vst
$loaddc	vb
$loaddc esube
$loaddc	esubva
$loaddc	etrndn
$loaddc	etrae
$loaddc	esubdm
$loaddc	esubm


rtd(i,r,s) = rtd0(i,r,s);
rtm(i,r,s) = rtm0(i,r,s);

sets	y_(g,r,s)	Flag: Production
	x_(i,r,s)	Flag: Disposition
	z_(i,r,s)	Flag: Armington demand
	c_(r,s,h)	Flag: Consumption
	ft_(f,r,s)	Flag: Specific factor transformation

	m_(i,r)		Flag: Import
	yt_(j)		Flag: Transport

	py_(g,r,s)	Flag: Output price
	pz_(i,r,s)	Flag: Armington composite price
	pd_(i,r,s)	Flag: Local goods price
	p_(i,r)		Flag: National goods price
	pc_(r,s,h)	Flag: Consumption price 
	pf_(f,r,s)	Flag: Primary factors rent
	ps_(f,g,r,s)	Flag: Sector-specific primary factors
	pm_(i,r)	Flag: Import price
	pt_(j)		Flag: Transportation services

	rh_(r,s,h)	Flag: representative household;

y_(g,r,s) = vom(g,r,s);
x_(i,r,s) = vom(i,r,s);
z_(i,r,s) = a0(i,r,s);
c_(r,s,h) = c0(r,s,h);
ft_(sf,r,s) = evom(sf,r,s);
m_(i,r) = vim(i,r);
yt_(j) = vtw(j);
py_(g,r,s) = vom(g,r,s);
pz_(i,r,s) = a0(i,r,s);
pd_(i,r,s) = xd0(i,r,s);
p_(i,r) = sum(s,xn0(i,r,s));
pc_(r,s,h) = c0(r,s,h);
pf_(f,r,s) = evom(f,r,s);
ps_(sf,g,r,s) = vfm(sf,g,r,s);
pm_(i,r) = vim(i,r);
pt_(j) = vtw(j);
rh_(r,s,h) = c0(r,s,h);

option x_:0:0:1;
display x_;
option vom:3:0:1;
display vom;


parameter	xchk;
xchk(i,r,s,"xn0") = xn0(i,r,s);
xchk(i,r,s,"xd0") = xd0(i,r,s);
xchk(i,r,s,"vom") = vom(i,r,s);
xchk(i,r,s,"chk") = vom(i,r,s) - xd0(i,r,s) - xn0(i,r,s);
option xchk:3:3:1;
display xchk;

parameter	mktchk;
mktchk(p_(i,r),"xn0") = sum(s,xn0(i,r,s));
mktchk(p_(i,r),"nd0") = sum(s,nd0(i,r,s));
mktchk(p_(i,r),"vxmd") =sum(rr,vxmd(i,r,rr));
mktchk(p_(i,r),"vst") = vst(i,r);
mktchk(p_(i,r),"chk") = sum(s,xn0(i,r,s)) - (sum(s,nd0(i,r,s)) + sum(rr,vxmd(i,r,rr)) + vst(i,r));
display "Cross check all indices:", mktchk;

mktchk(p_(i,r),"xn0") = sum(x_(i,r,s),xn0(i,r,s));
mktchk(p_(i,r),"nd0") = sum(z_(i,r,s),nd0(i,r,s));
mktchk(p_(i,r),"vxmd") =sum(m_(i,rr),vxmd(i,r,rr));
mktchk(p_(i,r),"vst") = vst(i,r);
mktchk(p_(i,r),"chk") = sum(x_(i,r,s),xn0(i,r,s)) - ( sum(z_(i,r,s),nd0(i,r,s)) + sum(m_(i,rr),vxmd(i,r,rr)) + vst(i,r)$yt_(i) );
display "Cross check on active domain:", mktchk;

option xn0:3:0:1;
display xn0;



*	Adjust elasticities for other goods and services (these are somehow set
*	to a very high level in the dataset):

esubdm("ogs") = 5;
esubm("ogs") = 8;

set rnum(r)	Numeraire region for denominating current account transfers;
parameter	gdp(r)	Gross domestic product;
gdp(r)$(not sameas(r,"usa")) = sum(s, sum(h,c0(r,s,h)) + vom("g",r,s) + vom("i",r,s));

*	Numeraire region:
rnum(r) = yes$(gdp(r) = smax(r.local,gdp(r)));

parameter	vbchk	Cross check on VB;
vbchk = sum(r,vb(r));
display vbchk;