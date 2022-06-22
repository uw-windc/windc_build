$stitle		Define a dataset with four primary factors of production:

*	Count the number of primary factors.  There are five (res,lnd,skl,lab,cap)
*	through version 8.1 and eight (res,lnd,cap + 5 labor types) thereafter.

$eval factors card(f)

set ff  /
	lnd	"Land"
	cap	"Capital"
	res	"Natural resources"
	lab	"Labor" /;

$ifthen.factors %factors%==8

*	GTAP 9 and 10: 8 factors

set mapf(f,ff) /
	mgr.lab	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tec.lab	Technicians technicians and associate professionals
	clk.lab	Clerks
	srv.lab	Service and market sales workers
	lab.lab	Agricultural and unskilled workers (Major Groups 6-9)
	lnd.lnd Land,    
	cap.cap Capital,    
	res.res Natural resources /;

$else.factors

$if not %factors%==5 $abort "Error detected in gtapingams.map.  Expected 5 factors, found %factors%."

*	GTAP 8 and 8.1: 5 factors

set mapf(f,ff) /
	skl.lab	Skilled labor
	lab.lab	Labor
	lnd.lnd Land,    
	cap.cap Capital,    
	res.res Natural resources /;

$endif.factors

abort$(card(mapf)<>card(f))	"Error: card(mapf)<>card(f).";
