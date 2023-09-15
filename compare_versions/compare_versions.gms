$title Release comparisons

* ------------------------------------------------------------------------------
* Read in new WiNDC database:
* ------------------------------------------------------------------------------

$set ds WiNDCdatabase_2021.gdx

set
    yr      Years of IO data,
    r       States,
    s       Goods and sectors from BEA,
    gm(s)   Margin related sectors,
    m       Margins (trade or transport);

$gdxin '%ds%'
$loaddc yr r s m gm
alias(s,g);

parameter
    ys0_(yr,r,g,s)  Sectoral supply,
    id0_(yr,r,s,g)  Intermediate demand,
    ld0_(yr,r,s)    Labor demand,
    kd0_(yr,r,s)    Capital demand,
    ty0_(yr,r,s)    Output tax on production,
    m0_(yr,r,s)     Imports,
    x0_(yr,r,s)     Exports of goods and services,
    rx0_(yr,r,s)    Re-exports of goods and services,
    md0_(yr,r,m,s)  Total margin demand,
    nm0_(yr,r,g,m)  Margin demand from national market,
    dm0_(yr,r,g,m)  Margin supply from local market,
    s0_(yr,r,s)     Aggregate supply,
    a0_(yr,r,s)     Armington supply,
    ta0_(yr,r,s)    Tax net subsidy rate on intermediate demand,
    tm0_(yr,r,s)    Import tariff,
    cd0_(yr,r,s)    Final demand,
    c0_(yr,r)       Aggregate final demand,
    yh0_(yr,r,s)    Household production,
    bopdef0_(yr,r)  Balance of payments,
    hhadj0_(yr,r)   Household adjustment,
    g0_(yr,r,s)     Government demand,
    i0_(yr,r,s)     Investment demand,
    xn0_(yr,r,g)    Regional supply to national market,
    xd0_(yr,r,g)    Regional supply to local market,
    dd0_(yr,r,g)    Regional demand from local  market,
    nd0_(yr,r,g)    Regional demand from national market;

* Production data:

$loaddc ys0_ ld0_ kd0_ id0_ ty0_

* Consumption data:

$loaddc yh0_ cd0_ c0_ i0_ g0_ bopdef0_ hhadj0_

* Trade data:

$loaddc s0_ xd0_ xn0_ x0_ rx0_ a0_ nd0_ dd0_ m0_ ta0_ tm0_

* Margins:

$loaddc md0_ nm0_ dm0_
$gdxin


* ------------------------------------------------------------------------------
* Read in old WiNDC database:
* ------------------------------------------------------------------------------

$set ds WiNDCdatabase_2017.gdx

parameter
    ys0_ref(yr,r,g,s)  Sectoral supply,
    id0_ref(yr,r,s,g)  Intermediate demand,
    ld0_ref(yr,r,s)    Labor demand,
    kd0_ref(yr,r,s)    Capital demand,
    ty0_ref(yr,r,s)    Output tax on production,
    m0_ref(yr,r,s)     Imports,
    x0_ref(yr,r,s)     Exports of goods and services,
    rx0_ref(yr,r,s)    Re-exports of goods and services,
    md0_ref(yr,r,m,s)  Total margin demand,
    nm0_ref(yr,r,g,m)  Margin demand from national market,
    dm0_ref(yr,r,g,m)  Margin supply from local market,
    s0_ref(yr,r,s)     Aggregate supply,
    a0_ref(yr,r,s)     Armington supply,
    ta0_ref(yr,r,s)    Tax net subsidy rate on intermediate demand,
    tm0_ref(yr,r,s)    Import tariff,
    cd0_ref(yr,r,s)    Final demand,
    c0_ref(yr,r)       Aggregate final demand,
    yh0_ref(yr,r,s)    Household production,
    bopdef0_ref(yr,r)  Balance of payments,
    hhadj0_ref(yr,r)   Household adjustment,
    g0_ref(yr,r,s)     Government demand,
    i0_ref(yr,r,s)     Investment demand,
    xn0_ref(yr,r,g)    Regional supply to national market,
    xd0_ref(yr,r,g)    Regional supply to local market,
    dd0_ref(yr,r,g)    Regional demand from local  market,
    nd0_ref(yr,r,g)    Regional demand from national market;

