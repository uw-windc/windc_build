$title Read the household data and recalibrate to match the WiNDC database

$if not set puttitle $set puttitle yes

file kutl; kutl.lw=0;

* -----------------------------------------------------------------------------
* Four step balancing routine:
*    - if dynamic, solve for equilibrium investment demand
*    - solve income routine for aggregated regions
*    - solve income routine at the state level
*    - solve expenditure routine at the state level
*
* This version of the code employs pooled national markets for savings
* and capital income.  Assume equalization of rates of return across all
* capital income.  Assume that the geography of savings is independent of 
* the geography of investment.
*
* Income upperbounds by quintile (CPS) -- can modify:
* (25000, 50000, 75000, 150000, Inf)
*
* Income bins in SOI matched approximately
* (25000, 50000, 75000, 200000, Inf)
*
* Allow the model to calculate foreign savings endogenously.
*
* Assume that fringe benefits (difference between total employee compensation
* and wages/salaries) are shared equivalently as wages and salaries.

* Replaces markups with those calculated when compared to nipa tables
* where applicable.

* Removes use of capital gains -- reflects change in WEALTH, not production
* driven income. Not included in NIPA tables. (still commented out -- if
* everyone okay with this, remove from code)

* added foreign capital ownership and commuting patterns (from ACS) lets us
* target cps shares really well. also foreign direct investment numbers make
* more sense relative to what is suggested by say the IMF.


* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* set year of interest
$if not set year $set year 2014

* set underlying dataset for recalibration
$if not set hhdata $set hhdata "cps"

* switch for invest calibration (static vs. dynamic)
$if not set invest $set invest "static"

* switch for assumption on domestic capital ownership (all vs. partial)
$if not set capital_ownership $set capital_ownership "partial"

* allow end of line comments
$eolcom !

* file separator
$set sep %system.dirsep%

*	Core data directory:
$if not set core $set core ..%sep%core%sep%

*	GDX directory:

$set gdxdir gdx%sep%
$if not dexist gdx $call mkdir gdx

*   Raw Data Directory
$set data_dir ../data/household

* -----------------------------------------------------------------------------
* Read in base WiNDC data
* -----------------------------------------------------------------------------

* read base dataset

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'

alias (r,q,rr), (s,g);


* write basic report on regional determinants of income in base windc data
parameter
    baserep	Baseline report on aggregate regional shares;

baserep(r,'consumption') = c0(r);
baserep(r,'investment') = sum(g, i0(r,g));
baserep(r,'income') = sum(s, ld0(r,s) + kd0(r,s)) + hhadj(r) + sum(g, yh0(r,g));
baserep(r,'labor_shr') = sum(s, ld0(r,s)) / baserep(r,'income');
baserep(r,'capital_shr') = sum(s, kd0(r,s)) / baserep(r,'income');
baserep('usa',"labor_shr") = sum((r,s), ld0(r,s)) / sum(r, baserep(r,'income'));
baserep('usa',"capital_shr") = sum((r,s), kd0(r,s)) / sum(r, baserep(r,'income'));
display baserep;


* -----------------------------------------------------------------------------
* Read in tax rates from SAGE model
* -----------------------------------------------------------------------------

parameter
    tk0(r)     Capital tax rate;

$gdxin '%gdxdir%capital_tax_rates.gdx'
$loaddc tk0
$gdxin

* Convert gross capital payments to net

kd0_(yr,r,s) = kd0_(yr,r,s) / (1+tk0(r));
kd0(r,s) = kd0_("%year%",r,s);


* -----------------------------------------------------------------------------
* Read in household data
* -----------------------------------------------------------------------------

* Define dimensions of the reconciled income shares. note that CPS has data on
* transfer income, but SOI does not.

set
    h      household income categories,
    trn(*) cps transfer income source categories;

parameters
    wages0_(yr,r,h)	Wage income by region and household (in billions),
    interest0_(yr,r,h)	Interest income by region and household (in billions),
    taxes0_(yr,r,h)	Personal income taxes by region and household (in billions),
    trans0_(yr,r,h)	Transfers from government (in billions),
    cpstrn0_(yr,r,h)	CPS cash payment transfers (in billions),
    hhtrans0_(yr,r,h,*)	Disaggregate household transfers (in billions),
    save0_(yr,r,h)	Retirement contributions (in billions),
    cons0_(yr,r,h)	Imputed consumption (in billions),
    pop0_(yr,r,h)	Number of households (in millions),
    pccons0_(yr,r,h)	Per-household consumption,
    taxrate0_(yr,r,h)	Assumed tax rate on labor income,
    taxrate0(r,h)	Assumed tax rate on labor income;

* Turn off domain checking when reading in household data because it is
* available for more recent years than core windc accounts

$gdxin '%gdxdir%%hhdata%_data.gdx'
$loaddc h
$if %hhdata%=="cps" $loaddc trn
$if %hhdata%=="cps" $loaddc wages0 interest0 taxes0 trans0 save0 pop pccons hhtrans0
$if %hhdata%=="soi" $loaddc wages0 interest0 taxes0 trans0 save0 pop=nr pccons
$if %hhdata%=="soi" trn('total') = yes;
$if %hhdata%=="soi" hhtrans0(r,h,trn) = trans0(r,h);

* Require total transfer cash payments from CPS to hold in SOI data

$if %hhdata%=="soi" $gdxin '%gdxdir%cps_data.gdx'
$if %hhdata%=="soi" $load cpstrn0_=trans0_
$if %hhdata%=="soi" trn('total') = yes;
$if %hhdata%=="soi" trans0_(yr,r,h) = cpstrn0_(yr,r,h);
$if %hhdata%=="soi" hhtrans0_(yr,r,h,trn) = trans0_(yr,r,h);

* Read in capital gains data from SOI if calibrating to CPS

* $if %hhdata%=="cps" $gdxin '%gdxdir%soi_capital_gains.gdx'
* $if %hhdata%=="cps" $load capgain0_
* $if %hhdata%=="soi" capgain0_(yr,r,h) = 0;

* Extrapolate size of capital gains based on income shares

* parameter
*     cg_income_share(r,h)	Share of capital income attributable to capital gains;

* cg_income_share(r,h)$sum(yr, capgain0_(yr,r,h)) =
*     sum(yr, capgain0_(yr,r,h)) / sum(yr$capgain0_(yr,r,h), interest0_(yr,r,h) + capgain0_(yr,r,h));

* $if %hhdata%=="cps" interest0_(yr,r,h) = interest0_(yr,r,h)/(1-cg_income_share(r,h));

* Note that the CPS doesn't include tax payments at the household level. we use
* Alex Marten's taxsim code to genrate both average and marginal rates. average
* rates are used here.

