$title Dynamic household model with subsistence households (MGE)

**** BROKEN ****

* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* Set dataset option
$set ds cps_dynamic_all_2017_sage_census_regions

* Set switch for cutoff point for non-saving households (1-5)
$if not set cutoff $set cutoff 2


* ------------------------------------------------------------------------------
* Set steady-state parameter values (must be consistent with values in
* build.gms)
* ------------------------------------------------------------------------------

* Set economy-wide growth rate
$set gr 0.02

* Set interest rate
$set ir 0.04

* Set economy-wide depreciation rate
$set delta 0.05


* -----------------------------------------------------------------------------
* Read in the dynamic household dataset
* -----------------------------------------------------------------------------

* Read in the household dataset

$include windc_hhdata

parameter
    ta(r,g)	Counterfactual consumption taxes,
    ty(r,s)	Counterfactual production taxes
    tm(r,g)	Counterfactual import taxes,
    tk(r,s)	Counterfactual capital taxes,
    tfica(r,h)	Counterfactual FICA labor taxes,
    tl(r,h)	Counterfactual marginal labor taxes;

* Counterfactual tax rates set to reference levels

ta(r,g) = ta0(r,g);
ty(r,s) = ty0(r,s);
tm(r,g) = tm0(r,g);
tk(r,s) = tk0(r);
tfica(r,h) = tfica0(r,h);
tl(r,h) = tl0(r,h);


* -----------------------------------------------------------------------------
* Define dynamic baseline
* -----------------------------------------------------------------------------

* Define the time horizon of the model using two sets, one which includes the
* post-terminal year and one which covers only the endogenous years:
*	5 sectors
*	1 year time steps
*	2040 horizon

set
    tt		Time horizon (with the first year of the post-terminal period) /2020*2041/,
    t(tt)	Time period over the model horizon /2020*2040/,
    t0(t)	Year 0 /2020/,
    tf(tt)	Final endogenous year /2040/,
    tp(tt)	First post-terminal year /2041/;

parameter
    gr		    Growth rate /%gr%/,
    ir		    Interest rate /%ir%/,
    delta(r,s)	    Assumed sectoral depreciation rate,
    qref(t)	    Reference quantity path,
    pref(tt)	    Reference price path,
    k0(r,g)	    Initial (benchmark) capital stock,
    kn0(r,s)	    New vintage capital supply for subsequent period,
    ktref(r,g)	    Post-terminal capital stock,
    ks0(r,h)	    Stock earnings by household
    pk0		    Benchmark capital price (including time to build),
    sigma_t(h)	    Intertemporal elasticitiy of substitution,
    ls0(r,h)	    Labor supply,
    w0(r,h)	    Intertemporal welfare,
    gdef0(t)	    Government deficit over time,
    thetas(r,h,tt)  Household h share of regional capital stock,
    thetak(r,h)	    Capital ownership share;

delta(r,s) = %delta%;
qref(t) = (1+gr)**(ord(t)-1);
pref(tt) = (1/(1+ir))**(ord(tt)-1);
k0(r,s) = kd0(r,s)/(ir+delta(r,s));
kn0(r,s) = (gr+delta(r,s)) * k0(r,s);
ktref(r,g) = k0(r,g) * (1+gr)**card(t);
pk0 = 1 + ir;
sigma_t(h) = 0.5;

w0(r,h) = sum(t,pref(t)*qref(t)*c0_h(r,h));

gdef0(t) = qref(t) * ( sum((r,g), g0(r,g)) 
	- sum((r,s,g)$y_(r,s), ty0(r,s) * ys0(r,s,g)) 
        - sum((r,s), tk0(r) * kd0(r,s))
	- sum((r,g)$a_(r,g),   ta0(r,g)*a0(r,g) + tm0(r,g)*m0(r,g))
	- sum((r,h),(tl(r,h)+tfica(r,h))*sum(q,le0(r,q,h))) );

* Environment variable indicates the highest income household which we represent
* as subsistence:
$if %cutoff%==0  $set subsistence 'hh1'
$if %cutoff%==1  $set subsistence 'hh1'
$if %cutoff%==2  $set subsistence 'hh1,hh2'
$if %cutoff%==3  $set subsistence 'hh1,hh2,hh3'
$if %cutoff%==4  $set subsistence 'hh1,hh2,hh3,hh4'
$if %cutoff%==5  $set subsistence 'hh1,hh2,hh3,hh4,hh5'

