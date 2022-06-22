$title	Disaggregate Subregions in USA for 2014 based on WINDC Benchmark

$set fs %system.dirsep%

*	Point to a WiNDC dataset:

$if not set windc_data $set windc_data soi_static_gtap_state_2014

*	Name the GTAPWiNDC dataset to be produced:

$if not set dsout      $set dsout gtap_soi_2014

*	Start off by reading the sets of subregions and 
*	households in the WiNDC dataset:

$set windc_gdx datasets%fs%windc%fs%%windc_data%.gdx
$gdxin %windc_gdx%

*	Subregions are are typically either states or census regions.
*	Households are currently quntiles (h1*h5).

set	s_usa	Subregions in USA
	h_usa	Households in USA

$load s_usa=r h_usa=h

*	Declare sets s and h to include the subregions and households
*	we will add as well as the "rest" region/household which is
*	in the stub dataset.  We need to make these declarations so
*	that we can add data without having domain violations.

set	s	Subregions in the model /set.s_usa, rest/
	h	Households in the model /set.h_usa, rest/;

*	Read the GTAPWiNDC stub dataset:

$if not set gtap_data $set gtap_data gtap_10_stub

$set ds %gtap_data%

$include gtapwindc_data

*	Declare WiNDC parameters we will use for targetting the disaggregation:

parameter
    cd0_h(s,i,h)	Household level expenditures,
    le0(s,s,h)		Household labor endowment,
    ls0(s,h)		  Labor supply (net),
    ke0(s,h)		  Household interest payments,
    ld0(s,g)		  Labor demand,
    kd0(s,g)		  Capital demand,
    x0(s,i)		    Exports of goods and services,
    sav0(s,h)		  Household saving,
    i0(s,i)		    Investment
    g0(s,i)		    Government expenditure

*	Several parameter identifiers have been used in the GTAPWiNDC database
*	so we need to add a suffix to make the names unique:

    xd0_windc(s,i)	Regional supply to local market,
    xn0_windc(s,i)	Regional supply to national market,
    m0_windc(s,i)	  Import demand
    nd0_windc(s,i)	Regional demand from national market;

$gdxin %windc_gdx%

$loaddc cd0_h le0 ls0 ke0 ld0 kd0 x0 sav0 i0 g0

*	Read and rename these parameters:

$loaddc xn0_windc=xn0 xd0_windc=xd0 nd0_windc=nd0 m0_windc=m0

*	Provide a comparison of trade flows in the two datasets:

parameter	trade	Trade comparison: %windc_data% vs %ds%;
trade(i,"exports","windc") = sum(s,x0(s,i));
trade(i,"imports","windc") = sum(s,m0_windc(s,i));
trade(i,"exports","gtap") = sum(r,vxmd(i,"usa",r)) + vst(i,"usa");
trade(i,"imports","gtap") = sum(r,vxmd(i,r,"usa")+sum(j,vtwr(i,j,r,"usa")));
option trade:3:1:2;
display trade;

*	Trade data and economic transactions in other regions remain unchanged:

set	rb(r)		Region to balance /usa/;

variables

	OBJ		Least squares objective

*	Add a trailing underscore to identify the targetted value:

	VOM_(g,r,s)	Total supply at market prices,
	VAFM_(i,g,r,s)	Intermediate demand at market prices,
	VFM_(f,g,r,s)	Factor demand at market prices,
	EVOMH_(f,r,s,h)	Household primary factor endowment,

	XN0_(i,r,s)	Commodity supply to national market,
	XD0_(i,r,s)	Local domestic absorption,
	A0_(i,r,s)	Absorption,
	MD0_(i,r,s)	Import absorption,
	ND0_(i,r,s)	National market domestic absorption,
	C0_(r,s,h)	Total household consumption,
	CD0_(i,r,s,h)	Household consumption at market prices,
	HSAV0_(r,s,h)	Household saving;

EQUATIONS
	objdef		Least squares objective,

*	Constraints correspond to the model's equilibrium conditions:

	profit_y(g,r,s), profit_x(i,r,s), profit_z(i,r,s), profit_c(r,s,h), 
	market_pz(i,r,s), market_p(i,r), market_pf(f,r,s), market_pm(i,r),
	balance_rh(r,s,h), balance_govt(r), balance_inv(r);

