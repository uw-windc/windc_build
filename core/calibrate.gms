$title Balance the National Dataset

* hotrun the calibration routine for a single year
* $set run 2017


* -------------------------------------------------------------------
* Set options:
* -------------------------------------------------------------------

* set optimization routine for matrix balancing: least squares (ls) or
* huber (huber). note that the routine computes the solution for both methods
* and reports the percent difference between the two. the set environment
* variable is the of the two methods.
$if not set matbal $set matbal ls

* set years of the dataset
$if not set run $set run 1997*2017

* options for directories
$if not set gengdx $set gengdx "gdx"

* set and create loadpoint directory if not exist, this appears to be the only
* place where system.dirsep is necessary. Below we create a nested directory 
* structure and GAMS isn't doing this correctly on Windows due to passing 
* to the shell.
$set lpdir loadpoint%system.dirsep%
$if not dexist %lpdir% $call mkdir %lpdir%

* option for use of neos optimization surver
$if not set neos $set neos "no"

* create a file for put_utility calls
file kutl; kutl.lw=0; kutl.nd=0; kutl.nw=0;


* -------------------------------------------------------------------
* Define flags for matrix balancing routine:
* -------------------------------------------------------------------

set
    bal			Matrix balancing methods / ls, huber /,
    matbalchk(bal)	Verify that matbal is recognized /%matbal%/,
    seq			Sequence of years /1990*2030/;

parameter
    ls			Flag for the least-squares model,
    huber		Flag for the Huber model;

ls = sameas("%matbal%","ls");
huber = sameas("%matbal%","huber");


* -------------------------------------------------------------------
* Read in the dataset -- sets and parameters:
* -------------------------------------------------------------------

* define and read in sets
set
    yr		Years in WiNDC Database,
    fd		BEA Final demand categories,
    ts		BEA Taxes and subsidies categories,
    r		Regions in WiNDC Database,
    va		BEA Value added categories;

* N.B. r is read but not touched in this program. We need to have it passed
* through to the calibrated national dataset.
$gdxin '../data/core/windc_base.gdx'
$loaddc yr va fd ts r
$gdxin

set
    othfd(fd)	Categories of fd other than PCE
    pce(fd)	PCE category of fd /pce/;

othfd(fd) = yes$(not pce(fd));

set
    i(*)	BEA Goods and sectors categories /
		ppd  	"Paper products manufacturing (322)",
		res  	"Food services and drinking places (722)",
		com  	"Computer systems design and related services (5415)",
		amb  	"Ambulatory health care services (621)",
		fbp  	"Food and beverage and tobacco products manufacturing (311-312)",
		rec  	"Amusements, gambling, and recreation industries (713)",
		con  	"Construction (23)",
		agr  	"Farms (111-112)",
		eec  	"Electrical equipment, appliance, and components manufacturing (335)",
		fnd  	"Federal general government (nondefense) (GFGN)",
		pub  	"Publishing industries, except Internet (includes software) (511)",
		hou  	"Housing (HS)",
		fbt  	"Food and beverage stores (445)",
		ins  	"Insurance carriers and related activities (524)",
		tex  	"Textile mills and textile product mills (313-314)",
		leg  	"Legal services (5411)",
		fen  	"Federal government enterprises (GFE)",
		uti  	"Utilities (22)",
		nmp  	"Nonmetallic mineral products manufacturing (327)",
		brd  	"Broadcasting and telecommunications (515, 517)",
		bnk  	"Federal Reserve banks, credit intermediation, and related services (521-522)",
		ore  	"Other real estate (ORE)",
		edu  	"Educational services (61)",
		ote  	"Other transportation equipment manufacturing (3364-3366, 3369)",
		man  	"Management of companies and enterprises (55)",
		mch  	"Machinery manufacturing (333)",
		dat  	"Data processing, internet publishing, and other information services (518, 519)",
		amd  	"Accommodation (721)",
		oil  	"Oil and gas extraction (211)",
		hos  	"Hospitals (622)",
		rnt  	"Rental and leasing services and lessors of intangible assets (532-533)",
		pla  	"Plastics and rubber products manufacturing (326)",
		fof  	"Forestry, fishing, and related activities (113-115)",
		fin  	"Funds, trusts, and other financial vehicles (525)",
		tsv  	"Miscellaneous professional, scientific, and technical services (5412-5414, 5416-5419)",
		nrs  	"Nursing and residential care facilities (623)",
		sec  	"Securities, commodity contracts, and investments (523)",
		art  	"Performing arts, spectator sports, museums, and related activities (711-712)",
		mov  	"Motion picture and sound recording industries (512)",
		fpd  	"Furniture and related products manufacturing (337)",
		slg  	"State and local general government (GSLG)",
		pri  	"Printing and related support activities (323)",
		grd  	"Transit and ground passenger transportation (485)",
		pip  	"Pipeline transportation (486)",
		sle  	"State and local government enterprises (GSLE)",
		osv  	"Other services, except government (81)",
		trn  	"Rail transportation (482)",
		smn  	"Support activities for mining (213)",
		fmt  	"Fabricated metal products (332)",
		pet  	"Petroleum and coal products manufacturing (324)",
		mvt  	"Motor vehicle and parts dealers (441)",
		cep  	"Computer and electronic products manufacturing (334)",
		wst  	"Waste management and remediation services (562)",
		mot  	"Motor vehicles, bodies and trailers, and parts manufacturing (3361-3363)",
		adm  	"Administrative and support services (561)",
		soc  	"Social assistance (624)",
		alt  	"Apparel and leather and allied products manufacturing (315-316)",
		pmt  	"Primary metals manufacturing (331)",
		trk  	"Truck transportation (484)",
		fdd  	"Federal general government (defense) (GFGD)",
		gmt  	"General merchandise stores (452)",
		wtt  	"Water transportation (483)",
		wpd  	"Wood products manufacturing (321)",
		wht  	"Wholesale trade (42)",
		wrh  	"Warehousing and storage (493)",
		ott  	"Other retail (4A0)",
		che  	"Chemical products manufacturing (325)",
		air  	"Air transportation (481)",
		mmf  	"Miscellaneous manufacturing (339)",
		otr  	"Other transportation and support activities (487-488, 492)",
		min  	"Mining, except oil and gas (212)" /;

