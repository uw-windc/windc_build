$title	Build GTAP in GAMS from GTAP Datasets

*--------------------------------
* Command line options:
*
*	--task
*	Indicate a single task. Options include: "gdx2gdx", "filter", "aggregate" and "replicate"
*	No task indicates build all the datasets.
*
*	--start
*	Begin the computations at a set starting point. Options are the same as above.
*----------------------------------

* set year(s) to compute data (2017, 2014, 2011)
*	Data files exist for 2004 and 2007, but these do not have carbon
*	and energy data.  They could be used if those inputs are dropped
*	from the code.

$if not set year $set year 2017

* Set filter tolerances (3, 4, 5)
$if not set relative_tolerance $set relative_tolerance 4

* Set aggregations (g20_10,  g20_32,  g20_43, wb12_10, wb12_32, wb12_43)
$if not set aggregation $set aggregation "g20_10, g20_32, g20_43"

$if not set gtap_version $include "gtapingams.gms"
$if not set gtap_zip_path $abort "You have not set the location of the GTAP gtap_zip_path in GTAPWiNDC/gtapingams.gms"
$if not set gtap_version $abort "You have not set the gtap_version variable in GTAPWiNDC/gtapingams.gms"

$if not dexist "%system.fp%%gtap_version%" $call rmdir /q /s '%system.fp%%gtap_version%'
$call mkdir "%system.fp%%gtap_version%"


set
	yr		Base years /%year%/,
	reltol		Filter tolance / %relative_tolerance%/
	target		Aggregations / %aggregation% /;


parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;


file kput; kput.lw=0; put kput;

*	Run a single task:

$if set task  $goto %task%

*	Start at a specific task:

$if set start $goto %start%

$label gdx2gdx

$set fs %system.dirsep%

file pututl; put pututl; pututl.pw=32766;pututl.lw=0;


loop(yr,
	put_utility 'title' /'Reading GDX data file (',yr.tl,')';
	put_utility 'exec' / 'mkdir %system.fp%%fs%%gtap_version%%fs%',yr.tl;
	put_utility 'exec' / 'gams %system.fp%gdx2gdx --yr=',yr.tl,' --zipfile=%gtap_zip_path% --gtap_version=%gtap_version% o=%system.fp%%gtap_version%/',yr.tl,'/gdx2gdx_',yr.tl,'.lst';

	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);

$if set task $exit



$label filter

*	Filter the data running five periods in parallel:

loop(yr,
 loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams %system.fp%filter --yr='yr.tl,' --reltol=',reltol.tl,' --gtap_version=%gtap_version% o=%system.fp%%gtap_version%/',yr.tl,'/calibrate_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from filter.gms"; );
));

$if set task $exit



$label aggregate

*	Aggregate for each target dataset:

loop((yr,target),
	put_utility 'title' /'aggregate: ',yr.tl,' : ', target.tl;
	put_utility 'exec' / 'gams %system.fp%aggregate --yr=',yr.tl,' --target=',target.tl,' --gtap_version=%gtap_version% o=%system.fp%%gtap_version%/',yr.tl,'/aggregate_',target.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from aggregate.gms"; );
);

$if set task $exit



$label replicate

*	Benchmark replication with the global multi-regional model.
*	This is not giving us a precise handshake yet, but this will be sorted out shortly.

loop((yr,target),
	put_utility 'title' /'replicate: ',yr.tl,' : ', target.tl;
	put_utility 'exec' / 'gams %system.fp%replicate --yr=',yr.tl,' --ds=',target.tl,' --gtap_version=%gtap_version% o=%system.fp%%gtap_version%/',yr.tl,'/gmr_',target.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from replicate.gms"; );
);