$if %hhdata%=="cps" $gdxin '%gdxdir%labor_tax_rates.gdx'
$if %hhdata%=="cps" $loaddc taxrate0
$if %hhdata%=="cps" taxes0(r,h) = taxrate0(r,h) * wages0(r,h);
$if %hhdata%=="soi" taxrate0(r,h) = taxes0(r,h) / (wages0(r,h) + interest0(r,h));

* For SOI data, adjust income tax rates to net out imposed capital tax rate

parameter
    corporate_rate /.186 /;

$if %hhdata%=="soi"  taxes0(r,h) = taxes0(r,h) - sum((rr,s), (tk0(rr) - corporate_rate)*kd0(rr,s)) * interest0(r,h) / sum((r.local, h.local), interest0(r,h));
$if %hhdata%=="soi"  taxrate0(r,h) = taxes0(r,h) / wages0(r,h);

* Compute reference consumption based on known incomes and expenditures

cons0_(yr,r,h) = wages0_(yr,r,h) + interest0_(yr,r,h) + trans0_(yr,r,h) - taxes0_(yr,r,h) - save0_(yr,r,h) + eps;

* report reference income and expenditure shares;
parameter
    hhshares	Reference income shares from household data;

hhshares("income","total",h) = sum(r, wages0(r,h) + interest0(r,h) + trans0(r,h));
hhshares("income","wage",h) = sum(r, wages0(r,h)) / hhshares("income","total",h);
hhshares("income","interest",h) = sum(r, interest0(r,h)) / hhshares("income","total",h);
hhshares("income","transfers",h) = sum(r, trans0(r,h)) / hhshares("income","total",h);

hhshares("expend","total",h) = sum(r, cons0(r,h) + taxes0(r,h) + save0(r,h));
hhshares("expend","cons",h) = sum(r, cons0(r,h)) / hhshares("expend","total",h);
hhshares("expend","taxes",h) = sum(r, taxes0(r,h)) / hhshares("expend","total",h);
hhshares("expend","save",h) = sum(r, save0(r,h)) / hhshares("expend","total",h);

parameter
    comp      Comparison of wages between %hhdata% and WiNDC;

comp(r,'wages0') = sum(h, wages0(r,h));
comp("us",'wages0') = sum((h,r), wages0(r,h));
comp(r,'ld0') = sum(s, ld0(r,s));
comp('us','ld0') = sum((s,r), ld0(r,s));
comp(r,'pct') = 100 * comp(r,'wages0') / comp(r,'ld0');
comp('us','pct') = 100 * comp('us','wages0') / comp('us','ld0');
display comp;

* there are two things going on here. (1) the labor demands account for overhead
* outside of what employees get paid directly for wages and salary. E.g. include
* insurance, pension payments. (2) some people live and work in different
* states.

* compare CPS and SOI population by household:
* parameter
*     pop_(r,h,*)   Population by household (or return) types (in millions),
*     popcps, popsoi, totchk;
* 
* * load cps data
* $gdxin '%gdxdir%cps_data_%year%.gdx'
* $load popcps=pop
* pop_(r,h,'cps') = popcps(r,h);
* 
* * load soi data
* $gdxin '%gdxdir%soi_data_%year%.gdx'
* $load popsoi=nr
* pop_(r,h,'soi') = popsoi(r,h);
* 
* totchk('cps') = sum((r,h), pop_(r,h,'cps'));
* totchk('soi') = sum((r,h), pop_(r,h,'soi'));
* 
* execute_unload 'population_in_millions_%year%.gdx' pop_;


* -----------------------------------------------------------------------------
* Read in known reporting relationships between CPS and NIPA
* -----------------------------------------------------------------------------

* from meyers et al. (2009), most recent estimates of under-reporting are (CPS
* totals / administrative totals for US):

* public assistance: 0.487
* food stammps: 0.539
* social security old age, survivors and disability insurance (oasdi): 0.893
* social secturity old age and survivors insurance (oasi): 0.908
* social security disability insurance (ssdi): 0.819
* supplemental security income: 0.759
* unemployment insurance: 0.679
* workers compensation: 0.527
* earned income tax credit: 0.827

* from rothbaum (2015):

* veteran's payments: .679
* social security: .899
* all transfers: .804
* interest, dividents, royalties (capital payments): .530

parameter
    trn_weight(*),
    trn_agg_weight,
    cap_weight;

* use when exist, otherwise default to all transfer share
$if %hhdata%=="cps" trn_weight('hucval') = 1 / 0.679;
$if %hhdata%=="cps" trn_weight('hwcval') = 1 / 0.527;
$if %hhdata%=="cps" trn_weight('hssval') = 1 / 0.899;
$if %hhdata%=="cps" trn_weight('hssival') = 1 / 0.759;
$if %hhdata%=="cps" trn_weight('hpawval') = 1 / 0.487;
$if %hhdata%=="cps" trn_weight('hvetval') = 1 / 0.679;
$if %hhdata%=="cps" trn_weight('hsurval') = 1 / 0.908;
$if %hhdata%=="cps" trn_weight('hdisval') = 1 / 0.819;
$if %hhdata%=="cps" trn_weight('hedval') = 1 / 0.804;
$if %hhdata%=="cps" trn_weight('hcspval') = 1 / 0.804;
$if %hhdata%=="cps" trn_weight('hfinval') = 1 / 0.539;
$if %hhdata%=="cps" trn_agg_weight = sum((trn,r,h), trn_weight(trn)*hhtrans0(r,h,trn)) / sum((r,h,trn),hhtrans0(r,h,trn));

$if %hhdata%=="soi" trn_weight('total') = 1 / 0.804; 
$if %hhdata%=="soi" trn_agg_weight = 1 / 0.804; 

$if %hhdata%=="cps" cap_weight = 1 / .530;
$if %hhdata%=="soi" cap_weight = 1;


* -----------------------------------------------------------------------------
* Balancing routine step 0: partial dynamic calibration (change investment for
* household recalibration if invest=dynamic switch activated)
* -----------------------------------------------------------------------------

* assumed invest=dynamic parameters
parameter
	gr		Growth rate /0.02/,
	ir		Interest rate /0.04/,
	delta(r,s)	Assumed sectoral depreciation rate;

delta(r,s) = 0.07;

variables
    OBJI	    Objective value for investment;

nonnegative
variables
    INV(r,g)	    Steady state investment;

equations
    investment(r)   Steady state investment,
    objinv          Objective function;

objinv..        OBJI =e= sum((r,g)$i0(r,g), i0(r,g) * sqr(INV(r,g) / i0(r,g) - 1));

investment(r)..	sum(g, INV(r,g)) =e= sum(s, (gr+delta(r,s)) * kd0(r,s)/(ir+delta(r,s)));

parameter
    compi0(r,g,*)    Comparison between reference and steady state investment levels;

compi0(r,g,'ref') = i0(r,g);