* DROP these sectors from the dataset:
*		use  Scrap, used and secondhand goods
*		oth  Noncomparable imports and rest-of-the-world adjustment

set
    m		Margins (trade or transport),
    imrg(i) 	Goods which only generate margins /
    		mvt	"Motor vehicle and parts dealers (441)"
		fbt	"Food and beverage stores (445)"
		gmt	"General merchandise stores (452)" /;

$gdxin 'gdx/national_cgeparm_raw.gdx'
$loaddc m
alias (i,j);

* read in data parameters
parameter
    y_0(yr,i)		Gross output,
    ys_0(yr,j,i)	Sectoral supply,
    ty_0(yr,j)		Output tax rate,
    fs_0(yr,i)		Household supply,
    id_0(yr,i,j)	Intermediate demand,
    fd_0(yr,i,fd)	Final demand,
    va_0(yr,va,j)	Value added,
    ts_0(yr,ts,i)	Taxes and subsidies,
    m_0(yr,i)		Imports,
    x_0(yr,i)		Exports of goods and services,
    mrg_0(yr,i)		Trade margins,
    trn_0(yr,i)		Transportation costs,
    duty_0(yr,i)	Import duties,
    sbd_0(yr,i)		Subsidies on products,
    tax_0(yr,i)		Taxes on products,
    ms_0(yr,i,m)	Margin supply,
    md_0(yr,m,i)	Margin demand,
    s_0(yr,i)		Aggregate supply,
    d_0(yr,i)		Sales in the domestic market,
    a_0(yr,i)		Armington supply,
    bopdef_0(yr)	Balance of payments deficit,
    ta_0(yr,i)		Tax net subsidy rate on intermediate demand,
    tm_0(yr,i)		Import tariff;

* use $load rather than $loaddc so that we can ignore "use" and "oth"
$load y_0=y0 ys_0=ys0 fs_0=fs0 id_0=id0 fd_0=fd0 va_0=va0 m_0=m0
$load x_0=x0 ms_0=ms0 md_0=md0 a_0=a0 ta_0=ta0 tm_0=tm0
$gdxin


* -------------------------------------------------------------------
* Matrix balancing routine (ls, huber):
* -------------------------------------------------------------------

parameter
    y0(i)	Gross output,
    ty0(j)	Output tax rate (OTHTAX),
    ys0(j,i)	Sectoral supply,
    fs0(i)	Household supply,
    id0(i,j)	Intermediate demand,
    fd0(i,fd)	Final demand,
    va0(va,j)	Vaue added,
    ts0(ts,i)	Taxes and subsidies,
    m0(i)	Imports,
    x0(i)	Exports of goods and services,
    mrg0(i)	Trade margins,
    trn0(i)	Transportation costs,
    duty0(i)	Import duties,
    sbd0(i)	Subsidies on products,
    tax0(i)	Taxes on products,
    ms0(i,m)	Margin supply,
    md0(m,i)	Margin demand,
    s0(i)	Aggregate supply,
    d0(i)	Sales in the domestic market,
    a0(i)	Armington supply,
    bopdef	Balance of payments deficit,
    ta0(i)	Tax net subsidy rate on intermediate demand,
    tm0(i)	Import tariff;

* Additional parameters needed if using Huber's matrix balancing routine. Permit
* any two-dimensional matrices in the Huber objective:
alias (ih,jh,*);

set
    mat		   	Select parameters for huber objective
    			/ ys0,id0,fd0,va0/,
    nonzero(mat,ih,jh)	Nonzeros in the reference data,
    zeros(mat,ih,jh)	Zeros in the reference data;

parameters
    v0(mat,ih,jh)	Matrix values,
    gammab		Lower bound cross-over tolerance / 0.5 /,
    thetab		Upper bound cross-over tolerance / 0.25 /,
    lob			Lower bound ratio / 0.01 /,
    upb			Upper bound ratio / 10 /,
    newnzpenalty	Penalty on new nonzeros /1e+3/;

* Variables denoted by "_":
nonnegative
variables
    ys0_(j,i)		Calibrated variable ys0,
    fs0_(i)		Calibrated variable fs0,
    ms0_(i,m)		Calibrated variable ms0,
    y0_(i)		Calibrated variable y0,
    id0_(i,j)		Calibrated variable id0,
    fd0_(i,fd)		Calibrated variable fd0,
    va0_(va,j)		Calibrated variable va0,
    a0_(i)		Calibrated variable a0,
    x0_(i)		Calibrated variable x0,
    m0_(i)		Calibrated variable m0,
    md0_(m,i)		Calibrated variable md0,
    X1(mat,ih,jh)	Percentage deviations,
    X2(mat,ih,jh)	Percentage deviations,
    X3(mat,ih,jh)	Percentage deviations
    NEWNZ		New non-zeros entering the dataset;

variable
    OBJ			Objective function (norm of deviation);

equations
    objdef		Objective function,
    x2def		Huber constraint,
    x3def		Huber constraint,
    newnzdef		Number of new non-zeros introduced data,
    mkt_py		Market clearance for industrial output,
    mkt_pa		Market clearance for commodities,
    mkt_pm		Market clearance for margins,
    prf_y		Zero profit condition for output,
    prf_a		Zero profit condition for commodities;

