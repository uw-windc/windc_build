$title	Disaggregate Subregions in USA for 2014 based on WINDC Benchmark

*	Point to a WiNDC dataset which has only 32 sectors:

$if not set gdxfile $set gdxfile datasets/windc/32.gdx

*	Name the GTAPWiNDC dataset to be produced:

$if not set dsout      $set dsout datasets/gtapwindc/43.gdx

*	Start off by reading the sets of subregions and 
*	households in the WiNDC dataset:

$gdxin %gdxfile%

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

alias (s,ss);

*	Read the GTAPWiNDC stub dataset:

$if not set gtapwindc_datafile $set gtapwindc_datafile datasets/gtapwindc/43_stub

$include gtapwindc_data

*	Declare WiNDC parameters we will use for targetting the disaggregation:

parameter
    cd0_h(s,i,h)	Household level expenditures,
    ls0(s,h)		Labor supply (net),
    le0(s,ss,h)		Household labor endowment,
    tl0(s,h)		Household labor tax rate,
    ke0(s,h)		Household interest payments,
    ld0(s,g)		Labor demand,
    kd0(s,g)		Capital demand,
    i0(s,i)		Investment
    g0(s,i)		Government expenditure

*	Several parameter identifiers have been used in the GTAPWiNDC database
*	so we need to add a suffix to make the names unique:


    hhtrn0_windc(s,h,trn)	Household transfers
    s0_windc(s,i)		Regional supply to all markets
    x0(s,i)			Regional supply to export markets,
    rx0(s,i)			Regional re-exports
    a0_windc(s,i)		Regional absorption
    xd0_windc(s,i)		Regional supply to local market,
    xn0_windc(s,i)		Regional supply to national market,
    m0_windc(s,i)		Import demand
    nd0_windc(s,i)		Regional demand from national market
    sav0_windc(s,h)		Base year savings;


$gdxin %windc_gdx%

$loaddc cd0_h le0 tl0 ke0 ld0 kd0 x0 rx0 i0 g0 

ls0(s,h) = sum(ss,le0(s,ss,h))*(1-tl0(s,h));


*	Read and rename these parameters:

$loaddc hhtrn0_windc=hhtrn0, xn0_windc=xn0 xd0_windc=xd0 nd0_windc=nd0 m0_windc=m0 s0_windc=s0 a0_windc=a0 sav0_windc=sav0

*	Define the region to be balanced:

$if not set rb $set rb usa

*	Provide a comparison of trade flows in the two datasets:

parameter	trade	Trade comparison: %windc_data% vs %ds%;
trade(i,"exports","windc") = sum(s,x0(s,i));
trade(i,"imports","windc") = sum(s,m0_windc(s,i));
trade(i,"exports","gtap") = sum(r,vxmd(i,"%rb%",r)) + vst(i,"%rb%");
trade(i,"imports","gtap") = sum(r,vxmd(i,r,"%rb%")+sum(j,vtwr(i,j,r,"%rb%")));
option trade:3:1:2;
display trade;

*	Trade data and economic transactions in other regions remain unchanged:

set	rb(r)		Region to balance /%rb%/
	rs(r,s)		Regions and subregions to balance;


parameter	hhtrn_compare, trnratio;
hhtrn_compare(trn,"stub") = sum((rb(r),s,h),hhtrn0(r,s,h,trn));
hhtrn_compare(trn,"windc") = sum((s,h),hhtrn0_windc(s,h,trn));

set	dsource /stub,windc/;
hhtrn_compare("total",dsource) = sum(trn,hhtrn_compare(trn,dsource));
option trn:0:0:1;
display hhtrn_compare, trn;

parameter	incomechk;
incomechk(r) = sum((s,h),c0(r,s,h)) + sum(s,vom("g",r,s) + vom("i",r,s)) 
	- sum((f,s,h),evomh(f,r,s,h))
	- vb(r) 
	- (	  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
		+ sum((i,s), rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s)) + rtm(i,r,s)*md0(i,r,s))
		+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
		+ sum(g, rto(g,r)*sum(s,vom(g,r,s))) );
display incomechk;

set lf(f) /mgr,tec,clk,srv,lab/, kf(f)/cap,lnd,res/;