set
    saving(h)		Households modelled as saving,
    subsistence(h)	Subsistence households /%subsistence%/;
alias (h,hh);

loop(h$subsistence(h), subsistence(hh)$(ord(hh) < ord(h)) = yes;);
$if %cutoff%==0  subsistence(h) = no;
saving(h) = (not subsistence(h));

thetak(r,h) = ke0(r,h)/sum(hh,ke0(r,hh));
ks0(r,h) = thetak(r,h) * sum(g, 
	k0(r,g)*pk0 - sum(tp,ktref(r,g)*pref(tp)*pk0) + sum(t,pref(t)*qref(t)*yh0(r,g)));

* Reset transfers to match assumptions on subsistence consumption

ls0(r,h) = sum(q,le0(r,q,h)) * (1-tl0(r,h)-tfica0(r,h));
trn0(r,h) = c0_h(r,h) - ls0(r,h) - ks0(r,h)/sum(t,qref(t)*pref(t));

thetas(r,subsistence(h),t)$ks0(r,h) = 
	(pref(t) *  qref(t) * (c0_h(r,h) - trn0(r,h)- ls0(r,h))) / ks0(r,h);
display thetas;

parameter    thetaschk(r,h)	Cross check on ownership shares;
thetaschk(r,subsistence(h)) = sum(t, thetas(r,h,t)) - 1;
display thetaschk;

parameter	pfxchk;
pfxchk("X") = sum((r,g)$x_(r,g),x0(r,g)-rx0(r,g));
pfxchk("a") = sum((r,g)$a_(r,g),rx0(r,g)-m0(r,g));
pfxchk("govt") = govdef0;
pfxchk("trn0") = sum((r,h),trn0(r,h));
pfxchk("sum") = pfxchk("X") + pfxchk("a") + pfxchk("govt") + pfxchk("trn0");
display pfxchk;


* -----------------------------------------------------------------------------
* Dynamic MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:dynamic_hh_mge

$sectors:
        Y(r,s,t)$y_(r,s)        !       Production
        X(r,g,t)$x_(r,g)        !       Disposition
        A(r,g,t)$a_(r,g)        !       Absorption
	W(r,h)$saving(h)	!	Interemporal welfare
	GD(t)			!	Government demand
        C(r,h,t)		!       Household consumption
	LS(r,h,t)		!	Labor supply
        MS(r,m,t)               !       Margin supply
	K(r,g,t)$k0(r,g)	!	Sectoral capital stock
	I(r,g,t)$kn0(r,g)	!	Sectoral investment
	INV(r,t)		!	Aggregate investment	

$commodities:
        PA(r,g,t)$a_(r,g)	!       Regional market (input)
        PY(r,g,t)		!       Regional market (output)
        PD(r,g,t)$xd0(r,g)	!       Local market price
	PGD(t)			!	Government demand
        RK(r,s,t)$kd0(r,s)	!       Sectoral capital rental rate
        PM(r,m,t)               !       Margin price
        PC(r,h,t)		!       Consumer price index
        PN(g,t)                 !       National market
	PW(r,h)$saving(h)	!	Price index for welfare
	PLS(r,h,t)		!	Leisure 
        PL(r,t)                 !       Regional wage rate
	PK(r,g,tt)$k0(r,g)	!	Capital purchase price
	PINV(r,t)		!	Cost of new vintage investment
	PKNYSE			!	Price index for extant capital
        PFX(t)                  !       Foreign exchange

$consumer:
        RIH(r,h)$saving(h)		!	Representative intertemporal household
	RSH(r,h,t)$subsistence(h)	!	Representative subsistence household
	GOVT(t)				!	Aggregate government
	NYSE				!	Aggregate capital owner
	ROW(t)				!	Aggregate rest of world

$auxiliary:
	TAXRATE(t)		!	Tax rate
	KT(r,g)			!	Terminal capital stock

