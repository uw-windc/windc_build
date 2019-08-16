$TITLE	Balance the dataset and verify benchmark consistency

$IF NOT SET reldir $SET reldir "."
$IF NOT SET temp $SET temp "temp"
$IF NOT SET gengdx $SET gengdx "gdx_temp"

$IF NOT SET neos $SET neos "no"
$IF NOT SET neosserver $SET neosserver "neos-server.org:3333"
$IF NOT SET kestrel_nlp $SET kestrel_nlp "conopt"
$IF NOT SET kestrel_lp $SET kestrel_lp "cplex"
$IF NOT SET kestrel_qcp $SET kestrel_qcp "cplex"
$IF NOT SET kestrel_mcp $SET kestrel_mcp "path"

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

$IFTHENI "%neos%" == "yes"
FILE opt / kestrel.opt /;
$ENDIF


* -------------------------------------------------------------------
* 	Set optimization routine for matrix balancing:
*	Least Squares (ls) or Huber (huber)

*	Note that the routine computes the solution for both methods and
*	reports the percent difference between the two. The set
*	environment variable is the chosen of the two methods.

* -------------------------------------------------------------------

$IF NOT SET matbal $SET matbal ls

SET bal "Matrix balancing objectives" / ls, huber /;

* Set year for calibration check using an accounting model:

$IF NOT SET year $SET year 2009


* -------------------------------------------------------------------
* 	Read in the dataset:
* -------------------------------------------------------------------

SET yr "Years in WiNDC Database";
SET i "BEA Goods and sectors categories";
SET m "Margins (trade or transport)";
SET fd "BEA Final demand categories";
SET ts "BEA Taxes and subsidies categories";
SET va "BEA Value added categories";


$GDXIN '%reldir%%sep%windc_base.gdx'
$LOADDC yr
$LOADDC i
$LOADDC va
$LOADDC fd
$LOADDC ts
$GDXIN

ALIAS(i,j);


$GDXIN '%reldir%%sep%temp%sep%gdx_temp%sep%national_cgeparm_raw.gdx'
$LOADDC m

SET imrg(i) "Goods which only generate margins" /
	mvt	"Motor vehicle and parts dealers (441)"
	fbt	"Food and beverage stores (445)"
	gmt	"General merchandise stores (452)" /;

PARAMETER y_0(yr,i)	"Gross output";
PARAMETER ys_0(yr,j,i) "Sectoral supply";
PARAMETER fs_0(yr,i) "Household supply";
PARAMETER id_0(yr,i,j) "Intermediate demand";
PARAMETER fd_0(yr,i,fd) "Final demand";
PARAMETER va_0(yr,va,j) "Value added";
PARAMETER ts_0(yr,ts,i) "Taxes and subsidies";
PARAMETER m_0(yr,i) "Imports";
PARAMETER x_0(yr,i) "Exports of goods and services";
PARAMETER mrg_0(yr,i) "Trade margins";
PARAMETER trn_0(yr,i) "Transportation costs";
PARAMETER duty_0(yr,i) "Import duties";
PARAMETER sbd_0(yr,i) "Subsidies on products";
PARAMETER tax_0(yr,i) "Taxes on products";
PARAMETER ms_0(yr,i,m) "Margin supply";
PARAMETER md_0(yr,m,i) "Margin demand";
PARAMETER s_0(yr,i)	"Aggregate supply";
PARAMETER d_0(yr,i)	"Sales in the domestic market";
PARAMETER a_0(yr,i) "Armington supply";
PARAMETER bopdef_0(yr) "Balance of payments deficit";
PARAMETER ta_0(yr,i) "Tax net subsidy rate on intermediate demand";
PARAMETER tm_0(yr,i) "Import tariff";

$LOADDC y_0=y0
$LOADDC ys_0=ys0
$LOADDC fs_0=fs0
$LOADDC id_0=id0
$LOADDC fd_0=fd0
$LOADDC va_0=va0
$LOADDC m_0=m0
$LOADDC x_0=x0
$LOADDC ms_0=ms0
$LOADDC md_0=md0
$LOADDC a_0=a0
$LOADDC ta_0=ta0
$LOADDC tm_0=tm0
$GDXIN


