$title MCP Model with Pooled National Markets

$echo	*	Calibration assignments for the MCP model.	>%gams.scrdir%MCPMODEL.GEN

nonnegative
variables
	Y(r,s)		Production
	X(r,g)		Disposition
	A(r,g)		Absorption
	C(r)		Aggregate final demand
	MS(r,m)		Margin supply

	PA(r,g)		Regional market (input)
	PY(r,g)		Regional market (output)
	PD(r,g)		Local market price
	PN(g)		National market
	PL(r)		Wage rate
	PK(r,s)		Rental rate of capital
	PM(r,m)		Margin price
	PC(r)		Consumer price index
	PFX		Foreign exchange

	RA(r)		Representative agent

equations
	prf_Y(r,s)		Production
	prf_X(r,g)		Disposition
	prf_A(r,g)		Absorption
	prf_C(r)		Aggregate final demand
	prf_MS(r,m)		Margin supply

	mkt_PA(r,g)		Regional market (input)
	mkt_PY(r,g)		Regional market (output)
	mkt_PD(r,g)		Local market price
	mkt_PN(g)		National market
	mkt_PL(r)		Wage rate
	mkt_PK(r,s)		Rental rate of capital
	mkt_PM(r,m)		Margin price
	mkt_PC(r)		Consumer price index
	mkt_PFX			Foreign exchange

	bal_RA(r)		Representative agent;

* $prod:Y(r,s)$y_(r,s)  s:0 va:1
* 	o:PY(r,g)	q:ys0(r,s,g)            a:RA(r) t:ty(r,s)    p:(1-ty0(r,s))
* 	i:PA(r,g)	q:id0(r,g,s)
* 	i:PL(r)		q:ld0(r,s)	va:
* 	i:PK(r,s)	q:kd0(r,s)	va:

parameter	lvs(r,s)	Labor value share;

$echo	lvs(r,s) = 0; lvs(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+kd0(r,s));	>>%gams.scrdir%MCPMODEL.GEN	

$macro	PVA(r,s)	(PL(r)**lvs(r,s) * PK(r,s)**(1-lvs(r,s)))

$macro  LD(r,s)         (ld0(r,s)*PVA(r,s)/PL(r))
$macro  KD(r,s)		(kd0(r,s)*PVA(r,s)/PK(r,s))

prf_Y(y_(r,s))..

		sum(g, PA(r,g)*id0(r,g,s)) + 

			PL(r)*LD(r,s) + PK(r,s)*KD(r,s)
*			(ld0(r,s)+kd0(r,s)) * PVA(r,s)

				=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));

* $prod:X(r,g)$x_(r,g)  t:4
* 	o:PFX		q:(x0(r,g)-rx0(r,g))
* 	o:PN(g)		q:xn0(r,g)
* 	o:PD(r,g)	q:xd0(r,g)
* 	i:PY(r,g)	q:s0(r,g)

parameter	thetaxd(r,g)	Value share (output to PD market),
		thetaxn(r,g)	Value share (output to PN market),
		thetaxe(r,g)	Value share (output to PFX market);

$echo	thetaxd(r,g) = xd0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	thetaxn(r,g) = xn0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	thetaxe(r,g) = (x0(r,g)-rx0(r,g))/s0(r,g);	>>%gams.scrdir%MCPMODEL.GEN	

$macro	RX(r,g)	 (( thetaxd(r,g) * PD(r,g)**(1+4) + thetaxn(r,g) * PN(g)**(1+4) + thetaxe(r,g) * PFX**(1+4) )**(1/(1+4)))

prf_X(x_(r,g))..
		PY(r,g)*s0(r,g) =e= (x0(r,g)-rx0(r,g)+xn0(r,g)+xd0(r,g)) * RX(r,g);
			
* $prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
* 	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta(r,g)	p:(1-ta0(r,g))
* 	o:PFX		q:rx0(r,g)
* 	i:PN(g)		q:nd0(r,g)	d:
* 	i:PD(r,g)	q:dd0(r,g)	d:
* 	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm(r,g) 	p:(1+tm0(r,g))
* 	i:PM(r,m)	q:md0(r,m,g)
 
parameter	thetam(r,g)	Import value share
		thetan(r,g)	National value share;

