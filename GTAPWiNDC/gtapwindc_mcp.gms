$title	Canonical Template GTAP-WINDC Model (MCP format)

*	Next, write down the same model using GAMS/MCP:

nonnegative
variables

*	$sectors:
	Y(g,r,s)		Production (includes I and G)
	C(r,s,h)		Consumption 
	X(i,r,s)		Disposition
	Z(i,r,s)		Armington demand
	FT(f,r,s)		Specific factor transformation
	M(i,r)			Import
	YT(j)			Transport

*	$commodities:
	PY(g,r,s)		Output price
	PZ(i,r,s)		Armington composite price
	PD(i,r,s)		Local goods price
	P(i,r)			National goods price
	PC(r,s,h)		Consumption price 
	PF(f,r,s)		Primary factors rent
	PS(f,g,r,s)		Sector-specific primary factors
	PM(i,r)			Import price
	PT(j)			Transportation services

*	$consumer:
	RH(r,s,h)		Representative household
	GOVT(r)			Public expenditure
	INV(r)			Investment;

equations
	prf_Y(g,r,s)		Production (includes I and G)
	prf_C(r,s,h)		Consumption 
	prf_X(i,r,s)		Disposition
	prf_Z(i,r,s)		Armington demand
	prf_FT(f,r,s)		Specific factor transformation
	prf_M(i,r)		Import
	prf_YT(j)		Transport

	mkt_PY(g,r,s)		Output price
	mkt_PZ(i,r,s)		Armington composite price
	mkt_PD(i,r,s)		Local goods price
	mkt_P(i,r)		National goods price
	mkt_PC(r,s,h)		Consumption price 
	mkt_PF(f,r,s)		Primary factors rent
	mkt_PS(f,g,r,s)		Sector-specific primary factors
	mkt_PM(i,r)		Import price
	mkt_PT(j)		Transportation services

	bal_RH(r,s,h)		Representative household
	bal_GOVT(r)		Public expenditure
	bal_INV(r)		Investment;

*	Produce a file which calibrates value shares for cost and revenue functions:

$echo *	Calibration code for mcf_mcp >%gams.scrdir%gtapwindc_mcp.gen	

*	-----------------------------------------------------------------------------------
parameter	theta_pl_y_va(r,s)	Labor value share;

$echo	theta_pl_y_va(r,s) = 0; theta_pl_y_va(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+kd0(r,s)*(1+tk0(r)));	>>%gams.scrdir%mcf_mcp.gen

*	Value-added cost index:

$macro	PI_Y_VA(r,s)	(PL(r)**theta_pl_y_va(r,s) * (RK(r,s)*(1+tk(r,s))/(1+tk0(r)))**(1-theta_pl_y_va(r,s)))

* $prod:Y(r,s)$y_(r,s)  s:0 va:1
*	   o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
$macro	O_Y_PY(r,g,s)	ys0(r,s,g)
*          i:PA(r,g)       q:id0(r,g,s)
$macro	I_PA_Y(r,g,s)	id0(r,g,s)
*          i:PL(r)         q:ld0(r,s)     va:
$macro	I_PL_Y(r,s)	(ld0(r,s) * PI_Y_VA(r,s) / PL(r))
*          i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))
$macro	I_RK_Y(r,s)	(kd0(r,s) * PI_Y_VA(r,s)*(1+tk0(r))/(RK(r,s)*(1+tk(r,s))))

*	Declare the arbitrage condition:

prf_Y(y_(r,s))..

	sum(g,PA(r,g)*I_PA_Y(r,g,s)) + I_PL_Y(r,s)*PL(r) + I_RK_Y(r,s)*RK(r,s)*(1+tk(r,s)) =g= 

		sum(g,PY(r,g)*O_Y_PY(r,g,s)*(1-ty(r,s)));

*	-----------------------------------------------------------------------------------
parameter	theta_PFX_X(r,g)	Export value share,
		theta_PN_X(r,g)		National value share
		theta_PD_X(r,g)		Domestic value share;

