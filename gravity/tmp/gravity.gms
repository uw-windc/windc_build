$title	Gravity Estimation Routine -- Single Sector PE Model in MPSGE

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	pd(*)	Port districts;

*.$if not set ds $abort "Need to have dataset defined by --ds=xxx";

$set ds mvh
$gdxin '%ds%.gdx'
$load r s pd

set		loc /set.s, set.pd/;

parameter	dist(s,loc)	Distances from state to state or port;
$load dist

alias (s,ss), (pd,ppd), (r,rr);

parameter
	y0(s)		Reference output (data)
	z0(s)		Reference demand (data)
	m0(r,pd)	Reference aggregate imports (data)
	x0(pd,r)	Reference aggregate exports (data),
	ms0(pd)		Aggregate imports by port (data),
	mb0(r)		Bilateral imports by region (data)
	xd0(pd)		Aggregate exports by port (data)
	xb0(r)		Bilateral exports by region (data);

$load y0 m0 x0 z0=d0

m0(r,pd)$(not round(m0(r,pd),3)) = 0;
x0(pd,r)$(not round(x0(pd,r),3)) = 0;

$ontext
y0(s) = 1e3 * y0(s);
z0(s) = 1e3 * z0(s);
m0(r,pd) = 1e3 * m0(r,pd);
x0(pd,r) = 1e3 * x0(pd,r);
$offtext

parameter
	bdref(s,s)	Reference intra-state demand (calibrated)
	mdref(pd,s)	Reference import demand (calibrated)
	eref(s,pd)	Reference exports (calibrated)

	tau_d(s,s)	Iceberg cost coefficient -- domestic trade
	tau_m(pd,s)	Iceberg cost coefficient -- imports
	tau_x(s,pd)	Iceberg cost coefficient -- exports

	pfxendow	Foreign exchange endowment -- for PE closure 

	lamda(s)	Scale parameter for absorption demand

	ytot		Total production
	mtot		Total imports
	xtot		Total exports
	ztot		Total absorption;

ytot = sum(s, y0(s));
mtot = sum((r,pd),m0(r,pd));
xtot = sum((pd,r),x0(pd,r));
ztot = sum(s,z0(s));

parameter	zscale	Demand scale factor;
zscale = (ytot + mtot - xtot)/ztot;
display zscale;
z0(s) = z0(s)*zscale;
ztot = sum(s,z0(s));

ms0(pd) = sum(r,m0(r,pd));
mb0(r) = sum(pd,m0(r,pd));
xd0(pd) = sum(r,x0(pd,r));
xb0(r) = sum(pd,x0(pd,r));

mdref(pd,s) = z0(s)  * ms0(pd)/ztot;
bdref(s,ss) = z0(ss) * (ytot-xtot)/ytot *y0(s)/ztot;
eref(s,pd)  = y0(s) * xtot/ytot * xd0(pd)/xtot;
display eref;
				
alias (u,*);
parameter	ymkt;
ymkt(s,"y0") = y0(s);
ymkt(s,"bdref") = sum(ss,bdref(s,ss));
ymkt(s,"eref") = sum(pd,eref(s,pd));
ymkt(s,"y0-bd-e") = y0(s) - sum(ss,bdref(s,ss)) - sum(pd,eref(s,pd));
display ymkt;

set	elast	Elasticities used for iceberg trade cost calculations /"3.0","4.0","5.0"/;

parameter
	epsilon			Elasticity of trade wrt trade cost /-1/,
	tau(s,*,elast)		Travel cost to closest port;

tau(s,"min",elast) = smin(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"max",elast) = smax(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"ave",elast) = sum(loc(pd),  dist(s,loc)**(epsilon/(1-elast.val)))/card(pd);
option tau:1:1:2;
display tau;

sets	z_(s), 
	pz_(s), py_(s), pm_(pd), 
	xd_(pd), fd_(s);
z_(s) = yes$z0(s);
pz_(s) = z_(s);
py_(s) = y0(s);
pm_(pd) = yes$ms0(pd);
xd_(pd) = yes$xd0(pd);
fd_(s) = yes$z0(s);

parameter	esubdm	/4/
		esubx	/4/;

pfxendow = sum(s,y0(s));

$ontext
$model:gravity

$sectors:
	Z(s)$z_(s)		! Absorption (Armington demand)

$commodities:
	PZ(s)$pz_(s)	! Demand price -- absorption in state s
	PY(s)$py_(s)	! Output price in state s
	PM(pd)$pm_(pd)  ! Price of imports from r in state s
	PFX		! Price level