objdef..		OBJ  =E=

* Least squares objective terms:

	  ( sum((j,i)$ys0(j,i),	abs(ys0(j,i)) * sqr(ys0_(j,i)/ys0(j,i) - 1))
	+   sum((i,j)$id0(i,j),	abs(id0(i,j)) * sqr(id0_(i,j)/id0(i,j) - 1)) 
	+   sum((i,pce(fd))$fd0(i,fd), abs(fd0(i,fd)) * sqr(fd0_(i,fd)/fd0(i,fd) - 1))
	+   sum((va,j)$va0(va,j), abs(va0(va,j)) * sqr(va0_(va,j)/va0(va,j) - 1)))$ls 

* The nonlinear Huber objective is hidden for the LS formulation so we can 
* apply a QCP solver:

$if %matbal%==huber + 	sum(nonzero(mat,ih,jh), abs(v0(mat,ih,jh)) * (sqr(X2(mat,ih,jh)) + 2*thetab*X1(mat,ih,jh) -
$if %matbal%==huber 			2*gammab*(1-gammab)*log(1-gammab-X3(mat,ih,jh)))) 

	+ sum((i,othfd(fd))$fd0(i,fd), abs(fd0(i,fd)) * sqr(fd0_(i,fd)/fd0(i,fd) - 1))
	+ sum((i)$fs0(i),	abs(fs0(i)) * sqr(fs0_(i)/fs0(i) - 1))
	+ sum((i,m)$ms0(i,m),	abs(ms0(i,m)) * sqr(ms0_(i,m)/ms0(i,m) - 1))
	+ sum((i)$y0(i),	abs(y0(i)) * sqr(y0_(i)/y0(i) - 1))
	+ sum((i)$a0(i),	abs(a0(i)) * sqr(a0_(i)/a0(i) - 1))
	+ sum((i)$x0(i),	abs(x0(i)) * sqr(x0_(i)/x0(i) - 1))
	+ sum((i)$m0(i),	abs(m0(i)) * sqr(m0_(i)/m0(i) - 1))
	+ sum((m,i)$md0(m,i),	abs(md0(m,i)) * sqr(md0_(m,i)/md0(m,i) - 1))

	+ newnzpenalty * NEWNZ;

* Huber objective function (with additional constraints):

$MACRO MV(mat,ih,jh) (sum((i(ih),j(jh)),ys0_(i,j)$SAMEAS(mat,'ys0') + id0_(i,j)$SAMEAS(mat,'id0')) + \
		      sum((i(ih),fd(jh)),fd0_(i,fd)$SAMEAS(mat,'fd0')) + \
		      sum((va(ih),j(jh)),va0_(va,j)$SAMEAS(mat,'va0')))

x2def(nonzero(mat,ih,jh))$huber..

	X2(mat,ih,jh) + X1(mat,ih,jh) =G= MV(mat,ih,jh)/v0(mat,ih,jh) - 1;

x3def(nonzero(mat,ih,jh))$huber..

	X3(mat,ih,jh) - X2(mat,ih,jh) =G= 1 - MV(mat,ih,jh)/v0(mat,ih,jh);

*	Sum of new non-zeros in the dataset:

newnzdef..	NEWNZ =e=
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
			sum((m,i)$(NOT md0(m,i)), md0_(m,i));

* Set accounting constraints for the data:

mkt_py(i)..	sum(j, ys0_(j,i)) +  fs0_(i) =E= sum(m, ms0_(i,m)) + y0_(i);

mkt_pa(i)..	a0_(i) =E= sum(j, id0_(i,j)) + sum(fd,fd0_(i,fd));

mkt_pm(m)..	sum(i,ms0_(i,m)) =E= sum(i, md0_(m,i));

prf_y(j)..	(1-ty0(j)) * sum(i, ys0_(j,i)) =E= sum(i, id0_(i,j)) + sum(va,va0_(va,j));

prf_a(i)..	a0_(i)*(1-ta0(i)) + x0_(i) =E= y0_(i) + m0_(i)*(1+tm0(i)) + sum(m, md0_(m,i));

model balance / objdef, newnzdef, x2def, x3def,
		mkt_py, mkt_pa, mkt_pm, prf_y, prf_a /;

* Before solving, report negative values:

parameter
    ys_n	Negative values in ys_0,
    id_n	Negative values in id_0,
    va_n	Negative values in va_0,
    a_n		Negative values in a_0,
    x_n		Negative values in x_0,
    y_n		Negative values in y_0,
    m_n		Negative values in m_0,
    duty_n	Negative values in duty_0,
    md_n	Negative values in md_0,
    fd_n	Negative values in fd_0,
    ms_n	Negative values in ms_0;

ys_n(yr,j,i) = min(0, ys_0(yr,j,i));
id_n(yr,i,j) = min(0, id_0(yr,i,j));
va_n(yr,va,j) = min(0, va_0(yr,va,j));
a_n(yr,i) = min(0, a_0(yr,i));
x_n(yr,i) = min(0, x_0(yr,i));
y_n(yr,i) = min(0, y_0(yr,i));
m_n(yr,i) = min(0, m_0(yr,i));
duty_n(yr,i)$(not m_0(yr,i)) = 0;
md_n(yr,m,i) = min(0,md_0(yr,m,i));
fd_n(yr,i,'pce') = min(0, fd_0(yr,i,'pce'));
ms_n(yr,i,m) = min(0, ms_0(yr,i,m));

