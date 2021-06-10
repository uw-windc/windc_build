$title Calibrate baseline data to balanced growth path

* -----------------------------------------------------------------------------
* Options for calibration
* -----------------------------------------------------------------------------

* set year of interest

$if not set year $set year 2017

* set file separator
$set sep %system.dirsep%

*	GDX directory

$if not dexist gdx $call mkdir gdx
$set gdxdir gdx%sep%

*	Core data directory:
$if not set core $set core ..%sep%core%sep%


* -----------------------------------------------------------------------------
* Read in the base dataset
* -----------------------------------------------------------------------------

* read base dataset

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'

alias (r,q,rr), (s,g);


* add capital tax rate
parameter
    tk0    Capital tax rate;

$gdxin "%gdxdir%capital_tax_rates.gdx"
$loaddc tk0


* -----------------------------------------------------------------------------
* Define investment calibration parameters
* -----------------------------------------------------------------------------

parameter
    gr			Growth rate,
    ir			Interest rate,
    i0_ss(r,g)  	Steady state investment,
    delta(r,s)		Assumed sectoral depreciation rate,
    invest0(r)		Aggregate benchmark investment,
    rent0(r)		Aggregate benchmark rental income,
    deltacalib(r)	Depreciation average rate;

* fix investment demands to match previous calibration. dispense with tiny
* values to avoid numerical overflows in the objective function:

$gdxin "%gdxdir%dynamic_adjustments_2017.gdx"
$loaddc i0_ss=i0 gr ir delta

* convert gross capital payments to net
kd0(r,s) = kd0(r,s) / (1+tk0(r));

* define some aggregate parameters for illustration
rent0(r) = sum(s,kd0(r,s));
invest0(r) = sum(g,i0(r,g));

* verify that the input data are inconsistent with a balanced steady-state
* growth path.  That is, if we calibrate to a world in which the rate of return
* covers interest plus depreciation and the investment covers growth plus
* depreciation, then:

*	invest0 = rent0 * (gr + delta) / (ir + delta)

* One method of calibation could be to solve for the depreciation rate:

*	delta = (ir*invest0 - gr*rent0) / (rent0-invest0) 

*	When we do that, we find implausible values:

deltacalib(r) = (ir*invest0(r) - gr*rent0(r)) / (rent0(r)-invest0(r)) 
display deltacalib;

parameter
    k0(r,g)	    Initial (benchmark) capital stock,
    kn0(r,s)	New vintage capital supply for subsequent period;    

k0(r,s) = kd0(r,s)/(ir+delta(r,s));
kn0(r,s) = (gr+delta(r,s)) * k0(r,s);

* In economics, when theory and the facts diverge, too bad for the facts.

parameter
    benchmark	Benchmark consistency report;

* reference levels
benchmark(r,"kd0") = sum(s,kd0(r,s));
benchmark(r,"id0") = sum(g,i0(r,g));

* impute what the capital earnings should be based on investment:
benchmark(r,"kd_ss") = sum(g, i0(r,g) * (ir+delta(r,g)) / (gr+delta(r,g)));

* impute what investment should be based on capital earnings:
benchmark(r,"id_ss0") = sum(s,kn0(r,s));
benchmark(r,"c0") = c0(r);

* capital value share of value-added:
benchmark(r,"kvs") = sum(s,kd0(r,s)) /sum(s,kd0(r,s)+ld0(r,s));

* save reference level tax revenue and rates:
parameter
    taxrev(r,s,*)   Reference tax revenues for endogenous parameters,
    taxrate(r,s,*)  Reference tax rates;

taxrev(r,s,'ty') = ty0(r,s) * sum(g, ys0(r,s,g));
taxrate(r,s,'ty') = ty0(r,s);
taxrev(r,g,'ta') = ta0(r,g) * a0(r,g);
taxrate(r,g,'ta') = ta0(r,g);
display taxrev;