* fix investment to zero if zero in benchmark and set lower bounds

i0(r,g)$(not round(i0(r,g),5)) = 0;

$ifthen.dynamic %invest%==dynamic

$if %puttitle%==yes put_utility kutl 'title' /'solve partial_ss minimizing OBJI using QCP';

	model partial_ss /objinv, investment/;
	INV.L(r,g) = i0(r,g);

	option qcp = cplex;

	INV.LO(r,g) = 0.5 * i0(r,g);
	INV.FX(r,g)$(not i0(r,g)) = 0;
	solve partial_ss minimizing OBJI using QCP;

*	Output dynamic adjustment to investment.  This is subsequently imposed in dynamic_calib.gms

	i0(r,g) = INV.L(r,g);
	execute_unload "%gdxdir%i0_%year%.gdx" i0, gr, ir, delta;

	compi0(r,g,'ss') = i0(r,g);

$endif.dynamic

* -----------------------------------------------------------------------------
* Prepare additional parameter targets for income side balancing routine
* -----------------------------------------------------------------------------

* there are differences between the balancing routines for the cps vs. soi data
* due to differences in how the underlying data is reported.
parameter    cps		    Switch for cps based constraints /0/;

$if %hhdata%=="cps" cps=1;

* include mapping file of aggregated regions
$oneolcom
$onembedded
$include 'maps%sep%hh_calib_aggregate_regions.map'

* generate set of regions within aggregated regions
set
    within(r,rr,ar)     Within aggregated region set;

within(r,rr,ar) = yes$(mapr(ar,r) and mapr(ar,rr));

* aggregate data
parameters
    wages0_ag(ar,h)	    Wage income by region and household (in billions),
    interest0_ag(ar,h)	Interest income by region and household (in billions),
    taxes0_ag(ar,h)	    Personal income taxes by region and household (in billions),
    trans0_ag(ar,h)	    Transfers from government (in billions),
    hhtrans0_ag(ar,h,*) Disaggregate household transfers (in billions),
    tottrn0_ag(ar)      Total CPS cash transfer payments (in billions),
    save0_ag(ar,h)	    Retirement contributions (in billions),
    cons0_ag(ar,h)	    Imputed consumption (in billions),
    pop_ag(ar,h)	    Number of households (in millions),
    pccons_ag(ar,h)     Per-household consumption,
    taxrate0_ag(ar,h)   Assumed tax rate on income,
    ld0_ag(ar,s)        Labor demand,
    kd0_ag(ar,s)        Capital demand,
    cd0_ag(ar,s)        Final demand,
    i0_ag(ar,s)         Investment demand,    
    yh0_ag(ar,s)        Household production,
    c0_ag(ar)           Aggregate final demand;

wages0_ag(ar,h) = sum(mapr(ar,r), wages0(r,h));
interest0_ag(ar,h) = sum(mapr(ar,r), interest0(r,h));
taxes0_ag(ar,h) = sum(mapr(ar,r), taxes0(r,h));
trans0_ag(ar,h) = sum(mapr(ar,r), trans0(r,h));
tottrn0_ag(ar) = sum(mapr(ar,r), tottrn0(r));
hhtrans0_ag(ar,h,trn) = sum(mapr(ar,r), hhtrans0(r,h,trn));
save0_ag(ar,h) = sum(mapr(ar,r), save0(r,h));
cons0_ag(ar,h) = sum(mapr(ar,r), cons0(r,h));
pop_ag(ar,h) = sum(mapr(ar,r), pop(r,h));
pccons_ag(ar,h) = cons0_ag(ar,h) / pop_ag(ar,h);
taxrate0_ag(ar,h) = taxes0_ag(ar,h) / wages0_ag(ar,h);
ld0_ag(ar,s) = sum(mapr(ar,r), ld0(r,s));
kd0_ag(ar,s) = sum(mapr(ar,r), kd0(r,s));
cd0_ag(ar,s) = sum(mapr(ar,r), cd0(r,s));
i0_ag(ar,s) = sum(mapr(ar,r), i0(r,s));
yh0_ag(ar,s) = sum(mapr(ar,r), yh0(r,s));
c0_ag(ar) = sum(mapr(ar,r), c0(r));

* specify the matrix balancing routine
set
    cv              Set of variables
                    /CONS, WAGES, INTEREST, SAVE, TRANS, INV/;

variable
    OBJ                Objective definition
    TAXES_AG(ar,h)     Direct labor tax payments;

nonnegative
variable
    TRANS_AG(ar,h)     Transfer payments,
    TRANSHH_AG(ar,h,*) Disaggregate Transfer payments,
    CONS_AG(ar,h)      Consumption expenditure
    WAGES_AG(ar,h)     Aggregate wage income,
    INTEREST_AG(ar,h)  Aggregate interest income,
    SAVE_AG(ar,h)      Savings,
    LAMDA_AG(cv)       Scale factor,
    FSAV_AG            Foreign savings in United States;

equations
    objdef_ag          Objective function,
    taxdef_ag          Tax constraint,
    consdef_ag         Consumption constraint,
    wagedef_ag         Labor income constraint,
    interestdef_ag     Capital income constraint,
    savedef_ag         Savings constraint,
    incbal_ag          Income balance closure,
    disagtrn_ag        Disaggregate transfer payment,
    totaltrnless_ag    Require total cash transfers to match CPS approximately,
    totaltrnmore_ag    Require total cash transfers to match CPS approximately,
    trntype_ag         Require transfer totals match literature by type,
    lincdef_ag         Constraint on wages to scale the same across household types for fringe benefits;

* objective definition (penalizing consumption from going to zero)

objdef_ag..        OBJ =e= sum((ar,h),
		            sqr(CONS_AG(ar,h) - LAMDA_AG("CONS") * cons0_ag(ar,h)) - 
		           (log(CONS_AG(ar,h)) - log(cons0_ag(ar,h))) +
            	            sqr(WAGES_AG(ar,h) - LAMDA_AG("WAGES") * wages0_ag(ar,h)) + 
            	           (sum(trn, sqr(TRANSHH_AG(ar,h,trn) - LAMDA_AG("TRANS")*hhtrans0_ag(ar,h,trn))))$cps +
            	           (sqr(TRANS_AG(ar,h) - LAMDA_AG("TRANS") * trans0_ag(ar,h)))$(not cps) +
                            sqr(INTEREST_AG(ar,h) - LAMDA_AG("INTEREST") * interest0_ag(ar,h)) +
            	            sqr(SAVE_AG(ar,h) - LAMDA_AG("SAVE") * save0_ag(ar,h)));

* let transfer payments and taxes adjust to satisfy budget balance assumptions
incbal_ag(ar,h)..  TRANS_AG(ar,h) + WAGES_AG(ar,h) + INTEREST_AG(ar,h) =e= CONS_AG(ar,h) + SAVE_AG(ar,h) + TAXES_AG(ar,h);