if (card(ys_n), option ys_n:3:0:1; display ys_n;);
if (card(id_n), option id_n:3:0:1; display id_n;);
if (card(va_n), option va_n:3:0:1; display va_n;);
if (card(a_n), option a_n:3:0:1;   display a_n;);
if (card(x_n), option x_n:3:0:1;   display x_n;);
if (card(y_n), option y_n:3:0:1;   display y_n;);
if (card(m_n), option m_n:3:0:1;   display m_n;);
if (card(duty_n), option duty_n:3:0:1; display duty_n;);
if (card(md_0), option md_0:3:0:1; display md_0;);
if (card(fd_n), option fd_n:3:0:1; display fd_n;);
if (card(ms_n), option ms_n:3:0:1; display ms_n;);

* Treat negative outputs as inputs:

id_0(yr,i,j) = id_0(yr,i,j) - ys_n(yr,j,i);

* Project negative values to zero:

ys_0(yr,j,i) = max(0, ys_0(yr,j,i));
id_0(yr,i,j) = max(0, id_0(yr,i,j));
a_0(yr,i) = max(0, a_0(yr,i));
x_0(yr,i) = max(0, x_0(yr,i));
y_0(yr,i) = max(0, y_0(yr,i));
duty_0(yr,i)$(not m_0(yr,i)) = 0;
md_0(yr,m,i) = max(0,md_0(yr,m,i));
ms_0(yr,i,m) = max(0, ms_0(yr,i,m));
fd_0(yr,i,'pce') = max(0, fd_0(yr,i,'pce'));

* Compute average shares m and va:

parameter
    m_shr(i)	 Average shares of imports,
    va_shr(j,va) Average shares of GDP;

m_shr(i)     = sum(yr,m_0(yr,i))/sum((yr,i.local),m_0(yr,i));
va_shr(j,va) = sum(yr, va_0(yr,va,j)) / sum((yr,va.local),va_0(yr,va,j));
display m_shr, va_shr;

* Assign average values in place of the negative values:

m_0(yr,i)$m_n(yr,i) = m_shr(i)*sum(i.local,m_0(yr,i));
va_0(yr,va,j)$va_n(yr,va,j) = va_shr(j,va)*sum(va.local,va_0(yr,va,j));
va_n(yr,va,j) = min(0, va_0(yr,va,j));
abort$card(va_n) "Negative value-added values remain.",va_n;

* Write a report on which years solve optimally and create solutions
* parameter:

parameters
    report	Solve report for yearly IO recalibration,
    bench	Reference benchmark parameters,
    nzlog	Report on non-zeros in select matrices,
    nzsum	Sum of nonzero values;

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

* Generate default (empty) loadpoint files:

$echo	*	Creates a dummy loadpoint file.			>%gams.scrdir%p.gms
$call	gams %gams.scrdir%p.gms gdx=%gams.scrdir%p.gdx o=%gams.scrdir%p.lst

file kutl; kutl.lw=0; 


loop(yr,

*	Shell syntax:

*		test <condition> || <cmd>  

*	means "if  <condition> is false then execute <cmd>"

*	This works with Windows and all of the Unix shells.  

*	mkdir and cp are both in the GAMS gbin directory so they work on both
*	windows and various Unix shells.  

	put_utility kutl, 'shell' / 'test -d %lpdir%',yr.tl,' || mkdir %lpdir%',yr.tl,' >nul';
	put_utility kutl, 'shell' / 'test -f %lpdir%',yr.tl,'/%matbal%_p.gdx || ',
				' cp  %gams.scrdir%p.gdx %lpdir%',yr.tl,'/%matbal%_p.gdx >nul';

);

* -------------------------------------------------------------------
* Loop over years and matrix balancing techniques to solve:
* -------------------------------------------------------------------

$echo	numericalemphasis 1	>cplex.opt

$if %matbal%==ls	$echo	kestrel_solver	cplex	>kestrel.opt
$if %matbal%==huber	$echo	kestrel_solver	conopt	>kestrel.opt
$echo	neos_server	neos-server.org:3333		>>kestrel.opt

$onechov >%gams.scrdir%loadyr.gms

* Subroutine to load model parameters and bounds for a single year.  

* Set parameter values:

	y0(i) = y_0(yr,i);
	ys0(j,i) = ys_0(yr,j,i);
	va0(va,j) = va_0(yr,va,j);

* Fix output tax rate corresponding to OTHTAX:

	ty0(j) = 0;
	ty0(j)$va0("othtax",j) = va0("othtax",j)/sum(i,ys0(j,i));
	display ty0, va0, ys0;

* Drop the OTHTAX component from value-added:

	va0("othtax",j) = 0;

	fs0(i) = fs_0(yr,i);
	id0(i,j) = id_0(yr,i,j);
	fd0(i,fd) = fd_0(yr,i,fd);
	m0(i) = m_0(yr,i);
	x0(i) = x_0(yr,i);
	ms0(i,m) = ms_0(yr,i,m);
	md0(m,i) = md_0(yr,m,i);
	a0(i) = a_0(yr,i);
	ta0(i) = ta_0(yr,i);
	tm0(i) = tm_0(yr,i);

* Lower bounds on re-calibrated parameters set to 10% of target value:

 	ys0_.LO(j,i) = max(0,lob * ys0(j,i));
	ms0_.LO(i,m) = max(0,lob * ms0(i,m));
	y0_.LO(i) = max(0,lob * y0(i));
	id0_.LO(i,j) = max(0,lob * id0(i,j));
	fd0_.LO(i,fd) = max(0,lob * fd0(i,fd));
	a0_.LO(i) = max(0,lob * a0(i));
	x0_.LO(i) = max(0,lob * x0(i));
	m0_.LO(i) = max(0,lob * m0(i));
	md0_.LO(m,i) = max(0,lob * md0(m,i));
	va0_.LO(va,j) = max(0,lob * va0(va,j));