* Production data:

$gdxin '%ds%'
$loaddc ys0_ref=ys0_ ld0_ref=ld0_ kd0_ref=kd0_ id0_ref=id0_ ty0_ref=ty0_

* Consumption data:

$loaddc yh0_ref=yh0_ cd0_ref=cd0_ c0_ref=c0_ i0_ref=i0_ g0_ref=g0_ bopdef0_ref=bopdef0_ hhadj0_ref=hhadj0_

* Trade data:

$loaddc s0_ref=s0_ xd0_ref=xd0_ xn0_ref=xn0_ x0_ref=x0_ rx0_ref=rx0_ a0_ref=a0_ nd0_ref=nd0_ dd0_ref=dd0_ m0_ref=m0_ ta0_ref=ta0_ tm0_ref=tm0_

* Margins:

$loaddc md0_ref=md0_ nm0_ref=nm0_ dm0_ref=dm0_
$gdxin


* ------------------------------------------------------------------------------
* Compare core data
* ------------------------------------------------------------------------------

parameter
    disaggregate_comparison	Detailed comparison of datasets,
    sector_comparison		Sector changes in the data,
    region_comparison		Region changes in the data;

* disaggregate statistics

disaggregate_comparison(yr,r,s,'ys0','new') = sum(g, ys0_(yr,r,s,g));
disaggregate_comparison(yr,r,s,'ys0','old') = sum(g, ys0_ref(yr,r,s,g));
disaggregate_comparison(yr,r,s,'ys0','diff') = sum(g, ys0_(yr,r,s,g)) - sum(g, ys0_ref(yr,r,s,g));
disaggregate_comparison(yr,r,s,'id0','new') = sum(g, ys0_(yr,r,g,s));
disaggregate_comparison(yr,r,s,'id0','old') = sum(g, ys0_ref(yr,r,g,s));
disaggregate_comparison(yr,r,s,'id0','diff') = sum(g, ys0_(yr,r,g,s)) - sum(g, ys0_ref(yr,r,g,s));
disaggregate_comparison(yr,r,s,'ld0','new') = ld0_(yr,r,s);
disaggregate_comparison(yr,r,s,'ld0','old') = ld0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'ld0','diff') = ld0_(yr,r,s) - ld0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'kd0','new') = kd0_(yr,r,s);
disaggregate_comparison(yr,r,s,'kd0','old') = kd0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'kd0','diff') = kd0_(yr,r,s) - kd0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'ty0','new') = ty0_(yr,r,s);
disaggregate_comparison(yr,r,s,'ty0','old') = ty0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'ty0','diff') = ty0_(yr,r,s) - ty0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'m0','new') = m0_(yr,r,s);
disaggregate_comparison(yr,r,s,'m0','old') = m0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'m0','diff') = m0_(yr,r,s) - m0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'x0','new') = x0_(yr,r,s);
disaggregate_comparison(yr,r,s,'x0','old') = x0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'x0','diff') = x0_(yr,r,s) - x0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'rx0','new') = rx0_(yr,r,s);
disaggregate_comparison(yr,r,s,'rx0','old') = rx0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'rx0','diff') = rx0_(yr,r,s) - rx0_ref(yr,r,s);
disaggregate_comparison(yr,r,m,'md0','new') = sum(s, md0_(yr,r,m,s));
disaggregate_comparison(yr,r,m,'md0','old') = sum(s, md0_ref(yr,r,m,s));
disaggregate_comparison(yr,r,m,'md0','diff') = sum(s, md0_(yr,r,m,s)) - sum(s, md0_ref(yr,r,m,s));
disaggregate_comparison(yr,r,m,'nm0','new') = sum(g, nm0_(yr,r,g,m));
disaggregate_comparison(yr,r,m,'nm0','old') = sum(g, nm0_ref(yr,r,g,m));
disaggregate_comparison(yr,r,m,'nm0','diff') = sum(g, nm0_(yr,r,g,m)) - sum(g, nm0_ref(yr,r,g,m));
disaggregate_comparison(yr,r,m,'dm0','new') = sum(g, dm0_(yr,r,g,m));
disaggregate_comparison(yr,r,m,'dm0','old') = sum(g, dm0_ref(yr,r,g,m));
disaggregate_comparison(yr,r,m,'dm0','diff') = sum(g, dm0_(yr,r,g,m)) - sum(g, dm0_ref(yr,r,g,m));
disaggregate_comparison(yr,r,s,'s0','new') = s0_(yr,r,s);
disaggregate_comparison(yr,r,s,'s0','old') = s0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'s0','diff') = s0_(yr,r,s) - s0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'a0','new') = a0_(yr,r,s);
disaggregate_comparison(yr,r,s,'a0','old') = a0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'a0','diff') = a0_(yr,r,s) - a0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'ta0','new') = ta0_(yr,r,s);
disaggregate_comparison(yr,r,s,'ta0','old') = ta0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'ta0','diff') = ta0_(yr,r,s) - ta0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'tm0','new') = tm0_(yr,r,s);
disaggregate_comparison(yr,r,s,'tm0','old') = tm0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'tm0','diff') = tm0_(yr,r,s) - tm0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'cd0','new') = cd0_(yr,r,s);
disaggregate_comparison(yr,r,s,'cd0','old') = cd0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'cd0','diff') = cd0_(yr,r,s) - cd0_ref(yr,r,s);
disaggregate_comparison(yr,r,'all','c0','new') = c0_(yr,r);
disaggregate_comparison(yr,r,'all','c0','old') = c0_ref(yr,r);
disaggregate_comparison(yr,r,'all','c0','diff') = c0_(yr,r) - c0_ref(yr,r);
disaggregate_comparison(yr,r,s,'yh0','new') = yh0_(yr,r,s);
disaggregate_comparison(yr,r,s,'yh0','old') = yh0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'yh0','diff') = yh0_(yr,r,s) - yh0_ref(yr,r,s);
disaggregate_comparison(yr,r,'all','bopdef0','new') = bopdef0_(yr,r);
disaggregate_comparison(yr,r,'all','bopdef0','old') = bopdef0_ref(yr,r);
disaggregate_comparison(yr,r,'all','bopdef0','diff') = bopdef0_(yr,r) - bopdef0_ref(yr,r);
disaggregate_comparison(yr,r,'all','hhadj0','new') = hhadj0_(yr,r);
disaggregate_comparison(yr,r,'all','hhadj0','old') = hhadj0_ref(yr,r);
disaggregate_comparison(yr,r,'all','hhadj0','diff') = hhadj0_(yr,r) - hhadj0_ref(yr,r);
disaggregate_comparison(yr,r,s,'g0','new') = g0_(yr,r,s);
disaggregate_comparison(yr,r,s,'g0','old') = g0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'g0','diff') = g0_(yr,r,s) - g0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'i0','new') = i0_(yr,r,s);
disaggregate_comparison(yr,r,s,'i0','old') = i0_ref(yr,r,s);
disaggregate_comparison(yr,r,s,'i0','diff') = i0_(yr,r,s) - i0_ref(yr,r,s);
disaggregate_comparison(yr,r,g,'xn0','new') = xn0_(yr,r,g);
disaggregate_comparison(yr,r,g,'xn0','old') = xn0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'xn0','diff') = xn0_(yr,r,g) - xn0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'xd0','new') = xd0_(yr,r,g);
disaggregate_comparison(yr,r,g,'xd0','old') = xd0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'xd0','diff') = xd0_(yr,r,g) - xd0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'dd0','new') = dd0_(yr,r,g);
disaggregate_comparison(yr,r,g,'dd0','old') = dd0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'dd0','diff') = dd0_(yr,r,g) - dd0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'nd0','new') = nd0_(yr,r,g);
disaggregate_comparison(yr,r,g,'nd0','old') = nd0_ref(yr,r,g);
disaggregate_comparison(yr,r,g,'nd0','diff') = nd0_(yr,r,g) - nd0_ref(yr,r,g);
* display disaggregate_comparison;

