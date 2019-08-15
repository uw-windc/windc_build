$TITLE Regional Disaggregation of the National IO Tables

* Output data directory is specified here:

$IF NOT SET year $SET year 2016

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* Set directory structure:
$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "..%sep%built_datasets"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"


$IFTHENI.kestrel "%neos%" == "yes"
FILE opt / kestrel.opt /;
$ENDIF.kestrel

* -------------------------------------------------------------------
* Read in the national dataset:
* -------------------------------------------------------------------


SET yr "Years in WiNDC Database";
SET r "Regions in WiNDC Database";
SET s "BEA Goods and sectors categories";
SET m "Margins (trade or transport)";
SET fd "BEA Final demand categories";
SET ts "BEA Taxes and subsidies categories";
SET va "BEA Value added categories";


* GDX existance test for UNIX
$IF NOT EXIST "%reldir%%sep%temp%sep%gdx_temp%sep%nationaldata.gdx" ABORT "File nationaldata.gdx does not exist"

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOADDC yr
$LOADDC r
$LOADDC s=i
$LOADDC va
$LOADDC fd
$GDXIN


$GDXIN '%reldir%%sep%temp%sep%gdx_temp%sep%nationaldata.gdx'
$LOADDC m

ALIAS(s,g,ss,gg),(r,rr);

PARAMETER y_0(yr,s) "Gross output"
PARAMETER ys_0(yr,s,g) "Sectoral supply"
PARAMETER fs_0(yr,g) "Household supply"
PARAMETER id_0(yr,g,s) "Intermediate demand"
PARAMETER fd_0(yr,s,fd) "Final demand"
PARAMETER va_0(yr,va,s) "Vaue added"
PARAMETER m_0(yr,g) "Imports"
PARAMETER x_0(yr,g) "Exports of goods and services"
PARAMETER ms_0(yr,s,m) "Margin supply"
PARAMETER md_0(yr,m,g) "Margin demand"
PARAMETER s_0(yr,g) "Aggregate supply"
PARAMETER a_0(yr,g) "Armington supply"
PARAMETER ta_0(yr,g) "Tax net subsidy rate on intermediate demand"
PARAMETER tm_0(yr,g) "Import tariff"
PARAMETER bopdef_0(yr) "Balance of payments"

$LOADDC y_0
$LOADDC ys_0
$LOADDC fs_0
$LOADDC id_0
$LOADDC fd_0
$LOADDC va_0
$LOADDC m_0
$LOADDC x_0
$LOADDC ms_0
$LOADDC md_0
$LOADDC s_0
$LOADDC a_0
$LOADDC bopdef_0
$LOADDC ta_0
$LOADDC tm_0
$GDXIN


* -------------------------------------------------------------------
* Read in shares generated using state level gross product, pce, cfs and
* government expenditures:
* -------------------------------------------------------------------

PARAMETER region_shr(yr,r,s) "Regional shares based on GSP";
PARAMETER labor_shr(yr,r,s) "Labor share of GSP";
PARAMETER pce_shr(yr,r,g) "Regional shares based on PCE";
PARAMETER sgf_shr(yr,r,g) "Regional government expenditure shares (SGF)";
PARAMETER cfs_rpc(r,g) "Regional purchase coefficients based on CFS (2012)";
PARAMETER usatrd_shr(yr,r,g,*) "Regional export-import shares based on USA Trade Online";


* GDX existance test for UNIX
$IF NOT EXIST "%reldir%%sep%temp%sep%gdx_temp%sep%shares_pce.gdx" ABORT "File shares_pce.gdx does not exist"
$IF NOT EXIST "%reldir%%sep%temp%sep%gdx_temp%sep%shares_sgf.gdx" ABORT "File shares_sgf.gdx does not exist"
$IF NOT EXIST "%reldir%%sep%temp%sep%gdx_temp%sep%cfs_rpcs.gdx" ABORT "File cfs_rpcs.gdx does not exist"
$IF NOT EXIST "%reldir%%sep%temp%sep%gdx_temp%sep%shares_usatrd.gdx" ABORT "File shares_usatrd.gdx does not exist"


$GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%shares_gsp.gdx
$LOADDC region_shr labor_shr
$GDXIN

$GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%shares_pce.gdx
$LOADDC pce_shr
$GDXIN

$GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%shares_sgf.gdx
$LOADDC sgf_shr
$GDXIN

$GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%cfs_rpcs.gdx
$LOADDC cfs_rpc=rpc
$GDXIN

$GDXIN %reldir%%sep%temp%sep%gdx_temp%sep%shares_usatrd.gdx
$LOADDC usatrd_shr
$GDXIN


* How do shares differ? Look at example:
PARAMETER diffshr(g,*) "Check on share differences";

diffshr(g,'PCE') = pce_shr('%year%','WI',g);
diffshr(g,'SGF') = sgf_shr('%year%','WI',g);
diffshr(g,'GSP') = region_shr('%year%','WI',g);
diffshr(g,'Labor') = labor_shr('%year%','WI',g);
diffshr(g,'RPC') = cfs_rpc('WI',g);
diffshr(g,'Xpt') = usatrd_shr('%year%','WI',g,'exports');
diffshr(g,'Imp') = usatrd_shr('%year%','WI',g,'imports');

* For years not included in USA Trade Online shares, use most recent
* shares. Earliest year for exports is: 2002. Earliest year for imports
* is: 2008.

usatrd_shr(yr,r,g,'exports')$(ord(yr) < 6) = usatrd_shr('2002',r,g,'exports');
usatrd_shr(yr,r,g,'imports')$(ord(yr) < 12) = usatrd_shr('2008',r,g,'imports');

* Verify all shares both sum to 1 and are in [0,1]:

PARAMETER shrverify "Verify consistent shares";

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

DISPLAY shrverify;

* -------------------------------------------------------------------
* Regionalize production data using iomacro shares and GSP data:
* -------------------------------------------------------------------

PARAMETER va0_(yr,r,s) "Regional value added";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER ty0_rev_(yr,r,s) "Production tax payments";
PARAMETER ty0_(yr,r,s) "Production tax rate";
PARAMETER y0_(yr,r,s) "Regional gross sectoral output";
PARAMETER ys0_(yr,r,s,g) "Regional sectoral output";
PARAMETER id0_(yr,r,g,s) "Regional intermediate demand";
PARAMETER zprof(yr,r,s) "Check on ZP";

ys0_(yr,r,s,g) = region_shr(yr,r,s) * ys_0(yr,s,g);
id0_(yr,r,g,s) = region_shr(yr,r,s) * id_0(yr,g,s);
ty0_rev_(yr,r,s) = region_shr(yr,r,s) * va_0(yr,'othtax',s);
ty0_(yr,r,s)$sum(g, ys0_(yr,r,s,g)) = ty0_rev_(yr,r,s) / sum(g, ys0_(yr,r,s,g));
va0_(yr,r,s) = region_shr(yr,r,s) * (va_0(yr,'compen',s) + va_0(yr,'surplus',s));

* Split aggregate value added based on GSP components:

ld0_(yr,r,s) = labor_shr(yr,r,s) * va0_(yr,r,s);
kd0_(yr,r,s) = va0_(yr,r,s) - ld0_(yr,r,s);

zprof(yr,r,s) = sum(g, ys0_(yr,r,s,g)) - ld0_(yr,r,s) - kd0_(yr,r,s) - ty0_rev_(yr,r,s) - sum(g, id0_(yr,r,g,s));
ABORT$(smax((yr,r,s), abs(zprof(yr,r,s))) > 1e-5) "Error in zero profit check in regionalization.";



* -------------------------------------------------------------------
* Final demand categories:
* -------------------------------------------------------------------

* Aggregate final demand categories:

SET fdcat "Aggregated final demand categories" /
  C "Household consumption",
  I "Investment",
  G "Government expenditures" /;

