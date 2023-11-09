$title	Input-Output Calculation of Factor Content

$set run 2017

* -------------------------------------------------------------------
* Set options:
* -------------------------------------------------------------------

* file separator
*$set sep %system.dirsep%

* matrix balancing method defines which dataset is loaded
$if not set matbal $set matbal ls
$if not set ds $set ds gdx/nationaldata_%matbal%.gdx

* hotrun the model calibration check for a single year
* $set run 2017


* -------------------------------------------------------------------
* Read in the dataset -- sets and parameters:
* -------------------------------------------------------------------

set
    yr		Years in WiNDC Database,
    i		BEA Goods and sectors categories,
    fd		BEA Final demand categories,
    ts		BEA Taxes and subsidies categories,
    va		BEA Value added categories excluding othtax,
    m		Margins (trade or transport);

$gdxin %ds%
$loaddc yr i va fd ts m


set
    run(yr)	Sampled years for benchmark consistency;

$if set run run('%run%') = yes;
$if not set run run(yr) = yes;

alias (i,j);

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

$loaddc y_0 ys_0 ty_0 fs_0 id_0 fd_0 va_0 m_0
$loaddc x_0 ms_0 md_0 a_0 ta_0 tm_0
$gdxin

* Parameters describing a single year:

parameter
    y0(i)	Gross output,
    ys0(j,i)	Sectoral supply,
    ty0(j)	Reference output tax rate,
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
    ta0(i)	Reference tax net subsidy rate on intermediate demand,
    tm0(i)	Reference import tariff,
    ty(j)	Policy output tax rate,
    ta(i)	Policy tax net subsidy rate on intermediate demand,
    tm(i)	Policy import tariff;

sets
    y_(j)	Sectors with positive production,
    a_(i)	Sectors with absorption,
    py_(i)	Goods with positive supply,
    xfd(fd) 	Exogenous components of final demand;


* ----------------------------------------------------------------------
* MGE accounting model
* ----------------------------------------------------------------------

$ontext
$model:accounting

$sectors:
	Y(j)$y_(j)	!	Sectoral production
	A(i)$a_(i)	!	Armington supply
	MS(m)		!	Margin supply

$commodities:
	PA(i)$a0(i)	!	Armington price
	PY(i)$py_(i)	!	Supply
	PVA(va)		!	Value-added
	PM(m)		!	Margin
	PFX		!	Foreign exchnage

$consumer:
	RA		!	Representative agent

$prod:Y(j)$y_(j)  s:0 va:1
	o:PY(i)		q:ys0(j,i)	a:RA  t:ty(j)
	i:PA(i)		q:id0(i,j)
	i:PVA(va)	q:va0(va,j)	va:

$prod:MS(m)
	o:PM(m)		q:(sum(i,ms0(i,m)))
	i:PY(i)		q:ms0(i,m)

$prod:A(i)$a_(i)  s:0  t:2 dm:2
	o:PA(i)		q:a0(i)			a:ra	t:ta(i)	p:(1-ta0(i))
	o:PFX		q:x0(i)
	i:PY(i)		q:y0(i)		dm:
	i:PFX		q:m0(i)		dm: 	a:ra	t:tm(i)	p:(1+tm0(i))
	i:PM(m)		q:md0(m,i)

$demand:RA  s:1
	d:PA(i)		q:fd0(i,"pce")
	e:PY(i)		q:fs0(i)
	e:PFX		q:bopdef
	e:PA(i)		q:(-sum(xfd,fd0(i,xfd)))
	e:PVA(va)	q:(sum(j,va0(va,j)))

$report:
	v:C(i)		d:PA(i)		demand:RA

$offtext
$SYSINCLUDE mpsgeset accounting -mt=1


* ----------------------------------------------------------------------
* MCP accounting model
* ----------------------------------------------------------------------

nonnegative
variables
	Y(j)		Sectoral production
	A(i)		Armington supply
	MS(m)		Margin supply

	PA(i)		Armington price
	PY(i)		Supply
	PVA(va)		Value-added
	PM(m)		Margin
	PFX		Foreign exchnage

	RA		Representative agent

