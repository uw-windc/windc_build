$title	Gravity Estimation Routine -- Bilateral

*	Define a single sector to estimate here:

$if not set ds $set ds alt

*	Two estimation methods have been implemented.  This is b:

*		b	"Bilateral gravity" model which calibrates to
*			import and export by port and bilateral trade partner.

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	pd(*)	Port districts;

$gdxin 'datasets\%ds%.gdx'
$load r s pd

*	Read economic data:

parameter
	y0(s)		Reference output (data)
	z0(s)		Reference demand (data)
	md0(r,pd)	Reference aggregate bilateral imports (data)
	xs0(pd,r)	Reference aggregate bilateral exports (data);

$load y0 md0 xs0 z0

parameter	x0(r)	Aggregate exports
		m0(r)	Aggregate imports;

m0(r) = sum(pd,md0(r,pd));
x0(r) = sum(pd,xs0(pd,r));

*	Read geographic distances:

set		loc		Locations (states and port districts) /set.s, set.pd/;
parameter	dist(s,loc)	Distances from states to locations;
$gdxin 'datasets\geography.gdx'
$load dist
$gdxin

dist("dc","dc") = 1;

alias (s,ss), (r,rr);

parameter	zscale	Demand scale factor;
zscale = (sum(s,y0(s)) + sum(r,m0(r)-x0(r)))/sum(s,z0(s));
display zscale;
z0(s) = z0(s)*zscale;

parameter
	tau_d(s,s)	Iceberg cost coefficient -- domestic trade
	tau_m(r,s)	Iceberg cost coefficient -- import shipments 
	tau_x(s,r)	Iceberg cost coefficient -- export shipments ;

tau_d(ss,s) = 1;
tau_m(r,s) = 1;
tau_x(s,r) = 1;

parameters
	nref(s,s)	Intra-national trade
	mref(r,s)	Imports
	xref(s,r)	Exports,
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

parameter
	esubdm		Elasticity of substitution (domestic versus imports) /4/
	esubmm		Elasticity across imports
	esubdn		Elasticity local versus other domestic
	esubnn		Elasticity among other domestic
	esubx		Elasticity between exports,
	pfxendow	Foreign exchange endowment -- for PE closure ;

esubmm = 2 * esubdm;
esubdn = 2 * esubdm;
esubnn = 4 * esubdm;
esubx = 2 * esubdm;
pfxendow = 10 * (sum(s,y0(s))+sum(r,m0(r)));

set	i_PY_Z(ss,s)	Domestic demand
	i_PM_Z(r,s)	Import demand,
	d_PY_X(s,r)	Export demand;

$ontext
$model:bgravity

$sectors:
	Z(s)$z0(s)		! Absorption (Armington demand)

$commodities:
	PZ(s)$z0(s)		! Demand price -- absorption in state s
	PY(s)$y0(s)		! Output price in state s
	PM(r)$m0(r)		! Import price
	PFX			! Price level

$consumers:
	RA			! PE Closure Agent
	X(r)$x0(r)		! Export demand
	FD(s)$z0(s)		! Final demand

$auxiliary:
	SY(s)$y0(s)		! Output supply
	SM(r)$m0(r)		! Import supply

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z0(s)  s:esubdm mm:esubmm  dn:esubdn  nn(dn):esubnn
	o:PZ(s)			q:z0(s)
	i:PY(ss)$i_PY_Z(ss,s)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(r)$i_PM_Z(r,s)	q:(tau_m(r,s)*mref(r,s))	p:(1/tau_m(r,s))   mm:

$report:
	v:PY_Z(ss,s)$(z0(s) and nref(ss,s))	i:PY(ss)	prod:Z(s)
	v:PM_Z(r,s)$(z0(s) and mref(r,s))	i:PM(r)		prod:Z(s)

*	Value of exports to region s:

$demand:X(r)$x0(r)	s:esubx
	d:PY(s)$d_PY_X(s,r)	q:(tau_x(s,r)*xref(s,r))	p:(1/tau_x(s,r))
	e:PFX			q:x0(r)

$report:
	v:PY_X(s,r)$(x0(r) and xref(s,r))	d:PY(s)		demand:X(r)

*	Partial equilibrium closure with supply by state and trade partner:

$demand:RA
	d:PFX
	e:PFX		q:pfxendow
	e:PY(s)		q:y0(s)		r:SY(s)
	e:PM(r)		q:m0(r)		r:SM(r)

*	Final demand is fixed:

