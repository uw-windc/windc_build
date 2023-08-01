$title Read the household data and recalibrate WiNDC household accounts

* CHANGES MADE IN THIS VERSION--

* - new version of balancing routine doesn't solve aggregates. fix transfers
* (what is known), let labor and capital shares minimize difference, and then
* let savings be the degree of freedom. tax rates are fixed.

* - replace markups with those calculated when compared to nipa tables
* where applicable.

* - for now, calibration routine solves for foreign savings. depends on static
* vs. dynamic calibration. foreign savings is dependent on assumptions made
* about capital income. in the corrent version of the dataset, we assume that
* the current capital stock is owned entirely by domestic investors.

* like before, restrict labor demand to people living within an aggregate census
* division.


* -----------------------------------------------------------------------------

* Three step balancing routine:
*    - if dynamic, solve for equilibrium investment demand
*    - solve income routine at the state level
*    - solve expenditure routine at the state level
*
* This version of the code employs pooled national markets for savings
* and capital income.  Assume equalization of rates of return across all
* capital income.  Assume that the geography of savings is independent of 
* the geography of investment.
*
* The CPS does not have capital gains data in the household file. We use data
* from SOI approximately.
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


* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* set year of interest
$if not set year $set year 2017

* set underlying dataset for recalibration
$if not set hhdata $set hhdata cps

* switch for invest calibration (static vs. dynamic)
$if not set invest $set invest static

* allow end of line comments
$eolcom !

* file separator
$set sep %system.dirsep%

* core data directory
$if not set core $set core ..%sep%core%sep%

* GDX directory
$set gdxdir gdx%sep%
$if not dexist gdx $call mkdir gdx

* let gams drive command promp title
$if not set puttitle $set puttitle yes
file kutl; kutl.lw=0;


* -----------------------------------------------------------------------------
* Read in base WiNDC data
* -----------------------------------------------------------------------------

* Read WiNDC base dataset

$set ds '%core%WiNDCdatabase.gdx'
$include '%core%windc_coredata.gms'
alias (r,q,rr), (s,g);

* Write basic report on regional determinants of income in base windc data

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
* Read in capital income tax rates from SAGE model
* -----------------------------------------------------------------------------

parameter
    tk0(r)     Capital tax rate;

$gdxin '%gdxdir%capital_tax_rates.gdx'
$loaddc tk0
$gdxin

* convert gross capital payments to net
kd0_(yr,r,s) = kd0_(yr,r,s) / (1+tk0(r));
kd0(r,s) = kd0_("%year%",r,s);


* -----------------------------------------------------------------------------
* Read in household data
* -----------------------------------------------------------------------------

* define dimensions of the reconciled income shares. note that CPS has data on
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
    taxrate0(r,h)	Assumed tax rate on labor income,
    capgain0_(yr,r,h)	Mapped capital gains from SOI;


* turn off domain checking when reading in household data because it is
* available for more recent years than core windc accounts
$gdxin '%gdxdir%%hhdata%_data.gdx'
$loaddc h
alias(h,hh);
$if %hhdata%=="cps" $loaddc trn
$if %hhdata%=="cps" $load wages0_ interest0_ taxes0_ trans0_ save0_ pop0_ pccons0_ hhtrans0_
$if %hhdata%=="soi" $load wages0_ interest0_ taxes0_ trans0_ save0_ pop0_=nr0_ pccons0_

* require total cash payments from CPS to hold in SOI data
$if %hhdata%=="soi" $gdxin '%gdxdir%cps_data.gdx'
$if %hhdata%=="soi" $load cpstrn0_=trans0_
$if %hhdata%=="soi" trn('total') = yes;
$if %hhdata%=="soi" trans0_(yr,r,h) = cpstrn0_(yr,r,h);
$if %hhdata%=="soi" hhtrans0_(yr,r,h,trn) = trans0_(yr,r,h);

* read in capital gains data from SOI if calibrating to CPS
$if %hhdata%=="cps" $gdxin '%gdxdir%soi_capital_gains.gdx'
$if %hhdata%=="cps" $load capgain0_
$if %hhdata%=="soi" capgain0_(yr,r,h) = 0;

