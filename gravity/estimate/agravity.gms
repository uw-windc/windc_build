$title	Gravity Estimation Routine -- Aggregate 

*	Define a single sector to estimate here:

$if not set ds $set ds alt

*	Two estimation methods have been implemented. This is a.

*		a	"Aggregate gravity" model which calibrates to 
*			aggregate import and export flows by port

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	pd(*)	Port districts;

$gdxin 'datasets\%ds%.gdx'
$load r s pd

*	Read economic data:

parameter
	y0(s)		Reference output (data)
	z0(s)		Reference demand (data)
	md0(r,pd)	Reference aggregate imports (data)
	xs0(pd,r)	Reference aggregate exports (data),
	td0(s)		Domestic tax,
	tm0(s)		Import tax;

$load y0 md0 xs0 z0 td0=td tm0=tm

*	Read geographic distances:

set		loc	Locations (states and port districts) /set.s, set.pd/;
parameter	dist(s,loc)	Distances from states to locations;
$gdxin 'datasets\geography.gdx'
$load dist
$gdxin

dist("dc","dc") = 1;

alias (s,ss), (r,rr);

*	Filter tiny values:

display "Before filter:", md0, xs0;
md0(r,pd)$(not round(md0(r,pd),3)) = 0;
xs0(pd,r)$(not round(xs0(pd,r),3)) = 0;
display "After filter:", md0, xs0;

parameter
	m0(r)		Import supply
	x0(r)		Export demand
	nref(s,s)	Intra-national trade
	mref(r,s)	Imports
	xref(s,r)	Exports,
	td(s)		Domestic tax,
	tm(s)		Import tax;

m0(r) = sum(pd,md0(r,pd));
x0(r) = sum(pd,xs0(pd,r));

parameter	zscale	Demand scale factor;
zscale = (sum(s,y0(s)) + sum(r,m0(r)-x0(r)))/sum(s,z0(s));
display zscale;
z0(s) = z0(s)*zscale;

parameter	
	esubdm	Elasticity of substitution (domestic versus imports) /4/,
	esubmm	Elasticity across imports
	esubdn	Elasticity local versus other domestic
	esubnn	Elasticity among other domestic
	esubx	Elasticity between exports;

esubmm = 2 * esubdm;
esubdn = 2 * esubdm;
esubnn = 4 * esubdm;
esubx = 2 * esubdm;

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

$prod:Z(s)$z0(s)  s:esubdm mm:esubmm  dn:esubdn nn(dn):esubnn
	o:PZ(s)		q:z0(s)
	i:PY(ss)	q:nref(ss,s)	dn:$sameas(s,ss) nn:$(not sameas(s,ss))  a:RA t:td(s)
	i:PM(r)		q:mref(r,s)	mm:  a:RA t:tm(s)

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
td(s) = 0;
tm(s) = 0;

ARMINGTON.savepoint = 1;
ARMINGTON.iterlim = 0;
$include ARMINGTON.GEN
solve armington using mcp;
ARMINGTON.savepoint = 0;

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
				
$ontext
$model:agravity

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

$prod:Z(s)$z0(s)  s:esubdm mm:esubmm  dn:esubdn  nn(dn):esubnn
	o:PZ(s)		q:(lamda(s)*z0(s))
	i:PY(ss)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))  a:RA t:td(s)
	i:PMD(pd)	q:(tau_m(pd,s)*mdref(pd,s))	p:(1/tau_m(pd,s))  mm:  a:RA t:tm(s)

$report:
	v:PY_Z(ss,s)$(z0(s) and nref(ss,s))	i:PY(ss)	prod:Z(s)
	v:PMD_Z(pd,s)$(z0(s) and mdref(pd,s))	i:PMD(pd)	prod:Z(s)

$demand:XD(pd)$xd0(pd)  s:esubx
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
	SY(s)*PY(s) =e= PFX;

*	Supply of imports:

$constraint:SM(pd)$ms0(pd)
	SM(pd)*PMD(pd) =e= PFX;

$offtext
$sysinclude mpsgeset agravity
SY.FX(s) = 1;
SM.FX(pd) = 1;

*	Benchmark replication with symmetric assignment:

lamda(s) = 1;
tau_d(ss,s) = 1;
tau_m(pd,s) = 1;
tau_x(s,pd) = 1;
pfxendow = 10*sum(s,y0(s));

AGRAVITY.iterlim = 0;
$include AGRAVITY.GEN
solve agravity using mcp;
abort$round(agravity.objval,4) "Benchmark replication problem";

parameter	solvelog	Solution log;
solvelog("a","objval","Benchmark") = agravity.objval;
solvelog("a","modelstat","Benchmark") = agravity.modelstat;
solvelog("a","solvestat","Benchmark") = agravity.solvestat;

$onechov >path.opt
convergence_tolerance 1e-5
proximal_perturbation 0
crash_method pnewton
$offecho

agravity.optfile = 1;
agravity.iterlim = 10000;

parameter	epsilon / -1 /;

