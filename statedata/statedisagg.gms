$title State disaggregation of national accounts

set	yr	/1997*2023/;

set	r	Regions /	
	USA	Nation
	AL	"Alabama",
	AK	"Alaska",
	AR	"Arizona",
	AZ	"Arkansas",
	CA	"California",
	CO	"Colorado",
	CT	"Connecticut",
	DC	"District of Columbia",
	DE	"Delaware",
	FL	"Florida",
	GA	"Georgia",
	HI	"Hawaii",
	IA	"Iowa",
	ID	"Idaho",
	IL	"Illinois",
	IN	"Indiana",
	KS	"Kansas",
	KY	"Kentucky",
	LA	"Louisiana",
	MA	"Massachusetts",
	MD	"Maryland",	
	ME	"Maine",
	MI	"Michigan",
	MN	"Minnesota",
	MO	"Missouri",
	MS	"Mississippi",	
	MT	"Montana",
	NC	"North Carolina",
	ND	"North Dakota",
	NE	"Nebraska",
	NH	"New Hampshire",
	NJ	"New Jersey",
	NM	"New Mexico",
	NV	"Nevada",
	NY	"New York",
	OH	"Ohio",
	OK	"Oklahoma",
	OR	"Oregon",
	PA	"Pennsylvania",
	RI	"Rhode Island",
	SC	"South Carolina",
	SD	"South Dakota",
	TN	"Tennessee",
	TX	"Texas",
	UT	"Utah",
	VA	"Virginia",
	VT	"Vermont",
	WA	"Washington",
	WV	"West Virginia",
	WI	"Wisconsin",
	WY	"Wyoming"/

* ------------------------------------------------------------------------------
* Read in the national dataset:
* ------------------------------------------------------------------------------

$onUNDF
$include ..\bea_IO\beadata

* ------------------------------------------------------------------------------
* Read in shares generated using state level gross product, pce, faf,
* and government expenditures:
* ------------------------------------------------------------------------------

set	sagdptbl /
	t1	State annual gross domestic product (GDP) summary
	t2	Gross domestic product (GDP) by state
	t3	Taxes on production and imports less subsidies
	t4	Compensation of employees
	t5	Subsidies
	t6	Taxes on production and imports
	t7	Gross operating surplus
	t8	Chain-type quantity indexes for real GDP by state (2017=100.0)
	t9	Real GDP by state
	t11	Contributions to percent change in real GDP /

parameter	sagdp(r,s,yr,sagdptbl)	State Annual GDP dataset;
$gdxin 'sagdp.gdx'
$loaddc sagdp

$exit

set	sapce_tbl /
	sapce1	Personal consumption expenditures (PCE) by major type of product
	sapce2	Per capita personal consumption expenditures (PCE) by major type of product
	sapce3	Personal consumption expenditures (PCE) by state by type of product
	sapce4	Personal consumption expenditures (PCE) by state by function /;

parameter	sapce(r,s,yr,sapce_tbl)	State Annual GDP dataset;
$gdxin sapce 
$loaddc sapce


parameter
    region_shr(yr,r,s)		Regional shares based on GSP,
    labor_shr(yr,r,s)		Labor share of GSP,
    pce_shr(yr,r,g)		Regional shares based on PCE,
    sgf_shr(yr,r,g)		Regional government expenditure shares (SGF),
    usatrd_shr(yr,r,g,*)	Regional export-import shares based on USA Trade Online;

* GDX existance test for UNIX
$if not exist "%gdxdir%shares_pce.gdx" abort "File shares_pce.gdx does not exist"
$if not exist "%gdxdir%shares_sgf.gdx" abort "File shares_sgf.gdx does not exist"
$if not exist "%gdxdir%faf_rpcs.gdx" abort "File faf_rpcs.gdx does not exist"
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

$gdxin %gdxdir%faf_rpcs.gdx
$load faf_rpc=rpc
$gdxin

$gdxin %gdxdir%shares_usatrd.gdx
$load usatrd_shr
$gdxin

* Relate years of data to available trade shares

usatrd_shr(yr,r,g,'exports')$(yr.val<2002 and not sameas(g,'agr')) = usatrd_shr('2002',r,g,'exports');
usatrd_shr(yr,r,g,'exports')$(yr.val<2000 and sameas(g,'agr')) = usatrd_shr('2000',r,g,'exports');
usatrd_shr(yr,r,g,'imports')$(yr.val<2002) = usatrd_shr('2002',r,g,'imports');

* Verify all shares both sum to 1 and are in [0,1]:

parameter
    shrverify 	Verify consistent shares;

