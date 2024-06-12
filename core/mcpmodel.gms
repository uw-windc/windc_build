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

	RA(r)		Representative agent;

PK.LO(r,s)$kd0(r,s) = 1e-5;

RA.L(r) = c0(r);

*	Fix to zero commodity prices and sectoral activity levels
*	which do not enter the model:

PA.FX(r,g)$(not a0(r,g)) = 0;
PY.FX(r,g)$(not s0(r,g)) = 0;
PD.FX(r,g)$(not xd0(r,g)) = 0;
PK.FX(r,s)$(not kd0(r,s)) = 0;
Y.FX(r,s)$(not y_(r,s)) = 0;
X.FX(r,g)$(not x_(r,g)) = 0;
A.FX(r,g)$(not a_(r,g)) = 0;

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

$macro	PI_Y(r,s)	(PL(r)**lvs(r,s)  * PK(r,s)**(1-lvs(r,s)))

*	Supply of commodity PY(r,g) per unit activity of sector Y(r,s) (compensated supply):

$macro  O_Y_PY(r,g,s)	(ys0(r,s,g))

*	Input from market PA(r,g) per unit activity of sector Y(r,s) (compensated demand):

$macro  I_PA_Y(r,g,s)   (id0(r,g,s))

*	Input from market PL(r) per unit activity of sector Y(r,s) (compensated demand):

$macro  I_PL_Y(r,s)     (ld0(r,s)*(PI_Y(r,s)/PL(r))$ld0(r,s))

*	Input from market PK(r,s) per unit activity of sector Y(r,s) (compensated demand):

$macro  I_PK_Y(r,s)	(kd0(r,s)*(PI_Y(r,s)/PK(r,s))$kd0(r,s))

*	Tax revenue payed to consumer RA per unit activity of sector Y(r,s):

$macro  R_Y_RA(r,s)	(sum(g,PY(r,g)*ty(r,s)*O_Y_PY(r,g,s)))


* $prod:X(r,g)$x_(r,g)  t:4
* 	o:PFX		q:(x0(r,g)-rx0(r,g))
* 	o:PN(g)		q:xn0(r,g)
* 	o:PD(r,g)	q:xd0(r,g)
* 	i:PY(r,g)	q:s0(r,g)

parameter	theta_X_PD(r,g)		Value share (output to PD market),
		theta_X_PN(r,g)		Value share (output to PN market),
		theta_X_PFX(r,g)	Value share (output to PFX market);

$echo	theta_X_PD(r,g)$s0(r,g) = xd0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	theta_X_PN(r,g)$s0(r,g) = xn0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	theta_X_PFX(r,g)$s0(r,g) = (x0(r,g)-rx0(r,g))/s0(r,g);	>>%gams.scrdir%MCPMODEL.GEN	

$macro	PI_X(r,g)	(( theta_X_PD(r,g) * PD(r,g)**(1+4) + theta_X_PN(r,g) * PN(g)**(1+4) + theta_X_PFX(r,g) * PFX**(1+4) )**(1/(1+4)))
$macro	O_X_PFX(r,g)	((x0(r,g)-rx0(r,g))*((PFX/PI_X(r,g))**4)$(x0(r,g)-rx0(r,g)))
$macro	O_X_PN(g,r)	(xn0(r,g)*((PN(g)/PI_X(r,g))**4)$xn0(r,g))

*	This is a tricky piece of code.  The PIP sector in HI has a single output from the 
*	X sector into the PD market.  This output is only used in margins which have a Leontief
*	demand structure.  In a counter-factual equilibrium, the price (PD("HI","PIP")) can then
*	fall to zero, and iso-elastic compensated supply function cannot be evaluated  (0/0).
*	We therefore need to differentiate between sectors with Leontief supply and those in 
*	which outputs are produce for multiple markets.  This is the sort of numerical nuisance
*	that is avoided when using MPSGE.

$macro	O_X_PD(r,g)	(xd0(r,g)*((((PD(r,g)/PI_X(r,g))**4)$round(1-theta_X_PD(r,g),6) + (1)$(not round(1-theta_X_PD(r,g),6))))$xd0(r,g))
$macro	I_PY_X(r,g)	(s0(r,g))

* $prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
* 	o:PA(r,g)	q:a0(r,g)		a:RA(r)	t:ta(r,g)	p:(1-ta0(r,g))
* 	o:PFX		q:rx0(r,g)
* 	i:PN(g)		q:nd0(r,g)	d:
* 	i:PD(r,g)	q:dd0(r,g)	d:
* 	i:PFX		q:m0(r,g)	dm: 	a:RA(r)	t:tm(r,g) 	p:(1+tm0(r,g))
* 	i:PM(r,m)	q:md0(r,m,g)
 
parameter	theta_pn_a(r,g)		Import value share
		theta_pd_a(r,g)		Import value share
		theta_pfx_a(r,g)	National value share;