* fix the income tax rate from the household data
taxdef_ag(ar,h)..  TAXES_AG(ar,h) =e= taxrate0_ag(ar,h) * WAGES_AG(ar,h);

* aggregation definition on total household consumption
consdef_ag(ar)..   sum(h, CONS_AG(ar,h)) =e= c0_ag(ar);

* wage income must sum to total labor demands by region
wagedef_ag(ar)..   sum(h, WAGES_AG(ar,h)) =e= sum(s, ld0_ag(ar,s));

* without more information, assume wages scale the same across households
lincdef_ag(ar,h).. WAGES_AG(ar,h) =e= sum(s, ld0_ag(ar,s)) / sum(h.local, wages0_ag(ar,h)) * wages0_ag(ar,h);

* capital rents must sum to total capital demands by region
interestdef_ag..   sum((ar,h), INTEREST_AG(ar,h)) =e= sum((ar,s), kd0_ag(ar,s) + yh0_ag(ar,s));

* ignore enterprise and government saving:
savedef_ag..	   sum((ar,h), SAVE_AG(ar,h)) + FSAV_AG =e= sum((ar,g), i0_ag(ar,g));

* disaggregate transfer payments
disagtrn_ag(ar,h).. sum(trn, TRANSHH_AG(ar,h,trn)) =e= TRANS_AG(ar,h);

* verify totals on specific transfers
trntype_ag(trn)$cps.. sum((ar,h), TRANSHH_AG(ar,h,trn)) =e= sum((ar,h), hhtrans0_ag(ar,h,trn))*trn_weight(trn);

* if using soi, require total regional transfers line up with CPS totals
totaltrnless_ag(ar)$(not cps)..  sum(h, TRANS_AG(ar,h)) =l= 1.2 * trn_agg_weight * tottrn0_ag(ar);
totaltrnmore_ag(ar)$(not cps)..  sum(h, TRANS_AG(ar,h)) =g= 0.8 * trn_agg_weight * tottrn0_ag(ar);

model calib_step1_%hhdata% /objdef_ag, taxdef_ag, consdef_ag, wagedef_ag, interestdef_ag, savedef_ag,
			    trntype_ag, incbal_ag, disagtrn_ag, totaltrnless_ag, totaltrnmore_ag, lincdef_ag /;

* can connect to litereature by specifying large upper bound on transfers due to
* non-reporting of transfers. upper bound could be set by understanding
* magnitude ot non-reporting. see literature. and set upper bound for specific
* transfer income categories that make sense. see:
* https://www.cbo.gov/system/files/2018-07/54234-workingpaper.pdf
* use meyer et al (2008) to characterize upper bounds.
$if %hhdata%=="soi" TRANSHH_AG.L(ar,h,trn) = trn_weight(trn) * hhtrans0_ag(ar,h,trn);
$if %hhdata%=="cps" TRANSHH_AG.L(ar,h,trn) = trn_weight(trn) * hhtrans0_ag(ar,h,trn);
$if %hhdata%=="cps" TRANSHH_AG.UP(ar,h,trn) = 1.25 * trn_weight(trn) * hhtrans0_ag(ar,h,trn);
$if %hhdata%=="cps" TRANSHH_AG.LO(ar,h,trn) = 0.75 * trn_weight(trn) * hhtrans0_ag(ar,h,trn);

* assume that transfers are "underreported" by assuming lower bound is the data
TRANS_AG.L(ar,h) = trans0_ag(ar,h);
TRANS_AG.LO(ar,h) = trans0_ag(ar,h);

* need to specify lower bound due to log function. because "consumption" is
* defined by income accounts, we let the lower bound be relatively small.
CONS_AG.L(ar,h) = cons0_ag(ar,h);
CONS_AG.LO(ar,h) = 0.5 * cons0_ag(ar,h);

* lower bounds for wages and capital payments, at this aggregated level (note,
* troublesome states like VA, MD and DC should be netted out here).
WAGES_AG.L(ar,h) = wages0_ag(ar,h);
WAGES_AG.LO(ar,h) = 0.75 * wages0_ag(ar,h);
INTEREST_AG.L(ar,h) = cap_weight * interest0_ag(ar,h);
INTEREST_AG.LO(ar,h) = 0.75 * interest0_ag(ar,h);

SAVE_AG.L(ar,h) = save0_ag(ar,h);
TAXES_AG.L(ar,h) = taxes0_ag(ar,h);

LAMDA_AG.L(cv) = 1;
LAMDA_AG.LO(cv) = 0.01;

* To force the model to allocate savings and capital ownership better, assume
* CPS/SOI data is a rough upper bound for lower quintiles. This assumes that
* retirement income is the maximum savings these bottom three quintiles engage
* in. Can connect to Zucman and Saez noting limited savings for households with
* < 90% percentile in wealth. Also assume non-reporting
* of transfers in CPS occurs in lower quintiles and assume the data represent an
* upper bound for top two quintiles. also see:
* https://www.census.gov/content/dam/Census/library/working-papers/2015/demo/SEHSD-WP2015-01.pdf

INTEREST_AG.UP(ar,h)$(ord(h)<5) = cap_weight * interest0_ag(ar,h);
SAVE_AG.LO(ar,h) = save0_ag(ar,h);
SAVE_AG.UP(ar,h)$(ord(h)<4) = 1.25 * save0_ag(ar,h);
TRANS_AG.UP(ar,h)$(ord(h)>3) = 1.25 * trn_agg_weight * trans0_ag(ar,h);

* solve step 1

option nlp=ipopt;

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step1_%hhdata% using nlp minimizing OBJ;';
solve calib_step1_%hhdata% using nlp minimizing OBJ;

if(calib_step1_%hhdata%.modelstat > 2,
	option nlp=conopt;
	solve calib_step1_%hhdata% using nlp minimizing OBJ;
);

ABORT$(calib_step1_%hhdata%.modelstat > 2) "Model calib_step1_%hhdata% has status > 2.";

* construct reports
parameter
    household_shares(r,h,*)	Household shares of income,
    savings_rate0(r,h)		Reference savings rate from hh data,
    fringe_markup		Fringe benefit markup,
    le0_multiplier(r)		Labor income difference between home and work destination,
    commute0(r,rr)		Approximate value of commuting flows from ACS-CPS,
    cap_own0_			Time series of capital ownership shares,
    cap_own0			Portion of capital stock owned domestically;

* Labor income shares defined by region:

household_shares(r,h,'wages') = wages0(r,h) / sum(h.local, wages0(r,h));

* Capital income shares defined across U.S. (capital market closed nationally)

household_shares(r,h,'cap') = interest0(r,h) / sum((r.local, h.local), interest0(r,h));

* Reference savings rate defined as portion of disposable income not spent on
* current consumption

