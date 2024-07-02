$title	Filter and Save Trade Data

singleton set	rb(r) /usa/;

parameter	mktchk;
mktchk(itrd(i),rb(r),s,"supply") = round(vom(i,r,s) - (xs_0(i,s) + sum(ss,bvdfm(i,s,ss))),3);
mktchk(itrd(i),rb(r),s,"demand") = round(a0(i,rb,s) - (bvifm(i,s)*(1+rtm0(i,r,s)) +
				sum(ss,bvdfm(i,ss,s)*(1+rtd0(i,r,s)))),3);
option mktchk:3:3:1;
display mktchk;

parameter	penalty /1000/;

nonnegative
variable	BVDFM_(i,s,ss), BVIFM_(i,s);

variable	OBJ;

equation	objdef, supply, demand, imports;

objdef..	OBJ =e= sum((itrd(i),s,ss)$bvdfm(i,s,ss), 
			   bvdfm(i,s,ss)*sqr(BVDFM_(i,s,ss)/bvdfm(i,s,ss)-1)) +
			sum((itrd(i),s)$bvifm(i,s), bvifm(i,s)*sqr(BVIFM_(i,s)/bvifm(i,s)-1)) +
			sum((itrd(i),s,ss)$(not bvdfm(i,s,ss)), penalty * BVDFM_(i,s,ss)) +
			sum((itrd(i),s)$(not bvifm(i,s)), penalty * BVIFM_(i,s));

supply(itrd(i),rb(r),s)..  vom(i,r,s) =e= xs_0(i,s) + sum(ss,BVDFM_(i,s,ss));

demand(itrd(i),rb(r),s).. a0(i,r,s) =e= sum(ss,	BVDFM_(i,ss,s)*(1+rtd0(i,r,s))) + 
						BVIFM_(i,s)    *(1+rtm0(i,r,s));

imports(itrd(i),rb(r))..  vim(i,r) =e= sum(s,BVIFM_(i,s));

model lsqr /objdef, supply, demand/;

option vom:3:0:1; display vom;
option a0:3:0:1; display a0;

BVDFM_.L(i,s,ss) = bvdfm(i,s,ss);
BVIFM_.L(i,s) = bvifm(i,s);

BVDFM_.FX(i,s,ss)$(sameas(s,"rest") or sameas(ss,"rest")) = 0;
BVIFM_.FX(i,"rest") = 0;

option qcp=cplex;
SOLVE lsqr USING QCP minimizing OBJ;

parameter	abstol	Absolute tolerance /1e-5/
		reltol	Relative tolerance /1e-3/;

bvdfm(i,s,ss)$(bvdfm(i,s,ss)<abstol) = 0;
bvifm(i,s)$(bvifm(i,s)<abstol) = 0;
bvdfm(i,s,s)$(not bvdfm(i,s,s)) = 0.5 * vom(i,rb,s);
SOLVE lsqr USING QCP minimizing OBJ;

BVDFM_.FX(i,s,ss)$(bvdfm_.L(i,s,ss)<abstol) = 0;
BVIFM_.FX(i,s)$(bvifm_.l(i,s)<abstol) = 0;
SOLVE lsqr USING QCP minimizing OBJ;

parameter	bd0(i,r,s,ss)	Bilateral trade
		md0(i,r,s)	Imports
		yd0(i,r,s)	Domestic supply and demand;

bd0(itrd(i),rb,s,ss)$(not sameas(s,ss)) = BVDFM_.L(i,s,ss);
yd0(itrd(i),rb,s) = BVDFM_.L(i,s,s);
option bvdfm:3:0:1;
display bvdfm;

md0(itrd(i),rb,s) = BVIFM_.L(i,s);

a0(itrd(i),rb,s) = sum(ss,bd0(i,rb,ss,s)*(1+rtd0(i,rb,s)))
		+ yd0(i,rb,s)*(1+rtd0(i,rb,s))
		+ md0(i,rb,s)*(1+rtm0(i,rb,s));
xs0(itrd(i),rb,s) = xs_0(i,s);
vnm(itrd(i),mkt,rb) = 0;
ns0(itrd(i),mkt,rb,s) = 0;
nd0(itrd(i),mkt,rb,s) = 0;
n_(itrd(i),mkt,rb) = no;
pn_(itrd(i),mkt,rb) = no;

$include gtapwindc.gen
solve gtapwindc using mcp;

