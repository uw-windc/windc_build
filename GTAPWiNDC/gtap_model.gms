$title	GTAPinGAMS Model in Canonical Form

$include gtapingams

$if not set ds $set ds g20_32

*	Run the standard GTAP multiregional model:

$set mgeonly yes

$include %gtapingams%replicate

set	rb(r) /usa/;

set	macct	Macro accounts /
		C	Household consumption,
		G	Public expenditure
		T	Tax revenue
		I	Investment
		L	Labor income
		K	Capital income
		F	Foreign savings
		GDP	"Gross domestic product (C+I+G-B)"
		"GDP*"	"Gross domestic product (K+L+T)"/;
		

alias (r,s);
parameter	incomechk;
incomechk(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f,evom(f,r)) 
	- vb(r) 
	- sum((i,s), rtms(i,s,r)*((1-rtxs(i,s,r))*vxmd(i,s,r)+sum(j,vtwr(j,i,s,r))) - rtxs(i,r,s)*vxmd(i,r,s))
	- sum((i,g), rtfd(i,g,r)*vdfm(i,g,r) + rtfi(i,g,r)*vifm(i,g,r))
	- sum((f,g), rtf(f,g,r)*vfm(f,g,r))
	- sum(g, rto(g,r)*vom(g,r));
display incomechk;

set lf(f) /mgr,tec,clk,srv,lab/, kf(f)/cap,lnd,res/;

parameter	macroaccounts(macct,*)	Macro economic accounts;
loop(rb(r),
	macroaccounts("C","$") = vom("c",r);
	macroaccounts("G","$") = vom("g",r);
	macroaccounts("I","$") = vom("i",r);
	macroaccounts("L","$") = sum(lf(f),evom(lf,r));
	macroaccounts("K","$") = sum(kf(f),evom(kf,r));
	macroaccounts("F","$") = vb(r);
	macroaccounts("T","$") = sum((i,s), rtms(i,s,r)*((1-rtxs(i,s,r))*vxmd(i,s,r)+sum(j,vtwr(j,i,s,r))) - rtxs(i,r,s)*vxmd(i,r,s))
				+ sum((i,g), rtfd(i,g,r)*vdfm(i,g,r) + rtfi(i,g,r)*vifm(i,g,r))
				+ sum((f,g), rtf(f,g,r)*vfm(f,g,r))
				+ sum(g, rto(g,r)*vom(g,r));

	macroaccounts("GDP","$") = macroaccounts("C","$") + macroaccounts("G","$") + macroaccounts("I","$") - macroaccounts("F","$");
	macroaccounts("GDP*","$") = macroaccounts("L","$") + macroaccounts("K","$") + macroaccounts("T","$");
);
macroaccounts("C","%GDP") = 100 * macroaccounts("C","$") / macroaccounts("GDP","$");
macroaccounts("G","%GDP") = 100 * macroaccounts("G","$") / macroaccounts("GDP","$");
macroaccounts("I","%GDP") = 100 * macroaccounts("I","$") / macroaccounts("GDP","$");
macroaccounts("L","%GDP") = 100 * macroaccounts("L","$") / macroaccounts("GDP","$");
macroaccounts("K","%GDP") = 100 * macroaccounts("K","$") / macroaccounts("GDP","$");
macroaccounts("F","%GDP") = 100 * macroaccounts("F","$") / macroaccounts("GDP","$");

option macct:0:0:1;
option macroaccounts:3;
display macroaccounts macct;
