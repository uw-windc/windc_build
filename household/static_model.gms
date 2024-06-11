$title Static household model (MGE and MCP)


* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* Set datset option
$set ds cps_static_all_2022

* Allow for end of line comments
$eolcom !


* -----------------------------------------------------------------------------
* Read in the static household dataset
* -----------------------------------------------------------------------------

* Read in the household dataset

$include windc_hhdata

parameter
    lse_inc	Labor supply income elasticity /-.05/,
    lse_sub	Labor supply substitution elasticity /.2/,
    lsr0(r,h)	Leisure demand,
    ls0(r,h)	Labor supply (net),
    esubL(r,h)	Leisure-consumption elasticity,
    etaK	Capital transformation elasticity /4/,
    ta(r,g)	Counterfactual consumption taxes,
    ty(r,s)	Counterfactual production taxes
    tm(r,g)	Counterfactual import taxes,
    tk(r,s)	Counterfactual capital taxes,
    tfica(r,h)	Counterfactual FICA labor taxes,
    tl(r,h)	Counterfactual marginal labor taxes;

* Calibrated labor-leisure choice based on McClelland and Mok (2012)

ls0(r,h) = sum(q,le0(r,q,h))*(1-tl0(r,h)-tfica0(r,h));
lsr0(r,h) = -lse_inc * ls0(r,h);
esubL(r,h) = lse_sub*(c0_h(r,h)+lsr0(r,h))/c0_h(r,h)*ls0(r,h)/lsr0(r,h);

* Counterfactual tax rates set to reference levels

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
tfica(r,h) = tfica0(r,h);
tl(r,h) = tl0(r,h);


* -----------------------------------------------------------------------------
* Static MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:static_hh_mge

$sectors:
        Y(r,s)$y_(r,s)          !       Production
        X(r,g)$x_(r,g)          !       Disposition
        A(r,g)$a_(r,g)          !       Absorption
	LS(r,h)			!	Labor supply
	KS			!	Aggregate capital stock
        C(r,h)			!       Household consumption
        MS(r,m)                 !       Margin supply

$commodities:
        PA(r,g)$a0(r,g)         !       Regional market (input)
        PY(r,g)$s0(r,g)         !       Regional market (output)
        PD(r,g)$pd_(r,g)        !       Local market price
        RK(r,s)$kd0(r,s)	!       Sectoral rental rate
	RKS			!	Capital stock
        PM(r,m)                 !       Margin price
        PC(r,h)			!       Consumer price index
        PN(g)$pn_(g)            !       National market price for goods
	PLS(r,h)		!	Leisure price
        PL(r)                   !       Regional wage rate
	PK			!     	Aggregate return to capital
        PFX                     !       Foreign exchange

$consumer:
        RA(r,h)			!	Representative agent
	NYSE			!	Aggregate capital owner
	INVEST			!	Aggregate investor
	GOVT			!	Aggregate government
	ROW$fint0		!	Aggregate rest of world

$auxiliary:
	SAVRATE			!	Domestic savings rate
	TRANS			!	Budget balance rationing variable
	SSK			!	Steady-state capital stock
	CPI			!	Consumer price index