*	We use a quadratic penalty of the form:  deviation = a0 * sqr(a/a0-1)

*	Could use a macro to write this equation.  A bit cryptic, but perhaps less error prone.

$macro	target(a,a0,sd,d)   (sum((&&sd)$a0(&&d), a0(&&d) * sqr(a(&&d)/a0(&&d)-1)))


objdef..	OBJ =e= target(VOM_,  vom,	"g,rb(r),s",	"g,r,s") +
			target(VAFM_, vafm,	"i,g,rb(r),s",	"i,g,r,s") +
			target(VFM_,  vfm,	"f,g,rb(r),s",	"f,g,r,s") +
			target(EVOMH_,evomh,	"f,rb(r),s,h",	"f,r,s,h") +

			target(XN0_,  xn0,	"i,rb(r),s",	"i,r,s") +
			target(XD0_,  xd0,	"i,rb(r),s",	"i,r,s") +
			target(A0_,   a0,	"i,rb(r),s",	"i,r,s") +
			target(MD0_,  md0,	"i,rb(r),s",	"i,r,s") +
			target(ND0_,  nd0,	"i,rb(r),s",	"i,r,s") +
			target(C0_,   c0,	"rb(r),s,h",	"r,s,h") +
			target(CD0_,  cd0,	"i,rb(r),s,h",	"i,r,s,h") +
			target(HSAV0_, hsav0,   "rb(r),s,h",   "r,s,h");

profit_y(y_(g,rb(r),s))..	VOM_(g,r,s)*(1-rto(g,r)) =e= sum(pz_(i,r,s),VAFM_(i,g,r,s)) +

					sum(pf_(f,r,s),VFM_(f,g,r,s)*(1+rtf0(f,g,r)));

profit_x(x_(i,rb(r),s))..	XN0_(i,r,s)$p_(i,r) + XD0_(i,r,s) =e= VOM_(i,r,s);

profit_z(z_(i,rb(r),s))..	A0_(i,r,s) =e= (1+rtd0(i,r,s)) *(XD0_(i,r,s) + ND0_(i,r,s)$p_(i,r)) 
							     + (1+rtm0(i,r,s))*MD0_(i,r,s)$PM_(i,r);

profit_c(c_(rb(r),s,h))..	C0_(r,s,h) =e= sum(pz_(i,r,s),CD0_(i,r,s,h));


balance_rh(RH_(rb(r),s,h))..	C0_(r,s,h) =e= sum(pf_(f,r,s),EVOMH_(f,r,s,h)) - htax0(r,s,h) - HSAV0_(r,s,h);

balance_govt(rb(r))..	sum(s,VOM_("g",r,s)) =e= 

					sum((s,h),htax0(r,s,h)) 


					+ sum(y_(g,r,s), 
						VOM_(g,r,s)*rto(g,r) +
						sum(f,VFM_(f,g,r,s)*rtf(f,g,r))
					) 

					+ sum(z_(i,r,s),
						(XD0_(i,r,s)+ND0_(i,r,s))*rtd0(i,r,s) +
						MD0_(i,r,s)*rtm0(i,r,s)
					) 

					+ sum(m_(i,r),
						sum(rr,vxmd(i,rr,r)*rtms(i,rr,r)*(1-rtxs(i,rr,r))
						+ sum(j,vtwr(j,i,rr,r)*rtms(i,rr,r)))
					) 

					- sum(m_(i,rr),vxmd(i,r,rr)*rtxs(i,r,rr));
						

balance_inv(rb(r))..		sum(s,VOM_("i",r,s)) =e= sum((s,h),HSAV0_(r,s,h)) + vb(r);

market_pz(pz_(i,rb(r),s))..	A0_(i,r,s) =e= sum(c_(r,s,h),CD0_(i,r,s,h)) + sum(y_(g,r,s),VAFM_(i,g,r,s));

