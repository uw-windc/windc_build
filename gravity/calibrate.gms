$stitle	Code to Calibrate a GTAP Dataset

*	This macro is used to generate a least-squares objective with a linear penalty:

$macro	target(a,b,d,ds)  sum((&&ds), ( abs(a(&&d))*sqr(b(&&d)/a(&&d)-1) )$a(&&d) \
                                       + (penalty * b(&&d))$(not a(&&d)))

*	Macro for assigning the initial level for a variable to the target value, 
*	unfixing the variable and counting the number of nonzeors in the target parameter:

$macro	setlevel(a,b,d,ds)  a.L(&&d) = b(&&d); \
		a.LO(&&d) = 0; \
		a.UP(&&d) = +inf; \
		nzc(rb,"&&b") = sum((&&ds)$b(&&d),1);

*	Readsolution:

*	a.L(d)	is the calibration variable.
*	b(d)	is the corresponding parameter

*	Filter numbers which are 1e-%abstol% or smaller when the values are extracted.  

*	Count the number of nonzeros in the resulting parameter.


$macro	readsolution(a,b,d,ds)  b(&&d) = a.L(&&d)$round(a.L(&&d),%abstol%); itlog(rb,iter,"&&b") = sum((&&ds)$b(&&d),1);

parameter	penalty		Penalty on untargetted nonzero /1000/;

set	rb(r)	Region to balance;

variable	OBJ		Least squares objective;	

nonnegative
variables	VOM_(g,r)	Sectoral output
		VDFM_(i,g,r)	Domestic intermediate
		VIFM_(i,g,r)	Imported intermediate
		VFM_(f,g,r)	Factor demand,

		VDFM_P(i,g,r)	Domestic intermediate -- positive deviation
		VIFM_P(i,g,r)	Imported intermediate -- positive deviation
		VDFM_N(i,g,r)	Domestic intermediate -- negative deviation
		VIFM_N(i,g,r)	Imported intermediate -- negative deviation;


equations	objdef, dmarket, mmarket, profit, vdfm_target, vifm_target;

objdef..		OBJ =e= target(vom,  VOM_,  "g,r",   "g,rb(r)") +
				target(vdfm, VDFM_, "i,g,r", "i,g,rb(r)") +
				target(vifm, VIFM_, "i,g,r", "i,g,rb(r)") +
				target(vfm,  VFM_,  "f,g,r", "f,g,rb(r)") +

*	L1 penalties on emission-related deviations:

			penalty * (
				sum((i,g,rb(r)), (VDFM_P(i,g,r)+VDFM_N(i,g,r))$eco2d(i,g,r) ) +
				sum((i,g,rb(r)), (VIFM_P(i,g,r)+VIFM_N(i,g,r))$eco2i(i,g,r) ) );
				

dmarket(g(i),rb(r),s)$y_(g,r,s)..	VOM_(g,r,s) =e= XREF_(i,s)$bfm(i,r) + XS0_(i,r,s)$pnm(i,r) + 
							NS0_(i,r,s)$(pnm(i,r) and x_(i,r)) + 
							YL0_(i,r,s)$(pnm(i,r) and z_(i,r,s)) + 
							sum(ss,VDFM_(i,r,s,ss))$(bfm(i,r) and z_(i,r,ss));

mmarket(i,rb(r))..	vim(i,r) =e=	sum((i,r,s)$(pnm(i,r) and z_(i,r,s)), MD0_(i,r,s)) +
					sum((i,r,s)$(bnm(i,r) and z_(i,r,s)), VIFM_(i,r,s));

zmarket(i,rb(r),s)$z_(i,r,s)..

			A0_(i,r,s) =e=	sum(c_(r,s,h),CD0_(i,r,s,h)) + sum(y_(g,r,s),VAFM_(i,g,r,s))

zprofit(i,rb(r),s)$z_(i,r,s)..	A0_(i,r,s) =e=	( YL0_(i,r,s) + ND0_(i,r,s) + MD0_(i,r,s) )$pnm(i,r) +
						( sum(ss, VDFM_(i,r,ss,s)) + VIFM_(i,r,s) )$bnm(i,r);

yprofit(g,rb(r),s)$y_(g,r,s)..	VOM_(g,r,s)*(1-rto(g,r)) =e= 
				sum(i,VAFM_(i,g,r,s))
			     +  sum(f,VFM_(f,g,r,s)*(1+rtf(f,g,r)));


model gtapwindcbal /all/;


set	iter /iter0*iter10/;