* aggregate statistics

sector_comparison(yr,s,'ys0','new') = sum(r, sum(g, ys0_(yr,r,s,g)));
sector_comparison(yr,s,'ys0','old') = sum(r, sum(g, ys0_ref(yr,r,s,g)));
sector_comparison(yr,s,'ys0','diff') = sum(r, sum(g, ys0_(yr,r,s,g)) - sum(g, ys0_ref(yr,r,s,g)));
sector_comparison(yr,s,'id0','new') = sum(r, sum(g, ys0_(yr,r,g,s)));
sector_comparison(yr,s,'id0','old') = sum(r, sum(g, ys0_ref(yr,r,g,s)));
sector_comparison(yr,s,'id0','diff') = sum(r, sum(g, ys0_(yr,r,g,s)) - sum(g, ys0_ref(yr,r,g,s)));
sector_comparison(yr,s,'ld0','new') = sum(r, ld0_(yr,r,s));
sector_comparison(yr,s,'ld0','old') = sum(r, ld0_ref(yr,r,s));
sector_comparison(yr,s,'ld0','diff') = sum(r, ld0_(yr,r,s) - ld0_ref(yr,r,s));
sector_comparison(yr,s,'kd0','new') = sum(r, kd0_(yr,r,s));
sector_comparison(yr,s,'kd0','old') = sum(r, kd0_ref(yr,r,s));
sector_comparison(yr,s,'kd0','diff') = sum(r, kd0_(yr,r,s) - kd0_ref(yr,r,s));
sector_comparison(yr,s,'ty0','new') = sum(r, ty0_(yr,r,s));
sector_comparison(yr,s,'ty0','old') = sum(r, ty0_ref(yr,r,s));
sector_comparison(yr,s,'ty0','diff') = sum(r, ty0_(yr,r,s) - ty0_ref(yr,r,s));
sector_comparison(yr,s,'m0','new') = sum(r, m0_(yr,r,s));
sector_comparison(yr,s,'m0','old') = sum(r, m0_ref(yr,r,s));
sector_comparison(yr,s,'m0','diff') = sum(r, m0_(yr,r,s) - m0_ref(yr,r,s));
sector_comparison(yr,s,'x0','new') = sum(r, x0_(yr,r,s));
sector_comparison(yr,s,'x0','old') = sum(r, x0_ref(yr,r,s));
sector_comparison(yr,s,'x0','diff') = sum(r, x0_(yr,r,s) - x0_ref(yr,r,s));
sector_comparison(yr,s,'rx0','new') = sum(r, rx0_(yr,r,s));
sector_comparison(yr,s,'rx0','old') = sum(r, rx0_ref(yr,r,s));
sector_comparison(yr,s,'rx0','diff') = sum(r, rx0_(yr,r,s) - rx0_ref(yr,r,s));
sector_comparison(yr,m,'md0','new') = sum(r, sum(s, md0_(yr,r,m,s)));
sector_comparison(yr,m,'md0','old') = sum(r, sum(s, md0_ref(yr,r,m,s)));
sector_comparison(yr,m,'md0','diff') = sum(r, sum(s, md0_(yr,r,m,s)) - sum(s, md0_ref(yr,r,m,s)));
sector_comparison(yr,m,'nm0','new') = sum(r, sum(g, nm0_(yr,r,g,m)));
sector_comparison(yr,m,'nm0','old') = sum(r, sum(g, nm0_ref(yr,r,g,m)));
sector_comparison(yr,m,'nm0','diff') = sum(r, sum(g, nm0_(yr,r,g,m)) - sum(g, nm0_ref(yr,r,g,m)));
sector_comparison(yr,m,'dm0','new') = sum(r, sum(g, dm0_(yr,r,g,m)));
sector_comparison(yr,m,'dm0','old') = sum(r, sum(g, dm0_ref(yr,r,g,m)));
sector_comparison(yr,m,'dm0','diff') = sum(r, sum(g, dm0_(yr,r,g,m)) - sum(g, dm0_ref(yr,r,g,m)));
sector_comparison(yr,s,'s0','new') = sum(r, s0_(yr,r,s));
sector_comparison(yr,s,'s0','old') = sum(r, s0_ref(yr,r,s));
sector_comparison(yr,s,'s0','diff') = sum(r, s0_(yr,r,s) - s0_ref(yr,r,s));
sector_comparison(yr,s,'a0','new') = sum(r, a0_(yr,r,s));
sector_comparison(yr,s,'a0','old') = sum(r, a0_ref(yr,r,s));
sector_comparison(yr,s,'a0','diff') = sum(r, a0_(yr,r,s) - a0_ref(yr,r,s));
sector_comparison(yr,s,'ta0','new') = sum(r, ta0_(yr,r,s));
sector_comparison(yr,s,'ta0','old') = sum(r, ta0_ref(yr,r,s));
sector_comparison(yr,s,'ta0','diff') = sum(r, ta0_(yr,r,s) - ta0_ref(yr,r,s));
sector_comparison(yr,s,'tm0','new') = sum(r, tm0_(yr,r,s));
sector_comparison(yr,s,'tm0','old') = sum(r, tm0_ref(yr,r,s));
sector_comparison(yr,s,'tm0','diff') = sum(r, tm0_(yr,r,s) - tm0_ref(yr,r,s));
sector_comparison(yr,s,'cd0','new') = sum(r, cd0_(yr,r,s));
sector_comparison(yr,s,'cd0','old') = sum(r, cd0_ref(yr,r,s));
sector_comparison(yr,s,'cd0','diff') = sum(r, cd0_(yr,r,s) - cd0_ref(yr,r,s));
sector_comparison(yr,'all','c0','new') = sum(r, c0_(yr,r));
sector_comparison(yr,'all','c0','old') = sum(r, c0_ref(yr,r));
sector_comparison(yr,'all','c0','diff') = sum(r, c0_(yr,r) - c0_ref(yr,r));
sector_comparison(yr,s,'yh0','new') = sum(r, yh0_(yr,r,s));
sector_comparison(yr,s,'yh0','old') = sum(r, yh0_ref(yr,r,s));
sector_comparison(yr,s,'yh0','diff') = sum(r, yh0_(yr,r,s) - yh0_ref(yr,r,s));
sector_comparison(yr,'all','bopdef0','new') = sum(r, bopdef0_(yr,r));
sector_comparison(yr,'all','bopdef0','old') = sum(r, bopdef0_ref(yr,r));
sector_comparison(yr,'all','bopdef0','diff') = sum(r, bopdef0_(yr,r) - bopdef0_ref(yr,r));
sector_comparison(yr,'all','hhadj0','new') = sum(r, hhadj0_(yr,r));
sector_comparison(yr,'all','hhadj0','old') = sum(r, hhadj0_ref(yr,r));
sector_comparison(yr,'all','hhadj0','diff') = sum(r, hhadj0_(yr,r) - hhadj0_ref(yr,r));
sector_comparison(yr,s,'g0','new') = sum(r, g0_(yr,r,s));
sector_comparison(yr,s,'g0','old') = sum(r, g0_ref(yr,r,s));
sector_comparison(yr,s,'g0','diff') = sum(r, g0_(yr,r,s) - g0_ref(yr,r,s));
sector_comparison(yr,s,'i0','new') = sum(r, i0_(yr,r,s));
sector_comparison(yr,s,'i0','old') = sum(r, i0_ref(yr,r,s));
sector_comparison(yr,s,'i0','diff') = sum(r, i0_(yr,r,s) - i0_ref(yr,r,s));
sector_comparison(yr,g,'xn0','new') = sum(r, xn0_(yr,r,g));
sector_comparison(yr,g,'xn0','old') = sum(r, xn0_ref(yr,r,g));
sector_comparison(yr,g,'xn0','diff') = sum(r, xn0_(yr,r,g) - xn0_ref(yr,r,g));
sector_comparison(yr,g,'xd0','new') = sum(r, xd0_(yr,r,g));
sector_comparison(yr,g,'xd0','old') = sum(r, xd0_ref(yr,r,g));
sector_comparison(yr,g,'xd0','diff') = sum(r, xd0_(yr,r,g) - xd0_ref(yr,r,g));
sector_comparison(yr,g,'dd0','new') = sum(r, dd0_(yr,r,g));
sector_comparison(yr,g,'dd0','old') = sum(r, dd0_ref(yr,r,g));
sector_comparison(yr,g,'dd0','diff') = sum(r, dd0_(yr,r,g) - dd0_ref(yr,r,g));
sector_comparison(yr,g,'nd0','new') = sum(r, nd0_(yr,r,g));
sector_comparison(yr,g,'nd0','old') = sum(r, nd0_ref(yr,r,g));
sector_comparison(yr,g,'nd0','diff') = sum(r, nd0_(yr,r,g) - nd0_ref(yr,r,g));
* display sector_comparison;