set	macct	Macro accounts /
		C	Household consumption,
		G	Public expenditure
		T	Tax revenue
		I	Investment
		L	Labor income
		K	Capital income

		"C*"	Household consumption (windc)
		"G*"	Public expenditure (windc)
		"I*"	Investment (windc)
		"L*"	Labor income (windc)
		"K*"	Capital income (windc)
		"LD*"	Wage earnings (windc -- gross of tax)
		"KD*"	Capital earnings (windc -- net household production)

		F	Foreign savings
		GDP	"Gross domestic product (C+I+G-B)"
		"GDP*"	"Gross domestic product (K+L+T)"/;
		
parameter	macroaccounts(macct,*)	Macro economic accounts;
loop(rb(r),
	macroaccounts("C","$") = sum((s,h),c0(r,s,h));
	macroaccounts("G","$") = sum(s,vom("g",r,s));
	macroaccounts("I","$") = sum(s,vom("i",r,s));
	macroaccounts("L","$") = sum((lf(f),s,h),evomh(lf,r,s,h));
	macroaccounts("K","$") = sum((kf(f),s,h),evomh(kf,r,s,h));
	macroaccounts("F","$") = vb(r);
	macroaccounts("T","$") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum((i,s), rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s)) + rtm(i,r,s)*md0(i,r,s))
				+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
				+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));

	macroaccounts("GDP","$") = macroaccounts("C","$") + macroaccounts("G","$") + macroaccounts("I","$") - macroaccounts("F","$");
	macroaccounts("GDP*","$") = macroaccounts("L","$") + macroaccounts("K","$") + macroaccounts("T","$");

	macroaccounts("C*","$") = sum((s,i,h),cd0_h(s,i,h));
	macroaccounts("G*","$") = sum((s,i),g0(s,i));
	macroaccounts("I*","$") = sum((s,i),i0(s,i));
	macroaccounts("L*","$") = sum((s,h),ls0(s,h));
	macroaccounts("K*","$") = sum((s,h),ke0(s,h));
	macroaccounts("LD*","$") = sum((s,g),ld0(s,g));
	macroaccounts("KD*","$") = sum((s,g),kd0(s,g));
);
macroaccounts("C","%GDP") = 100 * macroaccounts("C","$") / macroaccounts("GDP","$");
macroaccounts("G","%GDP") = 100 * macroaccounts("G","$") / macroaccounts("GDP","$");
macroaccounts("I","%GDP") = 100 * macroaccounts("I","$") / macroaccounts("GDP","$");
macroaccounts("L","%GDP") = 100 * macroaccounts("L","$") / macroaccounts("GDP","$");
macroaccounts("K","%GDP") = 100 * macroaccounts("K","$") / macroaccounts("GDP","$");
macroaccounts("F","%GDP") = 100 * macroaccounts("F","$") / macroaccounts("GDP","$");

option macct:0:0:1;
option macroaccounts:3;
display macroaccounts macct;

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
	CD0_(i,r,s,h)	Household consumption at market prices;

EQUATIONS
	objdef		Least squares objective,

*	Constraints correspond to the model's equilibrium conditions:

	profit_y(g,r,s), profit_x(i,r,s), profit_z(i,r,s), profit_c(r,s,h), 
	market_pz(i,r,s), market_p(i,r), market_pf(f,r,s), market_pm(i,r),
	balance_rh(r,s,h), balance_govt(r), balance_inv(r), sector_output(g,r), factor_income(f,r);

*	We use a quadratic penalty of the form:  deviation = a0 * sqr(a/a0-1)

*	Could use a macro to write this equation.  A bit cryptic, but perhaps less error prone.

$macro	target(a,a0,d)   (sum((&&d)$a0(&&d), a0(&&d) * sqr(a(&&d)/a0(&&d)-1)))

*	This macro is used to generate a least-squares objective. The macro:

*		target(VAFM_, vafm,	"i,g,rb,s") +

*	expands to:

*	(sum((i,g,rb,s)$vafm(i,g,rb,s), vafm(i,g,rb,s) * sqr(VAFM_(i,g,rb,s)/vafm(i,g,rb,s)-1))) +



