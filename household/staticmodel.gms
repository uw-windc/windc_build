$title	Read a Dataset and Replicate the Static Equilibrium

* -----------------------------------------------------------------------------
* set options
* -----------------------------------------------------------------------------

* set year of interest
$if not set year $set year 2017

* set underlying dataset for recalibration
$if not set hhdata $set hhdata cps

* switch for dynamic calibration (static vs. dynamic)
$if not set invest $set invest static

* file separator
$set sep %system.dirsep%

*	GDX directory

$set gdxdir gdx%sep%

*	Core data directory:
$if not set core $set core ..%sep%core%sep%

* -----------------------------------------------------------------------------
* read in dataset
* -----------------------------------------------------------------------------

* read in base windc data

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'

alias (r,q,rr), (s,g);

* add capital tax rate
parameter
    tk0(r)    Capital tax rate;

$gdxin "%gdxdir%capital_taxrate_%year%.gdx"
$loaddc tk0

* convert gross capital payments to net
kd0(r,s) = kd0(r,s) / (1+tk0(r));

* read in household data
$gdxin "%gdxdir%calibrated_hhdata_%hhdata%_%invest%_%year%.gdx"
set
    h     Household categories,
    trn   Transfer types;

$load h trn
alias(h,hh),(r,q), (g,gg);

parameter
    le0(r,q,h)	   Household labor endowment,
    ke0(r,h)	   Household interest payments,
    tl0(r,h)	   Household labor tax rate,
    cd0_h(r,g,h)   Household level expenditures,
    c0_h(r,h)	   Aggregate household level expenditures,
    sav0(r,h)	   Household saving,
    trn0(r,h)	   Household transfer payments,
    hhtrn0(r,h,*)  Disaggregate transfer payments,
    pop(r,h)       Population (households or returns in millions);

$loaddc le0 ke0 tl0 cd0_h c0_h sav0 trn0 hhtrn0 pop

* reassign steady state parameters as needed
parameter
    ys0_ss(r,s,g)	Steady state output,
    id0_ss(r,g,s)	Steady state intermediate demand,
    dd0_ss(r,g)		Steady state local demand,
    nd0_ss(r,g)		Steady state national demand,
    xd0_ss(r,g)		Steady state local supply,
    xn0_ss(r,g)		Steady state national supply,
    g0_ss(r,g)		Steady state government demand,
    a0_ss(r,g)		Steady state armington supply,
    s0_ss(r,g)		Steady state total supply,
    i0_ss(r,g)		Steady state investment,
    ty0_ss(r,s)         Steady state production tax,
    ta0_ss(r,g)         Steady state commodity tax;

$ifthen.dynamic %invest%=="dynamic"

$gdxin "%gdxdir%dynamic_parameters_%year%.gdx"
$loaddc ys0_ss=ys0 id0_ss=id0 dd0_ss=dd0 nd0_ss=nd0 xd0_ss=xd0 xn0_ss=xn0 
$loaddc a0_ss=a0 s0_ss=s0 i0_ss=i0 g0_ss=g0 ty0_ss=ty0 ta0_ss=ta0
	ys0(r,s,g) = ys0_ss(r,s,g);
	id0(r,g,s) = id0_ss(r,g,s);
	dd0(r,g) = dd0_ss(r,g);
	nd0(r,g) = nd0_ss(r,g);
	xd0(r,g) = xd0_ss(r,g);
	xn0(r,g) = xn0_ss(r,g);
	g0(r,g) = g0_ss(r,g);
	a0(r,g) = a0_ss(r,g);
	s0(r,g) = s0_ss(r,g);
	i0(r,g) = i0_ss(r,g);
	ty0(r,s) = ty0_ss(r,s);
	ta0(r,g) = ta0_ss(r,g);
$endif.dynamic


* define additional aggregate parameters
parameter
    totsav0	Total domestic savings,
    fsav0	Total foreign savings,
    taxrevL(r)  Tax revenue from labor income tax,
    taxrevK     Tax revenue from capital income tax,
    govdef0	Government deficit;

