$title	Gravity Estimation Routine -- Bilateral

$if not set tradedata $set tradedata %system.fp%aggtradedata.gdx
$if not set input  $set input  d:\GitHub\windc_build\statedata\gravitydata_2022.gdx
$if not set output $set output d:\GitHub\windc_build\statedata\gravitydata_2022_out.gdx

*	---------------------------------------------------------------------------------------

parameter
	esub		Domestic-import elasticity of substitution /4/
	epsilon 	Elasticity of trade wrt distance /-1/;

*	---------------------------------------------------------------------------------------
*	Trade data are provided explicitly.

set	s	States (subregions) /
	AL    Alabama
	AR    Arizona
	AZ    Arkansas
	CA    California
	CO    Colorado
	CT    Connecticut
	DE    Delaware
	DC    District of Columbia
	FL    Florida
	GA    Georgia
	ID    Idaho
	IL    Illinois
	IN    Indiana
	IA    Iowa
	KS    Kansas
	KY    Kentucky
	LA    Louisiana
	ME    Maine
	MD    Maryland
	MA    Massachusetts
	MI    Michigan
	MN    Minnesota
	MS    Mississippi
	MO    Missouri
	MT    Montana
	NE    Nebraska
	NV    Nevada
	NH    New Hampshire
	NJ    New Jersey
	NM    New Mexico
	NY    New York
	NC    North Carolina
	ND    North Dakota
	OH    Ohio
	OK    Oklahoma
	OR    Oregon
	PA    Pennsylvania
	RI    Rhode Island
	SC    South Carolina
	SD    South Dakota
	TN    Tennessee
	TX    Texas
	UT    Utah
	VT    Vermont
	VA    Virginia
	WA    Washington
	WV    West Virginia
	WI    Wisconsin
	WY    Wyoming /;


set	i(*)	Traded goods
	r(*)	Trade parnters,
	pd(*)	Ports;

parameter	md_0(i,r,pd)	Reference aggregate bilateral imports (data),
		xs_0(i,pd,r)	Reference aggregate bilateral exports (data);


$gdxin '%tradedata%'
$load i r pd
$loaddc md_0 xs_0 

set		loc	Locations (states and port districts) /set.s, set.pd/;

parameter	dist(s,loc)	Distances from states to locations;

$loaddc dist

alias (s,ss), (r,rr), (pd,ppd);

set		g(*)		Domestic goods,
		g_i(g,i)	Domestic-traded good mapping,
		da		Data arrays /
				x0	(input) International exports -- total,
				m0	(input) International imports -- total,
				y0	(input) Production by state
				a0	(input) Absorption by state 

				yn0	(output) Interstate sales
				yx0	(output) Export supply
				yd0	(output) Local supply and demand 
				nd0	(output) National market demand
				md0	(output) Import demand /,

		st		States and total /(set.s),total/;


parameter	gravitydata(g,st,da)	Gravity data,
		x0(g)	Aggregate (national) exports of domestic goods
		m0(g)	Aggregate (national) imports of domestic goods
		y0(g,s)	Production by state
		a0(g,s)	Absorption by state;

$gdxin '%input%'
$load g
$loaddc g_i gravitydata
$gdxin

x0(g) = gravitydata(g,"total","x0");
m0(g) = gravitydata(g,"total","m0");
y0(g,s(st)) = gravitydata(g,st,"y0");
a0(g,s(st)) = gravitydata(g,st,"a0");

parameter	marketchk	Supply-demand check (strictly enforced);
marketchk(g) = round(sum(s,y0(g,s)) + m0(g)-x0(g) - sum(s,a0(g,s)),6);
abort$card(marketchk)  "Problem with state data -- market imbalance.",marketchk;

set	nmap(g)	Sectors with no corresponding trade sector;
nmap(g) = yes$(sum(g_i(g,i),1) = 0);
abort$card(nmap) "Inconsistent mapping -- each g must have at least one i.",nmap;

parameter	beta_m(g,r)	Imports by trade partner,
		beta_x(g,r)	Exports by trade partner;

beta_m(g,r) = sum((g_i(g,i),pd),md_0(i,r,pd))/sum((g_i(g,i),rr,pd),md_0(i,rr,pd));
beta_x(g,r) = sum((g_i(g,i),pd),xs_0(i,pd,r))/sum((g_i(g,i),rr,pd),xs_0(i,pd,rr));

