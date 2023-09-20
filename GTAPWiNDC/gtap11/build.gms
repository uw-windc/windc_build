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


$if not set zipfile $abort "You have not set the location of the GTAP zipfile in GTAPWiNDC/gtapingams.gms"
$if not set gtap_version $abort "You have not set the gtap_version variable in GTAPWiNDC/gtapingams.gms"



set
	yr		Base years / %year% /,
	reltol		Filter tolance / %relative_tolerance%/
	target		Aggregations / %aggregation% /;


*---------------------------
* 	Here we indicate the location of the GTAP data files.

*	The code works with the following archive -- note that the
*	file name for a GTAP user may be different.

*	Archive:  gdx11aay333.zip

*	  Length     Date   Time    Name
*	 --------    ----   ----    ----
*	 52929463  08-17-23 07:44   GDX11a04.zip
*	 54370286  08-17-23 07:44   GDX11a07.zip
*	 56107467  08-17-23 07:44   GDX11a11.zip
*	 56029849  08-17-23 07:45   GDX11a14.zip
*	 56162643  08-17-23 07:45   GDX11a17.zip
*	 --------                   -------

*$if not set zipfile $set zipfile %system.fp%../../data/GTAPWiNDC/gtap11/GDX_AY1017.zip
*$if not set zipfile $set zipfile %system.fp%../../data/GTAPWiNDC/gtap11a/GDX11aAY333.zip


parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;


file kput; kput.lw=0; put kput;

*	Run a single task:

$if set task  $goto %task%

*	Start at a specific task:

$if set start $goto %start%

$label gdx2gdx

loop(yr,
	put_utility 'shell' / 'if exist ',yr.tl,'\nul rmdir /q /s ',yr.tl;
);

loop(yr,
	put_utility 'title' /'Reading GDX data file (',yr.tl,')';
	put_utility 'exec' / 'mkdir %system.fp%',yr.tl;
	put_utility 'exec' / 'gams %system.fp%gdx2gdx --yr=',yr.tl,' --zipfile=%zipfile% --gtap_version=%gtap_version% o=%system.fp%',yr.tl,'/gdx2gdx_',yr.tl,'.lst';

	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);

$if set task $exit



$label filter

*	Filter the data running five periods in parallel:

loop(yr,
 loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams %system.fp%filter --yr='yr.tl,' --reltol=',reltol.tl,' o=%system.fp%',yr.tl,'/calibrate_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from filter.gms"; );
));

$if set task $exit



$label aggregate

*	Aggregate for each target dataset:

loop((yr,target),
	put_utility 'title' /'aggregate: ',yr.tl,' : ', target.tl;
	put_utility 'exec' / 'gams %system.fp%aggregate --yr=',yr.tl,' --target=',target.tl,' o=%system.fp%',yr.tl,'/aggregate_',target.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from aggregate.gms"; );
);

$if set task $exit



$label replicate

*	Benchmark replication with the global multi-regional model.
*	This is not giving us a precise handshake yet, but this will be sorted out shortly.

loop((yr,target),
	put_utility 'title' /'replicate: ',yr.tl,' : ', target.tl;
	put_utility 'exec' / 'gams %system.fp%replicate --yr=',yr.tl,' --ds=',target.tl,' o=%system.fp%',yr.tl,'/gmr_',target.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from replicate.gms"; );
);