* Upper bounds on re-calibrated parameters set to 5x listed value:

	ys0_.UP(j,i)$ys0(j,i)  = abs(upb * ys0(j,i));
	id0_.UP(i,j)$id0(i,j)  = abs(upb * id0(i,j));
	ms0_.UP(i,m)$ms0(i,m)  = abs(upb * ms0(i,m));
	y0_.UP(i)$y0(i)  = abs(upb * y0(i));
	fd0_.UP(i,fd)$fd0(i,fd)  = abs(upb * fd0(i,fd));
	va0_.UP(va,j)$va0(va,j)  = abs(upb * va0(va,j));
	a0_.UP(i)$a0(i)  = abs(upb * a0(i));
	x0_.UP(i)$x0(i)  = abs(upb * x0(i));
	m0_.UP(i)$m0(i)  = abs(upb * m0(i));
	md0_.UP(m,i)$md0(m,i)  = abs(upb * md0(m,i));


* Assume zero values remoain zero values for multi-dimensional parameters:

	ys0_.fx(i,j)$(not ys0(i,j)) = 0;
	id0_.fx(i,j)$(not id0(i,j)) = 0;
	fd0_.fx(i,fd)$(not fd0(i,fd)) = 0;
	md0_.fx(m,i)$(not md0(m,i)) = 0;
	ms0_.fx(i,m)$(not ms0(i,m)) = 0;

* Fix certain parameters -- exogenous portions of final demand, value
* added, imports, exports and household supply.

	fs0_.FX(i) = fs0(i);
	m0_.FX(i) = m0(i);
	x0_.FX(i) = x0(i);

* Fix labor compensation to target NIPA table totals.

        va0_.FX("compen",j) = va0("compen",j);

* Need to permit adjustment of value-added, but retain the sparsity pattern:

	va0_.FX(va,j)$(not va0(va,j)) = 0;

* No margin inputs to goods which only provide margins:

	md0_.fx(m,imrg(i)) = 0;
	y0_.fx(imrg(i)) = 0;
	m0_.fx(imrg(i)) = 0;
	x0_.fx(imrg(i)) = 0;
	a0_.fx(imrg(i)) = 0;
	id0_.fx(imrg(i),j) = 0;
	fd0_.fx(imrg(i),fd) = 0;

* Assign parameters for the Huber method.  These assignments have
* no effect on the least squares formulation:

	v0('ys0',i,j) = ys0(i,j);
	v0('id0',i,j) = id0(i,j)$(not imrg(i));
	v0('fd0',i,pce) = fd0(i,pce)$(not imrg(i));
	v0('va0',va,j) = va0(va,j);

	nonzero(mat,ih,jh) = yes$v0(mat,ih,jh);
	zeros(mat,ih,jh) = yes$(not v0(mat,ih,jh));
	X1.FX(zeros) = 0;
	X2.FX(zeros) = 0;
	X3.FX(zeros) = 0;
	X2.UP(nonzero) = thetab;
	X2.LO(nonzero) = -gammab;
	X3.UP(nonzero) = 1-gammab-1e-5;
	X3.LO(nonzero) = 0;
	X1.L(nonzero) = 0;
	X2.L(nonzero) = 0;
	X3.L(nonzero) = 0;

$offecho

$onechov >%gams.scrdir%unloadyr.gms

