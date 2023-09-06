$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$include %system.fp%gtapwindc_data

$gdxin ..\gravity\bilatgravity.gdx

set	col /
		"yd/y"		Local supply share of output
		"ns/y"		National supply share of output
		"xs/y"		Export share of output
		"md/a"		Import share of absorption
		"nd/a"		National market share of absorption
		"yd/a"		Local supply share of absorption /;


parameter	shares(i,s,col)		Trade shares;

$loaddc shares

set	ib(i)	Sectors which have been balanced;
option ib<shares;

xs0(ib(i),"usa",s) = shares(i,s,"xs/y") * vom(i,"usa",s);
ns0(ib(i),"usa",s) = shares(i,s,"ns/y") * vom(i,"usa",s);
vnm(i,r) = sum(s,ns0(i,"usa",s));
yl0(ib(i),"usa",s) = shares(i,s,"yd/y") * vom(i,"usa",s);
nd0(ib(i),"usa",s) = shares(i,s,"nd/a") * a0(i,"usa",s);
md0(ib(i),"usa",s) = shares(i,s,"md/a") * a0(i,"usa",s);

*	This is not working yet.  Not sure why.

$include gtapwindc_mge