$prod:Y(r,s,t)$y_(r,s)  s:0 va:1
	o:PY(r,g,t)	q:ys0(r,s,g)            a:GOVT(t)  t:ty0(r,s)       p:(pref(t)*(1-ty0(r,s)))
	i:PA(r,g,t)     q:id0(r,g,s)					    p:pref(t)
        i:PL(r,t)       q:ld0(r,s)     va:				    p:pref(t)
        i:RK(r,s,t)     q:kd0(r,s)     va:	a:GOVT(t)  t:tk0(r)         p:(pref(t)*(1+tk0(r)))

$prod:X(r,g,t)$x_(r,g)  t:4
        o:PFX(t)          q:(x0(r,g)-rx0(r,g))	p:pref(t)
        o:PN(g,t)         q:xn0(r,g)		p:pref(t)
        o:PD(r,g,t)       q:xd0(r,g)		p:pref(t)
        i:PY(r,g,t)       q:s0(r,g)

$prod:A(r,g,t)$a_(r,g)  s:0 dm:4  d(dm):2
        o:PA(r,g,t)       q:a0(r,g)		a:GOVT(t) t:ta0(r,g)      p:(1-ta0(r,g))
        o:PFX(t)          q:rx0(r,g)
        i:PN(g,t)         q:nd0(r,g)      d:	                          p:pref(t)
        i:PD(r,g,t)       q:dd0(r,g)      d:	                          p:pref(t)
        i:PFX(t)          q:m0(r,g)       dm:   a:GOVT(t) t:tm0(r,g)      p:(pref(t)*(1+tm0(r,g)))
        i:PM(r,m,t)       q:md0(r,m,g)		                          p:pref(t)

$prod:MS(r,m,t)
        o:PM(r,m,t)       q:(sum(gm, md0(r,m,gm)))
        i:PN(gm,t)        q:nm0(r,gm,m)
        i:PD(r,gm,t)      q:dm0(r,gm,m)

$prod:C(r,h,t)	  s:1
        o:PC(r,h,t)       q:c0_h(r,h)
        i:PA(r,g,t)       q:cd0_h(r,g,h)	p:pref(t)

$prod:LS(r,h,t)
	o:PL(q,t)	q:le0(r,q,h)	a:GOVT(t)	t:(tl(r,h)+tfica(r,h))	p:(1-tl0(r,h)-tfica0(r,h))
	i:PLS(r,h,t)	q:ls0(r,h)

$prod:K(r,g,tt)$(k0(r,g) and t(tt))
	o:PK(r,g,tt+1)		q:(k0(r,g)*(1-delta(r,g)))
	o:RK(r,g,tt)		q:kd0(r,g)	
	i:PK(r,g,tt)		q:k0(r,g)

$prod:I(r,g,tt)$(kn0(r,g) and t(tt))
	o:PK(r,g,tt+1)		q:kn0(r,g)
	i:PINV(r,tt)		q:kn0(r,g)

$prod:INV(r,t)
	o:PINV(r,t)		q:(sum(g,kn0(r,g)))
	i:PA(r,g,t)		q:i0(r,g)

$prod:GD(t)  s:0
	o:PGD(t)		q:(sum((r,g),g0(r,g)))
	i:PA(r,g,t)		q:g0(r,g)

$demand:GOVT(t)
	d:PGD(t)		q:(sum((r,g),g0(r,g)))
	e:PFX(t)		q:gdef0(t)	! q:(qref(t)*govdef0)
	e:PFX(t)		q:(-sum((r,h), qref(t)*trn0(r,h)))	r:TAXRATE(t)
	e:PLS(r,h,t)		q:(-(tl(r,h) - tl_avg0(r,h))*qref(t)*sum(q,le0(r,q,h)))

$prod:W(r,h)$saving(h)  s:sigma_t(h)
	o:PW(r,h)		q:w0(r,h)
	i:PC(r,h,t)		q:(qref(t)*c0_h(r,h))	        p:pref(t)

$demand:RIH(r,h)$saving(h)  s:sigma_t(h)	
	d:PW(r,h)		q:w0(r,h)
	e:PFX(t)		q:(qref(t)*trn0(r,h))	r:TAXRATE(t)
        e:PLS(r,h,t)		q:(qref(t)*ls0(r,h))
	e:PLS(r,h,t)		q:((tl(r,h) - tl_avg0(r,h))*qref(t)*sum(q,le0(r,q,h)))
	e:PKNYSE		q:ks0(r,h)