objdef..	OBJ =e= target(VOM_,  vom,	"g,rb,s") +
			target(VAFM_, vafm,	"i,g,rb,s") +
			target(VFM_,  vfm,	"f,g,rb,s") +
			target(EVOMH_,evomh,	"f,rb,s,h") +

			target(XN0_,  xn0,	"i,rb,s") +
			target(XD0_,  xd0,	"i,rb,s") +
			target(A0_,   a0,	"i,rb,s") +
			target(MD0_,  md0,	"i,rb,s") +
			target(ND0_,  nd0,	"i,rb,s") +
			target(C0_,   c0,	"rb,s,h") +
			target(CD0_,  cd0,	"i,rb,s,h");

profit_y(y_(g,rs(r,s)))..	VOM_(g,r,s)*(1-rto(g,r)) =e= 
					sum(pz_(i,r,s),VAFM_(i,g,r,s)) +
					sum(pf_(f,r,s),VFM_(f,g,r,s)*(1+rtf0(f,g,r)));

profit_x(x_(i,rs(r,s)))..	XN0_(i,r,s)$p_(i,r) + XD0_(i,r,s) =e= VOM_(i,r,s);

profit_z(z_(i,rs(r,s)))..	A0_(i,r,s) =e= (1+rtd0(i,r,s)) *(XD0_(i,r,s) + ND0_(i,r,s)$p_(i,r)) 
							     + (1+rtm0(i,r,s))*MD0_(i,r,s)$PM_(i,r);

profit_c(c_(rs(r,s),h))..	C0_(r,s,h) =e= sum(pz_(i,r,s),CD0_(i,r,s,h));


balance_rh(RH_(rs(r,s),h))..	C0_(r,s,h) + sav0(r,s,h) =e= 


*	NB  Factor earnings in GTAP (EVOM) are defined on a net basis, so taxes do not need
*	to be specified in this budget equation:
 
					sum(pf_(f,r,s),EVOMH_(f,r,s,h)) + 

					sum(trn,hhtrn0(r,s,h,trn));

