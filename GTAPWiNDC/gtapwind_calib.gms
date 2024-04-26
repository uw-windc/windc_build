
*	Calibrate markets for international transport services:

vtw(j)   = sum((i,r,rr),vtwr(j,i,r,rr));

*	Careful here as this may affect all regions in the dataset,
*	not just the US.  However, this should already be balanced
*	and there should be no change:

vst(j,r)$sum(rr,vst(j,rr)) = vst(j,r) * vtw(j)/sum(rr,vst(j,rr));

*	Calibrate international imports:
vxm(i,r) = sum(rr,vxmd(i,r,rr)) + vst(i,r);

*	Calibrate imports from the national market:
vnm(i,r) = sum(z_(i,r,s),nd0(i,r,s));

*	Calibrate CIF imports:
vim(i,r) = sum(rr,vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r)*pvtwr(i,rr,r)));

*	Calibrate household expenditure and savings:
evomh(f,r,s,h)$sum(h.local,evomh(f,r,s,h))
	= evomh(f,r,s,h) * sum(g,vfm(f,g,r,s))/sum(h.local,evomh(f,r,s,h));
c0(r,s,h) = sum(i,cd0(i,r,s,h));
sav0(r,s,h) = sum(f,evomh(f,r,s,h)) + sum(trn,hhtrn0(r,s,h,trn)) - c0(r,s,h);

variable	OBJ		Objective function;

nonnegative
variables	NS0_(i,r,s)	Region supply to the national market 
		ND0_(i,r,s)	Regional demand from national market,

		XS0_(i,r,s)	Export supply
		MD0_(i,r,s)	Import demand

		VOM_(g,r,s)	Total supply at market prices,
		YL0_(i,r,s)	Local domestic absorption,
		VFM_(f,g,r,s)	Factor demand at market prices,
		VAFM_(i,g,r,s)	Intermediate demand,

		A0_(i,r,s)	Absorption,

		GOVT(r)		Government income;

parameter	thetag(r,s)	Subregion share;
thetag(r,s) = vom("g",r,s)/sum(s.local, vom("g",r,s));

parameter	penalty	Penalty on untargetted nonzero /1000/;

*	This macro is used to generate a least-squares objective with a linear penalty:

$macro	target(a,b,d,ds)  sum((&&ds), ( abs(a(&&d))*sqr(b(&&d)/a(&&d)-1) )$a(&&d) \
                                       + (penalty * b(&&d))$(not a(&&d)))

*	Macro for unfixing a variable and assigning the target level value:

$macro	setlevel(a,b,d,ds)  a.L(&&d) = b(&&d); \
		a.LO(&&d) = 0; \
		a.UP(&&d) = +inf; \
		nzc(r,"&&b") = sum((&&ds)$b(&&d),1);

*	Filter numbers which are 1e-6 or smaller when the values are extracted.  

*	Count the number of nonzeros in the resulting parameter, and fix to 
*	zero any variables which have been dropped.

*	a(d)	is the parameter.
*	a_.L(d)	is the corresponding calibration variable.

set		iter	Iterations /iter0*iter5/;

parameter	itlog(r,iter,*)		Iteration log;

$macro	readsolution(a,b,d,ds)  b(&&d) = a.L(&&d)$round(a.L(&&d),%abstol%); itlog(rb,iter,"&&b") = sum((&&ds)$b(&&d),1);

set		rb(r)	Region to balance /usa/;

equations	objdef, 
		market_py, market_pn, market_pz, market_pm, market_pl, market_ps, 
		profit_y, profit_z, govtincome;

objdef..	OBJ =e= target(ns0, NS0_, "i,r,s", "i,rb(r),s") +
			target(nd0, ND0_, "i,r,s", "i,rb(r),s") +
			target(xs0, XS0_, "i,r,s", "i,rb(r),s") +
			target(md0, MD0_, "i,r,s", "i,rb(r),s") +
			target(vom, VOM_, "g,r,s", "g,rb(r),s") +
			target(yl0, YL0_, "i,r,s", "i,rb(r),s") +
			target(vfm, VFM_, "f,g,r,s", "f,g,rb(r),s") +
			target(vafm, VAFM_, "i,g,r,s", "i,g,rb(r),s") +
			target(a0,  A0_,  "i,r,s",  "i,rb(r),s");

market_py(y_(g,rb(r),s))..
		VOM_(g,r,s) =e= sum(i(g),
					sum(x_(i,r),	XS0_(i,r,s)) + 
					sum(n_(i,r),	NS0_(i,r,s)) + 
					sum(z_(i,r,s),	YL0_(i,r,s))) 

				+ (vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))$sameas(g,"i") 

				+ (GOVT(r)*thetag(r,s))$sameas(g,"g") ;


govtincome(r)..	GOVT(r) =e= - sum((i,rr),rtxs(i,r,rr)*vxmd(i,r,rr))
			+ sum((i,rr),rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r))) 
			+ sum(z_(i,r,s), MD0_(i,r,s)*rtm(i,r,s) + (ND0_(i,r,s)+YL0_(i,r,s))*rtd(i,r,s)) 
			+ sum((f,g,s),vfm(f,g,r,s)*rtf(f,g,r));

