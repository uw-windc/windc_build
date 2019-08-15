$TITLE Matrix balancing routine for enforcing parameter values

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

$IF NOT SET reldir $SET reldir "."
$IF NOT SET dsdir $SET dsdir "..%sep%built_datasets"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

* Output parameters for a single year:
$IF NOT SET year $SET year 2012

* Define loss function (huber, ls):
$IF NOT SET matbal $SET matbal ls

$IFTHENI.kestrel "%neos%" == "yes"
FILE opt / kestrel.opt /;
$ENDIF.kestrel

$ONTEXT
This sub-routine adjusts accounts from the core WiNDC database to match NASS
(National Agricultural Statistical Survey). It has three parts:
 - Read NASS data
 - Impose new totals
 - Re-calibrate dataset for a given year
$OFFTEXT

* -------------------------------------------------------------------
* Read in core regionalized WiNDC dataset:
* -------------------------------------------------------------------

SET sr "Super set of Regions (states + US) in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";
SET yr "Years in WiNDC Database";
SET nc "Dynamically created set from nass_units parameter, USDA NAICS codes";
PARAMETER nass_units(r,nc,*) "USDA NASS Ag Census data, with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD yr
$LOAD sr
$LOAD r
$LOAD nc<nass_units.dim2
$LOAD nass_units
$GDXIN

SET s "Goods\sectors (national data)";
SET gm(s) "Margin related sectors";
SET m "Margins (trade or transport)";

$GDXIN '%dsdir%%sep%WiNDC_disagg_nass.gdx'
$LOADDC s
$LOADDC m
$LOADDC gm

ALIAS(s,g),(r,rr);

PARAMETER ys0_(yr,r,g,s) "Sectoral supply";
PARAMETER id0_(yr,r,s,g) "Intermediate demand";
PARAMETER ld0_(yr,r,s) "Labor demand";
PARAMETER kd0_(yr,r,s) "Capital demand";
PARAMETER ty0_(yr,r,s) "Production tax rate";
PARAMETER m0_(yr,r,s) "Imports";
PARAMETER x0_(yr,r,s) "Exports of goods and services";
PARAMETER rx0_(yr,r,s) "Re-exports of goods and services";
PARAMETER md0_(yr,r,m,s) "Total margin demand";
PARAMETER nm0_(yr,r,g,m) "Margin demand from national market";
PARAMETER dm0_(yr,r,g,m) "Margin supply from local market";
PARAMETER s0_(yr,r,s) "Aggregate supply";
PARAMETER a0_(yr,r,s) "Armington supply";
PARAMETER ta0_(yr,r,s) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0_(yr,r,s) "Import tariff";
PARAMETER cd0_(yr,r,s) "Final demand";
PARAMETER c0_(yr,r) "Aggregate final demand";
PARAMETER yh0_(yr,r,s) "Household production";
PARAMETER fe0_(yr,r) "Factor endowments";
PARAMETER bopdef0_(yr,r) "Balance of payments";
PARAMETER hhadj_(yr,r) "Household adjustment";
PARAMETER g0_(yr,r,s) "Government demand";
PARAMETER i0_(yr,r,s) "Investment demand";
PARAMETER xn0_(yr,r,g) "Regional supply to national market";
PARAMETER xd0_(yr,r,g) "Regional supply to local market";
PARAMETER dd0_(yr,r,g) "Regional demand from local  market";
PARAMETER nd0_(yr,r,g) "Regional demand from national market";

* Production data:

$LOADDC ys0_
$LOADDC ld0_
$LOADDC kd0_
$LOADDC id0_
$LOADDC ty0_

* Consumption data:

$LOADDC yh0_
$LOADDC fe0_
$LOADDC cd0_
$LOADDC c0_
$LOADDC i0_
$LOADDC g0_
$LOADDC bopdef0_
$LOADDC hhadj_

* Trade data:

$LOADDC s0_
$LOADDC xd0_
$LOADDC xn0_
$LOADDC x0_
$LOADDC rx0_
$LOADDC a0_
$LOADDC nd0_
$LOADDC dd0_
$LOADDC m0_
$LOADDC ta0_
$LOADDC tm0_

* Margins:

$LOADDC md0_
$LOADDC nm0_
$LOADDC dm0_
$GDXIN

* -------------------------------------------------------------------
* Define national totals:
* -------------------------------------------------------------------

PARAMETER ys0nat;
PARAMETER m0nat;
PARAMETER x0nat;
PARAMETER va0nat;
PARAMETER i0nat;
PARAMETER g0nat;
PARAMETER cd0nat;

