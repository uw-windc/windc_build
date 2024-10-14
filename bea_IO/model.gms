$title	General Equilibrium Models based on the BEA Input-Output Data

$include beadata

$ontext
$model:symmetric

$sectors:
	Y(r,s)$y_(yb,r,s)	! Production
	A(r,g)$a0(yb,r,g)	! Absorption
	ES(g)$vx0(yb,g)		! Export supply
	N(g)$n0(yb,g)		! National market supply
	MS(mrg)			! Margin supply

$commodities:
	PA(r,g)$pa_(yb,r,g)	! Regional market (input)
	PY(r,g)$y0(yb,r,g)	! Regional market (output)
	PX(g)$vx0(yb,g)		! Export market
	PN(g)$n0(yb,g)		! National market
	PK(r,s)$kd0_(yb,r,s)	! Rental rate of capital
	PI(mrg)			! Margin price
	PL(r)			! Wage rate
	PFX			! Foreign exchange

$consumer:
	RA(r)			! Representative agent
	ROW			! Rest of world (export demand)

$auxiliary:
	ED(g)$vx0(yb,g)		! Export demand

$prod:Y(r,s)$y_(yb,r,s)  s:0 va:1
	o:PY(r,s)	q:(ys0_(yb,r,s)) a:RA(r) t:(ty_(yb,r,s)) p:(1-ty0_(yb,r,s))
	i:PA(r,g)	q:(id0_(yb,r,g,s))
	i:PL(r)		q:(ld0_(yb,r,s))	va:
	i:PK(r,s)	q:(kd0_(yb,r,s))	va:

$prod:ES(g)$vx0(yb,g)  s:0.5  y:4
	o:PX(g)		q:(sum(r,x0(yb,r,g)))
	i:PY(r,g)	q:(x0(yb,r,g)-rx0(yb,r,g))   y:
	i:PFX		q:(sum(r,rx0(yb,r,g)))

$prod:N(g)$n0(yb,g)  t:4
	o:PN(g)		q:(n0(yb,g))
	i:PY(r,g)	q:(ns0(yb,r,g))

$prod:MS(mrg)  s:0.5
	o:PI(mrg)	q:(sum((r,g),ms0(yb,r,g,mrg)))
	i:PY(r,g)	q:(ms0(yb,r,g,mrg))

$prod:A(r,g)$a0(yb,r,g)  s:0 dm:2  d(dm):4
	o:PA(r,g)	q:(a0(yb,r,g))	a:RA(r)	t:(ta(yb,r,g)) p:(1-ta0(yb,r,g))
	i:PN(g)		q:(nd0(yb,r,g))		d:
	i:PY(r,g)	q:(yd0(yb,r,g))		d:
	i:PFX		q:(m0(yb,r,g)-rx0(yb,r,g))	dm:  a:RA(r)  t:(tm(yb,r,g)) p:(1+tm0(yb,r,g))
	i:PI(mrg)	q:(md0(yb,r,mrg,g))

$demand:RA(r)  s:1
	d:PA(r,g)	q:(cd0(yb,r,g))
	e:PFX		q:(vb(yb,r))
	e:PA(r,g)	q:(-sum(xd,fd0(yb,r,g,xd)))
	e:PL(r)		q:(sum(s,ld0(yb,r,s)))
	e:PK(r,s)	q:(kd0_(yb,r,s))

$demand:ROW
	e:PFX		q:(2*sum(g,vx0(yb,g)))
	e:PX(g)		q:(-vx0(yb,g))	r:ED(g)
	d:PFX		

$constraint:ED(g)$vx0(yb,g)
	ED(g) =e= (PX(g)/PFX)**(-epsilonx(g));

$offtext
$sysinclude mpsgeset symmetric -mt=1

symmetric.workspace=64;
symmetric.iterlim = 0;

ED.L(g)$vx0(yb,g) = 1;

*.$include %gams.scrdir%symmetric.gen
*.solve symmetric using mcp;

$ontext
$model:supplyuse

$sectors:
	Y(r,s)$y_(yb,r,s)	! Production
	A(r,g)$a0(yb,r,g)	! Absorption
	ES(g)$vx0(yb,g)		! Export supply
	N(g)$n0(yb,g)		! National market supply
	MS(mrg)			! Margin supply

