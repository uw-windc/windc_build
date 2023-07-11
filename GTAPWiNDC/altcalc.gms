$title	Canonical Template GTAP-WINDC Model (MGE format)

$set gtapwindc_datafile %system.fp%datasets\gtapwindc\43.gdx

*	Read the data:

$if not set ds $set ds 43

$include gtapwindc_data

singleton set	re(r)			Region to evaluate /usa/;

set	iag(i)  Agricultural sectors/ pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk, wol/;

alias (s,ss);

parameter	valueadded(i,r,s)	Sectoral value-added;

valueadded(i,re(r),s) = rto(i,r)*vom(i,r,s)+sum(f,vfm(f,i,r,s)*(1+rtf0(f,i,r)));


variable	OBJ		Objective;

nonnegative
variables	v_P(i,ss)	"Value-added content of all Y(j,ss) in P(i)",
		v_PD(i,s,ss)	"Value-added content of all Y(j,ss) in PD(i,s)",
		v_PZ(i,s,ss)	"Value-added content of all Y(j,ss) in PZ(i,s)",
		v_PY(i,s,ss)	"Value-added content of all Y(j,ss) in PY(i,s)";

equations	objdef, content_Y, content_Z, content_X;

*	Objective function: among all content definitions which are feasible, find the one which
*	most closely approximates the content in the national market.

objdef..	OBJ =e= sum((i,re(r),s,ss)$xd0(i,r,s), abs(xd0(i,r,s))*sqr(v_PD(i,s,ss)-v_P(i,ss)));

content_Y(i,re(r),s,ss)$y_(i,r,s)..
		vom(i,r,s)*v_PY(i,s,ss) =e= sum(j, vafm(j,i,r,s)*v_PZ(j,s,ss)) + valueadded(i,r,ss)$(iag(i) and sameas(s,ss));

content_Z(i,re(r),s,ss)$z_(i,r,s)..
		a0(i,r,s)*v_PZ(i,s,ss) =e= xd0(i,r,s)*v_PD(i,s,ss) + nd0(i,r,s)*v_P(i,ss);

content_X(i,re(r),s,ss)$x_(i,r,s)..
		xn0(i,r,s)*v_P(i,ss) + xd0(i,r,s)*v_PD(i,s,ss) =E= vom(i,r,s)*v_PY(i,s,ss);

model content /objdef, content_Y, content_Z, content_X/;

option qcp=cplex;


solve content using qcp minimizing OBJ;

$exit

parameter	atm(i,s)	Export content;
atm(i,s) = v_P.L(i,s);
execute_unload 'altatm.gdx',atm;
execute 'gdxxrw i=altatm.gdx o=altatm.xlsx par=atm rng=PivotData!a2 cdim=0';
