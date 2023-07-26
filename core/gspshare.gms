$title Gross state product (GSP) shares


* ------------------------------------------------------------------------------
* Set options
* ------------------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

* matrix balancing method defines which dataset is loaded
$if not set matbal $set matbal ls


* ------------------------------------------------------------------------------
* Read in state level GSP data, and relevant bea totals:
* ------------------------------------------------------------------------------

set
    yr 		Years in WiNDC Database,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database,
    s 		BEA Goods and sectors categories,
    si 		Dynamically created set from parameter gsp_units (industry list),
    gdpcat 	Dynamically creates set from parameter gsp_units (GSP components);

parameter
    gsp_units(sr,yr,gdpcat,si,*) Annual gross state product with units as domain;

$gdxin 'windc_base.gdx'
$load s=i yr sr r
$load gdpcat<gsp_units.dim3
$load si<gsp_units.dim4
$load gsp_units
$gdxin

parameter
    va_0(yr,*,s) 	Value added from national dataset;

$gdxin 'gdx%sep%nationaldata_%matbal%.gdx'
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
$INCLUDE 'maps%sep%mapgsp.map'
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
    labor_shr 		Estimated share of regional value added due to labor,
    klshare		Reported capital-labor shares in data,
    problem_shares	QA flagged region-sectors;

region_shr(yr,r,s)$(sum(r.local, gsp0(yr,r,s,'Reported'))) = gsp0(yr,r,s,'Reported') / sum(r.local,  gsp0(yr,r,s,'Reported'));

* Verify regional shares sum to one:

region_shr(yr,r,s)$sum(r.local, region_shr(yr,r,s)) = region_shr(yr,r,s) / sum(r.local, region_shr(yr,r,s));

* Attribute the difference between reported and calculated gdp to capital

klshare(yr,r,s,'k')$(gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s)) =
    (gsp0(yr,r,s,'Diff') + cap0(yr,r,s)) / (gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s));

klshare(yr,r,s,'k_nat')$(va_0(yr,'compen',s) + va_0(yr,'surplus',s)) =
    va_0(yr,'surplus',s) / (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

klshare(yr,r,s,'l')$(gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s)) =
    compen0(yr,r,s) / (gsp0(yr,r,s,'Diff') + cap0(yr,r,s) + compen0(yr,r,s));

klshare(yr,r,s,'l_nat')$(va_0(yr,'compen',s) + va_0(yr,'surplus',s)) =
    va_0(yr,'compen',s) / (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

* there are instances where capital payments are negative, dominate value added,
* or are significantly different from the national averages. assign these
* instances to a parameter and allow a matrix balancing routine change them
* slightly to target national labor payments consistent with NIPA accounts.

problem_shares(yr,r,s,'negative') = 1$(klshare(yr,r,s,'k')<0);
problem_shares(yr,r,s,'unity') = 1$(klshare(yr,r,s,'k')=1);
problem_shares(yr,r,s,'sig_diff')$klshare(yr,r,s,'k_nat') =
    1$(abs(klshare(yr,r,s,'k') - klshare(yr,r,s,'k_nat'))>.5);
problem_shares(yr,r,s,'tot') = problem_shares(yr,r,s,'negative') +
    problem_shares(yr,r,s,'unity') + problem_shares(yr,r,s,'sig_diff');

* Define temporary data containers serving as looping parameters

parameter klshare_, problem_shares_, gspbal, save, region_shr_,ld0,kd0;

* design balancing routine to shift share, targetting national value share for
* labor (to keep NIPA totals constant)

nonnegative
variables
    K_SHR(r,s)	Capital value share,
    L_SHR(r,s)	Labor value share;

variable
    OBJ		Objective function (norm of deviation);

equations
    objdef	Objective function,
    shrdef	Value shares sum to unity,
    lshrdef	Constraint on aggregate labor payments;

lshrdef(s)..
    sum(r, L_SHR(r,s)*region_shr_(r,s)*(ld0(s)+kd0(s))) =e= ld0(s);

shrdef(r,s)..
    L_SHR(r,s) + K_SHR(r,s) =e= 1;

objdef..
    OBJ =e= sum((r,s)$(gspbal(r,s) and problem_shares_(r,s)),
		abs(klshare_(r,s,'k_nat'))*sqr(K_SHR(r,s)/klshare_(r,s,'k_nat')) - 1) +
            sum((r,s)$(gspbal(r,s) and problem_shares_(r,s)),
		abs(klshare_(r,s,'l_nat'))*sqr(L_SHR(r,s)/klshare_(r,s,'l_nat')) - 1) +
            sum((r,s)$(gspbal(r,s) and not problem_shares_(r,s)),
		abs(klshare_(r,s,'k'))*sqr(K_SHR(r,s)/klshare_(r,s,'k')) - 1) +
            sum((r,s)$(gspbal(r,s) and not problem_shares_(r,s)),
		abs(klshare_(r,s,'l'))*sqr(L_SHR(r,s)/klshare_(r,s,'l')) - 1);

model solve_shares /objdef, shrdef, lshrdef/;

* Loop over years of data

loop(yr,

    klshare_(r,s,'k_nat') = klshare(yr,r,s,'k_nat');
    klshare_(r,s,'l_nat') = klshare(yr,r,s,'l_nat');
    klshare_(r,s,'k') = klshare(yr,r,s,'k');
    klshare_(r,s,'l') = klshare(yr,r,s,'l');

    problem_shares_(r,s) = problem_shares(yr,r,s,'tot');

    gspbal(r,s) = gsp0(yr,r,s,'Reported');

    ld0(s) = va_0(yr,'compen',s);
    kd0(s) = va_0(yr,'surplus',s);

    region_shr_(r,s) = region_shr(yr,r,s);

    K_SHR.L(r,s) = klshare(yr,r,s,'k');
    L_SHR.L(r,s) = klshare(yr,r,s,'l');

    K_SHR.UP(r,s) = 1;
    L_SHR.up(r,s) = 1;
    
* K_SHR.FX(yr,r,s)$(not problem_shares(yr,r,s,'tot')) = klshare(yr,r,s,'k');
* L_SHR.FX(yr,r,s)$(not problem_shares(yr,r,s,'tot')) = klshare(yr,r,s,'l');

    K_SHR.FX(r,'use') = 1;
    L_SHR.FX(r,'use') = 0;
    K_SHR.FX(r,'oth') = 1;
    L_SHR.FX(r,'oth') = 0;

    solve solve_shares minimizing OBJ using QCP;

    save(yr,r,s,'k') = K_SHR.L(r,s);
    save(yr,r,s,'l') = L_SHR.L(r,s);
);

parameter
    comp_shares		Report comparisons;

comp_shares(yr,r,s,'k_solve') = save(yr,r,s,'k');
comp_shares(yr,r,s,'k_nat') = klshare(yr,r,s,'k_nat');
comp_shares(yr,r,s,'k_dat') = klshare(yr,r,s,'k');

comp_shares(yr,r,s,'l_solve') = save(yr,r,s,'l');
comp_shares(yr,r,s,'l_nat') = klshare(yr,r,s,'l_nat');
comp_shares(yr,r,s,'l_dat') = klshare(yr,r,s,'l');
display comp_shares;

* Save labor share from model solution

labor_shr(yr,r,s) = save(yr,r,s,'l');


* ------------------------------------------------------------------------------
* Output regional shares
* ------------------------------------------------------------------------------

execute_unload 'gdx%sep%shares_gsp.gdx' region_shr, labor_shr;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