balance_govt(rb(r))..		sum(rs(r,s),VOM_("g",r,s)) + sum((rs(r,s),h,trn),hhtrn0(r,s,h,trn)) =e= 
					

					+ sum(y_(g,r,s), 
						VOM_(g,r,s)*rto(g,r) +
						sum(pf_(f,r,s),VFM_(f,g,r,s)*rtf(f,g,r))
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
						

balance_inv(rb(r))..		sum(rs(r,s),VOM_("i",r,s)) =e= sum((rs(r,s),h),sav0(r,s,h)) + vb(r);

market_pz(pz_(i,rb(r),s))..	A0_(i,r,s) =e= sum(c_(r,s,h),CD0_(i,r,s,h)) + sum(y_(g,r,s),VAFM_(i,g,r,s));

market_p(p_(i,rb(r)))..		sum(x_(i,r,s),XN0_(i,r,s)) =e= 
					sum(z_(i,r,s),ND0_(i,r,s)) + sum(m_(i,rr),vxmd(i,r,rr)) + vst(i,r)$yt_(i);

market_pf(pf_(f,rb(r),s))..	sum(rh_(r,s,h),EVOMH_(f,r,s,h)) =e= sum(y_(g,r,s), VFM_(f,g,r,s)) ;

market_pm(pm_(i,rb(r)))..	vim(i,r) =e= sum(rs(r,s),MD0_(i,r,s));

parameter	vom_tot(g)	Total output /(set.g) 0/,
		evomtot(f)	Factor income target /(set.f) 0/;

sector_output(g,rb(r))$vom_tot(g)..	sum(s,VOM_(g,r,s)) =e= vom_tot(g);

factor_income(f,rb)$evomtot(f)..	sum(rh_(r,s,h),EVOMH_(f,r,s,h)) =e= evomtot(f);

model balance /
	objdef,
	profit_y,   profit_x,     profit_z,  profit_c,	
	market_pz,  market_p,	  market_pf, market_pm, 
	balance_rh, balance_govt, balance_inv
	sector_output, factor_income /;

*	Use a macro to assign level values:

$macro	setlevel(a,b,d)	a.L(&&d) = b(&&d); a.LO(&&d) = 0.1*b(&&d); a.UP(&&d) = 10*b(&&d);

setlevel(VOM_,	vom,	"g,r,s")
setlevel(VAFM_,	vafm,	"i,g,r,s")
setlevel(VFM_,	vfm,	"f,g,r,s")
setlevel(EVOMH_,evomh,	"f,r,s,h")
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

rs(rb,"rest") = yes;
solve balance using qcp minimizing obj;
abort$round(obj.l,5)	"GTAP handshake fails",OBJ.L;

*	-------------------------------------------------------------------------------
*	Use WiNDC benchmark to target values for the GTAPWiNDC dataset.

*	Install targets for US states:

parameter	theta_vom(g,s)		Subregion share of production,
		thetaL(s,h)		Subregion labor endowment shares,
		thetaK(s,h)		Subregion capital endowment shares,
		thetam(i,s)		Import share
		theta_sav0(s,h)		Subregion and household share of savings
		thetaxn(i,s)		Subregion national market supply shares,
		thetand(i,s)		Subregion national market demand shares,
		thetad(i,s)		Local share of subregion absorption,
		thetac(i,r,s,h)		Subregional shares of consumption; 

set	labor(f)	/mgr,    tec,    clk,    srv,    lab/,
	capital(f)	/cap,    lnd,    res/;

alias (s,ss);

set	sersectors /ser,trd/;

parameter	totals		Cross check on totals;
totals(i,"s0") = sum(s,s0_windc(s,i)) + eps;
totals(i,"i0") = sum(s,i0(s,i)) + eps;
totals(i,"g0") = sum(s,g0(s,i)) + eps;
totals(i,"xn0") = sum(s,xn0_windc(s,i));
display totals;

*	Loop over the region to be balanced (rb("%rb%")).  I do this to avoid having
*	to write "%rb%" in place of r.  Furthermore, it will be possible to use the
*	same logic for disaggregating CAN (D-level provincial tables), EUR and CHN.

parameter	thetachk(*,*)		Cross check on targets;

*	Create parameters to retain values from the stub dataset calibration:

parameter	vom_rest, cd0_rest, evomh_rest, evom_rest,
		cd0_tot	Total household consumption demand;

*	Macro for unfixing a variable and assigning the target level value:

$macro	resetlevel(a,b,d)	a.L(&&d) = b(&&d); a.LO(&&d) = 0; a.UP(&&d) = +inf;

*	Loop over the region to be balanced (for the USA -- other regions eventually):

loop(rb(r),

*	Here is the subtle stuff -- impute target values for the subregions technologies 
*	and preferences.

*	We are not enforcing a "tight handshake" yet.  Here we assume that inputs follow
*	production.

	theta_vom(g(i),s)$sum(s.local,s0_windc(s,i)) = s0_windc(s,i)/sum(s.local,s0_windc(s,i));
	theta_vom("i",s)$sum((i,s.local),i0(s,i))    = sum(i,i0(s,i))/sum((i,s.local),i0(s,i));
	theta_vom("g",s)$sum((i,s.local),g0(s,i))    = sum(i,g0(s,i))/sum((i,s.local),g0(s,i));

*	Houshold savings shares:

	theta_sav0(s,h) = sav0_windc(s,h) / sum((s.local,h.local),sav0_windc(s,h));

*	We have previously worked on calibrating BLS occupation statistics to households.
*	A future version of WiNDC will include these data in the canonical model so that
*	we can line up with the GTAP labor categories.  For the time being, simply share out
*	labor and capital in proportion to household endowments in WiNDC:

	thetaL(s,h)$ls0(s,h)              = ls0(s,h)/sum(h.local,ls0(s,h));
	thetaK(s,h)$sum(h.local,ke0(s,h)) = ke0(s,h)/sum(h.local,ke0(s,h));

*	National and domestic market shares:

	thetaxn(i,s)$sum(s.local,xn0_windc(s,i)) = xn0_windc(s,i)/sum(s.local,xn0_windc(s,i));

*	National market share of aggregate absorption

	thetand(i,s)$(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i))
		= nd0_windc(s,i)/(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i));

