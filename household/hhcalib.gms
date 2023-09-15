$title Read the household data and recalibrate WiNDC household accounts

* Three step balancing routine:
*    - if dynamic, solve for equilibrium investment demand
*    - solve income routine at the state level
*    - solve expenditure routine at the state level
*
* This version of the code employs pooled national markets for savings
* and capital income.  Assume equalization of rates of return across all
* capital income.  Assume that the geography of savings is independent of 
* the geography for investment demands.
*
* Income upperbounds by quintile (CPS) -- can modify:
* (25000, 50000, 75000, 150000, Inf)
*
* Income bins in SOI matched approximately
* (25000, 50000, 75000, 200000, Inf)
*
* This version of the code allows for sensitivity analysis surrounding domestic
* vs. foreign capital ownership. The basic justification for this is a
* discrepancy between total capital rents in the input output table relative to
* capital income in the NIPA tables. We allow a dataset to be constructed in two
* ways: assume all capital payments from the domestic economy are owned
* domestically (all); or assume partial ownership based on a comparison of NIPA
* totals and IO totals (partial). In the case of partial ownership, we also
* assume that foreign savings contributes to domestic investment
* demand. Therefore, the matrix balancing routine calculates endogneous foreign
* savings and capital ownership based on these assumptions. In the case where
* all capital is assumed to be owned domestically, we also assume that total
* investment demand can be covered by domestic savings, only. Savings rates are
* assumed to mimic distribution of capital rents.
*
* Assume that fringe benefits (difference between total employee compensation
* and wages/salaries) are shared equivalently as wages and salaries. Futhermore,
* we impose commuting patterns from the American Community Survey to allow
* households labor income earners to live and work in different states (e.g.,
* VA-MD-DC).

* Employee compensation is pinned directly to NIPA totals.

* For most transfer income, we rely on CPS data and impose markups where the
* literature has determined under-reporting by comparing survey and
* administrative data. For health benefits, we estimate benefits by region by
* household by combining data state level medicare and medicaid payments with
* American Community Survey data on distribution of public insurance holders by
* region and income group.

* Remove use of capital gains -- reflects change in WEALTH, not production
* driven income. Not included in NIPA tables.


* -----------------------------------------------------------------------------
* Set options
* -----------------------------------------------------------------------------

* set year of interest
$if not set year $set year 2017

* set underlying dataset for recalibration
$if not set hhdata $set hhdata "cps"

* switch for invest calibration (static vs. dynamic)
$if not set invest $set invest "static"

* switch for assumption on domestic capital ownership (all vs. partial)
$if not set capital_ownership $set capital_ownership "all"

* allow end of line comments
$eolcom !

* core data directory
$if not set core $set core ../core/

* GDX directory
$set gdxdir gdx/
$if not dexist gdx $call mkdir gdx

* let gams drive command promp title
$if not set puttitle $set puttitle yes
file kutl; kutl.lw=0;


* -----------------------------------------------------------------------------
* Set steady state parameters
* -----------------------------------------------------------------------------

* set growth rate
$if not set gr $set gr 0.02

* set interest rate
$if not set ir $set ir 0.04

* set economy-wide depreciation rate
$if not set delta $set delta 0.05


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
baserep(r,'income') = sum(s, ld0(r,s) + kd0(r,s)) + hhadj0(r) + sum(g, yh0(r,g));
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
    tl_avg0_(yr,r,h)	Average tax rate on labor income,
    tl0_(yr,r,h)	Marginal tax rate on labor income,
    tfica0_(yr,r,h)	FICA tax rate on labor income,
    tl_avg0(r,h)	Average tax rate on labor income,
    tl0(r,h)		Marginal tax rate on labor income,
    tfica0(r,h)		FICA tax rate on labor income;

* Turn off domain checking when reading in household data because it is
* available for more recent years than core windc accounts

$gdxin '%gdxdir%%hhdata%_data.gdx'
$loaddc h
alias(h,hh);
$if %hhdata%=="cps" $loaddc trn
$if %hhdata%=="cps" $load wages0_ interest0_ taxes0_ trans0_ save0_ pop0_ pccons0_ hhtrans0_
$if %hhdata%=="soi" $load wages0_ interest0_ taxes0_ trans0_ save0_ pop0_=nr0_ pccons0_

