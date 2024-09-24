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

$include %gams.scrdir%symmetric.gen
solve symmetric using mcp;

$exit

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
option limrow=0, limcol=0, solprint=off;
loop(yr,
	yb(yr) = yes;
	ED.L(g)$vx0(yb,g) = 1;

$include %gams.scrdir%supplyuse.gen
	solve supplyuse using mcp;

	put_utility kput, 'title'/ yr.tl,' tolerance = ',supplyuse.objval;

);