shrverify(yr,g,'PCE','max') = smax(r, pce_shr(yr,r,g));
shrverify(yr,g,'SGF','max') = smax(r, sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','max') = smax(r, region_shr(yr,r,g));
shrverify(yr,g,'LABOR','max') = smax(r, labor_shr(yr,r,g));
shrverify(yr,g,'RPC','max') = smax(r, faf_rpc(yr,r,g));
shrverify(yr,g,'XPT','max') = smax(r, usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','max') = smax(r, usatrd_shr(yr,r,g,'imports'));

shrverify(yr,g,'PCE','min') = smin(r$pce_shr(yr,r,g), pce_shr(yr,r,g));
shrverify(yr,g,'SGF','min') = smin(r$sgf_shr(yr,r,g), sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','min') = smin(r$region_shr(yr,r,g), region_shr(yr,r,g));
shrverify(yr,g,'LABOR','min') = smin(r$labor_shr(yr,r,g), labor_shr(yr,r,g));
shrverify(yr,g,'RPC','min') = smin(r$faf_rpc(yr,r,g), faf_rpc(yr,r,g));
shrverify(yr,g,'XPT','min') = smin(r$usatrd_shr(yr,r,g,'exports'), usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','min') = smin(r$usatrd_shr(yr,r,g,'imports'), usatrd_shr(yr,r,g,'imports'));

shrverify(yr,g,'PCE','sum') = sum(r, pce_shr(yr,r,g));
shrverify(yr,g,'SGF','sum') = sum(r, sgf_shr(yr,r,g));
shrverify(yr,g,'GSP','sum') = sum(r, region_shr(yr,r,g));
shrverify(yr,g,'XPT','sum') = sum(r, usatrd_shr(yr,r,g,'exports'));
shrverify(yr,g,'IMP','sum') = sum(r, usatrd_shr(yr,r,g,'imports'));
display shrverify;

    
* ------------------------------------------------------------------------------
* Regionalize production data using iomacro shares and GSP data:
* ------------------------------------------------------------------------------

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


* ------------------------------------------------------------------------------
* Final demand categories:
* ------------------------------------------------------------------------------

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


* -------------------------------------------------------------------------------------
* Trade parameters:
* -------------------------------------------------------------------------------------

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

rpc(yr,r,g) = faf_rpc(yr,r,g);
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


* -------------------------------------------------------------------------------------
* Check equilibrium conditions:
* -------------------------------------------------------------------------------------

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
    hhadj0_(yr,r) 	Household adjustment parameter;

hhadj0_(yr,r) = ibal(yr,r,'balance');

ibal(yr,r,'inc') = ibal(yr,r,'inc') + hhadj0_(yr,r);
ibal(yr,r,'balance') = ibal(yr,r,'expend') - ibal(yr,r,'inc') - ibal(yr,r,'taxrev');
ibal(yr,'USA','balance') = sum(r, ibal(yr,r,'balance'));

mkt(yr,r,g,'PA') = a0_(yr,r,g) -
        (sum(s, id0_(yr,r,g,s)) + cd0_(yr,r,g) + g0_(yr,r,g) + i0_(yr,r,g));
mkt(yr,'USA',g,'PN')$(not sameas(yr,'2015')) = sum(r, xn0_(yr,r,g)) - sum((r,m), nm0_(yr,r,g,m)) - sum(r, nd0_(yr,r,g));
mkt(yr,r,g,'PY') = sum(s, ys0_(yr,r,s,g)) + yh0_(yr,r,g) - s0_(yr,r,g);
mkt(yr,'USA','all','PFX') = sum(r, sum(s, x0_(yr,r,s)) + hhadj0_(yr,r) + bopdef0_(yr,r) - sum(s, m0_(yr,r,s)));
display zp, ibal, mkt;


* ------------------------------------------------------------------------------
* Verify there are no negative numbers for %year%:
* ------------------------------------------------------------------------------

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


* ------------------------------------------------------------------------------
* Check microconsistency in a regional accounting model for %year%:
* ------------------------------------------------------------------------------

$include statemodel.gms
statemodel.workspace = 100;
statemodel.iterlim = 0;
$include STATEMODEL.GEN

solve statemodel using mcp;
abort$(statemodel.objval > 1e-5) "Error in benchmark calibration with regional data.";


* ------------------------------------------------------------------------------
* Verify GDP consistency in income and expenditure approaches
* ------------------------------------------------------------------------------

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
refbudget(yr,'income',r,'C','pfx') = hhadj0_(yr,r) + bopdef0_(yr,r);

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


* ------------------------------------------------------------------------------
* Output regionalized dataset:
* ------------------------------------------------------------------------------

* We include _ at the end of each parameter name to indicate all years of data
* are included.

execute_unload '%ds%.gdx'

* Sets:

yr,r,s,m,gm,

* Production data:

ys0_,ld0_,kd0_,id0_,ty0_,

* Consumption data:

yh0_,fe0_,cd0_,c0_,i0_,g0_,bopdef0_,hhadj0_,

* Trade data:

s0_,xd0_,xn0_,x0_,rx0_,a0_,nd0_,dd0_,m0_,ta0_,tm0_,

* Margins:

md0_,nm0_,dm0_,

* GDP:

gdp0_;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------

	     osd_agr	"Oilseed farming (1111A0)"
	     grn_agr	"Grain farming (1111B0)"
	     veg_agr	"Vegetable and melon farming (111200)"
	     nut_agr	"Fruit and tree nut farming (111300)"
	     flo_agr	"Greenhouse, nursery, and floriculture production (111400)"
	     oth_agr	"Other crop farming (111900)"
	     bef_agr	"Beef cattle ranching and farming, including feedlots and dual-purpose ranching and farming (1121A0)"
	     dry_agr	"Dairy cattle and milk production (112120)"
	     ota_agr	"Animal production, except cattle and poultry and eggs (112A00)"
	     egg_agr	"Poultry and egg production (112300)"
	     log_fof	"Forestry and logging (113000)"
	     fht_fof	"Fishing, hunting and trapping (114000)"
	     saf_fof	"Support activities for agriculture and forestry (115000)"
	     oil	"Oil and gas extraction (211000)"
	     col_min	"Coal mining (212100)"
	     ore_min	"Iron, gold, silver, and other metal ore mining (2122A0)"
	     led_min	"Copper, nickel, lead, and zinc mining (212230)"
	     stn_min	"Stone mining and quarrying (212310)"
	     oth_min	"Other nonmetallic mineral mining and quarrying (2123A0)"
	     drl_smn	"Drilling oil and gas wells (213111)"
	     oth_smn	"Other support activities for mining (21311A)"
	     ele_uti	"Electric power generation, transmission, and distribution (221100)"
	     gas_uti	"Natural gas distribution (221200)"
	     wat_uti	"Water, sewage and other systems (221300)"
	     nmr_con	"Nonresidential maintenance and repair (230301)"
	     rmr_con	"Residential maintenance and repair (230302)"
	     hcs_con	"Health care structures (233210)"
	     mfs_con	"Manufacturing structures (233230)"
	     pwr_con	"Power and communication structures (233240)"
	     edu_con	"Educational and vocational structures (233262)"
	     off_con	"Office and commercial structures (2332A0)"
	     trn_con	"Transportation structures and highways and streets (2332C0)"
	     ons_con	"Other nonresidential structures (2332D0)"
	     srs_con	"Single-family residential structures (233411)"
	     mrs_con	"Multifamily residential structures (233412)"
	     ors_con	"Other residential structures (2334A0)"
	     dog_fbp	"Dog and cat food manufacturing (311111)"
	     oaf_fbp	"Other animal food manufacturing (311119)"
	     flr_fbp	"Flour milling and malt manufacturing (311210)"
	     wet_fbp	"Wet corn milling (311221)"
	     soy_fbp	"Soybean and other oilseed processing (311224)"
	     fat_fbp	"Fats and oils refining and blending (311225)"
	     brk_fbp	"Breakfast cereal manufacturing (311230)"
	     sug_fbp	"Sugar and confectionery product manufacturing (311300)"
	     fzn_fbp	"Frozen food manufacturing (311410)"
	     can_fbp	"Fruit and vegetable canning, pickling, and drying (311420)"
	     mlk_fbp	"Fluid milk and butter manufacturing (31151A)"
	     chs_fbp	"Cheese manufacturing (311513)"
	     dry_fbp	"Dry, condensed, and evaporated dairy product manufacturing (311514)"
	     ice_fbp	"Ice cream and frozen dessert manufacturing (311520)"
	     asp_fbp	"Animal (except poultry) slaughtering, rendering, and processing (31161A)"
	     chk_fbp	"Poultry processing (311615)"
	     sea_fbp	"Seafood product preparation and packaging (311700)"
	     brd_fbp	"Bread and bakery product manufacturing (311810)"
	     cok_fbp	"Cookie, cracker, pasta, and tortilla manufacturing (3118A0)"
	     snk_fbp	"Snack food manufacturing (311910)"
	     tea_fbp	"Coffee and tea manufacturing (311920)"
	     syr_fbp	"Flavoring syrup and concentrate manufacturing (311930)"
	     spc_fbp	"Seasoning and dressing manufacturing (311940)"
	     ofm_fbp	"All other food manufacturing (311990)"
	     pop_fbp	"Soft drink and ice manufacturing (312110)"
	     ber_fbp	"Breweries (312120)"
	     wne_fbp	"Wineries (312130)"
	     why_fbp	"Distilleries (312140)"
	     cig_fbp	"Tobacco manufacturing (312200)"
	     fyt_tex	"Fiber, yarn, and thread mills (313100)"
	     fml_tex	"Fabric mills (313200)"
	     txf_tex	"Textile and fabric finishing and fabric coating mills (313300)"
	     rug_tex	"Carpet and rug mills (314110)"
	     lin_tex	"Curtain and linen mills (314120)"
	     otp_tex	"Other textile product mills (314900)"
	     app_alt	"Apparel manufacturing (315000)"
	     lea_alt	"Leather and allied product manufacturing (316000)"
	     saw_wpd	"Sawmills and wood preservation (321100)"
	     ven_wpd	"Veneer, plywood, and engineered wood product manufacturing (321200)"
	     mil_wpd	"Millwork (321910)"
	     owp_wpd	"All other wood product manufacturing (3219A0)"
	     plp_ppd	"Pulp mills (322110)"
	     ppm_ppd	"Paper mills (322120)"
	     pbm_ppd	"Paperboard mills (322130)"
	     pbc_ppd	"Paperboard container manufacturing (322210)"
	     ppb_ppd	"Paper bag and coated and treated paper manufacturing (322220)"
	     sta_ppd	"Stationery product manufacturing (322230)"
	     toi_ppd	"Sanitary paper product manufacturing (322291)"
	     opp_ppd	"All other converted paper product manufacturing (322299)"
	     pri_pri	"Printing (323110)"
	     sap_pri	"Support activities for printing (323120)"
	     ref_pet	"Petroleum refineries (324110)"
	     pav_pet	"Asphalt paving mixture and block manufacturing (324121)"
	     shn_pet	"Asphalt shingle and coating materials manufacturing (324122)"
	     oth_pet	"Other petroleum and coal products manufacturing (324190)"
	     ptr_che	"Petrochemical manufacturing (325110)"
	     igm_che	"Industrial gas manufacturing (325120)"
	     sdp_che	"Synthetic dye and pigment manufacturing (325130)"
	     obi_che	"Other basic inorganic chemical manufacturing (325180)"
	     obo_che	"Other basic organic chemical manufacturing (325190)"
	     pmr_che	"Plastics material and resin manufacturing (325211)"
	     srf_che	"Synthetic rubber and artificial and synthetic fibers and filaments manufacturing (3252A0)"
	     fmf_che	"Fertilizer manufacturing (325310)"
	     pag_che	"Pesticide and other agricultural chemical manufacturing (325320)"
	     mbm_che	"Medicinal and botanical manufacturing (325411)"
	     phm_che	"Pharmaceutical preparation manufacturing (325412)"
	     inv_che	"In-vitro diagnostic substance manufacturing (325413)"
	     bio_che	"Biological product (except diagnostic) manufacturing (325414)"
	     pnt_che	"Paint and coating manufacturing (325510)"
	     adh_che	"Adhesive manufacturing (325520)"
	     sop_che	"Soap and cleaning compound manufacturing (325610)"
	     toi_che	"Toilet preparation manufacturing (325620)"
	     pri_che	"Printing ink manufacturing (325910)"
	     och_che	"All other chemical product and preparation manufacturing (3259A0)"
	     plm_pla	"Plastics packaging materials and unlaminated film and sheet manufacturing (326110)"
	     ppp_pla	"Plastics pipe, pipe fitting, and unlaminated profile shape manufacturing (326120)"
	     lam_pla	"Laminated plastics plate, sheet (except packaging), and shape manufacturing (326130)"
	     fom_pla	"Polystyrene foam product manufacturing (326140)"
	     ure_pla	"Urethane and other foam product (except polystyrene) manufacturing (326150)"
	     bot_pla	"Plastics bottle manufacturing (326160)"
	     opm_pla	"Other plastics product manufacturing (326190)"
	     tir_pla	"Tire manufacturing (326210)"
	     rbr_pla	"Rubber and plastics hoses and belting manufacturing (326220)"
	     orb_pla	"Other rubber product manufacturing (326290)"
	     cly_nmp	"Clay product and refractory manufacturing (327100)"
	     gla_nmp	"Glass and glass product manufacturing (327200)"
	     cmt_nmp	"Cement manufacturing (327310)"
	     cnc_nmp	"Ready-mix concrete manufacturing (327320)"
	     cpb_nmp	"Concrete pipe, brick, and block manufacturing (327330)"
	     ocp_nmp	"Other concrete product manufacturing (327390)"
	     lme_nmp	"Lime and gypsum product manufacturing (327400)"
	     abr_nmp	"Abrasive product manufacturing (327910)"
	     cut_nmp	"Cut stone and stone product manufacturing (327991)"
	     tmn_nmp	"Ground or treated mineral and earth manufacturing (327992)"
	     wol_nmp	"Mineral wool manufacturing (327993)"
	     mnm_nmp	"Miscellaneous nonmetallic mineral products (327999)"
	     irn_pmt	"Iron and steel mills and ferroalloy manufacturing (331110)"
	     stl_pmt	"Steel product manufacturing from purchased steel			 (331200)"
	     ala_pmt	"Alumina refining and primary aluminum production (331313)"
	     sme_pmt	"Secondary smelting and alloying of aluminum (331314)"
	     alu_pmt	"Aluminum product manufacturing from purchased aluminum (33131B)"
	     nms_pmt	"Nonferrous metal (except aluminum) smelting and refining (331410)"
	     cop_pmt	"Copper rolling, drawing, extruding and alloying (331420)"
	     nfm_pmt	"Nonferrous metal (except copper and aluminum) rolling, drawing, extruding and alloying (331490)"
	     fmf_pmt	"Ferrous metal foundries (331510)"
	     nff_pmt	"Nonferrous metal foundries (331520)"
	     fss_fmt	"All other forging, stamping, and sintering (33211A)"
	     rol_fmt	"Custom roll forming (332114)"
	     crn_fmt	"Metal crown, closure, and other metal stamping (except automotive) (332119)"
	     cut_fmt	"Cutlery and handtool manufacturing (332200)"
	     plt_fmt	"Plate work and fabricated structural product manufacturing (332310)"
	     orn_fmt	"Ornamental and architectural metal products manufacturing (332320)"
	     pwr_fmt	"Power boiler and heat exchanger manufacturing (332410)"
	     mtt_fmt	"Metal tank (heavy gauge) manufacturing (332420)"
	     mtc_fmt	"Metal can, box, and other metal container (light gauge) manufacturing (332430)"
	     hdw_fmt	"Hardware manufacturing (332500)"
	     spr_fmt	"Spring and wire product manufacturing (332600)"
	     mch_fmt	"Machine shops (332710)"
	     tps_fmt	"Turned product and screw, nut, and bolt manufacturing (332720)"
	     ceh_fmt	"Coating, engraving, heat treating and allied activities (332800)"
	     vlv_fmt	"Valve and fittings other than plumbing (33291A)"
	     plb_fmt	"Plumbing fixture fitting and trim manufacturing (332913)"
	     bbr_fmt	"Ball and roller bearing manufacturing (332991)"
	     amn_fmt	"Ammunition, arms, ordnance, and accessories manufacturing (33299A)"
	     fab_fmt	"Fabricated pipe and pipe fitting manufacturing (332996)"
	     omf_fmt	"Other fabricated metal manufacturing (332999)"
	     frm_mch	"Farm machinery and equipment manufacturing (333111)"
	     lwn_mch	"Lawn and garden equipment manufacturing (333112)"
	     con_mch	"Construction machinery manufacturing (333120)"
	     min_mch	"Mining and oil and gas field machinery manufacturing (333130)"
	     smc_mch	"Semiconductor machinery manufacturing (333242)"
	     oti_mch	"Other industrial machinery manufacturing (33329A)"
	     opt_mch	"Optical instrument and lens manufacturing (333314)"
	     pht_mch	"Photographic and photocopying equipment manufacturing (333316)"
	     oci_mch	"Other commercial and service industry machinery manufacturing (333318)"
	     air_mch	"Industrial and commercial fan and blower and air purification equipment manufacturing (333413)"
	     hea_mch	"Heating equipment (except warm air furnaces) manufacturing (333414)"
	     acn_mch	"Air conditioning, refrigeration, and warm air heating equipment manufacturing (333415)"
	     imm_mch	"Industrial mold manufacturing (333511)"
	     mct_mch	"Machine tool manufacturing (333517)"
	     spt_mch	"Special tool, die, jig, and fixture manufacturing (333514)"
	     cut_mch	"Cutting and machine tool accessory, rolling mill, and other metalworking machinery manufacturing (33351B)"
	     tbn_mch	"Turbine and turbine generator set units manufacturing (333611)"
	     spd_mch	"Speed changer, industrial high-speed drive, and gear manufacturing (333612)"
	     mch_mch	"Mechanical power transmission equipment manufacturing (333613)"
	     oee_mch	"Other engine equipment manufacturing (333618)"
	     ppe_mch	"Pump and pumping equipment manufacturing (33391A)"
	     agc_mch	"Air and gas compressor manufacturing (333912)"
	     mat_mch	"Material handling equipment manufacturing (333920)"
	     pwr_mch	"Power-driven handtool manufacturing (333991)"
	     ogp_mch	"Other general purpose machinery manufacturing (33399A)"
	     pkg_mch	"Packaging machinery manufacturing (333993)"
	     ipf_mch	"Industrial process furnace and oven manufacturing (333994)"
	     fld_mch	"Fluid power process machinery (33399B)"
	     ecm_cep	"Electronic computer manufacturing (334111)"
	     csd_cep	"Computer storage device manufacturing (334112)"
	     ctm_cep	"Computer terminals and other computer peripheral equipment manufacturing (334118)"
	     tel_cep	"Telephone apparatus manufacturing (334210)"
	     brd_cep	"Broadcast and wireless communications equipment (334220)"
	     oce_cep	"Other communications equipment manufacturing (334290)"
	     aud_cep	"Audio and video equipment manufacturing (334300)"
	     oec_cep	"Other electronic component manufacturing (33441A)"
	     sem_cep	"Semiconductor and related device manufacturing (334413)"
	     prc_cep	"Printed circuit assembly (electronic assembly) manufacturing (334418)"
	     eea_cep	"Electromedical and electrotherapeutic apparatus manufacturing (334510)"
	     sdn_cep	"Search, detection, and navigation instruments manufacturing (334511)"
	     aec_cep	"Automatic environmental control manufacturing (334512)"
	     ipv_cep	"Industrial process variable instruments manufacturing (334513)"
	     tfl_cep	"Totalizing fluid meter and counting device manufacturing (334514)"
	     els_cep	"Electricity and signal testing instruments manufacturing (334515)"
	     ali_cep	"Analytical laboratory instrument manufacturing (334516)"
	     irr_cep	"Irradiation apparatus manufacturing (334517)"
	     wcm_cep	"Watch, clock, and other measuring and controlling device manufacturing (33451A)"
	     mmo_cep	"Manufacturing and reproducing magnetic and optical media (334610)"
	     elb_eec	"Electric lamp bulb and part manufacturing (335110)"
	     ltf_eec	"Lighting fixture manufacturing (335120)"
	     sea_eec	"Small electrical appliance manufacturing (335210)"
	     ham_eec	"Household cooking appliance manufacturing (335221)"
	     hrf_eec	"Household refrigerator and home freezer manufacturing (335222)"
	     hle_eec	"Household laundry equipment manufacturing (335224)"
	     osl_sle	"Other major household appliance manufacturing (335228)"
	     pwr_eec	"Power, distribution, and specialty transformer manufacturing (335311)"
	     mtg_eec	"Motor and generator manufacturing (335312)"
	     swt_eec	"Switchgear and switchboard apparatus manufacturing (335313)"
	     ric_eec	"Relay and industrial control manufacturing (335314)"
	     sbt_eec	"Storage battery manufacturing (335911)"
	     pbt_eec	"Primary battery manufacturing (335912)"
	     cme_eec	"Communication and energy wire and cable manufacturing (335920)"
	     wdv_eec	"Wiring device manufacturing (335930)"
	     cbn_eec	"Carbon and graphite product manufacturing (335991)"
	     oee_eec	"All other miscellaneous electrical equipment and component manufacturing (335999)"
	     atm_mot	"Automobile manufacturing (336111)"
	     ltr_mot	"Light truck and utility vehicle manufacturing (336112)"
	     htr_mot	"Heavy duty truck manufacturing (336120)"
	     mbd_mot	"Motor vehicle body manufacturing (336211)"
	     trl_mot	"Truck trailer manufacturing (336212)"
	     hom_mot	"Motor home manufacturing (336213)"
	     cam_mot	"Travel trailer and camper manufacturing (336214)"
	     gas_mot	"Motor vehicle gasoline engine and engine parts manufacturing (336310)"
	     eee_mot	"Motor vehicle electrical and electronic equipment manufacturing (336320)"
	     brk_mot	"Motor vehicle steering, suspension component (except spring), and brake systems manufacturing (3363A0)"
	     tpw_mot	"Motor vehicle transmission and power train parts manufacturing (336350)"
	     trm_mot	"Motor vehicle seating and interior trim manufacturing (336360)"
	     stm_mot	"Motor vehicle metal stamping (336370)"
	     omv_mot	"Other motor vehicle parts manufacturing (336390)"
	     air_ote	"Aircraft manufacturing (336411)"
	     aen_ote	"Aircraft engine and engine parts manufacturing (336412)"
	     oar_ote	"Other aircraft parts and auxiliary equipment manufacturing (336413)"
	     mis_ote	"Guided missile and space vehicle manufacturing (336414)"
	     pro_ote	"Propulsion units and parts for space vehicles and guided missiles (33641A)"
	     rrd_ote	"Railroad rolling stock manufacturing (336500)"
	     shp_ote	"Ship building and repairing (336611)"
	     bot_ote	"Boat building (336612)"
	     mcl_ote	"Motorcycle, bicycle, and parts manufacturing (336991)"
	     mlt_ote	"Military armored vehicle, tank, and tank component manufacturing (336992)"
	     otm_ote	"All other transportation equipment manufacturing (336999)"
	     cab_fpd	"Wood kitchen cabinet and countertop manufacturing (337110)"
	     uph_fpd	"Upholstered household furniture manufacturing (337121)"
	     nup_fpd	"Nonupholstered wood household furniture manufacturing (337122)"
	     ohn_fpd	"Other household nonupholstered furniture (33712N)"
	     ifm_fpd	"Institutional furniture manufacturing (337127)"
	     off_fpd	"Office furniture and custom architectural woodwork and millwork manufacturing (33721A)"
	     shv_fpd	"Showcase, partition, shelving, and locker manufacturing (337215)"
	     ofp_fpd	"Other furniture related product manufacturing (337900)"
	     smi_mmf	"Surgical and medical instrument manufacturing (339112)"
	     sas_mmf	"Surgical appliance and supplies manufacturing (339113)"
	     dnt_mmf	"Dental equipment and supplies manufacturing (339114)"
	     oph_mmf	"Ophthalmic goods manufacturing (339115)"
	     dlb_mmf	"Dental laboratories (339116)"
	     jwl_mmf	"Jewelry and silverware manufacturing (339910)"
	     ath_mmf	"Sporting and athletic goods manufacturing (339920)"
	     toy_mmf	"Doll, toy, and game manufacturing (339930)"
	     ofm_mmf	"Office supplies (except paper) manufacturing (339940)"
	     sgn_mmf	"Sign manufacturing (339950)"
	     omm_mmf	"All other miscellaneous manufacturing (339990)"
	     mtv_wht	"Motor vehicle and motor vehicle parts and supplies (423100)"
	     pce_wht	"Professional and commercial equipment and supplies (423400)"
	     hha_wht	"Household appliances and electrical and electronic goods (423600)"
	     mch_wht	"Machinery, equipment, and supplies (423800)"
	     odg_wht	"Other durable goods merchant wholesalers (423A00)"
	     dru_wht	"Drugs and druggists' sundries (424200)"
	     gro_wht	"Grocery and related product wholesalers (424400)"
	     pet_wht	"Petroleum and petroleum products (424700)"
	     ndg_wht	"Other nondurable goods merchant wholesalers (424A00)"
	     ele_wht	"Wholesale electronic markets and agents and brokers (425000)"
	     dut_wht	"Customs duties (4200ID)"
	     mvt	"Motor vehicle and parts dealers (441000)"
	     fbt	"Food and beverage stores (445000)"
	     gmt	"General merchandise stores (452000)"
	     bui_ott	"Building material and garden equipment and supplies dealers (444000)"
	     hea_ott	"Health and personal care stores (446000)"
	     gas_ott	"Gasoline stations (447000)"
	     clo_ott	"Clothing and clothing accessories stores (448000)"
	     non_ott	"Nonstore retailers (454000)"
	     oth_ott	"All other retail (4B0000)"
	     air	"Air transportation (481000)"
	     trn	"Rail transportation (482000)"
	     wtt_wtt	"Water transportation (483000)"
	     trk	"Truck transportation (484000)"
	     grd	"Transit and ground passenger transportation (485000)"
	     pip	"Pipeline transportation (486000)"
	     sce_otr	"Scenic and sightseeing transportation and support activities (48A000)"
	     mes_otr	"Couriers and messengers (492000)"
	     wrh_wrh	"Warehousing and storage (493000)"
	     new_pub	"Newspaper publishers (511110)"
	     pdl_pub	"Periodical publishers (511120)"
	     bok_pub	"Book publishers (511130)"
	     mal_pub	"Directory, mailing list, and other publishers (5111A0)"
	     sfw_pub	"Software publishers (511200)"
	     pic_mov	"Motion picture and video industries (512100)"
	     snd_mov	"Sound recording industries (512200)"
	     rad_brd	"Radio and television broadcasting (515100)"
	     cbl_brd	"Cable and other subscription programming (515200)"
	     wtl_brd	"Wired telecommunications carriers (517110)"
	     wls_brd	"Wireless telecommunications carriers (except satellite) (517210)"
	     sat_brd	"Satellite, telecommunications resellers, and all other telecommunications (517A00)"
	     dpr_dat	"Data processing, hosting, and related services (518200)"
	     new_dat	"News syndicates, libraries, archives and all other information services (5191A0)"
	     int_dat	"Internet publishing and broadcasting and Web search portals (519130)"
	     mon_bnk	"Monetary authorities and depository credit intermediation (52A000)"
	     cre_bnk	"Nondepository credit intermediation and related activities (522A00)"
	     com_sec	"Securities and commodity contracts intermediation and brokerage (523A00)"
	     ofi_sec	"Other financial investment activities (523900)"
	     dir_ins	"Direct life insurance carriers (524113)"
	     car_ins	"Insurance carriers, except direct life (5241XX)"
	     agn_ins	"Insurance agencies, brokerages, and related activities (524200)"
	     fin	"Funds, trusts, and other financial vehicles (525000)"
	     own_hou	"Owner-occupied housing (531HSO)"
	     rnt_hou	"Tenant-occupied housing (531HST)"
	     ORE	"Other real estate (531ORE)"
	     aut_rnt	"Automotive equipment rental and leasing (532100)"
	     cmg_rnt	"General and consumer goods rental (532A00)"
	     com_rnt	"Commercial and industrial machinery and equipment rental and leasing (532400)"
	     int_rnt	"Lessors of nonfinancial intangible assets (533000)"
	     leg	"Legal services (541100)"
	     acc_tsv	"Accounting, tax preparation, bookkeeping, and payroll services (541200)"
	     arc_tsv	"Architectural, engineering, and related services (541300)"
	     des_tsv	"Specialized design services (541400)"
	     mgt_tsv	"Management consulting services (541610)"
	     env_tsv	"Environmental and other technical consulting services (5416A0)"
	     sci_tsv	"Scientific research and development services (541700)"
	     adv_tsv	"Advertising, public relations, and related services (541800)"
	     mkt_tsv	"All other miscellaneous professional, scientific, and technical services (5419A0)"
	     pht_tsv	"Photographic services (541920)"
	     vet_tsv	"Veterinary services (541940)"
	     cus_com	"Custom computer programming services (541511)"
	     sys_com	"Computer systems design services (541512)"
	     ocs_com	"Other computer related services, including facilities management (54151A)"
	     man	"Management of companies and enterprises (550000)"
	     off_adm	"Office administrative services (561100)"
	     fac_adm	"Facilities support services (561200)"
	     emp_adm	"Employment services (561300)"
	     bsp_adm	"Business support services (561400)"
	     trv_adm	"Travel arrangement and reservation services (561500)"
	     inv_adm	"Investigation and security services (561600)"
	     dwe_adm	"Services to buildings and dwellings (561700)"
	     oss_adm	"Other support services (561900)"
	     wst_wst	"Waste management and remediation services (562000)"
	     sec_edu	"Elementary and secondary schools (611100)"
	     uni_edu	"Junior colleges, colleges, universities, and professional schools (611A00)"
	     oes_edu	"Other educational services (611B00)"
	     phy_amb	"Offices of physicians (621100)"
	     dnt_amb	"Offices of dentists (621200)"
	     ohp_amb	"Offices of other health practitioners (621300)"
	     out_amb	"Outpatient care centers (621400)"
	     lab_amb	"Medical and diagnostic laboratories (621500)"
	     hom_amb	"Home health care services (621600)"
	     oas_amb	"Other ambulatory health care services (621900)"
	     hos	"Hospitals (622000)"
	     ncc_nrs	"Nursing and community care facilities (623A00)"
	     res_nrs	"Residential mental health, substance abuse, and other residential care facilities (623B00)"
	     ifs_soc	"Individual and family services (624100)"
	     cmf_soc	"Community food, housing, and other relief services, including vocational rehabilitation services (624A00)"
	     day_soc	"Child day care services (624400)"
	     pfm_art	"Performing arts companies (711100)"
	     spr_art	"Spectator sports (711200)"
	     agt_art	"Promoters of performing arts and sports and agents for public figures (711A00)"
	     ind_art	"Independent artists, writers, and performers (711500)"
	     mus_art	"Museums, historical sites, zoos, and parks (712000)"
	     amu_rec	"Amusement parks and arcades (713100)"
	     cas_rec	"Gambling industries (except casino hotels) (713200)"
	     ori_rec	"Other amusement and recreation industries (713900)"
	     amd	"Accommodation (721000)"
	     ful_res	"Full-service restaurants (722110)"
	     lim_res	"Limited-service restaurants (722211)"
	     ofd_res	"All other food and drinking places (722A00)"
	     atr_osv	"Automotive repair and maintenance (including car washes) (811100)"
	     eqr_osv	"Electronic and precision equipment repair and maintenance (811200)"
	     imr_osv	"Commercial and industrial machinery and equipment repair and maintenance (811300)"
	     hgr_osv	"Personal and household goods repair and maintenance (811400)"
	     pcs_osv	"Personal care services (812100)"
	     fun_osv	"Death care services (812200)"
	     dry_osv	"Dry-cleaning and laundry services (812300)"
	     ops_osv	"Other personal services (812900)"
	     rel_osv	"Religious organizations (813100)"
	     grt_osv	"Grantmaking, giving, and social advocacy organizations (813A00)"
	     civ_osv	"Civic, social, professional, and similar organizations (813B00)"
	     prv_osv	"Private households (814000)"
	     fdd	"Federal general government (defense) (S00500)"
	     fnd	"Federal general government (nondefense) (S00600)"
	     pst_fen	"Postal service (491000)"
	     ele_fen	"Federal electric utilities (S00101)"
	     ofg_fen	"Other federal government enterprises (S00102)"
	     du_slg	"State and local government (educational services) (GSLGE)"
	     ea_slg	"State and local government (hospitals and health services) (GSLGH)"
	     th_slg	"State and local government (other services) (GSLGO)"
	     trn_sle	"State and local government passenger transit (S00201)"
	     ele_sle	"State and local government electric utilities (S00202)"
	     ent_sle	"Other state and local government enterprises (S00203)"
	     srp_usd	"Scrap (S00401)"
	     sec_usd	"Used and secondhand goods (S00402)"
	     imp_oth	"Noncomparable imports (S00300)"
	     rwa_oth	"Rest of the world adjustment (S00900)" /;