* -------------------------------------------------------------------
* 	Matrix balancing routine (LS, Huber):
* -------------------------------------------------------------------

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

* Define parameter structure without time index:

PARAMETER y0(i) "Gross output";;
PARAMETER ys0(j,i) "Sectoral supply";
PARAMETER fs0(i) "Household supply";
PARAMETER id0(i,j) "Intermediate demand";
PARAMETER fd0(i,fd) "Final demand";
PARAMETER va0(va,j) "Vaue added";
PARAMETER ts0(ts,i) "Taxes and subsidies";
PARAMETER m0(i) "Imports";
PARAMETER x0(i) "Exports of goods and services";
PARAMETER mrg0(i) "Trade margins";
PARAMETER trn0(i) "Transportation costs";
PARAMETER duty0(i) "Import duties";
PARAMETER sbd0(i) "Subsidies on products";
PARAMETER tax0(i) "Taxes on products";
PARAMETER ms0(i,m) "Margin supply";
PARAMETER md0(m,i) "Margin demand";
PARAMETER s0(i) "Aggregate supply";
PARAMETER d0(i) "Sales in the domestic market";
PARAMETER a0(i) "Armington supply";
PARAMETER bopdef "Balance of payments deficit";
PARAMETER ta0(i) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0(i) "Import tariff";

* Additional parameters needed if using Huber's matrix balancing routine:

SET mat "Select parameters for huber objective" / ys0,id0 /;
SET nonzero(mat,i,j) "Nonzeros in the reference data";
SET zeros(mat,i,j) "Zeros in the reference data";

PARAMETER v0(mat,i,j) "Matrix values";

PARAMETER gammab "Lower bound cross-over tolerance" / 0.5 /;
PARAMETER thetab "Upper bound cross-over tolerance" / 0.25 /;

POSITIVE VARIABLE ys0_(j,i) "Cailbration variable";
POSITIVE VARIABLE fs0_(i) "Cailbration variable";
POSITIVE VARIABLE ms0_(i,m) "Cailbration variable";
POSITIVE VARIABLE y0_(i) "Cailbration variable";
POSITIVE VARIABLE id0_(i,j) "Cailbration variable";
POSITIVE VARIABLE fd0_(i,fd) "Cailbration variable";
POSITIVE VARIABLE va0_(va,j) "Cailbration variable";
POSITIVE VARIABLE a0_(i) "Cailbration variable";
POSITIVE VARIABLE x0_(i) "Cailbration variable";
POSITIVE VARIABLE m0_(i) "Cailbration variable";
POSITIVE VARIABLE md0_(m,i) "Cailbration variable";
POSITIVE VARIABLE X1(mat,i,j) "Percentage deviations";
POSITIVE VARIABLE X2(mat,i,j) "Percentage deviations";
POSITIVE VARIABLE X3(mat,i,j) "Percentage deviations";

VARIABLE OBJ;

EQUATION lsobj;
EQUATION huberobj;
EQUATION mkt_py;
EQUATION mkt_pa;
EQUATION mkt_pm;
EQUATION prf_y;
EQUATION prf_a;
EQUATION x2def;
EQUATION x3def;

* -------------------------------------------------------------------
* 	Least squares objective function:
* -------------------------------------------------------------------