* set up a matrix balancing program which adjusts investment to line up with
* capital earnings:

set
    rb(r)	    Region(s) to be balanced;

parameter
    zpenalty        Zero penalty /1e6/;

variable
    OBJ		    Objective function;

nonnegative
variables
    YS0_V(r,s,g)    Production
    ID0_V(r,g,s)    Intermediate demand
    DD0_V(r,g)      Regional demand
    ND0_V(r,g)      National demand
    XD0_V(r,g)      Regional supply
    XN0_V(r,g)      National supply
    A0_V(r,g)       Armington demand
    S0_V(r,g)       Total supply
    I0_V(r,g)	    Investment
    G0_V(r,g)	    Government demand;

equations
    objdef, profit, value, disposition, absorption, domestic, national, supply, investment;

objdef..    OBJ =e= 1e-6*(
	            sum((rb(r),s,g)$ys0(r,s,g),	ys0(r,s,g)*sqr(YS0_V(r,s,g)/ys0(r,s,g)-1)) +
		    sum((rb(r),g,s)$id0(r,g,s),	id0(r,g,s)*sqr(ID0_V(r,g,s)/id0(r,g,s)-1)) +
		    sum((rb(r),g)$dd0(r,g),	dd0(r,g)*sqr(DD0_V(r,g)/dd0(r,g)-1)) +
		    sum((rb(r),g)$nd0(r,g),	nd0(r,g)*sqr(ND0_V(r,g)/nd0(r,g)-1)) +
		    sum((rb(r),g)$xd0(r,g),	xd0(r,g)*sqr(XD0_V(r,g)/xd0(r,g)-1)) +
		    sum((rb(r),g)$xn0(r,g),	xn0(r,g)*sqr(XN0_V(r,g)/xn0(r,g)-1)) +
		    sum((rb(r),g)$i0(r,g),	i0(r,g)*sqr(I0_V(r,g)/i0(r,g)-1)) +
		    sum((rb(r),g)$g0(r,g),	g0(r,g)*sqr(G0_V(r,g)/g0(r,g)-1)) +
		    sum((rb(r),g)$a0(r,g),	a0(r,g)*sqr(A0_V(r,g)/a0(r,g)-1)) +
		    sum((rb(r),g)$s0(r,g),	s0(r,g)*sqr(S0_V(r,g)/s0(r,g)-1)) +			
		    
* penalize items which are initially zero -- lasso method:
  		    zpenalty * (
			sum((r,s,g)$(not ys0(r,s,g)),	YS0_V(r,s,g)) + 
			sum((r,g,s)$(not id0(r,g,s)),	ID0_V(r,g,s)) + 
			sum((r,g)$(not dd0(r,g)),	DD0_V(r,g)) + 
			sum((r,g)$(not nd0(r,g)),	ND0_V(r,g)) + 
			sum((r,g)$(not xd0(r,g)),	XD0_V(r,g)) + 
			sum((r,g)$(not xn0(r,g)),	XN0_V(r,g)) + 
			sum((r,g)$(not a0(r,g)),	A0_V(r,g)) + 
			sum((r,g)$(not s0(r,g)),	S0_V(r,g)) + 
			sum((r,g)$(not g0(r,g)),	G0_V(r,g)) + 
			sum((r,g)$(not i0(r,g)),	I0_V(r,g)) ));

* calibration of investment to match growth plus depreciation of capital (holds
* from previous calibration)
investment(rb(r))..	sum(g,I0_V(r,g)) =e= sum(s, (gr+delta(r,s)) * kd0(r,s)/(ir+delta(r,s)));

profit(rb(r),s)..	sum(g,YS0_V(r,s,g)) - taxrev(r,s,'ty') =e= ld0(r,s) + (1+tk0(r))*kd0(r,s) + sum(g,ID0_V(r,g,s));

supply(rb(r),g)..	sum(s,YS0_V(r,s,g)) + yh0(r,g) =e= S0_V(r,g);

