$title Gross state product (GSP) shares


* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* matrix balancing method defines which dataset is loaded
$if not set matbal $set matbal ls


* ------------------------------------------------------------------------------
* Read in state level GSP data, and relevant bea totals:
* ------------------------------------------------------------------------------

set
    yr 		Years in WiNDC Database,
    lyr		Years for computing rolling averages,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database,
    s 		BEA Goods and sectors categories,
    si 		Dynamically created set from parameter gsp_units (industry list),
    gdpcat 	Dynamically creates set from parameter gsp_units (GSP components);

parameter
    gsp_units(sr,yr,gdpcat,si,*) Annual gross state product with units as domain;

$gdxin '../data/core/windc_base.gdx'
$load s=i yr sr r lyr=yr
$load gdpcat<gsp_units.dim3
$load si<gsp_units.dim4
$load gsp_units
$gdxin

parameter
    va_0(yr,*,s) 	Value added from national dataset;

$gdxin 'gdx/nationaldata_%matbal%.gdx'
$load va_0
$gdxin

parameter
    gspcalc(r,yr,gdpcat,si) 	Calculated gross state product;

gspcalc(r,yr,'cmp',si) = gsp_units(r,yr,'cmp',si,"millions of us dollars (USD)");
gspcalc(r,yr,'gos',si) = gsp_units(r,yr,'gos',si,"millions of us dollars (USD)");
gspcalc(r,yr,'taxsbd',si) = gsp_units(r,yr,'taxsbd',si,"millions of us dollars (USD)");
gspcalc(r,yr,'gdp',si) = gspcalc(r,yr,'cmp',si) + gspcalc(r,yr,'gos',si) + gspcalc(r,yr,'taxsbd',si);

* Note: GSP <> lab + cap + tax in the data for government affiliated sectors
* (utilities, enterprises, etc.). Some capital account elements of GSP are
* negative.


* ------------------------------------------------------------------------------
* Map GSP sectors to national IO definitions:
* ------------------------------------------------------------------------------

* Note that in the mapping, aggregate categories in the GSP dataset are
* removed. Also, the used and other sectors don't have any mapping to the
* state files. In cases other than used and other, the national files have
* more detail. In cases where multiple sectors are mapped to the state gdp
* estimates, the same profile of GDP will be used. Used and scrap sectors
* are defined by state averages.

set
    mapsec(si,s) 	Mapping between state sectors and national sectors /
$INCLUDE 'maps/mapgsp.map'
/;

parameter
    gsp0(yr,r,s,*) 	Mapped state level gsp accounts,
    compen0(yr,r,s) 	Employee compensation,
    cap0(yr,r,s) 	Operating surplus,
    gspcat0(yr,r,s,gdpcat) Mapped gsp categorical accounts;

gsp0(yr,r,s,'Calculated') = sum(mapsec(si,s), gspcalc(r,yr,'gdp',si));
gsp0(yr,r,s,'Reported') = sum(mapsec(si,s), gsp_units(r,yr,'gdp',si,"millions of us dollars (USD)"));
gsp0(yr,r,s,'Diff') = gsp0(yr,r,s,'Reported') - gsp0(yr,r,s,'Calculated');
compen0(yr,r,s) = sum(mapsec(si,s), gsp_units(r,yr,'cmp',si,"millions of us dollars (USD)"));
cap0(yr,r,s) = sum(mapsec(si,s), gsp_units(r,yr,'gos',si,"millions of us dollars (USD)"));
gspcat0(yr,r,s,gdpcat) = sum(mapsec(si,s), gsp_units(r,yr,gdpcat,si,"millions of us dollars (USD)"));

* For the most part, these figures match (rounding errors produce +-1 on the
* check). However, sector 10 other government affiliated sectors (utilities)
* produces larger error.

* ------------------------------------------------------------------------------
* Generate io-shares using national data to share out regional GDP
* estimates, first mapping data to state level aggregation:
* ------------------------------------------------------------------------------

parameter
    region_shr 		Regional share of value added,
    rs_exist		Verify existance of region shares for needed sectors,
    labor_shr 		Estimated share of regional value added due to labor,
    klshare		Reported capital-labor shares in data,
    problem_shares	QA flagged region-sectors;