equations
	prf_Y(j)	Zero profit for sectoral production
	prf_A(i)	Zero profit for Armington supply
	prf_MS(m)	Zero profit for margin supply

	bal_RA		Income balance for representative agent

	mkt_PA(i)	Market clearance for Armington price
	mkt_PY(i)	Market clearance for supply price
	mkt_PVA(va)	Market clearance for value-added
	mkt_PM(m)	Market clearance for margin
	mkt_PFX		Market clearance for foreign exchnage;

$echo	* Benchmark assignments for accounting_mcp		>%gams.scrdir%accounting_mcp.gen

* $prod:Y(j)$y_(j)  s:0 va:1
* 	o:PY(i)		q:ys0(j,i)  a:RA t:ty0(j)
* 	i:PA(i)		q:id0(i,j)
* 	i:PVA(va)	q:va0(va,j)	va:

parameter
    thetava(va,j)	Value-added shares;
alias (va,va_);

$echo	thetava(va,j) = 0; thetava(va,j)$va0(va,j) = va0(va,j)/sum(va.local,va0(va,j));	>>%gams.scrdir%accounting_mcp.gen
$macro	CVA(j)	(prod(va_, PVA(va_)**thetava(va_,j)))

prf_Y(y_(j))..	CVA(j)*sum(va,va0(va,j)) + sum(i, PA(i)*id0(i,j)) =e= sum(i, PY(i)*ys0(j,i))*(1-ty(j));

* $prod:A(i)$a_(i)  s:0  t:2 dm:2
* 	o:PA(i)		q:a0(i)			a:ra	t:ta(i)	p:(1-ta0(i))
* 	o:PFX		q:x0(i)
* 	i:PY(i)		q:y0(i)		dm:
* 	i:PFX		q:m0(i)		dm: 	a:ra	t:tm(i) 	p:(1+tm0(i))
* 	i:PM(m)		q:md0(m,i)

parameter
    thetam(i)	Import value share,
    thetax(i)	Export value share;

$echo	thetam(i) = 0; thetam(i)$m0(i) = m0(i)*(1+tm0(i))/( m0(i)*(1+tm0(i)) + y0(i) );	>>%gams.scrdir%accounting_mcp.gen
$echo	thetax(i) = 0; thetax(i)$x0(i) = x0(i)/(x0(i)+a0(i)*(1-ta0(i)));		>>%gams.scrdir%accounting_mcp.gen

$macro PMD(i)	((thetam(i)*(PFX*(1+tm(i))/(1+tm0(i)))**(1-2) + (1-thetam(i))*PY(i)**(1-2))**(1/(1-2)))
$macro PXD(i)   ((thetax(i)*PFX**(1+2) + (1-thetax(i))*(PA(i)*(1-ta(i))/(1-ta0(i)))**(1+2))**(1/(1+2)))

$macro MD(i) (A(i)*m0(i)*( (PMD(i)*(1+tm0(i))) / (PFX*(1+tm(i))) )**2)
$macro YD(i) (A(i)*y0(i)*(PMD(i)/PY(i))**2)
$macro XS(i) (A(i)*x0(i)*(PFX/PXD(i))**2)
$macro DS(i) (A(i)*a0(i)*(PA(i)*(1-ta(i))/(PXD(i)*(1-ta0(i))))**2)

prf_A(a_(i))..	sum(m,PM(m)*md0(m,i)) + PMD(i)*(y0(i)+(1+tm0(i))*m0(i)) =g= PXD(i)*(x0(i)+a0(i)*(1-ta0(i)));

* $prod:MS(m)
* 	o:PM(m)		q:(sum(i,ms0(i,m)))
* 	i:PY(i)		q:ms0(i,m)

prf_MS(m)..	sum(i,PY(i)*ms0(i,m)) =e= PM(m)*sum(i,ms0(i,m));

* $demand:RA  s:1
* 	d:PA(i)		q:fd0(i,"pce")
* 	e:PY(i)		q:fs0(i)
* 	e:PFX		q:bopdef
*	e:PA(i)		q:(-sum(xfd,fd0(i,xfd)))
*	e:PVA(va)	q:(sum(j,va0(va,j)))

parameter
    thetac(i)	Benchmark value shares;

$echo	thetac(i) =  fd0(i,"pce")/sum(i.local,fd0(i,"pce"));				>>%gams.scrdir%accounting_mcp.gen