* extrapolate size of capital gains based on income shares
parameter
    cg_income_share(r,h)	Share of capital income attributable to capital gains;

cg_income_share(r,h)$sum(yr, capgain0_(yr,r,h)) =
    sum(yr, capgain0_(yr,r,h)) / sum(yr$capgain0_(yr,r,h), interest0_(yr,r,h) + capgain0_(yr,r,h));

$if %hhdata%=="cps" interest0_(yr,r,h) = interest0_(yr,r,h)/(1-cg_income_share(r,h));

* note that the CPS doesn't include tax payments at the household level. we use
* Alex Marten's taxsim code to genrate both average and marginal rates. average
* rates are used to calibrate the accounts. marginal rates enter the model only.

$if %hhdata%=="cps" $gdxin '%gdxdir%labor_tax_rates.gdx'
$if %hhdata%=="cps" $loaddc taxrate0
$if %hhdata%=="cps" taxrate0_(yr,r,h) = taxrate0(r,h);
$if %hhdata%=="cps" taxes0_(yr,r,h) = taxrate0_(yr,r,h) * wages0_(yr,r,h);
$if %hhdata%=="soi" taxrate0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) / (wages0_(yr,r,h) + interest0_(yr,r,h));

* for SOI data, adjust income tax rates to net out imposed capital tax rate
parameter
    corporate_rate /.186 /;

$if %hhdata%=="soi"  taxes0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) - sum((rr,s), (tk0(rr) - corporate_rate)*kd0_(yr,rr,s)) * interest0_(yr,r,h) / sum((r.local, h.local), interest0_(yr,r,h));
$if %hhdata%=="soi"  taxrate0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) / wages0_(yr,r,h);

* compute reference consumption
cons0_(yr,r,h) = wages0_(yr,r,h) + interest0_(yr,r,h) + trans0_(yr,r,h) - taxes0_(yr,r,h) - save0_(yr,r,h) + eps;


* -----------------------------------------------------------------------------
* Pull out needed year of data
* -----------------------------------------------------------------------------

parameters
    wages0(r,h)		Wage income by region and household (in billions),
    interest0(r,h)	Interest income by region and household (in billions),
    taxes0(r,h)		Personal income taxes by region and household (in billions),
    taxrate0(r,h)	Assumed tax rate on labor income,
    trans0(r,h)		Transfers from government (in billions),
    hhtrans0(r,h,*)	Disaggregate household transfers (in billions),
    save0(r,h)		Retirement contributions (in billions),
    cons0(r,h)		Imputed consumption (in billions),
    pop0(r,h)		Number of households (in millions),
    hhshares		Reference income shares from household data,
    comp		Comparison of wages between %hhdata% and WiNDC;

wages0(r,h) = wages0_("%year%",r,h);
interest0(r,h) = interest0_("%year%",r,h);
taxes0(r,h) = taxes0_("%year%",r,h);
taxrate0(r,h) = taxrate0_("%year%",r,h);
trans0(r,h) = trans0_("%year%",r,h);
hhtrans0(r,h,trn) = hhtrans0_("%year%",r,h,trn);
save0(r,h) = save0_("%year%",r,h);
cons0(r,h) = cons0_("%year%",r,h);
pop0(r,h) = pop0_("%year%",r,h);

* also, report reference income and expenditure shares;

hhshares("income","total",h) = sum(r, wages0(r,h) + interest0(r,h) + trans0(r,h));
hhshares("income","wage",h) = sum(r, wages0(r,h)) / hhshares("income","total",h);
hhshares("income","interest",h) = sum(r, interest0(r,h)) / hhshares("income","total",h);
hhshares("income","transfers",h) = sum(r, trans0(r,h)) / hhshares("income","total",h);

hhshares("expend","total",h) = sum(r, cons0(r,h) + taxes0(r,h) + save0(r,h));
hhshares("expend","cons",h) = sum(r, cons0(r,h)) / hhshares("expend","total",h);
hhshares("expend","taxes",h) = sum(r, taxes0(r,h)) / hhshares("expend","total",h);
hhshares("expend","save",h) = sum(r, save0(r,h)) / hhshares("expend","total",h);

