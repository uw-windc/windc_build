$TITLE Accounting model to verify benchmark consistency

$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* This routine provides a very simple accounting general equilibrium model to
* verify the consistency of reconciled national accounts.

PARAMETER y0(i) "Gross output";
PARAMETER ys0(j,i) "Sectoral supply";
PARAMETER fs0(i) "Household supply";
PARAMETER id0(i,j) "Intermediate demand";
PARAMETER fd0(i,fd) "Final demand";
PARAMETER va0(va,j) "Vaue added";
PARAMETER m0(i) "Imports";
PARAMETER x0(i) "Exports of goods and service";
PARAMETER ms0(i,m) "Margin supply";
PARAMETER md0(m,i) "Margin demand";
PARAMETER a0(i) "Armington supply";
PARAMETER bopdef "Balance of payments deficit";
PARAMETER ta0(i) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0(i) "Import tariff";

SET y_(j) "Sectors with positive production";
SET py_(i) "Goods with positive supply";
SET xfd(fd) "Exogenous components of final demand";


y0(i) = y_0('%year%',i);
ys0(j,i) = ys_0('%year%',j,i);
fs0(i) = fs_0('%year%',i);
id0(i,j) = id_0('%year%',i,j);
fd0(i,fd) = fd_0('%year%',i,fd);
va0(va,j) = va_0('%year%',va,j);
m0(i) = m_0('%year%',i);
x0(i) = x_0('%year%',i);
ms0(i,m) = ms_0('%year%',i,m);
md0(m,i) = md_0('%year%',m,i);
a0(i) = a_0('%year%',i);
ta0(i) = ta_0('%year%',i);
tm0(i) = tm_0('%year%',i);

y_(j) = yes$(sum(i, ys0(j,i)));
py_(i) = yes$(sum(j, ys0(j,i)));
xfd(fd) = yes$(not sameas(fd,'pce'));

$ontext
$model:accounting

$sectors:
	Y(j)$y_(j)	!	Sectoral production
	A(i)$a0(i)	!	Armington supply
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
	o:PY(i)		q:ys0(j,i)
	i:PA(i)		q:id0(i,j)
	i:PVA(va)	q:va0(va,j)	va:

$prod:MS(m)
	o:PM(m)		q:(sum(i,ms0(i,m)))
	i:PY(i)		q:ms0(i,m)

$prod:A(i)$a0(i)  s:0  t:2 dm:2
	o:PA(i)		q:a0(i)			a:ra	t:ta0(i)	p:(1-ta0(i))
	o:PFX		q:x0(i)
	i:PY(i)		q:y0(i)		dm:
	i:PFX		q:m0(i)		dm: 	a:ra	t:tm0(i) 	p:(1+tm0(i))
	i:PM(m)		q:md0(m,i)

$demand:RA  s:1
	d:PA(i)		q:fd0(i,"pce")
	e:PY(i)		q:fs0(i)
	e:PFX		q:bopdef
	e:PA(i)		q:(-sum(xfd,fd0(i,xfd)))
	e:PVA(va)	q:(sum(j,va0(va,j)))

$offtext
$SYSINCLUDE mpsgeset accounting

*bopdef = sum(i$a0(i), m0(i)-x0(i));
bopdef = sum(i, m0(i)-x0(i));

$IFTHENI %system.filesys% == MSNT
$CALL "copy accounting.gen %reldir%%sep%temp%sep%accounting.gen";
$CALL "del /f accounting.gen";
$ENDIF


$IFTHENI %system.filesys% == UNIX
$CALL "cp accounting.gen %reldir%%sep%temp%sep%accounting.gen";
$CALL "rm -f accounting.gen";
$ENDIF