totsav0 = sum((r,h), sav0(r,h));
fsav0 = sum((r,g), i0(r,g)) - totsav0;
taxrevL(rr) = sum((r,h),tl0(r,h)*le0(r,rr,h));
taxrevK = sum((r,s),tk0(r)*kd0(r,s));
govdef0 = sum((r,g), g0(r,g)) + sum((r,h), trn0(r,h))
	- sum(r, taxrevL(r)) 
	- taxrevK 
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g));

* define capital transformation elasticity and policy tax rates
parameter
    etaK	Capital transformation elasticity /4/,
    ta(r,g)	Consumption taxes,
    ty(r,s)	Production taxes
    tm(r,g)	Import taxes,
    tk(r,s)     Capital taxes,
    tl(r,h)	Labor taxes;

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
tl(r,h) = tl0(r,h);


* -----------------------------------------------------------------------------
* static calibration model
* -----------------------------------------------------------------------------

$ontext 
$model:mgemodel

$sectors:
        Y(r,s)$y_(r,s)          !       Production
        X(r,g)$x_(r,g)          !       Disposition
        A(r,g)$a_(r,g)          !       Absorption
	KS			!	Aggregate capital stock
        C(r,h)			!       Household consumption
        MS(r,m)                 !       Margin supply

$commodities:
        PA(r,g)$a0(r,g)         !       Regional market (input)
        PY(r,g)$s0(r,g)         !       Regional market (output)
        PD(r,g)$xd0(r,g)        !       Local market price
        RK(r,s)$kd0(r,s)	!       Sectoral rental rate
	RKS			!	Capital stock
        PM(r,m)                 !       Margin price
        PC(r,h)			!       Consumer price index
        PN(g)                   !       National market price for goods
        PL(r)                   !       Regional wage rate
	PK			!     	Aggregate return to capital
        PFX                     !       Foreign exchange

$consumer:
        RA(r,h)			!	Representative agent
	NYSE			!	Aggregate capital owner
	INVEST			!	Aggregate investor
	GOVT			!	Aggregate government

$auxiliary:
	SAVRATE			!	Domestic savings rate
	TAXRATE			!	Budget balance rationing variable
	SSK			!	Steady-state capital stock

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

$prod:A(r,g)$a_(r,g)  s:0 dm:4  d(dm):2
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

$prod:KS	t:etaK
	o:RK(r,s)	q:kd0(r,s)
	i:RKS		q:(sum((r,s),kd0(r,s)))

$demand:RA(r,h)
        d:PC(r,h)       q:c0_h(r,h)
        e:PL(q)         q:le0(r,q,h)
        e:PL(q)         q:(-tl0(r,h)*le0(r,q,h))	r:TAXRATE
	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))
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
	e:PFX           q:(-sum((r,h), trn0(r,h)))
	e:PFX           q:govdef0
 	e:PL(r)         q:taxrevL(r)	r:TAXRATE

$constraint:SSK
	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

$constraint:TAXRATE
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));
	
$offtext
$sysinclude mpsgeset mgemodel -mt=1

TAXRATE.L = 1;
SAVRATE.L = 1;
SSK.FX = 1;
mgemodel.savepoint = 1;
mgemodel.workspace = 1000;
mgemodel.iterlim=0;
$include %gams.scrdir%mgemodel.gen
*.solve mgemodel using mcp;

equations

	prf_Y(r,s)	Production
	prf_X(r,g)	Disposition
	prf_A(r,g)	Absorption
	prf_KS		Aggregate capital stock
	prf_C(r,h)	Household consumption
	prf_MS(r,m)	Margin supply

        mkt_PA(r,g)	Regional market (input)
        mkt_PY(r,g)	Regional market (output)
        mkt_PD(r,g)	Local market price
        mkt_RK(r,s)	Sectoral rental rate
	mkt_RKS		Capital stock
	mkt_PK		Capital earnings
        mkt_PM(r,m)	Margin price
        mkt_PC(r,h)	Consumer price index
        mkt_PN(g)	National market price for goods
        mkt_PL(r)	Regional wage rate
        mkt_PFX		Foreign exchange

	bal_RA(r,h)	Representative agent
	bal_NYSE	Aggregate capital owner
	bal_INVEST	Aggregate investor
	bal_GOVT	Aggregate government

	aux_SAVRATE	Domestic savings rate
	aux_TAXRATE	Budget balance rationing variable
	aux_SSK		Steady-state capital stock