SET fdmap(fd,fdcat) "Mapping of final demand" /
  pce.C "Personal consumption expenditures",
  structures.I "Nonresidential private fixed investment in structures",
  equipment.I "Nonresidential private fixed investment in equipment",
  intelprop.I "Nonresidential private fixed investment in intellectual",
  residential.I "Residential private fixed investment",
  changinv.I "Change in private inventories",
  defense.G "National defense: Consumption expenditures",
  def_structures.G "Federal national defense: Gross investment in structures",
  def_equipment.G "Federal national defense: Gross investment in equipment",
  def_intelprop.G "Federal national defense: Gross investment in intellectual",
  nondefense.G "Nondefense: Consumption expenditures",
  fed_structures.G "Federal nondefense: Gross investment in structures",
  fed_equipment.G "Federal nondefense: Gross investment in equipment",
  fed_intelprop.G "Federal nondefense: Gross investment in intellectual prop",
  state_consume.G "State and local government consumption expenditures",
  state_invest.G "State and local: Gross investment in structures",
  state_equipment.G "State and local: Gross investment in equipment",
  state_intelprop.G "State and local: Gross investment in intellectual" /;

PARAMETER g_0(yr,g) "National government demand";
PARAMETER i_0(yr,g) "National investment demand";
PARAMETER cd_0(yr,g) "National final consumption";
PARAMETER yh0_(yr,r,s) "Household production";
PARAMETER fe0_(yr,r) "Total factor supply";
PARAMETER cd0_(yr,r,s) "Consumption demand";
PARAMETER c0_(yr,r) "Total final household consumption";
PARAMETER i0_(yr,r,s) "Investment demand";
PARAMETER g0_(yr,r,s) "Government demand";

g_0(yr,g) = sum(fdmap(fd,'g'), fd_0(yr,g,fd));
i_0(yr,g) = sum(fdmap(fd,'i'), fd_0(yr,g,fd));
cd_0(yr,g) = sum(fdmap(fd,'c'), fd_0(yr,g,fd));

yh0_(yr,r,s) = fs_0(yr,s) * region_shr(yr,r,s);
fe0_(yr,r) = sum(s, va0_(yr,r,s));

* Use PCE and government demand data rather than region_shr:

cd0_(yr,r,g) = pce_shr(yr,r,g) * cd_0(yr,g);
g0_(yr,r,g) = sgf_shr(yr,r,g) * g_0(yr,g);
i0_(yr,r,g) = region_shr(yr,r,g) * i_0(yr,g);
c0_(yr,r) = sum(s, cd0_(yr,r,s));

* --------------------------------------------------------------------------
* Trade parameters:
* --------------------------------------------------------------------------

PARAMETER m0_(yr,r,g) "Foreign Imports";
PARAMETER md0_(yr,r,m,g) "Margin demand";
PARAMETER ms0_(yr,r,s,m) "Margin supply";
PARAMETER x0_(yr,r,g) "Foreign Exports";
PARAMETER s0_(yr,r,g) "Total supply";
PARAMETER bopdef0_(yr,r) "Balance of payments (closure parameter)";
PARAMETER a0_(yr,r,g) "Domestic absorption";
PARAMETER tm0_(yr,r,g) "Import taxes";
PARAMETER ta0_(yr,r,g) "Absorption taxes";
PARAMETER tr0a_(yr,r,g) "Tax revenue from output";
PARAMETER tr0m_(yr,r,g) "Tax revenue on imports";
PARAMETER rx0_(yr,r,g) "Re-exports";

* Use export shares from USA Trade Online for included sectors. For those
* not included, use gross state product shares:

SET notrd(yr,g) "Goods not included in trade data";

notrd(yr,g) = yes$(not sum(r, usatrd_shr(yr,r,g,'exports')));
x0_(yr,r,g) = usatrd_shr(yr,r,g,'exports') * x_0(yr,g);
x0_(yr,r,g)$notrd(yr,g) = region_shr(yr,r,g) * x_0(yr,g);