* Subroutine to unload the solution for a single year.  

	report(yr,'modelstat') = balance.modelstat;
	report(yr,'solvestat') = balance.solvestat;
	report(yr,'obj') = obj.l;

	report(yr,'newnz') = sum((j,i)$(NOT ys0(j,i)), 1$round(ys0_.L(j,i),6)) +
			sum((i)$(NOT fs0(i)), 1$round(fs0_.L(i),6)) +
			sum((i,m)$(NOT ms0(i,m)), 1$round(ms0_.L(i,m),6)) +
			sum((i)$(NOT y0(i)), 1$round(y0_.L(i),6)) +
			sum((i,j)$(NOT id0(i,j)), 1$round(id0_.L(i,j),6)) +
			sum((i,fd)$(NOT fd0(i,fd)), 1$round(fd0_.L(i,fd),6)) +
			sum((va,j)$(NOT va0(va,j)), 1$round(va0_.L(va,j),6)) +
			sum((i)$(NOT a0(i)), 1$round(a0_.L(i),6)) +
			sum((i)$(NOT x0(i)), 1$round(x0_.L(i),6)) +
			sum((i)$(NOT m0(i)), 1$round(m0_.L(i),6)) +
			sum((m,i)$(NOT md0(m,i)), 1$round(md0_.L(m,i),6));

	report(yr,'lostnz') = sum((j,i)$ys0(j,i), 1$(not ys0_.L(j,i))) +
			sum((i)$fs0(i), 1$(not fs0_.L(i))) +
			sum((i,m)$ms0(i,m), 1$(not ms0_.L(i,m))) +
			sum((i)$y0(i), 1$(not y0_.L(i))) +
			sum((i,j)$id0(i,j), 1$(not id0_.L(i,j))) +
			sum((i,fd)$fd0(i,fd), 1$(not fd0_.L(i,fd))) +
			sum((va,j)$va0(va,j), 1$(not va0_.L(va,j))) +
			sum((i)$a0(i), 1$(not a0_.L(i))) +
			sum((i)$x0(i), 1$(not x0_.L(i))) +
			sum((i)$m0(i), 1$(not m0_.L(i))) +
			sum((m,i)$md0(m,i), 1$(not md0_.L(m,i)));

	report(yr,'.LO') = sum((j,i)$ys0(j,i), 1$(ys0_.L(j,i)=ys0_.LO(j,i))) +
			sum((i)$fs0(i), 1$(not fs0_.L(i)=fs0_.LO(i))) +
			sum((i,m)$ms0(i,m), 1$(ms0_.L(i,m)=ms0_.LO(i,m))) +
			sum((i)$y0(i), 1$(y0_.L(i)=y0_.LO(i))) +
			sum((i,j)$id0(i,j), 1$(id0_.L(i,j)=id0_.LO(i,j))) +
			sum((i,fd)$fd0(i,fd), 1$(fd0_.L(i,fd)=fd0_.LO(i,fd))) +
			sum((va,j)$va0(va,j), 1$(va0_.L(va,j)=va0_.LO(va,j))) +
			sum((i)$a0(i), 1$(a0_.L(i)=a0_.LO(i))) +
			sum((i)$x0(i), 1$(x0_.L(i)=x0_.Lo(i))) +
			sum((i)$m0(i), 1$(m0_.L(i)=m0_.LO(i))) +
			sum((m,i)$md0(m,i), 1$(md0_.L(m,i)=md0_.LO(m,i)));

	report(yr,'.UP') = sum((j,i)$ys0(j,i), 1$(ys0_.L(j,i)=ys0_.UP(j,i))) +
			sum((i)$fs0(i), 1$(not fs0_.L(i)= fs0_.UP(i))) +
			sum((i,m)$ms0(i,m), 1$(ms0_.L(i,m)=ms0_.UP(i,m))) +
			sum((i)$y0(i), 1$(y0_.L(i)=y0_.UP(i))) +
			sum((i,j)$id0(i,j), 1$(id0_.L(i,j)=id0_.UP(i,j))) +
			sum((i,fd)$fd0(i,fd), 1$(fd0_.L(i,fd)=fd0_.UP(i,fd))) +
			sum((va,j)$va0(va,j), 1$(va0_.L(va,j)=va0_.UP(va,j))) +
			sum((i)$a0(i), 1$(a0_.L(i)=a0_.UP(i))) +
			sum((i)$x0(i), 1$(x0_.L(i)=x0_.UP(i))) +
			sum((i)$m0(i), 1$(m0_.L(i)=m0_.UP(i))) +
			sum((m,i)$md0(m,i), 1$(md0_.L(m,i)=md0_.UP(m,i)));


	report(yr,'ys0%') = 100 * sum((j,i)$ys0(j,i), 	abs(ys0(j,i)) * sqr(ys0_.L(j,i)/ys0(j,i) - 1)) /
				  sum((j,i)$ys0(j,i), 	abs(ys0(j,i)));

	report(yr,'id0%') = 100 * sum((i,j)$id0(i,j), 	abs(id0(i,j)) * sqr(id0_.L(i,j)/id0(i,j) - 1))  /
				  sum((i,j)$id0(i,j), 	abs(id0(i,j)));

	report(yr,'fs0%')$sum(i, fs0(i)) = 100 * sum((i)$fs0(i), abs(fs0(i)) * sqr(fs0_.L(i)/fs0(i) - 1))  /
				  sum((i)$fs0(i),	abs(fs0(i)));

	report(yr,'ms0%') = 100 * sum((i,m)$ms0(i,m),	abs(ms0(i,m)) * sqr(ms0_.L(i,m)/ms0(i,m) - 1))  /
				  sum((i,m)$ms0(i,m),	abs(ms0(i,m)));

	report(yr,'md0%') = 100 * sum((m,i)$md0(m,i),	abs(md0(m,i)) * sqr(md0_.L(m,i)/md0(m,i) - 1))  /
				  sum((m,i)$md0(m,i),	abs(md0(m,i)));

	report(yr,'y0%') = 100 *  sum((i)$y0(i),	abs(y0(i)) * sqr(y0_.L(i)/y0(i) - 1))  /
				  sum((i)$y0(i),	abs(y0(i)));

	report(yr,'fd0%') = 100 * sum((i,fd)$fd0(i,fd),	abs(fd0(i,fd)) * sqr(fd0_.L(i,fd)/fd0(i,fd) - 1))  /
				  sum((i,fd)$fd0(i,fd),	abs(fd0(i,fd)));

	report(yr,'va0%') = 100 * sum((va,j)$va0(va,j),	abs(va0(va,j)) * sqr(va0_.L(va,j)/va0(va,j) - 1))  /
				  sum((va,j)$va0(va,j),	abs(va0(va,j)));

	report(yr,'a0%') = 100 *  sum((i)$a0(i),	abs(a0(i)) * sqr(a0_.L(i)/a0(i) - 1))  /
				  sum((i)$a0(i),	abs(a0(i)));

	report(yr,'x0%') = 100 *  sum((i)$x0(i),	abs(x0(i)) * sqr(x0_.L(i)/x0(i) - 1))  /
				  sum((i)$x0(i),	abs(x0(i)));

	report(yr,'m0%') = 100 *  sum((i)$m0(i),	abs(m0(i)) * sqr(m0_.L(i)/m0(i) - 1))  /
				  sum((i)$m0(i),	abs(m0(i)));


	nzlog("ys0",yr,'d0_%')    = 100 * card(ys0)/(card(j)*card(i));
	nzlog("ys0",yr,'d_%')     = 100 * sum((j,i),1$ys0_.L(i,j))/(card(j)*card(i));
	nzlog("ys0",yr,'nzgain%') = 100 * sum((j,i)$(NOT ys0(j,i)), 1$round(ys0_.L(j,i),6))/(card(j)*card(i));
	nzlog("ys0",yr,'nzloss%') = 100 * sum((j,i)$ys0(j,i),  1$(not round(ys0_.L(j,i),6)))/(card(j)*card(i));

	nzlog("id0",yr,'d0_%')    = 100 * card(id0)/(card(j)*card(i));
	nzlog("id0",yr,'d_%')     = 100 * sum((j,i),1$id0_.L(j,i))/(card(j)*card(i));
	nzlog("id0",yr,'nzgain%') = 100 * sum((j,i)$(NOT id0(j,i)), 1$round(id0_.L(j,i),6))/(card(j)*card(i));
	nzlog("id0",yr,'nzloss%') = 100 * sum((j,i)$id0(j,i),  1$(not round(id0_.L(j,i),6)))/(card(j)*card(i));

	nzlog("fd0",yr,'d0_%')    = 100 * card(fd0)/(card(i)*card(fd));
	nzlog("fd0",yr,'d_%')     = 100 * sum((i,fd),1$fd0_.L(i,fd))/(card(i)*card(fd));
	nzlog("fd0",yr,'nzgain%') = 100 * sum((i,fd)$(NOT fd0(i,fd)), 1$round(fd0_.L(i,fd),6))/(card(i)*card(fd));
	nzlog("fd0",yr,'nzloss%') = 100 * sum((i,fd)$fd0(i,fd),  1$(not round(fd0_.L(i,fd),6)))/(card(i)*card(fd));

	nzlog("va0",yr,'d0_%')    = 100 * card(va0)/(card(va)*card(j));
	nzlog("va0",yr,'d_%')     = 100 * sum((va,j),1$va0_.L(va,j))/(card(va)*card(j));
	nzlog("va0",yr,'nzgain%') = 100 * sum((va,j)$(NOT va0(va,j)), 1$round(va0_.L(va,j),6))/(card(va)*card(j));
	nzlog("va0",yr,'nzloss%') = 100 * sum((va,j)$va0(va,j),  1$(not round(va0_.L(va,j),6)))/(card(va)*card(j));

	nzlog("fs0",yr,'d0_%')	  = 100 * card(fs0)/(card(i));
	nzlog("fs0",yr,'d_%')	  = 100 * sum(i,1$fs0_.L(i))/(card(i));
	nzlog("fs0",yr,'nzgain%') = 100 * sum((i)$(NOT fs0(i)), 1$round(fs0_.L(i),6))/card(i);
	nzlog("fs0",yr,'nzloss%') = 100 * sum((i)$fs0(i), 1$(not round(fs0_.L(i),6)))/card(i);

	nzlog("ms0",yr,'d0_%')	  = 100 * card(ms0)/(card(i)*card(m));
	nzlog("ms0",yr,'d_%')	  = 100 * sum((i,m),1$ms0_.L(i,m))/(card(i)*card(m));
	nzlog("ms0",yr,'nzgain%') = 100 * sum((i,m)$(NOT ms0(i,m)), 1$round(ms0_.L(i,m),6))/(card(i)*card(m));
	nzlog("ms0",yr,'nzloss%') = 100 * sum((i,m)$ms0(i,m), 1$(not round(ms0_.L(i,m),6)))/(card(i)*card(m));

	nzlog("md0",yr,'d0_%')	  = 100 * card(md0)/(card(i)*card(m));
	nzlog("md0",yr,'d_%')	  = 100 * sum((m,i),1$md0_.L(m,i))/(card(i)*card(m));
	nzlog("md0",yr,'nzgain%') = 100 * sum((m,i)$(NOT md0(m,i)), 1$round(md0_.L(m,i),6))/(card(i)*card(m));
	nzlog("md0",yr,'nzloss%') = 100 * sum((m,i)$md0(m,i), 1$(not round(md0_.L(m,i),6)))/(card(i)*card(m));

	nzlog("y0",yr,'d0_%')	  = 100 * card(y0)/(card(i));
	nzlog("y0",yr,'d_%')	  = 100 * sum(i,1$y0_.L(i))/(card(i));
	nzlog("y0",yr,'nzgain%') = 100 * sum((i)$(NOT y0(i)), 1$round(y0_.L(i),6))/card(i);
	nzlog("y0",yr,'nzloss%') = 100 * sum((i)$y0(i), 1$(not round(y0_.L(i),6)))/card(i);

	nzlog("a0",yr,'d0_%')	  = 100 * card(a0)/(card(i));
	nzlog("a0",yr,'d_%')	  = 100 * sum(i,1$a0_.L(i))/(card(i));
	nzlog("a0",yr,'nzgain%') = 100 * sum((i)$(NOT a0(i)), 1$round(a0_.L(i),6))/card(i);
	nzlog("a0",yr,'nzloss%') = 100 * sum((i)$a0(i), 1$(not round(a0_.L(i),6)))/card(i);

	nzlog("x0",yr,'d0_%')	  = 100 * card(x0)/(card(i));
	nzlog("x0",yr,'d_%')	  = 100 * sum(i,1$x0_.L(i))/(card(i));
	nzlog("x0",yr,'nzgain%') = 100 * sum((i)$(NOT x0(i)), 1$round(x0_.L(i),6))/card(i);
	nzlog("x0",yr,'nzloss%') = 100 * sum((i)$x0(i), 1$(not round(x0_.L(i),6)))/card(i);

	nzlog("m0",yr,'d0_%')	  = 100 * card(m0)/(card(i));
	nzlog("m0",yr,'d_%')	  = 100 * sum(i,1$m0_.L(i))/(card(i));
	nzlog("m0",yr,'nzgain%') = 100 * sum((i)$(NOT m0(i)), 1$round(m0_.L(i),6))/card(i);
	nzlog("m0",yr,'nzloss%') = 100 * sum((i)$m0(i), 1$(not round(m0_.L(i),6)))/card(i);

	nzsum("ys0",yr) = sum((j,i)$(NOT ys0(j,i)), ys0_.L(j,i));
	nzsum("fs0",yr) = sum((i)$(NOT fs0(i)), fs0_.L(i));
	nzsum("ms0",yr) = sum((i,m)$(NOT ms0(i,m)), ms0_.L(i,m));
	nzsum("y0",yr)  = sum((i)$(NOT y0(i)), y0_.L(i));
	nzsum("id0",yr) = sum((i,j)$(NOT id0(i,j)), id0_.L(i,j));
	nzsum("fd0",yr) = sum((i,fd)$(NOT fd0(i,fd)), fd0_.L(i,fd));
	nzsum("va0",yr) = sum((va,j)$(NOT va0(va,j)), va0_.L(va,j));
	nzsum("a0",yr)  = sum((i)$(NOT a0(i)), a0_.L(i));
	nzsum("x0",yr)  = sum((i)$(NOT x0(i)), x0_.L(i));
	nzsum("m0",yr)  = sum((i)$(NOT m0(i)), m0_.L(i));
	nzsum("md0",yr) = sum((m,i)$(NOT md0(m,i)), md0_.L(m,i));