tau_d(s,ss(loc))$(not sameas(s,ss)) = dist(s,loc)**(epsilon/(1-esubnn));
tau_d(s,s(loc)) = dist(s,loc)**(epsilon/(1-esubdn));
tau_m(pd(loc),s) = dist(s,loc)**(epsilon/(1-  esubmm));
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-esubx));
td(s) = td0(s);
tm(s) = tm0(s);

parameter	cz(s)	Unit cost of Z at current prices,
		cm(s)	Unit cost of imports in Z,
		cn(s)	Unit cost of national imports in Z,
		cx(pd)	Unit cost of X at current prices;

parameter	ntot, thetan, thetam, theta_d, theta_n, theta_dn, thetax;

ntot(s) = sum(ss$(not sameas(s,ss)), nref(ss,s));

thetan(ss,s)$ntot(s) = nref(ss,s)/ntot(s);
thetan(s,s) = 0;
thetam(pd,s) = mdref(pd,s)/sum(pd.local,mdref(pd,s));
theta_d(s) = nref(s,s)/sum(ss,nref(ss,s));
theta_dn(s) = sum(ss,nref(ss,s))/z0(s);
thetax(s,pd)$xsref(s,pd) = xsref(s,pd)/sum(pd.local,xsref(s,pd));

parameter	cn, cm, cdn, cz, cx;

cn(s) = sum(ss$(not sameas(s,ss)), thetan(ss,s)*(tau_d(ss,s)*PY.L(ss)*(1+td(s)))**(1-esubnn))**(1/(1-esubnn));

cm(s) = sum(pd, thetam(pd,s)*(tau_m(pd,s)*PMD.L(pd)*(1+tm(s)))**(1-esubmm))**(1/(1-esubmm));

cdn(s) = ( theta_d(s)*(tau_d(s,s)*PY.L(s))**(1-esubdn) +
	 (1-theta_d(s))  * cn(s)**(1-esubdn) )**(1/(1-esubdn));

cz(s) = (theta_dn(s)*cdn(s)**(1-esubdm) + (1-theta_dn(s))*cm(s)**(1-esubdm))**(1/(1-esubdm));

cx(pd)$sum(s,xsref(s,pd)) = sum(s, thetax(s,pd) * (tau_x(s,pd)*PY.L(s))**(1-esubx))**(1/(1-esubx));

parameter	cindex	Cost indices;
cindex(s,"cn") = cn(s);
cindex(s,"cd") = tau_d(s,s)*PY.L(s);
cindex(s,"cm") = cm(s);
cindex(s,"cdn") = cdn(s);
cindex(s,"cz") = cz(s);
display cindex;

set	iter	/0*20/;

parameter	itlog	Iteration log;

loop(iter,

	SY.FX(s)  = PFX.L/PY.L(s);
	SM.FX(pd) = PFX.L/PMD.L(pd);

	itlog(s,iter) = SY.L(s)-1;
	itlog(pd,iter) = SM.L(pd)-1;

$include AGRAVITY.GEN
	solve agravity using mcp;

);
display itlog;

execute_unload 'itlog.gdx',itlog;
execute 'gdxxrw i=itlog.gdx o=itlog.xlsx par=itlog rng=itlog!a2 cdim=0 intastext=n';
$exit


SY.UP(s) = +inf; SY.LO(s) = -inf;
SY.L(s) = PFX.L/PY.L(s);
SM.UP(pd) = +inf; SM.LO(pd) = -inf;
SM.L(pd) = PFX.L/PMD.L(pd);

$include AGRAVITY.GEN
solve agravity using mcp;

$exit

solvelog("a","objval",   "Gravity") = agravity.objval;
solvelog("a","modelstat","Gravity") = agravity.modelstat;
solvelog("a","solvestat","Gravity") = agravity.solvestat;
solvelog("a","modelstat","Gravity") = agravity.modelstat;
solvelog("a","resusd","Gravity") = agravity.resusd;

*	Verify consistency in the Armington model.

nref(ss,s) = PY_Z.L(ss,s)*PY.L(ss)/PFX.L;
mref(r,s)  = sum(pd$ms0(pd), PMD_Z.L(pd,s)*PMD.L(pd)/PFX.L*md0(r,pd)/ms0(pd));
xref(s,r)  = sum(pd$xd0(pd), PY_XD.L(s,pd)*PY.L(s)/PFX.L  *xs0(pd,r)/xd0(pd));

execute_loadpoint 'armington_p.gdx';

RA.FX = sum(s,y0(s)) + sum(r,m0(r)-x0(r));

ARMINGTON.iterlim = 0;
$include ARMINGTON.GEN
solve armington using mcp;

solvelog("a","objval",   "Armington") = Armington.objval;
solvelog("a","modelstat","Armington") = Armington.modelstat;
solvelog("a","solvestat","Armington") = Armington.solvestat;
solvelog("a","modelstat","Armington") = Armington.modelstat;

$if not dexist datasets\a $call mkdir datasets\a
execute_unload 'datasets\a\%ds%.gdx',z0,nref,mref,x0,xref,y0,m0;

display solvelog;