* No longer subtracting margin supply from gross output. This will be allocated
* through the national and local markets.

s0_(yr,r,g) = sum(s, ys0_(yr,r,s,g)) + yh0_(yr,r,g);
a0_(yr,r,g) = cd0_(yr,r,g) + g0_(yr,r,g) + i0_(yr,r,g) + sum(s, id0_(yr,r,g,s));

tm0_(yr,r,g) = tm_0(yr,g);
ta0_(yr,r,g) = ta_0(yr,g);

PARAMETER thetaa(yr,r,g) "Share of regional absorption";

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

* The 'oth' and 'use' sectors are problematic with negative numbers.

PARAMETER diff "Negative numbers still exist due to sharing parameter";

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

SET gm(g) "Commodities employed in margin supply";

gm(g) = yes$(sum((yr,m), ms_0(yr,g,m)) or sum((yr,m), md_0(yr,m,g)));

PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local market";
PARAMETER dd0min(yr,r,g) "Minimum regional demand from local market";
PARAMETER dd0max(yr,r,g) "Maximum regional demand from local market";
PARAMETER nd0_(yr,r,g) "Regional demand from national marke";
PARAMETER nd0min(yr,r,g) "Minimum regional demand from national market";
PARAMETER nd0max(yr,r,g) "Maximum regional demand from national market";
PARAMETER nm0_(yr,r,g,m) "Margin demand from the national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from the local market";

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

nd0min(yr,r,g) = (1-ta0_(yr,r,g))* a0_(yr,r,g) + rx0_(yr,r,g) - dd0max(yr,r,g) - m0_(yr,r,g)*(1+tm0_(yr,r,g)) - sum(m,md0_(yr,r,m,g));
dd0min(yr,r,g) = (1-ta0_(yr,r,g))* a0_(yr,r,g) + rx0_(yr,r,g) - nd0max(yr,r,g) - m0_(yr,r,g)*(1+tm0_(yr,r,g)) - sum(m,md0_(yr,r,m,g));

* The mixture of domestic vs. national demand in the absorption market is
* determined by regional purchase coefficients. Use estimates based on 2012
* Commodity Flow Survey data:

PARAMETER rpc(yr,r,g) "Regional purchase coefficients";

rpc(yr,r,g) = cfs_rpc(r,g);
dd0_(yr,r,g) = rpc(yr,r,g) * dd0max(yr,r,g);
nd0_(yr,r,g) = round((1-ta0_(yr,r,g))*a0_(yr,r,g) + rx0_(yr,r,g) - dd0_(yr,r,g) - m0_(yr,r,g)*(1+tm0_(yr,r,g)) - sum(m,md0_(yr,r,m,g)),10);

* Assume margins come both from local and national production. Assign like
* dd0. Use information on national margin supply to enforce other identities.

PARAMETER totmargsupply(yr,r,m,g) "Designate total supply of margins";
PARAMETER margshr(yr,r,m) "Share of margin demand by region";
PARAMETER shrtrd(yr,r,m,g) "Share of margin total by margin type";

margshr(yr,r,m)$sum((g,rr), md0_(yr,rr,m,g)) = sum(g, md0_(yr,r,m,g)) / sum((g,rr), md0_(yr,rr,m,g));
totmargsupply(yr,r,m,g) = margshr(yr,r,m) * ms_0(yr,g,m);
shrtrd(yr,r,m,gm)$sum(m.local, totmargsupply(yr,r,m,gm)) = totmargsupply(yr,r,m,gm) / sum(m.local, totmargsupply(yr,r,m,gm));
dm0_(yr,r,gm,m) = min(rpc(yr,r,gm)*totmargsupply(yr,r,m,gm), shrtrd(yr,r,m,gm)*(s0_(yr,r,gm) - x0_(yr,r,gm) + rx0_(yr,r,gm) - dd0_(yr,r,gm)));
nm0_(yr,r,gm,m) = totmargsupply(yr,r,m,gm) - dm0_(yr,r,gm,m);