* Save the solution:

	ys_0(yr,j,i)  = ys0_.L(j,i);
	ty_0(yr,j)    = ty0(j);
	fs_0(yr,i)    = fs0_.L(i);
	ms_0(yr,i,m)  = ms0_.L(i,m);
	y_0(yr,i)     = y0_.L(i);
	id_0(yr,i,j)  = id0_.L(i,j);
	fd_0(yr,i,fd) = fd0_.L(i,fd);
	va_0(yr,va,j) = va0_.L(va,j);
	a_0(yr,i)     = a0_.L(i);
	x_0(yr,i)     = x0_.L(i);
	m_0(yr,i)     = m0_.L(i);
	md_0(yr,m,i)  = md0_.L(m,i);
	bopdef_0(yr)  = sum(i$a_0(yr,i), m_0(yr,i)-x_0(yr,i));

$offecho

option nlp=conopt;

*.option qcp=mosek;
option qcp=cplex;

balance.holdfixed = 1;

parameter
    solveno(yr)	Solve number (for retrieving basis files);

set
    run(yr)	Which years to run /%run%/;

loop(yr$run(yr),

* Load this year's data:

$include %gams.scrdir%loadyr

* Read the starting point:

* This reads data from a loadpoint file, but (MP) can't find where it is initially
* written. That means it overwrites all parameters to be empty.

*put_utility kutl, 'gdxin'/'%lpdir%',yr.tl,'/%matbal%_p.gdx';
*	execute_loadpoint;

	put_utility kutl, 'title'/'Calibrating for ',yr.tl,' with %matbal% objective function.';

* Save the solution in balance_p<n>.gdx where <n> is the solve number.

	balance.savepoint = 2;

* The Huber model is NLP. Least squares is QCP.

	if (huber, 
	  solve balance using NLP minimizing OBJ;
	else
	  solve balance using QCP minimizing OBJ;
	);

* Save the solve number:

	solveno(yr) = balance.number;

$include %gams.scrdir%unloadyr

);
display report, nzlog, nzsum;
abort$(smax(yr, report(yr,' ')) > 2) "Matrix balancing problem is infeasible for at least one year.";