* Require total transfer cash payments from CPS to hold in SOI data

$if %hhdata%=="soi" $gdxin '%gdxdir%cps_data.gdx'
$if %hhdata%=="soi" $load cpstrn0_=trans0_
$if %hhdata%=="soi" trn('total') = yes;
$if %hhdata%=="soi" trans0_(yr,r,h) = cpstrn0_(yr,r,h);
$if %hhdata%=="soi" hhtrans0_(yr,r,h,trn) = trans0_(yr,r,h);

* Note that the CPS doesn't include tax payments at the household level. we use
* Alex Marten's taxsim code to genrate both average and marginal rates. average
* rates are used to calibrate the accounts. marginal rates enter the model
* only. for soi, assume the average rate is inclusive of fica taxes.

$if %hhdata%=="cps" $gdxin '%gdxdir%labor_tax_rates_tl_avg.gdx'
$if %hhdata%=="cps" $loaddc tl_avg0
$if %hhdata%=="cps" $gdxin '%gdxdir%labor_tax_rates_tl.gdx'
$if %hhdata%=="cps" $loaddc tl0
$if %hhdata%=="cps" $gdxin '%gdxdir%labor_tax_rates_tfica.gdx'
$if %hhdata%=="cps" $loaddc tfica0
$if %hhdata%=="cps" tl_avg0_(yr,r,h) = tl_avg0(r,h);
$if %hhdata%=="cps" tl0_(yr,r,h) = tl0(r,h);
$if %hhdata%=="cps" tfica0_(yr,r,h) = tfica0(r,h);
$if %hhdata%=="cps" taxes0_(yr,r,h) = (tl_avg0_(yr,r,h)+tfica0_(yr,r,h)) * wages0_(yr,r,h);
$if %hhdata%=="soi" tl_avg0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) / (wages0_(yr,r,h) + interest0_(yr,r,h));
$if %hhdata%=="soi" $gdxin '%gdxdir%labor_tax_rates_tl.gdx'
$if %hhdata%=="soi" $loaddc tl0
$if %hhdata%=="soi" tl0_(yr,r,h) = tl0(r,h);
$if %hhdata%=="soi" tfica0_(yr,r,h) = 0;

* For SOI data, adjust income tax rates to net out imposed capital tax rate

parameter
    corporate_rate /.186 /;

$if %hhdata%=="soi"  taxes0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) - sum((rr,s), (tk0(rr) - corporate_rate)*kd0_(yr,rr,s)) * interest0_(yr,r,h) / sum((r.local, h.local), interest0_(yr,r,h));
$if %hhdata%=="soi"  tl_avg0_(yr,r,h)$taxes0_(yr,r,h) = taxes0_(yr,r,h) / wages0_(yr,r,h);

* Compute reference consumption based on known incomes and expenditures

cons0_(yr,r,h) = wages0_(yr,r,h) + interest0_(yr,r,h) + trans0_(yr,r,h) - taxes0_(yr,r,h) - save0_(yr,r,h) + eps;


* -----------------------------------------------------------------------------
* Pull out needed year of data
* -----------------------------------------------------------------------------

parameters
    wages0(r,h)		Wage income by region and household (in billions),
    interest0(r,h)	Interest income by region and household (in billions),
    taxes0(r,h)		Personal income taxes by region and household (in billions),
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
tl_avg0(r,h) = tl_avg0_("%year%",r,h);
tl0(r,h) = tl0_("%year%",r,h);
tfica0(r,h) = tfica0_("%year%",r,h);
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

$call 'csv2gdx ../data/household/cps/cps_vs_nipa_income_categories.csv output=%gdxdir%cps_vs_nipa_income_categories.gdx id=cps_nipa index=(1,5) useHeader=y value=4';
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

* Scale aggregate transfers to match NIPA table totals after adjusting for
* underreporting for individual categories -- add "other" category to capturing
* discrepancy between nipa totals and cps data.

hhtrans0(r,h,trn) = trn_weight('%year%',trn) * hhtrans0(r,h,trn);