comp(r,'wages0') = sum(h, wages0(r,h));
comp("us",'wages0') = sum((h,r), wages0(r,h));
comp(r,'ld0') = sum(s, ld0(r,s));
comp('us','ld0') = sum((s,r), ld0(r,s));
comp(r,'pct') = 100 * (comp(r,'wages0') / comp(r,'ld0') - 1);
comp('us','pct') = 100 * (comp('us','wages0') / comp('us','ld0') - 1);
display hhshares, comp;

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
* Read in known reporting relationships between CPS and NIPA for transfers
* -----------------------------------------------------------------------------

parameter
    cps_nipa(yr,*)	Comparison of CPS and NIPA income categories,
    trn_weight_(yr,*,*)	Source based transfer category survey markup to match nipa totals,
    trn_weight(yr,*)	Chosen transfer survey markup,
    trn_agg_weight(yr)	Aggregate transfer markup for soi data;

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

* for income categories that can compare directly with nipa tables, use
* that. the transfer "weight" will turn into a time series. otherwise use static
* meyers/rothbaum estimates.

$call 'csv2gdx data_sources%sep%cps%sep%cps_vs_nipa_income_categories.csv output=%gdxdir%cps_vs_nipa_income_categories.gdx id=cps_nipa index=(1,5) useHeader=y value=4';
$gdxin %gdxdir%cps_vs_nipa_income_categories.gdx
$load cps_nipa
$gdxin

* When it exists, use explicit comparison to nipa tables (and comapre with older
* literature estimates)

$if %hhdata%=="cps" trn_weight_(yr,'hucval','meyer') = 1 / 0.679;
$if %hhdata%=="cps" trn_weight_(yr,'hucval','nipa')$(cps_nipa(yr,'government benefits: unemployment insurance')) = 1 / (cps_nipa(yr,'government benefits: unemployment insurance')/100 + 1);
$if %hhdata%=="cps" trn_weight_(yr,'hucval','nipa')$(not cps_nipa(yr,'government benefits: unemployment insurance')) = trn_weight_(yr,'hucval','meyer');

$if %hhdata%=="cps" trn_weight_(yr,'hssval','rothbaum') = 1 / 0.899;
$if %hhdata%=="cps" trn_weight_(yr,'hssval','nipa')$(cps_nipa(yr,'government benefits: social security')) = 1 / (cps_nipa(yr,'government benefits: social security')/100 + 1);
$if %hhdata%=="cps" trn_weight_(yr,'hssval','nipa')$(not cps_nipa(yr,'government benefits: social security')) = trn_weight_(yr,'hssval','rothbaum');

$if %hhdata%=="cps" trn_weight_(yr,'hssival','meyer') = 1 / 0.759;
$if %hhdata%=="cps" trn_weight_(yr,'hssival','nipa')$(cps_nipa(yr,'government benefits: social security')) = 1 / (cps_nipa(yr,'government benefits: social security')/100 + 1);
$if %hhdata%=="cps" trn_weight_(yr,'hssival','nipa')$(not cps_nipa(yr,'government benefits: social security')) = trn_weight_(yr,'hssival','meyer');

$if %hhdata%=="cps" trn_weight_(yr,'hdisval','meyer') = 1 / 0.819;
$if %hhdata%=="cps" trn_weight_(yr,'hdisval','nipa')$(cps_nipa(yr,'government benefits: social security')) = 1 / (cps_nipa(yr,'government benefits: social security')/100 + 1);
$if %hhdata%=="cps" trn_weight_(yr,'hdisval','nipa')$(not cps_nipa(yr,'government benefits: social security')) = trn_weight_(yr,'hdisval','meyer');

$if %hhdata%=="cps" trn_weight_(yr,'hvetval','rothbaum') = 1 / 0.679;
$if %hhdata%=="cps" trn_weight_(yr,'hvetrval','nipa')$(cps_nipa(yr,"government benefits: veterans' benefits")) = 1 / (cps_nipa(yr,"government benefits: veterans' benefits")/100 + 1);
$if %hhdata%=="cps" trn_weight_(yr,'hvetrval','nipa')$(not cps_nipa(yr,"government benefits: veterans' benefits")) = trn_weight_(yr,'hvetrval','rothbaum');