*	Domestic share beginning with a default value:

	thetad(i,s)$sum(i.local,xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i))
		= sum(i.local,xd0_windc(s,i))/
		  sum(i.local,xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i));
	thetad(i,s)$(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i))
		= xd0_windc(s,i)/(xd0_windc(s,i)+nd0_windc(s,i)+m0_windc(s,i));

*	Consumption shares:

	cd0_tot(i) = sum((s.local,h.local),cd0_h(s,i,h));
	display cd0_tot;

	thetac(i,r,s,h)$(not (sameas(s,"rest") or sameas(h,"rest"))) = 
		sum(i.local,cd0_h(s,i,h))/sum(i.local,cd0_tot(i));
	thetac(i,r,s,h)$cd0_tot(i) = cd0_h(s,i,h)/cd0_tot(i);

*	Import shares with default allocation equal to subregion share of total absorption:

	thetam(i,s) = sum(i.local,m0_windc(s,i))/
		      sum((i.local,s.local),m0_windc(s,i));
	thetam(i,s)$sum(s.local,m0_windc(s,i))
		= m0_windc(s,i)/sum(s.local,m0_windc(s,i));

*	National market demand shares:

	thetachk(g,"vom")$vom(g,r,"rest") = round(1 - sum(s,theta_vom(g,s)), 3);
	thetachk(s,"L")$(not sameas(s,"rest")) = round(1 - sum(h,thetaL(s,h)), 3);
	thetachk(s,"K")$(not sameas(s,"rest")) = round(1 - sum(h,thetaK(s,h)), 3);
	thetachk(i,"xn")$xn0(i,r,"rest") = round(1 - sum(s,thetaxn(i,s)), 3);
	thetachk(i,"c")$cd0(i,r,"rest","rest") = round(1 - sum((s,h),thetac(i,r,s,h)), 3);
	option thetachk:3:1:1;
	abort$card(thetachk) thetachk;


*	Household transfers are specified exogenously.  It is not clear why the transfer totals in 
*	the stub dataset are not exactly equal to transfers in the WiNDC dataset.  See other code!!

	hhtrn0(r,s,h,trn) = hhtrn0_windc(s,h,trn) * sum((s.local,h.local,trn.local),hhtrn0(r,    s,h,trn)) / 
						    sum((s.local,h.local,trn.local),hhtrn0_windc(s,h,trn));

	vom_rest(g) = vom(g,r,"rest");
	cd0_rest(i) = cd0(i,r,"rest","rest");
	evomh_rest(f) = evomh(f,r,"rest","rest");
	evom_rest(f) = sum(s,evom(f,r,s));

*	Add a constraint for public output and factor income:

	vom_tot(g(sersectors)) = vom(g,r,"rest");
	vom_tot("i") = 0;
	evomtot(f) = evomh_rest(f);

	vom(g,r,s)    = theta_vom(g,s) * vom(g,r,"rest");
	vafm(i,g,r,s) = theta_vom(g,s) * vafm(i,g,r,"rest");
	vfm(f,g,r,s)  = theta_vom(g,s) * vfm(f,g,r,"rest");

	evomh(labor(f),r,s,h)   = thetaL(s,h) * evomh_rest(f);
	evomh(capital(f),r,s,h) = thetaK(s,h) * evomh_rest(f);

	xn0(i,r,s) = thetaxn(i,s) * xn0(i,r,"rest");

	rtd0(i,r,s) = rtd0(i,r,"rest");
	rtm0(i,r,s) = rtm0(i,r,"rest");

	sav0(r,s,h) = theta_sav0(s,h) * sav0(r,"rest","rest");
	md0(i,r,s) = thetam(i,s)  * md0(i,r,"rest");
	xd0(i,r,s) = thetad(i,s)  * a0(i,r,"rest");
	nd0(i,r,s) = thetand(i,s) * a0(i,r,s);

	a0(i,r,s) = (xd0(i,r,s)+nd0(i,r,s))*(1+rtd0(i,r,s)) + md0(i,r,s)*(1+rtm0(i,r,s));

	cd0(i,r,s,h) = thetac(i,r,s,h) * cd0(i,r,"rest","rest");
	c0(r,s,h) = sum(i,cd0(i,r,s,h));