parameter	dev(r)		Change in number of nonzeros /(set.r) 1 /,
		itlog(r,iter,*)	Iteration log
		nzc(r,*)	Nonzero count;

set		itsolve(iter,r)	Current iteration for each region /iter0.(set.r)/;


file ktitle; ktitle.lw=0; ktitle.nd=0; ktitle.nw=0; put ktitle;

*	Solve all the regions at once on the first pass:

rb(r) = yes;
vim(i,r) = sum(rr,vxmd(i,rr,r)*pvxmd(i,rr,r)+sum(j,vtwr(j,i,rr,r))*pvtwr(i,rr,r));

loop(iter$card(rb),

	setlevel(VOM_, vom, "g,rb",  "g");
	setlevel(VDFM_,vdfm,"i,g,rb","i,g");
	setlevel(VIFM_,vifm,"i,g,rb","i,g");
	setlevel(VFM_, vfm, "f,g,rb","f,g");

*	Fix inputs with associated emissions -- not feasible.  We have
*	introduced L1 penalties instead.

*.	VDFM_.FX(i,g,rb)$round(eco2d(i,g,rb)) = vdfm(i,g,rb);
*.	VIFM_.FX(i,g,rb)$round(eco2i(i,g,rb)) = vifm(i,g,rb);

*	No factor inputs to final demand:

	VFM_.FX(f,g,r)$(not j(g)) = 0;

	gtapbal.holdfixed = yes;
	option qcp=cplex;
	solve gtapbal using qcp minimizing OBJ;

	abort$(gtapbal.modelstat>2) "Calibration fails -- you will need to check this dataset more carefully";

	readsolution(VOM_, vom, "g,rb","g");
	readsolution(VDFM_,vdfm,"i,g,rb","i,g");
	readsolution(VIFM_,vifm,"i,g,rb","i,g");
	readsolution(VFM_, vfm, "f,g,rb","f,g");

	dev(rb) = sum(param, abs(itlog(rb,iter,param)-nzc(rb,param)));
	itlog(rb,iter,"dev")   = dev(rb);

$ondotl
	itlog(rb,iter,"OBJ.L") = target(vom,  VOM_,  "g,rb",   "g") +
				target(vdfm, VDFM_, "i,g,rb", "i,g") +
				target(vifm, VIFM_, "i,g,rb", "i,g") +
				target(vfm,  VFM_,  "f,g,rb", "f,g");

*	Drop regions which have converged:

	rb(r)$(rb(r) and (not dev(r))) = no;
);
option itlog:0:2:1;
display itlog;

*	Drop taxes for non-existent flows:

rto(g,r)$(not vom(g,r)) = 0;
rtf(f,g,r)$(not vfm(f,g,r)) = 0;
rtfd(i,g,r)$(not vdfm(i,g,r)) = 0;
rtfi(i,g,r)$(not vifm(i,g,r)) = 0;
rtxs(i,r,rr)$(not vxmd(i,r,rr)) = 0;
rtms(i,r,rr)$(not vxmd(i,r,rr)) = 0;

*	Adjust income and price elasticities to reflect changes in consumption
*	value shares:

parameter	thetac(i,r)	Final demand value shares;
alias (i,k);

*	Final consumption value shares:

thetac(i,r) = (vdfm(i,"c",r)*(1+rtfd(i,"c",r)) + vifm(i,"c",r)*(1+rtfi(i,"c",r))) /
	 sum(j,vdfm(j,"c",r)*(1+rtfd(j,"c",r)) + vifm(j,"c",r)*(1+rtfi(j,"c",r)));

*	Drop references to commodities with zero value shares:

subp(i,r)$(not thetac(i,r)) = 0;
incp(i,r)$(not thetac(i,r)) = 0;

*	Income elasticity of demand:

eta(i,r)$(not thetac(i,r)) = 0;
eta(i,r)$thetac(i,r) = subp(i,r) - sum(k,thetac(k,r)*subp(k,r)) + 
	(incp(i,r)*(1-subp(i,r)) + sum(k,thetac(k,r)*incp(k,r)*subp(k,r))) / 
	sum(k,thetac(k,r)*incp(k,r));

*	The Allen-Uzawa matrix of own- and cross-price elasticities
*	of substitution:

aues(i,j,r)$(not (thetac(i,r) and thetac(j,r))) = 0;
aues(i,j,r)$(thetac(i,r) and thetac(j,r)) = subp(i,r) + subp(j,r) 
		- sum(k,thetac(k,r)*subp(k,r))
		- (subp(i,r)/thetac(i,r))$sameas(i,j);
