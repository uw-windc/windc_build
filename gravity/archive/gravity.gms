$title	Gravity Estimation Routine -- Single Sector PE Model in MPSGE

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	pd(*)	Port districts;

*.$if not set ds $abort "Need to have dataset defined by --ds=xxx";

$set ds mvh
$gdxin '%ds%.gdx'
$load r s pd

alias (s,ss), (pd,ppd), (r,rr);

parameter
	y0(s)		Reference output (data)
	z0(s)		Reference demand (data)
	md0(r,pd)	Reference aggregate imports (data)
	xs0(pd,r)	Reference aggregate exports (data);

$load y0 md0=m0 xs0=x0 z0=d0

*	Filter tiny values:

md0(r,pd)$(not round(md0(r,pd),3)) = 0;
xs0(pd,r)$(not round(xs0(pd,r),3)) = 0;

parameter
	m0(r)		Import supply
	x0(r)		Export demand
	nref(s,s)	Intra-national trade
	mref(r,s)	Imports
	xref(s,r)	Exports;

m0(r) = sum(pd,md0(r,pd));
x0(r) = sum(pd,xs0(pd,r));

parameter	zscale	Demand scale factor;
zscale = (sum(s,y0(s)) + sum(r,m0(r)-x0(r)))/sum(s,z0(s));
display zscale;

z0(s) = z0(s)*zscale;

parameter	esubdm	Elasticity of substitution (domestic versus imports) /4/;

*	Create a template model illustrating what we are trying to estimate

*	Given y0, x0, m0 and z0, find values for nref, mref and xref which share 
*	the same total values.

$ontext
$model:ARMINGTON

$sectors:
	Z(s)$z0(s)	! Absorption (Armington demand)
	X(r)$x0(r)	! Exports

$commodities:
	PZ(s)$z0(s)	! Armington price
	PY(s)$y0(s)	! Output price
	PM(r)$m0(r)	! Import price
	PX(r)$x0(r)	! Export price

$consumers:
	RA		! Representative agent

$prod:Z(s)$z0(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm) nn(dn):(4*esubdm)
	o:PZ(s)		q:z0(s)
	i:PY(ss)	q:nref(ss,s)	dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(r)		q:mref(r,s)	mm:

$prod:X(r)$x0(r)
	o:PX(r)		q:x0(r)
	i:PY(s)		q:xref(s,r)

$demand:RA
	e:PY(s)		q:y0(s)
	e:PM(r)		q:m0(r)
	e:PX(r)		q:(-x0(r))
	d:PZ(s)		q:z0(s)

$offtext
$sysinclude mpsgeset ARMINGTON

*	Benchmark replication with symmetric assignment:

parameters
	ytot		Total production
	mtot		Total imports
	xtot		Total exports
	ztot		Total absorption;

ytot = sum(s, y0(s));
mtot = sum(r,m0(r));
xtot = sum(r,x0(r));
ztot = sum(s,z0(s));

nref(ss,s) = z0(s) * y0(ss)*(ytot-xtot)/ytot / ztot;
mref(r,s)  = z0(s) * m0(r) / ztot;
xref(s,r)  = x0(r) * y0(s) / ytot;

ARMINGTON.savepoint = 1;
ARMINGTON.iterlim = 0;
$include ARMINGTON.GEN
solve armington using mcp;
ARMINGTON.savepoint = 0;

set		loc	Locations (states and port districts) /set.s, set.pd/;

parameter	dist(s,loc)	Distances from states to locations;
$load dist

parameter
	tau_d(s,s)	Iceberg cost coefficient -- domestic trade
	tau_m(pd,s)	Iceberg cost coefficient -- import shipments from ports
	tau_x(s,pd)	Iceberg cost coefficient -- export shipments to ports

	pfxendow	Foreign exchange endowment -- for PE closure 

	lamda(s)	Scale parameter for absorption demand

	ms0(pd)		Import supply by port
	xd0(pd)		Export demand by port
	mdref(pd,s)	Import demand from port pd in state s
	xsref(s,pd)	Export supply from state s to port pd;

ms0(pd) = sum(r,md0(r,pd));
xd0(pd) = sum(r,xs0(pd,r));

mdref(pd,s)  = z0(s)  * ms0(pd)/ztot;
nref(s,ss)   = z0(ss) * y0(s) * (ytot-xtot)/ytot /ztot;
xsref(s,pd)  = y0(s) *  xtot/ytot * xd0(pd)/xtot;
				
set	elast	Elasticities used for iceberg trade cost calculations /"3.0","4.0","5.0"/;

parameter
	epsilon			Elasticity of trade wrt trade cost /-1/,

	tau(s,*,elast)		Travel cost to closest port;