ys0nat(yr,s,g) = sum(r, ys0_(yr,r,s,g));
m0nat(yr,g) = sum(r, m0_(yr,r,g));
x0nat(yr,g) = sum(r, x0_(yr,r,g));
va0nat(yr,g) = sum(r, ld0_(yr,r,g) + kd0_(yr,r,g));
i0nat(yr,g) = sum(r, i0_(yr,r,g));
g0nat(yr,g) = sum(r, g0_(yr,r,g));
cd0nat(yr,g) = sum(r, cd0_(yr,r,g));

PARAMETER dataconschk "Consistency check on re-calibrated data";

dataconschk(r,s,'ys0','old') = sum(g, ys0_('%year%',r,s,g));
dataconschk(r,g,'id0','old') = sum(s, id0_('%year%',r,g,s));
dataconschk(r,s,'va0','old') = ld0_('%year%',r,s) + kd0_('%year%',r,s);
dataconschk(r,s,'tyrev','old') = (1-ty0_('%year%',r,s)) * sum(g, ys0_('%year%',r,s,g));

dataconschk(r,g,'i0','old') = i0_('%year%',r,g);
dataconschk(r,g,'g0','old') = g0_('%year%',r,g);
dataconschk(r,g,'cd0','old') = cd0_('%year%',r,g);
dataconschk(r,g,'yh0','old') = yh0_('%year%',r,g);
dataconschk(r,'total','hhadj','old') = hhadj_('%year%',r);
dataconschk(r,'total','bop','old') = bopdef0_('%year%',r);

dataconschk(r,g,'s0','old') = s0_('%year%',r,g);
dataconschk(r,g,'xd0','old') = xd0_('%year%',r,g);
dataconschk(r,g,'xn0','old') = xn0_('%year%',r,g);
dataconschk(r,g,'x0','old') = x0_('%year%',r,g);
dataconschk(r,g,'rx0','old') = rx0_('%year%',r,g);
dataconschk(r,g,'a0','old') = a0_('%year%',r,g);
dataconschk(r,g,'nd0','old') = nd0_('%year%',r,g);
dataconschk(r,g,'dd0','old') = dd0_('%year%',r,g);
dataconschk(r,g,'m0','old') = m0_('%year%',r,g);

dataconschk(r,g,'md0','old') = sum(m, md0_('%year%',r,m,g));
dataconschk(r,g,'nm0','old') = sum(m, nm0_('%year%',r,g,m));
dataconschk(r,g,'dm0','old') = sum(m, dm0_('%year%',r,g,m));

* -------------------------------------------------------------------
* Impose outside data: NASS
* -------------------------------------------------------------------

* This routine differs from the SEDS implementation. No sectors are
* added. Rather, we re-adjust totals based on 2012 NASS data.

SET mapg(g,nc) "Mapping between WiNDC and NAICS codes" /
	oila.(11111,11112),
	grna.(11113,11114,11115,11116,11119),
	vega.(1112),
	nuta.(1113),
	floa.(1114),
	otha.(1119),
	befa.(11211),
	drya.(11212),
	otaa.(1122,1124,1125,1129),
	egga.(1123) /;

PARAMETER data(r,g) "Mapped sales data (10s bill. dollars)";

data(r,g) = sum(mapg(g,nc), nass_units(r,nc,'millions of us dollars (USD)')) / 1e4;

* In this example, we use NASS state by commodity sales data. Thus, we re-adjust
* s0, or gross output.

SET ns(g)	"NASS sectors";

ns(g) = yes$sum(r, data(r,g));

s0_('2012',r,g)$(ns(g) and data(r,g)) = data(r,g);

* -------------------------------------------------------------------------
* Write a re-calibration routine which minimally shifts data to maintain
* micro-consistency.
* -------------------------------------------------------------------------


$ONTEXT
Huber's approach to matrix balancing incorporates a barrier function
to assure that nonzeros in the source data remain nonzero in the
estimated matrix.

Huber's loss function is represented by:

                | a0 * sqr(a/a0 - 1)            for |a/a0-1| <= theta
        L(a) =  |
                | a0 * 2 * theta * |a/a0-1|     for |a/a0-1| >= theta

The loss function is quadratic in the neighborhood of a0 and becomes
linear as we move away from the target, with a slope chosen to
maintain continuity of the first derivative across the threshold value
a=a0*(1+theta) ).

The motivation for Huber's approach is to overcome the disadvantage of
the least squares approach to "outliers" -- residuals which are large
in magnitude.  These are squared in the conventional least-squares
formulation and therefore contribute heavily to the objective
function.  Outliers in the least-squares model have an undue influence
over the recalibration point.  Huber's approach places less weight on
the outlying points and

See http://en.wikipedia.org/wiki/Robust_statistics or Huber (1981)
(Robust Statistics, John Wiley and Sons, New York).