* -----------------------------------------------------------------------------
* Add government health benefit transfer payments
* -----------------------------------------------------------------------------

* Missing transfers -- medicare and medicaid. Medicare and medicaid payments are
* included in personal consumer expenditures, and therefore requisite transfers
* are needed to augment incomes to satisfy payments. To capture, we have
* information on total medicare and medicaid spending by state from the Center
* for Mediare and Medicaid Serives in their Heath expenditures by state of
* residence, 1991-2020 dataset. Use this information with data from ACS on
* whether someone has public insurance in given income group and state as a way
* to share totals across household groups. Implicitly assumes per-capita
* benefits constant across type of beneficiary.

parameter
    health_care_transfers(r,*,*,*)	Medicaid and medicare transfers payments;

$set health_data_dir ../data/household/health_care/
$set file "%health_data_dir%public_health_benefits_2009_2019.csv"
$call 'csv2gdx "%file%" id=health_care_transfers useheader=yes index=(1,2,3) values=(4,5) output="%gdxdir%public_health_benefits.gdx"'
$gdxin '%gdxdir%public_health_benefits.gdx'
$load health_care_transfers

* Map data to needed years and households

sets
    hy			Years with healthcare data,
    maphy(hy,*)		Mapping to chosen year,
    hea_h		Household types in health data,
    maphh(hea_h,h)	Mapping household types;

$load hy=Dim2 hea_h=Dim3
$gdxin

* Imperfect mapping of household types

maphh('<25k',"hh1") = yes;
maphh('25-50k',"hh2") = yes;
maphh('50-75k',"hh3") = yes;
maphh('75-100k',"hh4") = yes;
maphh('>100k',"hh5") = yes;

maphy(hy,yr)$(hy.val = yr.val) = yes;
maphy(hy,yr)$(ord(hy)=1 and yr.val < hy.val) = yes;
maphy(hy,yr)$(ord(hy)=card(hy) and yr.val > hy.val) = yes;

$if %hhdata%=="cps" trn("medicare") = yes;
$if %hhdata%=="cps" trn("medicaid") = yes;
$if %hhdata%=="cps" hhtrans0(r,h,'medicare') = sum((maphy(hy,'%year%'),maphh(hea_h,h)), health_care_transfers(r,hy,hea_h,'medicare'));
$if %hhdata%=="cps" hhtrans0(r,h,'medicaid') = sum((maphy(hy,'%year%'),maphh(hea_h,h)), health_care_transfers(r,hy,hea_h,'medicaid'));

$if %hhdata%=="soi" hhtrans0(r,h,'total') = hhtrans0(r,h,'total') + sum((maphy(hy,'%year%'),maphh(hea_h,h)), health_care_transfers(r,hy,hea_h,'medicare') + health_care_transfers(r,hy,hea_h,'medicaid'));


* -----------------------------------------------------------------------------
* Balancing routine step 0: partial dynamic calibration (change investment for
* household recalibration if invest=dynamic switch activated)
* -----------------------------------------------------------------------------

* Assumed invest=dynamic parameters

parameter
	gr	Growth rate /%gr%/,
	ir	Interest rate /%ir%/,
	delta	Depreciation rate /%delta%/;

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
    sum(g, INV(r,g)) =e= sum(s, (gr+delta) * kd0(r,s)/(ir+delta));

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

* Output dynamic adjustment to investment.  This is subsequently imposed in dynamic_calib.gms

	i0(r,g) = INV.L(r,g);
	execute_unload "%gdxdir%i0_%year%.gdx" i0, gr, ir, delta;

	compi0(r,g,'ss') = i0(r,g);

$endif.dynamic


* -----------------------------------------------------------------------------
* Prepare additional parameter targets for income side balancing routine
* -----------------------------------------------------------------------------

* Construct income shares and other parameters for targetting in balancing
* routine