tau(s,"min",elast) = smin(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"max",elast) = smax(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"ave",elast) = sum(loc(pd),  dist(s,loc)**(epsilon/(1-elast.val)))/card(pd);
option tau:1:1:2;
display tau;


$ontext
$model:gravity

$sectors:
	Z(s)$z0(s)	! Absorption (Armington demand)

$commodities:
	PZ(s)$z0(s)	! Armington price
	PY(s)$y0(s)	! Output price in state s
	PMD(pd)$ms0(pd)	! Price of imports at port pd
	PFX		! Price level

$consumers:
	RA		! PE Closure Agent
	XD(pd)$xd0(pd)	! Export demand
	FD(s)$z0(s)	! Final demand

$auxiliary:
	SY(s)$y0(s)	! Output supply
	SM(pd)$ms0(pd)	! Import supply

$prod:Z(s)$z0(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PMD(pd)	q:(tau_m(pd,s)*mdref(pd,s))	p:(1/tau_m(pd,s))

$report:
	v:PY_Z(ss,s)$(z0(s) and nref(ss,s))	i:PY(ss)	prod:Z(s)
	v:PMD_Z(pd,s)$(z0(s) and mdref(pd,s))	i:PMD(pd)	prod:Z(s)

$demand:XD(pd)$xd0(pd)  s:(2*esubdm)
	d:PY(s)		q:(tau_x(s,pd)*xsref(s,pd))	p:(1/tau_x(s,pd))
	e:PFX		q:xd0(pd)

$report:
	v:PY_XD(s,pd)$(xd0(pd) and xsref(s,pd))	 d:PY(s)	demand:XD(pd)

$demand:RA
	d:PFX
	e:PFX		q:pfxendow
	e:PY(s)		q:y0(s)		r:SY(s)
	e:PMD(pd)	q:ms0(pd)	r:SM(pd)

$demand:FD(s)$z0(s)
	  d:PZ(s)
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	PFX =e= SY(s)*PY(s);

*	Supply of imports:

$constraint:SM(pd)$ms0(pd)
	PFX =e= SM(pd)*PMD(pd);

$offtext
$sysinclude mpsgeset gravity
SY.FX(s) = 1;
SM.FX(pd) = 1;

*	Benchmark replication with symmetric assignment:

lamda(s) = 1;
tau_d(ss,s) = 1;
tau_m(pd,s) = 1;
tau_x(s,pd) = 1;
pfxendow = sum(s,y0(s));

GRAVITY.iterlim = 0;
$include GRAVITY.GEN
solve gravity using mcp;

parameter	solvelog	Solution log;
solvelog("objval","Benchmark") = gravity.objval;
solvelog("modelstat","Benchmark") = gravity.modelstat;
solvelog("solvestat","Benchmark") = gravity.solvestat;

tau_d(s,ss(loc)) = dist(s,loc)**(epsilon/(1-2*esubdm));
tau_m(pd(loc),s) = dist(s,loc)**(epsilon/(1-  esubdm));
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-2*esubdm));

parameter	tau_min(s)	Minimum value of tau;
tau_min(s)$z0(s) = min( 
	smin( ss$y0(ss), tau_d(ss,s)), 
	smin(pd$ms0(pd), tau_m(pd,s)) ) + eps;
display tau_min;

tau_d(ss,s)$z0(s) = tau_d(ss,s)/tau_min(s);
tau_m(pd,s)$z0(s) = tau_m(pd,s)/tau_min(s);
tau_x(s,pd(loc)) = tau_x(s,pd)/tau_min(s);

*	Scale productivity:

lamda(s)$z0(s) = sum(ss, tau_d(ss, s)*nref(ss,s)/z0(s)) + 
		 sum(pd, tau_m(pd,s)*mdref(pd,s)/z0(s));

$onechov >path.opt
convergence_tolerance 1e-5
proximal_perturbation 0
crash_method pnewton
$offecho

GRAVITY.OPTFILE = 1;
GRAVITY.iterlim = 10000;

$ifthen.presolve not exist gravity_%ds%_p.gdx

$include GRAVITY.GEN
	solve gravity using mcp;

*	Incorporate targeting variable for domestic supply:
	SY.UP(s) = +inf; SY.LO(s) = 0;
	SY.FX(s)$(not y0(s)) = 0;
$include GRAVITY.GEN
	solve gravity using mcp;

$else.presolve

	SY.UP(s) = +inf; SY.LO(s) = 0;
	SY.FX(s)$(not y0(s)) = 0;

	execute_loadpoint 'gravity_%ds%_p.gdx';

$endif.presolve

*	Include targeting variable for imports:

SM.UP(pd) = +inf; SM.LO(pd) = 0;
SM.FX(pd)$(not ms0(pd)) = 0;