* Regional and national output must then be tied down as follows:

xd0_(yr,r,g) = sum(m, dm0_(yr,r,g,m)) + dd0_(yr,r,g);
xn0_(yr,r,g) = s0_(yr,r,g) + rx0_(yr,r,g) - xd0_(yr,r,g) - x0_(yr,r,g);

* Remove tiny numbers:

xd0_(yr,r,g)$(xd0_(yr,r,g) < 1e-8) = 0;
xn0_(yr,r,g)$(xn0_(yr,r,g) < 1e-8) = 0;

* Check equilibrium conditions:

PARAMETER zp;
PARAMETER mkt;
PARAMETER ibal;

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

PARAMETER hhadj_(yr,r) "Household adjustment parameter";
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

PARAMETER negnum "Check on negative numbers";

negnum('ys0') = smin((r,g,s), ys0_('%year%',r,s,g));
negnum('id0') = smin((r,s,g), id0_('%year%',r,g,s));
negnum('ld0') = smin((r,s), ld0_('%year%',r,s));
negnum('kd0') = smin((r,s), kd0_('%year%',r,s));
negnum('ty0_rev') = smin((r,s), ty0_rev_('%year%',r,s));
negnum('m0') = smin((r,g), m0_('%year%',r,g));
negnum('x0') = smin((r,g), x0_('%year%',r,g));
negnum('rx0') = smin((r,g), rx0_('%year%',r,g));
negnum('x0-rx0') = smin((r,g), x0_('%year%',r,g) - rx0_('%year%',r,g));
negnum('md0') = smin((r,m,gm), md0_('%year%',r,m,gm));
negnum('nm0') = smin((r,m,gm), nm0_('%year%',r,gm,m));
negnum('dm0') = smin((r,m,gm), dm0_('%year%',r,gm,m));
negnum('s0') = smin((r,g), s0_('%year%',r,g));
negnum('a0') = smin((r,g), a0_('%year%',r,g));
negnum('cd0') = smin((r,g), cd0_('%year%',r,g));
negnum('c0') = smin((r), c0_('%year%',r));
negnum('yh0') = smin((r,g), yh0_('%year%',r,g));
negnum('g0') = smin((r,g), g0_('%year%',r,g));
negnum('i0') = smin((r,g), i0_('%year%',r,g));
negnum('xn0') = smin((r,g), xn0_('%year%',r,g));
negnum('xd0') = smin((r,g), xd0_('%year%',r,g));
negnum('dd0') = smin((r,g), dd0_('%year%',r,g));
negnum('nd0') = smin((r,g), nd0_('%year%',r,g));
ALIAS(p,*);

ABORT$(smin(p, negnum(p)) < 0) "Negative numbers exist in regionalized parameters.";

* -------------------------------------------------------------------
* Check microconsistency in a regional accounting model for %year%:
* -------------------------------------------------------------------

$INCLUDE %reldir%%sep%statemodel.gms
statemodel.workspace = 100;
statemodel.iterlim = 0;
$INCLUDE %reldir%%sep%temp%sep%statemodel.gen


$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_mcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel

SOLVE statemodel using mcp;
ABORT$(statemodel.objval > 1e-5) "Error in benchmark calibration with regional data.";

* -------------------------------------------------------------------
* Output regionalized dataset:
* -------------------------------------------------------------------

* We include _ at the end of each parameter name to indicate all years of data
* are included.

EXECUTE_UNLOAD '%dsdir%%sep%WiNDCdatabase.gdx'

* Sets:

yr,r,s,m,gm,

* Production data:

ys0_,ld0_,kd0_,id0_,ty0_,

* Consumption data:

yh0_,fe0_,cd0_,c0_,i0_,g0_,bopdef0_,hhadj_,

* Trade data:

s0_,xd0_,xn0_,x0_,rx0_,a0_,nd0_,dd0_,m0_,ta0_,tm0_,
g
* Margins:

md0_,nm0_,dm0_;