parameter	theta_m(g,r,pd)	Import shares by trade partner and port,
		theta_x(g,pd,r)	Export shares by trade partner and port;

*	Use traded goods flows to impute domestic flows:

theta_m(g,r,pd) = sum(g_i(g,i),md_0(i,r,pd)) / sum((g_i(g,i),ppd,rr),md_0(i,rr,ppd));
theta_x(g,pd,r) = sum(g_i(g,i),xs_0(i,pd,r)) / sum((g_i(g,i),ppd,rr),xs_0(i,ppd,rr));

parameter	omega_m(g,r,pd)	Fraction of imports from r entering port pd
		omega_x(g,pd,r)	Fraction of exports to r leaving port pd;

omega_m(g,r,pd)$theta_m(g,r,pd) = theta_m(g,r,pd)/sum(pd.local,theta_m(g,r,pd));
omega_x(g,pd,r)$theta_x(g,pd,r) = theta_x(g,pd,r)/sum(pd.local,theta_x(g,pd,r));

parameter
	tau_d(s,s)	Iceberg trade cost coefficient -- domestic flows
	tau_m(r,s)	Iceberg trade cost coefficient -- import shipments 
	tau_x(s,r)	Iceberg trade cost coefficient -- export shipments ;

tau_d(ss,s) = 1;
tau_m(r,s) = 1;
tau_x(s,r) = 1;

parameters
	yref(s)		Reference production,
	aref(s)		Reference absorption,
	nref(s,s)	Intra-national trade (reference equilibrium),
	mref(r,s)	Imports (reference equilibrium),
	xref(s,r)	Exports (reference equilibrium),
	sy0(s)		Output multiplier,

	ytot		Total production,
	atot		Total absorption,
	pfxendow	Endowment of outside good;


sets	a_(s)		Absorption,
	y_(s)		Production,
	m_(r)		Import market exists,
	x_(r)		Export market exists,

	i_PY_A(ss,s)	Domestic demand
	i_PM_A(r,s)	Import demand,
	d_PY_X(s,r)	Export demand;

$ontext
$model:bgravity

$sectors:
	A(s)$a_(s)		! Absorption (Armington demand)

$commodities:
	PA(s)$a_(s)		! Demand price -- absorption in state s
	PY(s)$y_(s)		! Output price in state s
	PM(r)$m_(r)		! Import price
	PFX			! Price level

$consumers:
	RA			! PE Closure Agent
	X(r)$x_(r)		! Export demand
	FD(s)$a_(s)		! Final demand

$auxiliary:
	SY(s)$y_(s)		! Output supply
	SM(r)$m_(r)		! Import supply

*	Demand for domestic and imported goods in state s:

$prod:A(s)$a_(s)  s:esub mm:(2*esub)  dn:(2*esub)  nn(dn):(4*esub)
	o:PA(s)			q:aref(s)
	i:PY(ss)$i_PY_A(ss,s)	q:(tau_d(ss,s)*nref(ss,s))	p:(1/tau_d(ss,s))  dn:$sameas(s,ss) nn:$(not sameas(s,ss))
	i:PM(r)$i_PM_A(r,s)	q:(tau_m(r,s)*mref(r,s))	p:(1/tau_m(r,s))   mm:

$report:
	v:PY_A(ss,s)$i_PY_A(ss,s)	i:PY(ss)	prod:A(s)
	v:PM_A(r,s)$i_PM_A(r,s)		i:PM(r)		prod:A(s)

*	Value of exports to region r:

$demand:X(r)$x_(r)	s:(2*esub)
	d:PY(s)		q:(tau_x(s,r)*xref(s,r))	p:(1/tau_x(s,r))
	e:PFX		q:(sum(s,xref(s,r)))

$report:
	v:PY_X(s,r)$d_PY_X(s,r)		d:PY(s)		demand:X(r)

*	Partial equilibrium closure with supply by state and trade partner:

$demand:RA
	d:PFX
	e:PFX		q:pfxendow
	e:PY(s)		q:yref(s)		r:SY(s)
	e:PM(r)		q:(sum(s,mref(r,s)))	r:SM(r)

*	The value of final demand in state s equals aref(s):

$demand:FD(s)$a_(s)
	  d:PA(s)	
	  e:PFX		q:aref(s)

*	Supply adjustments for both domestic and imported goods
*	hold value of sales fixed:

$constraint:SY(s)$y_(s)
	SY(s)*PY(s) =e= sy0(s)*PFX;