$echo	thetam(r,g)=0; thetan(r,g)=0;								>>%gams.scrdir%MCPMODEL.GEN
$echo	thetam(r,g)$m0(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>%gams.scrdir%MCPMODEL.GEN
$echo	thetan(r,g)$nd0(r,g) = nd0(r,g) /(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%MCPMODEL.GEN

$macro PND(r,g)  ( (thetan(r,g)*PN(g)**(1-4) + (1-thetan(r,g))*PD(r,g)**(1-4))**(1/(1-4)) ) 
$macro PMND(r,g) ( (thetam(r,g)*(PFX*(1+tm(r,g))/(1+tm0(r,g)))**(1-2) + (1-thetam(r,g))*PND(r,g)**(1-2))**(1/(1-2)) )

prf_A(a_(r,g))..
	 	sum(m,PM(r,m)*md0(r,m,g)) + 
			(nd0(r,g)+dd0(r,g)+m0(r,g)*(1+tm0(r,g))) * PMND(r,g)
				=e= PA(r,g)*a0(r,g)*(1-ta(r,g)) + PFX*rx0(r,g);
* $prod:MS(r,m)
* 	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
* 	i:PN(gm)	q:nm0(r,gm,m)
* 	i:PD(r,gm)	q:dm0(r,gm,m)

prf_MS(r,m)..	sum(gm, PN(gm)*nm0(r,gm,m) + PD(r,gm)*dm0(r,gm,m)) =g= PM(r,m)*sum(gm, md0(r,m,gm));
 
* $prod:C(r)  s:1
*     	o:PC(r)		q:c0(r)
* 	i:PA(r,g)	q:cd0(r,g)
 

prf_C(r)..	prod(g$cd0(r,g), PA(r,g)**(cd0(r,g)/c0(r))) =g= PC(r);


* $demand:RA(r)
* 	d:PC(r)		q:c0(r)
* 	e:PY(r,g)	q:yh0(r,g)
* 	e:PFX		q:(bopdef0(r) + hhadj(r))
* 	e:PA(r,g)	q:(-g0(r,g) - i0(r,g))
* 	e:PL(r)		q:(sum(s,ld0(r,s)))
* 	e:PK(r,s)	q:kd0(r,s)

bal_RA(r)..	RA(r) =e= sum(g, PY(r,g)*yh0(r,g)) + PFX*(bopdef0(r) + hhadj(r))
				- sum(g, PA(r,g)*(g0(r,g)+i0(r,g))) 
				+ sum(s, PL(r)*ld0(r,s)) 
				+ sum(s, PK(r,s)*kd0(r,s))
				+ sum(y_(r,s), Y(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))
				+ sum(a_(r,g)$a0(r,g), A(r,g)*ta(r,g)*PA(r,g)*a0(r,g))
				+ sum(a_(r,g)$m0(r,g), A(r,g)*tm(r,g)*PFX*m0(r,g)*
						(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**2);

*	Market clearance conditions:

mkt_PA(a_(r,g))..	A(r,g)*a0(r,g) =e= sum(y_(r,s), Y(r,s)*id0(r,g,s)) 
					+ cd0(r,g)*C(r)*PC(r)/PA(r,g)
					+ g0(r,g) + i0(r,g);

mkt_PY(r,g)$s0(r,g)..	sum(y_(r,s), Y(r,s)*ys0(r,s,g)) + yh0(r,g) =e= X(r,g) * s0(r,g);

mkt_PD(r,g)$xd0(r,g)..	X(r,g)*xd0(r,g) * 

*	This is a tricky piece of code.  The PIP sector in HI has a single output from the 
*	X sector into the PD market.  This output is only used in margins which have a Leontief
*	demand structure.  In a counter-factual equilibrium, the price (PD("HI","PIP")) can then
*	fall to zero, and iso-elastic compensated supply function cannot be evaluated  (0/0).
*	We therefore need to differentiate between sectors with Leontief supply and those in 
*	which outputs are produce for multiple markets.  This is the sort of numerical nuisance
*	that is avoided when using MPSGE.

			( ( (PD(r,g)/RX(r,g))**4 )$round(1-thetaxd(r,g),6) + 1$(not round(1-thetaxd(r,g),6))) =e= 

				sum(a_(r,g), A(r,g) * dd0(r,g) * 
				(PND(r,g)/PD(r,g))**4 * (PMND(r,g)/PND(r,g))**2)
				+ sum((m,gm)$sameas(g,gm), dm0(r,gm,m)*MS(r,m));

mkt_PN(g)..		sum(x_(r,g), X(r,g) * xn0(r,g) * (PN(g)/PY(r,g))**4) =e= 
			sum(a_(r,g), A(r,g) * nd0(r,g) * (PND(R,G)/PN(g))**4 * (PMND(r,g)/PND(r,g))**2)
			+ sum((r,m,gm)$sameas(g,gm), nm0(r,gm,m)*MS(r,m));

mkt_PFX..		sum(x_(r,g), X(r,g)*(x0(r,g)-rx0(r,g))*(PFX/PY(r,g))**4) 
			+ sum(a_(r,g), A(r,g)*rx0(r,g)) 
			+ sum(r, bopdef0(r)+hhadj(r)) =e= 
			sum(a_(r,g), A(r,g)*m0(r,g)*(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**2);

mkt_PL(r)..	sum(s,ld0(r,s)) =g= sum(y_(r,s), Y(r,s)*ld0(r,s)*PVA(r,s)/PL(r));

mkt_PK(r,s)$kd0(r,s)..	kd0(r,s) =e= kd0(r,s)*Y(r,s)*PVA(r,s)/PK(r,s);

mkt_PM(r,m)..		MS(r,m)*sum(gm,md0(r,m,gm)) =e= sum(a_(r,g),md0(r,m,g)*A(r,g));

mkt_PC(r)..	C(r)*c0(r)*PC(r) =e= RA(r);


model mcpmodel /

	prf_Y.Y, prf_X.X, prf_A.A, prf_C.C, prf_MS.MS,

	mkt_PA.PA, mkt_PY.PY, mkt_PD.PD, mkt_PN.PN, mkt_PL.PL, mkt_PK.PK,
	mkt_PM.PM, mkt_PC.PC, mkt_PFX.PFX,

	bal_RA.RA  /;