$consumers:
	RA		! PE Closure Agent
	XD(pd)$xd_(pd)	! Export demand
	FD(s)$fd_(s)	! Final demand

$auxiliary:
	SY(s)$y0(s)	! Output supply
	SM(pd)$ms0(pd)	! Import supply

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z_(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*bdref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(pd)	q:(tau_m(pd,s)*mdref(pd,s))	p:(1/tau_m(pd,s))

$demand:RA
	  d:PFX
	  e:PFX		q:pfxendow
	  e:PY(s)$y0(s)		q:y0(s)		r:SY(s)
	  e:PM(pd)$pm_(pd)	q:ms0(pd)	r:SM(pd)

*	Value of exports through port pd:

$demand:XD(pd)$xd_(pd)  s:esubx
	d:PY(s)		q:(tau_x(s,pd)*eref(s,pd))	p:(1/tau_x(s,pd))
	e:PFX		q:xd0(pd)

$demand:FD(s)$fd_(s)
	  d:PZ(s)
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	SY(s)*PY(s) =e= PFX;

*	Supply of imports:

$constraint:SM(pd)$ms0(pd)
	SM(pd)*PM(pd) =e= PFX;

$offtext
$sysinclude mpsgeset gravity

SY.FX(s) = 1;
SM.FX(pd) = 1;

*	Benchmark replication:

lamda(s) = 1;
tau_d(ss,s) = 1;
tau_m(pd,s) = 1;
tau_x(s,pd) = 1;

$goto newmodel

GRAVITY.iterlim = 0;
$include GRAVITY.GEN
solve gravity using mcp;

parameter	solvelog	Solution log;

solvelog("objval","Benchmark") = gravity.objval;
solvelog("modelstat","Benchmark") = gravity.modelstat;
solvelog("solvestat","Benchmark") = gravity.solvestat;

tau_d(s,ss(loc)) = dist(s,loc)**(epsilon/(1-2*esubdm));
tau_m(pd(loc),s) = dist(s,loc)**(epsilon/(1-esubdm));
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-esubx));

parameter	tau_min(s)	Minimum value of tau;

tau_min(s)$z0(s) = min( 
	smin( ss$y0(ss), tau_d(ss,s)), 
	smin(pd$ms0(pd), tau_m(pd,s)) ) + eps;
display tau_min;

tau_d(ss,s)$z0(s) = tau_d(ss,s)/tau_min(s);
tau_m(pd,s)$z0(s) = tau_m(pd,s)/tau_min(s);
tau_x(s,pd(loc)) = tau_x(s,pd)/tau_min(s);

*	Scale productivity:

lamda(s)$z0(s) = sum(ss, tau_d(ss, s)*bdref(ss,s)/z0(s)) + 
		 sum(pd, tau_m(pd,s)*mdref(pd,s)/z0(s));

*	Incorporate targeting variable for domestic supply:

SY.UP(s) = +inf; SY.LO(s) = 0;
SY.FX(s)$(not y0(s)) = 0;

$onechov >path.opt
convergence_tolerance 1e-5
proximal_perturbation 0
crash_method pnewton
$offecho
GRAVITY.OPTFILE = 1;
GRAVITY.iterlim = 10000;

*	Include targeting variable for imports:

SM.UP(pd) = +inf; SM.LO(pd) = 0;
SM.FX(pd)$(not sum(r,m0(r,pd))) = 0;

GRAVITY.savepoint = 1;
$if exist %ds%_p.gdx execute_loadpoint '%ds%_p.gdx';

$include GRAVITY.GEN
solve gravity using mcp;

solvelog("objval",   "Gravity") = gravity.objval;
solvelog("modelstat","Gravity") = gravity.modelstat;
solvelog("solvestat","Gravity") = gravity.solvestat;
solvelog("modelstat","Gravity") = gravity.modelstat;
solvelog("resusd","Gravity") = gravity.resusd;

execute 'mv -f gravity_p.gdx %ds%_p.gdx';

display solvelog;
$exit


$label newmodel

set	x_(r);
x_(r) = sum(pd,x0(pd,r));

parameter	mref(r,pd,s)	Reference imports;
mref(r,pd,s) = z0(s) * m0(r,pd)/ztot;

set	pi_(r,pd)	Bilateral trade
	ms_(r,s)	Bilateral imports;
pi_(r,pd) = m0(r,pd);
ms_(r,s) = sum(pd,mref(r,pd,s));

parameter	lamda_m(r,s)	Scale parameter for import demand;
lamda_m(r,s) = 1;

$ontext
$model:gravity_new

$sectors:
	Z(s)$z_(s)		! Absorption (Armington demand)
	MS(r,s)$ms_(r,s)