parameter
    household_shares(r,h,*)	Household shares of income,
    ret_dist0(r,h)		Reference retirement distributions from hh data,
    savings_rate_bea0		Reference economy-wide savings rate from bea /0.07/,
    savings_rate0(r,h)		Reference savings rate,
    economy_wide_sr0		Economy-wide savings rate,
    save_target			Flag for targetting bea savings rate (partially owned capital) /0/,
    fringe_markup		Fringe benefit markup,
    le0_multiplier(r)		Labor income difference between home and work destination,
    commute0(r,rr)		Approximate value of commuting flows from ACS-CPS,
    cap_own0_			Time series of capital ownership shares,
    cap_own0			Portion of capital stock owned domestically,
    adj_trans0(r,h)		Total adjusted transfer income,
    othinc0			Other non-government transfer income;

* Labor income shares defined by region:

household_shares(r,h,'wages') = wages0(r,h) / sum(h.local, wages0(r,h));

* Capital income shares defined across U.S. (capital market closed nationally)

household_shares(r,h,'cap') = interest0(r,h) / sum((r.local, h.local), interest0(r,h));

* Assume savings are distributed on the bases of capital ownership (not
* retirement distributions):

$if %capital_ownership%=="all" economy_wide_sr0 = sum((r,g), i0(r,g)) / (sum((r,g), i0(r,g) + cd0(r,g)));
$if %capital_ownership%=="partial" economy_wide_sr0 = savings_rate_bea0;

savings_rate0(r,h) = (economy_wide_sr0 / (sum((r.local,h.local), interest0(r,h)) / sum((r.local,h.local), (interest0(r,h) + cons0(r,h))))) * interest0(r,h) / (interest0(r,h) + cons0(r,h));
$if %capital_ownership%=="partial" save_target=1;
display savings_rate0;

* Reference retirement distributions:

ret_dist0(r,h) = save0(r,h) / sum(h.local, save0(r,h));
display ret_dist0, savings_rate0;

* Define a multiplier that characterizes the ratio of income received from labor
* compensation to sectoral labor payments. If the number is <1, we can interpret
* as relatively more commuters coming into the state to work. If >1, commuters
* leave the state to work. DC is a good example of the former case. First,
* adjust the fringe markup such that total wages = total labor demands.

fringe_markup = sum((r,s),ld0(r,s)) / sum((r,h), wages0(r,h));
le0_multiplier(r) = sum(hh, fringe_markup * wages0(r,hh))/sum(s,ld0(r,s));

* Read in bilateral commuting data

$call 'csv2gdx ../data/household/acs/acs_commuting_data.csv output=%gdxdir%acs_commuting_data.gdx id=commute0 index=(1,2) useHeader=y value=3';
$gdxin %gdxdir%acs_commuting_data.gdx
$load commute0
$gdxin

* Scale to billions of dollars, remove within state commutes, keep only big
* commutes (those worth over 1 billion)

commute0(r,rr) = commute0(r,rr) * 1e-9;
commute0(r,r) = 0;
commute0(r,rr)$(commute0(r,rr)<1) = 0;

* In instances where there is no commuting, reset le0_multiplier to 1

le0_multiplier(r)$(le0_multiplier(r)>1 and sum(rr,commute0(r,rr))=0) = 1;
le0_multiplier(r)$(le0_multiplier(r)<1 and sum(rr,commute0(rr,r))=0) = 1;

* Set assumption on capital ownership (partial ownership is based on NIPA totals)

$call 'csv2gdx ../data/household/cps/windc_vs_nipa_domestic_capital.csv output=%gdxdir%windc_vs_nipa_domestic_capital.gdx id=cap_own0_ index=(1) useHeader=y value=4';
$gdxin %gdxdir%windc_vs_nipa_domestic_capital.gdx
$load cap_own0_
$gdxin

$if %capital_ownership%=="partial" cap_own0 = cap_own0_("%year%");
$if %capital_ownership%=="all" cap_own0 = 1;

* Report household budget balance in source data assumptions:

adj_trans0(r,h) = sum(trn, hhtrans0(r,h,trn));

othinc0(r,h) = cons0(r,h)/sum(h.local, cons0(r,h)) * c0(r) +
    savings_rate0(r,h) * (cons0(r,h)/sum(h.local, cons0(r,h)) * c0(r))/(1-savings_rate0(r,h)) +
    household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s)) * (tl_avg0(r,h) + tfica0(r,h))
    -
    (adj_trans0(r,h) +
     household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s)) +
     household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s)));
