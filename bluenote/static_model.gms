$title Static household model (MGE and MCP)


* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* Set datset option
$set datafile datasets/WiNDC_cps_static_all_2021_sage_census_regions.gdx

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
* End
* -----------------------------------------------------------------------------