$commodities:
	PA(r,g)$pa_(yb,r,g)	! Regional market (input)
	PY(r,g)$y0(yb,r,g)	! Regional market (output)
	PX(g)$vx0(yb,g)		! Export market
	PN(g)$n0(yb,g)		! National market
	PK(r,s)$kd0(yb,r,s)	! Rental rate of capital
	PI(mrg)			! Margin price
	PL(r)			! Wage rate
	PFX			! Foreign exchange

$consumer:
	RA(r)			! Representative agent
	ROW			! Rest of world (export demand)

$auxiliary:
	ED(g)$vx0(yb,g)		! Export demand

$prod:Y(r,s)$y_(yb,r,s)  s:0 va:1
	o:PY(r,g)	q:(ys0(yb,r,s,g)) a:RA(r) t:(ty(yb,r,s)) p:(1-ty0(yb,r,s))
	i:PA(r,g)	q:(id0(yb,r,g,s))
	i:PL(r)		q:(ld0(yb,r,s))	va:
	i:PK(r,s)	q:(kd0(yb,r,s))	va:

$prod:ES(g)$vx0(yb,g)  s:0.5  y:4
	o:PX(g)		q:(sum(r,x0(yb,r,g)))
	i:PY(r,g)	q:(x0(yb,r,g)-rx0(yb,r,g))   y:
	i:PFX		q:(sum(r,rx0(yb,r,g)))

$prod:N(g)$n0(yb,g)  t:4
	o:PN(g)		q:(n0(yb,g))
	i:PY(r,g)	q:(ns0(yb,r,g))

$prod:MS(mrg)  s:0.5
	o:PI(mrg)	q:(sum((r,g),ms0(yb,r,g,mrg)))
	i:PY(r,g)	q:(ms0(yb,r,g,mrg))

$prod:A(r,g)$a0(yb,r,g)  s:0 dm:2  d(dm):4
	o:PA(r,g)	q:(a0(yb,r,g))	a:RA(r)	t:(ta(yb,r,g)) p:(1-ta0(yb,r,g))
	i:PN(g)		q:(nd0(yb,r,g))		d:
	i:PY(r,g)	q:(yd0(yb,r,g))		d:
	i:PFX		q:(m0(yb,r,g)-rx0(yb,r,g))	dm:  a:RA(r)  t:(tm(yb,r,g)) p:(1+tm0(yb,r,g))
	i:PI(mrg)	q:(md0(yb,r,mrg,g))

$demand:RA(r)  s:1
	d:PA(r,g)	q:(cd0(yb,r,g))
	e:PFX		q:(vb(yb,r))
	e:PA(r,g)	q:(-sum(xd,fd0(yb,r,g,xd)))
	e:PL(r)		q:(sum(s,ld0(yb,r,s)))
	e:PK(r,s)	q:(kd0(yb,r,s))

$demand:ROW
	e:PFX		q:(2*sum(g,vx0(yb,g)))
	e:PX(g)		q:(-vx0(yb,g))	r:ED(g)
	d:PFX		

$constraint:ED(g)$vx0(yb,g)
	ED(g) =e= (PX(g)/PFX)**(-epsilonx(g));

$offtext
$sysinclude mpsgeset supplyuse -mt=1

supplyuse.workspace=64;
supplyuse.iterlim = 0;

file kput; kput.lw=0; 
kput.nr=2; kput.nw=8; kput.nd=2; put kput;
*.option limrow=0, limcol=0, solprint=off;
ED.L(g)$vx0(yb,g) = 1;
y_(yr,r,s) = yes$sum(g$round(ys0(yr,r,s,g),5),1);

*$include %gams.scrdir%supplyuse.gen
*.solve supplyuse using mcp;

*	Cinch the supply-use dataset:

ys0(yb,r,s,g)$ys0(yb,r,s,g) = ys0(yb,r,s,g) * 
	sum(r.local, (x0(yb,r,g)-rx0(yb,r,g)) +
	( ns0(yb,r,g) )$n0(yb,g) +
	sum(mrg,ms0(yb,r,g,mrg)) +
	( yd0(yb,r,g) )$a0(yb,r,g)) /
	sum(y_(yb,r.local,s.local),ys0(yb,r,s,g));

