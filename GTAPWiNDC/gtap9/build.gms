$title	Build GTAP9inGAMS from GTAP Datasets

*	Indicate a single task.  If no task is specified, then build all 
*	datasets.

*	The tasks include "flex2gdx", "gdx2gdx", "filter", "aggregate" and "replicate"

*$set task filter
*.$set start gdx2gdx

*-------------------------------
*	Change the following to modify which years are run, the relative
*	tolerance and the aggregations.
*
*	Data files exist for 2004 and 2007, but these do not have carbon
*	and energy data.  They could be used if those inputs are dropped
*	from the code.

*	Here is the full set of data files which can be processed:

*.	yr		Base years /2011,2014,2017/,
*.	reltol		Filter tolance /3,4,5/
*.	target		Aggregations /g20_10,  g20_32,  g20_43, 
*.				      wb12_10, wb12_32, wb12_43/;
*---------------------------------

set
	yr		Base years /2011/,
	reltol		Filter tolance /4/
	target		Aggregations /g20_10,  g20_32,  g20_43 /;




parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;

file kput; kput.lw=0; put kput;

*	Here we indicate the location of the GTAP data files.

*	Run a single task:

$if set task  $goto %task%

*	Start at a specific task:

$if set start $goto %start%

$label flex2gdx

put_utility 'title' /'Reading FLEXAGG data files';

loop(yr,
	put_utility 'shell' / 'if exist %system.fp%',yr.tl,'\nul rmdir /q /s %system.fp%',yr.tl;
	put_utility 'shell' / 'mkdir %system.fp%',yr.tl;
);

*	Point to the directory with the flexlagg data files:

$set flexagg %system.fp%../../data/GTAPWiNDC/gtap9/

set		flexaggfile /
		2004	"%flexagg%flexagg9aY04.zip"
		2007	"%flexagg%flexagg9aY07.zip"
		2011	"%flexagg%flexagg9aY11.zip" /;


put_utility 'shell' / "if exist %system.fp%tmp\nul rmdir /q /s %system.fp%tmp";
put_utility 'shell' / "mkdir %system.fp%tmp";

loop(yr,
	put_utility 'shell' / 'gams %system.fp%flex2gdx --yr=',yr.tl,' --flexaggfile=',flexaggfile.te(yr),' o=%system.fp%',yr.tl,'/flex2gdx.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from flex2gdx.gms"; );
);
$if set task $exit

$label gdx2gdx
loop(yr,
	put_utility 'title' /'Reading GDX data file (',yr.tl,')';
*	put_utility 'shell' / 'mkdir %system.fp%',yr.tl;
	put_utility 'shell' / 'gams %system.fp%gdx2gdx --yr=\',yr.tl,' o=%system.fp%',yr.tl,'\gdx2gdx.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);
$if set task $exit

$label filter
loop(yr,
  loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams %system.fp%filter --yr=',yr.tl,' --reltol=',reltol.tl,' o=%system.fp%',yr.tl,'\filter_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
	if (errorlevel>0, abort "Non-zero return code from filter.gms"; );
));
$if set task $exit



$label aggregate

loop((yr,target),

	put_utility "title" / "Aggeragating: ",yr.tl," Target: ",target.tl;
	put_utility "shell" /"gams %system.fp%aggregate --yr=",yr.tl," --target=",target.tl," o=%system.fp%",yr.tl,"\aggregate_",target.tl,".lst";

);


$label replicate
loop((yr,target),

	put_utility "title" / "Replicating: : ",yr.tl,"Target: ",target.tl;
	put_utility "shell" /"gams %system.fp%replicate --yr=",yr.tl," --ds=",target.tl," o=%system.fp%",yr.tl,"\replicate_",target.tl,".lst";

);