$echo	*	MCP calibration code.	>%gams.scrdir%MCPMODEL.GEN	

*$prod:Y(r,s)$y_(r,s)  s:0 va:1
*	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
*        i:PA(r,g)       q:id0(r,g,s)
*        i:PL(r)         q:ld0(r,s)     va:
*        i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r))

parameter	lvs(r,s)	Labor value share;

$echo	lvs(r,s) = 0; lvs(r,s)$ld0(r,s) = ld0(r,s)/(ld0(r,s)+(1+tk0(r))*kd0(r,s));	>>%gams.scrdir%MCPMODEL.GEN	

$macro	PVA(r,s)	(PL(r)**lvs(r,s) * (RK(r,s)*(1+tk(r,s))/(1+tk0(r)))**(1-lvs(r,s)))

prf_Y(r,s)$y_(r,s)..

		sum(g, PA(r,g)*id0(r,g,s)) + 
			(ld0(r,s)+(1+tk0(r))*kd0(r,s)) * PVA(r,s)
				=e= sum(g,PY(r,g)*ys0(r,s,g))*(1-ty(r,s));

*$report:
*	v:KD(r,s)$kd0(r,s)	i:RK(r,s)	prod:Y(r,s)

*	KD(r,s) is a variable defined in the MGE model.  In the MCP model we
*	use a macro to define capital inputs:

$macro	KD_(r,s)	(kd0(r,s)*(PVA(r,s)*(1+tk0(r))/(RK(r,s)*(1+tk(r,s))))*Y(r,s))

*$prod:X(r,g)$x_(r,g)  t:4
*        o:PFX           q:(x0(r,g)-rx0(r,g))
*        o:PN(g)         q:xn0(r,g)
*        o:PD(r,g)       q:xd0(r,g)
*        i:PY(r,g)       q:s0(r,g)

parameter	thetaxd(r,g)	Value share (output to PD market),
		thetaxn(r,g)	Value share (output to PN market),
		thetaxe(r,g)	Value share (output to PFX market);

$echo	thetaxd(r,g) = xd0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	thetaxn(r,g) = xn0(r,g)/s0(r,g);		>>%gams.scrdir%MCPMODEL.GEN	
$echo	thetaxe(r,g) = (x0(r,g)-rx0(r,g))/s0(r,g);	>>%gams.scrdir%MCPMODEL.GEN	

$macro	RX(r,g)	 (( thetaxd(r,g) * PD(r,g)**(1+4) + thetaxn(r,g) * PN(g)**(1+4) + thetaxe(r,g) * PFX**(1+4) )**(1/(1+4)))

prf_X(r,g)$x_(r,g)..
		PY(r,g)*s0(r,g) =e= (x0(r,g)-rx0(r,g)+xn0(r,g)+xd0(r,g)) * RX(r,g);

*$prod:A(r,g)$a_(r,g)  s:0 dm:4  d(dm):2
*        o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
*        o:PFX           q:rx0(r,g)
*        i:PN(g)         q:nd0(r,g)      d:
*        i:PD(r,g)       q:dd0(r,g)      d:
*        i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
*        i:PM(r,m)       q:md0(r,m,g)

parameter	thetam(r,g)	Import value share
		thetan(r,g)	National value share;