lsobj..
  OBJ
  =E=
  sum((j,i)$ys0(j,i),  abs(ys0(j,i)) * sqr(ys0_(j,i)/ys0(j,i) - 1))
	+ sum((i,j)$id0(i,j),  abs(id0(i,j)) * sqr(id0_(i,j)/id0(i,j) - 1))
	+ sum((i)$fs0(i),    abs(fs0(i)) * sqr(fs0_(i)/fs0(i) - 1))
	+ sum((i,m)$ms0(i,m),  abs(ms0(i,m)) * sqr(ms0_(i,m)/ms0(i,m) - 1))
	+ sum((i)$y0(i),    abs(y0(i)) * sqr(y0_(i)/y0(i) - 1))
	+ sum((i,fd)$fd0(i,fd), abs(fd0(i,fd)) * sqr(fd0_(i,fd)/fd0(i,fd) - 1))
	+ sum((va,j)$va0(va,j), abs(va0(va,j)) * sqr(va0_(va,j)/va0(va,j) - 1))
	+ sum((i)$a0(i),    abs(a0(i)) * sqr(a0_(i)/a0(i) - 1))
	+ sum((i)$x0(i),    abs(x0(i)) * sqr(x0_(i)/x0(i) - 1))
	+ sum((i)$m0(i),    abs(m0(i)) * sqr(m0_(i)/m0(i) - 1))
	+ sum((m,i)$md0(m,i),  abs(md0(m,i)) * sqr(md0_(m,i)/md0(m,i) - 1))

	+ 1e7 * (
	+ sum((j,i)$(NOT ys0(j,i)), ys0_(j,i))
	+ sum((i)$(NOT fs0(i)), fs0_(i))
	+ sum((i,m)$(NOT ms0(i,m)), ms0_(i,m))
	+ sum((i)$(NOT y0(i)), y0_(i))
	+ sum((i,j)$(NOT id0(i,j)), id0_(i,j))
	+ sum((i,fd)$(NOT fd0(i,fd)), fd0_(i,fd))
	+ sum((va,j)$(NOT va0(va,j)), va0_(va,j))
	+ sum((i)$(NOT a0(i)), a0_(i))
	+ sum((i)$(NOT x0(i)), x0_(i))
	+ sum((i)$(NOT m0(i)), m0_(i))
	+ sum((m,i)$(NOT md0(m,i)), md0_(m,i)));

* -------------------------------------------------------------------
* 	Huber objective function (with additional constraints):
* -------------------------------------------------------------------

$MACRO MV(mat,i,j) (ys0_(i,j)$SAMEAS(mat,'ys0') + id0_(i,j)$SAMEAS(mat,'id0'))

x2def(nonzero(mat,i,j))..
  X2(mat,i,j)
  + X1(mat,i,j)
  =G=
  (MV(mat,i,j) / v0(mat,i,j) - 1);

x3def(nonzero(mat,i,j))..
  X3(mat,i,j)
  - X2(mat,i,j)
  =G=
  (1 - MV(mat,i,j) / v0(mat,i,j));


huberobj..
  OBJ
  =E=
  sum(nonzero(mat,i,j), abs(v0(mat,i,j)) *
        (sqr(X2(mat,i,j)) + 2*thetab*X1(mat,i,j) -
    2*gammab*(1-gammab)*log(1-gammab-X3(mat,i,j)))) +
    sum((i)$fs0(i),    abs(fs0(i)) * sqr(fs0_(i)/fs0(i) - 1)) +
    sum((i,m)$ms0(i,m),  abs(ms0(i,m)) * sqr(ms0_(i,m)/ms0(i,m) - 1)) +
    sum((i)$y0(i),    abs(y0(i)) * sqr(y0_(i)/y0(i) - 1)) +
    sum((i,fd)$fd0(i,fd), abs(fd0(i,fd)) * sqr(fd0_(i,fd)/fd0(i,fd) - 1)) +
    sum((va,j)$va0(va,j), abs(va0(va,j)) * sqr(va0_(va,j)/va0(va,j) - 1)) +
    sum((i)$a0(i),    abs(a0(i)) * sqr(a0_(i)/a0(i) - 1)) +
    sum((i)$x0(i),    abs(x0(i)) * sqr(x0_(i)/x0(i) - 1)) +
    sum((i)$m0(i),    abs(m0(i)) * sqr(m0_(i)/m0(i) - 1)) +
    sum((m,i)$md0(m,i),  abs(md0(m,i)) * sqr(md0_(m,i)/md0(m,i) - 1)) +

    1e7 * (
    sum((j,i)$(NOT ys0(j,i)), ys0_(j,i)) +
    sum((i)$(NOT fs0(i)), fs0_(i)) +
    sum((i,m)$(NOT ms0(i,m)), ms0_(i,m)) +
    sum((i)$(NOT y0(i)), y0_(i)) +
    sum((i,j)$(NOT id0(i,j)), id0_(i,j)) +
    sum((i,fd)$(NOT fd0(i,fd)), fd0_(i,fd)) +
    sum((va,j)$(NOT va0(va,j)), va0_(va,j)) +
    sum((i)$(NOT a0(i)), a0_(i)) +
    sum((i)$(NOT x0(i)), x0_(i)) +
    sum((i)$(NOT m0(i)), m0_(i)) +
    sum((m,i)$(NOT md0(m,i)), md0_(m,i)));

