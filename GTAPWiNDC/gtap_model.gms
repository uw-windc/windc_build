$title	GTAPinGAMS Model in Canonical Form

*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------


$include gtapingams;


*$include gtapingams

$if not set ds $set ds g20_32

*	Run the standard GTAP multiregional model:

$set mgeonly yes

$include %gtapingams%replicate

option i:0:0:1;
display i;

set	agrfoo(i)	Agricultural and food products /
	fbp  "Food and beverage and tobacco products (311FT)",
	pdr  "Paddy rice",
	wht  "Wheat",
	gro  "Cereal grains nec",
	v_f  "Vegetables, fruit, nuts",
	osd  "Oil seeds",
	c_b  "Sugar cane, sugar beet",
	pfb  "Plant-based fibers",
	ocr  "Crops nec",
	ctl  "Bovine cattle, sheep, goats and horses",
	oap  "Animal products nec",
	rmk  "Raw milk"/;

parameter	expend(*,i,r)	Household consumption expenditures;
expend("$",agrfoo(i),r) = vdfm(i,"c",r)*(1+rtfd0(i,"c",r)) + vifm(i,"c",r)*(1+rtfi0(i,"c",r));
expend("%",agrfoo(i),r) = 100 * expend("$",i,r) / sum(i.local,
				(vdfm(i,"c",r)*(1+rtfd0(i,"c",r)) + vifm(i,"c",r)*(1+rtfi0(i,"c",r))));
option expend:1:2:1;
display expend;


$exit


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