region_shr(yr,r,s)$(sum(r.local, gsp0(yr,r,s,'Reported'))) = gsp0(yr,r,s,'Reported') /
    sum(r.local,  gsp0(yr,r,s,'Reported'));

* Verify regional shares sum to one:

region_shr(yr,r,s)$sum(r.local, region_shr(yr,r,s)) = region_shr(yr,r,s) /
    sum(r.local, region_shr(yr,r,s));

* Verify regional shares exist for all sector-year observations in the io data

rs_exist(yr,s)$(va_0(yr,'compen',s) + va_0(yr,'surplus',s) and not (sum(r, region_shr(yr,r,s)))) = 1;
abort$(sum((yr,s), rs_exist(yr,s))>0) 'Inconsistency in region shares';

* Attribute the difference between reported and calculated gdp to capital

klshare(yr,r,s,'l')$(gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s)) =
    compen0(yr,r,s) / (gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s));

klshare(yr,r,s,'l_nat')$(va_0(yr,'compen',s) + va_0(yr,'surplus',s)) =
    va_0(yr,'compen',s) / (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

klshare(yr,r,s,'k')$region_shr(yr,r,s) = 1 - klshare(yr,r,s,'l');

klshare(yr,r,s,'k_nat')$region_shr(yr,r,s) = 1 - klshare(yr,r,s,'l_nat');

* There is a discrepency with the average national k-l shares between the IO
* data and GSP data. Scale GSP shares to lineup with IO shars.

parameter
    chk_national_shares,
    delta_shr;

chk_national_shares(yr,s,'gsp')$sum(r,gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s)) =
    sum(r, compen0(yr,r,s)) / sum(r,gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s));