ys0_(yb,r,g) = 
	x0(yb,r,g)-rx0(yb,r,g) + 
	ns0(yb,r,g) +
	sum(mrg,ms0(yb,r,g,mrg)) +
	yd0(yb,r,g);

parameter	marketbal	Cross check on market balance;
marketbal(r,g,"ys0") = 	sum(y_(yb,r,s),ys0(yb,r,s,g));
marketbal(r,g,"x0") =   (x0(yb,r,g)-rx0(yb,r,g));
marketbal(r,g,"ns0") =  ( ns0(yb,r,g) )$n0(yb,g);
marketbal(r,g,"ms0") = sum(mrg,ms0(yb,r,g,mrg));
marketbal(r,g,"yd0") = ( yd0(yb,r,g) )$a0(yb,r,g);
marketbal(r,g,"chk") = marketbal(r,g,"ys0") 
			- marketbal(r,g,"x0")
			- marketbal(r,g,"ns0")
			- marketbal(r,g,"ms0")
			- marketbal(r,g,"yd0");
option marketbal:3:2:1;
display marketbal;

marketbal(r,g,"ys0") = 	ys0_(yb,r,g);
marketbal(r,g,"x0") =   (x0(yb,r,g)-rx0(yb,r,g))$vx0(yb,g);
marketbal(r,g,"ns0") =  ( ns0(yb,r,g) )$n0(yb,g);
marketbal(r,g,"ms0") = sum(mrg,ms0(yb,r,g,mrg));
marketbal(r,g,"yd0") = ( yd0(yb,r,g) )$a0(yb,r,g);
marketbal(r,g,"chk") = marketbal(r,g,"ys0") 
			- marketbal(r,g,"x0")
			- marketbal(r,g,"ns0")
			- marketbal(r,g,"ms0")
			- marketbal(r,g,"yd0");
option marketbal:3:2:1;
display marketbal;

set	ags(s)  Agricultural sectors/ 
		osd_agr  "Oilseed farming (1111A0)",
		grn_agr  "Grain farming (1111B0)",
		veg_agr  "Vegetable and melon farming (111200)",
		nut_agr  "Fruit and tree nut farming (111300)",
		flo_agr  "Greenhouse, nursery, and floriculture production (111400)",
		oth_agr  "Other crop farming (111900)",
		dry_agr  "Dairy cattle and milk production (112120)",
		bef_agr  "Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)",
		egg_agr  "Poultry and egg production (112300)",
		ota_agr  "Animal production, except cattle and poultry and eggs (112A00)" /;

parameter	content;

set		m_s(*)	Model structure;

*	symm	Symmetri
*	suse	Supply-Use

variable	OBJ	Objective function;

equations	objdef, market_PY, market_PI, market_PA, market_PX, market_PN;

objdef..		OBJ =e= sum((r,s), content(r,s)*Y(r,s));

market_PY(r,g)$y0(yb,r,g)..

	  sum(y_(yb,r,s), ys0(yb,r,s,g)*Y(r,s))$m_s("suse")
 		        + (ys0_(yb,r,g)*Y(r,g))$m_s("symm")
		=e=	( ES(g)*(x0(yb,r,g)-rx0(yb,r,g)) )$vx0(yb,g) +
			( N(g)*ns0(yb,r,g) )$n0(yb,g) +
			sum(mrg,MS(mrg)*ms0(yb,r,g,mrg)) +
			( A(r,g)*yd0(yb,r,g) )$a0(yb,r,g);

market_PI(mrg)..	MS(mrg)*sum((r,g),ms0(yb,r,g,mrg)) =e= 
				sum((r,g)$a0(yb,r,g), A(r,g)*md0(yb,r,mrg,g));

market_PA(r,g)$pa_(yb,r,g)..
		A(r,g)*a0(yb,r,g) =e= cd0(yb,r,g) + sum(xd,fd0(yb,r,g,xd))
				+ sum(y_(yb,r,s), Y(r,s)*id0(yb,r,g,s))$m_s("suse")
				+ sum(y_(yb,r,s), Y(r,s)*id0_(yb,r,g,s))$m_s("symm");