$commodities:
	PZ(s)$pz_(s)		! Demand price -- absorption in state s
	PY(s)$py_(s)		! Output price in state s
	PI(r,pd)$pi_(r,pd)	! Import price
	PMS(r,s)$ms_(r,s)
	PFX			! Price level

$consumers:
	RA		! PE Closure Agent
	X(r)$x_(r)	! Export demand
	FD(s)$fd_(s)	! Final demand

$auxiliary:
	SY(s)$y0(s)	! Output supply
	BM(r)$mb0(r)	! Bilateral import multiplier

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z_(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*bdref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PMS(r,s)	q:(lamda_m(r,s)*sum(pd,mref(r,pd,s)))	mm:
	
$prod:MS(r,s)$ms_(r,s)
	o:PMS(r,s)	q:(lamda_m(r,s)*sum(pd,mref(r,pd,s)))
	i:PI(r,pd)	q:(tau_m(pd,s)*mref(r,pd,s))

$demand:RA
	  d:PFX
	  e:PFX			q:pfxendow
	  e:PY(s)$y0(s)		q:y0(s)		r:SY(s)
	  e:PI(r,pd)		q:m0(r,pd)	r:BM(r)

*	Value of exports through port pd:

$demand:X(r)$x_(r)  s:esubx   s.tl:0
	d:PY(s)#(pd)	q:(tau_x(s,pd)*eref(s,pd))	p:(1/tau_x(s,pd))  s.tl:
	e:PFX		q:(sum(pd,x0(pd,r)))

*	Final demand:

$demand:FD(s)$fd_(s)
	  d:PZ(s)
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	SY(s)*PY(s) =e= PFX;

*	Supply of imports from region r:

$constraint:BM(r)$mb0(r)
	BM(r)*sum(pi_(r,pd),m0(r,pd)*PI(r,pd)) =e= PFX*mb0(r);

$offtext
$sysinclude mpsgeset gravity_new

BM.FX(r) = 1;

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
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-esubx));

parameter	tau_min(s)	Minimum value of tau;
tau_min(s)$z0(s) = min( 
	smin( ss$y0(ss), tau_d(ss,s)), 
	smin(pd$ms0(pd), tau_m(pd,s)) ) + eps;
display tau_min;

tau_d(ss,s)$z0(s) = tau_d(ss,s)/tau_min(s);
tau_m(pd,s)$z0(s) = tau_m(pd,s)/tau_min(s);
tau_x(s,pd(loc)) = tau_x(s,pd)/tau_min(s);

*	Scale productivity:

lamda_m(r,s)$ms_(r,s) = sum(pd, tau_m(pd,s)*mref(r,pd,s))/sum(pd,mref(r,pd,s));
lamda(s)$z0(s) = ( sum(ss, tau_d(ss, s)*bdref(ss,s)) + 
		   sum(r,  lamda_m(r,s)*sum(pd,mref(r,pd,s))))/z0(s);

*	Incorporate targeting variable for domestic supply:

SY.UP(s) = +inf; SY.LO(s) = 0;
SY.FX(s)$(not y0(s)) = 0;

$onechov >path.opt
convergence_tolerance 1e-5
proximal_perturbation 0
crash_method pnewton
$offecho
GRAVITY_NEW.OPTFILE = 1;
GRAVITY_NEW.iterlim = 10000;

$ifthen.presolve not exist %ds%_p.gdx

$include GRAVITY_NEW.GEN
solve gravity_new using mcp;

solvelog("objval",   "Output") = gravity.objval;
solvelog("modelstat","Output") = gravity.modelstat;
solvelog("solvestat","Output") = gravity.solvestat;
solvelog("modelstat","Output") = gravity.modelstat;
solvelog("resusd","Output") = gravity.resusd;

$endif.presolve

gravity_new.savepoint = 1;
$if exist %ds%_p.gdx execute_loadpoint '%ds%_p.gdx';

*	Include targeting variable for imports:

BM.LO(r) = 0;
BM.UP(r) = +inf;
BM.FX(r)$(not mb0(r)) = 0;

$include GRAVITY_NEW.GEN
solve gravity_new using mcp;

solvelog("objval",   "Gravity") = gravity_new.objval;
solvelog("modelstat","Gravity") = gravity_new.modelstat;
solvelog("solvestat","Gravity") = gravity_new.solvestat;
solvelog("modelstat","Gravity") = gravity_new.modelstat;
solvelog("resusd","Gravity") = gravity_new.resusd;

execute 'mv -f gravity_new_p.gdx %ds%_p.gdx';

display solvelog;
