$title	Build GTAP in GAMS from GTAP Datasets

*	Indiate a single task.  If no task is specified, then build all 
*	datasets.

*	The tasks include "gdx2gdx", "filter", "aggregate" and "replicate"

$set task gdx2gdx
*. $set start filter

parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;

set
	yr		Base years /2017/,
	reltol		Filter tolance /4/
	target		Aggregations /g20_10,  g20_32,  g20_43 /;

*	Data files exist for 2004 and 2007, but these do not have carbon
*	and energy data.  They could be used if those inputs are dropped
*	from the code.

*	Here is the full set of data files which can be processed:

*.	yr		Base years /2011,2014,2017/,
*.	reltol		Filter tolance /3,4,5/
*.	target		Aggregations /g20_10,  g20_32,  g20_43, 
*.				      wb12_10, wb12_32, wb12_43/;

file kput; kput.lw=0; put kput;

*	Here we indicate the location of the GTAP data files.

*	The code works with the following archive -- note that the
*	file name for a GTAP user may be different.

*	Archive:  GDX_AY1017.zip

*	  Length     Date   Time    Name
*	 --------    ----   ----    ----
*	 52930993  04-27-23 16:30   GDX04.zip
*	 54369371  04-27-23 16:30   GDX07.zip
*	 56027868  04-27-23 16:30   GDX11.zip
*	 56111941  04-27-23 16:30   GDX14.zip
*	 56161607  04-27-23 16:30   GDX17.zip
	
$if not set zipfile $set zipfile C:\Users\mphillipson\Documents\WiNDC\GDX_AY1017.zip
	
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
	put_utility 'shell' / 'mkdir ',yr.tl;
	put_utility 'shell' / 'gams gdx2gdx --yr=',yr.tl,' --zipfile=%zipfile% o=',yr.tl,'\gdx2gdx_',yr.tl,'.lst';

	myerrorlevel = errorlevel;
*	if (errorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);

$if set task $exit

execute 'pause';

$label filter

*	Filter the data running five periods in parallel:

loop(yr,
 loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams filter --yr='yr.tl,' --reltol=',reltol.tl,' o=',yr.tl,'\calibrate_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
*	if (errorlevel>0, abort "Non-zero return code from filter.gms"; );
));

$if set task $exit

execute 'pause';

$label aggregate

*	Aggregate for two target aggregations:

loop((yr,target),
	put_utility 'title' /'aggregate: ',yr.tl,' : ', target.tl;
	put_utility 'shell' / 'gams aggregate --yr=',yr.tl,' --target=',target.tl,' o=',yr.tl,'\aggregate_',target.tl,'.lst';
	myerrorlevel = errorlevel;
*	if (errorlevel>0, abort "Non-zero return code from aggregate.gms"; );
);

$if set task $exit

execute 'pause';

$label replicate

*	Benchmark replication with the global multi-regional model.
*	This is not giving us a precise handshake yet, but this will be sorted out shortly.

loop((yr,target),
	put_utility 'title' /'replicate: ',yr.tl,' : ', target.tl;
	put_utility 'shell' / 'gams replicate --yr=',yr.tl,' --ds=',target.tl,' o=',yr.tl,'\gmr_',target.tl,'.lst';
	myerrorlevel = errorlevel;
*	if (errorlevel>0, abort "Non-zero return code from replicate.gms"; );
);
