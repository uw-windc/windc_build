$title	GTAPinGAMS Model in Canonical Form -- Produce a Stub Dataset

*.$set fs %system.dirsep%

$if not set dsout $set dsout 2017/gtapwindc/43_stub


*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------


$include %system.fp%gtapingams

$if not set ds $set ds g20_43


$include %gtapingams%gtapdata

alias (s,r);


sets	s_		Subregions /rest/
	h(*)		Households /rest/

*	At this point we have a singleton.  After gravity estimation we
*	can have national, census or state-level markets:

set		mkts		Markets /pooled/;

singleton set	mkt(mkts)	Markets /pooled/;

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

parameters

	vom_(g,r,s_)	Total supply at market prices,
	vafm_(i,g,r,s_)	Intermediate demand at market prices,
	vfm_(f,g,r,s_)	Factor demand at market prices,

*	Parameters which are added to create the subnational model:

	s0_(i,r,s_)		Aggregate commodity supply,

	ns0_(i,mkts,r,s_)	National market supply
	xs0_(i,r,s_)		Export supply

	vxm_(i,r)		Aggregate exports at market prices
	vnm_(i,mkts,r)		Aggregate national market supply,

	a0_(i,r,s_)		Absorption,
	yl0_(i,r,s_)		Local domestic absorption,
	yd0_(i,r,s_)		Local absorption
	bd0_(i,r,s_,s_)		Bilateral trade
	nd0_(i,mkts,r,s_)	National market domestic absorption,
	md0_(i,r,s_)		Import absorption,

	c0_(r,s_,h)	    Total household consumption,
	cd0_(i,r,s_,h)	Household consumption at market prices,

	evomh_(f,r,s_,h) Household primary factor endowment,

	evom_(f,r,s_)	Primary factor supply,
	rtd_(i,r,s_)	Tax rate on domestic demand,
	rtd0_(i,r,s_)	Benchmark tax rate on domestic demand,

	rtm_(i,r,s_)	Tax rate on import demand,
	rtm0_(i,r,s_)	Benchmark tax rate on import demand,

	esube_(g)	Energy demand elasticity,
	etrndn_(i)	Elasticity of transformation -- local goods supply,

	hhtrn0(r,s_,h,trn)	Household transfer
	sav0(r,s_,h)		Household saving;


esube_(i) = 0.5;
esube_("g") = 0;
esube_("i") = 0;
etrndn_(i) = 4;


vom_(g,r,s_)$(not sameas(g,"c")) = vom(g,r);
vfm_(f,g,r,s_) = vfm(f,g,r);

vafm_(i,g,r,s_) = vdfm(i,g,r)*(1+rtfd(i,g,r)) + vifm(i,g,r)*(1+rtfi(i,g,r));
cd0_(i,r,s_,h) = vafm_(i,"c",r,s_);
vafm_(i,"c",r,s_) = 0;
c0_(r,s_,h) = vom("c",r);

a0_(i,r,s_) = sum(g,vafm_(i,g,r,s_)) + sum(h,cd0_(i,r,s_,h));

*	Ignore the local market for the time being:

yl0_(i,r,s_) = 0;
md0_(i,r,s_) = sum(g,vifm(i,g,r));
nd0_(i,mkt,r,s_) = sum(g,vdfm(i,g,r));
yd0_(i,r,s_) = 0;
bd0_(i,r,s_,s_) = 0;

xs0_(i,r,s_) = sum(s,vxmd(i,r,s)) + vst(i,r);
ns0_(i,mkt,r,s_) = vom(i,r) - xs0_(i,r,s_);
vxm_(i,r) = sum(s_,xs0_(i,r,s_));
vnm_(i,mkt,r) = sum(s_,ns0_(i,mkt,r,s_));


rtd_(i,r,s_)$nd0_(i,mkt,r,s_) = sum(g,rtfd(i,g,r)*vdfm(i,g,r))/nd0_(i,mkt,r,s_);
rtm_(i,r,s_)$md0_(i,r,s_) = sum(g,rtfi(i,g,r)*vifm(i,g,r))/md0_(i,r,s_);

rtd0_(i,r,s_) = rtd_(i,r,s_);
rtm0_(i,r,s_) = rtm_(i,r,s_);

evom_(f,r,s_) = evom(f,r);
evomh_(f,r,s_,h) = evom(f,r);

alias (u,*);
vb(u)$(not r(u)) = 0;

sav0(r,s_,h)	= vom("i",r) - vb(r);
hhtrn0(r,s_,h,"hpawval") = c0_(r,s_,h) + sav0(r,s_,h) - sum(f,evomh_(f,r,s_,h));

set g_(*) /g	Public expenditure,
	   i	Investment,
	   agr	Agricuture (composite) /,

    i_(*) / agr	Agricuture (composite) /;

g_(i) = i(i);
i_(i) = i(i);


set	sf(f)	Specific factor,
	mf(f)	Mobile factors;
sf(f) = no;
set	specific	Factors treated as specific /lnd, res/;
sf(f)$sameas(f,"lnd") = yes;
sf(f)$sameas(f,"res") = yes;
mf(f) = not sf(f);

parameter	vtw(j);
vtw(j) = sum(r,vst(j,r));

parameter	esubm;
esubm(i) = 2 * esubdm(i);

execute_unload '%dsout%',
	r,s_=s,g_=g,i_=i,g_=a,h,f,sf,mf,trn,
	vom_=vom, vafm_=vafm, vfm_=vfm, 
	a0_=a0, yl0_=yl0, md0_=md0, yd0_=yd0, bd0_=bd0, nd0_=nd0, c0_=c0, cd0_=cd0, ns0_=ns0, xs0_=xs0,
	evom_=evom, evomh_=evomh, 
	rtd0_=rtd0, rtm0_=rtm0, esube_=esube,
	etrndn_=etrndn, hhtrn0, sav0,
	rto, rtf, rtf=rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etaf=etrae, esubdm, esubm;