*	Supply of imports from region r:

$constraint:SM(r)$m_(r)
	SM(r)*PM(r) =e= PFX;

$offtext
$sysinclude mpsgeset bgravity

$if not set run $set run set.g
set	run(g)	Which sectors do we run? /%run%/;
*.set	run(g)	Which sectors do we run? /oil/;

parameter	itlog		Iteration log,
		yn0(g,s)	Interstate sales of good g from state s,
		yx0(g,s,r)	Export supply of good g from state s to trade partner r,
		dx0(g,s,ss)	Domestic trade,
		yd0(g,s)	Local demand and supply of good g in state s,
		nd0(g,s)	National market demand for good g in state s,
		md0(g,r,s)	Import market demand for good g from trade parnter r in state s,

		x0chk		Cross check on x0,
		m0chk		Cross check on m0,
		y0chk		Cross check on y0,
		a0chk		Cross check on a0
		echop		Cross check on model inputs;

set	echocol /a0,aref,y0,yref/;

parameter	chk;

loop(run(g),

	ytot = sum(s,y0(g,s));
	atot = sum(s,a0(g,s));

*	Filter tiny values to three decimals:

*.	nref(ss,s) = round(a0(g,s)/atot * y0(g,ss)/ytot * (ytot-x0(g)), 3);
*.	mref(r,s)  = round(a0(g,s)/atot * m0(g),			3);
*.	xref(s,r)  = round(y0(g,s)/ytot * x0(g),			3);

	nref(ss,s) = y0(g,ss) * (ytot-x0(g))/ytot  * a0(g,s)/(ytot-x0(g)+m0(g));
	mref(r,s)  = beta_m(g,r) * m0(g) /(ytot-x0(g)+m0(g)) * a0(g,s);
	xref(s,r)  = beta_x(g,r) * (y0(g,s)-sum(ss,nref(s,ss)));

	chk(g,"y+a-x-m") = sum(s,y0(g,s)-a0(g,s))-x0(g)+m0(g);
	chk(g,"nref+mref-a") = sum((s,ss),nref(s,ss))+sum((r,s),mref(r,s)) - sum(s,a0(g,s));
	chk(g,"xref-x0") = sum((s,r),xref(s,r)) - x0(g);

*	Then recalibrate totals:

	aref(s) = sum(ss,nref(ss,s)) + sum(r,mref(r,s));
	yref(s) = sum(r,xref(s,r))   + sum(ss,nref(s,ss));

	echop(s,"a0") = a0(g,s);
	echop(s,"aref") = aref(s);
	echop(s,"y0") = y0(g,s);
	echop(s,"yref") = yref(s);

	echop("total",echocol) = sum(s,echop(s,echocol));

*	Identify nonzero flows:

	i_PY_A(ss,s) = nref(ss,s);
	i_PM_A(r,s)  = mref(r,s);
	d_PY_X(s,r)  = xref(s,r);

*	Identify active markets:

	a_(s) = yes$aref(s);
	y_(s) = yes$yref(s);
	m_(r) = yes$sum(s,mref(r,s));
	x_(r) = yes$sum(s,xref(s,r));

*	Benchmark at the reference counterfactual:

	A.L(s)$a_(s) = 1;
	PA.L(s)$a_(s) = 1;
	PY.L(s)$y_(s) = 1;
	PM.L(r)$m_(r) = 1;

*	Fix output and import supplies:

	SY.FX(s) = 1;
	SM.FX(r) = 1;

*	Benchmark replication:

	sy0(s) = 1;

*	Use outside good price as numeraire:

	PFX.FX = 1;

	bgravity.iterlim = 0;
	bgravity.savepoint = 1;

*	Provide an endowment which is sufficient to cover 
*	aggregate demand.  This is the standard strategy for 
*	closure of a partial equilibrium model in MPSGE:

	pfxendow = 4 * (sum(s,yref(s))+sum((r,s),mref(r,s)));

$include bgravity.GEN
	solve bgravity using mcp;

	bgravity.savepoint = 0;

$set scn bmk
	itlog(run,"%scn%","objval")	= bgravity.objval;
	itlog(run,"%scn%","modelstat")	= bgravity.modelstat;
	itlog(run,"%scn%","solvestat")	= bgravity.solvestat;

	ABORT$round(bgravity.objval,4)	"Benchmark replication fails.";

*	Assign transportation impedance which depends on the elasticity:

	tau_d(s,ss(loc))$(not sameas(s,ss)) = dist(s,loc)**(epsilon/(1-4*esub));
	tau_d(s,s(loc))                     = dist(s,loc)**(epsilon/(1-2*esub));

	tau_m(r,s)$m0(g) = sum(pd(loc), omega_m(g,r,pd) * dist(s,loc)**(epsilon/(1-2*esub)));
	tau_x(s,r)$x0(g) = sum(pd(loc), omega_x(g,pd,r) * dist(s,loc)**(epsilon/(1-2*esub)));

	sy0(s)$y0(g,s) = y0(g,s)/yref(s);
	SY.FX(s)$y0(g,s) = sy0(s)*PFX.L/PY.L(s);
	SM.FX(r) = PFX.L/PM.L(r);

	bgravity.iterlim = 10000;
$include bgravity.gen
	solve bgravity using mcp;

$set scn sfix
	itlog(run,"%scn%","objval")    = bgravity.objval;
	itlog(run,"%scn%","modelstat") = bgravity.modelstat;
	itlog(run,"%scn%","solvestat") = bgravity.solvestat;

*	Endogenize production and import supplies:

	SY.UP(s)        = +inf;
	SY.LO(s)        = 0;
	SY.L(s)$y0(g,s) = sy0(s) * (PFX.L/PY.L(s))$PY.L(s);

	SM.UP(r)      = +inf;
	SM.LO(r)      = 0;
	SM.L(r)$m_(r) = (PFX.L/PM.L(r))$PM.L(r);

	bgravity.iterlim = 10000;
$include bgravity.gen
	solve bgravity using mcp;

$set scn svar
	itlog(run,"%scn%","objval") = bgravity.objval;
	itlog(run,"%scn%","modelstat") = bgravity.modelstat;
	itlog(run,"%scn%","solvestat") = bgravity.solvestat;

*	Recalibrate the model with prices equal to unity and 
*	transactions quantities equal to values in the gravity framework:

	nref(ss,s) = ( PY_A.L(ss,s)*PY.L(ss)/PFX.L )$i_PY_A(ss,s);
	mref(r,s)  = ( PM_A.L(r,s)*PM.L(r)/PFX.L )$i_PM_A(r,s);
	xref(s,r)  = ( PY_X.L(s,r)*PY.L(s)/PFX.L )$d_PY_X(s,r);
	tau_d(ss,s) = 1;
	tau_m(r,s) = 1;
	tau_x(s,r) = 1;

	echop(s,"yref*") = sum(ss,nref(s,ss)) + sum(r,xref(s,r));
	echop(s,"aref*") = sum(ss,nref(ss,s)) + sum(r,mref(r,s))

	execute_loadpoint 'bgravity_p.gdx';
	bgravity.iterlim = 0;
$include BGRAVITY.GEN
	solve bgravity using mcp;

	ABORT$round(bgravity.objval,4)	"Gravity estimate replication fails.";

	yd0(g,s) = nref(s,s);
	yn0(g,s) = sum(ss,nref(s,ss)) - nref(s,s);
	yx0(g,s,r) = xref(s,r);
	dx0(g,s,ss) = nref(s,ss);
	
	nd0(g,s) = sum(ss,nref(ss,s)) - nref(s,s);
	md0(g,r,s) = mref(r,s);

	x0chk(g) = x0(g) - sum((s,r),yx0(g,s,r));
	display x0, yx0;

	m0chk(g) = m0(g) - sum((r,s),md0(g,r,s));
	display m0, md0;

	y0chk(g,s) = y0(g,s) - yd0(g,s) - yn0(g,s) - sum(r,yx0(g,s,r));
	a0chk(g,s) = a0(g,s) - yd0(g,s) - nd0(g,s) - sum(r,md0(g,r,s));

);

display echop;
option x0chk:3:0:1, m0chk:3:0:1, y0chk:3:0:1, a0chk:3:0:1;
display x0chk, m0chk, y0chk, a0chk;

gravitydata(g,st(s),"yn0") = yn0(g,s);
gravitydata(g,st(s),"yx0") = sum(r,yx0(g,s,r));
gravitydata(g,st(s),"md0") = sum(r,md0(g,r,s));
gravitydata(g,st(s),"yd0") = yd0(g,s);
gravitydata(g,st(s),"nd0") = nd0(g,s);

execute_unload '%output%', g, g_i, gravitydata, yx0, md0, dx0;
