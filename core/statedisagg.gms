$title State disaggregation of national accounts


* -------------------------------------------------------------------
* Set options:
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%

* matrix balancing method defines which dataset is loaded
$if not set matbal $set matbal ls

* check benchmark consistency in regional model for single year
$if not set year $set year 2017

* input data directory
$set gdxdir gdx%sep%

* set default name of the output dataset
$if not set ds $set ds "WiNDCdatabase"

* switch for using neos optimization server
$if not set neos $set neos "no"

* Write an options file for kestrel which is used if NEOS is chosen:
$echo		kestrel_solver path			>kestrel.opt
$echo		neos_server "neos-server.org:3333"	>>kestrel.opt


* -------------------------------------------------------------------
* Read in the national dataset:
* -------------------------------------------------------------------

set
    yr 	Years in WiNDC Database,
    r 	Regions in WiNDC Database,
    s 	BEA Goods and sectors categories,
    m 	Margins (trade or transport),
    fd 	BEA Final demand categories,
    ts 	BEA Taxes and subsidies categories,
    va 	BEA Value added categories;

* GDX existance test for UNIX
$if not exist "%gdxdir%nationaldata_%matbal%.gdx" abort "File nationaldata_%matbal%.gdx does not exist"

$gdxin '%gdxdir%nationaldata_%matbal%.gdx'
$load yr r s=i va fd m
alias(s,g,ss,gg),(r,rr);

parameter
    y_0(yr,s)		Gross output,
    ys_0(yr,s,g)	Sectoral supply,
    ty_0(yr,s)		Sectoral tax rate,
    fs_0(yr,g)		Household supply,
    id_0(yr,g,s)	Intermediate demand,
    fd_0(yr,s,fd)	Final demand,
    va_0(yr,va,s)	Vaue added,
    m_0(yr,g)		Imports,
    x_0(yr,g)		Exports of goods and services,
    ms_0(yr,s,m)	Margin supply,
    md_0(yr,m,g)	Margin demand,
    s_0(yr,g)		Aggregate supply,
    a_0(yr,g)		Armington supply,
    ta_0(yr,g)		Tax net subsidy rate on intermediate demand,
    tm_0(yr,g)		Import tariff,
    bopdef_0(yr)	Balance of payments;

$loaddc y_0 ty_0 ys_0 fs_0 id_0 fd_0 va_0 m_0 x_0 ms_0 md_0 s_0 a_0
$loaddc bopdef_0 ta_0 tm_0
$gdxin


* -------------------------------------------------------------------
* Read in shares generated using state level gross product, pce, cfs and
* government expenditures:
* -------------------------------------------------------------------

parameter
    region_shr(yr,r,s)		Regional shares based on GSP,
    labor_shr(yr,r,s)		Labor share of GSP,
    pce_shr(yr,r,g)		Regional shares based on PCE,
    sgf_shr(yr,r,g)		Regional government expenditure shares (SGF),
    cfs_rpc(r,g)		Regional purchase coefficients based on CFS (2012),
    usatrd_shr(yr,r,g,*)	Regional export-import shares based on USA Trade Online;

* GDX existance test for UNIX
$if not exist "%gdxdir%shares_pce.gdx" abort "File shares_pce.gdx does not exist"
$if not exist "%gdxdir%shares_sgf.gdx" abort "File shares_sgf.gdx does not exist"
$if not exist "%gdxdir%cfs_rpcs.gdx" abort "File cfs_rpcs.gdx does not exist"
$if not exist "%gdxdir%shares_usatrd.gdx" abort "File shares_usatrd.gdx does not exist"

* N.B. We use LOAD rather than LOADDC to avoid domain errors associated
* with sectors "oth" and "use" which were dropped from the sector list in
* the calibrate routine.

$gdxin %gdxdir%shares_gsp.gdx
$load region_shr labor_shr
$gdxin

$gdxin %gdxdir%shares_pce.gdx
$load pce_shr
$gdxin

$gdxin %gdxdir%shares_sgf.gdx
$load sgf_shr
$gdxin

$gdxin %gdxdir%cfs_rpcs.gdx
$load cfs_rpc=rpc
$gdxin

$gdxin %gdxdir%shares_usatrd.gdx
$load usatrd_shr
$gdxin

* For years not included in USA Trade Online shares, use most recent
* shares. Earliest year for exports is: 2002. Earliest year for imports
* is: 2008.