savings_rate0(r,h) = save0(r,h) / (save0(r,h) + cons0(r,h));

* Define a multiplier that characterizes the ratio of income received from labor
* compensation to sectoral labor payments. If the number is <1, we can interpret
* as relatively more commuters coming into the state to work. If >1, commuters
* leave the state to work. DC is a good example of the former case. First,
* adjust the fringe markup such that total wages = total labor demands.

chkhhdata_ar("expend","total",h) = sum(ar, CONS_AG.L(ar,h) + TAXES_AG.L(ar,h) + SAVE_AG.L(ar,h));
chkhhdata_ar("expend","cons",h) = sum(ar, CONS_AG.L(ar,h)) / chkhhdata_ar("expend","total",h);
chkhhdata_ar("expend","taxes",h) = sum(ar, TAXES_AG.L(ar,h)) / chkhhdata_ar("expend","total",h);
chkhhdata_ar("expend","save",h) = sum(ar, SAVE_AG.L(ar,h)) / chkhhdata_ar("expend","total",h);

increp_ar(ar,h,'wage','cal') = WAGES_AG.L(ar,h) / (WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h));
increp_ar(ar,h,'interest','cal') = INTEREST_AG.L(ar,h) / (WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h));
increp_ar(ar,h,'trans','cal') = TRANS_AG.L(ar,h) / (WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h));
increp_ar('us',h,'wage','cal') = sum(ar, WAGES_AG.L(ar,h)) / sum(ar,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar('us',h,'interest','cal') = sum(ar, INTEREST_AG.L(ar,h)) / sum(ar,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar('us',h,'trans','cal') = sum(ar, TRANS_AG.L(ar,h)) / sum(ar,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar(ar,"all",'wage','cal') = sum(h, WAGES_AG.L(ar,h)) / sum(h,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar(ar,"all",'interest','cal') = sum(h, INTEREST_AG.L(ar,h)) / sum(h,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar(ar,"all",'trans','cal') = sum(h, TRANS_AG.L(ar,h)) / sum(h,(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar("us","all",'wage','cal') = sum((ar,h), WAGES_AG.L(ar,h)) / sum((ar,h),(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar("us","all",'interest','cal') = sum((ar,h), INTEREST_AG.L(ar,h)) / sum((ar,h),(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));
increp_ar("us","all",'trans','cal') = sum((ar,h), TRANS_AG.L(ar,h)) / sum((ar,h),(WAGES_AG.L(ar,h) + INTEREST_AG.L(ar,h) + TRANS_AG.L(ar,h)));

increp_ar(ar,h,'wage','data') = WAGES0_ag(ar,h) / (WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h));
increp_ar(ar,h,'interest','data') = INTEREST0_ag(ar,h) / (WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h));
increp_ar(ar,h,'trans','data') = TRANS0_ag(ar,h) / (WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h));
increp_ar('us',h,'wage','data') = sum(ar, WAGES0_ag(ar,h)) / sum(ar,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar('us',h,'interest','data') = sum(ar, INTEREST0_ag(ar,h)) / sum(ar,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar('us',h,'trans','data') = sum(ar, TRANS0_ag(ar,h)) / sum(ar,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar(ar,"all",'wage','data') = sum(h, WAGES0_ag(ar,h)) / sum(h,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar(ar,"all",'interest','data') = sum(h, INTEREST0_ag(ar,h)) / sum(h,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar(ar,"all",'trans','data') = sum(h, TRANS0_ag(ar,h)) / sum(h,(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar("us","all",'wage','data') = sum((ar,h), WAGES0_ag(ar,h)) / sum((ar,h),(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar("us","all",'interest','data') = sum((ar,h), INTEREST0_ag(ar,h)) / sum((ar,h),(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));
increp_ar("us","all",'trans','data') = sum((ar,h), TRANS0_ag(ar,h)) / sum((ar,h),(WAGES0_ag(ar,h) + INTEREST0_ag(ar,h) + TRANS0_ag(ar,h)));

boundshr_ar(h,'wage','min') = smin(ar, increp_ar(ar,h,'wage','cal'));
boundshr_ar(h,'wage','max') = smax(ar, increp_ar(ar,h,'wage','cal'));
boundshr_ar(h,'interest','min') = smin(ar, increp_ar(ar,h,'interest','cal'));
boundshr_ar(h,'interest','max') = smax(ar, increp_ar(ar,h,'interest','cal'));
boundshr_ar(h,'trans','min') = smin(ar, increp_ar(ar,h,'trans','cal'));
boundshr_ar(h,'trans','max') = smax(ar, increp_ar(ar,h,'trans','cal'));
display cbochk_ar, chkhhdata_ar, hhshares, increp_ar, boundshr_ar;
* execute_unload '%hhdata%_agreport.gdx' chkhhdata_ar=calib, hhshares=data;
* execute 'gdxxrw %hhdata%_agreport.gdx par=calib rng=calib! cdim=0 par=data rng=data! cdim=0';

* construct wage multiplier to constrain wage fluctuations in the disaggregate model
parameter
    le0mult(r)    Multiplier on regional wages;

le0mult(r) = sum((mapr(ar,r),h), wages_ag.l(ar,h)) / sum((mapr(ar,r),h), wages0_ag(ar,h));
display le0mult;

le0_multiplier(r)$(le0_multiplier(r)>1 and sum(rr,commute0(r,rr))=0) = 1;
le0_multiplier(r)$(le0_multiplier(r)<1 and sum(rr,commute0(rr,r))=0) = 1;

* Set assumption on capital ownership (partial ownership is based on NIPA totals)

$call 'csv2gdx %data_dir%%sep%cps%sep%windc_vs_nipa_domestic_capital.csv output=%gdxdir%windc_vs_nipa_domestic_capital.gdx id=cap_own0_ index=(1) useHeader=y value=4';
$gdxin %gdxdir%windc_vs_nipa_domestic_capital.gdx
$load cap_own0_
$gdxin
$if %capital_ownership%=="partial" cap_own0 = cap_own0_("%year%");
$if %capital_ownership%=="all" cap_own0 = 1;


* -----------------------------------------------------------------------------
* Income side balancing routine
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
* Balancing routine step 2: state level income side
* -----------------------------------------------------------------------------

variable
    TAXES(r,h)      Direct labor tax payments;

nonnegative
variable
    TRANS(r,h)      Transfer payments,
    TRANSHH(r,h,*)  Disaggregate Transfer payments,
    CONS(r,h)       Consumption expenditure
    WAGES(r,r,h)    Aggregate wage income (living in r and working in rr),
    INTEREST(r,h)   Aggregate interest income,
    SAVE(r,h)       Savings,
    LAMDA(cv)       Scale factor,
    FSAV            Foreign savings in United States;

equations
    objdef          Objective function,
    taxdef          Tax constraint,
    consdef         Consumption constraint,
    wagedef         Cross state labor income constraint,
    lincdef         Within state labor income constraint,
    interestdef     Capital income constraint,
    savedef         Savings constraint,
    incbal          Income balance closure,
    disagtrn        Disaggregate transfer payment,
    totaltrnless    For SOI recalibration enforce CPS transfer totals approximately,
    totaltrnmore    For SOI recalibration enforce CPS transfer totals approximately,
    ar_trans        Aggregate region transfers totals,
    ar_transhh      Aggregate region transfers totals,
    ar_wages        Aggregate region wage totals,
    ar_interest     Aggregate region interest payment totals,
    ar_save         Aggregate region savings totals;

* objective definition (penalizing consumption from going to zero)

objdef..
    OBJ =e= sum((r,h),
 	abs(household_shares(r,h,'wages')*le0_multiplier(r)*sum(s,ld0(r,s)))*
		sqr(sum(rr, WAGES(r,rr,h))/(household_shares(r,h,'wages')*le0_multiplier(r)*sum(s,ld0(r,s))) - 1) +
	abs(household_shares(r,h,'cap')*cap_own0*sum((s,rr),kd0(rr,s)))*
		sqr(INTEREST(r,h)/(household_shares(r,h,'cap')*cap_own0*sum((s,rr),kd0(rr,s))) - 1)) +
    	sum((r,rr)$commute0(r,rr), sum(h, WAGES(r,rr,h))/commute0(r,rr));
	
* fix the income tax rate from the household data
taxdef(r,h)..	TAXES(r,h) =e= taxrate0(r,h) * sum(rr, WAGES(r,rr,h));

* aggregation definition on total household consumption
consdef(r)..    sum(h, CONS(r,h)) =e= c0(r);

* wage income must sum to total labor demands by region
wagedef(rr)..   sum((r,h), WAGES(r,rr,h)) =e= sum(s, ld0(rr,s));

* define constraint on labor income
lincdef(r,h)..  sum(rr, WAGES(r,rr,h)) =l= le0mult(r) * wages0(r,h);

* capital rents must sum to total capital demands by region
interestdef..   sum((r,h), INTEREST(r,h)) =e= sum((r,s), kd0(r,s) + yh0(r,s));

* ignore enterprise and government saving:
savedef..	sum((r,h), SAVE(r,h)) + FSAV =e= sum((r,g), i0(r,g));

* let transfer payments and taxes adjust to satisfy budget balance assumptions
incbal(r,h)..	TRANS(r,h) + sum(rr, WAGES(r,rr,h)) + INTEREST(r,h) =e= CONS(r,h) + SAVE(r,h) + TAXES(r,h);

* disaggregate transfer payments
disagtrn(r,h).. sum(trn, TRANSHH(r,h,trn)) =e= TRANS(r,h);

* for soi calibration, require state level transfers to line up with cps data
totaltrnless(r)$(not cps).. sum(h, TRANS(r,h)) =l= 1.2 * trn_agg_weight * tottrn0(r);
totaltrnmore(r)$(not cps).. sum(h, TRANS(r,h)) =g= 0.8 * trn_agg_weight * tottrn0(r);

* require that state level accounts match those at the census region
ar_trans(ar,h)..       sum(mapr(ar,r), TRANS(r,h)) =e= TRANS_AG.L(ar,h);
ar_transhh(ar,h,trn).. sum(mapr(ar,r), TRANSHH(r,h,trn)) =e= TRANSHH_AG.L(ar,h,trn);
ar_wages(ar,h)..       sum(mapr(ar,r), sum(rr, WAGES(r,rr,h))) =e= WAGES_AG.L(ar,h);
ar_interest(ar,h)..    sum(mapr(ar,r), INTEREST(r,h)) =e= INTEREST_AG.L(ar,h);
ar_save(ar,h)..        sum(mapr(ar,r), SAVE(r,h)) =e= SAVE_AG.L(ar,h);

model calib_step2_%hhdata% / objdef, taxdef, consdef, wagedef, lincdef, interestdef, savedef, incbal, disagtrn,
                             totaltrnless, totaltrnmore, ar_trans, ar_transhh, ar_wages, ar_interest, ar_save /;

* assume bounds akin to aggregated solve

TRANSHH.L(r,h,trn) = trn_weight(trn) * hhtrans0(r,h,trn);

* Target income SHARES for wages and capital earnings (both categories having
* missing information so we target the distribution based on WiNDC
* totals). Restrictions of interstate commuting handled through the objective
* function. Note that commute0(r,rr) represents an upper bound on interstate
* commuting -- it is estimated by taking the number of estimated commuters from
* the ACS multiplied by average household income in the origin state of the
* commute.

TRANS.L(r,h) = trans0(r,h);
TRANS.LO(r,h) = 0.75 * trans0(r,h);
TRANS.UP(r,h)$(ord(h)>3) = 1.25 * trn_agg_weight * trans0(r,h);

CONS.L(r,h) = cons0(r,h);
CONS.LO(r,h) = 0.5 * cons0(r,h);

INTEREST.L(r,h) = household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
INTEREST.LO(r,h) = 0.75 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
INTEREST.UP(r,h) = 1.25 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
FINT.L = (1-cap_own0) * sum((r,s), kd0(r,s));

INTEREST.L(r,h) = interest0(r,h);
INTEREST.LO(r,h) = 0.75 * interest0(r,h);
INTEREST.UP(r,h)$(ord(h)<5) = cap_weight * interest0(r,h);

SAVE.L(r,h) = save0(r,h);
SAVE.LO(r,h) = save0(r,h);
SAVE.UP(r,h)$(ord(h)<4) = 1.25 * save0(r,h);

TAXES.L(r,h) = taxes0(r,h);

LAMDA.L(cv) = LAMDA_AG.L(cv);
LAMDA.LO(cv) = 0.01;

* use savepoint to speed subsequent model runes
calib_step2_%hhdata%.savepoint = 1;
$if exist '%gdxdir%calib_step2_%hhdata%_p.gdx' execute_loadpoint '%gdxdir%calib_step2_%hhdata%_p.gdx';

* solve step 2

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step2_%hhdata% using nlp minimizing OBJ;';

option nlp=ipopt;

solve calib_step2_%hhdata% using nlp minimizing OBJ;

if (calib_step2_%hhdata%.modelstat > 2,
	option nlp=conopt;
	solve calib_step2_%hhdata% using nlp minimizing OBJ;
);

ABORT$(calib_step2_%hhdata%.modelstat > 2) "Model calib_step2_%hhdata% has status > 2.";

execute 'mv -f calib_step2_%hhdata%_p.gdx %gdxdir%calib_step2_%hhdata%_p.gdx';

* construct reports
parameter
    cbochk    Check on CBO result for transfers less taxes,
    chkhhdata Aggregate shares for calibrated dataset,
    increp    Income report,
    boundshr  Report on minimum and maximum shares,
    chkwages  Check on multi-dimensional wages;

cbochk(h) = sum(r, TRANS.L(r,h) - TAXES.L(r,h));

chkhhdata("income","total",h) = sum(r, sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h));
chkhhdata("income","wage",h) = sum(r, sum(rr, WAGES.L(r,rr,h))) / chkhhdata("income","total",h);
chkhhdata("income","interest",h) = sum(r, INTEREST.L(r,h)) / chkhhdata("income","total",h);
chkhhdata("income","transfers",h) = sum(r, TRANS.L(r,h)) / chkhhdata("income","total",h);

chkhhdata("expend","total",h) = sum(r, CONS.L(r,h) + TAXES.L(r,h) + SAVE.L(r,h));
chkhhdata("expend","cons",h) = sum(r, CONS.L(r,h)) / chkhhdata("expend","total",h);
chkhhdata("expend","taxes",h) = sum(r, TAXES.L(r,h)) / chkhhdata("expend","total",h);
chkhhdata("expend","save",h) = sum(r, SAVE.L(r,h)) / chkhhdata("expend","total",h);

increp(r,h,'wage','cal') = sum(rr, WAGES.L(r,rr,h)) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h));
increp(r,h,'interest','cal') = INTEREST.L(r,h) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h));
increp(r,h,'trans','cal') = TRANS.L(r,h) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h));
increp('us',h,'wage','cal') = sum(r, sum(rr, WAGES.L(r,rr,h))) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp('us',h,'interest','cal') = sum(r, INTEREST.L(r,h)) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp('us',h,'trans','cal') = sum(r, TRANS.L(r,h)) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp(r,"all",'wage','cal') = sum(h, sum(rr, WAGES.L(r,rr,h))) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp(r,"all",'interest','cal') = sum(h, INTEREST.L(r,h)) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp(r,"all",'trans','cal') = sum(h, TRANS.L(r,h)) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp("us","all",'wage','cal') = sum((r,rr,h), WAGES.L(r,rr,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp("us","all",'interest','cal') = sum((r,h), INTEREST.L(r,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp("us","all",'trans','cal') = sum((r,h), TRANS.L(r,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));

increp(r,h,'wage','data') = WAGES0(r,h) / (WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h));
increp(r,h,'interest','data') = INTEREST0(r,h) / (WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h));
increp(r,h,'trans','data') = TRANS0(r,h) / (WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h));
increp('us',h,'wage','data') = sum(r, WAGES0(r,h)) / sum(r,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp('us',h,'interest','data') = sum(r, INTEREST0(r,h)) / sum(r,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp('us',h,'trans','data') = sum(r, TRANS0(r,h)) / sum(r,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp(r,"all",'wage','data') = sum(h, WAGES0(r,h)) / sum(h,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp(r,"all",'interest','data') = sum(h, INTEREST0(r,h)) / sum(h,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp(r,"all",'trans','data') = sum(h, TRANS0(r,h)) / sum(h,(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp("us","all",'wage','data') = sum((r,h), WAGES0(r,h)) / sum((r,h),(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp("us","all",'interest','data') = sum((r,h), INTEREST0(r,h)) / sum((r,h),(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));
increp("us","all",'trans','data') = sum((r,h), TRANS0(r,h)) / sum((r,h),(WAGES0(r,h) + INTEREST0(r,h) + TRANS0(r,h)));

boundshr(h,'wage','min') = smin(r, increp(r,h,'wage','cal'));
boundshr(h,'wage','max') = smax(r, increp(r,h,'wage','cal'));
boundshr(h,'wage','mean') = chkhhdata("income","wage",h);
boundshr(h,'interest','min') = smin(r, increp(r,h,'interest','cal'));
boundshr(h,'interest','max') = smax(r, increp(r,h,'interest','cal'));
boundshr(h,'interest','mean') = chkhhdata("income","interest",h);
boundshr(h,'trans','min') = smin(r, increp(r,h,'trans','cal'));
boundshr(h,'trans','max') = smax(r, increp(r,h,'trans','cal'));
boundshr(h,'trans','mean') = chkhhdata("income","transfers",h);

chkwages(r,h,'le0') = wages0(r,h);
chkwages(r,h,'le0_cal') = sum(rr, WAGES.L(r,rr,h));
chkwages(r,h,'le0_pct') = 100 * chkwages(r,h,'le0_cal') / chkwages(r,h,'le0');
chkwages(r,'all','le0') = sum(h, wages0(r,h));
chkwages(r,'all','le0_cal') = sum((rr,h), WAGES.L(r,rr,h));
chkwages(r,'all','ld0') = sum(s, ld0(r,s));
chkwages(r,'all','ld0_pct') = 100 * chkwages(r,'all','le0_cal') / chkwages(r,'all','ld0');
chkwages(r,'all','le0_pct') = 100 * chkwages(r,'all','le0_cal') / chkwages(r,'all','le0');
display cbochk, chkhhdata, hhshares, increp, boundshr, chkwages, FSAV.L, cons_save, WAGES.L;

parameter
    avg_tax_h, avg_tax_r, avg_tax    Reports on average tax rates;

avg_tax_h(h) = sum(r, TAXES.L(r,h)) / sum(r, sum(rr, WAGES.L(r,rr,h)));
avg_tax_r(r) = sum(h, TAXES.L(r,h)) / sum(h, sum(rr, WAGES.L(r,rr,h)));
avg_tax = sum((r,h), TAXES.L(r,h)) / sum((r,h), sum(rr, WAGES.L(r,rr,h)));
display avg_tax_h, avg_tax;
$exit

* -----------------------------------------------------------------------------
* Balancing routine step 3: state level expenditures
* -----------------------------------------------------------------------------

* set up step 3 with income elasticities of demand from SAGE
* documentation
set
    cex    Income elasticity categories /
             alcbev          "alcoholic beverages",
	     food            "food",
	     tobacc          "tobacco",
	     appar           "apparel",
	     persca          "personal care",
	     read            "reading/books",
	     educa           "education",
	     medical         "medical"
	     entert          "entertainment",
	     elec            "electricity",
	     natural_gas     "natural gas",
	     fuel_oil        "other heating fuels",
	     telephone       "telephone",
	     water           "water utilities",
	     shelter         "rent for housing",
	     oper_furnish    "house furnishings and equipment",
	     vacation_home_q "vacation home imputed rent",
	     tran_fuel       "fuel for transportation",
	     veh_mainten     "vehicle maintenance",
	     veh_finance     "vehicle financing",
	     veh_serv2       "vehicle services for owned or rented vehicles" /
     mapi(cex,g)    Mapping between demand categories and WiNDC;

parameters
  regres            Regression results from income elasticity estimation (based on aguiar et al. 2015),
  pcebridge         Bridge between PCE and WiNDC accounts,
  eta_(cex)         Income elasticities for cex categories,
  pceshr(cex,s)     PCE shares to link elasticities to sage demand categries,
  chkpce(s)         Verify pce shares sum to one,
  eta0(s)           Reconciled income elasticities of demand matched to sage sectors
  theta0(r,g)	    Average budget share,
  incomeindex(r,h)  Household income index,
  theta(r,g,h)	    Target value share;


* read in cex based income elasticities (estimated at the national level)
$call 'csv2gdx %data_dir%%sep%cex%sep%national_income_elasticities_CEX_2013_2017.csv output=%gdxdir%national_income_elasticities_CEX_2013_2017.gdx id=regres index=1 useHeader=y value=2,3,4';
$gdxin '%gdxdir%national_income_elasticities_CEX_2013_2017.gdx'
$load regres

eta_(cex) = regres(cex,'elast');

* read in constructed bridge file between cex and sage sectors (based on pce)
$call 'csv2gdx %data_dir%%sep%cex%sep%windc_pce_map.csv output=%gdxdir%windc_pce_map.gdx id=pcebridge index=1,2 useHeader=y value=3,4,5';
$gdxin '%gdxdir%windc_pce_map.gdx'
$load pcebridge

pceshr(cex,s) = pcebridge(cex,s,'pct_windc') / 100;
chkpce(s) = sum(cex, pceshr(cex,s));

* aggregate the elasticity estiamtes to sage sectors as weighted averages using
* expenditures in the pce
eta0(s)$sum(r,cd0(r,s)) = sum(cex$pceshr(cex,s), pceshr(cex,s)*sum(r, cd0(r,s))*eta_(cex)) / sum(r,cd0(r,s));

theta0(r,g)      = cd0(r,g)/sum(g.local,cd0(r,g));
incomeindex(r,h) = (cons.l(r,h)/pop(r,h)) * 
	           sum((r.local,h.local),pop(r,h))/sum((r.local,h.local),cons.l(r,h));

* impute consumption shares using income elasticities of demand
theta(r,g,h) = theta0(r,g) * incomeindex(r,h)**eta0(g);
theta(r,g,h) = theta(r,g,h) / sum(g.local, theta(r,g,h));

nonnegative
variable
    CD(r,g,h)	Consumer demand;

equations
    objcd       Objective function,
    market      Market clearance,
    budget      Budget balance;


* objective function
objcd..		OBJ =e= sum((r,g,h), sqr(CD(r,g,h)-theta(r,g,h)*CONS.L(r,h)) )
			- sum((r,g,h)$theta(r,g,h), LOG(CD(r,g,h)));

* market clearance
market(r,g)..	sum(h, CD(r,g,h)) =e= cd0(r,g);

* income balance
budget(r,h)$(ord(h)<card(h))..	sum(g, CD(r,g,h)) =e= CONS.L(r,h);

model calib_step3_%hhdata% /objcd, market, budget/;

CD.L(r,g,h) = theta(r,g,h)*CONS.L(r,h);
CD.LO(r,g,h)$theta(r,g,h) = 1e-5;
CD.FX(r,g,h)$(not theta(r,g,h)) = 0;

* use savepoint to solve subsequent models


calib_step3_%hhdata%.savepoint = 1;
$if exist '%gdxdir%calib_step3_%hhdata%_p.gdx' execute_loadpoint '%gdxdir%calib_step3_%hhdata%_p.gdx';

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step3_%hhdata% using nlp minimizing OBJ;';

option nlp=ipopt;

solve calib_step3_%hhdata% using nlp minimizing OBJ;

if (calib_step3_%hhdata%.modelstat > 3,
	option nlp=conopt;
	solve calib_step3_%hhdata% using nlp minimizing OBJ;
);

ABORT$(calib_step3_%hhdata%.modelstat > 2) "Model calib_step3_%hhdata% has status > 2.";

execute 'mv -f calib_step3_%hhdata%_p.gdx %gdxdir%calib_step3_%hhdata%_p.gdx';

parameter
    exprep	Check that all expenditures shared,
    expbyinc	Report expenditure shares by income,
    avgshr      Average shares for us;


exprep(g,r,h)$cd0(r,g) = CD.L(r,g,h) / cd0(r,g);
exprep(g,"us",h)$sum(r, cd0(r,g)) = sum(r, CD.L(r,g,h)) / sum(r, cd0(r,g));
exprep(g,r,"all")$cd0(r,g) = sum(h, CD.L(r,g,h)) / cd0(r,g);
exprep(g,"us","all")$sum(r, cd0(r,g)) = sum((r,h), CD.L(r,g,h)) / sum(r, cd0(r,g));

expbyinc(g,r,h)$cd0(r,g) = CD.L(r,g,h) / sum(g.local, CD.L(r,g,h));
expbyinc(g,'us',h)$sum(r, cd0(r,g)) = sum(r, CD.L(r,g,h)) / sum((r,g.local), CD.L(r,g,h));

avgshr(g,h) = expbyinc(g,'us',h);
avgshr(g,'all') = sum((r,h), CD.L(r,g,h)) / sum((r,g.local,h), CD.L(r,g,h));
display exprep, expbyinc, avgshr, eta0;

* -----------------------------------------------------------------------------
* Output household dataset
* -----------------------------------------------------------------------------

parameter
    le0(r,rr,h)		Household labor endowment,
    ke0(r,h)		Household interest payments,
    tl0(r,h)		Household direct labor tax rate
    cd0_h(r,g,h)	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    taxrevL(r)		Labor tax revenue
    taxrevK		Capital tax revenue
    totsav0		Aggregate savings,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,*)	Disaggregate household transfer payments;

cd0_h(r,g,h) = CD.L(r,g,h);
c0_h(r,h) = CONS.L(r,h);
le0(r,rr,h) = WAGES.L(r,rr,h);
ke0(r,h) = INTEREST.L(r,h);
tl0(r,h) = TAXES.L(r,h) / sum(rr, le0(r,rr,h));
sav0(r,h) = SAVE.L(r,h);
trn0(r,h) = TRANS.L(r,h);
$if %hhdata%=="soi" hhtrn0(r,h,trn) = trn0(r,h);
$if %hhdata%=="cps" hhtrn0(r,h,trn) = TRANSHH.L(r,h,trn);

* output resulting data parameters
execute_unload "%gdxdir%calibrated_hhdata_%hhdata%_%invest%_%year%.gdx"
    h, trn, cd0_h, c0_h, le0, ke0, tl0, sav0, trn0, hhtrn0, pop;

* save the capital tax rate separately for use in dynamic_calib
execute_unload "%gdxdir%capital_taxrate_%year%.gdx" tk0;