$prod:Y(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
        i:PA(r,g)       q:id0(r,g,s)
        i:PL(r)         q:ld0(r,s)     va:
        i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

$report:
	v:KD(r,s)$kd0(r,s)	i:RK(r,s)	prod:Y(r,s)

$prod:X(r,g)$x_(r,g)  t:4
        o:PFX           q:(x0(r,g)-rx0(r,g))
        o:PN(g)         q:xn0(r,g)
        o:PD(r,g)       q:xd0(r,g)
        i:PY(r,g)       q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
        o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
        o:PFX           q:rx0(r,g)
        i:PN(g)         q:nd0(r,g)      d:
        i:PD(r,g)       q:dd0(r,g)      d:
        i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
        i:PM(r,m)       q:md0(r,m,g)

$report:
	v:MD(r,g)$m0(r,g)	i:PFX	prod:A(r,g)

$prod:MS(r,m)
        o:PM(r,m)       q:(sum(gm, md0(r,m,gm)))
        i:PN(gm)        q:nm0(r,gm,m)
        i:PD(r,gm)      q:dm0(r,gm,m)

$prod:C(r,h)	  s:1
        o:PC(r,h)       q:c0_h(r,h)
        i:PA(r,g)       q:cd0_h(r,g,h)

$prod:LS(r,h)
	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:(tl(r,h)+tfica(r,h))	p:(1-tl0(r,h)-tfica0(r,h))
	i:PLS(r,h)	q:ls0(r,h)

$prod:KS	t:etaK
	o:RK(r,s)	q:kd0(r,s)
	i:RKS		q:(sum((r,s),kd0(r,s)))

$demand:RA(r,h)	  s:esubL(r,h)
        d:PC(r,h)       q:c0_h(r,h)
	d:PLS(r,h)	q:lsr0(r,h)
	e:PLS(r,h)	q:(ls0(r,h)+lsr0(r,h))
	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))	r:TRANS
	e:PLS(r,h)	q:((tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))
        e:PK		q:ke0(r,h)
	e:PFX		q:(-sav0(r,h))	r:SAVRATE

$report:
	v:W(r,h)	w:RA(r,h)

$demand:NYSE
	d:PK
	e:PY(r,g)	q:yh0(r,g)
	e:RKS		q:(sum((r,s),kd0(r,s)))	r:SSK

$demand:INVEST  s:0
	d:PA(r,g)	q:i0(r,g)
	e:PFX		q:totsav0	r:SAVRATE
	e:PFX		q:fsav0

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX           q:(-sum((r,h), trn0(r,h)))	r:TRANS	
	e:PFX           q:govdef0
	e:PLS(r,h)	q:(-(tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))

$demand:ROW$fint0
    	d:PFX
	e:PK		q:fint0
	
$constraint:SSK
	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

$constraint:TRANS
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

$constraint:CPI
    	CPI =e= sum((r,h), PC(r,h)*c0_h(r,h))/sum((r,h),c0_h(r,h));

$offtext
$sysinclude mpsgeset static_hh_mge -mt=1

* Set the numeraire:

PFX.FX = 1;

* Starting values for other auxiliary variables:

CPI.L = 1;
TRANS.L = 1;
SAVRATE.L = 1;
SSK.L = 1;

static_hh_mge.workspace = 10000;
static_hh_mge.iterlim=0;
$include %gams.scrdir%static_hh_mge.gen
solve static_hh_mge using mcp;
abort$round(static_hh_mge.objval,3) "Benchmark calibration of static_hh_mge fails.";


* -----------------------------------------------------------------------------
* Static GAMS/MCP Model
* -----------------------------------------------------------------------------

nonnegative
variables

*	$sectors:
        Y(r,s)		Production
        X(r,g)		Disposition
        A(r,g)		Absorption
	LS(r,h)		Labor supply
	KS		Aggregate capital stock
        C(r,h)		Household consumption
        MS(r,m)		Margin supply

*	$commodities:
        PA(r,g)		Regional market (input)
        PY(r,g)		Regional market (output)
        PD(r,g)		Local market price
        RK(r,s)		Sectoral rental rate
	RKS		Capital stock
        PM(r,m)		Margin price
        PC(r,h)		Consumer price index
        PN(g)		National market price for goods
	PLS(r,h)	Leisure price
        PL(r)		Regional wage rate
	PK		Aggregate return to capital
        PFX		Foreign exchange

*	$consumer:
        RA(r,h)		Representative agent
	NYSE		Aggregate capital owner
	INVEST		Aggregate investor
	GOVT		Aggregate government
	ROW		Aggregate rest of world

*	$auxiliary:
	SAVRATE		Domestic savings rate
	TRANS		Budget balance rationing variable
	SSK		Steady-state capital stock
	CPI		Consumer price index;

