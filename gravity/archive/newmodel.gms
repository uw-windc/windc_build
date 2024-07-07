$title	Gravity Estimation Routine -- Single Sector PE Model in MPSGE

set	r(*)	Regions (trading partners)
	s(*)	Subregions (states),
	pd(*)	Port districts;

*.$if not set ds $abort "Need to have dataset defined by --ds=xxx";

$set ds wht
$gdxin '%ds%.gdx'
$load r s pd

set		loc /set.s, set.pd/;

parameter	dist(s,loc)	Distances from state to state or port;
$load dist

alias (s,ss), (pd,ppd), (r,rr);

parameter
	y0(s)		Reference output (data)
	d0(s)		Reference demand (data)
	m0(r,pd)	Reference aggregate imports (data)
	x0(pd,r)	Reference aggregate exports (data);

$load y0 m0 x0 d0

m0(r,pd)$(not round(m0(r,pd),3)) = 0;
x0(pd,r)$(not round(x0(pd,r),3)) = 0;

y0(s) = 1e3 * y0(s);
d0(s) = 1e3 * d0(s);
m0(r,pd) = 1e3 * m0(r,pd);
x0(pd,r) = 1e3 * x0(pd,r);

parameter
	eref(s,r)	Reference exports (calibrated)
	bdref(s,s)	Reference intra-state demand (calibrated)
	mdref(r,s)	Reference import demand (calibrated)

	tau_d(s,s)	Iceberg cost coefficient -- domestic trade
	tau_m(pd,s)	Iceberg cost coefficient -- imports
	tau_x(s,pd)	Iceberg cost coefficient -- exports

	pfxendow	Foreign exchange endowment -- for PE closure 

	lamda_a(s)	Scale parameter for absorption demand

	ytot		Total production
	mtot		Total imports
	xtot		Total exports
	dtot		Total absorption;

ytot = sum(s, y0(s));
mtot = sum((r,pd),m0(r,pd));
xtot = sum((pd,r),x0(pd,r));
dtot = sum(s,d0(s));

parameter	dscale	Demand scale factor;
dscale = (ytot + mtot - xtot)/dtot;
display dscale;
d0(s) = d0(s)*dscale;
dtot = sum(s,d0(s));

mdref(r,s)  = d0(s)  * sum(pd,m0(r,pd)) /(sum((rr,pd),m0(rr,pd)) + sum(ss,y0(ss)));
bdref(s,ss) = d0(ss) * y0(s) /(sum((rr,pd),m0(rr,pd)) + sum(s.local,y0(s)));
eref(s,r)   = sum(pd,x0(pd,r)) * y0(s) / sum(ss.local,y0(ss));
				
parameter	zprofit;
zprofit(s,"d0") = d0(s);
zprofit(s,"bd0") = sum(ss,bdref(ss,s));
zprofit(s,"md0") = sum(r,mdref(r,s));
zprofit(s,"chk") = zprofit(s,"d0") - zprofit(s,"bd0") - zprofit(s,"md0");
display zprofit;

parameter	ymarket;
ymarket(s,"y0") = y0(s);
ymarket(s,"bdref") = sum(ss,bdref(s,ss));
ymarket(s,"eref") = sum(r,eref(s,r));
ymarket(s,"chk") = ymarket(s,"y0") - ymarket(s,"bdref") - ymarket(s,"eref");
display ymarket;

parameter	xmarket;
xmarket(r,"x0") = sum(pd,x0(pd,r));
xmarket(r,"eref") = sum(s,eref(s,r));
xmarket(r,"chk") = xmarket(r,"eref") - xmarket(r,"x0");
display xmarket;

set	elast	Elasticities used for iceberg trade cost calculations /"3.0","4.0","5.0"/;

parameter
	epsilon			Elasticity of trade wrt trade cost /-1/,
	tau(s,*,elast)		Travel cost to closest port;

tau(s,"min",elast) = smin(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"max",elast) = smax(loc(pd), dist(s,loc)**(epsilon/(1-elast.val)));
tau(s,"ave",elast) = sum(loc(pd),  dist(s,loc)**(epsilon/(1-elast.val)))/card(pd);
option tau:1:1:2;
display tau;

sets	z_(s), md_(r,pd,s), xs_(s,pd,r), pz_(s), py_(s), pm_(r,s), px_(s,r), pp_(r,pd),
	xd_(r), d_(s);
z_(s) = yes$d0(s);
py_(s) = yes$y0(s);
md_(r,pd,s) = yes$(m0(r,pd) and mdref(r,s));
xs_(py_(s),pd,r) = yes$(eref(s,r) and x0(pd,r));
xd_(r) = yes$sum(pd,x0(pd,r));
d_(s) = yes$d0(s);
pz_(s) = z_(s);
pm_(r,s) = yes$mdref(r,s);
px_(s,r) = yes$eref(s,r);
pp_(r,pd) = yes$(m0(r,pd) and sum(s,mdref(r,s)));