market_p(p_(i,rb(r)))..		sum(s,XN0_(i,r,s)) =e= 
					sum(s,ND0_(i,r,s)) + sum(M_(i,rr),vxmd(i,r,rr)) + vst(i,r)$yt_(i);

market_pf(pf_(f,rb(r),s))..	sum(RH_(r,s,h),EVOMH_(f,r,s,h)) =e= sum(y_(g,r,s), VFM_(f,g,r,s)) ;

market_pm(pm_(i,rb(r)))..	vim(i,r) =e= sum(s,MD0_(i,r,s));

model balance /
	objdef,
	profit_y, profit_x, profit_z, profit_c,	
	market_pz, market_p,	market_pf, market_pm, 
	balance_rh, balance_govt, balance_inv /;

*	Use a macro to assign level values:

$macro	setlevel(a,b,d)	a.L(&&d) = b(&&d); a.LO(&&d) = 0.1*b(&&d); a.UP(&&d) = 10*b(&&d);

setlevel(VOM_,	vom,	"g,r,s")
setlevel(VAFM_,	vafm,	"i,g,r,s")
setlevel(VFM_,	vfm,	"f,g,r,s")
setlevel(EVOMH_, evomh,	"f,r,s,h")
setlevel(XN0_,	xn0,	"i,r,s")
setlevel(XD0_,	xd0,	"i,r,s")
setlevel(A0_,	a0,	"i,r,s")
setlevel(MD0_,	md0,	"i,r,s")
setlevel(ND0_,	nd0,	"i,r,s")
setlevel(C0_,	c0,	"r,s,h")
setlevel(CD0_,	cd0,	"i,r,s,h")

*	The interior point solver (CPLEX) is very fast.  

*	During model development, CONOPT is useful as it provides
*	better error messages.

option qcp=cplex;

*	Pass fixed values as constants:

balance.holdfixed = yes;

*	Verify that we have a handshake on the GTAP data:

solve balance using qcp minimizing obj;

abort$round(obj.l,5)	"GTAP handshake fails",OBJ.L;

*	Install targets for USA regions:

parameter	theta_vom(g,s)		Subregion share of production,
		thetaL(s,h)		Subregion labor endowment shares,
		thetaK(s,h)		Subregion capital endowment shares,
		thetam(i,s)		Import share
		thetaxn(i,s)		Subregion national market supply shares,
		thetand(i,s)		Subregion national market demand shares,
		thetad(i,s)		Local share of subregion absorption,
		thetac(i,r,s,h)		Subregional shares of consumption; 


set	labor(f)	/mgr,    tec,    clk,    srv,    lab/,
	capital(f)	/cap,    lnd,    res/;

alias (s,ss);

$macro	resetlevel(a,a0,d)	a.L(&&d) = a0(&&d); a.LO(&&d) = 0*a0(&&d); a.UP(&&d) = 100*a0(&&d);

*	Loop over the region to be balanced (rb("usa")).  I do this to avoid having
*	to write "usa" in place of r.  Furthermore, it will be possible to use the
*	same logic for disaggregating CAN (D-level provincial tables), EUR and CHN.

loop(rb(r),

*	Here is the subtle stuff -- impute target values for the subregions technologies 
*	and preferences.

*	We are not enforcing a "tight handshake" yet.  Here we assume that inputs follow
*	production.

	theta_vom(g(i),s) = (xd0_windc(s,i)+xn0_windc(s,i)+nd0_windc(s,i)) /
		sum(s.local,xd0_windc(s,i)+xn0_windc(s,i)+nd0_windc(s,i));

	theta_vom("i",s) = sum(i,i0(s,i))/sum((i,s.local),i0(s,i));
	theta_vom("g",s) = sum(i,g0(s,i))/sum((i,s.local),g0(s,i));

*	We have previously worked on calibrating BLS occupation statistics to households.
*	A future version of WiNDC will include these data in the canonical model so that
*	we can line up with the GTAP labor categories.  For the time being, simply share out
*	labor and cpaital in proportion to household endowments in WiNDC:

	thetaL(s,h) = sum(ss,le0(s,ss,h))/sum((s.local,ss,h.local),le0(s,ss,h));

	thetaK(s,h) = 1/(card(h)-1);
	thetaK(s,h)$sum(s.local,ke0(s,h)) = ke0(s,h)/sum(s.local,ke0(s,h));

*	National and domestic market shares:

	thetaxn(i,s) = xn0_windc(s,i)/sum(s.local,xn0_windc(s,i));
	thetad(i,s) = 1/(card(s)-1);
	thetad(i,s)$(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i))
		= xd0_windc(s,i)/(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i));