bal_RA..	RA =e= sum(i,PY(i)*fs0(i)) + PFX*bopdef - sum((i,xfd), PA(i)*fd0(i,xfd)) + sum((va,j),PVA(va)*va0(va,j))
			+ sum(i,A(i)* (a0(i)*PA(i)*ta(i) + PFX*MD(i)*tm(i))) + sum(j, Y(j)*sum(i,ys0(j,i)*PY(i))*ty(j));

mkt_PA(a_(i))..	DS(i) =e= thetac(i) * RA/PA(i) + sum(xfd,fd0(i,xfd)) + sum(y_(j),Y(j)*id0(i,j));

mkt_PY(i)..	sum(y_(j),Y(j)*ys0(j,i)) =e= sum(m,MS(m)*ms0(i,m)) + YD(i);

mkt_PVA(va)..	sum(j,va0(va,j)) =e= sum(y_(j), Y(j)*va0(va,j)*CVA(j)/PVA(va));

mkt_PM(m)..	MS(m)*sum(i,ms0(i,m)) =e= sum(i$a0(i), A(i)*md0(m,i));

mkt_PFX..	sum(a_(i), XS(i)) + bopdef =e= sum(a_(i),MD(i));

model accounting_mcp /
	prf_Y.Y, prf_A.A, prf_MS.MS, 
	bal_RA.RA, 
	mkt_PA.PA, mkt_PY.PY, mkt_PVA.PVA, mkt_PM.PM, mkt_PFX.PFX /;


alias (i,ii);
set	k(i)	Target commodity;

variables	vPY(i,i)	Value content of PY wrt VA(k)
		vPM(m,i)	Value content of PM wrt VA(k)
		vPA(i,i)	Value content of PA wrt VA(k)

equations	balY, balMS, balA;

balY(j,k)$y_(j)..	sum(i$py_(i),vPY(i,k)*ys0(j,i)) =e= sum(i$a_(i),vPA(i,k)*id0(i,j)) + sum(va,va0(va,j))$sameas(j,k);

balMS(m,k)..		vPM(m,k)*sum(i,ms0(i,m)) =e= sum(i$py_(i), vPY(i,k)*ms0(i,m));

balA(i,k)$a_(i)..	vPA(i,k)*(a0(i)*(1-ta0(i))+x0(i))   =e= vPY(i,k)*y0(i) + sum(m, vPM(m,k)*md0(m,i));

model content /balY, balMS, balA/;

* ----------------------------------------------------------------------
* Verify reference calibration of the MGE and MCP models
* ----------------------------------------------------------------------

parameter	report		Report of values;

loop(run(yr),
	y0(i) = y_0(yr,i);
	ys0(j,i) = ys_0(yr,j,i);
	ty0(j) = ty_0(yr,j);
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
	ta(i) = ta0(i);
	ty(j) = ty0(j);
	tm(i) = tm0(i);
	bopdef = sum(i, m0(i)-x0(i));

	y_(j) = yes$sum(i,ys0(j,i));
	a_(i) = yes$a0(i);
	py_(i) = yes$sum(j,ys0(j,i));
	xfd(fd) = yes$(not sameas(fd,'pce'));

*	Benchmark replication:

*	1. MGE model

	Y.L(j) = 1;
	A.L(i) = 1;
	MS.L(m) = 1;
	PA.L(i) = 1;
	PY.L(i) = 1;
	PVA.L(va) = 1;
	PM.L(m) = 1;
	PFX.L = 1;
	RA.LO = 0; RA.UP = +INF;
	accounting.iterlim = 0;
*.$include %gams.scrdir%accounting.gen
*.	solve accounting using mcp;
*.	abort$round(accounting.objval,3) "Benchmark replication fails for the MGE model.";


	k(i) = yes$a_(i);
	solve content using mcp;

	report(k,"atm") = vPA.L(k,k);
	report(k,"va/A")$a0(k) = sum(va,va0(va,k))/a0(k);

);

option i:0:0:1;
display i;

display report;


$exit

* ----------------------------------------------------------------------
* End
* ----------------------------------------------------------------------
	loop(ii,
		k(i) = yes$sameas(i,ii);
		solve content using mcp;
	);