$echo	thetam(r,g)=0; thetan(r,g)=0;								>>%gams.scrdir%MCPMODEL.GEN
$echo	thetam(r,g)$m0(r,g) = m0(r,g)*(1+tm0(r,g))/(m0(r,g)*(1+tm0(r,g))+nd0(r,g)+dd0(r,g));	>>%gams.scrdir%MCPMODEL.GEN
$echo	thetan(r,g)$nd0(r,g) = nd0(r,g) /(nd0(r,g)+dd0(r,g));					>>%gams.scrdir%MCPMODEL.GEN

$macro PND(r,g)  ( (thetan(r,g)*PN(g)**(1-4) + (1-thetan(r,g))*PD(r,g)**(1-4))**(1/(1-4)) ) 
$macro PMND(r,g) ( (thetam(r,g)*(PFX*(1+tm(r,g))/(1+tm0(r,g)))**(1-2) + (1-thetam(r,g))*PND(r,g)**(1-2))**(1/(1-2)) )

prf_A(r,g)$a_(r,g)..
	 	sum(m,PM(r,m)*md0(r,m,g)) + 
			(nd0(r,g)+dd0(r,g)+m0(r,g)*(1+tm0(r,g))) * PMND(r,g)
				=e= PA(r,g)*a0(r,g)*(1-ta(r,g)) + PFX*rx0(r,g);


*$report:
*	v:MD(r,g)$m0(r,g)	i:PFX	prod:A(r,g)

*	MD(r,s) is a variable defined in the MGE model.  In the MCP model we
*	use a macro to define import demand

$macro MD_(r,g)		( A(r,g)*m0(r,g)*(PMND(r,g)*(1+tm0(r,g))/(PFX*(1+tm(r,g))))**2)

*$prod:MS(r,m)
*        o:PM(r,m)       q:(sum(gm, md0(r,m,gm)))
*        i:PN(gm)        q:nm0(r,gm,m)
*        i:PD(r,gm)      q:dm0(r,gm,m)

prf_MS(r,m)..	sum(gm, PN(gm)*nm0(r,gm,m) + PD(r,gm)*dm0(r,gm,m)) =g= PM(r,m)*sum(gm, md0(r,m,gm));

*$prod:C(r,h)	  s:1
*        o:PC(r,h)       q:c0_h(r,h)
*        i:PA(r,g)       q:cd0_h(r,g,h)

prf_C(r,h)..	prod(g$cd0_h(r,g,h), PA(r,g)**(cd0_h(r,g,h)/c0_h(r,h))) =g= PC(r,h);

*$prod:KS	t:etaK
*	o:RK(r,s)	q:kd0(r,s)
*	i:RKS		q:(sum((r,s),kd0(r,s)))

prf_KS..	RKS * sum((r,s),kd0(r,s))**(1/(1+etaK)) =e= sum((r,s), kd0(r,s) * RK(r,s)**(1+etaK))**(1/(1+etaK));

*$demand:RA(r,h)
*        d:PC(r,h)       q:c0_h(r,h)
*        e:PL(q)         q:le0(r,q,h)
*        e:PL(q)         q:(-tl0(r,h)*le0(r,q,h))	r:TAXRATE
*	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))
*        e:PK		q:ke0(r,h)
*	e:PFX		q:(-sav0(r,h))	r:SAVRATE

bal_RA(r,h)..	RA(r,h) =e= sum(q, PL(q)*(1-tl0(r,h)*TAXRATE)*le0(r,q,h)) +
				PFX * sum(trn,hhtrn0(r,h,trn)) +
				PK * ke0(r,h) -
				SAVRATE * PFX * sav0(r,h);

*	v:W(r,h)	w:RA(r,h)

$macro	W_(r,h)		(RA(r,h)/(PC(r,h)*c0_h(r,h)))

*$demand:NYSE
*	d:PK
*	e:PY(r,g)	q:yh0(r,g)
*	e:RKs		q:(sum((r,s),kd0(r,s)))	r:SSK

bal_NYSE..		NYSE =e= sum((r,g), PY(r,g)*yh0(r,g)) + SSK*RKS*sum((r,s),kd0(r,s));