*	Consumption shares:

	thetac(i,r,s,h)$sum((s.local,h.local),cd0_h(s,i,h))
		= cd0_h(s,i,h)/sum((s.local,h.local),cd0_h(s,i,h));

*	Import shares:

	thetam(i,s)$sum(s.local,m0_windc(s,i))
		= m0_windc(s,i)/sum(s.local,m0_windc(s,i));

*	National market demand shares:

	thetand(i,s) = nd0_windc(s,i)/sum(s.local,nd0_windc(s,i));

	vom(g,r,s) = theta_vom(g,s) * vom(g,r,"rest");

	vafm(i,g,r,s)= theta_vom(g,s) * vafm(i,g,r,"rest");
	vfm(f,g,r,s) = theta_vom(g,s) * vfm(f,g,r,"rest");

	evomh(labor(f),r,s,h) = thetaL(s,h) * sum(g,vfm(f,g,r,s));

	evomh(capital(f),r,s,h) = thetaK(s,h) * sum(g,vfm(f,g,r,s));

	xn0(i,r,s) = thetaxn(i,s) * xn0(i,r,"rest");
	xd0(i,r,s) = thetad(i,s)*a0(i,r,"rest");

	rtd0(i,r,s) = rtd0(i,r,"rest");
	rtm0(i,r,s) = rtm0(i,r,"rest");

	a0(i,r,s) = (xd0(i,r,s)+nd0(i,r,s))*(1+rtd0(i,r,s)) + md0(i,r,s)*(1+rtm0(i,r,s));
	md0(i,r,s) = thetam(i,s) * md0(i,r,"rest");

	nd0(i,r,s) = thetand(i,s)*nd0(i,r,"rest");
	cd0(i,r,s,h) = thetac(i,r,s,h) * cd0(i,r,"rest","rest");

	htax0(r,s,h) = c0(r,s,h)/c0(r,"rest","rest")*htax0(r,"rest","rest");
	hsav0(r,s,h) = sav0(s,h)/sum((s.local,h.local), sav0(s,h))*hsav0(r,"rest","rest");
	c0(r,s,h) = sum(i,cd0(i,r,s,h));

*	Drop the "rest" subregion data for rb(r):

	vom(g,r,"rest") = 0;
	vafm(i,g,r,"rest") = 0;
	vfm(f,g,r,"rest") = 0;
	evomh(f,r,"rest",h) = 0;
	xn0(i,r,"rest") = 0;
	xd0(i,r,"rest") = 0;
	a0(i,r,"rest") = 0;
	md0(i,r,"rest") = 0;
	nd0(i,r,"rest") = 0;
	c0(r,"rest",h) = 0;
	cd0(i,r,"rest",h) = 0;
	hsav0(r,"rest",h) = 0;
	htax0(r,"rest",h) = 0;

*	Add imports if they are in the GTAP dataset:

	loop(i$(sum(s,md0(i,r,s))=0),
	  md0(i,r,s)$((not sameas(s,"rest")) and vim(i,r)) = vim(i,r)/(card(s)-1);
	);

*	Supress intermediate demand and final if the source market is inactive:

	vafm(i,g,r,s)$(not a0(i,r,s)) = 0;
	cd0(i,r,s,h)$(not a0(i,r,s)) = 0;

*	Reset level values and bounds:

	resetlevel(VOM_,	vom,	"g,r,s")
	resetlevel(VAFM_,	vafm,	"i,g,r,s")
	resetlevel(VFM_,	vfm,	"f,g,r,s")
	resetlevel(EVOMH_, evomh,	"f,r,s,h")

	resetlevel(XN0_,	xn0,	"i,r,s")
	resetlevel(XD0_,	xd0,	"i,r,s")
	resetlevel(A0_,	a0,	"i,r,s")
	resetlevel(MD0_,	md0,	"i,r,s")
	resetlevel(ND0_,	nd0,	"i,r,s")
	resetlevel(C0_,	c0,	"r,s,h")
	resetlevel(CD0_,	cd0,	"i,r,s,h")
	resetlevel(HSAV0_,	hsav0,	"r,s,h")
);