In the hybrid barrier method we retain Huber's loss function for
increases from the target value and we add a log term to penalize
values which go to zero:

        | a0 * 2 * theta * (a/a0-1)			for a/a0-1 >= theta
        |
L(a) =  | a0 * sqr(a/a0 - 1)				for -gamma <= a/a0-1 <= theta
        |
        | a0 * 2 * gamma * (1-gamma) * log(a/a0)	for a/a0-1 <= -gamma

$OFFTEXT

SET mat "Select parameters for huber objective" / ys0,id0 /;
SET nonzero(mat,r,*,*) "Nonzeros in the reference data";
SET zeros(mat,r,*,*) "Zeros in the reference data";

PARAMETER zeropenalty "Penalty for imposing non-zero elements" / 1e8 /;

POSITIVE VARIABLE YS "Production Variable";
POSITIVE VARIABLE ID "Production Variable";
POSITIVE VARIABLE LD "Production Variable";
POSITIVE VARIABLE KD "Production Variable";

POSITIVE VARIABLE ARM "Trade Variable";
POSITIVE VARIABLE ND "Trade Variable";
POSITIVE VARIABLE DD "Trade Variable";
POSITIVE VARIABLE IMP "Trade Variable";

POSITIVE VARIABLE SUP "Supply Variable";
POSITIVE VARIABLE XD "Supply Variable";
POSITIVE VARIABLE XN "Supply Variable";
POSITIVE VARIABLE XPT "Supply Variable";
POSITIVE VARIABLE RX "Supply Variable";

POSITIVE VARIABLE NM "Margin Variable";
POSITIVE VARIABLE DM "Margin Variable";
POSITIVE VARIABLE MARD "Margin Variable";

POSITIVE VARIABLE YH "Demand Variable";
POSITIVE VARIABLE CD "Demand Variable";
POSITIVE VARIABLE INV "Demand Variable";
POSITIVE VARIABLE GD "Demand Variable";

POSITIVE VARIABLE X1 "Percentage deviations";
POSITIVE VARIABLE X2 "Percentage deviations";
POSITIVE VARIABLE X3 "Percentage deviations";


VARIABLE OBJ "Objective variable";
VARIABLE BOP(r) "Balance of payments";

EQUATION obj_ls "Least squares objective definition";
EQUATION obj_huber "Hybrid huber objective definition";

EQUATION zp_y "Zero profit condition";
EQUATION zp_a "Zero profit condition";
EQUATION zp_x	 "Zero profit condition";
EQUATION zp_ms "Zero profit condition";
EQUATION zp_c "Zero profit condition";

EQUATION mc_py "Market clearing condition";
EQUATION mc_pa "Market clearing condition";
EQUATION mc_pn "Market clearing condition";
EQUATION mc_pfx "Market clearing condition";
EQUATION mc_pm "Market clearing condition";
EQUATION mc_pfx "Market clearing condition";
EQUATION mc_pd "Market clearing condition";

EQUATION incbal "Income balance";

EQUATION expdef "Gross exports must be greater than re-exports";

EQUATION netgenbalpos1 "Net generation of electricity balancing";
EQUATION netgenbalpos2 "Net generation of electricity balancing";
EQUATION netgenbalneg1 "Net generation of electricity balancing";
EQUATION netgenbalneg2 "Net generation of electricity balancing";

EQUATION natys0 "Verify regional totals == national totals";
EQUATION natm0 "Verify regional totals == national totals";
EQUATION natx0 "Verify regional totals == national totals";
EQUATION natva "Verify regional totals == national totals";
EQUATION nati0 "Verify regional totals == national totals";
EQUATION natg0 "Verify regional totals == national totals";

EQUATION natc0 "Verify regional totals == national totals";

EQUATION demtotup "Verify energy demands match SEDS";
EQUATION demtotlo "Verify energy demands match SEDS";

EQUATION x2def "Huber constraints";
EQUATION x3def "Huber constraints";

PARAMETER ys0loop;
PARAMETER id0loop;
PARAMETER ld0loop;
PARAMETER kd0loop;
PARAMETER ty;
PARAMETER ta;
PARAMETER a0loop;
PARAMETER nd0loop;
PARAMETER dd0loop;
PARAMETER tm;
PARAMETER m0loop;
PARAMETER s0loop;
PARAMETER xd0loop;
PARAMETER xn0loop;
PARAMETER x0loop;
PARAMETER rx0loop;
PARAMETER nm0loop;
PARAMETER dm0loop;
PARAMETER md0loop;
PARAMETER cd0loop;
PARAMETER c0loop;
PARAMETER g0loop;
PARAMETER i0loop;
PARAMETER yh0loop;
PARAMETER bopdef0loop;
PARAMETER hhadjloop;
PARAMETER netgenloop;
PARAMETER nat_ys;
PARAMETER nat_m;
PARAMETER nat_x;
PARAMETER nat_va;
PARAMETER nat_i;
PARAMETER nat_g;
PARAMETER nat_c;
PARAMETER edloop;