display othinc0, adj_trans0;


* -----------------------------------------------------------------------------
* Income side balancing routine
* -----------------------------------------------------------------------------

* Define variables and equations of balancing routine. Allow for negative savings.

variable
    TAXES(r,h)		Direct labor tax payments,
    OBJ			Objective definition,
    FSAV            	Foreign savings in United States,
    OTHINC(r,h)		Other non-governmental transfer income;

nonnegative
variable
    TRANS(r,h)		Transfer payments,
    TRANSHH(r,h,*)	Disaggregate Transfer payments,
    CONS(r,h)		Consumption expenditure
    WAGES(r,r,h)	Aggregate wage income (living in r and working in rr),
    INTEREST(r,h)	Aggregate interest income,
    FINT		Foreign capital ownership,
    SAVE(r,h)		Savings,
    SAVE_RATE(r,h)	Savings rate (relative to consumption);

equations
    objdef		Objective function,
    taxdef		Tax constraint,
    consdef		Consumption constraint,
    wagedef		Cross state labor income constraint,
    interestdef		Capital income constraint,
    savedef		Savings constraint,
    saveratedef		Definition of savings rate,
    targetsave		Target economy-wide savings rate from bea,
    incbal		Income balance closure,
    disagtrn		Disaggregate transfer payment;

* Objective definition -- target shares for labor and capital income and totals
* for transfers and savings. Fix transfers, minimize difference in labor and
* capital, and let savings be the degree of freedom. Also penalize interstate
* commuting based on ACS data on commuting flows. Without better information,
* assume commuting across states is equally likely across income distribution.

objdef..
    OBJ =e= sum((r,h),
 	abs(household_shares(r,h,'wages')*le0_multiplier(r)*sum(s,ld0(r,s)))*
	   sqr(sum(rr, WAGES(r,rr,h))/(household_shares(r,h,'wages')*le0_multiplier(r)*sum(s,ld0(r,s))) - 1) +
	abs(household_shares(r,h,'cap')*cap_own0*sum((s,rr),kd0(rr,s)))*
	   sqr(INTEREST(r,h)/(household_shares(r,h,'cap')*cap_own0*sum((s,rr),kd0(rr,s))) - 1)) + 
    	sum((r,rr)$commute0(r,rr), abs(commute0(r,rr))*sqr(sum(h,WAGES(r,rr,h))/commute0(r,rr) - 1)) +
        sum((r,h)$(ord(h) < 3), abs(othinc0(r,h)) * sqr(OTHINC(r,h)/othinc0(r,h) - 1));
	
* fix the income tax rate from the household data
taxdef(r,h)..
    TAXES(r,h) =e= (tl_avg0(r,h) + tfica0(r,h)) * sum(rr, WAGES(r,rr,h));

* aggregation definition on total household consumption
consdef(r)..
    sum(h, CONS(r,h)) =e= c0(r);

* wage income must sum to total labor demands by region
wagedef(rr)..
    sum((r,h), WAGES(r,rr,h)) =e= sum(s, ld0(rr,s));

* capital rents must sum to total capital demands by region
interestdef..
    sum((r,h), INTEREST(r,h)) + FINT =e= sum((r,s), kd0(r,s) + yh0(r,s));

* ignore enterprise and government saving:
savedef..
    sum((r,h), SAVE(r,h)) + FSAV =e= sum((r,g), i0(r,g));

* define savings rate
saveratedef(r,h)..
    SAVE_RATE(r,h) * (CONS(r,h)+SAVE(r,h)) =e= SAVE(r,h);

* target economy-wide savings rate
targetsave$save_target..
    sum((r,h), SAVE(r,h)) =e= sum((r,h), CONS(r,h)+SAVE(r,h)) * savings_rate_bea0;

* let transfer payments and taxes adjust to satisfy budget balance assumptions
incbal(r,h)..
    TRANS(r,h) + OTHINC(r,h) + sum(rr, WAGES(r,rr,h)) + INTEREST(r,h) =e= CONS(r,h) + SAVE(r,h) + TAXES(r,h);

* disaggregate transfer payments
disagtrn(r,h)..
    sum(trn, TRANSHH(r,h,trn)) =e= TRANS(r,h);

