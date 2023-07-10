$title	Build GTAP9inGAMS from GTAP Datasets

*	Indicate a single task.  If no task is specified, then build all 
*	datasets.

*	The tasks include "flex2gdx", "gdx2gdx", "filter", "aggregate" and "replicate"

$set task filter
*.$set start gdx2gdx

parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;

set
	yr		Base years /2011/,
	reltol		Filter tolance /4/
	target		Aggregations /g20_10,  g20_32,  g20_43 /;

*.	yr		Base years /2004,2007,2011/,
*.	reltol		Filter tolance /3,4,5/
*.	target		Aggregations /g20_10,  g20_32,  g20_43, 
*.				      wb12_10, wb12_32, wb12_43/;

file kput; kput.lw=0; put kput;

*	Here we indicate the location of the GTAP data files.

*	Run a single task:

$if set task  $goto %task%

*	Start at a specific task:

$if set start $goto %start%

$label flex2gdx

put_utility 'title' /'Reading FLEXAGG data files';

loop(yr,
	put_utility 'shell' / 'if exist ',yr.tl,'\nul rmdir /q /s ',yr.tl;
	put_utility 'shell' / 'mkdir ',yr.tl;
);

*	Point to the directory with the flexlagg data files:

$set flexagg h:\gtapingams\flexagg\

set		flexaggfile /
		2004	"%flexagg%flexagg9aY04.zip"
		2007	"%flexagg%flexagg9aY07.zip"
		2011	"%flexagg%flexagg9aY11.zip" /;
loop(yr,
	put_utility 'shell' / 'gams flex2gdx --yr=2004 --flexaggfile=',flexaggfile.te(yr),' o=',yr.tl,'\flex2gdx.lst';
	myerrorlevel = errorlevel;
	if (errorlevel>1, abort "Non-zero return code from flex2gdx.gms"; );
);
$if set task $exit

$label gdx2gdx
loop(yr,
	put_utility 'title' /'Reading GDX data file (',yr.tl,')';
	put_utility 'shell' / 'mkdir ',yr.tl;
	put_utility 'shell' / 'gams gdx2gdx --yr=',yr.tl,' o=',yr.tl,'\gdx2gdx.lst';
	myerrorlevel = errorlevel;
	if (errorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);
$if set task $exit

$label filter
loop(yr,
  loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams filter --yr='yr.tl,' --reltol=',reltol.tl,' o=',yr.tl,'\filter_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
	if (errorlevel>0, abort "Non-zero return code from filter.gms"; );
));
$if set task $exit