region_comparison(yr,r,'ys0','new') = sum(s, sum(g, ys0_(yr,r,s,g)));
region_comparison(yr,r,'ys0','old') = sum(s, sum(g, ys0_ref(yr,r,s,g)));
region_comparison(yr,r,'ys0','diff') = sum(s, sum(g, ys0_(yr,r,s,g)) - sum(g, ys0_ref(yr,r,s,g)));
region_comparison(yr,r,'id0','new') = sum(s, sum(g, ys0_(yr,r,g,s)));
region_comparison(yr,r,'id0','old') = sum(s, sum(g, ys0_ref(yr,r,g,s)));
region_comparison(yr,r,'id0','diff') = sum(s, sum(g, ys0_(yr,r,g,s)) - sum(g, ys0_ref(yr,r,g,s)));
region_comparison(yr,r,'ld0','new') = sum(s, ld0_(yr,r,s));
region_comparison(yr,r,'ld0','old') = sum(s, ld0_ref(yr,r,s));
region_comparison(yr,r,'ld0','diff') = sum(s, ld0_(yr,r,s) - ld0_ref(yr,r,s));
region_comparison(yr,r,'kd0','new') = sum(s, kd0_(yr,r,s));
region_comparison(yr,r,'kd0','old') = sum(s, kd0_ref(yr,r,s));
region_comparison(yr,r,'kd0','diff') = sum(s, kd0_(yr,r,s) - kd0_ref(yr,r,s));
region_comparison(yr,r,'ty0','new') = sum(s, ty0_(yr,r,s));
region_comparison(yr,r,'ty0','old') = sum(s, ty0_ref(yr,r,s));
region_comparison(yr,r,'ty0','diff') = sum(s, ty0_(yr,r,s) - ty0_ref(yr,r,s));
region_comparison(yr,r,'m0','new') = sum(s, m0_(yr,r,s));
region_comparison(yr,r,'m0','old') = sum(s, m0_ref(yr,r,s));
region_comparison(yr,r,'m0','diff') = sum(s, m0_(yr,r,s) - m0_ref(yr,r,s));
region_comparison(yr,r,'x0','new') = sum(s, x0_(yr,r,s));
region_comparison(yr,r,'x0','old') = sum(s, x0_ref(yr,r,s));
region_comparison(yr,r,'x0','diff') = sum(s, x0_(yr,r,s) - x0_ref(yr,r,s));
region_comparison(yr,r,'rx0','new') = sum(s, rx0_(yr,r,s));
region_comparison(yr,r,'rx0','old') = sum(s, rx0_ref(yr,r,s));
region_comparison(yr,r,'rx0','diff') = sum(s, rx0_(yr,r,s) - rx0_ref(yr,r,s));
region_comparison(yr,r,'md0','new') = sum(m, sum(s, md0_(yr,r,m,s)));
region_comparison(yr,r,'md0','old') = sum(m, sum(s, md0_ref(yr,r,m,s)));
region_comparison(yr,r,'md0','diff') = sum(m, sum(s, md0_(yr,r,m,s)) - sum(s, md0_ref(yr,r,m,s)));
region_comparison(yr,r,'nm0','new') = sum(m, sum(g, nm0_(yr,r,g,m)));
region_comparison(yr,r,'nm0','old') = sum(m, sum(g, nm0_ref(yr,r,g,m)));
region_comparison(yr,r,'nm0','diff') = sum(m, sum(g, nm0_(yr,r,g,m)) - sum(g, nm0_ref(yr,r,g,m)));
region_comparison(yr,r,'dm0','new') = sum(m, sum(g, dm0_(yr,r,g,m)));
region_comparison(yr,r,'dm0','old') = sum(m, sum(g, dm0_ref(yr,r,g,m)));
region_comparison(yr,r,'dm0','diff') = sum(m, sum(g, dm0_(yr,r,g,m)) - sum(g, dm0_ref(yr,r,g,m)));
region_comparison(yr,r,'s0','new') = sum(s, s0_(yr,r,s));
region_comparison(yr,r,'s0','old') = sum(s, s0_ref(yr,r,s));
region_comparison(yr,r,'s0','diff') = sum(s, s0_(yr,r,s) - s0_ref(yr,r,s));
region_comparison(yr,r,'a0','new') = sum(s, a0_(yr,r,s));
region_comparison(yr,r,'a0','old') = sum(s, a0_ref(yr,r,s));
region_comparison(yr,r,'a0','diff') = sum(s, a0_(yr,r,s) - a0_ref(yr,r,s));
region_comparison(yr,r,'ta0','new') = sum(s, ta0_(yr,r,s));
region_comparison(yr,r,'ta0','old') = sum(s, ta0_ref(yr,r,s));
region_comparison(yr,r,'ta0','diff') = sum(s, ta0_(yr,r,s) - ta0_ref(yr,r,s));
region_comparison(yr,r,'tm0','new') = sum(s, tm0_(yr,r,s));
region_comparison(yr,r,'tm0','old') = sum(s, tm0_ref(yr,r,s));
region_comparison(yr,r,'tm0','diff') = sum(s, tm0_(yr,r,s) - tm0_ref(yr,r,s));
region_comparison(yr,r,'cd0','new') = sum(s, cd0_(yr,r,s));
region_comparison(yr,r,'cd0','old') = sum(s, cd0_ref(yr,r,s));
region_comparison(yr,r,'cd0','diff') = sum(s, cd0_(yr,r,s) - cd0_ref(yr,r,s));
region_comparison(yr,r,'yh0','new') = sum(s, yh0_(yr,r,s));
region_comparison(yr,r,'yh0','old') = sum(s, yh0_ref(yr,r,s));
region_comparison(yr,r,'yh0','diff') = sum(s, yh0_(yr,r,s) - yh0_ref(yr,r,s));
region_comparison(yr,r,'g0','new') = sum(s, g0_(yr,r,s));
region_comparison(yr,r,'g0','old') = sum(s, g0_ref(yr,r,s));
region_comparison(yr,r,'g0','diff') = sum(s, g0_(yr,r,s) - g0_ref(yr,r,s));
region_comparison(yr,r,'i0','new') = sum(s, i0_(yr,r,s));
region_comparison(yr,r,'i0','old') = sum(s, i0_ref(yr,r,s));
region_comparison(yr,r,'i0','diff') = sum(s, i0_(yr,r,s) - i0_ref(yr,r,s));
region_comparison(yr,r,'xn0','new') = sum(g, xn0_(yr,r,g));
region_comparison(yr,r,'xn0','old') = sum(g, xn0_ref(yr,r,g));
region_comparison(yr,r,'xn0','diff') = sum(g, xn0_(yr,r,g) - xn0_ref(yr,r,g));
region_comparison(yr,r,'xd0','new') = sum(g, xd0_(yr,r,g));
region_comparison(yr,r,'xd0','old') = sum(g, xd0_ref(yr,r,g));
region_comparison(yr,r,'xd0','diff') = sum(g, xd0_(yr,r,g) - xd0_ref(yr,r,g));
region_comparison(yr,r,'dd0','new') = sum(g, dd0_(yr,r,g));
region_comparison(yr,r,'dd0','old') = sum(g, dd0_ref(yr,r,g));
region_comparison(yr,r,'dd0','diff') = sum(g, dd0_(yr,r,g) - dd0_ref(yr,r,g));
region_comparison(yr,r,'nd0','new') = sum(g, nd0_(yr,r,g));
region_comparison(yr,r,'nd0','old') = sum(g, nd0_ref(yr,r,g));
region_comparison(yr,r,'nd0','diff') = sum(g, nd0_(yr,r,g) - nd0_ref(yr,r,g));
* display region_comparison;