market_pn(pn_(i,rb(r)))..	sum((n_(i,r),s),NS0_(i,r,s)) =e= sum(z_(i,r,s),ND0_(i,r,s));

market_pz(pz_(i,rb(r),s))..	A0_(i,r,s) =e= sum(y_(g,r,s),VAFM_(i,g,r,s)) + sum(c_(r,s,h),cd0(i,r,s,h));

market_pm(pm_(i,rb(r)))..	sum(s,MD0_(i,r,s)) =e= vim(i,r);

market_pl(pf_(mf,rb(r),s))..	sum(h,evomh(mf,r,s,h)) =e= sum(g,VFM_(mf,g,r,s));

market_ps(sf,rb(r))..	sum((h,s),evomh(sf,r,s,h)) =e= sum((g,s),VFM_(sf,g,r,s));

profit_y(y_(y_(g,rb(r),s)))..  VOM_(g,r,s)*(1-rto(g,r)) =e= sum(i,VAFM_(i,g,r,s)) + 
				sum(f,VFM_(f,g,r,s)*(1+rtf(f,g,r)));

profit_z(z_(i,rb(r),s))..  A0_(i,r,s) =e= (1+rtd(i,r,s))*(YL0_(i,r,s)+ND0_(i,r,s)) + (1+rtm(i,r,s))*MD0_(i,r,s);

model	calib /	objdef, 
		market_py, market_pn, market_pz, market_pm, market_pl, market_ps, 
		profit_y, profit_z,
		govtincome /;

GOVT.L(r) = sum(s,vom("g",r,s));

parameter	nzc(r,*)	Nonzero counts;

setlevel(NS0_, ns0, "i,r,s", "i,rb(r),s") 
setlevel(ND0_, nd0, "i,r,s", "i,rb(r),s") 
setlevel(XS0_, xs0, "i,r,s", "i,rb(r),s") 
setlevel(MD0_, md0, "i,r,s", "i,rb(r),s") 
setlevel(VOM_, vom, "g,r,s", "g,rb(r),s") 
setlevel(YL0_, yl0, "i,r,s", "i,rb(r),s") 
setlevel(VFM_, vfm, "f,g,r,s", "f,g,rb(r),s") 
setlevel(VAFM_, vafm, "i,g,r,s", "i,g,rb(r),s") 
setlevel(A0_,  a0,  "i,r,s",  "i,rb(r),s")

parameter chk_market_py, chk_market_pn, chk_market_pz, chk_market_pm, chk_market_pl, chk_market_ps,
	chk_profit_y, chk_profit_z, chk_govtincome;

$onecho >%gams.scrdir%chkmodel.gms
$ondotl
chk_market_py(y_(g,rb(r),s)) = 
		VOM_(g,r,s) - ( sum(i(g),
					sum(x_(i,r),	XS0_(i,r,s)) + 
					sum(n_(i,r),	NS0_(i,r,s)) + 
					sum(z_(i,r,s),	YL0_(i,r,s))) 

				+ (vb(r)+sum(rh_(r,s,h),sav0(r,s,h)))$sameas(g,"i") 

				+ (GOVT(r)*thetag(r,s))$sameas(g,"g") );


chk_govtincome(r) =	GOVT(r) - ( - sum((i,rr),rtxs(i,r,rr)*vxmd(i,r,rr))
			+ sum((i,rr),rtms(i,rr,r)*(sum(j,vtwr(j,i,rr,r))+(1-rtxs(i,rr,r))*vxmd(i,rr,r))) 
			+ sum(z_(i,r,s), MD0_(i,r,s)*rtm(i,r,s) + (ND0_(i,r,s)+YL0_(i,r,s))*rtd(i,r,s)) 
			+ sum((f,g,s),vfm(f,g,r,s)*rtf(f,g,r)) );

chk_market_pn(pn_(i,rb(r))) =	sum((n_(i,r),s),NS0_(i,r,s)) - sum(z_(i,r,s),ND0_(i,r,s));

chk_market_pz(pz_(i,rb(r),s)) =	A0_(i,r,s) - (sum(y_(g,r,s),VAFM_(i,g,r,s)) + sum(c_(r,s,h),cd0(i,r,s,h)));

chk_market_pm(pm_(i,rb(r))) = sum(s,MD0_(i,r,s)) - vim(i,r);

chk_market_pl(pf_(mf,rb(r),s)) = sum(h,evomh(mf,r,s,h)) - sum(g,VFM_(mf,g,r,s));

chk_market_ps(sf,rb(r)) = sum((h,s),evomh(sf,r,s,h)) - sum((g,s),VFM_(sf,g,r,s));

chk_profit_y(y_(y_(g,rb(r),s))) =  VOM_(g,r,s)*(1-rto(g,r)) - ( sum(i,VAFM_(i,g,r,s)) + 
				sum(f,VFM_(f,g,r,s)*(1+rtf(f,g,r))) );

chk_profit_z(z_(i,rb(r),s)) =  A0_(i,r,s) - ( (1+rtd(i,r,s))*(YL0_(i,r,s)+ND0_(i,r,s)) + (1+rtm(i,r,s))*MD0_(i,r,s));
$offecho