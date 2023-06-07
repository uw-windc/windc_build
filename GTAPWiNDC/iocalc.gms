
set	re(r)	Region to evaluate /usa/;	

set	iag(i) / pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk, wol/;

set	is(i,s)	Content to evaluate;

set	samesector(i,s,i,s)	Sector identifier;

alias (s,ss);

parameter	valueadded(i,r,s)	Sectoral value-added;
valueadded(i,re(r),s) = rto(i,r)*vom(i,r,s)+sum(f,vfm(f,i,r,s)*(1+rtf0(f,i,r)));



variable	OBJ		Objective;

variable	v_P(i,j,s)	"Value-added content of Y(j,ss)  in P(i)",
		v_PD(i,s,j,ss)	"Value-added content of Y(j,ss) in PD(i,s)",
		v_PZ(i,s,j,ss)	"Value-added content of Y(j,ss) in PZ(i,s)",
		v_PY(i,s,j,ss)	"Value-added content of Y(j,ss) in PY(i,s)";

equations	objdef, content_Y, content_Z, content_X;

objdef..	OBJ =e= sum((i,s,re(r),is)$xd0(i,r,s), xd0(i,r,s)*sqr(v_PD(i,s,is)-v_P(i,is)));

content_Y(i,re(r),s,is)$y_(i,r,s)..
		vom(i,r,s)*v_PY(i,s,is) =e= sum(j, vafm(j,i,r,s)*v_PZ(j,s,is)) + valueadded(i,r,s)$samesector(i,s,is);

content_Z(i,re(r),s,is)$z_(i,r,s)..
		a0(i,r,s)*v_PZ(i,s,is) =e= xd0(i,r,s)*v_PD(i,s,is) + nd0(i,r,s)*v_P(i,is);

content_X(i,re(r),s,is)$x_(i,r,s)..
		xn0(i,r,s)*v_P(i,is) + xd0(i,r,s)*v_PD(i,S,is) =E= vom(i,r,s)*v_PY(i,s,is);

model content /objdef, content_Y, content_Z, content_X/;

option qcp=cplex;

is(i,s) = no;
loop(iag,
	loop(re,is(iag,s) = yes$valueadded(iag,re,s));
	samesector(i,s,i,s) = yes$is(i,s);
	solve content using qcp minimizing OBJ;
	is(iag,s) = no;
);