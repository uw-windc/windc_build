$title	Canonical Template GTAP-WINDC Model (MGE format)

*	Read the data:

$if not set ds $set ds 43

$include %system.fp%gtapwindc_data

$gdxin ../gravity/bilatgravity.gdx

set	col /
		"yd/y"		Local supply share of output
		"ns/y"		National supply share of output
		"xs/y"		Export share of output
		"md/a"		Import share of absorption
		"nd/a"		National market share of absorption
		"yd/a"		Local supply share of absorption /;

parameter	shares(i,s,col)		Trade shares,
		nd_0(i,s)
		a_0(i,s);

$loaddc shares nd_0 a_0
shares(i,s,col) = shares(i,s,col) / 100;

set	ib(i)	Sectors which have been balanced;
option ib<shares;

xs0(ib(i),"usa",s) = shares(i,s,"xs/y") * vom(i,"usa",s);
ns0(ib(i),"usa",s) = shares(i,s,"ns/y") * vom(i,"usa",s);
vnm(i,"usa")       = sum(s,ns0(i,"usa",s));
yl0(ib(i),"usa",s) = shares(i,s,"yd/y") * vom(i,"usa",s);
nd0(ib(i),"usa",s) = shares(i,s,"nd/a") * a0(i,"usa",s);
md0(ib(i),"usa",s) = shares(i,s,"md/a") * a0(i,"usa",s);

parameter	pnmkt;
pnmkt(i,"vnm") = vnm(i,"usa");
pnmkt(i,"nd0") = sum(s,nd0(i,"usa",s));
pnmkt(i,"chk") = pnmkt(i,"vnm") - pnmkt(i,"nd0");
display pnmkt;

parameter nd0_;
nd0_(i,s) = nd0(i,"usa",s);
display nd0_, nd_0;

parameter	a0_;
a0_(i,s) = a0(i,"usa",s);
display a0_, a_0;


$exit



*	This is not working yet.  Not sure why.

$include gtapwindc_mge