* Set accounting constraints for the data:

mkt_py(i)..	sum(j, ys0_(j,i)) +  fs0_(i) =E= sum(m, ms0_(i,m)) + y0_(i);

mkt_pa(i)..	a0_(i) =E= sum(j, id0_(i,j)) + sum(fd,fd0_(i,fd));

mkt_pm(m)..	sum(i,ms0_(i,m)) =E= sum(i, md0_(m,i));

prf_y(j)..	sum(i, ys0_(j,i)) =E= sum(i, id0_(i,j)) + sum(va,va0_(va,j));

prf_a(i)..	a0_(i)*(1-ta0(i)) + x0_(i) =E= y0_(i) + m0_(i)*(1+tm0(i)) + sum(m, md0_(m,i));

model balance_ls / lsobj, mkt_py, mkt_pa, mkt_pm, prf_y, prf_a /;
model balance_huber / huberobj, mkt_py, mkt_pa, mkt_pm, prf_y, prf_a, x2def, x3def /;

* Set negative numbers to zero:

ys_0(yr,j,i) = max(0, ys_0(yr,j,i));
id_0(yr,i,j) = max(0, id_0(yr,i,j));
va_0(yr,va,j) = max(0, va_0(yr,va,j));
a_0(yr,i) = max(0, a_0(yr,i));
x_0(yr,i) = max(0, x_0(yr,i));
y_0(yr,i) = max(0, y_0(yr,i));
m_0(yr,i) = max(0, m_0(yr,i));
duty_0(yr,i)$(not m_0(yr,i)) = 0;
md_0(yr,m,i) = max(0,md_0(yr,m,i));
fd_0(yr,i,'pce') = max(0, fd_0(yr,i,'pce'));
ms_0(yr,i,m) = max(0, ms_0(yr,i,m));

* Write a report on which years solve optimally and create solutions
* parameter:

PARAMETER report "Solve report for yearly IO recalibration";
PARAMETER solution "Solutions to matrix balancing problem";
PARAMETER bench "Reference benchmark parameters";

bench('ys0',yr,j,i) = ys_0(yr,j,i);
bench('fs0',yr,i,' ') = fs_0(yr,i);
bench('ms0',yr,i,m) = ms_0(yr,i,m);
bench('y0',yr,i,' ') = y_0(yr,i);
bench('id0',yr,i,j) = id_0(yr,i,j);
bench('fd0',yr,i,fd) = fd_0(yr,i,fd);
bench('va0',yr,va,j) = va_0(yr,va,j);
bench('a0',yr,i,' ') = a_0(yr,i);
bench('x0',yr,i,' ') = x_0(yr,i);
bench('m0',yr,i,' ') = m_0(yr,i);
bench('md0',yr,m,i) = md_0(yr,m,i);

ALIAS(u,uu,uuu,*);

* -------------------------------------------------------------------
* 	Loop over years and matrix balancing techniques to solve:
* -------------------------------------------------------------------

SET	lp(bal)	"Loop control for balancing frameworks";
lp('ls') = yes;
lp('huber') = yes;

