*	Simplest possible CGE model:

parameter	t	Tax rate /0.2/; 

$ontext
$model:simple

$sectors:
	Y

$commodities:
	P
	PL
	PK

$consumers:
	RA

$prod:Y  s:1
	o:P	q:100
	i:PL	q:50	a:RA	t:t	p:1.2
	i:PK	q:40

$report:
	v:LD	i:PL	prod:Y

$demand:RA  s:1
	d:P	q:100
	d:PL	q:50
	e:PL	q:100
	e:PK	q:40
$offtext
$sysinclude mpsgeset simple
$include simple.gen
solve simple using mcp;

parameter	dl	Labor demand /50/;

variable	obj;

equations	objdef, profit;

objdef..	obj =e= 40*PK + 100*PL + t*dl*PL - RA.L * log(P**(2/3)*PL**(1/3));

*.profit..	(PL*(1+t)/1.2)**0.6 * PK**0.4 =e= P;

$macro		C	((PL*(1+t)/1.2)**0.6 * PK**0.4)
$macro		aL	(0.5*(C*1.2/((1+t)*PL)))
$macro		aK	(0.4*(C/PK))

profit..	PL*(1+t)*aL + PK*aK =e= P;

option nlp=examiner;
option limrow=1000, limcol=1000, sysout=on;

model sjm /objdef, profit/;

sjm.optfile = yes;

$onecho >examiner.opt
dumpinitPoint    true
examineinitpoint true
returninitPoint  true
$offecho

$ondotl
PK.M = 0;
PL.M = 0;
P.M = 0;
RA.M = 0;
Y.M = 0;
OBJ.L = 40*PK + 100*PL + t*dl*PL - RA.L * log(P**(2/3)*PL**(1/3));

objdef.m = 1;
PROFIT.M = 100;


solve sjm using nlp minimizing OBJ;
 
$exit


t = 0.5;
$include simple.gen
solve simple using mcp;

dl = LD.L;


solve sjm using nlp minimizing OBJ;

$exit

parameter	coeff;

coeff("profit","PL") = (1+t)*aL;
coeff("profit","PK") = aK;
display coeff;

$exit


*	1. U(c,L) -- Cobb-Douglas
*	2.



variables	P,PL,PK,OBJ;

PL.FX = 1;
PK.FX = 1;

parameter	t	Tax rate /0.1/;

equations	objdef, profit;

*	1 + delta = y * (1-t)/0.9

parameter	delta;

*	delta = y*(1-t)/0.9 - 1;

delta = (1-t)/0.9 - 1;

objdef..	OBJ =e= - P * (1+delta);

profit..	sqrt(PL * PK) =e= P * (1-t)/0.9

model	example /objdef, profit/;

solve example using nlp maximizing obj;

t = 0.2;
PL.FX = 1.1;
solve example using nlp maximizing obj;