* execute_unload 'dataset_comparison.gdx',
*     disaggregate_comparison, sector_comparison, region_comparison;

* execute 'gdxxrw.exe dataset_comparison.gdx par=sector_comparison rng=sector!A2 cdim=0 par=region_comparison rng=region!A2 cdim=0';


* ------------------------------------------------------------------------------
* Read new household data
* ------------------------------------------------------------------------------

$set ds WiNDC_cps_static_all_2017_new.gdx

set
    h       Household categories,
    trn     Transfer types;    

$gdxin '%ds%'
$loaddc h trn
alias(r,q);

parameter
    pop0(r,h)		Population (households or returns in millions),
    le0(r,q,h)		Household labor endowment,
    ke0(r,h)		Household interest payments,
    tk0(r)		Capital tax rate,
    tl_avg0(r,h)	Household average labor tax rate,
    tl0(r,h)		Household marginal labor tax rate,
    tfica0(r,h)		Household FICA labor tax rate,
    cd0_h(r,g,h)	Household level expenditures,
    c0_h(r,h)		Aggregate household level expenditures,
    sav0(r,h)		Household saving,
    fsav0		Foreign savings,
    fint0		Foreign interest payments,
    trn0(r,h)		Household transfer payments,
    hhtrn0(r,h,trn)	Disaggregate transfer payments;