model calib_step2_%hhdata% / objdef, taxdef, consdef, wagedef, interestdef,
			     savedef, saveratedef, targetsave, incbal, disagtrn /;

* Bounds on ABSOLUTE government transfers (we have good data on this). 

$if %hhdata% == "cps" TRANSHH.LO(r,h,trn) = 0.8 * hhtrans0(r,h,trn);
$if %hhdata% == "cps" TRANSHH.UP(r,h,trn) = 1.2 * hhtrans0(r,h,trn);

$if %hhdata% == "soi" TRANSHH.LO(r,h,trn) = 0.5 * hhtrans0(r,h,trn);
$if %hhdata% == "soi" TRANSHH.UP(r,h,trn) = 1.5 * hhtrans0(r,h,trn);

TRANS.L(r,h) = sum(trn, hhtrans0(r,h,trn));

* Fix "other" transfer income not accounted for in the household data (can
* be negative) to zero:

OTHINC.FX(r,h) = 0;

* Require a lower bound on aggregate consumption to prevent zero values from
* occurring

CONS.L(r,h) = cons0(r,h) / sum(h.local, cons0(r,h)) * c0(r);
CONS.LO(r,h) = 0.1 * cons0(r,h) / sum(h.local, cons0(r,h)) * c0(r);

* Target income SHARES for wages and capital earnings (both categories having
* missing information so we target the distribution based on WiNDC
* totals). Restrictions of interstate commuting handled through the objective
* function. Note that commute0(r,rr) represents an upper bound on interstate
* commuting -- it is estimated by taking the number of estimated commuters from
* the ACS multiplied by average household income in the origin state of the
* commute.

WAGES.L(r,r,h) = household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
$if %hhdata% == "cps" WAGES.LO(r,r,h) = 0.65 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
$if %hhdata% == "cps" WAGES.UP(r,r,h) = 1.25 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
$if %hhdata% == "soi" WAGES.LO(r,r,h) = 0.5 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));
$if %hhdata% == "soi" WAGES.UP(r,r,h) = 1.5 * household_shares(r,h,'wages') * le0_multiplier(r) * sum(s, ld0(r,s));

WAGES.L(r,rr,h)$(commute0(r,rr)>0 and not sameas(r,rr)) = 0.5 * commute0(r,rr)/card(h);
WAGES.LO(r,rr,h)$(commute0(r,rr)>0 and not sameas(r,rr)) = 0.1 * commute0(r,rr)/card(h);
WAGES.UP(r,rr,h)$(commute0(r,rr)>0 and not sameas(r,rr)) = 1.25 * commute0(r,rr)/card(h);
WAGES.FX(r,rr,h)$(commute0(r,rr)=0 and not sameas(r,rr)) = 0;

INTEREST.L(r,h) = household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
$if %hhdata% == "cps" INTEREST.LO(r,h) = 0.75 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
$if %hhdata% == "cps" INTEREST.UP(r,h) = 1.25 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
$if %hhdata% == "soi" INTEREST.LO(r,h) = 0.5 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));
$if %hhdata% == "soi" INTEREST.UP(r,h) = 1.5 * household_shares(r,h,'cap') * cap_own0 * sum((s,rr), kd0(rr,s));

FINT.L = (1-cap_own0) * sum((r,s), kd0(r,s));
$if %capital_ownership%=="all" FINT.FX = 0;
$if %capital_ownership%=="all" FSAV.FX = 0;

* Assume any interest income adjustments that need to be made outside of bounds
* above accrue to upper income group

INTEREST.UP(r,h)$(ord(h)=card(h)) = inf;

* Assume lower bound on savings based on retirement distributions:

SAVE.L(r,h) = save0(r,h);
$if %hhdata% == "cps" SAVE.LO(r,h) = 0.1 * save0(r,h);

* Constrain savings rate letting any additional savings needed to close the
* budget constraint accrues to the upper income group

SAVE_RATE.L(r,h) = savings_rate0(r,h);
SAVE_RATE.LO(r,h) = min(savings_rate0(r,h),savings_rate0(r,h-1));
SAVE_RATE.UP(r,h) = max(savings_rate0(r,h),savings_rate0(r,h+1));
SAVE_RATE.UP(r,h)$(ord(h)=card(h)) = inf;

