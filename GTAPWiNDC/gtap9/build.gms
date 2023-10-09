$title	Build GTAP9inGAMS from GTAP Datasets

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
$if not set year $set year 2011

* Set filter tolerances (3, 4, 5)
$if not set relative_tolerance $set relative_tolerance 4

* Set aggregations (g20_10,  g20_32,  g20_43, wb12_10, wb12_32, wb12_43)
$if not set aggregation $set aggregation "g20_10, g20_32, g20_43"


$if not dexist "%system.fp%%gtap_version%" $call rmdir /q /s '%system.fp%%gtap_version%'
$call mkdir "%system.fp%%gtap_version%"





set
	yr		Base years / %year% /,
	reltol		Filter tolance / %relative_tolerance%/
	target		Aggregation / %aggregation% /;

$set fs %system.dirsep%

loop(yr,
	put_utility 'exec' / 'mkdir %system.fp%%gtap_version%%fs%',yr.tl;
);

parameter	myerrorlevel	Assigned to error level of the latest executation statement;

set	seq	Sequencing set for filter tolerance /1*10/;

file kput; kput.lw=0; put kput;

*	Run a single task:

$if set task  $goto %task%

*	Start at a specific task:

$if set start $goto %start%

$label flex2gdx

put_utility 'title' /'Reading FLEXAGG data files';



*	Point to the directory with the flexlagg data files:

$set flexagg %system.fp%../../data/GTAPWiNDC/gtap9/

set		flexaggfile /
		2004	"%flexagg%flexagg9aY04.zip"
		2007	"%flexagg%flexagg9aY07.zip"
		2011	"%flexagg%flexagg9aY11.zip" /;


file pututl; put pututl; pututl.pw=32766;pututl.lw=0;

loop(yr,
	put_utility 'shell' / 'gams %system.fp%flex2gdx --yr=',yr.tl,' --flexaggfile=',flexaggfile.te(yr),' o=%system.fp%%gtap_version%/',yr.tl,'/flex2gdx.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from flex2gdx.gms"; );
);
$if set task $exit

$label gdx2gdx
loop(yr,
	put_utility 'title' /'Reading GDX data file (',yr.tl,')';
	put_utility 'shell' / 'gams %system.fp%gdx2gdx --yr=',yr.tl,' o=%system.fp%%gtap_version%/',yr.tl,'/gdx2gdx.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>1, abort "Non-zero return code from gdx2gdx.gms"; );
);
$if set task $exit

$label filter
loop(yr,
  loop(reltol,
	put_utility 'title' /'filter: ',yr.tl,' : ', reltol.tl;
	put_utility 'shell' /'gams %system.fp%filter --yr=',yr.tl,' --reltol=',reltol.tl,' o=%system.fp%gtap9/',yr.tl,'/filter_',reltol.tl,'.lst';
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from filter.gms"; );
));
$if set task $exit



$label aggregate

loop((yr,target),

	put_utility "title" / "Aggeragating: ",yr.tl," Target: ",target.tl;
	put_utility "shell" /"gams %system.fp%aggregate --yr=",yr.tl," --target=",target.tl," o=%system.fp%gtap9/",yr.tl,"/aggregate_",target.tl,".lst";
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from aggregate.gms");
);


$label replicate
loop((yr,target),

	put_utility "title" / "Replicating: : ",yr.tl,"Target: ",target.tl;
	put_utility "shell" /"gams %system.fp%replicate --yr=",yr.tl," --ds=",target.tl," o=%system.fp%gtap9/",yr.tl,"/replicate_",target.tl,".lst";
	myerrorlevel = errorlevel;
	if (myerrorlevel>0, abort "Non-zero return code from replicatge.gms");
);