market_PX(g)$vx0(yb,g)..	ES(g)*sum(r,x0(yb,r,g)) =g= vx0(yb,g);

market_PN(g)$n0(yb,g)..		N(g)*n0(yb,g) =e= sum(r, A(r,g)*nd0(yb,r,g));

model atmLP /objdef, market_PY, market_PI, market_PA, market_PX, market_PN /;

set	mtype /symm, suse/;

parameter	debug	AGS flows;
loop(s$sameas(s,"asp_fbp"),
  debug("ags_output","symm") = ys0_(yb,"usa",s)$ags(s);
  debug("ags_output","suse") = sum(ags(g),ys0(yb,"usa",s,g));
  debug("ags_input","symm") = sum(ags(g),id0_(yb,"usa",g,s));
  debug("ags_input","suse") = sum(ags(g),id0(yb,"usa",g,s));
);
option debug:3;
display debug;


parameter	atmval(g,*,mtype)	ATM value;

option LP=conopt;
loop(mtype,
	m_s(mtype) = yes;
	content(r,s) = ys0_(yb,r,s)$(ags(s) and m_s("symm")) + sum(ags(g),ys0(yb,r,s,g))$m_s("suse");
	solve atmLP using lp minimizing OBJ;
	atmval(g,"PX",mtype) = 1000 * (market_PX.m(g) - 1$ags(g));
	atmval(g,"PY",mtype) =  1000 * (market_PY.m("usa",g) - 1$ags(g));
	atmval(g,"PA",mtype) =  1000 * (market_PA.m("usa",g) - 1$ags(g));
	m_s(mtype) = no;

);
option atmval:3;
display atmval;

execute_unload 'atmval.gdx', atmval, atmpy;

$exit

parameter	v_PY(r,s)	Agricultural content - state output
		v_PX(g)		Agricultural content - exports
		v_PN(g)		Agricultural content - national market
		v_PI(mrg)	Agricultural content - margin
		v_PA(r,g)	Agricultural content - absorption;

v_PY(r,g) = market_PY.M(r,g);
v_PX(g) = market_PX.M(g);
v_PN(g) = market_PN.M(g);
v_PI(mrg) = market_PI.M(mrg);
v_PA(r,g) = market_PA.M(r,g);

v_PX(g)$vx0(yb,g) = v_PX(g) - ( sum(r,v_PY(r,g)*(x0(yb,r,g)-rx0(yb,r,g)))/ sum(r,x0(yb,r,g)) );

v_PN(g)$n0(yb,g) = v_PN(g) - sum(r,v_PY(r,g)*ns0(yb,r,g))/n0(yb,g);

v_PI(mrg) = v_PI(mrg) - sum((r,g),v_PY(r,g)*ms0(yb,r,g,mrg))/sum((r,g),ms0(yb,r,g,mrg));

v_PA(r,g)$a0(yb,r,g) = v_PA(r,g) - ( (v_PN(g)*nd0(yb,r,g))$n0(yb,g) + v_PY(r,g)*yd0(yb,r,g) +
		sum(mrg,v_PI(mrg)*md0(yb,r,mrg,g))) / a0(yb,r,g);

option v_PY:3:0:1, v_PX:3:0:1, v_PN:3:0:1, v_PI:3:0:1, v_PA:3:0:1;

display v_PY, v_PX, v_PN, v_PI, v_PA;


$exit

loop(yr,
	yb(yr) = yes;
	ED.L(g)$vx0(yb,g) = 1;

$include %gams.scrdir%supplyuse.gen
	solve supplyuse using mcp;

	put_utility kput, 'title'/ yr.tl,' tolerance = ',supplyuse.objval;

);


$gdxin 'atmalt.gdx'
$loaddc v_PY v_PX v_PN v_PI v_PA
display v_PY, market_PY.M,
	v_PX, market_PX.M,
	v_PN, market_PN.M,
	v_PI, market_PI.M,
	v_PA, market_PA.M;