* Otherwise, default to literature estimates

$if %hhdata%=="cps" trn_weight_(yr,'hwcval','meyer') = 1 / 0.527;
$if %hhdata%=="cps" trn_weight_(yr,'hpawval','meyer') = 1 / 0.487;
$if %hhdata%=="cps" trn_weight_(yr,'hsurval','meyer') = 1 / 0.908;
$if %hhdata%=="cps" trn_weight_(yr,'hedval','rothbaum') = 1 / 0.804;
$if %hhdata%=="cps" trn_weight_(yr,'hcspval','rothbaum') = 1 / 0.804;
$if %hhdata%=="cps" trn_weight_(yr,'hfinval','meyer') = 1 / 0.539;

* Pick sources of mark up to use in balancing

$if %hhdata%=="cps" trn_weight(yr,trn)$(trn_weight_(yr,trn,'nipa')) = trn_weight_(yr,trn,'nipa');
$if %hhdata%=="cps" trn_weight(yr,trn)$(not trn_weight(yr,trn) and trn_weight_(yr,trn,'meyer')) = trn_weight_(yr,trn,'meyer');
$if %hhdata%=="cps" trn_weight(yr,trn)$(not trn_weight(yr,trn) and trn_weight_(yr,trn,'rothbaum')) = trn_weight_(yr,trn,'rothbaum');

* Define aggregate transfer mark up

$if %hhdata%=="cps" trn_agg_weight(yr) = sum((trn,r,h), trn_weight(yr,trn)*hhtrans0(r,h,trn)) / sum((r,h,trn),hhtrans0(r,h,trn));
$if %hhdata%=="soi" trn_weight(yr,'total') = 1 / 0.804; 
$if %hhdata%=="soi" trn_agg_weight(yr) = 1 / 0.804; 


* -----------------------------------------------------------------------------
* Read in fringe benefit share from NIPA tables
* -----------------------------------------------------------------------------

* Assign a standard markup to fringe benefits based on national averages from
* NIPA table -- bls data shows markup pretty consistent across regions.

parameter
    fringe_markup(yr)	Fringe benefit markup;

$call 'csv2gdx data_sources%sep%cps%sep%nipa_fringe_benefit_markup.csv output=%gdxdir%nipa_fringe_benefit_markup.gdx id=fringe_markup index=(1) useHeader=y value=2';
$gdxin %gdxdir%nipa_fringe_benefit_markup.gdx
$load fringe_markup
$gdxin


* -----------------------------------------------------------------------------
* Balancing routine step 0: partial dynamic calibration (change investment for
* household recalibration if invest=dynamic switch activated)
* -----------------------------------------------------------------------------

* Assumed invest=dynamic parameters

parameter
	gr		Growth rate /0.02/,
	ir		Interest rate /0.04/,
	delta(r,s)	Assumed sectoral depreciation rate;

delta(r,s) = 0.07;

variables
    OBJI		Objective value for investment;

nonnegative
variables
    INV(r,g)		Steady state investment;

equations
    investment(r)	Steady state investment,
    objinv		Objective function;

objinv..
    OBJI =e= sum((r,g)$i0(r,g), i0(r,g) * sqr(INV(r,g) / i0(r,g) - 1));

investment(r)..
    sum(g, INV(r,g)) =e= sum(s, (gr+delta(r,s)) * kd0(r,s)/(ir+delta(r,s)));

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
* Income side balancing routine
* -----------------------------------------------------------------------------

* Read in mapping of census divisions to restrict wage payments

$include 'maps%sep%hh_calib_aggregate_divisions.map'
alias(ar,aar),(mapr,maprr);

* Construct income shares and other parameters for targetting in balancing
* routine

parameter
    household_shares(r,h,*)	Household shares of income,
    savings_rate0(r,h)		Reference savings rate from hh data,
    le0_multiplier(r)		Labor income difference between home and work destination,
    dist0(r,rr)			Distance between states (100s of km),
    commute0(r,rr)		Approximate value of commuting flows from ACS-CPS;

household_shares(r,h,'wages') = wages0(r,h) / sum(h.local, wages0(r,h));
household_shares(r,h,'cap') = interest0(r,h) / sum(h.local, interest0(r,h));
savings_rate0(r,h) = save0(r,h) / (save0(r,h) + cons0(r,h));

