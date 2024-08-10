$title	Template Model

$if not set ds $set ds gebalanced

set	yr(*)	Years with summary tables 
	s(*)	Sectors
	r(*)	Regions
	mrg	Margins /trd,trn/,
	xd	Exogenous demand /
*.		F010  	"Personal consumption expenditures",
		F02E  	"Nonresidential private fixed investment in equipment",
		F02N  	"Nonresidential private fixed investment in intellectual property products",
		F02R  	"Residential private fixed investment",
		F02S  	"Nonresidential private fixed investment in structures",
		F030  	"Change in private inventories",
		F06C  	"Federal Government defense: Consumption expenditures",
		F06E  	"Federal national defense: Gross investment in equipment",
		F06N  	"Federal national defense: Gross investment in intellectual property products",
		F06S  	"Federal national defense: Gross investment in structures",
		F07C  	"Federal Government nondefense: Consumption expenditures",
		F07E  	"Federal nondefense: Gross investment in equipment",
		F07N  	"Federal nondefense: Gross investment in intellectual property products",
		F07S  	"Federal nondefense: Gross investment in structures",
		F10C  	"State and local government consumption expenditures",
		F10E  	"State and local: Gross investment in equipment",
		F10N  	"State and local: Gross investment in intellectual property products",
		F10S  	"State and local: Gross investment in structures" /;

$gdxin %ds%.gdx
$load yr s r

alias (s,g);

parameter	
	ld0(yr,r,s)	Labor demand
	kd0(yr,r,s)	Capital demand
	lvs(yr,r,s)	Labor value share
	kl0(yr,r,s)	Aggregate factor earnings (K+L)
	x0(yr,r,g)	Regional exports
	d0(yr,r,g)	Domestic demand,
	rx0(yr,r,g)	Re-exports
	ns0(yr,r,g)	Supply to the national market 
	n0(yr,g)	National market aggregate supply
	a0(yr,r,g)	Absorption
	m0(yr,r,g)	Imports
	ty0(yr,r,s)	Output tax rate
	tm0(yr,r,g)	Import tariff
	ta0(yr,r,g)	Product tax
	nd0(yr,r,g)	National market demand,
	am(yr,r,mrg,g)	Trade and transport margin,
	ms0(yr,r,g,mrg)	Margin supply,
	ys0(yr,r,s,g)	Make matrix
	id0(yr,r,g,s)	Intermediate demand,
	id0(yr,r,g,s)	Intermediate demand,
	cd0(yr,r,g)	Final demand
	fd0(yr,r,g,xd)	Final demand
	md0(yr,r,mrg,g)	Margin demand;

$loaddc ys0 ld0 kd0 id0 rx0 x0 ms0 ns0 nd0 cd0 a0 m0 ty0 tm0 ta0 md0
$load fd0
parameter
	ty(yr,r,s)	Output tax rate
	tm(yr,r,g)	Import tariff
	ta(yr,r,g)	Product tax;

ty(yr,r,s) = ty0(yr,r,s);
tm(yr,r,g) = tm0(yr,r,g);
ta(yr,r,g) = ta0(yr,r,g);

*	Choose the base year

singleton set yb(yr) /2017/;

parameter	epsilonx(g)	Export demand elasticity;
epsilonx(g) = 2;

parameter	vx0(yr,g)	Aggregate exports,
		y0(yr,r,g)	Aggregate output,
		n0(yr,g)	Aggregate national market;

y0(yr,r,g) = sum(s,ys0(yr,r,s,g));
vx0(yr,g) = sum(r,x0(yr,r,g));
n0(yr,g) = sum(r,ns0(yr,r,g));

set	y_(yr,r,s)	Set of active Y sectors
	pa_(yr,r,g)	Set of active PA markets;

parameter	abstol /6/;
y_(yr,r,s) = round(sum(g,ys0(yr,r,s,g)),abstol);
pa_(yr,r,g) = a0(yr,r,g) + max(0,-sum(xd,fd0(yr,r,g,xd)))

parameter	profit	Check on profit;
profit(yr,r,s,"PY") = sum(g,ys0(yr,r,s,g));
profit(yr,r,s,"PA") = sum(g,id0(yr,r,g,s));
profit(yr,r,s,"VABAS") = ld0(yr,r,s) + kd0(yr,r,s) + sum(g,ys0(yr,r,s,g))*ty(yr,r,s);
profit(yr,r,s,"chk") = profit(yr,r,s,"PY") - profit(yr,r,s,"PA") - profit(yr,r,s,"VABAS");
option profit:3:1:1;
*.display profit;


parameter	market	Check on market clearance;
market(yr,r,g,"Y") = sum(s,ys0(yr,r,s,g));
market(yr,r,g,"ES") = x0(yr,r,g) - rx0(yr,r,g);
market(yr,r,g,"N") = ns0(yr,r,g);
market(yr,r,g,"MS") = sum(mrg,ms0(yr,r,g,mrg));
market(yr,r,g,"chk") = market(yr,r,g,"Y") - market(yr,r,g,"ES") - 
		    market(yr,r,g,"N") - market(yr,r,g,"MS");
option market:3:1:1;
*.display market;

alias (u,*);
profit(yr,r,s,u)$(not round(profit(yr,r,s,"chk"),6)) = 0;
display profit;

market(yr,r,g,u)$(not round(market(yr,r,g,"chk"),6)) = 0;
display market;


parameter	yd0(yr,r,g), vb(yr,r), vbchk;

yd0(yr,r,g) = 0;

vb(yr,r) = sum(g,cd0(yr,r,g)) + sum((g,xd),fd0(yr,r,g,xd)) - sum(s,ld0(yr,r,s)+kd0(yr,r,s))
		- sum(g$a0(yr,r,g), (m0(yr,r,g)-rx0(yr,r,g))*tm(yr,r,g) + a0(yr,r,g)*ta(yr,r,g))
		- sum(y_(yr,r,s),sum(g,ys0(yr,r,s,g))*ty(yr,r,s));
vbchk(yr) = sum(r,vb(yr,r));

display vb, vbchk;


$ontext
$model:mgemodel

$sectors:
	Y(r,s)$y_(yb,r,s)		! Production
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
$sysinclude mpsgeset mgemodel -mt=1

mgemodel.workspace=64;
mgemodel.iterlim = 0;

file kput; kput.lw=0; 
kput.nr=2; kput.nw=8; kput.nd=2; put kput;
option limrow=0, limcol=0, solprint=off;
loop(yr,
	yb(yr) = yes;
	ED.L(g)$vx0(yb,g) = 1;

$include %gams.scrdir%mgemodel.gen
	solve mgemodel using mcp;

	put_utility kput, 'title'/ yr.tl,' tolerance = ',mgemodel.objval;

);