chk_national_shares(yr,s,'io')$(va_0(yr,'compen',s) + va_0(yr,'surplus',s)) =
    va_0(yr,'compen',s) / (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

delta_shr(yr,r,s,'shr')$chk_national_shares(yr,s,'gsp') = chk_national_shares(yr,s,'io')/chk_national_shares(yr,s,'gsp');
delta_shr(yr,r,s,'l') = klshare(yr,r,s,'l');
delta_shr(yr,r,s,'l-diff') = klshare(yr,r,s,'l') * delta_shr(yr,r,s,'shr');
klshare(yr,r,s,'l') = klshare(yr,r,s,'l') * delta_shr(yr,r,s,'shr');
klshare(yr,r,s,'k') = 1 - klshare(yr,r,s,'l');

* There are instances where capital payments are negative, dominate value added,
* or are significantly different from the national averages. assign these
* instances to a parameter and allow a matrix balancing routine change them
* slightly to target national labor payments consistent with NIPA accounts.

problem_shares(yr,r,s,'negative') = 1$(klshare(yr,r,s,'k')<0);
problem_shares(yr,r,s,'unity') = 1$(klshare(yr,r,s,'k')>=1);
problem_shares(yr,r,s,'sig_diff')$klshare(yr,r,s,'k_nat') =
    1$(abs(klshare(yr,r,s,'k') - klshare(yr,r,s,'k_nat'))>.75);
problem_shares(yr,r,s,'tot') = problem_shares(yr,r,s,'negative') +
    problem_shares(yr,r,s,'unity') + problem_shares(yr,r,s,'sig_diff');
problem_shares(yr,r,s,'tot')$problem_shares(yr,r,s,'tot') = 1;

parameter
    pct_problem	Compute percent of shares that are problematic;

pct_problem(yr,"year") = sum((r,s), problem_shares(yr,r,s,'tot')) / sum((r,s)$region_shr(yr,r,s), 1);
pct_problem(s,"sector")$sum((r,yr)$region_shr(yr,r,s), 1) = sum((r,yr), problem_shares(yr,r,s,'tot')) / sum((r,yr)$region_shr(yr,r,s), 1);
pct_problem(r,"region")$sum((s,yr)$region_shr(yr,r,s), 1) = sum((s,yr), problem_shares(yr,r,s,'tot')) / sum((s,yr)$region_shr(yr,r,s), 1);

* Replace problem shares with national average

klshare(yr,r,s,'l')$(problem_shares(yr,r,s,'tot') and region_shr(yr,r,s)) = klshare(yr,r,s,'l_nat');
klshare(yr,r,s,'k')$region_shr(yr,r,s) = 1 - klshare(yr,r,s,'l');

* Define year set to calculate averages over -- assume boundaries get full
* window of time

parameter
    numyear	Number of other years in rolling average (use even numbers) /8/;

set
    loopyr(yr,lyr);
alias(yr,yyr);

loopyr(yr,lyr)$(yr.val <= lyr.val+numyear/2 and yr.val >= lyr.val - numyear/2) = yes;

* Define temporary data containers serving as looping parameters

parameter klshare_, problem_shares_, gspbal, save, region_shr_,ld0,kd0;

* Design balancing routine to shift share, targetting national value share for
* labor (to keep NIPA totals constant)

nonnegative
variables
    K_SHR(r)	Capital value share,
    L_SHR(r)	Labor value share;

variable
    OBJ		Objective function (norm of deviation);

equations
    objdef	Objective function,
    shrdef	Value shares sum to unity,
    lshrdef	Constraint on aggregate labor payments,
    kshrdef	Constraint on aggregate capital payments;

lshrdef..
    sum(r, L_SHR(r)*region_shr_(r)*(ld0+kd0)) =e= ld0;

kshrdef..
    sum(r, K_SHR(r)*region_shr_(r)*(ld0+kd0)) =e= kd0;

shrdef(r)$region_shr_(r)..
    L_SHR(r) + K_SHR(r) =e= 1;

* Define the objective function to minimize deviations from national and
* reported data. compute over rolling years to avoid oscillations in the
* reported gsp data.

objdef..
    OBJ =e= sum((r,lyr)$(region_shr_(r) and klshare_(r,lyr,'l')),
	abs(gspbal(r))*sqr(L_SHR(r)/klshare_(r,lyr,'l') - 1));

model solve_shares /objdef, shrdef, lshrdef, kshrdef/;

* Solve the model for each year and sector in the dataset

loop((yr,s)$va_0(yr,'compen',s),

    klshare_(r,lyr,'l')$loopyr(yr,lyr) = klshare(lyr,r,s,'l');

    gspbal(r) = gsp0(yr,r,s,'Reported');

    ld0 = va_0(yr,'compen',s);
    kd0 = va_0(yr,'surplus',s);

    region_shr_(r) = region_shr(yr,r,s);

    L_SHR.L(r)$region_shr_(r) = klshare(yr,r,s,'l');
    K_SHR.L(r)$region_shr_(r) = klshare(yr,r,s,'k');

    L_SHR.LO(r)$region_shr_(r) = 0.25 * klshare(yr,r,s,'l_nat');
    K_SHR.LO(r)$region_shr_(r) = 0.25 * klshare(yr,r,s,'k_nat');

* Fix shares to zero if region_shr is zero

    L_SHR.FX(r)$(not region_shr(yr,r,s)) = 0;
    K_SHR.FX(r)$(not region_shr(yr,r,s)) = 0;
    
    solve solve_shares minimizing OBJ using QCP;
    abort$(solve_shares.modelstat>2) "GSP share generation is infeasible";

    save(yr,r,s,'k') = K_SHR.L(r);
    save(yr,r,s,'l') = L_SHR.L(r);

* Reset loop parameters

    klshare_(r,lyr,'l') = 0;
    
* Reset bounds on veriables

    L_SHR.LO(r) = 0;
    L_SHR.UP(r) = inf;

    K_SHR.LO(r) = 0;
    K_SHR.UP(r) = inf;
);

* Report share stability:

parameter
    stability		Stability check;

stability(s,r,yr)$save(yr,r,s,'l') = round(save(yr,r,s,'l')/klshare(yr,r,s,'l_nat'),5);
* execute_unload 'stability_chk.gdx' stability;
* execute 'gdxxrw stability_chk.gdx par=stability rng=pivotdata!A2 cdim=0';

* Save labor share from model solution

labor_shr(yr,r,s) = save(yr,r,s,'l');


* ------------------------------------------------------------------------------
* Output regional shares
* ------------------------------------------------------------------------------

execute_unload 'gdx/shares_gsp.gdx' region_shr, labor_shr;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