* Huber method: additional parameters needed if using Huber's matrix
* balancing routine:

PARAMETER v0_(mat,r,*,*) "matrix values";
PARAMETER gammab "Lower bound cross-over tolerance" / 0.5 /;
PARAMETER thetab "Upper bound cross-over tolerance" / 0.25 /;

$MACRO	MV(mat,r,s,g) (YS(r,s,g)$SAMEAS(mat,'ys0') + ID(r,s,g)$SAMEAS(mat,'id0'))

x2def(nonzero(mat,r,s,g))..   X2(mat,r,s,g) + X1(mat,r,s,g) =G= (MV(mat,r,s,g)/v0_(mat,r,s,g)-1);
x3def(nonzero(mat,r,s,g))..   X3(mat,r,s,g) - X2(mat,r,s,g) =G= (1-MV(mat,r,s,g)/v0_(mat,r,s,g));

obj_huber..  OBJ =E= 	sum(nonzero(mat,r,s,g), abs(v0_(mat,r,s,g)) *
	                (sqr(X2(mat,r,s,g)) + 2*thetab*X1(mat,r,s,g) -
			2*gammab*(1-gammab)*log(1-gammab-X3(mat,r,s,g)))) +

			sum((r,s)$ld0loop(r,s), abs(ld0loop(r,s)) * sqr(LD(r,s) / ld0loop(r,s) - 1)) +
			sum((r,s)$kd0loop(r,s), abs(kd0loop(r,s)) * sqr(KD(r,s) / kd0loop(r,s) - 1)) +
			sum((r,g)$a0loop(r,g), abs(a0loop(r,g)) * sqr(ARM(r,g) / a0loop(r,g) - 1)) +
			sum((r,g)$nd0loop(r,g), abs(nd0loop(r,g)) * sqr(ND(r,g) / nd0loop(r,g) - 1)) +
			sum((r,g)$dd0loop(r,g), abs(dd0loop(r,g)) * sqr(DD(r,g) / dd0loop(r,g) - 1)) +
			sum((r,g)$m0loop(r,g), abs(m0loop(r,g)) * sqr(IMP(r,g) / m0loop(r,g) - 1)) +
			sum((r,g)$s0loop(r,g), abs(s0loop(r,g)) * sqr(SUP(r,g) / s0loop(r,g) - 1)) +
			sum((r,g)$xd0loop(r,g), abs(xd0loop(r,g)) * sqr(XD(r,g) / xd0loop(r,g) - 1)) +
			sum((r,g)$xn0loop(r,g), abs(xn0loop(r,g)) * sqr(XN(r,g) / xn0loop(r,g) - 1)) +
			sum((r,g)$x0loop(r,g), abs(x0loop(r,g)) * sqr(XPT(r,g) / x0loop(r,g) - 1)) +
			sum((r,g)$rx0loop(r,g), abs(rx0loop(r,g)) * sqr(RX(r,g) / rx0loop(r,g) - 1)) +
			sum((r,m,g)$nm0loop(r,g,m), abs(nm0loop(r,g,m)) * sqr(NM(r,g,m) / nm0loop(r,g,m) - 1)) +
			sum((r,m,g)$dm0loop(r,g,m), abs(dm0loop(r,g,m)) * sqr(DM(r,g,m) / dm0loop(r,g,m) - 1)) +
			sum((r,m,g)$md0loop(r,m,g), abs(md0loop(r,m,g)) * sqr(MARD(r,m,g) / md0loop(r,m,g) - 1)) +
			sum((r,g)$yh0loop(r,g), abs(yh0loop(r,g)) * sqr(YH(r,g) / yh0loop(r,g) - 1)) +
			sum((r,g)$cd0loop(r,g), abs(cd0loop(r,g)) * sqr(CD(r,g) / cd0loop(r,g) - 1)) +
			sum((r,g)$i0loop(r,g), abs(i0loop(r,g)) * sqr(INV(r,g) / i0loop(r,g) - 1)) +
			sum((r,g)$g0loop(r,g), abs(g0loop(r,g)) * sqr(GD(r,g) / g0loop(r,g) - 1)) +
			sum((r)$bopdef0loop(r), abs(bopdef0loop(r)) * sqr(BOP(r) / bopdef0loop(r) - 1)) +
		zeropenalty * (
			sum((r,s,g)$(not ys0loop(r,s,g)), YS(r,s,g)) +
			sum((r,g,s)$(not id0loop(r,g,s)), ID(r,g,s)) +
			sum((r,s)$(not ld0loop(r,s)), LD(r,s)) +
			sum((r,s)$(not kd0loop(r,s)), KD(r,s)) +
			sum((r,g)$(not a0loop(r,g)), ARM(r,g)) +
			sum((r,g)$(not nd0loop(r,g)), ND(r,g)) +
			sum((r,g)$(not dd0loop(r,g)), DD(r,g)) +
			sum((r,g)$(not m0loop(r,g)), IMP(r,g)) +
			sum((r,g)$(not s0loop(r,g)), SUP(r,g)) +
			sum((r,g)$(not xd0loop(r,g)), XD(r,g)) +
			sum((r,g)$(not xn0loop(r,g)), XN(r,g)) +
			sum((r,g)$(not x0loop(r,g)), XPT(r,g)) +
			sum((r,g)$(not rx0loop(r,g)), RX(r,g)) +
			sum((r,m,g)$(not nm0loop(r,g,m)), NM(r,g,m)) +
			sum((r,m,g)$(not dm0loop(r,g,m)), DM(r,g,m)) +
			sum((r,m,g)$(not md0loop(r,m,g)), MARD(r,m,g)) +
			sum((r,g)$(not yh0loop(r,g)), YH(r,g)) +
			sum((r,g)$(not cd0loop(r,g)), CD(r,g)) +
			sum((r,g)$(not i0loop(r,g)), INV(r,g)) +
			sum((r,g)$(not g0loop(r,g)), GD(r,g)));

