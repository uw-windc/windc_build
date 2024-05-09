$title	Code for Model Calibration

variable	OBJ		Objective function;

nonnegative
variables	NS0_(i,r,s)	Region supply to the national market 
		ND0_(i,r,s)	Regional demand from national market,

		XS0_(i,r,s)	Export supply
		MD0_(i,r,s)	Import demand

		VOM_(g,r,s)	Total supply at market prices,
		VFM_(f,g,r,s)	Factor demand at market prices,
		VAFM_(i,g,r,s)	Intermediate demand,

		A0_(i,r,s)	Absorption;

parameter	penalty	Penalty on untargetted nonzero /1000/;

*	This macro is used to generate a least-squares objective with a linear penalty:

$macro	target(a,b,d,ds)  sum((&&ds), ( abs(a(&&d))*sqr(b(&&d)/a(&&d)-1) )$a(&&d) \
                                       + (penalty * b(&&d))$(not a(&&d)))

*	Macro for unfixing a variable and assigning the target level value:

$macro	setlevel(a,b,d,ds)  a.L(&&d) = b(&&d); \
		a.LO(&&d) = 0; a.UP(&&d) = +inf; \
		nzc("&&b") = sum((&&ds)$b(&&d),1);

*	Filter numbers which are 1e-6 or smaller when the values are extracted.  

*	Count the number of nonzeros in the resulting parameter, and fix to 
*	zero any variables which have been dropped.

*	a(d)	is the parameter.
*	a_.L(d)	is the corresponding calibration variable.

set		iter	Iterations /iter0*iter5/;

parameter	itlog(iter,*)		Iteration log;

$macro	readsolution(a,b,d,ds)  b(&&ds) = a.L(&&d)$round(a.L(&&d),%abstol%); itlog(iter,"&&b") = sum((&&ds)$b(&&d),1);

equations	objdef, 
		market_pg, market_py, market_pn, market_pz, market_pm, market_pl, market_ps, 
		profit_y, profit_z, profit_x;

objdef..	OBJ =e= target(ns0, NS0_,	"i,r,s",   "i,rb(r),s") +
			target(nd0, ND0_,	"i,r,s",   "i,rb(r),s") +
			target(xs0, XS0_,	"i,r,s",   "i,rb(r),s") +
			target(md0, MD0_,	"i,r,s",   "i,rb(r),s") +
			target(vom, VOM_,	"g,r,s",   "g,rb(r),s") +
			target(vfm, VFM_,	"f,g,r,s", "f,g,rb(r),s") +
			target(vafm, VAFM_,	"i,g,r,s", "i,g,rb(r),s") +
			target(a0,  A0_,	"i,r,s",   "i,rb(r),s");

market_pg(rb(r))..		sum(s,VOM_("g",r,s)) =e=
				- sum((i,rr),		rtxs(i,r,rr)*vxmd(i,r,rr))
				+ sum(m_(i,rr),		rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r)))
				+ sum(z_(i,r,s),	rtd(i,r,s) * ND0_(i,r,s) + rtm(i,r,s)*MD0_(i,r,s))
				+ sum((g,s),		rto(g,r)   * VOM_(g,r,s))
				+ sum((f,y_(g,r,s)),	rtf(f,g,r) * VFM_(f,g,r,s))
				- sum((rh_(r,s.local,h),trn),hhtrn0(r,s,h,trn));

market_py(y_(i,rb(r),s))..	VOM_(i,r,s) =e= sum(x_(i,r), XS0_(i,r,s)) + sum(n_(i,r), NS0_(i,r,s));

market_pn(pn_(i,rb(r)))..	sum((n_(i,r),s),NS0_(i,r,s)) =e= sum(z_(i,r,s),ND0_(i,r,s));

market_pz(pz_(i,rb(r),s))..	A0_(i,r,s) =e= sum(y_(g,r,s),VAFM_(i,g,r,s)) + sum(c_(r,s,h),cd0(i,r,s,h));

market_pm(pm_(i,rb(r)))..	sum(s,MD0_(i,r,s)) =e= vim(i,r);

market_pl(pf_(mf,rb(r),s))..	sum(h,evomh(mf,r,s,h)) =e= sum(g,VFM_(mf,g,r,s));

market_ps(sf,rb(r))..		sum((h,s),evomh(sf,r,s,h)) =e= sum((g,s),VFM_(sf,g,r,s));

profit_y(y_(y_(g,rb(r),s)))..	VOM_(g,r,s)*(1-rto(g,r)) =e= sum(i,VAFM_(i,g,r,s)) + sum(f,VFM_(f,g,r,s)*(1+rtf(f,g,r)));