*	We want to remove the "rest" subregion from rb:

MD0_.FX(i,rb,"rest") = 0;

*	Assign the aggregate factor supply which enters the balancing
*	model by identifying which factor markets are active (pf_):

evom(f,r,s) = sum(h,evomh(f,r,s,h));

set	iter	Iterations for removing small values /iter0*iter3/;

*	Filter numbers which are 1e-5 or smaller when the values are extracted.  
*	Count the number of nonzeros in the resulting parameter, and fix to 
*	zero any variables which have been dropped.

$macro	readsolution(a,a0,d)	a0(&&d) = a.L(&&d)$round(a.L(&&d),4); nz("&&a0") = card(a0); A.FX(&&d)$(not a0(&&d)) = 0;

set	v /vom,vafm,vfm,evomh,xn0,xd0,a0,md0,nd0,c0,cd0,hsav0/;

parameter	nz(v)		Number of nonzeros
		iterlog(v,iter)	Iteration log,
		dev		Change in nonzeros /1/;

loop(iter$dev,

*	Set logical flags for the activities and markets which 
*	are in the model:

	loop(rb(r),
	  y_(g,r,s) = vom(g,r,s);
	  x_(i,r,s) = vom(i,r,s);
	  z_(i,r,s) = a0(i,r,s);
	  c_(r,s,h) = c0(r,s,h);
	  ft_(sf,r,s) = evom(sf,r,s);
	  m_(i,r) = vim(i,r);
	  yt_(j) = vtw(j);
	  pz_(i,r,s) = a0(i,r,s);
	  p_(i,r) = sum(s,xn0(i,r,s));
	  pc_(r,s,h) = c0(r,s,h);
	  pf_(f,r,s) = evom(f,r,s);
	  ps_(sf,g,r,s) = vfm(sf,g,r,s);
	  pm_(i,r) = vim(i,r);
	  pt_(j) = vtw(j);
	  rh_(r,s,h) = c0(r,s,h);
	);

*	Use conopt if an infeasibility only shows up, otherwise
*	one of the LP codes is going to be faster:

	option qcp = cplex;
*.option qcp=conopt;


	solve balance using qcp minimizing obj;

*	Read the solution values and count nonzeros:

	loop(rb(r),
		readsolution(VOM_,	vom,	"g,r,s")
		readsolution(VAFM_,	vafm,	"i,g,r,s")
		readsolution(VFM_,	vfm,	"f,g,r,s")
		readsolution(EVOMH_,	evomh,	"f,r,s,h")
		readsolution(XN0_,	xn0,	"i,r,s")
		readsolution(XD0_,	xd0,	"i,r,s")
		readsolution(A0_,	a0,	"i,r,s")
		readsolution(MD0_,	md0,	"i,r,s")
		readsolution(ND0_,	nd0,	"i,r,s")
		readsolution(C0_,	c0,	"r,s,h")
		readsolution(CD0_,	cd0,	"i,r,s,h")
		readsolution(HSAV0_,	hsav0,	"r,s,h")

*	Assign evom to control pf_() in the next iteration:

		evom(f,r,s) = sum(rh_(r,s,h),EVOMH_.L(f,r,s,h));
	);

*	Report nonzero counts and continue if the numbers
*	have changed:

	iterlog(v,iter) = nz(v);
	dev = sum(v,iterlog(v,iter-1)-nz(v));
);
display iterlog;

execute_unload 'datasets%fs%gtapwindc%fs%%dsout%.gdx',
	r,g,i,f,s,h,sf,mf,
	vom, vafm, vfm, xn0, xd0, a0,
	md0, nd0, c0, cd0, evom, evomh, 
	rtd, rtd0, rtm, rtm0, esube,
	etrndn, htax0, hsav0,
	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;