parameter	esubdm	/4/
		esub_x	/4/;

pfxendow = sum(s,y0(s));

$ontext
$model:gravity

$sectors:
	Z(s)$z_(s)		! Absorption (Armington demand)
	MD(r,pd,s)$md_(r,pd,s)	! Imports
	XS(s,pd,r)$xs_(s,pd,r)	! Exports

$commodities:
	PZ(s)$pz_(s)	! Demand price -- absorption in state s
	PY(s)$py_(s)	! Output price in state s
	PM(r,s)$pm_(r,s) ! Price of imports from r in state s
	PX(s,r)$px_(s,r) ! CIF price of exports from s in r
	PP(r,pd)$pp_(r,pd) ! Port price of imports (CIF)
	PFX		! Price level

$consumers:
	RA		! PE Closure Agent
	XD(r)$xd_(r)	! Export demand
	D(s)$d_(s)	! Final demand

$auxiliary:
	SY(s)		! Output supply
	SM(r,pd)	! Import supply
	MU(pd,r)	! Port congestion premium

*	Demand for domestic and imported goods in subregion s:


$prod:Z(s)$z_(s)  s:esubdm mm:(2*esubdm)  dn:(2*esubdm)  nn(dn):(4*esubdm)
	o:PZ(s)		q:(lamda_a(s)*d0(s))
	i:PY(ss)	q:(tau_d(ss,s)*bdref(ss,s))  p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(r,s)	q:mdref(r,s)		mm:

*	Imports from region r comes from port district pd to subregion s:

$prod:MD(r,pd,s)$md_(r,pd,s)
	o:PM(r,s)		q:1
	i:PP(r,pd)$pp_(r,pd)	q:tau_m(pd,s)

*	External equations describe supply of domestic
*	and imported goods:

$demand:RA
	  d:PFX
	  e:PFX		q:pfxendow
	  e:PY(s)$y0(s)		q:y0(s)		r:SY(s)
	  e:PP(r,pd)$m0(r,pd)	q:m0(r,pd)	r:SM(r,pd)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$SY.UP(s)
	SY(s)*PY(s) =e= PFX;

$constraint:SM(r,pd)$SM.UP(r,pd)
	SM(r,pd)*PP(r,pd) =e= PFX;

$constraint:MU(pd,r)$MU.UP(pd,r)
	PFX*x0(pd,r) =e= sum(xs_(s,pd,r), XS(s,pd,r)*PX(s,r));

*	Export from subregion s through port district pd:

$prod:XS(s,pd,r)$xs_(s,pd,r)
	o:PX(s,r)$px_(s,r)	q:1	a:RA	n:MU(pd,r)
	i:PY(s)			q:tau_x(s,pd)

*	Value of exports to region r:

$demand:XD(r)$xd_(r)   s:esub_x
	d:PX(s,r)	q:eref(s,r)
	e:PFX		q:(sum(pd,x0(pd,r)))

$demand:D(s)$d_(s)
	  d:PZ(s)
	  e:PFX		q:d0(s)

$offtext
$sysinclude mpsgeset gravity

SY.FX(s) = 1;
SM.FX(r,pd) = 1;
MU.FX(pd,r) = 0;
SY.FX(s)$(not y0(s)) = 0;
SM.FX(r,pd)$(not m0(r,pd)) = 0;

MD.L(md_(r,pd,s)) = mdref(r,s)*m0(r,pd)/sum(pd.local,m0(r,pd));
XS.L(xs_(s,pd,r)) = eref(s,r)*x0(pd,r)/sum(pd.local,x0(pd,r));

*	Benchmark replication:

lamda_a(s) = 1;
tau_d(ss,s) = 1;
tau_m(pd,s) = 1;
tau_x(s,pd) = 1;

*.GRAVITY.holdfixed = yes;


GRAVITY.iterlim = 0;
$include GRAVITY.GEN
solve gravity using mcp;

GRAVITY.iterlim = 100000;
$include GRAVITY.GEN
solve gravity using mcp;

tau_d(s,ss(loc)) = dist(s,loc)**(epsilon/(1-4*esubdm));
tau_m(pd(loc),s) = dist(s,loc)**(epsilon/(1-esubdm));
tau_x(s,pd(loc)) = dist(s,loc)**(epsilon/(1-esub_x));

SY.UP(s) = +inf; SY.LO(s) = 0;
SM.UP(r,pd) = +inf; SM.LO(r,pd) = 0;

MU.LO(pd,r) = 0;
MU.UP(pd,r) = +inf; 
MU.FX(pd,r)$(not sum(xs_(s,pd,r),1)) = 0;

SY.FX(s)$(not y0(s)) = 0;
SM.FX(r,pd)$(not m0(r,pd)) = 0;

GRAVITY.iterlim = 100000;
$include GRAVITY.GEN
solve gravity using mcp;