* Least squares:

obj_ls..	OBJ =E= sum((r,s,g)$ys0loop(r,s,g), abs(ys0loop(r,s,g)) * sqr(YS(r,s,g) / ys0loop(r,s,g) - 1)) +
			sum((r,g,s)$id0loop(r,g,s), abs(id0loop(r,g,s)) * sqr(ID(r,g,s) / id0loop(r,g,s) - 1)) +
			sum((r,s)$ld0loop(r,s), abs(ld0loop(r,s)) * sqr(LD(r,s) / ld0loop(r,s) - 1)) +
			sum((r,s)$kd0loop(r,s), abs(kd0loop(r,s)) * sqr(KD(r,s) / kd0loop(r,s) - 1)) +
			sum((r,g)$a0loop(r,g), abs(a0loop(r,g)) * sqr(ARM(r,g) / a0loop(r,g) - 1)) +
			sum((r,g)$nd0loop(r,g), abs(nd0loop(r,g)) * sqr(ND(r,g) / nd0loop(r,g) - 1)) +
			sum((r,g)$dd0loop(r,g), abs(dd0loop(r,g)) * sqr(DD(r,g) / dd0loop(r,g) - 1)) +
			sum((r,g)$m0loop(r,g), abs(m0loop(r,g)) * sqr(IMP(r,g) / m0loop(r,g) - 1)) +
			sum((r,g)$s0loop(r,g), abs(s0loop(r,g)) * sqr(SUP(r,g) / s0loop(r,g) - 1)) +
			sum((r,g)$xd0loop(r,g), abs(xd0loop(r,g)) * sqr(XD(r,g) / xd0loop(r,g) - 1)) +
			sum((r,g)$xn0loop(r,g), abs(xn0loop(r,g)) * sqr(XN(r,g) / xn0loop(r,g) - 1)) +
			sum((r,g)$x0loop(r,g), abs(x0loop(r,g)) * sqr(XPT(r,g) / x0loop(r,g) - 1)) +
			sum((r,g)$rx0loop(r,g), abs(rx0loop(r,g)) * sqr(RX(r,g) / rx0loop(r,g) - 1)) +
			sum((r,m,g)$nm0loop(r,g,m), abs(nm0loop(r,g,m)) * sqr(NM(r,g,m) / nm0loop(r,g,m) - 1)) +
			sum((r,m,g)$dm0loop(r,g,m), abs(dm0loop(r,g,m)) * sqr(DM(r,g,m) / dm0loop(r,g,m) - 1)) +
			sum((r,m,g)$md0loop(r,m,g), abs(md0loop(r,m,g)) * sqr(MARD(r,m,g) / md0loop(r,m,g) - 1)) +
			sum((r,g)$yh0loop(r,g), abs(yh0loop(r,g)) * sqr(YH(r,g) / yh0loop(r,g) - 1)) +
			sum((r,g)$cd0loop(r,g), abs(cd0loop(r,g)) * sqr(CD(r,g) / cd0loop(r,g) - 1)) +
			sum((r,g)$i0loop(r,g), abs(i0loop(r,g)) * sqr(INV(r,g) / i0loop(r,g) - 1)) +
			sum((r,g)$g0loop(r,g), abs(g0loop(r,g)) * sqr(GD(r,g) / g0loop(r,g) - 1)) +
			sum((r)$bopdef0loop(r), abs(bopdef0loop(r)) * sqr(BOP(r) / bopdef0loop(r) - 1)) +
		zeropenalty * (
			sum((r,s,g)$(not ys0loop(r,s,g)), sqr(YS(r,s,g))) +
			sum((r,g,s)$(not id0loop(r,g,s)), sqr(ID(r,g,s))) +
			sum((r,s)$(not ld0loop(r,s)), sqr(LD(r,s))) +
			sum((r,s)$(not kd0loop(r,s)), sqr(KD(r,s))) +
			sum((r,g)$(not a0loop(r,g)), sqr(ARM(r,g))) +
			sum((r,g)$(not nd0loop(r,g)), sqr(ND(r,g))) +
			sum((r,g)$(not dd0loop(r,g)), sqr(DD(r,g))) +
			sum((r,g)$(not m0loop(r,g)), sqr(IMP(r,g))) +
			sum((r,g)$(not s0loop(r,g)), sqr(SUP(r,g))) +
			sum((r,g)$(not xd0loop(r,g)), sqr(XD(r,g))) +
			sum((r,g)$(not xn0loop(r,g)), sqr(XN(r,g))) +
			sum((r,g)$(not x0loop(r,g)), sqr(XPT(r,g))) +
			sum((r,g)$(not rx0loop(r,g)), sqr(RX(r,g))) +
			sum((r,m,g)$(not nm0loop(r,g,m)), sqr(NM(r,g,m))) +
			sum((r,m,g)$(not dm0loop(r,g,m)), sqr(DM(r,g,m))) +
			sum((r,m,g)$(not md0loop(r,m,g)), sqr(MARD(r,m,g))) +
			sum((r,g)$(not yh0loop(r,g)), sqr(YH(r,g))) +
			sum((r,g)$(not cd0loop(r,g)), sqr(CD(r,g))) +
			sum((r,g)$(not i0loop(r,g)), sqr(INV(r,g))) +
			sum((r,g)$(not g0loop(r,g)), sqr(GD(r,g))));