$echo	theta_PFX_X(r,g)$x_(r,g) = (x0(r,g)-rx0(r,g))/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));	>>%gams.scrdir%mcf_mcp.gen	
$echo	theta_PN_X(r,g)$x_(r,g) = xn0(r,g)/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));		>>%gams.scrdir%mcf_mcp.gen	
$echo	theta_PD_X(r,g)$x_(r,g) = xd0(r,g)/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));		>>%gams.scrdir%mcf_mcp.gen	

*	Unit revenue index:

$macro PI_X(r,g) ((theta_PFX_X(r,g)*PFX**(1+4) + theta_PN_X(r,g)*PN(g)**(1+4) + theta_PD_X(r,g)*PD(r,g)**(1+4))**(1/(1+4)))

* $prod:X(r,g)$x_(r,g)  t:4
*         o:PFX           q:(x0(r,g)-rx0(r,g))
$macro	O_X_PFX(r,g)	((x0(r,g)-rx0(r,g))*(PFX/PI_X(r,g))**4)
*         o:PN(g)         q:xn0(r,g)
$macro	O_X_PN(g,r)	(xn0(r,g)*(PN(g)/PI_X(r,g))**4)
*         o:PD(r,g)       q:xd0(r,g)
$macro	O_X_PD(r,g)	(xd0(r,g)*(PD(r,g)/PI_X(r,g))**4)
*         i:PY(r,g)       q:s0(r,g)
$macro	I_PY_X(r,g)	s0(r,g)

*	Declare the arbitrage condition:

prf_X(r,g)$x_(r,g)..	PY(r,g)*I_PY_X(r,g) =e= PFX*O_X_PFX(r,g) + PN(g)*O_X_PN(g,r) + PD(r,g)*O_X_PD(r,g);

*	-----------------------------------------------------------------------------------
parameter	theta_PN_A_d(r,g)	National value share in nest d,
		theta_PFX_A_dm(r,g)	Imported value share in nest dm;