*	Drop the "rest" subregion data for rb(r):

	vom(g,r,"rest") = 0;
	vafm(i,g,r,"rest") = 0;
	vfm(f,g,r,"rest") = 0;
	evomh(f,r,"rest",h) = 0;
	xn0(i,r,"rest") = 0;
	xd0(i,r,"rest") = 0;
	sav0(r,"rest",h) = 0;
	a0(i,r,"rest") = 0;
	md0(i,r,"rest") = 0;
	xd0(i,r,"rest") = 0;
	nd0(i,r,"rest") = 0;
	c0(r,"rest",h) = 0;
	cd0(i,r,"rest",h) = 0;
	hhtrn0(r,s,"rest",trn) = 0;

*	Set up the equations for states and drop the rest region: 

	rs(r,s) = yes$(not sameas(s,"rest"));

*	Add imports if they are in the GTAP dataset --- may need to revisit the 
*	sharing rule here.  Might want to use state-level GDP:

	loop(i$(sum(s,md0(i,r,s))=0),
	  md0(i,r,s)$((not sameas(s,"rest")) and vim(i,r)) = vim(i,r)/(card(s)-1);
	);

*	Supress intermediate demand and final if the source market is inactive:

	vafm(i,g,r,s)$(not a0(i,r,s)) = 0;
	cd0(i,r,s,h)$(not a0(i,r,s)) = 0;

*	Reset level values and bounds:

	resetlevel(VOM_,   vom,	"g,r,s")
	resetlevel(VAFM_,  vafm,"i,g,r,s")
	resetlevel(VFM_,   vfm,	"f,g,r,s")
	resetlevel(EVOMH_, evomh,"f,r,s,h")

	resetlevel(XN0_, xn0,	"i,r,s")
	resetlevel(XD0_, xd0,	"i,r,s")
	resetlevel(A0_,  a0,	"i,r,s")
	resetlevel(MD0_, md0,	"i,r,s")
	resetlevel(ND0_, nd0,	"i,r,s")
	resetlevel(C0_,  c0,	"r,s,h")
	resetlevel(CD0_, cd0,	"i,r,s,h")
);

*	We want to remove the "rest" subregion from rb:

MD0_.FX(i,rb,"rest") = 0;

*	Assign the aggregate factor supply which enters the balancing
*	model by identifying which factor markets are active (pf_):

evom(f,r,s) = sum(h,evomh(f,r,s,h));

set	iter	Iterations for removing small values /iter0*iter10/;

*	Filter numbers which are 1e-6 or smaller when the values are extracted.  
*	Count the number of nonzeros in the resulting parameter, and fix to 
*	zero any variables which have been dropped.

*	a(d)	is the parameter.
*	a_.L(d)	is the corresponding calibration variable.

$macro	readsolution(a,b,d)	b(&&d) = a.L(&&d)$round(a.L(&&d),6); nz("&&a0") = card(b); a.FX(&&d)$(not b(&&d)) = 0;

set	v /vom,vafm,vfm,evomh,xn0,xd0,a0,md0,nd0,c0,cd0/;

parameter	nz(v)		Number of nonzeros
		iterlog(v,iter)	Iteration log,
		dev		Change in nonzeros /1/;