zp_y(r,s)..	(1-ty(r,s)) * sum(g, YS(r,s,g)) =E= sum(g, ID(r,g,s)) + LD(r,s) + KD(r,s);
zp_a(r,g)..	(1-ta(r,g)) * ARM(r,g) + RX(r,g) =E= ND(r,g) + DD(r,g) + (1+tm(r,g)) * IMP(r,g) + sum(m, MARD(r,m,g));
zp_x(r,g)..	SUP(r,g) + RX(r,g) =E= XPT(r,g) + XN(r,g) + XD(r,g);
zp_ms(r,m)..	sum(s, NM(r,s,m) + DM(r,s,m)) =E= sum(g, MARD(r,m,g));

mc_py(r,g)..	sum(s, YS(r,s,g)) + YH(r,g) =E= SUP(r,g);
mc_pa(r,g)..	ARM(r,g) =E= sum(s, ID(r,g,s)) + CD(r,g) + GD(r,g) + INV(r,g);
mc_pd(r,g)..	XD(r,g) =E= sum(m, DM(r,g,m)) + DD(r,g);
mc_pn(g)..	sum(r, XN(r,g)) =E= sum((r,m), NM(r,g,m)) + sum(r, ND(r,g));
mc_pfx..	sum(r, BOP(r) + hhadjloop(r)) + sum((r,g), XPT(r,g)) =E= sum((r,g), IMP(r,g));

expdef(r,g)..	XPT(r,g) =G= RX(r,g);

incbal(r)..	sum(g, CD(r,g) + GD(r,g) + INV(r,g)) =E=
		sum(g, YH(r,g)) + BOP(r) + hhadjloop(r) + sum(s, LD(r,s) + KD(r,s)) +
		sum(g, ta(r,g)*ARM(r,g) + tm(r,g)*IMP(r,g)) + sum(s, ty(r,s)*sum(g, YS(r,s,g)));

natys0(s)..	sum((r,g), YS(r,s,g)) =E= sum(g, nat_ys(s,g));

natx0(s)..	sum(r, XPT(r,s)) =E= nat_x(s);

natm0(s)..	sum(r, IMP(r,s)) =E= nat_m(s);

natva(s)..	sum(r, LD(r,s) + KD(r,s)) =E= nat_va(s);

natg0(s)..	sum(r, GD(r,s)) =E= nat_g(s);

nati0(s)..	sum(r, INV(r,s)) =E= nat_i(s);

