$title	GTAPinGAMS Model in Canonical Form -- Produce a Stub Dataset

$set fs %system.dirsep%

$include gtap_data.gms

sets	s_		  Subregions /rest/
	    h(*)		Households /rest/

parameters

	vom_(g,r,s_)	Total supply at market prices,
	vafm_(i,g,r,s_)	Intermediate demand at market prices,
	vfm_(f,g,r,s_)	Factor demand at market prices,

*	Parameters which are added to create the subnational model:

	xn0_(i,r,s_)	Commodity supply to national market,
	xd0_(i,r,s_)	Local domestic absorption,
	s0_(i,r,s_)	  Aggregate commodity supply,

	a0_(i,r,s_)	  Absorption,
	md0_(i,r,s_)	Import absorption,
	nd0_(i,r,s_)	National market domestic absorption,

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

	htax0_(r,s_,h)	Household direct tax,
	hsav0_(r,s_,h)	Household saving;


esube_(i) = 0.5;
esube_("g") = 0;
esube_("i") = 0;
etrndn_(i) = 4;


vom_(g,r,s_)$(not sameas(g,"c")) = vom(g,r);
vfm_(f,g,r,s_) = vfm(f,g,r);

s0_(i,r,s_) = vom(i,r);


vafm_(i,g,r,s_) = vdfm(i,g,r)*(1+rtfd0(i,g,r)) + vifm(i,g,r)*(1+rtfi0(i,g,r));
cd0_(i,r,s_,h) = vafm_(i,"c",r,s_);
vafm_(i,"c",r,s_) = 0;
c0_(r,s_,h) = vom("c",r);

a0_(i,r,s_) = sum(g,vafm_(i,g,r,s_)) + sum(h,cd0_(i,r,s_,h));

*	Ignore the local market for the time being:

xd0_(i,r,s_) = 0;
md0_(i,r,s_) = sum(g,vifm(i,g,r));
nd0_(i,r,s_) = sum(g,vdfm(i,g,r));
xn0_(i,r,s_) = vom(i,r);

rtd_(i,r,s_)$nd0_(i,r,s_) = sum(g,rtfd(i,g,r)*vdfm(i,g,r))/nd0_(i,r,s_);
rtm_(i,r,s_)$md0_(i,r,s_) = sum(g,rtfi(i,g,r)*vifm(i,g,r))/md0_(i,r,s_);

rtd0_(i,r,s_) = rtd_(i,r,s_);
rtm0_(i,r,s_) = rtm_(i,r,s_);

evom_(f,r,s_) = evom(f,r);
evomh_(f,r,s_,h) = evom(f,r);

hsav0_(r,s_,h)	= vom("i",r) - vb(r);
htax0_(r,s_,h)	= sum(f,evomh_(f,r,s_,h)) - c0_(r,s_,h) - hsav0_(r,s_,h);

set g_(*);
g_(i) = yes;
g_("g") = yes;
g_("i") = yes;

display h;

execute_unload 'datasets%fs%gtapwindc%fs%%ds%_stub.gdx',
	r,s_=s,g_=g,i,g_=a,h,f,sf,mf,
	vom_=vom, vafm_=vafm, vfm_=vfm, xn0_=xn0, xd0_=xd0, s0_=s0, a0_=a0,
	md0_=md0, nd0_=nd0, c0_=c0, cd0_=cd0, evom_=evom, evomh_=evomh, 
	rtd0_=rtd0, rtm0_=rtm0, esube_=esube,
	etrndn_=etrndn, htax0_=htax0, hsav0_=hsav0,

	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;