* household data:
$loaddc le0 ke0 tk0 tl_avg0 tl0 tfica0 cd0_h c0_h sav0 trn0 hhtrn0 pop0 fsav0 fint0
$gdxin


* ------------------------------------------------------------------------------
* Read old household data
* ------------------------------------------------------------------------------

$set ds WiNDC_cps_static_all_2017_old.gdx
$gdxin '%ds%'

parameter
    pop0_ref(r,h)		Population (households or returns in millions),
    le0_ref(r,q,h)		Household labor endowment,
    ke0_ref(r,h)		Household interest payments,
    tk0_ref(r)			Capital tax rate,
    tl_avg0_ref(r,h)		Household average labor tax rate,
    tl0_ref(r,h)		Household marginal labor tax rate,
    tfica0_ref(r,h)		Household FICA labor tax rate,
    cd0_h_ref(r,g,h)		Household level expenditures,
    c0_h_ref(r,h)		Aggregate household level expenditures,
    sav0_ref(r,h)		Household saving,
    fsav0_ref			Foreign savings,
    fint0_ref			Foreign interest payments,
    trn0_ref(r,h)		Household transfer payments,
    hhtrn0_ref(r,h,trn)		Disaggregate transfer payments;

* household data:
$loaddc le0_ref=le0 ke0_ref=ke0 tk0_ref=tk0 tl_avg0_ref=tl_avg0
$loaddc tl0_ref=tl0 tfica0_ref=tfica0 cd0_h_ref=cd0_h c0_h_ref=c0_h
$loaddc sav0_ref=sav0 trn0_ref=trn0 hhtrn0_ref=hhtrn0 pop0_ref=pop0
$loaddc fsav0_ref=fsav0 fint0_ref=fint0
$gdxin


* ------------------------------------------------------------------------------
* Compare household data
* ------------------------------------------------------------------------------

parameter
    household_comparison;

household_comparison(r,h,'pop0','new') = pop0(r,h);
household_comparison(r,h,'pop0','old') = pop0_ref(r,h);
household_comparison(r,h,'le0','new') = sum(q, le0(r,q,h));
household_comparison(r,h,'le0','old') = sum(q, le0_ref(r,q,h));
household_comparison(r,h,'ke0','new') = ke0(r,h);
household_comparison(r,h,'ke0','old') = ke0_ref(r,h);
household_comparison(r,h,'c0','new') = c0_h(r,h);
household_comparison(r,h,'c0','old') = c0_h_ref(r,h);
household_comparison(r,h,'sav0','new') = sav0(r,h);
household_comparison(r,h,'sav0','old') = sav0_ref(r,h);
household_comparison(r,h,'trn0','new') = trn0(r,h);
household_comparison(r,h,'trn0','old') = trn0_ref(r,h);
household_comparison(r,trn,'trn0','new') = sum(h, hhtrn0(r,h,trn));
household_comparison(r,trn,'trn0','old') = sum(h, hhtrn0_ref(r,h,trn));
display household_comparison;


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