* Define a multiplier that characterizes the ratio of income received from labor
* compensation to sectoral labor payments. If the number is <1, we can interpret
* as relatively more commuters coming into the state to work. If >1, commuters
* leave the state to work. DC is a good example of the former case.

le0_multiplier(r) = sum(hh, fringe_markup('%year%') * wages0(r,hh))/sum(s,ld0(r,s));

* Read in bilateral state distances

$call 'csv2gdx data_sources%sep%state_distances.csv output=%gdxdir%state_distances.gdx id=dist0 index=(1,2) useHeader=y value=3';
$gdxin %gdxdir%state_distances.gdx
$load dist0
$gdxin

$call 'csv2gdx data_sources%sep%acs%sep%acs_commuting_data.csv output=%gdxdir%acs_commuting_data.gdx id=commute0 index=(1,2) useHeader=y value=3';
$gdxin %gdxdir%acs_commuting_data.gdx
$load commute0
$gdxin

* scale to billions of dollars
commute0(r,rr) = commute0(r,rr) * 1e-9;

* remove within state commutes
commute0(r,r) = 0;

* Define variables and equations of balancing routine

variable
    TAXES(r,h)		Direct labor tax payments,
    OBJ			Objective definition;

nonnegative
variable
    TRANS(r,h)		Transfer payments,
    TRANSHH(r,h,*)	Disaggregate Transfer payments,
    CONS(r,h)		Consumption expenditure
    WAGES(r,r,h)	Aggregate wage income (living in r and working in rr),
    INTEREST(r,h)	Aggregate interest income,
    SAVE(r,h)		Savings,
    SAVE_RATE(r,h)	Savings rate (relative to consumption),
    FSAV            	Foreign savings in United States;

equations
    objdef		Objective function,
    taxdef		Tax constraint,
    consdef		Consumption constraint,
    wagedef		Cross state labor income constraint,
    censusdef		Restriction on wage payments,
    interestdef		Capital income constraint,
    savedef		Savings constraint,
    saveratedef		Definition of savings rate,
    incbal		Income balance closure,
    disagtrn		Disaggregate transfer payment;

* objective definition -- target shares for labor and capital income and totals
* for transfers and savings. fix transfers, minimize difference in labor and
* capital, and let savings be the degree of freedom. also penalize distance
* traveled to work (largely ends up handling dc).

objdef..
    OBJ =e= sum((r,h),
	abs(household_shares(r,h,'wages')*sum(s,ld0(r,s)))*
		sqr(sum(rr, WAGES(r,rr,h))/(household_shares(r,h,'wages')*le0_multiplier(r)*sum(s,ld0(r,s))) - 1) +
	abs(household_shares(r,h,'cap')*sum(s,kd0(r,s)))*
		sqr(INTEREST(r,h)/(household_shares(r,h,'cap')*sum(s,kd0(r,s))) - 1)) +
    	sum((r,rr)$commute0(r,rr), sqr(sum(h, WAGES(r,rr,h))/commute0(r,rr)));

* fix the income tax rate from the household data
taxdef(r,h)..
    TAXES(r,h) =e= taxrate0(r,h) * sum(rr, WAGES(r,rr,h));

* aggregation definition on total household consumption
consdef(r)..
    sum(h, CONS(r,h)) =e= c0(r);

* wage income must sum to total labor demands by region
wagedef(rr)..
    sum((r,h), WAGES(r,rr,h)) =e= sum(s, ld0(rr,s));

* restrict commute pairings to within census divisions
censusdef(ar,aar,h)$(not sameas(ar,aar))..
    sum((mapr(ar,r),maprr(aar,rr)), WAGES(r,rr,h)) =e= 0;

* capital rents must sum to total capital demands by region
interestdef..
    sum((r,h), INTEREST(r,h)) =e= sum((r,s), kd0(r,s) + yh0(r,s));

* ignore enterprise and government saving:
savedef..
    sum((r,h), SAVE(r,h)) + FSAV =e= sum((r,g), i0(r,g));

