$title	Gravity Estimation Routine -- Bilateral

*	Define a single sector to estimate here:

$if not set ds $set ds bef_agr

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	g(*)	Goods
	pd(*)	Port districts
	yr(*)	Years;

$gdxin 'datasets\bea.gdx'
$load r s g pd yr


*	Read economic data:

parameter
	y0(yr,g,s)	Reference output (data)
	z0(yr,g,s)	Reference demand (data)
	md0(yr,g,r,pd)	Reference aggregate bilateral imports (data)
	xs0(yr,g,pd,r)	Reference aggregate bilateral exports (data);

$load y0 md0 xs0 z0

parameter	x0(yr,g,r)	Aggregate exports
		m0(yr,g,r)	Aggregate imports;

m0(yr,g,r) = sum(pd,md0(yr,g,r,pd));
x0(yr,g,r) = sum(pd,xs0(yr,g,pd,r));


*	Read geographic distances:

set		loc		Locations (states and port districts) /set.s, set.pd/;
parameter	dist(s,loc)	Distances from states to locations;
$gdxin 'datasets\geography.gdx'
$load dist
$gdxin

dist("dc","dc") = 1;

alias (s,ss), (r,rr);

parameter	dataset;
dataset(yr,g,"y0") = sum(s,y0(yr,g,s));
dataset(yr,g,"m0-x0") = sum(r,m0(yr,g,r)-x0(yr,g,r));
dataset(yr,g,"z0") = sum(s,z0(yr,g,s));
dataset(yr,g,"chk") = dataset(yr,g,"y0") + dataset(yr,g,"m0-x0") - dataset(yr,g,"z0");
display dataset;

parameter	zscale(yr,g)	Demand scale factor;
zscale(yr,g) = (sum(s,y0(yr,g,s)) + sum(r,m0(yr,g,r)-x0(yr,g,r))) / sum(s,z0(yr,g,s));
display zscale;

z0(yr,g,s) = z0(yr,g,s)*zscale(yr,g);

parameter	marketchk;
marketchk(yr,g) = sum(s,y0(yr,g,s)) + sum(r,m0(yr,g,r)-x0(yr,g,r)) - sum(s,z0(yr,g,s));
display marketchk;

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

parameter	z0_(s), y0_(s), m0_(r), x0_(r);

set	i_PY_Z(ss,s)	Domestic demand
	i_PM_Z(r,s)	Import demand,
	d_PY_X(s,r)	Export demand;

$ontext
$model:bgravity

$sectors:
	Z(s)$z0_(s)		! Absorption (Armington demand)

$commodities:
	PZ(s)$z0_(s)		! Demand price -- absorption in state s
	PY(s)$y0_(s)		! Output price in state s
	PM(r)$m0_(r)		! Import price
	PFX			! Price level

$consumers:
	RA			! PE Closure Agent
	X(r)$x0_(r)		! Export demand
	FD(s)$z0_(s)		! Final demand

$auxiliary:
	SY(s)$y0_(s)		! Output supply
	SM(r)$m0_(r)		! Import supply

*	Demand for domestic and imported goods in subregion s:

$prod:Z(s)$z0_(s)  s:esubdm mm:esubmm  dn:esubdn  nn(dn):esubnn
	o:PZ(s)			q:z0_(s)
	i:PY(ss)$i_PY_Z(ss,s)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(r)$i_PM_Z(r,s)	q:(tau_m(r,s)*mref(r,s))	p:(1/tau_m(r,s))   mm:

$report:
	v:PY_Z(ss,s)$(z0_(s) and nref(ss,s))	i:PY(ss)	prod:Z(s)
	v:PM_Z(r,s)$(z0_(s) and mref(r,s))	i:PM(r)		prod:Z(s)

*	Value of exports to region r:

$demand:X(r)$x0_(r)	s:esubx
	d:PY(s)$d_PY_X(s,r)	q:(tau_x(s,r)*xref(s,r))	p:(1/tau_x(s,r))
	e:PFX			q:x0_(r)

