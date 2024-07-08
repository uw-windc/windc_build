$title	Alternative Formulation

parameter	mpsref(r,pd,s)	Reference imports;

$ontext
$model:bgravity

$sectors:
	Z(s)$z0(s)		! Absorption (Armington demand)
	M(r,s)$mref(r,s)

$commodities:
	PZ(s)$z0(s)		! Demand price -- absorption in state s
	PY(s)$y0(s)		! Output price in state s
	PI(r,pd)$md0(r,pd)	! Import price
	PMS(r,s)$mref(r,s)	! Import supply price
	PFX			! Price level

$consumers:
	RA			! PE Closure Agent
	BX(r)$x0(r)		! Export demand
	FD(s)$z0(s)		! Final demand

$auxiliary:
	SY(s)$y0(s)		! Output supply
	BM(r,pd)$md0(r,pd)	! Bilateral import multiplier

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z0(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PMS(r,s)	q:(lamda_m(r,s)*mref(r,s))	mm:
	
$report:
	v:PY_Z(ss,s)$(z0(s) and nref(ss,s))	i:PY(ss)	prod:Z(s)
	v:PMS_Z(r,s)$(z0(s) and mref(r,s))	i:PMS(r,s)	prod:Z(s)

$prod:M(r,s)$mref(r,s)  s:(2*esubdm)
	o:PMS(r,s)	q:(lamda_m(r,s)*mref(r,s))
	i:PI(r,pd)	q:(tau_m(pd,s)*mpsref(r,pd,s))  p:(1/tau_m(pd,s))

$demand:RA
	  d:PFX
	  e:PFX			q:pfxendow
	  e:PY(s)$y0(s)		q:y0(s)		r:SY(s)
	  e:PI(r,pd)		q:md0(r,pd)	r:BM(r,pd)

*	Value of exports through port pd:

$demand:BX(r)$x0(r)  s:(2*esubdm)
	d:PY(s)$y0(s)	q:(sum(pd,tau_x(s,pd)*xsref(s,pd)))
	e:PFX		q:x0(r)

$report:
	v:PY_BX(s,r)$(x0(r) and sum(pd,xsref(s,pd)))	 d:PY(s)	demand:BX(r)

*	Final demand:

$demand:FD(s)$z0(s)
	  d:PZ(s)	
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	SY(s)*PY(s) =e= PFX;

*	Supply of imports from region r:

$constraint:BM(r,pd)$md0(r,pd)
	BM(r,pd)*PI(r,pd) =e= PFX;

$offtext
$sysinclude mpsgeset bgravity

mdref(pd,s)  = z0(s)  * ms0(pd)/ztot;
nref(s,ss)   = z0(ss) * y0(s) * (ytot-xtot)/ytot /ztot;
xsref(s,pd)  = y0(s) *  xtot/ytot * xd0(pd)/xtot;
mpsref(r,pd,s) = z0(s) * md0(r,pd)/ztot;
mref(r,s) = z0(s) * m0(r) / ztot;

parameter	lamda_m(r,s)	Scale parameter for import demand;
lamda(s) = 1;
lamda_m(r,s) = 1;
tau_d(ss,s) = 1;
tau_m(pd,s) = 1;
tau_x(s,pd) = 1;


SY.FX(s) = 1;
BM.FX(r,pd) = 1;

bgravity.iterlim = 0;
bgravity.workspace=64;
$include BGRAVITY.GEN
solve bgravity using mcp;

parameter	solvelog	Solution log;
solvelog("b","objval","Benchmark") = bgravity.objval;
solvelog("b","modelstat","Benchmark") = bgravity.modelstat;
solvelog("b","solvestat","Benchmark") = bgravity.solvestat;

tau_d(s,ss(loc)) = dist(s,loc)**(epsilon/(1-2*esubdm));
tau_m(pd(loc),s) = dist(s,loc)**(epsilon/(1-esubdm));
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-2*esubdm));

tau_min(s)$z0(s) = min( 
	smin( ss$y0(ss), tau_d(ss,s)), 
	smin(pd$ms0(pd), tau_m(pd,s)) ) + eps;
display tau_min;

tau_d(ss,s)$z0(s) = tau_d(ss,s)/tau_min(s);
tau_m(pd,s)$z0(s) = tau_m(pd,s)/tau_min(s);
tau_x(s,pd(loc))  = tau_x(s,pd)/tau_min(s);

*	Scale productivity:

lamda_m(r,s)$mref(r,s) = sum(pd, tau_m(pd,s)*mpsref(r,pd,s))/mref(r,s);
lamda(s)$z0(s) = ( sum(ss, tau_d(ss, s)*nref(ss,s)) + 
		   sum(r,  lamda_m(r,s)*mref(r,s)) ) / z0(s);

*	Incorporate targeting variable for domestic supply:

SY.UP(s) = +inf; SY.LO(s) = 0;
SY.FX(s)$(not y0(s)) = 0;

bgravity.optfile = 1;
bgravity.iterlim = 10000;

$ifthen.presolvenew not exist bases\bgravity_%ds%_p.gdx

$include BGRAVITY.GEN
	solve bgravity using mcp;

	solvelog("b","objval",   "Output") = bgravity.objval;
	solvelog("b","modelstat","Output") = bgravity.modelstat;
	solvelog("b","solvestat","Output") = bgravity.solvestat;
	solvelog("b","modelstat","Output") = bgravity.modelstat;
	solvelog("b","resusd",   "Output") = bgravity.resusd;

$else.presolvenew

	execute_loadpoint 'bases\bgravity_%ds%_p.gdx';

$endif.presolvenew

*	Include targeting variable for imports:

BM.LO(r,pd) = 0;
BM.UP(r,pd) = +inf;
BM.FX(r,pd)$(not md0(r,pd)) = 0;

bgravity.savepoint = 1;

$include BGRAVITY.GEN
solve bgravity using mcp;

execute 'mv -f bgravity_p.gdx bases\bgravity_%ds%_p.gdx';

solvelog("b","objval",   "Gravity") = bgravity.objval;
solvelog("b","modelstat","Gravity") = bgravity.modelstat;
solvelog("b","solvestat","Gravity") = bgravity.solvestat;
solvelog("b","modelstat","Gravity") = bgravity.modelstat;
solvelog("b","resusd","Gravity")    = bgravity.resusd;

*	Verify consistency in the Armington model.

nref(ss,s) = PY_Z.L(ss,s)*PY.L(ss)/PFX.L;
mref(r,s)  = PMS_Z.L(r,s)*PMS.L(r,s)/PFX.L;
xref(s,r)  = PY_BX.L(s,r)*PY.L(s)/PFX.L;

execute_loadpoint 'armington_p.gdx';
ARMINGTON.iterlim = 0;
$include ARMINGTON.GEN
solve armington using mcp;

solvelog("b","objval",   "Armington") = Armington.objval;
solvelog("b","modelstat","Armington") = Armington.modelstat;
solvelog("b","solvestat","Armington") = Armington.solvestat;
solvelog("b","modelstat","Armington") = Armington.modelstat;

execute_unload 'datasets\b\%ds%.gdx',z0,nref,mref,x0,xref,y0,m0;

option solvelog:3:2:1;
display solvelog;