* define savings rate
saveratedef(r,h)..
    SAVE_RATE(r,h) * (CONS(r,h)+SAVE(r,h)) =e= SAVE(r,h);

* let transfer payments and taxes adjust to satisfy budget balance assumptions
incbal(r,h)..
    TRANS(r,h) + sum(rr, WAGES(r,rr,h)) + INTEREST(r,h) =e= CONS(r,h) + SAVE(r,h) + TAXES(r,h);

* disaggregate transfer payments
disagtrn(r,h)..
    sum(trn, TRANSHH(r,h,trn)) =e= TRANS(r,h);

model calib_step2_%hhdata% / objdef, taxdef, consdef, wagedef, censusdef,
			     interestdef, savedef, saveratedef, incbal, disagtrn /;

* Fix ABSOLUTE government transfers (we have good data on this)

TRANSHH.FX(r,h,trn) = trn_weight("%year%",trn) * hhtrans0(r,h,trn);
TRANS.L(r,h) = trans0(r,h);

* Require a lower bound on aggregate consumption to prevent zero values from occurring

CONS.L(r,h) = cons0(r,h);
CONS.LO(r,h) = 0.5 * cons0(r,h);

* Target income SHARES for wages and capital earnings (both categories having
* missing information so we target the distribution based on WiNDC
* totals). restrictions of interstate commuting handled through the objective
* function.

WAGES.L(r,r,h) = household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
WAGES.LO(r,r,h) = 0.75 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
WAGES.UP(r,r,h) = 1.25 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
* WAGES.UP(r,rr,h)$commute0(r,rr) = 2 * commute0(r,rr);
WAGES.FX(r,rr,h)$(commute0(r,rr)=0 and not sameas(r,rr)) = 0;

INTEREST.L(r,h) = household_shares(r,h,'cap') * sum(s, kd0(r,s));
INTEREST.LO(r,h) = 0.75 * household_shares(r,h,'cap') * sum(s, kd0(r,s));
INTEREST.UP(r,h) = 1.25 * household_shares(r,h,'cap') * sum(s, kd0(r,s));

* Assume any interest income adjustments that need to be made outside of bounds
* above accrue to upper income group

INTEREST.UP(r,h)$(ord(h)=card(h)) = inf;

* Make sure savings are at least retirement distributions from household data

SAVE.L(r,h) = save0(r,h);
SAVE.LO(r,h) = 0.5 * save0(r,h);

* Constrain savings rate letting any additional savings needed to close the
* budget constraint accrues to the upper income group

SAVE_RATE.L(r,h) = savings_rate0(r,h);
SAVE_RATE.UP(r,h) = 2 * savings_rate0(r,h);
SAVE_RATE.UP(r,h)$(ord(h)=card(h)) = inf;

* Taxes are constrained by a fixed tax rate in the balancing routine

TAXES.L(r,h) = taxes0(r,h);

* Solve the income side balancing routine

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step2_%hhdata% using nlp minimizing OBJ;';
option nlp=conopt;
solve calib_step2_%hhdata% using nlp minimizing OBJ;
abort$(calib_step2_%hhdata%.modelstat > 2) "Model calib_step2_%hhdata% has status > 2.";

* Construct reports on calibrated household accounts

parameter
    cbochk    Check on CBO result for transfers less taxes,
    chkhhdata Aggregate shares for calibrated dataset,
    increp    Income report,
    cons_save Report on consumption vs savings,
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

cons_save(r,h,'cons') = CONS.L(r,h);
cons_save(r,h,'save') = SAVE.L(r,h);
cons_save(r,h,'savings_rate') = SAVE.L(r,h) / (CONS.L(r,h)+SAVE.L(r,h));
cons_save('tot','tot','savings_rate') = sum((r,h), SAVE.L(r,h)) / sum((r,h), CONS.L(r,h)+SAVE.L(r,h));

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
display cbochk, chkhhdata, hhshares, increp, boundshr, chkwages, FSAV.L, cons_save;

* execute_unload '%hhdata%_income_ranges.gdx' boundshr;
* execute 'gdxxrw %hhdata%_income_ranges.gdx par=boundshr rng=%hhdata%!A2 cdim=0';