* Taxes are constrained by a fixed tax rate in the balancing routine

TAXES.L(r,h) = taxes0(r,h);

* Solve the income side balancing routine

$if %puttitle%==yes put_utility kutl 'title' /'solve calib_step2_%hhdata% using nlp minimizing OBJ;';
solve calib_step2_%hhdata% using nlp minimizing OBJ;
abort$(calib_step2_%hhdata%.modelstat > 2) "Model has status>2, check lst/hhcalib_%year%_%hhdata%_%invest%.lst";

* Construct reports on calibrated household accounts

parameter
    cbochk    Check on CBO result for transfers less taxes,
    chkhhdata Aggregate shares for calibrated dataset,
    chktotals Aggregate totals for calibrated dataset,
    increp    Income report,
    cons_save Report on consumption vs savings,
    boundshr  Report on minimum and maximum shares,
    chkwages  Check on multi-dimensional wages;

cbochk(h) = sum(r, TRANS.L(r,h) - TAXES.L(r,h));

chkhhdata("income","total",h) = sum(r, sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h));
chkhhdata("income","wage",h) = sum(r, sum(rr, WAGES.L(r,rr,h))) / chkhhdata("income","total",h);
chkhhdata("income","interest",h) = sum(r, INTEREST.L(r,h)) / chkhhdata("income","total",h);
chkhhdata("income","transfers",h) = sum(r, TRANS.L(r,h)) / chkhhdata("income","total",h);
chkhhdata("income","other",h) = sum(r, OTHINC.L(r,h)) / chkhhdata("income","total",h);

chkhhdata("expend","total",h) = sum(r, CONS.L(r,h) + TAXES.L(r,h) + SAVE.L(r,h));
chkhhdata("expend","cons",h) = sum(r, CONS.L(r,h)) / chkhhdata("expend","total",h);
chkhhdata("expend","taxes",h) = sum(r, TAXES.L(r,h)) / chkhhdata("expend","total",h);
chkhhdata("expend","save",h) = sum(r, SAVE.L(r,h)) / chkhhdata("expend","total",h);

chktotals("income","total",h) = sum(r, sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h));
chktotals("income","wage",h) = sum(r, sum(rr, WAGES.L(r,rr,h)));
chktotals("income","interest",h) = sum(r, INTEREST.L(r,h));
chktotals("income","transfers",h) = sum(r, TRANS.L(r,h));
chktotals("income","other",h) = sum(r, OTHINC.L(r,h));

chktotals("expend","total",h) = sum(r, CONS.L(r,h) + TAXES.L(r,h) + SAVE.L(r,h));
chktotals("expend","cons",h) = sum(r, CONS.L(r,h));
chktotals("expend","taxes",h) = sum(r, TAXES.L(r,h));
chktotals("expend","save",h) = sum(r, SAVE.L(r,h));