*SET	uo(i) "Used goods and Other sectors";
*uo(')

FILE gendir / "%reldir%%sep%temp%sep%loadpoint%sep%loadptdir.gms" /;
FILE loadptexist / "%reldir%%sep%temp%sep%loadpoint%sep%loadpoint.gms" /;
FILE copysoln / "%reldir%%sep%temp%sep%loadpoint%sep%storeloadpt.gms" /;

loop(bal$lp(bal),

$IFTHENI.kestrel "%neos%" == "yes"
IF(SAMEAS(bal,'ls'),
  PUT opt;
  PUT 'kestrel_solver %kestrel_qcp%' /;
  PUT 'neos_server %neosserver%';
  PUTCLOSE opt;)

IF(SAMEAS(bal,'huber'),
  PUT opt;
  PUT 'kestrel_solver %kestrel_nlp%' /;
  PUT 'neos_server %neosserver%';
  PUTCLOSE opt;)
$ENDIF.kestrel

  loop(yr,

* Set parameter values:

	y0(i) = y_0(yr,i);
	ys0(j,i) = ys_0(yr,j,i);
	fs0(i) = fs_0(yr,i);
	id0(i,j) = id_0(yr,i,j);
	fd0(i,fd) = fd_0(yr,i,fd);
	va0(va,j) = va_0(yr,va,j);
	m0(i) = m_0(yr,i);
	x0(i) = x_0(yr,i);
	ms0(i,m) = ms_0(yr,i,m);
	md0(m,i) = md_0(yr,m,i);
	a0(i) = a_0(yr,i);
	ta0(i) = ta_0(yr,i);
	tm0(i) = tm_0(yr,i);

* Lower bounds on re-calibrated parameters set to 10% of listed value:

	ys0_.LO(j,i) = max(0,0.1 * ys0(j,i));
	ms0_.LO(i,m) = max(0,0.1 * ms0(i,m));
	y0_.LO(i) = max(0,0.1 * y0(i));
	id0_.LO(i,j) = max(0,0.1 * id0(i,j));
	fd0_.LO(i,fd) = max(0,0.1 * fd0(i,fd));
	a0_.LO(i) = max(0,0.1 * a0(i));
	x0_.LO(i) = max(0,0.1 * x0(i));
	m0_.LO(i) = max(0,0.1 * m0(i));
	md0_.LO(m,i) = max(0,0.1 * md0(m,i));
	va0_.LO(va,j) = max(0,0.1 * va0(va,j));

* Upper bounds on re-calibrated parameters set to 5x listed value:

	ys0_.UP(j,i)$ys0(j,i)  = abs(5 * ys0(j,i));
	id0_.UP(i,j)$id0(i,j)  = abs(5 * id0(i,j));
	ms0_.UP(i,m)$ms0(i,m)  = abs(5 * ms0(i,m));
	y0_.UP(i)$y0(i)  = abs(5 * y0(i));
	fd0_.UP(i,fd)$fd0(i,fd)  = abs(5 * fd0(i,fd));
	va0_.UP(va,j)$va0(va,j)  = abs(5 * va0(va,j));
	a0_.UP(i)$a0(i)  = abs(5 * a0(i));
	x0_.UP(i)$x0(i)  = abs(5 * x0(i));
	m0_.UP(i)$m0(i)  = abs(5 * m0(i));
	md0_.UP(m,i)$md0(m,i)  = abs(5 * md0(m,i));

* Restrict output of the use and other sector to be zero:

	ys0_.FX(i,j)$(sameas(i,'use') or sameas(i,'oth')) = 0;
	
* Set zero values:

*	ms0_.FX(i,m)$(not ms0(i,m))  = 0;
*	y0_.FX(i)$(not y0(i))  = 0;
*	fd0_.FX(i,fd)$(not fd0(i,fd))  = 0;
*	va0_.FX(va,j)$(not va0(va,j))  = 0;
*	a0_.FX(i)$(not a0(i))  = 0;
*	x0_.FX(i)$(not x0(i))  = 0;
*	m0_.FX(i)$(not m0(i))  = 0;
*	md0_.FX(m,i)$(not md0(m,i))  = 0;

* Fix certain parameters -- exogenous portions of final demand, value
* added, imports and household supply.

*fd0_.FX(i,fd)$(not SAMEAS(fd,'pce')) = fd0(i,fd);
	fs0_.FX(i) = fs0(i);
	va0_.FX(va,j) = va0(va,j);
	m0_.FX(i) = m0(i);

* Additional parameters for using Huber's objective function:

	IF(SAMEAS(bal,'huber'),
	  v0('ys0',i,j) = ys_0(yr,i,j);
	  v0('id0',i,j) = id_0(yr,i,j);
	  nonzero(mat,i,j) = yes$v0(mat,i,j);
	  zeros(mat,i,j) = yes$(not v0(mat,i,j));
	  X1.FX(zeros) = 0;
	  X2.FX(zeros) = 0;
	  X3.FX(zeros) = 0;
	  X2.UP(nonzero) = thetab;
	  X2.LO(nonzero) = -gammab;
	  X3.UP(nonzero) = 1-gammab-1e-5;
	  X3.LO(nonzero) = 0;
	  X1.L(nonzero) = 0;
	  X2.L(nonzero) = 0;
	  X3.L(nonzero) = 0;);


	IF (SAMEAS(bal,'huber'),
	  balance_huber.holdfixed = 1;
	  balance_huber.savepoint = 1;);

	IF (SAMEAS(bal,'ls'),
	  balance_ls.holdfixed = 1;
	  balance_ls.savepoint = 1;);


* -------------------------------------------------------------------
*** Loadpoint logic to minimize run times
* -------------------------------------------------------------------

PUT gendir;
PUT '$IF NOT DEXIST "%reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '"' ' $CALL mkdir "%reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '"'/;
PUTCLOSE;

$IFTHENI %system.filesys% == MSNT
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%loadptdir.gms o=nul"
$ENDIF

$IFTHENI %system.filesys% == UNIX
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%loadptdir.gms o=/dev/null"
$ENDIF

PUT loadptexist;
PUT '$IF EXIST "%reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '%sep%balance_' bal.tl:0 '_p.gdx"' ' EXECUTE "cp %reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '%sep%balance_' bal.tl:0 '_p.gdx'  ' %reldir%%sep%temp%sep%loadpoint%sep%loadpt.gdx"'
PUTCLOSE;

$IFTHENI %system.filesys% == MSNT
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%loadpoint.gms o=nul"
$ENDIF

$IFTHENI %system.filesys% == UNIX
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%loadpoint.gms o=/dev/null"
$ENDIF
* -------------------------------------------------------------------


* -------------------------------------------------------------------
*** Solve statements
* -------------------------------------------------------------------

EXECUTE_LOADPOINT "%reldir%%sep%temp%sep%loadpoint%sep%loadpt.gdx";


IF(SAMEAS(bal,'huber'), SOLVE balance_huber using NLP minimizing OBJ;);
IF(SAMEAS(bal,'ls'), SOLVE balance_ls using QCP minimizing OBJ;);
* -------------------------------------------------------------------

* -------------------------------------------------------------------
*** Move solution to loadpoint directory
* -------------------------------------------------------------------

$IFTHENI %system.filesys% == MSNT
PUT copysoln;
PUT 'EXECUTE "copy balance_' bal.tl:0 '_p.gdx ' '%reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '%sep%balance_' bal.tl:0 '_p.gdx;"';
PUTCLOSE;
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%storeloadpt.gms o=nul";
$ENDIF

$IFTHENI %system.filesys% == UNIX
PUT copysoln;
PUT 'EXECUTE "cp balance_' bal.tl:0 '_p.gdx ' '%reldir%%sep%temp%sep%loadpoint%sep%' yr.tl:0 '%sep%balance_' bal.tl:0 '_p.gdx;"';
PUTCLOSE;
EXECUTE "gams %reldir%%sep%temp%sep%loadpoint%sep%storeloadpt.gms o=/dev/null";
$ENDIF




* -------------------------------------------------------------------


* -------------------------------------------------------------------
*** File cleanup
* -------------------------------------------------------------------

$IFTHENI %system.filesys% == MSNT
EXECUTE "del %reldir%%sep%temp%sep%loadpoint%sep%loadpoint.gms"
EXECUTE "del %reldir%%sep%temp%sep%loadpoint%sep%storeloadpt.gms"
EXECUTE "del %reldir%%sep%temp%sep%loadpoint%sep%loadptdir.gms"
$ENDIF

$IFTHENI %system.filesys% == UNIX
EXECUTE "rm %reldir%%sep%temp%sep%loadpoint%sep%loadpoint.gms"
EXECUTE "rm %reldir%%sep%temp%sep%loadpoint%sep%storeloadpt.gms"
EXECUTE "rm %reldir%%sep%temp%sep%loadpoint%sep%loadptdir.gms"
$ENDIF
* -------------------------------------------------------------------


 IF(SAMEAS(bal,'huber'), report(yr,'modelstat','huber') = balance_huber.modelstat;);
 IF(SAMEAS(bal,'ls'), report(yr,'modelstat','ls') = balance_ls.modelstat;);

* Save the solution:

	solution(bal,'ys0',yr,j,i) = ys0_.L(j,i);
	solution(bal,'fs0',yr,i,' ') = fs0_.L(i);
	solution(bal,'ms0',yr,i,m) = ms0_.L(i,m);
	solution(bal,'y0',yr,i,' ') = y0_.L(i);
	solution(bal,'id0',yr,i,j) = id0_.L(i,j);
	solution(bal,'fd0',yr,i,fd) = fd0_.L(i,fd);
	solution(bal,'va0',yr,va,j) = va0_.L(va,j);
	solution(bal,'a0',yr,i,' ') = a0_.L(i);
	solution(bal,'x0',yr,i,' ') = x0_.L(i);
	solution(bal,'m0',yr,i,' ') = m0_.L(i);
	solution(bal,'md0',yr,m,i) = md0_.L(m,i);

* Report total pct deviation between methods and from the benchmark.

	report(yr,u,bal)$sum((uu,uuu), bench(u,yr,uu,uuu)) = 100 *
			(sum((uu,uuu)$bench(u,yr,uu,uuu), solution(bal,u,yr,uu,uuu))/sum((uu,uuu), bench(u,yr,uu,uuu)) - 1);

	report(yr,'total',bal)$sum((u,uu,uuu), bench(u,yr,uu,uuu)) = 100 *
		(sum((u,uu,uuu)$bench(u,yr,uu,uuu), solution(bal,u,yr,uu,uuu))/sum((u,uu,uuu), bench(u,yr,uu,uuu)) - 1);

);
);




report(yr,u,'pctdev_method')$sum((uu,uuu),solution('ls',u,yr,uu,uuu)) = 100 *
			(sum((uu,uuu)$solution('ls',u,yr,uu,uuu), solution('huber',u,yr,uu,uuu))/sum((uu,uuu), solution('ls',u,yr,uu,uuu)) - 1);

report(yr,'total','pctdev_method')$sum((u,uu,uuu), solution('ls',u,yr,uu,uuu)) = 100 *
		(sum((u,uu,uuu)$solution('ls',u,yr,uu,uuu), solution('huber',u,yr,uu,uuu))/sum((u,uu,uuu), solution('ls',u,yr,uu,uuu)) - 1);

DISPLAY report;

* Output the report to the loadpoint directory:


EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%comparematbal.gdx' report;


ABORT$(smax(yr, report(yr,' ','huber')) > 2) "Huber matrix balancing routine infeasible for at least one year.";
ABORT$(smax(yr, report(yr,' ','ls')) > 2) "LS matrix balancing routine infeasible for at least one year.";



* Delete loadpoint files in root directory:
$IFTHENI %system.filesys% == MSNT
EXECUTE 'del /f balance_huber_p.gdx balance_ls_p.gdx';
$ENDIF

$IFTHENI %system.filesys% == UNIX
EXECUTE 'rm -f balance_huber_p.gdx balance_ls_p.gdx';
$ENDIF



* Reset benchmark parameters in accordance to selected matrix balancing
* routine:

ys_0(yr,j,i) = solution('%matbal%','ys0',yr,j,i);
fs_0(yr,i) = solution('%matbal%','fs0',yr,i,' ');
ms_0(yr,i,m) = solution('%matbal%','ms0',yr,i,m);
y_0(yr,i) = solution('%matbal%','y0',yr,i,' ');
id_0(yr,i,j) = solution('%matbal%','id0',yr,i,j);
fd_0(yr,i,fd) = solution('%matbal%','fd0',yr,i,fd);
va_0(yr,va,j) = solution('%matbal%','va0',yr,va,j);
a_0(yr,i) = solution('%matbal%','a0',yr,i,' ');
x_0(yr,i) = solution('%matbal%','x0',yr,i,' ');
m_0(yr,i) = solution('%matbal%','m0',yr,i,' ');
md_0(yr,m,i) = solution('%matbal%','md0',yr,m,i);
bopdef_0(yr) = sum(i$a_0(yr,i), m_0(yr,i)-x_0(yr,i));

* Verify new parameters satisfy accounting identities:

PARAMETER profit "Zero profit conditions";
PARAMETER market "Market clearance condition";

s_0(yr,j) = sum(i,ys_0(yr,j,i));
profit(yr,j,'Y')$s_0(yr,j) = sum(i,ys_0(yr,j,i) - id_0(yr,i,j)) - sum(va,va_0(yr,va,j));
profit(yr,i,'A')$a_0(yr,i) = a_0(yr,i)*(1-ta_0(yr,i)) + x_0(yr,i) - y_0(yr,i) - m_0(yr,i)*(1+tm_0(yr,i)) - sum(m, md_0(yr,m,i));
market(yr,i,'PA')$a_0(yr,i) = a_0(yr,i) - sum(fd,fd_0(yr,i,fd)) - sum(j$s_0(yr,j),id_0(yr,i,j));
market(yr,i,'PY')$s_0(yr,i) = sum(j$s_0(yr,j),ys_0(yr,j,i)) + fs_0(yr,i) - y_0(yr,i) - sum(m,ms_0(yr,i,m));

DISPLAY profit,market;

* Abort calibration procedure if micro-consistency check fails:

ABORT$(smax((yr,i), profit(yr,i,'Y'))>1e-7) "Y ZP is out of balance";
ABORT$(smax((yr,i), profit(yr,i,'A'))>1e-7) "A ZP is out of balance";
ABORT$(smax((yr,i), market(yr,i,'PY'))>1e-7) "PY market is out of balance";
ABORT$(smax((yr,i), market(yr,i,'PA'))>1e-7) "PA market is out of balance";

* Identify and report negative values:

PARAMETER n_ys0; n_ys0(yr,j,i) = min(0,ys_0(yr,j,i));
PARAMETER n_id0; n_id0(yr,i,j) = min(0,id_0(yr,i,j));
PARAMETER n_va0; n_va0(yr,va,j) = min(0,va_0(yr,va,j));
PARAMETER n_x0; n_x0(yr,i) = min(0,x_0(yr,i));
PARAMETER n_y0; n_y0(yr,i) = min(0,y_0(yr,i));
PARAMETER n_ms0; n_ms0(yr,i,m) = min(0,ms_0(yr,i,m));
PARAMETER n_m0; n_m0(yr,i) = min(0,m_0(yr,i));
PARAMETER n_md0; n_md0(yr,m,i) = min(0,md_0(yr,m,i));

ABORT$(	card(n_ys0)+card(n_id0)+card(n_va0)+card(n_x0)+
	card(n_y0)+card(n_ms0)+	card(n_m0)+card(n_md0)) "Error: negative entries.";

* ----------------------------------------------------------------------
* 	Verify balancing routine solution with a CGE accounting model:
* ----------------------------------------------------------------------

$INCLUDE %reldir%%sep%nationalmodel.gms
accounting.workspace = 100;
accounting.iterlim = 0;
$INCLUDE %reldir%%sep%temp%sep%accounting.gen

$IFTHENI.kestrel "%neos%" == "yes"
PUT opt;
PUT 'kestrel_solver %kestrel_mcp%' /;
PUT 'neos_server %neosserver%';
PUTCLOSE opt;
$ENDIF.kestrel


SOLVE accounting using mcp;
ABORT$(accounting.objval>1e-4) "Error in benchmark calibration.";

* ----------------------------------------------------------------------
* 	Output calibrated parameters:
* ----------------------------------------------------------------------

* EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%nationaldata.gdx' y_0,ys_0,fs_0,id_0,
*     fd_0,va_0,ts_0,m_0,x_0,mrg_0,trn_0,duty_0,sbd_0,tax_0,ms_0,md_0,s_0,a_0,
*     bopdef_0,ta_0,tm_0,yr,i,va,fd,ts,m;


EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%nationaldata.gdx' y_0,ys_0,fs_0,id_0,
    fd_0,va_0,ts_0,m_0,x_0,mrg_0,trn_0,duty_0,sbd_0,tax_0,ms_0,md_0,s_0,a_0,
    bopdef_0,ta_0,tm_0,m;