equations
	prf_Y(r,s)	Production
	prf_X(r,g)	Disposition
	prf_A(r,g)	Absorption
	prf_LS(r,h)	Labor supply
	prf_KS		Aggregate capital stock
	prf_C(r,h)	Household consumption
	prf_MS(r,m)	Margin supply

	mkt_PA(r,g)	Regional market (input)
	mkt_PY(r,g)	Regional market (output)
	mkt_PD(r,g)	Local market price
	mkt_RK(r,s)	Sectoral rental rate
	mkt_RKS		Capital stock
	mkt_PM(r,m)	Margin price
	mkt_PC(r,h)	Consumer price index
	mkt_PN(g)	National market price for goods
	mkt_PLS(r,h)	Leisure price
	mkt_PL(r)	Regional wage rate
	mkt_PK		Aggregate return to capital
	mkt_PFX		Foreign exchange

	bal_RA(r,h)	Representative agent
	bal_NYSE	Aggregate capital owner
	bal_INVEST	Aggregate investor
	bal_GOVT	Aggregate government
	bal_ROW		Aggregate rest of world

	aux_SAVRATE	Domestic savings rate
	aux_TRANS	Budget balance rationing variable
	aux_SSK		Steady-state capital stock
	aux_CPI		Consumer price index;

*	Produce a file which calibrates value shares for cost and revenue functions:

$echo *	Calibration code for static_hh_mcp >%gams.scrdir%static_hh_mcp.gen	

*	-----------------------------------------------------------------------------------
parameter	theta_pl_y_va(r,s)	Labor value share;

$echo	theta_pl_y_va(r,s) = 0; theta_pl_y_va(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+kd0(r,s)*(1+tk0(r)));	>>%gams.scrdir%static_hh_mcp.gen

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

$echo	theta_PFX_X(r,g)$x_(r,g) = (x0(r,g)-rx0(r,g))/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));	>>%gams.scrdir%static_hh_mcp.gen	
$echo	theta_PN_X(r,g)$x_(r,g) = xn0(r,g)/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));		>>%gams.scrdir%static_hh_mcp.gen	
$echo	theta_PD_X(r,g)$x_(r,g) = xd0(r,g)/(x0(r,g)-rx0(r,g) + xn0(r,g) + xd0(r,g));		>>%gams.scrdir%static_hh_mcp.gen	

*	Unit revenue index:

$macro PI_X(r,g) ((theta_PFX_X(r,g)*PFX**(1+4) + theta_PN_X(r,g)*PN(g)**(1+4) + theta_PD_X(r,g)*PD(r,g)**(1+4))**(1/(1+4)))

* $prod:X(r,g)$x_(r,g)  t:4
*         o:PFX           q:(x0(r,g)-rx0(r,g))
$macro	O_X_PFX(r,g)	((x0(r,g)-rx0(r,g))*((PFX/PI_X(r,g))**4)$(x0(r,g)-rx0(r,g)))
*         o:PN(g)         q:xn0(r,g)
$macro	O_X_PN(g,r)	(xn0(r,g)*((PN(g)/PI_X(r,g))**4)$xn0(r,g))

*	This is a tricky piece of code.  The PIP sector in HI has a single output from the 
*	X sector into the PD market.  This output is only used in margins which have a Leontief
*	demand structure.  In a counter-factual equilibrium, the price (PD("HI","PIP")) can then
*	fall to zero, and iso-elastic compensated supply function cannot be evaluated  (0/0).
*	We therefore need to differentiate between sectors with Leontief supply and those in 
*	which outputs are produce for multiple markets.  This is the sort of numerical nuisance
*	that is avoided when using MPSGE.

$macro	O_X_PD(r,g)	(xd0(r,g)*((((PD(r,g)/PI_X(r,g))**4)$round(1-theta_PD_X(r,g),6) + (1)$(not round(1-theta_PD_X(r,g),6))))$xd0(r,g))
*         i:PY(r,g)       q:s0(r,g)
$macro	I_PY_X(r,g)	s0(r,g)

*	Declare the arbitrage condition:

prf_X(r,g)$x_(r,g)..	PY(r,g)*I_PY_X(r,g) =e= PFX*O_X_PFX(r,g) + PN(g)*O_X_PN(g,r) + PD(r,g)*O_X_PD(r,g);

*	-----------------------------------------------------------------------------------
parameter	theta_PN_A_d(r,g)	National value share in nest d,
		theta_PD_A_d(r,g)       Regional value share in nest d,
		theta_PFX_A_dm(r,g)	Imported value share in nest dm;

$echo	theta_PN_A_d(r,g)=0; theta_PFX_A_dm(r,g)=0; theta_PD_A_d(r,g) = 0;				>>%gams.scrdir%static_hh_mcp.gen
$echo	theta_PN_A_d(r,g)$nd0(r,g) = nd0(r,g)/(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%static_hh_mcp.gen
$echo	theta_PD_A_d(r,g)$dd0(r,g) = dd0(r,g)/(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%static_hh_mcp.gen
$echo	theta_PFX_A_dm(r,g)$m0(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>%gams.scrdir%static_hh_mcp.gen

$macro PI_A_D(r,g)	((theta_PN_A_d(r,g)*PN(g)**(1-4)$theta_PN_A_d(r,g)+theta_PD_A_d(r,g)*PD(r,g)**(1-4)$theta_PD_A_d(r,g))**(1/(1-4)))
$macro PI_A_DM(r,g)	((theta_PFX_A_dm(r,g)*(PFX*(1+tm(r,g))/(1+tm0(r,g)))**(1-2)$theta_PFX_A_dm(r,g)+(1-theta_PFX_A_dm(r,g))*PI_A_D(r,g)**(1-2)$(1-theta_PFX_A_dm(r,g)))**(1/(1-2)))

* $prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
*         o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
$macro O_A_PA(r,g)	a0(r,g)
*         o:PFX           q:rx0(r,g)
$macro O_A_PFX(r,g)	rx0(r,g)
*         i:PN(g)         q:nd0(r,g)      d:
$macro I_PN_A(g,r)	(nd0(r,g)*((PI_A_DM(r,g)/PI_A_D(r,g))**2 * (PI_A_D(r,g)/PN(g))**4)$nd0(r,g))
*         i:PD(r,g)       q:dd0(r,g)      d:
$macro I_PD_A(r,g)	(dd0(r,g)*((PI_A_DM(r,g)/PI_A_D(r,g))**2 * (PI_A_D(r,g)/PD(r,g))**4)$dd0(r,g))
*         i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
$macro I_PFX_A(r,g)	(m0(r,g)*((PI_A_DM(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**2)$m0(r,g))
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
$echo	thetac(r,g,h) = cd0_h(r,g,h)/sum(g.local,cd0_h(r,g,h));	>>%gams.scrdir%static_hh_mcp.gen

*	Use g.local in the cost function to designate elements of g which
*	are independent of set g dimensions appearing in equation in which 
*	this function appears.

* $macro	PI_C(r,h)	(prod(g.local,PA(r,g)**thetac(r,g,h)))
$macro  PI_C(r,h,n)	((prod(g.local$thetac(r,g,h), PA(r,g)**thetac(r,g,h)))$sameas(n,"s"))

* $prod:C(r,h)	  s:1
*        o:PC(r,h)       q:c0_h(r,h)
$macro	O_C_PC(r,h)	(c0_h(r,h))
*        i:PA(r,g)       q:cd0_h(r,g,h)
$macro	I_PA_C(r,g,h)	(cd0_h(r,g,h)*(PI_C(r,h,"s")/PA(r,g))$cd0_h(r,g,h))	! N.B. Set g enters PI_C but is local to that macro

prf_c(r,h)..	sum(g, PA(r,g)*I_PA_C(r,g,h)) =e= PC(r,h)*O_C_PC(r,h);

*	-----------------------------------------------------------------------------------
* $prod:LS(r,h)
* 	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:(tl(r,h)+tfica(r,h))	p:(1-tl0(r,h)-tfica0(r,h))
$macro	O_LS_PL(q,r,h)	(le0(r,q,h))
* 	i:PLS(r,h)	q:ls0(r,h)
$macro	I_PLS_LS(r,h)	(ls0(r,h))

prf_LS(r,h)..	PLS(r,h)*I_PLS_LS(r,h) =e= sum(q, PL(q)*O_LS_PL(q,r,h)*(1-tl(r,h)-tfica(r,h)));

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

$echo	theta_PC_RA(r,h) = c0_h(r,h)/(c0_h(r,h)+lsr0(r,h));	>>%gams.scrdir%static_hh_mcp.gen

$macro	PI_RA(r,h)	((theta_PC_RA(r,h)*PC(r,h)**(1-esubL(r,h)) + (1-theta_PC_RA(r,h))*PLS(r,h)**(1-esubL(r,h)))**(1/(1-esubL(r,h))))
$macro  W_RA(r,h)	(RA(r,h)/((c0_h(r,h)+lsr0(r,h))*PI_RA(r,h)))

* $demand:RA(r,h)	  s:esubL(r,h)
*       d:PC(r,h)       q:c0_h(r,h)
$macro	D_PC_RA(r,h)	(c0_h(r,h) * W_RA(r,h) * (PI_RA(r,h)/PC(r,h))**esubL(r,h))
*	d:PLS(r,h)	q:lsr0(r,h)
$macro	D_PLS_RA(r,h)	(lsr0(r,h) * W_RA(r,h) * (PI_RA(r,h)/PLS(r,h))**esubL(r,h))
*	e:PLS(r,h)	q:(ls0(r,h)+lsr0(r,h))
*	e:PLS(r,h)      q:((tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))
$macro	E_RA_PLS(r,h)	(ls0(r,h)+lsr0(r,h) + (tl(r,h)-tl_avg0(r,h))*sum(q,le0(r,q,h)))
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
*	e:PLS(r,h)	q:(-(tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))
$macro	E_GOVT_PLS(r,h)	(-(tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))

bal_GOVT..	GOVT =e= PFX*E_GOVT_PFX + sum((r,h), PLS(r,h)*E_GOVT_PLS(r,h)) +
				sum(y_(r,s), Y(r,s) * (sum(g,PY(r,g)*ys0(r,s,g)*ty(r,s)) + I_RK_Y(r,s)*RK(r,s)*tk(r,s))) +
				sum(a_(r,g), A(r,g) * (PA(r,g)*ta(r,g)*a0(r,g) + PFX*I_PFX_A(r,g)*tm(r,g))) +
				sum((r,h,q),   LS(r,h) * PL(q) * O_LS_PL(q,r,h) * (tl(r,h)+tfica(r,h)));


*	-----------------------------------------------------------------------------------
* $demand:ROW$fint0
*     	d:PFX
$macro	D_PFX_ROW	(ROW/PFX)
* 	e:PK		q:fint0
$macro	E_PK_ROW	(fint0)

bal_ROW$fint0..	ROW =e= PK * fint0;


*	Auxiliary constraints: one for each auxiliary variable.

aux_ssk..	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

aux_savrate..	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

aux_trans..	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

aux_cpi..	CPI =e= sum((r,h), PC(r,h)*c0_h(r,h))/sum((r,h), c0_h(r,h));

*	Market clearance conditions over the declared domain:

mkt_PA(r,g)$a0(r,g)..	sum(a_(r,g), A(r,g)*O_A_PA(r,g)) =g= sum(y_(r,s), Y(r,s)*I_PA_Y(r,g,s)) + 

				sum(h, C(r,h)*I_PA_C(r,g,h)) + D_PA_INVEST(r,g) + D_PA_GOVT(r,g);
	
mkt_PY(r,g)$s0(r,g)..	sum(y_(r,s), Y(r,s)*O_Y_PY(r,g,s)) + E_NYSE_PY(r,g) =e= sum(x_(r,g), X(r,g)*I_PY_X(r,g));
	
mkt_PD(r,g)$pd_(r,g)..	sum(x_(r,g), X(r,g)*O_X_PD(r,g)) =e= sum(a_(r,g), A(r,g)*I_PD_A(r,g)) + sum((m,gm(g)), MS(r,m)*I_PD_MS(r,gm,m));
	
mkt_RK(r,s)$kd0(r,s)..	KS*O_KS_RK(r,s) =e= Y(r,s)*I_RK_Y(r,s);
	
mkt_RKS..		E_NYSE_RKS =e= KS*I_RKS_KS;
	
mkt_PM(r,m)..		MS(r,m)*O_MS_PM(r,m) =e= sum(a_(r,g),A(r,g)*I_PM_A(r,m,g));
	
mkt_PC(r,h)..		C(r,h)*O_C_PC(r,h) =e= D_PC_RA(r,h);
	
mkt_PN(g)$pn_(g)..	sum(x_(r,g), X(r,g)*O_X_PN(g,r)) =e= sum(a_(r,g), A(r,g)*I_PN_A(g,r)) + sum((r,m,gm(g)), MS(r,m)*I_PN_MS(gm,r,m));
	
mkt_PLS(r,h)..		E_RA_PLS(r,h) + E_GOVT_PLS(r,h) =g= D_PLS_RA(r,h) + LS(r,h) * I_PLS_LS(r,h);
	
*	NB: The declared domain for PL is r and this set also drives LS(r,h).  Need to use 
*	a .local on the sum:

mkt_PL(r)..		sum(q(r), sum((r.local,h), LS(r,h)*O_LS_PL(q,r,h))) =e= sum(y_(r,s), Y(r,s)*I_PL_Y(r,s));
	
mkt_PK..		sum((r,h), E_RA_PK(r,h)) + E_PK_ROW =e= D_PK_NYSE;
	
mkt_PFX..		sum(x_(r,g), X(r,g)*O_X_PFX(r,g)) + sum(a_(r,g), A(r,g)*O_A_PFX(r,g)) + 
				sum((r,h),E_RA_PFX(r,h)) + E_INVEST_PFX + E_GOVT_PFX =g= sum(a_(r,g), A(r,g)*I_PFX_A(r,g)) + D_PFX_ROW;

model static_hh_mcp /

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
	bal_ROW.ROW,

*	$auxiliary:
	aux_SAVRATE.SAVRATE,
	aux_TRANS.TRANS,
	aux_SSK.SSK,
	aux_CPI.CPI /;

*	Fix to zero commodity prices and sectoral activity levels
*	which do not enter the model:

PK.LO = 1e-5;
PA.FX(r,g)$(not a0(r,g)) = 1;
ROW.FX$(not fint0) = 0;
PA.FX(r,g)$(not a0(r,g)) = 0;
PY.FX(r,g)$(not s0(r,g)) = 0;
PD.FX(r,g)$(not xd0(r,g)) = 0;
Y.FX(r,s)$(not y_(r,s)) = 0;
X.FX(r,g)$(not x_(r,g)) = 0;
A.FX(r,g)$(not a_(r,g)) = 0;

static_hh_mcp.workspace = 10000;
static_hh_mcp.iterlim=0;
$include %gams.scrdir%static_hh_mcp.gen
solve static_hh_mcp using mcp;
abort$round(static_hh_mcp.objval,3) "Benchmark calibration of static_hh_mcp fails.";

* Perform the same simulation in both models:

tl(r,h) = 0.8*tl0(r,h);

static_hh_mge.iterlim=10000;
$include %gams.scrdir%static_hh_mge.gen
solve static_hh_mge using mcp;
abort$round(static_hh_mge.objval,4) "Counterfactual consistency with static_hh_mge fails.";

static_hh_mcp.iterlim=0;
$include %gams.scrdir%static_hh_mcp.gen
solve static_hh_mcp using mcp;
abort$round(static_hh_mcp.objval,4) "Counterfactual simulation with static_hh_mcp fails.";


* -----------------------------------------------------------------------------
* End
* -----------------------------------------------------------------------------