* Subsistence households operate on a cash basis in every period

$demand:RSH(r,h,t)$subsistence(h)
        d:PC(r,h,t)		q:(qref(t)*c0_h(r,h))
	e:PFX(t)		q:(qref(t)*trn0(r,h))	r:TAXRATE(t)
        e:PLS(r,h,t)		q:(qref(t)*ls0(r,h))
	e:PLS(r,h,t)		q:((tl(r,h) - tl_avg0(r,h))*qref(t)*sum(q,le0(r,q,h)))
	e:PKNYSE		q:(ks0(r,h)*thetas(r,h,t))

$demand:ROW(t)
    	d:PFX(t)
	e:PKNYSE		q:(fint0/((ir+%delta%)))
	
$demand:NYSE
	d:PKNYSE
	e:PY(r,g,t)		q:(qref(t)*yh0(r,g))
	e:PK(r,s,t0)		q:k0(r,s)
	e:PK(r,g,tp)		q:(-ktref(r,g))		R:KT(r,g)

$constraint:TAXRATE(t)
	GOVT(t) =e= sum((r,g),PA(r,g,t)*qref(t)*g0(r,g));

* Target terminal capital stock so that terminal investment grows at the same
* rate as production:

$constraint:KT(r,g)
	sum(t$tf(t+1), I(r,g,t+1)/I(r,g,t) - Y(r,g,t+1)/Y(r,g,t)) =E= 0;

$offtext
$sysinclude mpsgeset dynamic_hh_mge -mt=1

*	Assign steady-state equilibrium values for qunatities and prices:

Y.L(r,s,t) = qref(t);
X.L(r,g,t) = qref(t);
GD.L(t) = qref(t);
PGD.L(t) = pref(t);
A.L(r,g,t) = qref(t);
C.L(r,h,t) = qref(t);
MS.L(r,m,t) = qref(t);
K.L(r,g,t) = qref(t);
I.L(r,g,t) = qref(t);
INV.L(r,t) = qref(t);
LS.L(r,h,t) = qref(t);
PA.L(r,g,t) = pref(t);
PY.L(r,g,t) = pref(t);
PD.L(r,g,t) = pref(t);
RK.L(r,s,t) = pref(t);
PM.L(r,m,t) = pref(t);
PC.L(r,h,t) = pref(t);
PN.L(g,t) = pref(t);
PL.L(r,t) = pref(t);
PLS.L(r,h,t) = pref(t);
PK.L(r,g,tt) = pref(tt)*pk0;
PINV.L(r,t) = pref(t);
PKNYSE.L = 1;
PFX.L(t) = pref(t);
KT.L(r,g) = 1;
TAXRATE.L(t) = 1;
dynamic_hh_mge.workspace = 1000;
dynamic_hh_mge.iterlim=0;
$include %gams.scrdir%dynamic_hh_mge.gen
solve dynamic_hh_mge using mcp;


* -----------------------------------------------------------------------------
* Post solve diagnostics
* -----------------------------------------------------------------------------

parameter
    incomeshare		Income shares;

incomeshare(r,saving(h),"trn") = sum(t,pref(t)*qref(t)*trn0(r,h))/w0(r,h);
incomeshare(r,saving(h),"ls") = sum(t,pref(t)*qref(t)*ls0(r,h)) / w0(r,h);
incomeshare(r,saving(h),"taxes") = -tl(r,h) *
	sum(t,pref(t)*(qref(t)*ls0(r,h)+qref(t)*ke0(r,h))) /w0(r,h);
incomeshare(r,saving(h),"ks") = ks0(r,h)/w0(r,h);
incomeshare(r,saving(h),"total") = 
	incomeshare(r,h,"trn") + 
	incomeshare(r,h,"ls")  +
	incomeshare(r,h,"taxes") +
	incomeshare(r,h,"ks") - 1;
option incomeshare:3:2:1;
display incomeshare;


* -----------------------------------------------------------------------------
* End
* -----------------------------------------------------------------------------
