$title	Aggregate a GTAP-WINDC Datas

$if not set target $set target minimal

*	Read the data:

$if not set ds $set ds 43

$include ..\gtapwindc\gtapwindc_data

*	Calling program points to the target mapping:

$include "%system.fp%defines/%target%"

parameters
	vom_(g_,r_,s)		Total supply at market prices
	vafm_(i_,g_,r_,s)	Intermediate demand at market prices,
	vfm_(f,g_,r_,s)		Factor demand at market prices,
	xd0_(i_,r_,s)		Local domestic absorption
	a0_(i_,r_,s)		Absorption
	nd0_(i_,r_,s)		National market domestic absorption
	md0_(i_,r_,s)		Import absorption
	c0_(r_,s,h)		Total household consumption
	cd0_(i_,r_,s,h)		Household consumption at market prices
	evom_(f,r_,s)		Primary factor supply
	ns0_(i_,r_,s)		National market supply
	xs0_(i_,r_,s)		Export market supply
	evomh_(f,r_,s,h)	Household primary factor endowment
	hhtrn0_(r_,s,h,trn)	Household transfers
	sav0_(r_,s,h)		Household saving
	vim_(i_,r_)		Aggregate imports at market prices
	vxmd_(i_,r_,rr_)	Trade - bilateral exports at market prices,
	vtwr_(j_,i_,rr_,r_)	Trade margins on international transport
	vtw_(j_)		Aggregate international transportation services,
	vst_(j_,r_)		Trade - exports for international transportation
	vb_(r_)			Current account balance;

vom_(g_,r_,s)		= sum((mapg(g,g_),mapr(r,r_)),vom(g,r,s));
vafm_(i_,g_,r_,s)	= sum((mapi(i,i_),mapg(g,g_),mapr(r,r_)),vafm(i,g,r,s));
vfm_(f,g_,r_,s)		= sum((mapg(g,g_),mapr(r,r_)),vfm(f,g,r,s));
a0_(i_,r_,s)		= sum((mapi(i,i_),mapr(r,r_)),a0(i,r,s));
nd0_(i_,r_,s)		= sum((mapi(i,i_),mapr(r,r_)),nd0(i,r,s));
md0_(i_,r_,s)		= sum((mapi(i,i_),mapr(r,r_)),md0(i,r,s));
ns0_(i_,r_,s)		= sum((mapi(i,i_),mapr(r,r_)),ns0(i,r,s));
xs0_(i_,r_,s)		= sum((mapi(i,i_),mapr(r,r_)),xs0(i,r,s));
c0_(r_,s,h)		= sum(mapr(r,r_),c0(r,s,h));
cd0_(i_,r_,s,h)		= sum((mapi(i,i_),mapr(r,r_)),cd0(i,r,s,h));
evom_(f,r_,s)		= sum(mapr(r,r_),evom(f,r,s));
evomh_(f,r_,s,h)	= sum(mapr(r,r_),evomh(f,r,s,h));
hhtrn0_(r_,s,h,trn)	= sum(mapr(r,r_),hhtrn0(r,s,h,trn));
sav0_(r_,s,h)		= sum(mapr(r,r_),sav0(r,s,h));
vim_(i_,r_)		= sum((mapi(i,i_),mapr(r,r_)),vim(i,r));
vb_(r_)			= sum(mapr(r,r_), vb(r));
vtw_(j_)		= sum(mapj(j,j_),vtw(j));
vst_(j_,r_)		= sum((mapj(j,j_),mapr(r,r_)),vst(j,r));
vtwr_(j_,i_,rr_,r_)	= sum((mapj(j,j_),mapi(i,i_),maprr(rr,rr_),mapr(r,r_)),vtwr(j,i,rr,r));
vxmd_(i_,r_,rr_)	= sum((mapi(i,i_),mapr(r,r_),maprr(rr,rr_)),vxmd(i,r,rr));

$exit

parameter
	rto_(g_,r_)		Output (or income) subsidy rates
	rtf0_(f,g_,r_)		Benchmark primary factor tax rate
	rtf_(f,g_,r_)		Primary factor tax rate
	rtd_(i_,r_,s)		Tax rate on domestic demand
	rtd0_(i_,r_,s)		Benchmark tax rate on domestic demand
	rtm_(i_,r_,s)		Tax rate on import demand
	rtm0_(i_,r_,s)		Benchmark tax rate on import demand
	rtxs_(i_,rr_,r_)	Export subsidy rates
	rtms_(i_,rr_,r_)	Import taxes rates

rto(g,r) = vom(g,r,s) * rto(g,r);
rtf(f,g,r) = vfm(f,g,r,s) * rtf(f,g,r);
rtd(i,r,s) = (vdfm(i,r,s,s)$bnm(i,r)) * rtd(i,r,s);
rtm(i,r,s) = (md0(i,r,s)$pnm(i,r) + vifm(i,r,s)$bnm(i,r)) * rtm(i,r,s);
rtms(i,rr,r) = vxmd(i,rr,r)*(1-rtxs(i,rr,r))*rtms(i,rr,r);
rtxs(i,rr,r) = vxmd(i,rr,r)*rtxs(i,rr,r);


rto_(g_,r_) = sum((mapg(g,g_),mapr(r,r_)),rto(g,r));
rtf_(f,g_,r_) = sum((f,mapg(g,g_),mapr(r,r_)),rtf(f,g,r));
rtd_(i_,r_,s) = sum((mapi(i,i_),mapr(r,r_)),rtf(i,r,s));
rtm_(i_,r_,s) = sum((mapi(i,i_),mapr(r,r_)),rtm(i,r,s));
rtxs_(i_,rr_,r_) = sum((mapi(i,i_),maprr(rr,rr_),mapr(r,r_)),rtxs(i,rr,r));
rtms_(i_,rr_,r_) = sum((mapi(i,i_),maprr(rr,rr_),mapr(r,r_)),rtms(i,rr,r));

rto_(g_,r_) = vom(g,r,s) * rto(g,r);
rtf_(f,g_,r_) = vfm(f,g,r,s) * rtf(f,g,r);
rtd_(i_,r_,s) = (vdfm(i,r,s,s)$bnm(i,r)) * rtd(i,r,s);
rtm_(i_,r_,s) = (md0(i,r,s)$pnm(i,r) + vifm(i,r,s)$bnm(i,r)) * rtm(i,r,s);
rtxs_(i_,rr_,r_) = rtxs_(i_,rr_,r_)/(vxmd_(i_,rr_,r_)+rtms_(i_,rr_,r_))
rtms_(i_,rr_,r_) = rtms(i,rr,r) / (vxmd(i,rr,r)*(1-rtxs_(i_,rr_,r_)));

pvxmd_(i_,rr_,r_) = (1-rtxs_(i_,rr_,r_))*(1+rtms_(i_,rr_,r_));
pvtwr_(i_,rr_,r_) = 1+rtms_(i_,rr_,r_);


esube_(g) = sum(mapg(g,g_),
esubva_(g_) = sum((r,s),esubva(g)*vom(g,r,s))/sum((r,s),vom(g,r,s));
esubdm_(i_)		Elasticity of substitution (M versus D),
esubm_(i_) = sum(r,vim(i,r)*esubm(i))/sum(r,vim(i,r));




$loaddc	rto
$loaddc	rtf
$loaddc	rtxs
$loaddc	rtms

$loaddc	pvxmd
$loaddc	pvtwr

$loaddc esube
$loaddc	esubva
$loaddc	etrndn
$loaddc	etrae
$loaddc	esubdm
$loaddc	esubm
