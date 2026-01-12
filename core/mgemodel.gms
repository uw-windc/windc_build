$title MPSGE Model with Pooled National Markets

$ONTEXT
$model:mgemodel

$sectors:
	Y(r,s)$y_(r,s)		!	Production
	X(r,g)$x_(r,g)		!	Disposition
	A(r,g)$a_(r,g)		!	Absorption
	C(r)				!	Aggregate final demand
	MS(r,m)				!	Margin supply

$commodities:
	PA(r,g)$a0(r,g)		!	Regional market (input)
	PY(r,g)$s0(r,g)		!	Regional market (output)
	PD(r,g)$xd0(r,g)	!	Local market price
	PN(g)				!	National market
	PL(r)				!	Wage rate
	PK(r,s)$kd0(r,s)	!	Rental rate of capital
	PM(r,m)				!	Margin price
	PC(r)				!	Consumer price index
	PFX					!	Foreign exchange

$consumer:
	RA(r)				!	Representative agent

$prod:Y(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
	i:PA(r,g)	q:id0(r,g,s)
	i:PL(r)		q:ld0(r,s)	va:
	i:PK(r,s)	q:kd0(r,s)	va:

$prod:X(r,g)$x_(r,g)  t:4
	o:PFX		q:(x0(r,g)-rx0(r,g))
	o:PN(g)		q:xn0(r,g)
	o:PD(r,g)	q:xd0(r,g)
	i:PY(r,g)	q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta(r,g)	p:(1-ta0(r,g))
	o:PFX		q:rx0(r,g)
	i:PN(g)		q:nd0(r,g)	d:
	i:PD(r,g)	q:dd0(r,g)	d:
	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm(r,g) 	p:(1+tm0(r,g))
	i:PM(r,m)	q:md0(r,m,g)

$prod:MS(r,m)
	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
	i:PN(gm)	q:nm0(r,gm,m)
	i:PD(r,gm)	q:dm0(r,gm,m)

$prod:C(r)  s:1
	o:PC(r)		q:c0(r)
	i:PA(r,g)	q:cd0(r,g)

$demand:RA(r)
	d:PC(r)		q:c0(r)
	e:PY(r,g)	q:yh0(r,g)
	e:PFX		q:(bopdef0(r) + hhadj0(r))
	e:PA(r,g)	q:(-g0(r,g) - i0(r,g))
	e:PL(r)		q:(sum(s,ld0(r,s)))
	e:PK(r,s)	q:kd0(r,s)

$OFFTEXT
$SYSINCLUDE mpsgeset mgemodel -mt=1