usatrd_shr(yr,r,g,'exports')$(ord(yr) < 6) = usatrd_shr('2002',r,g,'exports');
usatrd_shr(yr,r,g,'imports')$(ord(yr) < 12) = usatrd_shr('2008',r,g,'imports');

* Verify all shares both sum to 1 and are in [0,1]:

parameter
    shrverify 	Verify consistent shares;

shrverify(yr,g,'PCE','max') = smax(r, pce_shr(yr,r,g));
shrverify(yr,g,'SGF','max') = smax(r, sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','max') = smax(r, region_shr(yr,r,g));
shrverify(yr,g,'LABOR','max') = smax(r, labor_shr(yr,r,g));
shrverify(yr,g,'RPC','max') = smax(r, cfs_rpc(r,g));
shrverify(yr,g,'XPT','max') = smax(r, usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','max') = smax(r, usatrd_shr(yr,r,g,'imports'));

shrverify(yr,g,'PCE','min') = smin(r$pce_shr(yr,r,g), pce_shr(yr,r,g));
shrverify(yr,g,'SGF','min') = smin(r$sgf_shr(yr,r,g), sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','min') = smin(r$region_shr(yr,r,g), region_shr(yr,r,g));
shrverify(yr,g,'LABOR','min') = smin(r$labor_shr(yr,r,g), labor_shr(yr,r,g));
shrverify(yr,g,'RPC','min') = smin(r$cfs_rpc(r,g), cfs_rpc(r,g));
shrverify(yr,g,'XPT','min') = smin(r$usatrd_shr(yr,r,g,'exports'), usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','min') = smin(r$usatrd_shr(yr,r,g,'imports'), usatrd_shr(yr,r,g,'imports'));

shrverify(yr,g,'PCE','sum') = sum(r, pce_shr(yr,r,g));
shrverify(yr,g,'SGF','sum') = sum(r, sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','sum') = sum(r, region_shr(yr,r,g));
shrverify(yr,g,'XPT','sum') = sum(r, usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','sum') = sum(r, usatrd_shr(yr,r,g,'imports'));
display shrverify;


* -------------------------------------------------------------------
* Regionalize production data using iomacro shares and GSP data:
* -------------------------------------------------------------------

parameter
    va0_(yr,r,s)	Regional value added,
    ld0_(yr,r,s)	Labor demand,
    kd0_(yr,r,s)	Capital demand,
    ty0_(yr,r,s)	Production tax rate,
    y0_(yr,r,s)		Regional gross sectoral output,
    ys0_(yr,r,s,g)	Regional sectoral output,
    id0_(yr,r,g,s)	Regional intermediate demand,
    gspchk(yr,r,s,*)    Verification of GSP shares,
    kvalshr(yr,r,s,*)   Capital demand value shares,  
    zprof(yr,r,s)	Check on ZP;

ys0_(yr,r,s,g) = region_shr(yr,r,s) * ys_0(yr,s,g);
id0_(yr,r,g,s) = region_shr(yr,r,s) * id_0(yr,g,s);
va0_(yr,r,s) = region_shr(yr,r,s) * (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

* Assume uniform output tax rates across regions

ty0_(yr,r,s) = ty_0(yr,s);

* Split aggregate value added based on GSP components

ld0_(yr,r,s) = labor_shr(yr,r,s) * va0_(yr,r,s);
kd0_(yr,r,s) = va0_(yr,r,s) - ld0_(yr,r,s);

* Verify zero profit condition

zprof(yr,r,s) = sum(g, ys0_(yr,r,s,g)) * (1-ty0_(yr,r,s)) -
    (ld0_(yr,r,s) + kd0_(yr,r,s) + sum(g, id0_(yr,r,g,s)));

abort$(smax((yr,r,s), abs(zprof(yr,r,s))) > 1e-5) "Error in zero profit check in regionalization.";

* -------------------------------------------------------------------
* Final demand categories:
* -------------------------------------------------------------------

* Aggregate final demand categories:

set
    fdcat 	Aggregated final demand categories /
	  	C 	"Household consumption",
	  	I 	"Investment",
	  	G 	"Government expenditures" /,

    fdmap(fd,fdcat) Mapping of final demand /
	  	pce.C 			"Personal consumption expenditures",
	  	structures.I 		"Nonresidential private fixed investment in structures",
	  	equipment.I 		"Nonresidential private fixed investment in equipment",
	  	intelprop.I 		"Nonresidential private fixed investment in intellectual",
	  	residential.I 		"Residential private fixed investment",
	  	changinv.I 		"Change in private inventories",
	  	defense.G 		"National defense: Consumption expenditures",
	  	def_structures.G 	"Federal national defense: Gross investment in structures",
	  	def_equipment.G 	"Federal national defense: Gross investment in equipment",
	  	def_intelprop.G 	"Federal national defense: Gross investment in intellectual",
	  	nondefense.G 		"Nondefense: Consumption expenditures",
	  	fed_structures.G 	"Federal nondefense: Gross investment in structures",
	  	fed_equipment.G 	"Federal nondefense: Gross investment in equipment",
	  	fed_intelprop.G 	"Federal nondefense: Gross investment in intellectual prop",
	  	state_consume.G 	"State and local government consumption expenditures",
	  	state_invest.G 		"State and local: Gross investment in structures",
	  	state_equipment.G 	"State and local: Gross investment in equipment",
	  	state_intelprop.G 	"State and local: Gross investment in intellectual" /;

parameter
    g_0(yr,g) 		National government demand,
    i_0(yr,g) 		National investment demand,
    cd_0(yr,g) 		National final consumption,
    yh0_(yr,r,s) 	Household production,
    fe0_(yr,r) 		Total factor supply,
    cd0_(yr,r,s) 	Consumption demand,
    c0_(yr,r) 		Total final household consumption,
    i0_(yr,r,s) 	Investment demand,
    g0_(yr,r,s) 	Government demand;

g_0(yr,g) = sum(fdmap(fd,'g'), fd_0(yr,g,fd));
i_0(yr,g) = sum(fdmap(fd,'i'), fd_0(yr,g,fd));
cd_0(yr,g) = sum(fdmap(fd,'c'), fd_0(yr,g,fd));

yh0_(yr,r,s) = fs_0(yr,s) * region_shr(yr,r,s);
fe0_(yr,r) = sum(s, va0_(yr,r,s));

* Use PCE and government demand data rather than region_shr:

cd0_(yr,r,g) = pce_shr(yr,r,g) * cd_0(yr,g);
g0_(yr,r,g) = sgf_shr(yr,r,g) * g_0(yr,g);
i0_(yr,r,g) = region_shr(yr,r,g) * i_0(yr,g);
c0_(yr,r) = sum(g, cd0_(yr,r,g));


* --------------------------------------------------------------------------
* Trade parameters:
* --------------------------------------------------------------------------

parameter
    m0_(yr,r,g) 	Foreign Imports,
    md0_(yr,r,m,g) 	Margin demand,
    ms0_(yr,r,s,m) 	Margin supply,
    x0_(yr,r,g) 	Foreign Exports,
    s0_(yr,r,g) 	Total supply,
    bopdef0_(yr,r) 	Balance of payments (closure parameter),
    a0_(yr,r,g) 	Domestic absorption,
    tm0_(yr,r,g) 	Import taxes,
    ta0_(yr,r,g) 	Absorption taxes,
    tr0a_(yr,r,g) 	Tax revenue from output,
    tr0m_(yr,r,g) 	Tax revenue on imports,
    rx0_(yr,r,g) 	Re-exports;

* Use export shares from USA Trade Online for included sectors. For those
* not included, use gross state product shares:

set
    notrd(yr,g) 	Goods not included in trade data;

notrd(yr,g) = yes$(not sum(r, usatrd_shr(yr,r,g,'exports')));
x0_(yr,r,g) = usatrd_shr(yr,r,g,'exports') * x_0(yr,g);
x0_(yr,r,g)$notrd(yr,g) = region_shr(yr,r,g) * x_0(yr,g);

* No longer subtracting margin supply from gross output. This will be allocated
* through the national and local markets.

s0_(yr,r,g) = sum(s, ys0_(yr,r,s,g)) + yh0_(yr,r,g);
a0_(yr,r,g) = cd0_(yr,r,g) + g0_(yr,r,g) + i0_(yr,r,g) + sum(s, id0_(yr,r,g,s));

tm0_(yr,r,g) = tm_0(yr,g);
ta0_(yr,r,g) = ta_0(yr,g);

parameter
    thetaa(yr,r,g) 	Share of regional absorption;

thetaa(yr,r,g)$sum(r.local, (1-ta0_(yr,r,g))*a0_(yr,r,g)) = a0_(yr,r,g) / sum(r.local, a0_(yr,r,g));
m0_(yr,r,g) = thetaa(yr,r,g) * m_0(yr,g);
md0_(yr,r,m,g) = thetaa(yr,r,g) * md_0(yr,m,g);

* Note that s0_ - x0_ is negative for the other category. md0 is zero for that
* category and: a + x = s + m. This means that some part of the other goods
* imports are directly re-exported. Note, re-exports are defined as the maximum
* between s0_-x0_ and the zero profit condition for the Armington
* composite. This is due to balancing issues when defining domestic and national
* demands. Particularly in the other goods sector which is a composite of the
* "fudge" factor in the national IO accounts.

rx0_(yr,r,g)$(round(s0_(yr,r,g) - x0_(yr,r,g),10) < 0) = x0_(yr,r,g) - s0_(yr,r,g);

* The 'oth' and 'use' sectors are problematic with negative numbers (removed
* from the dataset in previous steps).

parameter
    diff 	Negative numbers still exist due to sharing parameter;

diff(yr,r,g) = - min(round((1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) -
                        ((1+tm0_(yr,r,g))*m0_(yr,r,g) + sum(m, md0_(yr,r,m,g))),10), 0);

* Initial level of rx0_ makes the armington supply zero profit condition
* negative meaning it is too small (imports + margins > supply +
* re-exports). Adjust rx0_ upward for these enough to make these conditions
* zeroed out. Then subsequently adjust parameters through the circular economy.

rx0_(yr,r,g) = rx0_(yr,r,g) + diff(yr,r,g);
x0_(yr,r,g) = x0_(yr,r,g) + diff(yr,r,g);
s0_(yr,r,g) = s0_(yr,r,g) + diff(yr,r,g);
yh0_(yr,r,g) = yh0_(yr,r,g) + diff(yr,r,g);
bopdef0_(yr,r) = sum(g, m0_(yr,r,g) - x0_(yr,r,g));

set
    gm(g) 	Commodities employed in margin supply;

gm(g) = yes$(sum((yr,m), ms_0(yr,g,m)) or sum((yr,m), md_0(yr,m,g)));

parameter
    xn0_(yr,r,g) 	Regional supply to national market,
    xd0_(yr,r,g) 	Regional supply to local market,
    dd0_(yr,r,g) 	Regional demand from local market,
    dd0min(yr,r,g) 	Minimum regional demand from local market,
    dd0max(yr,r,g) 	Maximum regional demand from local market,
    nd0_(yr,r,g) 	Regional demand from national marke,
    nd0min(yr,r,g) 	Minimum regional demand from national market,
    nd0max(yr,r,g) 	Maximum regional demand from national market,
    nm0_(yr,r,g,m) 	Margin demand from the national market,
    dm0_(yr,r,g,m) 	Margin supply from the local market;

* Assume domestic demand is defined by either the supply or demand side of the
* market. Maximum or minimum amound would depend on level of national imports
* and exports.

dd0max(yr,r,g) = min(round((1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) -
                        ((1+tm0_(yr,r,g))*m0_(yr,r,g) + sum(m, md0_(yr,r,m,g))),10),
                      round(s0_(yr,r,g) - (x0_(yr,r,g) - rx0_(yr,r,g)),10) );

nd0max(yr,r,g) = min(round((1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) -
                        ((1+tm0_(yr,r,g))*m0_(yr,r,g) + sum(m, md0_(yr,r,m,g))),10),
                      round(s0_(yr,r,g) - (x0_(yr,r,g) - rx0_(yr,r,g)),10) );

* We can subsequently define nd0min and xd0min as:

nd0min(yr,r,g) = (1-ta0_(yr,r,g))* a0_(yr,r,g) + rx0_(yr,r,g) -
    (dd0max(yr,r,g) + m0_(yr,r,g)*(1+tm0_(yr,r,g)) + sum(m,md0_(yr,r,m,g)));

dd0min(yr,r,g) = (1-ta0_(yr,r,g))* a0_(yr,r,g) + rx0_(yr,r,g) -
    (nd0max(yr,r,g) + m0_(yr,r,g)*(1+tm0_(yr,r,g)) + sum(m,md0_(yr,r,m,g)));

* The mixture of domestic vs. national demand in the absorption market is
* determined by regional purchase coefficients. Use estimates based on 2012
* Commodity Flow Survey data:

parameter
    rpc(yr,r,g) 	Regional purchase coefficients;

rpc(yr,r,g) = cfs_rpc(r,g);
dd0_(yr,r,g) = rpc(yr,r,g) * dd0max(yr,r,g);
nd0_(yr,r,g) = round((1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) -
    (dd0_(yr,r,g) + m0_(yr,r,g)*(1+tm0_(yr,r,g)) + sum(m,md0_(yr,r,m,g))),10);

* Assume margins come both from local and national production. Assign like
* dd0. Use information on national margin supply to enforce other identities.

parameter
    totmargsupply(yr,r,m,g) 	Designate total supply of margins,
    margshr(yr,r,m) 		Share of margin demand by region,
    shrtrd(yr,r,m,g) 		Share of margin total by margin type;

margshr(yr,r,m)$sum((g,rr), md0_(yr,rr,m,g)) = sum(g, md0_(yr,r,m,g)) / sum((g,rr), md0_(yr,rr,m,g));

totmargsupply(yr,r,m,g) = margshr(yr,r,m) * ms_0(yr,g,m);

shrtrd(yr,r,m,gm)$sum(m.local, totmargsupply(yr,r,m,gm)) =
    totmargsupply(yr,r,m,gm) / sum(m.local, totmargsupply(yr,r,m,gm));

dm0_(yr,r,gm,m) = min(rpc(yr,r,gm)*totmargsupply(yr,r,m,gm),
    shrtrd(yr,r,m,gm)*(s0_(yr,r,gm) - x0_(yr,r,gm) + rx0_(yr,r,gm) - dd0_(yr,r,gm)));

nm0_(yr,r,gm,m) = totmargsupply(yr,r,m,gm) - dm0_(yr,r,gm,m);

* Regional and national output must then be tied down as follows:

xd0_(yr,r,g) = sum(m, dm0_(yr,r,g,m)) + dd0_(yr,r,g);
xn0_(yr,r,g) = s0_(yr,r,g) + rx0_(yr,r,g) - xd0_(yr,r,g) - x0_(yr,r,g);

* Remove tiny numbers:

xd0_(yr,r,g)$(xd0_(yr,r,g) < 1e-8) = 0;
xn0_(yr,r,g)$(xn0_(yr,r,g) < 1e-8) = 0;
a0_(yr,r,g)$(a0_(yr,r,g) < 1e-8) = 0;


* --------------------------------------------------------------------------
* Check equilibrium conditions:
* --------------------------------------------------------------------------

parameter
    zp		Zero-profit condition check,
    mkt		Market-clearance condition check,
    ibal	Income-balance condition check;

zp(yr,r,s,'Y') = (1-ty0_(yr,r,s)) * sum(g, ys0_(yr,r,s,g)) - sum(g, id0_(yr,r,g,s)) - ld0_(yr,r,s) - kd0_(yr,r,s);
zp(yr,r,g,'A') = (1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) -
        (nd0_(yr,r,g) + dd0_(yr,r,g) + (1+tm0_(yr,r,g))*m0_(yr,r,g) + sum(m, md0_(yr,r,m,g)));
zp(yr,r,g,'X') = s0_(yr,r,g) - xd0_(yr,r,g) - xn0_(yr,r,g) - x0_(yr,r,g) + rx0_(yr,r,g);
zp(yr,r,m,'M') = sum(s, nm0_(yr,r,s,m) + dm0_(yr,r,s,m)) - sum(g, md0_(yr,r,m,g));

ibal(yr,r,'inc') = sum(s, va0_(yr,r,s) + yh0_(yr,r,s)) + bopdef0_(yr,r) - sum(s, g0_(yr,r,s) + i0_(yr,r,s));
ibal(yr,r,'taxrev') = sum(s, ta0_(yr,r,s) * a0_(yr,r,s) + tm0_(yr,r,s)*m0_(yr,r,s) + ty0_(yr,r,s)*sum(g, ys0_(yr,r,s,g)));
ibal(yr,r,'expend') = c0_(yr,r);
ibal(yr,r,'balance') = ibal(yr,r,'expend') - ibal(yr,r,'inc') - ibal(yr,r,'taxrev');
ibal(yr,'USA','balance') = sum(r, ibal(yr,r,'balance'));

* Need a household adjustment:

parameter
    hhadj_(yr,r) 	Household adjustment parameter;

hhadj_(yr,r) = ibal(yr,r,'balance');

ibal(yr,r,'inc') = ibal(yr,r,'inc') + hhadj_(yr,r);
ibal(yr,r,'balance') = ibal(yr,r,'expend') - ibal(yr,r,'inc') - ibal(yr,r,'taxrev');
ibal(yr,'USA','balance') = sum(r, ibal(yr,r,'balance'));

mkt(yr,r,g,'PA') = a0_(yr,r,g) -
        (sum(s, id0_(yr,r,g,s)) + cd0_(yr,r,g) + g0_(yr,r,g) + i0_(yr,r,g));
mkt(yr,'USA',g,'PN')$(not sameas(yr,'2015')) = sum(r, xn0_(yr,r,g)) - sum((r,m), nm0_(yr,r,g,m)) - sum(r, nd0_(yr,r,g));
mkt(yr,r,g,'PY') = sum(s, ys0_(yr,r,s,g)) + yh0_(yr,r,g) - s0_(yr,r,g);
mkt(yr,'USA','all','PFX') = sum(r, sum(s, x0_(yr,r,s)) + hhadj_(yr,r) + bopdef0_(yr,r) - sum(s, m0_(yr,r,s)));
display zp, ibal, mkt;

* -------------------------------------------------------------------
* Verify there are no negative numbers for %year%:
* -------------------------------------------------------------------

parameter
    negnum 	Check on negative numbers;

negnum('ys0') = smin((r,g,s), ys0_("%year%",r,s,g));
negnum('id0') = smin((r,s,g), id0_("%year%",r,g,s));
negnum('ld0') = smin((r,s), ld0_("%year%",r,s));
negnum('kd0') = smin((r,s), kd0_("%year%",r,s));
negnum('m0') = smin((r,g), m0_("%year%",r,g));
negnum('x0') = smin((r,g), x0_("%year%",r,g));
negnum('rx0') = smin((r,g), rx0_("%year%",r,g));
negnum('x0-rx0') = smin((r,g), x0_("%year%",r,g) - rx0_("%year%",r,g));
negnum('md0') = smin((r,m,gm), md0_("%year%",r,m,gm));
negnum('nm0') = smin((r,m,gm), nm0_("%year%",r,gm,m));
negnum('dm0') = smin((r,m,gm), dm0_("%year%",r,gm,m));
negnum('s0') = smin((r,g), s0_("%year%",r,g));
negnum('a0') = smin((r,g), a0_("%year%",r,g));
negnum('cd0') = smin((r,g), cd0_("%year%",r,g));
negnum('c0') = smin((r), c0_("%year%",r));
negnum('yh0') = smin((r,g), yh0_("%year%",r,g));
negnum('g0') = smin((r,g), g0_("%year%",r,g));
negnum('i0') = smin((r,g), i0_("%year%",r,g));
negnum('xn0') = smin((r,g), xn0_("%year%",r,g));
negnum('xd0') = smin((r,g), xd0_("%year%",r,g));
negnum('dd0') = smin((r,g), dd0_("%year%",r,g));
negnum('nd0') = smin((r,g), nd0_("%year%",r,g));
display negnum;

alias(p,*);

abort$(round(smin(p, negnum(p)),6) < 0) "Negative numbers exist in regionalized parameters.";


* -------------------------------------------------------------------
* Check microconsistency in a regional accounting model for %year%:
* -------------------------------------------------------------------

$include statemodel.gms
statemodel.workspace = 100;
statemodel.iterlim = 0;
$include STATEMODEL.GEN

solve statemodel using mcp;
abort$(statemodel.objval > 1e-5) "Error in benchmark calibration with regional data.";


* -------------------------------------------------------------------
* Verify GDP consistency in income and expenditure approaches
* -------------------------------------------------------------------

set
    agt		GDP agents in reference model
    		/ C /,
    cat		GDP categories
    		/ C, "I+G", "X-M", L, K, TAX, OTH /;

parameter
    refbudget(yr,*,r,*,*)	Reference budget balance,
    refgdp(yr,*,*,*)		GDP totals by category,
    chkgdp(yr,*,*)		Verification of budget balance,
    gdp0_(yr,r)			Aggregate GDP;


* Allocate expenditures and incomes

refbudget(yr,'expend',r,'C','pc') = c0_(yr,r);

refbudget(yr,'expend',r,'C','pa') = sum(g, i0_(yr,r,g)) + sum(g, g0_(yr,r,g));

refbudget(yr,'income',r,'C','tax') =
    sum(g, ta0_(yr,r,g) * a0_(yr,r,g)) + sum(g, tm0_(yr,r,g)*m0_(yr,r,g)) +
    sum(s, ty0_(yr,r,s)*sum(g, ys0_(yr,r,s,g)));

refbudget(yr,'income',r,'C','py') = sum(g, yh0_(yr,r,g));
refbudget(yr,'income',r,'C','pl') = sum(s, ld0_(yr,r,s));
refbudget(yr,'income',r,'C','pk') = sum(s, kd0_(yr,r,s));
refbudget(yr,'income',r,'C','pfx') = hhadj_(yr,r) + bopdef0_(yr,r);

alias(un,*);

refbudget(yr,"total",r,agt,"chksum") =
    sum(un, refbudget(yr,"expend",r,agt,un)-refbudget(yr,"income",r,agt,un));

* Expenditure approach. Net exports are determined via transfers denominated as
* foreign exchange and through balance of payments.

refgdp(yr,"expend",r,"C") = refbudget(yr,"expend",r,'C',"pc");
refgdp(yr,"expend",r,"I+G") = refbudget(yr,'expend',r,'C','pa');
refgdp(yr,"expend",r,"X-M") = - refbudget(yr,'income',r,'C','pfx');

* Income approach:

refgdp(yr,"income",r,"L") = refbudget(yr,'income',r,'C','pl');
refgdp(yr,"income",r,"K") = refbudget(yr,'income',r,'C','pk');
refgdp(yr,"income",r,"TAX") = refbudget(yr,'income',r,'C','tax');
refgdp(yr,"income",r,"OTH") = refbudget(yr,'income',r,'C','py');

* Production (value added) approach:

refgdp(yr,'va',r,s) = ld0_(yr,r,s) + kd0_(yr,r,s) +
    ty0_(yr,r,s) * sum(g, ys0_(yr,r,s,g)) + ta0_(yr,r,s)*a0_(yr,r,s) +
    tm0_(yr,r,s)*m0_(yr,r,s);

* Calculate regional and national totals:

refgdp(yr,'expend',r,'total') = sum(cat, refgdp(yr,'expend',r,cat));
refgdp(yr,'expend','total',un) = sum(r, refgdp(yr,'expend',r,un));
refgdp(yr,'expend','total','total') = sum(cat, refgdp(yr,'expend','total',cat));

refgdp(yr,'income',r,'total') = sum(cat, refgdp(yr,'income',r,cat));
refgdp(yr,'income','total',un) = sum(r, refgdp(yr,'income',r,un));
refgdp(yr,'income','total','total') = sum(cat, refgdp(yr,'income','total',cat));

refgdp(yr,'va',r,'total') = sum(s, refgdp(yr,'va',r,s));
refgdp(yr,'va','total','total') = sum(r, refgdp(yr,'va',r,'total'));

* Check totals match across methods:

chkgdp(yr,r,"expend") = sum(cat, refgdp(yr,"expend",r,cat));
chkgdp(yr,r,"income") = sum(cat, refgdp(yr,"income",r,cat));
chkgdp(yr,r,"va") = refgdp(yr,"va",r,"total");
chkgdp(yr,r,"chksum") = chkgdp(yr,r,"expend") - chkgdp(yr,r,"income");
chkgdp(yr,'total','chksum') = sum(r, chkgdp(yr,r,'chksum'));
abort$(smax(yr, abs(chkgdp(yr,'total','chksum'))) > 1e-6) "Error in GDP consistency.";

* Report total GDP by region and add to database

gdp0_(yr,r) = refgdp(yr,'expend',r,'total');


* -------------------------------------------------------------------
* Output regionalized dataset:
* -------------------------------------------------------------------

* We include _ at the end of each parameter name to indicate all years of data
* are included.

EXECUTE_UNLOAD '%ds%.gdx'

* Sets:

yr,r,s,m,gm,

* Production data:

ys0_,ld0_,kd0_,id0_,ty0_,

* Consumption data:

yh0_,fe0_,cd0_,c0_,i0_,g0_,bopdef0_,hhadj_,

* Trade data:

s0_,xd0_,xn0_,x0_,rx0_,a0_,nd0_,dd0_,m0_,ta0_,tm0_,

* Margins:

md0_,nm0_,dm0_,

* GDP:

gdp0_;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