disposition(rb(r),g)..	S0_V(r,g) =e= XD0_V(r,g) + XN0_V(r,g) + x0(r,g) - rx0(r,g);

domestic(rb(r),g)..	XD0_V(r,g) =e= sum(m, dm0(r,g,m)) + DD0_V(r,g);

national(g)..		sum(r, XN0_V(r,g)) =e= sum(r, sum(m, nm0(r,g,m)) + ND0_V(r,g));

value(rb(r),g)..	A0_V(r,g) - taxrev(r,g,'ta') + rx0(r,g) =e= (1+tm0(r,g))*m0(r,g) + sum(m, md0(r,m,g)) + ND0_V(r,g) + DD0_V(r,g);

absorption(rb(r),g)..	A0_V(r,g) =e= cd0(r,g) + I0_V(r,g) + G0_V(r,g) + sum(s,ID0_V(r,g,s));

model sscalib /all/;

* level values
YS0_V.L(r,s,g) = ys0(r,s,g);
ID0_V.L(r,g,s) = id0(r,g,s);
DD0_V.L(r,g) = dd0(r,g);
XD0_V.L(r,g) = xd0(r,g);
ND0_V.L(r,g) = nd0(r,g);
XN0_V.L(r,g) = xn0(r,g);
G0_V.L(r,g) = g0(r,g);
A0_V.L(r,g) = a0(r,g);
S0_V.L(r,g) = s0(r,g);

* lower bounds
YS0_V.LO(r,s,g) = ys0(r,s,g)/5;
ID0_V.LO(r,g,s) = id0(r,g,s)/5;
DD0_V.LO(r,g) = dd0(r,g)/5;
XD0_V.LO(r,g) = xd0(r,g)/5;
ND0_V.LO(r,g) = nd0(r,g)/5;
XN0_V.LO(r,g) = xn0(r,g)/5;
G0_V.LO(r,g) = g0(r,g)/5;
A0_V.LO(r,g) = a0(r,g)/5;
S0_V.LO(r,g) = s0(r,g)/5;

* nb: we are solving all the balancing problems simultaneously but we are holding
* fixed trade flows between regions and international markets
alias (r,rr);
rb(r) = yes;
option qcp=cplex;

* fix investment demands to match pre-computed levels
I0_V.FX(r,g) = i0_ss(r,g);
i0(r,g) = i0_ss(r,g);
i0(r,g)$(not round(i0(r,g),5)) = 0;

solve sscalib using QCP minimizing OBJ;

taxrate(r,s,'ty_new')$sum(g, ys0(r,s,g)) = taxrev(r,s,'ty') / sum(g, YS0_V.L(r,s,g));
taxrate(r,g,'ta_new')$a0(r,g) = taxrev(r,g,'ta') / A0_V.L(r,g);
display taxrate;

* write report on deviations from reference parameters
parameter
    calibrep	Report on recalibration,
    chkys0      Report on byproducts;