loop(iter$dev,
	dev = 0;

	resetlevel(VOM_, vom,	"g,r,s")
	resetlevel(VAFM_, vafm,"i,g,r,s")
	resetlevel(VFM_, vfm,	"f,g,r,s")
	resetlevel(EVOMH_, evomh,"f,r,s,h")
	resetlevel(XN0_, xn0,	"i,r,s")
	resetlevel(XD0_, xd0,	"i,r,s")
	resetlevel(A0_, a0,	"i,r,s")
	resetlevel(MD0_, md0,	"i,r,s")
	resetlevel(ND0_, nd0,	"i,r,s")
	resetlevel(C0_, c0,	"r,s,h")
	resetlevel(CD0_, cd0,	"i,r,s,h")

*	Set logical flags for the activities and markets which 
*	are in the model:

	loop(rb(r),
	  y_(g,rs(r,s)) = vom(g,rs);

*.	  vomrest(g) = vom(g,"usa","rest")
*.	  display vomrest;

	  x_(i,rs(r,s)) = vom(i,rs);
	  z_(i,rs(r,s)) = a0(i,rs);
	  c_(rs(r,s),h) = c0(rs,h);
	  ft_(sf,rs(r,s)) = evom(sf,rs);
	  m_(i,r) = vim(i,r);
	  yt_(j) = vtw(j);
	  pz_(i,rs(r,s)) = a0(i,rs);
	  p_(i,r) = sum(rs(r,s),xn0(i,r,s));
	  pc_(rs(r,s),h) = c0(rs,h);
	  pf_(f,rs(r,s)) = evom(f,rs);
	  ps_(sf,g,rs(r,s)) = vfm(sf,g,rs);
	  pm_(i,r) = vim(i,r);
	  pt_(j) = vtw(j);
	  rh_(rs(r,s),h) = c0(rs,h);

	  XD0_.FX(i,r,s)$(not z_(i,r,s)) = 0;
	  ND0_.FX(i,r,s)$(not z_(i,r,s)) = 0;
	  MD0_.FX(i,r,s)$(not z_(i,r,s)) = 0;	  

	  ND0_.FX(i,r,s)$(not p_(i,r)) = 0;
	  XN0_.FX(i,r,s)$(not p_(i,r)) = 0;
	  XN0_.FX(i,r,s)$(not x_(i,r,s)) = 0;

*	No factor inputs to investment or public expenditure:

	  VFM_.FX(f,"i",r,s) = 0;
	  VFM_.FX(f,"g",r,s) = 0;

*	Remove the aggregate region from the region being balanced:

	  VOM_.FX(g,r,"rest") = 0;
	  VAFM_.FX(i,g,r,"rest") = 0;
	  VFM_.FX(f,g,r,"rest") = 0;
	  EVOMH_.FX(f,r,"rest",h) = 0;
	  XN0_.FX(i,r,"rest") = 0;
	  XD0_.FX(i,r,"rest") = 0;
	  A0_.FX(i,r,"rest") = 0;
	  MD0_.FX(i,r,"rest") = 0;
	  ND0_.FX(i,r,"rest") = 0;
	  C0_.FX(r,"rest",h) = 0;
	  CD0_.fx(i,r,"rest",h) = 0;

	);

*	Use conopt if an infeasibility only shows up, otherwise
*	one of the LP codes is going to be faster:

	option qcp = cplex;
*.	option qcp=conopt;

	solve balance using qcp minimizing obj;

	abort$(balance.modelstat<>1) "Model balance fails to solve to optimality!";

	mktchk(p_(i,r),"xn0") = sum(x_(i,r,s),xn0(i,r,s));
	mktchk(p_(i,r),"nd0") = sum(z_(i,r,s),nd0(i,r,s));
	mktchk(p_(i,r),"vxmd") =sum(m_(i,rr),vxmd(i,r,rr));
	mktchk(p_(i,r),"vst") = vst(i,r);
	mktchk(p_(i,r),"chk") = sum(x_(i,r,s),xn0(i,r,s)) - ( sum(z_(i,r,s),nd0(i,r,s)) + sum(m_(i,rr),vxmd(i,r,rr)) + vst(i,r)$yt_(i) );
	option xn0:3:0:1;
	display mktchk, xn0;

*	Read the solution values and count nonzeros:

	loop(rb(r),
		readsolution(VOM_, vom,"g,r,s")
		readsolution(VAFM_, vafm,"i,g,r,s")
		readsolution(VFM_, vfm,"f,g,r,s")
		readsolution(EVOMH_, evomh,"f,r,s,h")
		readsolution(XN0_, xn0,"i,r,s")
		readsolution(XD0_, xd0,"i,r,s")
		readsolution(A0_, a0,"i,r,s")
		readsolution(MD0_, md0,"i,r,s")
		readsolution(ND0_, nd0,"i,r,s")
		readsolution(C0_, c0,"r,s,h")
		readsolution(CD0_, cd0,"i,r,s,h")

*	Assign evom to control pf_() in the next iteration:

		evom(f,r,s) = sum(rh_(r,s,h),EVOMH_.L(f,r,s,h));
	);

*	Report nonzero counts and continue if the numbers
*	have changed:

	iterlog(v,iter) = nz(v);
	dev = sum(v,abs(iterlog(v,iter-1)-nz(v)));
	option dev:0;
	display dev;
);
display iterlog;