profit_z(z_(i,rb(r),s))..	A0_(i,r,s) =e= (1+rtd(i,r,s))*ND0_(i,r,s) + (1+rtm(i,r,s))*MD0_(i,r,s);

profit_x(x_(i,rb(r)))..		sum(s, XS0_(i,r,s)) =e= vxm(i,r);

model	calib /	objdef, 
		market_pg, market_py, market_pn, market_pz, market_pm, market_pl, market_ps, 
		profit_y, profit_z, profit_x /;

set	param /ns0, nd0, xs0, md0, vom, vfm, vafm, a0/;

parameter	nzc(param)	Nonzero counts;

calib.holdfixed = yes;

parameter	dev	Deviation (change in nonzero count);

*	

vxm(i,rb(r)) = vst(i,r) + sum(rr,vxmd(i,r,rr));
vim(i,rb(r)) = sum(rr, vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));

parameter	pgchk(iter)	Cross check on PG market;

dev = 1;
loop(iter$dev,
	setlevel(NS0_, ns0, "i,r,s", "i,rb(r),s") 
	setlevel(ND0_, nd0, "i,r,s", "i,rb(r),s") 
	setlevel(XS0_, xs0, "i,r,s", "i,rb(r),s") 
	setlevel(MD0_, md0, "i,r,s", "i,rb(r),s") 
	setlevel(VOM_, vom, "g,r,s", "g,rb(r),s") 
	setlevel(VAFM_, vafm, "i,g,r,s", "i,g,rb(r),s") 
	setlevel(A0_,  a0,  "i,r,s",  "i,rb(r),s")
	setlevel(VFM_, vfm, "f,g,r,s", "f,g,rb(r),s") 

	vfm(f,g,r,s)$(not vom(g,r,s)) = 0;
	evom(sf,r,s) = sum(g,vfm(sf,g,r,s));

	NS0_.FX(i,rb(r),"rest") = 0;
	ND0_.FX(i,rb(r),"rest") = 0;
	XS0_.FX(i,rb(r),"rest") = 0;
	MD0_.FX(i,rb(r),"rest") = 0;
	VOM_.FX(g,rb(r),"rest") = 0;
	VFM_.FX(f,g,rb(r),"rest") = 0;
	VAFM_.FX(i,g,rb(r),"rest") = 0;
	A0_.FX(i,rb(r),"rest") = 0;

	VOM_.FX("i",rb(r),s) = vom("i",r,s);
	XS0_.FX(i,rb(r),s)$(not y_(i,r,s)) = 0;
	NS0_.FX(i,rb(r),s)$(not y_(i,r,s)) = 0;

	option qcp = cplex;
	solve calib using qcp minimizing obj;

	abort$(calib.modelstat>2) "Calibration fails -- you will need to check this dataset more carefully";

	readsolution(NS0_, ns0, "i,r,s", "i,rb(r),s")
	readsolution(ND0_, nd0, "i,r,s", "i,rb(r),s")
	readsolution(XS0_, xs0, "i,r,s", "i,rb(r),s")
	readsolution(MD0_, md0, "i,r,s", "i,rb(r),s")
	readsolution(VOM_, vom, "g,r,s", "g,rb(r),s")
	readsolution(VFM_, vfm, "f,g,r,s", "f,g,rb(r),s")
	readsolution(VAFM_, vafm, "i,g,r,s", "i,g,rb(r),s")
	readsolution(A0_,  a0,  "i,r,s",  "i,rb(r),s")


	y_(g,r,s) = vom(g,r,s);
	x_(i,r) = vxm(i,r);
	n_(i,r) = vnm(i,r);
	pn_(i,r) = n_(i,r);
	z_(i,r,s) = a0(i,r,s);
	c_(r,s,h) = c0(r,s,h);
	ft_(sf,r,s) = evom(sf,r,s);
	m_(i,r) = vim(i,r);
	yt_(j) = vtw(j);
	py_(g,r,s) = vom(g,r,s);
	pz_(i,r,s) = a0(i,r,s);
	pc_(r,s,h) = c0(r,s,h);
	pf_(f,r,s) = evom(f,r,s);
	ps_(sf,g,r,s) = vfm(sf,g,r,s);
	pm_(i,r) = vim(i,r);
	pt_(j) = vtw(j);
	rh_(r,s,h) = c0(r,s,h);



	dev =	sum(param, abs(itlog(iter,param)-nzc(param)));
	itlog(iter,"dev")   = dev;

);

display itlog;