* Move savepoint files to the loadpoint directory:

kutl.nw=0; kutl.nd=0;
loop(yr$solveno(yr),
  put_utility kutl, 'exec'/'mv -f balance_p',solveno(yr),'.gdx  %lpdir%',yr.tl,'/%matbal%_p.gdx';
);


* ----------------------------------------------------------------------
* Verify new parameters satisfy accounting identities:
* ----------------------------------------------------------------------

parameter
    profit 	Zero profit conditions,
    market 	Market clearance condition;

s_0(yr,j) = sum(i,ys_0(yr,j,i));

profit(yr,j,'Y')$(s_0(yr,j) and run(yr)) = round(
    (1-ty_0(yr,j)) * sum(i,ys_0(yr,j,i)) -
    (sum(i,id_0(yr,i,j)) + sum(va,va_0(yr,va,j))), 6);

profit(yr,i,'A')$(a_0(yr,i) and run(yr)) = round(
    a_0(yr,i)*(1-ta_0(yr,i)) + x_0(yr,i) -
    (y_0(yr,i) + m_0(yr,i)*(1+tm_0(yr,i)) + sum(m, md_0(yr,m,i))), 6);

market(yr,i,'PA')$(a_0(yr,i) and run(yr))= round(
    a_0(yr,i) - sum(fd,fd_0(yr,i,fd)) - sum(j$s_0(yr,j),id_0(yr,i,j)), 6);

market(yr,i,'PY')$(s_0(yr,i) and run(yr)) = round(
    sum(j$s_0(yr,j),ys_0(yr,j,i)) + fs_0(yr,i) - y_0(yr,i) - sum(m,ms_0(yr,i,m)), 6);

* Abort calibration procedure if micro-consistency check fails:

abort$card(profit) "Zero profit conditions are not satisfied:", profit;
abort$card(market) "Market clearance conditions are not satisfied:", market;


* ----------------------------------------------------------------------
* Output calibrated parameters:
* ----------------------------------------------------------------------

set
    va_(va)	Value-added accounts excluding othtax;

va_(va) = va(va)$(not sameas(va,"othtax"));

execute_unload 'gdx/nationaldata_%matbal%.gdx'
    yr, i, fd, ts, va_=va, m, r,
    y_0,ys_0,ty_0,fs_0,id_0,fd_0,va_0,ts_0,m_0,x_0,mrg_0,trn_0,duty_0,
    sbd_0,tax_0,ms_0,md_0,s_0,a_0,bopdef_0,ta_0,tm_0;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