$report:
	v:PY_X(s,r)$(x0_(r) and xref(s,r))	d:PY(s)		demand:X(r)

*	Partial equilibrium closure with supply by state and trade partner:

$demand:RA
	d:PFX
	e:PFX		q:pfxendow
	e:PY(s)		q:y0_(s)		r:SY(s)
	e:PM(r)		q:m0_(r)		r:SM(r)

*	Final demand is fixed:

$demand:FD(s)$z0_(s)
	  d:PZ(s)	
	  e:PFX		q:z0_(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y0_(s)
	SY(s)*PY(s) =e= PFX;

*	Supply of imports from region r:

$constraint:SM(r)$m0_(r)
	SM(r)*PM(r) =e= PFX;

$offtext
$sysinclude mpsgeset bgravity

SY.FX(s) = 1;
SM.FX(r) = 1;

i_PY_Z(ss,s) = yes;
i_PM_Z(r,s) = yes;
d_PY_X(s,r) = yes;

*set	run(yr,g) /(2017,2022).(set.g)/;
set	run(yr,g) /2017.veg_agr/;

set	py_(s), pz_(s), pm_(r);

parameter	epsilon 	Elasticity of trade wrt trade cost/-1/
		cz(s)		Unit cost of Z at current prices,
		cm(s)		Unit cost of imports in Z,
		cn(s)		Unit cost of national imports in Z,
		cx(r)		Unit cost of X at current prices,
		ntot		Total intra-national imports, 
		thetan		Intra-state trade shares, 
		thetam		Import share, 
		theta_d		Local share, 
		theta_dn	Domestic share of absorption, 
		thetax		Port s share of export demand for region r
		cdn		Cost of local and intra-national shares
		cindex		Cost indices
		qd(ss,s)	Uncompensated domestic demand index
		qm(r,s)		Uncompensated imported demand index
		qx(s,r)		Uncompensated export demand index 
		vd(ss,s)	Value share of domestic demand
		vm(r,s)		Value share of imported demand
		vx(s,r)		Value share of export demand,
		yref(s)		Reference output, 
		dref(s)		Reference demand, 
		itlog		Iteration log,

		tradechk(yr,g,r,*)	Cross check on imports and exports,
		bmkdata(yr,g,s,*)	Benchmark data (calibration results);

loop(run(yr,g),

	ytot = sum(s,y0(yr,g,s));
	mtot = sum(r,m0(yr,g,r));
	xtot = sum(r,x0(yr,g,r));
	ztot = sum(s,z0(yr,g,s));

*	Filter tiny values here:
	nref(ss,s) = round(z0(yr,g,s) * y0(yr,g,ss)*(ytot-xtot)/ytot / ztot,3);
	mref(r,s)  = round(z0(yr,g,s) * m0(yr,g,r) / ztot,3);
	xref(s,r)  = round(x0(yr,g,r) * y0(yr,g,s) / ytot,3);

*	Then recalibrate the totals:

	z0_(s) = sum(ss,nref(ss,s)) + sum(r,mref(r,s));
	y0_(s) = sum(r,xref(s,r)) + sum(ss,nref(s,ss));
	m0_(r) = sum(s$z0_(s),mref(r,s));
	x0_(r) = sum(s,xref(s,r));

	pfxendow = 10 * (sum(s,y0(yr,g,s))+sum(r,m0(yr,g,r)));

	Z.L(s)$z0_(s) = 1;
	PZ.L(s)$z0_(s) = 1;
	PY.L(s)$y0_(s) = 1;
	PM.L(r)$m0_(r) = 1;
	PFX.L = 1;
	SY.L(s)$y0_(s) = 1;
	SM.L(r)$m0_(r) = 1;

	PFX.FX = 1;

	bgravity.iterlim = 0;
	bgravity.savepoint = 1;

$include bgravity.GEN
	solve bgravity using mcp;

	bgravity.savepoint = 0;

$set scn bmk
	itlog(run,"%scn%","objval") = bgravity.objval;
	itlog(run,"%scn%","modelstat") = bgravity.modelstat;
	itlog(run,"%scn%","solvestat") = bgravity.solvestat;


	display$round(bgravity.objval,4) "Benchmark replication problem";

*	Transportation impedance:

	tau_d(s,ss(loc))$(not sameas(s,ss)) = dist(s,loc)**(epsilon/(1-esubnn));
	tau_d(s,s(loc))  = dist(s,loc)**(epsilon/(1-esubdn));

*	md0(r,pd)/m0(r) = share of imports from r entering port pd
*	xs0(pd,r)/x0(r) = share of exports to r going through port pd

	tau_m(r,s)$m0(yr,g,r) = sum(pd(loc), md0(yr,g,r,pd)/m0(yr,g,r) * dist(s,loc)**(epsilon/(1-esubmm)));
	tau_x(s,r)$x0(yr,g,r) = sum(pd(loc), xs0(yr,g,pd,r)/x0(yr,g,r) * dist(s,loc)**(epsilon/(1-esubx)));

$ontext
	ntot(s) = sum(ss$(not sameas(s,ss)), nref(ss,s));
	thetan(ss,s)$ntot(s) = nref(ss,s)/ntot(s);
	thetan(s,s) = 0;
	thetam(r,s)$sum(rr,mref(rr,s)) = mref(r,s)/sum(rr,mref(rr,s));
	theta_d(s)$sum(ss,nref(ss,s)) = nref(s,s)/sum(ss,nref(ss,s));
	theta_dn(s)$z0(yr,g,s) = sum(ss,nref(ss,s))/z0(yr,g,s);
	thetax(s,r)$x0(yr,g,r) = xref(s,r)/x0(yr,g,r);

	py_(s) = yes$y0_(s);
	cn(s) = sum(py_(ss)$(not sameas(s,ss)), 
			thetan(ss,s)*(tau_d(ss,s)*PY.L(ss))**(1-esubnn))**(1/(1-esubnn));

	pm_(r) = yes$m0_(r);
	cm(s) = sum(pm_(r), thetam(r,s)*(tau_m(r,s)*PM.L(r))**(1-esubmm))**(1/(1-esubmm));

	cdn(s)$py_(s) = ( theta_d(s)*(tau_d(s,s)*PY.L(s))**(1-esubdn) +
		 (1-theta_d(s))  * cn(s)**(1-esubdn) )**(1/(1-esubdn));

	cz(s) = (theta_dn(s)*cdn(s)**(1-esubdm) + (1-theta_dn(s))*cm(s)**(1-esubdm))**(1/(1-esubdm));

	cx(r)$x0(yr,g,r) = sum(s, thetax(s,r) * (tau_x(s,r)*PY.L(s))**(1-esubx))**(1/(1-esubx));

	cindex(s,"cn") = cn(s);
	cindex(s,"cd") = tau_d(s,s)*PY.L(s);
	cindex(s,"cm") = cm(s);
	cindex(s,"cdn") = cdn(s);
	cindex(s,"cz") = cz(s);
	display cindex, cx;

	qd(ss,s)$nref(ss,s) = 
		(cn(s)/(tau_d(s,ss)*PY.L(ss)))**esubnn * 
		(cdn(s)/cn(s))**esubdn * 
		(cz(s)/cdn(s))**esubdm * 
		(1/cz(s));

	qm(r,s)$mref(r,s) = (cm(s)/(tau_m(r,s)*PM.L(r)))**esubmm * (cz(s)/cm(s))**esubdm;

	qx(s,r)$xref(s,r) = (cx(r)/(tau_x(s,r)*PY.L(s)))**esubx * (1/cx(r));

	vd(ss,s) = qd(ss,s) * nref(ss,s)*tau_d(ss,s)*PY.L(ss)  / z0(yr,g,s);
	vm(r,s)  = qm(r,s) * mref(r,s)*tau_m(r,s)*PM.L(r)      / z0(yr,g,s);
	vx(s,r)$x0(yr,g,r) = qx(s,r) * xref(s,r)*tau_x(s,r)*PY.L(s) / x0(yr,g,r);

	display qd, qm, qx, vd, vm, vx;
$offtext

	bgravity.iterlim = 10000;
$include bgravity.gen
	solve bgravity using mcp;

$set scn sfix
	itlog(run,"%scn%","objval") = bgravity.objval;
	itlog(run,"%scn%","modelstat") = bgravity.modelstat;
	itlog(run,"%scn%","solvestat") = bgravity.solvestat;

	SY.UP(s) = +inf;
	SY.LO(s) = 0;
	SY.L(s)$y0(yr,g,s) = (PFX.L/PY.L(s))$PY.L(s);

	SM.UP(r) = +inf;
	SM.LO(r) = 0;
	SM.L(r)$m0(yr,g,r) = (PFX.L/PM.L(r))$PM.L(r);

	bgravity.iterlim = 10000;
$include bgravity.gen
	solve bgravity using mcp;

$set scn svar
	itlog(run,"%scn%","objval") = bgravity.objval;
	itlog(run,"%scn%","modelstat") = bgravity.modelstat;
	itlog(run,"%scn%","solvestat") = bgravity.solvestat;

*	Save the solution:

*.execute 'mv -f bgravity_p.gdx bases\alt_%ds%_p.gdx';

*	Verify benchmark consistency:

	nref(ss,s) = PY_Z.L(ss,s)*PY.L(ss)/PFX.L;
	mref(r,s)  = PM_Z.L(r,s)*PM.L(r)/PFX.L;
	xref(s,r)  = PY_X.L(s,r)*PY.L(s)/PFX.L;
	tau_d(ss,s) = 1;
	tau_m(r,s) = 1;
	tau_x(s,r) = 1;

*.	execute_loadpoint 'bgravity_p.gdx';
*.	bgravity.iterlim = 0;
*.$include BGRAVITY.GEN
*.	solve bgravity using mcp;

	yref(s) = sum(ss,nref(s,ss))+sum(r,xref(s,r));
	dref(s) = sum(ss,nref(ss,s))+sum(r,mref(r,s));

	bmkdata(run,s,"Y")$yref(s) = yref(s);
	bmkdata(run,s,"D")$yref(s) = dref(s);

	tradechk(run,r,"m0") = m0(run,r);
	tradechk(run,r,"x0") = x0(run,r);
	tradechk(run,r,"m0*") = sum(s,z0(yr,g,s) * m0(run,r)) / ztot;
	tradechk(run,r,"x0*") = sum(s,x0(yr,g,r) * y0(run,s)) / ytot;

	tradechk(run,r,"mref") = sum(s,mref(r,s));
	tradechk(run,r,"xref") = sum(s,xref(s,r));

	bmkdata(run,s,"d/Y")$yref(s) = nref(s,s)/yref(s);
	bmkdata(run,s,"n/Y")$yref(s) = (sum(ss,nref(s,ss))-nref(s,s))/yref(s);
	bmkdata(run,s,"x/Y")$yref(s) = sum(r,xref(s,r))/yref(s);
	bmkdata(run,s,"d/D")$dref(s) = nref(s,s)/dref(s);
	bmkdata(run,s,"n/D")$dref(s) = (sum(ss,nref(ss,s))-nref(s,s))/dref(s);
	bmkdata(run,s,"m/D")$dref(s) = sum(r,mref(r,s))/dref(s);
);

option tradechk:3:1:1;
display tradechk;

execute_unload 'datasets\bearesults.gdx',itlog,bmkdata;