parameter	revisedaccounts	Revised macro accounts;

loop(rb(r),
	revisedaccounts("C","$") = sum((s,h),c0(r,s,h));
	revisedaccounts("G","$") = sum(s,vom("g",r,s));
	revisedaccounts("I","$") = sum(s,vom("i",r,s));
	revisedaccounts("L","$") = sum((lf(f),s,h),evomh(lf,r,s,h));
	revisedaccounts("K","$") = sum((kf(f),s,h),evomh(kf,r,s,h));
	revisedaccounts("F","$") = vb(r);
	revisedaccounts("T","$") =  sum((i,rr), rtms(i,rr,r)*((1-rtxs(i,rr,r))*vxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))) - rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum((i,s), rtd(i,r,s)*(xd0(i,r,s)+nd0(i,r,s)) + rtm(i,r,s)*md0(i,r,s))
				+ sum((f,g), rtf(f,g,r)*sum(s,vfm(f,g,r,s)))
				+ sum(g, rto(g,r)*sum(s,vom(g,r,s)));

	revisedaccounts("GDP","$") = revisedaccounts("C","$") + revisedaccounts("G","$") + revisedaccounts("I","$") - revisedaccounts("F","$");
	revisedaccounts("GDP*","$") = revisedaccounts("L","$") + revisedaccounts("K","$") + revisedaccounts("T","$");
);
display revisedaccounts;


parameter	adjustment	Changes in aggregate values;
adjustment("$",g,"vom") = vom_rest(g) - sum(s,vom(g,"%rb%",s));
adjustment("$",i,"cd0") = cd0_rest(i) - sum((s,h),cd0(i,"%rb%",s,h));
adjustment("$",f,"evomh") = evomh_rest(f)-sum((s,h),evomh(f,"%rb%",s,h));
adjustment("$",f,"evom") = evom_rest(f) - sum(s,evom(f,"%rb%",s));

adjustment("%",g,"vom")$adjustment("$",g,"vom") = 100 * (sum(s,vom(g,"%rb%",s))/vom_rest(g) - 1);
adjustment("%",i,"cd0")$cd0_rest(i) = 100 * (sum((s,h),cd0(i,"%rb%",s,h))/cd0_rest(i) - 1);;
adjustment("%",f,"evomh")$evomh_rest(f) = 100 * (sum((s,h),evomh(f,"%rb%",s,h))/evomh_rest(f)-1);
adjustment("%",f,"evom")$evom_rest(f) = 100 * (sum(s,evom(f,"%rb%",s))/evom_rest(f) - 1);
option adjustment:3:2:1;
display adjustment;


rs(r,"rest") = yes$(not rb(r));
rs(rb,s) = yes$(not sameas(s,"rest"));

evom(f,r,s)$(not rs(r,s)) = 0;
evomh(f,r,s,h)$(not rs(r,s)) = 0;
evomh(f,r,s,h)$(not evom(f,r,s)) = 0;
vfm(sf,g,r,s)$(not rs(r,s)) = 0;
xd0(i,r,s)$(not rs(r,s)) = 0;
vom(g,r,s)$(not rs(r,s)) = 0;
xn0(i,r,s)$(not rs(r,s)) = 0;

set	g_(*), i_(*);
g_(g) = g(g);
i_(i) = i(i);
$if "%dropagr%"=="yes" g_("agr") = no; i_("agr") = no;


execute_unload '%dsout%',
	r,g_=g,i_=i,f,s,h,sf,mf,
	vom, vafm, vfm, xn0, xd0, a0,
	md0, nd0, c0, cd0, evom, evomh, 
	rtd, rtd0, rtm, rtm0, esube,
	etrndn, hhtrn0, sav0,
	rto, rtf, rtf0, vim, vxmd, pvxmd, pvtwr, rtxs, rtms, vtw, vtwr, vst, vb,
	esubva,  etrae, esubdm, esubm;