parameter
    avg_tax_h, avg_tax_r, avg_tax    Reports on average tax rates;

avg_tax_h(h) = sum(r, TAXES.L(r,h)) / sum(r, sum(rr, WAGES.L(r,rr,h)));
avg_tax_r(r) = sum(h, TAXES.L(r,h)) / sum(h, sum(rr, WAGES.L(r,rr,h)));
avg_tax = sum((r,h), TAXES.L(r,h)) / sum((r,h), sum(rr, WAGES.L(r,rr,h)));
display avg_tax_h, avg_tax, WAGES.L;
$exit

* -----------------------------------------------------------------------------
* Expenditure side balancing routine
* -----------------------------------------------------------------------------

* Income elasticities taken from SAGE documentation where categories are based
* on the Consumer Expenditure Survey from BLS.

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
$call 'csv2gdx data_sources%sep%cex%sep%national_income_elasticities_CEX_2013_2017.csv output=%gdxdir%national_income_elasticities_CEX_2013_2017.gdx id=regres index=1 useHeader=y value=2,3,4';
$gdxin '%gdxdir%national_income_elasticities_CEX_2013_2017.gdx'
$load regres

eta_(cex) = regres(cex,'elast');

* read in constructed bridge file between cex and sage sectors (based on pce)
$call 'csv2gdx data_sources%sep%cex%sep%windc_pce_map.csv output=%gdxdir%windc_pce_map.gdx id=pcebridge index=1,2 useHeader=y value=3,4,5';
$gdxin '%gdxdir%windc_pce_map.gdx'
$load pcebridge

pceshr(cex,s) = pcebridge(cex,s,'pct_windc') / 100;
chkpce(s) = sum(cex, pceshr(cex,s));

* Aggregate the elasticity estiamtes to sage sectors as weighted averages using
* expenditures in the pce

eta0(s)$sum(r,cd0(r,s)) = sum(cex$pceshr(cex,s), pceshr(cex,s)*sum(r, cd0(r,s))*eta_(cex)) / sum(r,cd0(r,s));

theta0(r,g)      = cd0(r,g)/sum(g.local,cd0(r,g));
incomeindex(r,h) = (cons.l(r,h)/pop0(r,h)) * 
	           sum((r.local,h.local),pop0(r,h))/sum((r.local,h.local),cons.l(r,h));

* Impute consumption shares using income elasticities of demand

theta(r,g,h) = theta0(r,g) * incomeindex(r,h)**eta0(g);
theta(r,g,h) = theta(r,g,h) / sum(g.local, theta(r,g,h));

nonnegative
variable
    CD(r,g,h)	Consumer demand;

equations
    objcd       Objective function,
    market      Market clearance,
    budget      Budget balance;


* Objective function
objcd..
    OBJ =e= sum((r,g,h), sqr(CD(r,g,h)-theta(r,g,h)*CONS.L(r,h)) )
    		- sum((r,g,h)$theta(r,g,h), LOG(CD(r,g,h)));

* Market clearance
market(r,g)..
    sum(h, CD(r,g,h)) =e= cd0(r,g);

* income balance
budget(r,h)$(ord(h)<card(h))..
    sum(g, CD(r,g,h)) =e= CONS.L(r,h);

model calib_step3_%hhdata% /objcd, market, budget/;

CD.L(r,g,h) = theta(r,g,h)*CONS.L(r,h);
CD.LO(r,g,h)$theta(r,g,h) = 1e-5;
CD.FX(r,g,h)$(not theta(r,g,h)) = 0;

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step3_%hhdata% using nlp minimizing OBJ;';
option nlp=ipopt;
solve calib_step3_%hhdata% using nlp minimizing OBJ;
abort$(calib_step3_%hhdata%.modelstat > 2) "Model calib_step3_%hhdata% has status > 2.";

* Construct reports on expenditure side balancing routine

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
    h, trn, cd0_h, c0_h, le0, ke0, tl0, sav0, trn0, hhtrn0, pop0;

* save the capital tax rate separately for use in dynamic_calib
execute_unload "%gdxdir%capital_taxrate_%year%.gdx" tk0;


* -----------------------------------------------------------------------------
* End
* -----------------------------------------------------------------------------