$include GRAVITY.GEN
solve gravity using mcp;

solvelog("objval",   "Gravity") = gravity.objval;
solvelog("modelstat","Gravity") = gravity.modelstat;
solvelog("solvestat","Gravity") = gravity.solvestat;
solvelog("modelstat","Gravity") = gravity.modelstat;
solvelog("resusd","Gravity") = gravity.resusd;
display solvelog;

execute 'mv -f gravity_p.gdx gravity_%ds%_p.gdx';

*	Verify consistency in the Armington model.

nref(ss,s) = PY_Z.L(ss,s)*PY.L(ss)/PFX.L;
mref(r,s)  = sum(pd$ms0(pd), PMD_Z.L(pd,s)*PMD.L(pd)/PFX.L*md0(r,pd)/ms0(pd));
xref(s,r)  = sum(pd$xd0(pd), PY_XD.L(s,pd)*PY.L(s)/PFX.L*xs0(pd,r)/xd0(pd));

execute_loadpoint 'armington_p.gdx';

ARMINGTON.iterlim = 0;
$include ARMINGTON.GEN
solve armington using mcp;


parameter	mpsref(r,pd,s)	Reference imports;

$ontext
$model:gravity_new

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
	RA		! PE Closure Agent
	BX(r)$x0(r)	! Export demand
	FD(s)$z0(s)	! Final demand

$auxiliary:
	SY(s)$y0(s)		! Output supply
	BM(r,pd)$md0(r,pd)	! Bilateral import multiplier

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z0(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PMS(r,s)	q:(lamda_m(r,s)*mref(r,s))	mm:
	
$prod:M(r,s)$mref(r,s)  s:1
	o:PMS(r,s)	q:(lamda_m(r,s)*mref(r,s))
	i:PI(r,pd)	q:(tau_m(pd,s)*mpsref(r,pd,s))  p:(1/tau_m(pd,s))

$demand:RA
	  d:PFX
	  e:PFX			q:pfxendow
	  e:PY(s)$y0(s)		q:y0(s)		r:SY(s)
	  e:PI(r,pd)		q:md0(r,pd)	r:BM(r,pd)

*	Value of exports through port pd:

$demand:BX(r)$x0(r)  s:(2*esubdm)   s.tl:1
	d:PY(s)#(pd)	q:(tau_x(s,pd)*xsref(s,pd))	p:(1/tau_x(s,pd))  s.tl:
	e:PFX		q:x0(r)

*	Final demand:

$demand:FD(s)$z0(s)
	  d:PZ(s)	
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	PFX =e= SY(s)*PY(s);

*	Supply of imports from region r:

$constraint:BM(r,pd)$md0(r,pd)
	PFX =e= BM(r,pd)*PI(r,pd);

$offtext
$sysinclude mpsgeset gravity_new

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

GRAVITY_new.iterlim = 0;
GRAVITY_new.workspace=64;
$include GRAVITY_new.GEN
solve gravity_new using mcp;

parameter	solvelog	Solution log;
solvelog("objval","Benchmark") = gravity.objval;
solvelog("modelstat","Benchmark") = gravity.modelstat;
solvelog("solvestat","Benchmark") = gravity.solvestat;

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

GRAVITY_NEW.OPTFILE = 1;
GRAVITY_NEW.iterlim = 10000;

$ifthen.presolvenew not exist %ds%_p.gdx

$include GRAVITY_NEW.GEN
	solve gravity_new using mcp;

	solvelog("objval",   "Output") = gravity.objval;
	solvelog("modelstat","Output") = gravity.modelstat;
	solvelog("solvestat","Output") = gravity.solvestat;
	solvelog("modelstat","Output") = gravity.modelstat;
	solvelog("resusd","Output") = gravity.resusd;

$else.presolvenew

	execute_loadpoint '%ds%_p.gdx';

$endif.presolvenew

gravity_new.savepoint = 1;

*	Include targeting variable for output and imports:

SY.UP(s) = +inf; SY.LO(s) = 0;
SY.FX(s)$(not y0(s)) = 0;

BM.LO(r,pd) = 0;
BM.UP(r,pd) = +inf;
BM.FX(r,pd)$(not md0(r,pd)) = 0;

$include GRAVITY_NEW.GEN
solve gravity_new using mcp;

solvelog("objval",   "Gravity") = gravity_new.objval;
solvelog("modelstat","Gravity") = gravity_new.modelstat;
solvelog("solvestat","Gravity") = gravity_new.solvestat;
solvelog("modelstat","Gravity") = gravity_new.modelstat;
solvelog("resusd","Gravity") = gravity_new.resusd;
execute 'mv -f gravity_new_p.gdx %ds%_p.gdx';
display solvelog;