$echo	theta_PN_A(r,g)=0; theta_PFX_A(r,g)=0;	theta_PD_A(r,g) = 0;					>>%gams.scrdir%MCPMODEL.GEN
$echo	theta_PFX_A(r,g)$m0(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>%gams.scrdir%MCPMODEL.GEN
$echo	theta_PN_A(r,g)$nd0(r,g) = nd0(r,g) /(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%MCPMODEL.GEN
$echo	theta_PD_A(r,g)$dd0(r,g) = dd0(r,g) /(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%MCPMODEL.GEN

$macro  PI_PFX_A(r,g)	(PFX*(1+tm(r,g))/(1+tm0(r,g)))

*	We need to evaluate a * X**b when a=0 and b<0 as zero:

$macro  PI_A_d(r,g)   ( (theta_PN_a(r,g)*(PN(g)**(1-4))$theta_PN_a(r,g) + theta_PD_A(r,g)*(PD(r,g)**(1-4))$theta_PD_A(r,g))**(1/(1-4)))
$macro  PI_A_dm(r,g)  ( (theta_PFX_A(r,g)*(PI_PFX_A(r,g)**(1-2))$theta_PFX_A(r,g) + (1-theta_PFX_A(r,g))*(PI_A_d(r,g)**(1-2))$(1-theta_PFX_A(r,g)))**(1/(1-2)))

$macro  O_A_PA(r,g)		(a0(r,g))
$macro  O_A_PFX(r,g)		(rx0(r,g))

$macro  I_PN_A(g,r)		(nd0(r,g)*((PI_A_dm(r,g)/PI_A_d(r,g))**2*(PI_A_d(r,g)/PN(g))**4)$nd0(r,g))
$macro  I_PD_A(r,g)		(dd0(r,g)*((PI_A_dm(r,g)/PI_A_d(r,g))**2*(PI_A_d(r,g)/PD(r,g))**4)$dd0(r,g))
$macro  I_PFX_A(r,g)		(m0(r,g)*((PI_A_dm(r,g)/PI_PFX_A(r,g))**2)$m0(r,g))

$macro  I_PM_A(r,m,g)		(md0(r,m,g))

*	Tax revenue paid to consumer RA(r) per unit activity of sector A(r,g), including both the output tax ta(r,g)
*	and the tax on imports tm(r,g):

$macro  R_A_RA(r,g)		(ta(r,g)*PA(r,g)*O_A_PA(r,g) + tm(r,g)*PFX*I_PFX_A(r,g))

* $prod:MS(r,m)
* 	o:PM(r,m)	q:(sum(gm, md0(r,m,gm)))
* 	i:PN(gm)	q:nm0(r,gm,m)
* 	i:PD(r,gm)	q:dm0(r,gm,m)

$macro O_MS_PM(r,m)	(sum(gm, md0(r,m,gm)))
$macro I_PN_MS(gm,r,m)	(nm0(r,gm,m))
$macro I_PD_MS(r,gm,m)	(dm0(r,gm,m))

* $prod:C(r)  s:1
*     	o:PC(r)		q:c0(r)
* 	i:PA(r,g)	q:cd0(r,g)
 
parameter	theta_PA_C(r,g)		Consumption value share;

$echo	theta_PA_C(r,g) = cd0(r,g)/sum(g.local,cd0(r,g));		>>%gams.scrdir%MCPMODEL.GEN

$macro  PI_C(r,n)	((prod(g.local$theta_PA_C(r,g), PA(r,g)**theta_PA_C(r,g)))$sameas(n,"s"))

$macro	O_C_PC(r)	(c0(r))
$macro	I_PA_C(r,g)	(cd0(r,g)*(PI_C(r,"s")/PA(r,g))$cd0(r,g))

* $demand:RA(r)
* 	d:PC(r)		q:c0(r)
* 	e:PY(r,g)	q:yh0(r,g)
* 	e:PFX		q:(bopdef0(r) + hhadj0(r))
* 	e:PA(r,g)	q:(-g0(r,g) - i0(r,g))
* 	e:PL(r)		q:(sum(s,ld0(r,s)))
* 	e:PK(r,s)	q:kd0(r,s)

$macro	E_RA_PY(r,g)	(yh0(r,g))
$macro	E_RA_PFX(r)	(bopdef0(r)+hhadj0(r))
$macro	E_RA_PA(r,g)	(-g0(r,g)-i0(r,g))
$macro	E_RA_PL(r)	(sum(s,ld0(r,s)))
$macro	E_RA_PK(r,s)	(kd0(r,s))
$macro	D_PC_RA(r)	(RA(r)/PC(r))

*	Zero profit condition: value of inputs from national market (PN(g)), domestic market (PD(r,g)) 
*	and imports (PFX) plus tax liability equals the value of supply to the PA(r,g) market and
*	re-exports to the PFX market:


prf_Y(r,s)..
		sum(g, PA(r,g)*I_PA_Y(r,g,s)) + 

			PL(r)*I_PL_Y(r,s) + PK(r,s)*I_PK_Y(r,s)  + R_Y_RA(r,s)

				=e= sum(g,PY(r,g)*O_Y_PY(r,g,s));
prf_X(r,g)..
			PY(r,g)*I_PY_X(r,g) =e= PFX*O_X_PFX(r,g) + PN(g)*O_X_PN(g,r) + PD(r,g)*O_X_PD(r,g);
			
prf_A(r,g)..

		 PN(g)*I_PN_A(g,r) + PD(r,g)*I_PD_A(r,g) + PFX*I_PFX_A(r,g) + sum(m,PM(r,m)*I_PM_A(r,m,g)) + R_A_RA(r,g)

				=e= PA(r,g)*O_A_PA(r,g) + PFX * O_A_PFX(r,g);

prf_MS(r,m)..	sum(gm, PN(gm)*I_PN_MS(gm,r,m) + PD(r,gm)*I_PD_MS(r,gm,m)) =g= PM(r,m)*O_MS_PM(r,m);
 
prf_C(r)..	sum(g, PA(r,g)*I_PA_C(r,g)) =g= PC(r)*O_C_PC(r);


*	Market clearance conditions: production outputs plus consumer endowments equal production inputs
*	plus consumer demand.

*	Aggregate absorption associated with intermediate and consumer demand:

mkt_PA(r,g)..		A(r,g)*O_A_PA(r,g) + E_RA_PA(r,g) =e= 

			sum(s, Y(r,s)*I_PA_Y(r,g,s)) + I_PA_C(r,g)*C(r);

*	Producer output supply and demand:

mkt_PY(r,g)..		sum(s, Y(r,s)*O_Y_PY(r,g,s)) + E_RA_PY(r,g) =e= X(r,g) * I_PY_X(r,g);

*	Regional market for goods:

mkt_PD(r,g)..		X(r,g)*O_X_PD(r,g) =E= A(r,g)*I_PD_A(r,g) + sum(m, MS(r,m)*I_PD_MS(r,g,m))$gm(g);

*	National market for goods:

mkt_PN(g)..		sum(r, X(r,g) * O_X_PN(g,r)) =e= 

			sum(r, A(r,g) * I_PN_A(g,r)) + sum((r,m), MS(r,m)*I_PN_MS(g,r,m))$gm(g);

*	Foreign exchange:

mkt_PFX..		sum(x_(r,g), X(r,g)*O_X_PFX(r,g)) + sum((r,g), A(r,g)*O_A_PFX(r,g)) + sum(r, E_RA_PFX(r)) 

					=g= sum((r,g), A(r,g) * I_PFX_A(r,g));
			
*	Labor market:

mkt_PL(r)..		E_RA_PL(r) =g= sum(s, Y(r,s)*I_PL_Y(r,s));

*	Capital stocks:

mkt_PK(r,s)..		E_RA_PK(r,s) =e= Y(r,s)*I_PK_Y(r,s);

*	Margin supply and demand:

mkt_PM(r,m)..		MS(r,m)*O_MS_PM(r,m) =e= sum(g, A(r,g) * I_PM_A(r,m,g));

*	Consumer demand:

mkt_PC(r)..		C(r)*O_C_PC(r) =e= D_PC_RA(r);

*	Income balance:

bal_RA(r)..	RA(r) =e= 

*	Endowment income from yh0(r,g):

			sum(g, PY(r,g)*E_RA_PY(r,g)) 

*	Wage income from ld0:

			+ PL(r)*E_RA_PL(r)

*	Income associated with bopdef(r) and hhadj0(r):

			+ PFX*E_RA_PFX(r)

*	Government and investment demand (g0(r,g) + i0(r,g)):

			+ sum(g, PA(r,g)*E_RA_PA(r,g))

*	Capital earnings (kd0(r,s)):

			+ sum(s, PK(r,s)*E_RA_PK(r,s)) 

*	Tax revenues are expressed as values per unit activity, so we
*	need multiply these by the activity level to compute total income:

			+ sum(y_(r,s), R_Y_RA(r,s)*Y(r,s))
			+ sum(a_(r,g), R_A_RA(r,g)*A(r,g));



model mcpmodel /

	prf_Y.Y, prf_X.X, prf_A.A, prf_C.C, prf_MS.MS,

	mkt_PA.PA, mkt_PY.PY, mkt_PD.PD, mkt_PN.PN, mkt_PL.PL, mkt_PK.PK,
	mkt_PM.PM, mkt_PC.PC, mkt_PFX.PFX,

	bal_RA.RA  /;