natc0(s)..	sum(r, CD(r,s)) =E= nat_c(s);

$IF %matbal% == huber model regcalib /obj_huber, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, natx0, natm0, natva, natg0, nati0, natc0, natys0 /;

$IF %matbal% == ls model regcalib /obj_ls, expdef, zp_y, zp_a, zp_x, zp_ms, mc_py, mc_pa, mc_pn, mc_pfx, mc_pd, incbal, natx0, natm0, natva, natg0, nati0, natc0, natys0 /;


* We could alternatively produce data for all years:
* loop(yr$(not SAMEAS(yr,'2015')),

loop(yr$(SAMEAS(yr,'%year%')),

* Define looping data:

ys0loop(r,s,g) = ys0_(yr,r,s,g);
id0loop(r,g,s) = id0_(yr,r,g,s);
ld0loop(r,g) = ld0_(yr,r,g);
kd0loop(r,g) = kd0_(yr,r,g);
ty(r,s) = ty0_(yr,r,s);
a0loop(r,g) = a0_(yr,r,g);
nd0loop(r,g) = nd0_(yr,r,g);
dd0loop(r,g) = dd0_(yr,r,g);
m0loop(r,g) = m0_(yr,r,g);
s0loop(r,g) = s0_(yr,r,g);
x0loop(r,g) = x0_(yr,r,g);
xn0loop(r,g) = xn0_(yr,r,g);
xd0loop(r,g) = xd0_(yr,r,g);
rx0loop(r,g) = rx0_(yr,r,g);
md0loop(r,m,g) = md0_(yr,r,m,g);
nm0loop(r,g,m) = nm0_(yr,r,g,m);
dm0loop(r,g,m) = dm0_(yr,r,g,m);
yh0loop(r,g) = yh0_(yr,r,g);
cd0loop(r,g) = cd0_(yr,r,g);
i0loop(r,g) = i0_(yr,r,g);
g0loop(r,g) = g0_(yr,r,g);
bopdef0loop(r) = bopdef0_(yr,r);
hhadjloop(r) = hhadj_(yr,r);
ta(r,g) = ta0_(yr,r,g);
tm(r,g) = tm0_(yr,r,g);
nat_ys(s,g) = ys0nat(yr,s,g);
nat_x(s) = x0nat(yr,s);
nat_m(s) = m0nat(yr,s);
nat_va(s) = va0nat(yr,s);
nat_g(s) = g0nat(yr,s);
nat_i(s) = i0nat(yr,s);
nat_c(s) = cd0nat(yr,s);

$IF %matbal% == huber v0('ys0',r,s,g) = ys0loop(r,s,g);
$IF %matbal% == huber v0('id0',r,s,g) = id0loop(r,s,g);
$IF %matbal% == huber nonzero(mat,r,s,g) = yes$v0(mat,r,s,g);
$IF %matbal% == huber zeros(mat,r,s,g) = yes$(not v0(mat,r,s,g));
$IF %matbal% == huber X1.FX(zeros) = 0;
$IF %matbal% == huber X2.FX(zeros) = 0;
$IF %matbal% == huber X3.FX(zeros) = 0;
$IF %matbal% == huber X2.UP(nonzero) = thetab;
$IF %matbal% == huber X2.LO(nonzero) = -gammab;
$IF %matbal% == huber X3.UP(nonzero) = 1-gammab-1e-5;
$IF %matbal% == huber X3.LO(nonzero) = 0;
$IF %matbal% == huber X1.L(nonzero) = 0;
$IF %matbal% == huber X2.L(nonzero) = 0;
$IF %matbal% == huber X3.L(nonzero) = 0;

* Set starting values for balancing routine:

YS.L(r,s,g) = ys0loop(r,s,g);
ID.L(r,g,s) = id0loop(r,g,s);
LD.L(r,s) = ld0loop(r,s);
KD.L(r,s) = kd0loop(r,s);
ARM.L(r,g) = a0loop(r,g);
ND.L(r,g) = nd0loop(r,g);
DD.L(r,g) = dd0loop(r,g);
IMP.L(r,g) = m0loop(r,g);
SUP.L(r,g) = s0loop(r,g);
XD.L(r,g) = xd0loop(r,g);
XN.L(r,g) = xn0loop(r,g);
XPT.L(r,g) = x0loop(r,g);
RX.L(r,g) = rx0loop(r,g);
NM.L(r,g,m) = nm0loop(r,g,m);
DM.L(r,g,m) = dm0loop(r,g,m);
MARD.L(r,m,g) = md0loop(r,m,g);
YH.L(r,g) = yh0loop(r,g);
CD.L(r,g) = cd0loop(r,g);
INV.L(r,g) = i0loop(r,g);
GD.L(r,g) = g0loop(r,g);
BOP.L(r) = bopdef0loop(r);

* Impose some restrictions:

RX.FX(r,g)$(rx0loop(r,g) = 0) = 0;
MARD.FX(r,m,g)$(md0loop(r,m,g) = 0) = 0;

* Bounds on NASS data:

SUP.LO(r,g)$ns(g) = 0.8 * s0loop(r,g);
SUP.UP(r,g)$ns(g) = 1.2 * s0loop(r,g);

* Solve:

$IFTHENI.matbal "%matbal%" == 'huber'

$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_nlp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel

SOLVE regcalib using NLP minimizing OBJ;

$ELSEIF.matbal "%matbal%" == 'ls'

$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_qcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel

SOLVE regcalib using QCP minimizing OBJ;

$ELSE.matbal
ABORT("NASS solver error. must specify matbal as either huber or ls.")
$ENDIF.matbal



ABORT$(regcalib.modelstat > 1) "Optimal solution not found.";

* Reset parameter values:

ys0_(yr,r,s,g) = YS.L(r,s,g);
id0_(yr,r,g,s) = ID.L(r,g,s);
ld0_(yr,r,s) = LD.L(r,s);
kd0_(yr,r,s) = KD.L(r,s);
a0_(yr,r,g) = ARM.L(r,g);
nd0_(yr,r,g) = ND.L(r,g);
dd0_(yr,r,g) = DD.L(r,g);
m0_(yr,r,g) = IMP.L(r,g);
s0_(yr,r,g) = SUP.L(r,g);
xd0_(yr,r,g) = XD.L(r,g);
xn0_(yr,r,g) = XN.L(r,g);
x0_(yr,r,g) = XPT.L(r,g);
rx0_(yr,r,g) = RX.L(r,g);
nm0_(yr,r,g,m) = NM.L(r,g,m);
dm0_(yr,r,g,m) = DM.L(r,g,m);
md0_(yr,r,m,g) = MARD.L(r,m,g);
yh0_(yr,r,g) = YH.L(r,g);
cd0_(yr,r,g) = CD.L(r,g);
i0_(yr,r,g) = INV.L(r,g);
g0_(yr,r,g) = GD.L(r,g);
bopdef0_(yr,r) = BOP.L(r);

* Reset variables boundaries:

SUP.LO(r,g) = 0;
SUP.UP(r,g) = inf;

);

ys0loop(r,s,g) = YS.L(r,s,g);
id0loop(r,g,s) = ID.L(r,g,s);
ld0loop(r,s) = LD.L(r,s);
kd0loop(r,s) = KD.L(r,s);
ty(r,s) = ty0_('%year%',r,s);
a0loop(r,g) = ARM.L(r,g);
nd0loop(r,g) = ND.L(r,g);
dd0loop(r,g) = DD.L(r,g);
m0loop(r,g) = IMP.L(r,g);
s0loop(r,g) = SUP.L(r,g);
xd0loop(r,g) = XD.L(r,g);
xn0loop(r,g) = XN.L(r,g);
x0loop(r,g) = XPT.L(r,g);
rx0loop(r,g) = RX.L(r,g);
nm0loop(r,g,m) = NM.L(r,g,m);
dm0loop(r,g,m) = DM.L(r,g,m);
md0loop(r,m,g) = MARD.L(r,m,g);
yh0loop(r,g) = YH.L(r,g);
cd0loop(r,g) = CD.L(r,g);
i0loop(r,g) = INV.L(r,g);
g0loop(r,g) = GD.L(r,g);
bopdef0loop(r) = BOP.L(r);
ta(r,g) = ta0_('%year%',r,g);
tm(r,g) = tm0_('%year%',r,g);
c0loop(r) = sum(g, cd0loop(r,g));

* -------------------------------------------------------------------
* Output regionalized dataset calibrated to NASS:
* -------------------------------------------------------------------

EXECUTE_UNLOAD '%dsdir%%sep%WiNDC_cal_%year%_nass.gdx'

* Sets:

r,s,m,gm,

* Production data:

ys0loop=ys0,ld0loop=ld0,kd0loop=kd0,id0loop=id0,ty=ty0,

* Consumption data:

yh0loop=yh0,c0loop=c0,cd0loop=cd0,i0loop=i0,g0loop=g0,bopdef0loop=bopdef0,hhadjloop=hhadj,

* Trade data:

s0loop=s0,xd0loop=xd0,xn0loop=xn0,x0loop=x0,rx0loop=rx0,a0loop=a0,
nd0loop=nd0,dd0loop=dd0,m0loop=m0,ta=ta0,tm=tm0,

* Margins:

md0loop=md0,nm0loop=nm0,dm0loop=dm0;