calibrep(r,s,'ys0','old') = sum(g, ys0(r,s,g));
calibrep(r,s,'ys0','cal') = sum(g, YS0_V.L(r,s,g));
calibrep(r,s,'ys0','%')$calibrep(r,s,'ys0','old') = 100 * (calibrep(r,s,'ys0','cal')/calibrep(r,s,'ys0','old') - 1);
calibrep(r,g,'id0','old') = sum(s, id0(r,g,s));
calibrep(r,g,'id0','cal') = sum(s, ID0_V.L(r,g,s));
calibrep(r,g,'id0','%')$calibrep(r,g,'id0','old') = 100 * (calibrep(r,g,'id0','cal')/calibrep(r,g,'id0','old') - 1);
calibrep(r,g,'dd0','old') = dd0(r,g);
calibrep(r,g,'dd0','cal') = DD0_V.L(r,g);
calibrep(r,g,'dd0','%')$calibrep(r,g,'dd0','old') = 100 * (calibrep(r,g,'dd0','cal')/calibrep(r,g,'dd0','old') - 1);
calibrep(r,g,'nd0','old') = nd0(r,g);
calibrep(r,g,'nd0','cal') = ND0_V.L(r,g);
calibrep(r,g,'nd0','%')$calibrep(r,g,'nd0','old') = 100 * (calibrep(r,g,'nd0','cal')/calibrep(r,g,'nd0','old') - 1);
calibrep(r,g,'xd0','old') = xd0(r,g);
calibrep(r,g,'xd0','cal') = XD0_V.L(r,g);
calibrep(r,g,'xd0','%')$calibrep(r,g,'xd0','old') = 100 * (calibrep(r,g,'xd0','cal')/calibrep(r,g,'xd0','old') - 1);
calibrep(r,g,'xn0','old') = xn0(r,g);
calibrep(r,g,'xn0','cal') = XN0_V.L(r,g);
calibrep(r,g,'xn0','%')$calibrep(r,g,'xn0','old') = 100 * (calibrep(r,g,'xn0','cal')/calibrep(r,g,'xn0','old') - 1);
calibrep(r,g,'a0','old') = a0(r,g);
calibrep(r,g,'a0','cal') = A0_V.L(r,g);
calibrep(r,g,'a0','%')$calibrep(r,g,'a0','old') = 100 * (calibrep(r,g,'a0','cal')/calibrep(r,g,'a0','old') - 1);
calibrep(r,g,'s0','old') = s0(r,g);
calibrep(r,g,'s0','cal') = S0_V.L(r,g);
calibrep(r,g,'s0','%')$calibrep(r,g,'s0','old') = 100 * (calibrep(r,g,'s0','cal')/calibrep(r,g,'s0','old') - 1);
calibrep(r,g,'i0','old') = i0_ss(r,g);
calibrep(r,g,'i0','cal') = I0_V.L(r,g);
calibrep(r,g,'i0','%')$calibrep(r,g,'i0','old') = 100 * (calibrep(r,g,'i0','cal')/calibrep(r,g,'i0','old') - 1);
calibrep(r,g,'g0','old') = g0(r,g);
calibrep(r,g,'g0','cal') = G0_V.L(r,g);
calibrep(r,g,'g0','%')$calibrep(r,g,'g0','old') = 100 * (calibrep(r,g,'g0','cal')/calibrep(r,g,'g0','old') - 1);

chkys0(r,s,g,'old') = ys0(r,s,g);
chkys0(r,s,g,'cal') = YS0_V.L(r,s,g);
chkys0(r,s,g,'%')$chkys0(r,s,g,'old') = 100 * (chkys0(r,s,g,'cal')/chkys0(r,s,g,'old') - 1);
display calibrep, chkys0;

* retrieve the calibrated values and adjust tax rates:
ys0(r,s,g) = YS0_V.L(r,s,g);
id0(r,g,s) = ID0_V.L(r,g,s);
dd0(r,g) = DD0_V.L(r,g);
nd0(r,g) = ND0_V.L(r,g);
xd0(r,g) = XD0_V.L(r,g);
xn0(r,g) = XN0_V.L(r,g);
a0(r,g) = A0_V.L(r,g);
s0(r,g) = S0_V.L(r,g);
i0(r,g) = I0_V.L(r,g);
g0(r,g) = G0_V.L(r,g);

* assign new tax rates:
ty0(r,s) = taxrate(r,s,'ty_new');
ta0(r,g) = taxrate(r,g,'ta_new');


* -----------------------------------------------------------------------------
* Output recalibrated parameters
* -----------------------------------------------------------------------------

execute_unload '%gdxdir%dynamic_parameters_%year%.gdx'
    ys0, id0, dd0, nd0, xd0, xn0, a0, s0, i0, g0, ty0, ta0;