*$demand:INVEST  s:0
*	d:PA(r,g)	q:i0(r,g)
*	e:PFX		q:totsav0	r:SAVRATE
*	e:PFX		q:fsav0

bal_INVEST..		INVEST =e= PFX*(SAVRATE*totsav0 + fsav0);

*$demand:GOVT
*	d:PA(r,g)	q:g0(r,g)
*	e:PFX           q:(-sum((r,h), trn0(r,h)))
*	e:PFX           q:govdef0
* 	e:PL(r)         q:taxrevL(r)	r:TAXRATE

bal_GOVT..	GOVT =e= PFX * (govdef0 - sum((r,h),trn0(r,h))) +

			TAXRATE*sum(r, PL(r)*taxrevL(r))

			+ sum(y_(r,s), Y(r,s)*ty(r,s)*sum(g$ys0(r,s,g), PY(r,g)*ys0(r,s,g)))

			+ sum(a_(r,g)$a0(r,g), A(r,g)*ta(r,g)*PA(r,g)*a0(r,g))

			+ sum((r,s)$kd0(r,s), tk(r,s)*RK(r,s)*KD_(r,s))

			+ sum(a_(r,g)$m0(r,g), tm(r,g)*PFX*MD_(r,g));

*$constraint:SSK
*	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

aux_SSK..	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

*$constraint:SAVRATE
*	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

aux_SAVRATE..	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

*$constraint:TAXRATE
*	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

aux_TAXRATE..	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

mkt_PA(r,g)$a_(r,g)..	A(r,g)*a0(r,g) =e= sum(y_(r,s), Y(r,s)*id0(r,g,s)) 
					+ sum(h,cd0_h(r,g,h)*C(r,h)*PC(r,h)/PA(r,g))
					+ g0(r,g) + i0(r,g) * INVEST/sum((rr,gg),PA(rr,gg)*i0(rr,gg));

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
			+ sum(r, bopdef0(r)+hhadj(r)) =e= sum(a_(r,g)$m0(r,g), MD_(r,g));

mkt_PL(r)..	sum(s,ld0(r,s)) =g= sum(y_(r,s), Y(r,s)*ld0(r,s)*PVA(r,s)/PL(r));

mkt_RK(r,s)$kd0(r,s)..	kd0(r,s) =e= KD_(r,s);

mkt_PM(r,m)..		MS(r,m)*sum(gm,md0(r,m,gm)) =e= sum(a_(r,g),md0(r,m,g)*A(r,g));

mkt_RKS..		sum((r,s),kd0(r,s)) * KS =E= sum((r,s),kd0(r,s)) * SSK;

mkt_PK..		sum((r,h),ke0(r,h)) =e= NYSE/PK;

mkt_PC(r,h)..		C(r,h)*c0_h(r,h) =e= RA(r,h)/PC(r,h);

model mcpmodel /
	prf_Y.Y, prf_X.X, prf_A.A, prf_KS.KS, prf_C.C, prf_MS.MS, 

	mkt_PA.PA, mkt_PY.PY, mkt_PD.PD, mkt_RK.RK, mkt_RKS.RKS, mkt_PK.PK, 
	mkt_PM.PM, mkt_PC.PC, mkt_PN.PN, mkt_PL.PL, mkt_PFX.PFX, 

	bal_RA.RA, bal_NYSE.NYSE, bal_INVEST.INVEST, bal_GOVT.GOVT, 

	aux_SAVRATE.SAVRATE, aux_TAXRATE.TAXRATE, aux_SSK.SSK /;

$include '%gams.scrdir%MCPMODEL.GEN'

*	Benchmark income levels:

RA.L(r,h) = c0_h(r,h);
NYSE.L = sum((r,g), yh0(r,g)) + sum((r,s),kd0(r,s));
INVEST.L = sum((r,g),i0(r,g));
GOVT.L = sum((r,g),g0(r,g));
mcpmodel.iterlim = 0;
solve mcpmodel using mcp;