$demand:FD(s)$z0(s)
	  d:PZ(s)	
	  e:PFX		q:z0(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0(s)
	SY(s)*PY(s) =e= PFX;

*	Supply of imports from region r:

$constraint:SM(r)$m0(r)
	SM(r)*PM(r) =e= PFX;

$offtext
$sysinclude mpsgeset bgravity

SY.FX(s) = 1;
SM.FX(r) = 1;

i_PY_Z(ss,s) = yes;
i_PM_Z(r,s) = yes;
d_PY_X(s,r) = yes;

bgravity.savepoint = 1;
bgravity.iterlim = 0;
$include bgravity.GEN
solve bgravity using mcp;
abort$round(bgravity.objval,4) "Benchmark replication problem";

bgravity.savepoint = 0;

parameter  epsilon 	Elasticity of trade wrt trade cost/-1/;

*	Transportation impedance:

tau_d(s,ss(loc))$(not sameas(s,ss)) = dist(s,loc)**(epsilon/(1-esubnn));
tau_d(s,s(loc))  = dist(s,loc)**(epsilon/(1-esubdn));

*	md0(r,pd)/m0(r) = share of imports from r entering port pd
*	xs0(pd,r)/x0(r) = share of exports to r going through port pd

tau_m(r,s)$m0(r) = sum(pd(loc), md0(r,pd)/m0(r) * dist(s,loc)**(epsilon/(1-esubmm)));
tau_x(s,r)$x0(r) = sum(pd(loc), xs0(pd,r)/x0(r) * dist(s,loc)**(epsilon/(1-esubx)));

parameter	cz(s)	Unit cost of Z at current prices,
		cm(s)	Unit cost of imports in Z,
		cn(s)	Unit cost of national imports in Z,
		cx(r)	Unit cost of X at current prices;

parameter	ntot		Total intra-national imports, 
		thetan		Intra-state trade shares, 
		thetam		Import share, 
		theta_d		Local share, 
		theta_dn	Domestic share of absorption, 
		thetax		Port s share of export demand for region r;

ntot(s) = sum(ss$(not sameas(s,ss)), nref(ss,s));
thetan(ss,s)$ntot(s) = nref(ss,s)/ntot(s);
thetan(s,s) = 0;
thetam(r,s) = mref(r,s)/sum(rr,mref(rr,s));
theta_d(s) = nref(s,s)/sum(ss,nref(ss,s));
theta_dn(s) = sum(ss,nref(ss,s))/z0(s);
thetax(s,r)$x0(r) = xref(s,r)/x0(r);

parameter	cn	Intra-national cost, 
		cm	Import cost,
		cdn	Cost of local and intra-national shares, 
		cz	Cost index for region s absorption,
		cx	Cost index for exports to region r;

cn(s) = sum(ss$(not sameas(s,ss)), 
		thetan(ss,s)*(tau_d(ss,s)*PY.L(ss))**(1-esubnn))**(1/(1-esubnn));

cm(s) = sum(r, thetam(r,s)*(tau_m(r,s)*PM.L(r))**(1-esubmm))**(1/(1-esubmm));

cdn(s) = ( theta_d(s)*(tau_d(s,s)*PY.L(s))**(1-esubdn) +
	 (1-theta_d(s))  * cn(s)**(1-esubdn) )**(1/(1-esubdn));

cz(s) = (theta_dn(s)*cdn(s)**(1-esubdm) + (1-theta_dn(s))*cm(s)**(1-esubdm))**(1/(1-esubdm));

cx(r)$x0(r) = sum(s, thetax(s,r) * (tau_x(s,r)*PY.L(s))**(1-esubx))**(1/(1-esubx));

parameter	cindex	Cost indices;
cindex(s,"cn") = cn(s);
cindex(s,"cd") = tau_d(s,s)*PY.L(s);
cindex(s,"cm") = cm(s);
cindex(s,"cdn") = cdn(s);
cindex(s,"cz") = cz(s);
display cindex, cx;

parameter	qd(ss,s)	Uncompensated domestic demand index
		qm(r,s)		Uncompensated imported demand index
		qx(s,r)		Uncompensated export demand index; 

qd(ss,s)$nref(ss,s) = 
	(cn(s)/(tau_d(s,ss)*PY.L(ss)))**esubnn * 
	(cdn(s)/cn(s))**esubdn * 
	(cz(s)/cdn(s))**esubdm * 
	(1/cz(s));

qm(r,s)$mref(r,s) = (cm(s)/(tau_m(r,s)*PM.L(r)))**esubmm * (cz(s)/cm(s))**esubdm;

qx(s,r)$xref(s,r) = (cx(r)/(tau_x(s,r)*PY.L(s)))**esubx * (1/cx(r));

parameter	vd(ss,s)	Value share of domestic demand
		vm(r,s)		Value share of imported demand
		vx(s,r)		Value share of export demand;

vd(ss,s) = qd(ss,s) * nref(ss,s)*tau_d(ss,s)*PY.L(ss)  / z0(s);
vm(r,s)  = qm(r,s) * mref(r,s)*tau_m(r,s)*PM.L(r)      / z0(s);
vx(s,r)$x0(r) = qx(s,r) * xref(s,r)*tau_x(s,r)*PY.L(s) / x0(r);

display qd, qm, qx, vd, vm, vx;

bgravity.iterlim = 10000;
$include bgravity.gen
solve bgravity using mcp;

SY.UP(s) = +inf;
SY.LO(s) = 0;
SY.L(s)$y0(s) = PFX.L/PY.L(s);

SM.UP(r) = +inf;
SM.LO(r) = 0;
SM.L(r)$m0(r) = PFX.L/PM.L(r);

bgravity.iterlim = 10000;
$include bgravity.gen
solve bgravity using mcp;

*	Save the solution:

*.execute 'mv -f bgravity_p.gdx bases\alt_%ds%_p.gdx';

*	Verify benchmark consistency:

nref(ss,s) = PY_Z.L(ss,s)*PY.L(ss)/PFX.L;
mref(r,s)  = PM_Z.L(r,s)*PM.L(r)/PFX.L;
xref(s,r)  = PY_X.L(s,r)*PY.L(s)/PFX.L;
tau_d(ss,s) = 1;
tau_m(r,s) = 1;
tau_x(s,r) = 1;

execute_loadpoint 'bgravity_p.gdx';

bgravity.iterlim = 0;
$include BGRAVITY.GEN
solve bgravity using mcp;

$if not dexist datasets\b $call mkdir datasets\b

execute_unload 'datasets\b\%ds%.gdx',z0,nref,mref,x0,xref,y0,m0;
