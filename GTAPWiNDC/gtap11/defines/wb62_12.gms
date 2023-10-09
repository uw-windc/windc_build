$batinclude "%system.fp%../mappings" wbregions_62
$batinclude "%system.fp%../mappings" wbsectors_12

set ff  /
	lab	Labor
	cap	Capital
	/;

set mapf(*,*) /
	mgr.lab	Officials and Mangers legislators (ISCO-88 Major Groups 1-2), 
	tec.lab	Technicians technicians and associate professionals
	clk.lab	Clerks
	srv.lab	Service and market sales workers
	lab.lab	Agricultural and unskilled workers (Major Groups 6-9)
	lnd.cap Land,    
	cap.cap Capital,    
	res.cap Natural resources /;

abort$(card(mapf)<>card(f))	"Error: card(mapf)<>card(f).";