increp(r,h,'wage','cal') = sum(rr, WAGES.L(r,rr,h)) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.l(r,h));
increp(r,h,'interest','cal') = INTEREST.L(r,h) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h));
increp(r,h,'trans','cal') = TRANS.L(r,h) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h));
increp(r,h,'other','cal') = OTHINC.L(r,h) / (sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h));
increp('us',h,'wage','cal') = sum(r, sum(rr, WAGES.L(r,rr,h))) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp('us',h,'interest','cal') = sum(r, INTEREST.L(r,h)) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp('us',h,'trans','cal') = sum(r, TRANS.L(r,h)) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp('us',h,'trans','cal') = sum(r, OTHINC.L(r,h)) / sum(r,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp(r,"all",'wage','cal') = sum(h, sum(rr, WAGES.L(r,rr,h))) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h)));
increp(r,"all",'interest','cal') = sum(h, INTEREST.L(r,h)) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp(r,"all",'trans','cal') = sum(h, TRANS.L(r,h)) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp(r,"all",'trans','cal') = sum(h, OTHINC.L(r,h)) / sum(h,(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp("us","all",'wage','cal') = sum((r,rr,h), WAGES.L(r,rr,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp("us","all",'interest','cal') = sum((r,h), INTEREST.L(r,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp("us","all",'trans','cal') = sum((r,h), TRANS.L(r,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));
increp("us","all",'trans','cal') = sum((r,h), OTHINC.L(r,h)) / sum((r,h),(sum(rr, WAGES.L(r,rr,h)) + INTEREST.L(r,h) + TRANS.L(r,h) + OTHINC.L(r,h)));

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
boundshr(h,'other','min') = smin(r, increp(r,h,'other','cal'));
boundshr(h,'other','max') = smax(r, increp(r,h,'other','cal'));
boundshr(h,'other','mean') = chkhhdata("income","other",h);

chkwages(r,h,'le0') = wages0(r,h);
chkwages(r,h,'le0_cal') = sum(rr, WAGES.L(r,rr,h));
chkwages(r,h,'le0_pct') = 100 * chkwages(r,h,'le0_cal') / chkwages(r,h,'le0');
chkwages(r,'all','le0') = sum(h, wages0(r,h));
chkwages(r,'all','le0_cal') = sum((rr,h), WAGES.L(r,rr,h));
chkwages(r,'all','ld0') = sum(s, ld0(r,s));
chkwages(r,'all','ld0_pct') = 100 * chkwages(r,'all','le0_cal') / chkwages(r,'all','ld0');
chkwages(r,'all','le0_pct') = 100 * chkwages(r,'all','le0_cal') / chkwages(r,'all','le0');
display cbochk, chkhhdata, hhshares, chktotals, increp, boundshr, chkwages, cons_save, WAGES.L;

parameter
    avg_tax_h, avg_tax_r, avg_tax    Reports on average tax rates;

avg_tax_h(h) = sum(r, TAXES.L(r,h)) / sum(r, sum(rr, WAGES.L(r,rr,h)));
avg_tax_r(r) = sum(h, TAXES.L(r,h)) / sum(h, sum(rr, WAGES.L(r,rr,h)));
avg_tax = sum((r,h), TAXES.L(r,h)) / sum((r,h), sum(rr, WAGES.L(r,rr,h)));
display avg_tax_h, avg_tax;
display fsav.l, fint.l;


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
$call 'csv2gdx ../data/household/cex/national_income_elasticities_CEX_2013_2017.csv output=%gdxdir%national_income_elasticities_CEX_2013_2017.gdx id=regres index=1 useHeader=y value=2,3,4';
$gdxin '%gdxdir%national_income_elasticities_CEX_2013_2017.gdx'
$load regres

eta_(cex) = regres(cex,'elast');

* read in constructed bridge file between cex and sage sectors (based on pce)
$call 'csv2gdx ../data/household/cex/windc_pce_map.csv output=%gdxdir%windc_pce_map.gdx id=pcebridge index=1,2 useHeader=y value=3,4,5';
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
abort$(calib_step3_%hhdata%.modelstat > 2) "Model has status>2, check lst/hhcalib_%year%_%hhdata%_%invest%.lst";

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
    cd0_h(r,g,h)	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    fsav0		Foreign savings,
    fint0		Foreign interest payments,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,*)	Disaggregate household transfer payments;

cd0_h(r,g,h) = CD.L(r,g,h);
c0_h(r,h) = CONS.L(r,h);
le0(r,rr,h) = WAGES.L(r,rr,h);
ke0(r,h) = INTEREST.L(r,h);
sav0(r,h) = SAVE.L(r,h);
fsav0 = FSAV.L;
fint0 = FINT.L;
trn0(r,h) = TRANS.L(r,h);
$if %hhdata%=="soi" hhtrn0(r,h,trn) = trn0(r,h);
$if %hhdata%=="cps" hhtrn0(r,h,trn) = TRANSHH.L(r,h,trn);

* Output resulting data parameters

execute_unload "%gdxdir%calibrated_hhdata_%invest%_%hhdata%_%capital_ownership%_%year%.gdx"
    h, trn, cd0_h, c0_h, le0, ke0, tl_avg0, tl0, tfica0, sav0, fsav0, fint0, trn0, hhtrn0, pop0;


* -----------------------------------------------------------------------------
* End
* -----------------------------------------------------------------------------