$echo	theta_PN_A_d(r,g)$a_(r,g) = nd0(r,g)/(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%mcf_mcp.gen	
$echo	theta_PFX_A_dm(r,g)$a_(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>%gams.scrdir%mcf_mcp.gen

$macro PI_A_D(r,g)	((theta_PN_A_d(r,g)*PN(g)**(1-2)+(1-theta_PN_A_d(r,g))*PD(r,g)**(1-2))**(1/(1-2)))
$macro PI_A_DM(r,g)	((theta_PFX_A_dm(r,g)*(PFX*(1+tm(r,g))/(1+tm0(r,g)))**(1-4)+(1-theta_PFX_A_dm(r,g))*PI_A_D(r,g)**(1-4))**(1/(1-4)))


* $prod:A(r,g)$a_(r,g)  s:0 dm:4  d(dm):2
*         o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
$macro O_A_PA(r,g)	a0(r,g)
*         o:PFX           q:rx0(r,g)
$macro O_A_PFX(r,g)	rx0(r,g)
*         i:PN(g)         q:nd0(r,g)      d:
$macro I_PN_A(g,r)	(nd0(r,g)*(PI_A_DM(r,g)/PI_A_D(r,g))**4 * (PI_A_D(r,g)/PN(g))**2)
*         i:PD(r,g)       q:dd0(r,g)      d:
$macro I_PD_A(r,g)	(dd0(r,g)*(PI_A_DM(r,g)/PI_A_D(r,g))**4 * (PI_A_D(r,g)/PD(r,g))**2)
*         i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
$macro I_PFX_A(r,g)	(m0(r,g)*(PI_A_DM(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**4)
*         i:PM(r,m)       q:md0(r,m,g)
$macro I_PM_A(r,m,g)	md0(r,m,g)

*	Declare the arbitrage condition:

prf_a(r,g)$a_(r,g)..	sum(m,PM(r,m)*I_PM_A(r,m,g)) + PFX*(1+tm(r,g))*I_PFX_A(r,g) + PD(r,g)*I_PD_A(r,g) + PN(g)*I_PN_A(g,r) =e= 

					PFX*O_A_PFX(r,g) + PA(r,g)*O_A_PA(r,g)*(1-ta(r,g));

*	-----------------------------------------------------------------------------------
* $prod:MS(r,m)
*        o:PM(r,m)       q:(sum(gm, md0(r,m,gm)))
$macro O_MS_PM(r,m)	(sum(gm, md0(r,m,gm)))
*        i:PN(gm)        q:nm0(r,gm,m)
$macro I_PN_MS(gm,r,m)	(nm0(r,gm,m))
*        i:PD(r,gm)      q:dm0(r,gm,m)
$macro I_PD_MS(r,gm,m)	(dm0(r,gm,m))

prf_MS(r,m)..	sum(gm, PD(r,gm)*I_PD_MS(r,gm,m) + PN(gm)*I_PN_MS(gm,r,m)) =e= PM(r,m)*O_MS_PM(r,m);

*	-----------------------------------------------------------------------------------
parameter	thetac(r,g,h)	Consumption value share;
$echo	thetac(r,g,h) = cd0_h(r,g,h)/sum(g.local,cd0_h(r,g,h));	>>%gams.scrdir%mcf_mcp.gen

*	Use g.local in the cost function to designate elements of g which
*	are independent of set g dimensions appearing in equation in which 
*	this function appears.

$macro	PI_C(r,h)	(prod(g.local,PA(r,g)**thetac(r,g,h)))

* $prod:C(r,h)	  s:1
*        o:PC(r,h)       q:c0_h(r,h)
$macro	O_C_PC(r,h)	(c0_h(r,h))
*        i:PA(r,g)       q:cd0_h(r,g,h)
$macro	I_PA_C(r,g,h)	(cd0_h(r,g,h)*PI_C(r,h)/PA(r,g))	! N.B. Set g enters PI_C but is local to that macro

prf_c(r,h)..	sum(g, PA(r,g)*I_PA_C(r,g,h)) =e= PC(r,h)*O_C_PC(r,h);

*	-----------------------------------------------------------------------------------
* $prod:LS(r,h)
* 	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:tl(r,h)	p:(1-tl0(r,h))
$macro	O_LS_PL(q,r,h)	(le0(r,q,h))
* 	i:PLS(r,h)	q:ls0(r,h)
$macro	I_PLS_LS(r,h)	(ls0(r,h))

prf_LS(r,h)..	PLS(r,h)*I_PLS_LS(r,h) =e= sum(q, PL(q)*O_LS_PL(q,r,h)*(1-tl(r,h)));

*	-----------------------------------------------------------------------------------
parameter	betaks(r,s)	Capital supply value share;
betaks(r,s) = kd0(r,s) / sum((r.local,s.local), kd0(r,s));

$macro PI_KS	(sum((r.local,s.local), betaks(r,s)*RK(r,s)**(1+etak))**(1/(1+etak)))

* $prod:KS	t:etaK
* 	o:RK(r,s)	q:kd0(r,s)
$macro O_KS_RK(r,s) (kd0(r,s)*(RK(r,s)/PI_KS)**etak)
*	i:RKS		q:(sum((r,s),kd0(r,s)))
$macro I_RKS_KS	(sum((r.local,s.local),kd0(r,s)))

prf_ks..	RKS*I_RKS_KS =e= sum((r,s), RK(r,s)*O_KS_RK(r,s));

*	-----------------------------------------------------------------------------------
parameter	theta_PC_RA(r,h)	Value share of PC in RA;

$echo	theta_PC_RA(r,h) = c0_h(r,h)/(c0_h(r,h)+lsr0(r,h));	>>%gams.scrdir%mcf_mcp.gen

$macro	PI_RA(r,h)	((theta_PC_RA(r,h)*PC(r,h)**(1-esubL(r,h)) + (1-theta_PC_RA(r,h))*PLS(r,h)**(1-esubL(r,h)))**(1/(1-esubL(r,h))))
$macro  W_RA(r,h)	(RA(r,h)/((c0_h(r,h)+lsr0(r,h))*PI_RA(r,h)))

* $demand:RA(r,h)	  s:esubL(r,h)
*       d:PC(r,h)       q:c0_h(r,h)
$macro	D_PC_RA(r,h)	(c0_h(r,h) * W_RA(r,h) * (PI_RA(r,h)/PC(r,h))**esubL(r,h))
*	d:PLS(r,h)	q:lsr0(r,h)
$macro	D_PLS_RA(r,h)	(lsr0(r,h) * W_RA(r,h) * (PI_RA(r,h)/PLS(r,h))**esubL(r,h))
*	e:PLS(r,h)	q:(ls0(r,h)+lsr0(r,h))
$macro	E_RA_PLS(r,h)	(ls0(r,h)+lsr0(r,h))
*       e:PK		q:ke0(r,h)
$macro  E_RA_PK(r,h)	(ke0(r,h))
*	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))	r:TRANS
* 	e:PFX		q:(-sav0(r,h))			r:SAVRATE
$macro	E_RA_PFX(r,h)	(TRANS*sum(trn.local, hhtrn0(r,h,trn))-SAVRATE*sav0(r,h))

bal_ra(r,h)..	RA(r,h) =e= PLS(r,h) * E_RA_PLS(r,h) + PFX * E_RA_PFX(r,h) + PK * E_RA_PK(r,h);

*	-----------------------------------------------------------------------------------
* $demand:NYSE
*	d:PK
$macro	D_PK_NYSE	(NYSE/PK)
*	e:PY(r,g)	q:yh0(r,g)
$macro	E_NYSE_PY(r,g)	(yh0(r,g))
*	e:RKS		q:(sum((r,s),kd0(r,s)))	r:SSK
$macro	E_NYSE_RKS	(SSK*sum((r,s),kd0(r,s)))

bal_NYSE..	NYSE =e= sum((r,g),PY(r,g)*E_NYSE_PY(r,g)) + RKS*E_NYSE_RKS;

*	-----------------------------------------------------------------------------------
* $demand:INVEST  s:0
*	d:PA(r,g)	q:i0(r,g)
$macro	D_PA_INVEST(r,g)	(i0(r,g) * INVEST/sum((r.local,g.local),PA(r,g)*i0(r,g)))
*	e:PFX		q:totsav0	r:SAVRATE
*	e:PFX		q:fsav0
$macro	E_INVEST_PFX		(fsav0+SAVRATE*totsav0) 

bal_INVEST..	INVEST =e= PFX*fsav0 + SAVRATE*PFX*totsav0;


*	-----------------------------------------------------------------------------------
* $demand:GOVT
* 	d:PA(r,g)	q:g0(r,g)
$macro	D_PA_GOVT(r,g)	(g0(r,g)*GOVT/sum((r.local,g.local),PA(r,g)*g0(r,g)))
*	e:PFX           q:(-sum((r,h), trn0(r,h)))	r:TRANS	
*	e:PFX           q:govdef0
$macro	E_GOVT_PFX	(govdef0-TRANS*sum((r,h),trn0(r,h)))

bal_GOVT..	GOVT =e= PFX*(govdef0 - TRANS*sum((r,h),trn0(r,h))) +
				sum(y_(r,s), Y(r,s) * (sum(g,PY(r,g)*ys0(r,s,g)*ty(r,s)) + I_RK_Y(r,s)*RK(r,s)*tk(r,s))) +
				sum(a_(r,g), A(r,g) * (PA(r,g)*ta(r,g)*a0(r,g) + PFX*I_PFX_A(r,g)*tm(r,g))) +
				sum((r,h,q),   LS(r,h) * PL(q) * O_LS_PL(q,r,h) * tl(r,h));
				
*	Auxiliary constraints: one for each auxiliary variable.

aux_ssk..	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

aux_savrate..	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

aux_trans..	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

*	Market clearance conditions over the declared domain:

mkt_PA(r,g)$a0(r,g)..	sum(a_(r,g), A(r,g)*O_A_PA(r,g)) =g= sum(y_(r,s), Y(r,s)*I_PA_Y(r,g,s)) + 

				sum(h, C(r,h)*I_PA_C(r,g,h)) + D_PA_INVEST(r,g) + D_PA_GOVT(r,g);
	
mkt_PY(r,g)$s0(r,g)..		sum(y_(r,s), Y(r,s)*O_Y_PY(r,g,s)) + E_NYSE_PY(r,g) =e= sum(x_(r,g), X(r,g)*I_PY_X(r,g));
	
mkt_PD(r,g)..		sum(x_(r,g), X(r,g)*O_X_PD(r,g)) =e= sum(a_(r,g), A(r,g)*I_PD_A(r,g)) + sum((m,gm(g)), MS(r,m)*I_PD_MS(r,gm,m));
	
mkt_RK(r,s)$kd0(r,s)..	 KS*O_KS_RK(r,s) =e= Y(r,s)*I_RK_Y(r,s);
	
mkt_RKS..		E_NYSE_RKS =e= KS*I_RKS_KS;
	
mkt_PM(r,m)..		MS(r,m)*O_MS_PM(r,m) =e= sum(a_(r,g),A(r,g)*I_PM_A(r,m,g));
	
mkt_PC(r,h)..		C(r,h)*O_C_PC(r,h) =e= D_PC_RA(r,h);
	
mkt_PN(g)..		sum(x_(r,g), X(r,g)*O_X_PN(g,r)) =e= sum(a_(r,g), A(r,g)*I_PN_A(g,r)) + sum((r,m,gm(g)), MS(r,m)*I_PN_MS(gm,r,m));
	
mkt_PLS(r,h)..		E_RA_pls(r,h) =g= D_PLS_RA(r,h) + LS(r,h) * I_PLS_LS(r,h);
	
*	NB: The declared domain for PL is r and this set also drives LS(r,h).  Need to use 
*	a .local on the sum:

mkt_PL(r)..		sum(q(r), sum((r.local,h), LS(r,h)*O_LS_PL(q,r,h))) =e= sum(y_(r,s), Y(r,s)*I_PL_Y(r,s));
	
mkt_PK..		sum((r,h), E_RA_PK(r,h)) =e= D_PK_NYSE;
	
mkt_PFX..		sum(x_(r,g), X(r,g)*O_X_PFX(r,g)) + sum(a_(r,g), A(r,g)*O_A_PFX(r,g)) + 
				sum((r,h),E_RA_PFX(r,h)) + E_INVEST_PFX + E_GOVT_PFX =g= sum(a_(r,g), A(r,g)*I_PFX_A(r,g));

model mcf_mcp /

*	$sectors:
        prf_Y.Y,
        prf_X.X,
        prf_A.A,
	prf_LS.LS,
	prf_KS.KS,
        prf_C.C,
        prf_MS.MS,

*	$commodities:
        mkt_PA.PA,
        mkt_PY.PY,
        mkt_PD.PD,
        mkt_RK.RK,
	mkt_RKS.RKS,
        mkt_PM.PM,
        mkt_PC.PC,
        mkt_PN.PN,
	mkt_PLS.PLS,
        mkt_PL.PL,
	mkt_PK.PK,
        mkt_PFX.PFX,

*	$consumer:
        bal_RA.RA,
	bal_NYSE.NYSE,
	bal_INVEST.INVEST,
	bal_GOVT.GOVT,

*	$auxiliary:
	aux_SAVRATE.SAVRATE,
	aux_TRANS.TRANS,
	aux_SSK.SSK /;

PA.FX(r,g)$(not a0(r,g)) = 1;

mcf_mcp.workspace = 1000;
mcf_mcp.iterlim=0;
$include %gams.scrdir%mcf_mcp.gen
solve mcf_mcp using mcp;
abort$round(mcf_mcp.objval,4) "Benchmark calibration of mcf_mcp fails.";


*	Perform the same simulation in both models:

tl(r,h) = 0;

PK.FX = 1;

mcf_mcp.iterlim=10000;
$include %gams.scrdir%mcf_mcp.gen
solve mcf_mcp using mcp;
abort$round(mcf_mcp.objval,4) "Counterfactual simulation with mcf_mcp fails.";

mcf_mge.iterlim=0;
$include %gams.scrdir%mcf_mge.gen
solve mcf_mge using mcp;
abort$round(mcf_mge.objval,4) "Counterfactual consistency with mcf_mge fails.";

