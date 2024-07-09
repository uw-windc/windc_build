$title	Read Bilateral Trade Data between Provices and States for 2017


*	Imports:

*	https://www150.statcan.gc.ca/n1/pub/71-607-x/2021004/imp-eng.htm?r1=(10,11,12,13,24,35,46,47,48,59,60,61,62)&r2=0&r3=0&r4=0&r5=1&r7=1&r8=2017-01-01&r9=2017-12-01

$call csv2gdx imports.csv id=trade useheader=yes   autorow=r index=(1,3,5) values=(6,7) o=trade.gdx
$call csv2gdx imports.csv id=r_hs6   useheader=yes autorow=r index=(1) text=2 o=hs6.gdx
$call csv2gdx imports.csv id=r_units useheader=yes autorow=r index=(1,8) o=units.gdx

set	r(*)		Rows,
	i(*)		HS6 codes,
	u(*)		Units of measure
	r_hs6(r<,i<)	HS6
	r_units(r,i,u<)	Units of measure;

$gdxin 'hs6.gdx' 
$load r_hs6 

$gdxin 'units.gdx' 
$load r_units

set	hs6(i)		HS6 identifiers,
	ui(i,u)		Units of measure;

option ui<r_units;

ui(i,"Blank") = no;

loop(r_hs6(r,i),
	hs6(i) = r_hs6(r,i);
	ui(ui(i,u)) = r_hs6(r,i);
);

option hs6:0:0:1, ui:0:0:1;
display hs6, ui

sets
	prv(*)		Provinces
	st(*)		State
	col(*)		Column
	units(*)	Units of measure;

parameter	trade(r,i,prv<,st<,col<);
$gdxin 'trade.gdx'
$load trade
set	indices(i,prv,st),rindex(r,i,prv,st);
option indices<trade, rindex<trade;

parameter	nentry(i,prv,st);
nentry(indices) = sum(rindex(r,indices),1) - 1;
nentry(indices)$nentry(indices) = nentry(indices) + 1;
option nentry:0:0:1;
display nentry;
$exit

option prv:0:0:1, st:0:0:1, col:0:0:1;
display prv, st, col;

set	p(*)	Province codes /
	qc	"Quebec",
	nb	"New Brunswick",
	ab	"Alberta",
	bc	"British Columbia",
	sk	"Saskatchewan",
	mb	"Manitoba",
	on	"Ontario",
	ns	"Nova Scotia",
	pe	"Prince Edward Island",
	nl	"Newfoundland and Labrador",
	yk	"Yukon",
	nu	"Nunavut",
	nw	"Northwest Territories" /;

set	s(*)	State codes /
	ny	"New York",
	nj	"New Jersey",
	nh	"New Hampshire",
	wa	"Washington",
	ks	"Kansas",
	ut	"Utah",
	ky	"Kentucky",
	tx	"Texas",
	mi	"Michigan",
	ca	"California",
	in	"Indiana",
	il	"Illinois",
	fl	"Florida",
	ar	"Arkansas",
	wi	"Wisconsin",
	co	"Colorado",
	tn	"Tennessee",
	or	"Oregon",
	ga	"Georgia",
	ma	"Massachusetts",
	me	"Maine",
	pa	"Pennsylvania",
	mn	"Minnesota",
	ct	"Connecticut",
	de	"Delaware",
	oh	"Ohio",
	vt	"Vermont",
	ms	"Mississippi",
	nc	"North Carolina",
	mo	"Missouri",
	sc	"South Carolina",
	al	"Alabama",
	md	"Maryland",
	ok	"Oklahoma",
	wy	"Wyoming",
	nb	"Nebraska",
	nv	"Nevada",
	wv	"West Virginia",
	nd	"North Dakota",
	mt	"Montana",
	ri	"Rhode Island",
	az	"Arizona",
	la	"Louisiana",
	va	"Virginia",
	ia	"Iowa",
	hi	"Hawaii",
	id	"Idaho",
	nm	"New Mexico",
	pr	"Puerto Rico",
	sd	"South Dakota",
	dc	"District of Columbia",
	ak	"Alaska",
	vi	"US Virgin Islands",
	un	"Unknown states" /

set	prvmap(p,prv) /
	qc."Quebec",
	nb."New Brunswick",
	ab."Alberta",
	bc."British Columbia",
	sk."Saskatchewan",
	mb."Manitoba",
	on."Ontario",
	ns."Nova Scotia",
	pe."Prince Edward Island",
	nl."Newfoundland and Labrador",
	yk."Yukon",
	nu."Nunavut",
	nw."Northwest Territories" /;

set	stmap(s,st) /
	ny."New York",
	nj."New Jersey",
	nh."New Hampshire",
	wa."Washington",
	ks."Kansas",
	ut."Utah",
	ky."Kentucky",
	tx."Texas",
	mi."Michigan",
	ca."California",
	in."Indiana",
	il."Illinois",
	fl."Florida",
	ar."Arkansas",
	wi."Wisconsin",
	co."Colorado",
	tn."Tennessee",
	or."Oregon",
	ga."Georgia",
	ma."Massachusetts",
	me."Maine",
	pa."Pennsylvania",
	mn."Minnesota",
	ct."Connecticut",
	de."Delaware",
	oh."Ohio",
	vt."Vermont",
	ms."Mississippi",
	nc."North Carolina",
	mo."Missouri",
	sc."South Carolina",
	al."Alabama",
	md."Maryland",
	ok."Oklahoma",
	wy."Wyoming",
	nb."Nebraska",
	nv."Nevada",
	wv."West Virginia",
	nd."North Dakota",
	mt."Montana",
	ri."Rhode Island",
	az."Arizona",
	la."Louisiana",
	va."Virginia",
	ia."Iowa",
	hi."Hawaii",
	id."Idaho",
	nm."New Mexico",
	pr."Puerto Rico",
	sd."South Dakota",
	dc."District of Columbia",
	ak."Alaska",
	vi."US Virgin Islands",
	un."Unknown states" /


parameter	data(i,p,s,col)	Trade data;
data(i,p,s,col) = sum((prvmap(p,prv),stmap(s,st)), trade(i,prv,st,col));
option data:3:0:1;
display data;
