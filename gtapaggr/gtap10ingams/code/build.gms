$title	Driver Program for Building a GTAP Dataset

*	Action: flex2gdx or filter

$set fs %system.dirsep% 

*	Define the absolute and relative tolerances for 
*	filtering the GTAP dataset:

*	set	reltol	Alternative relative tolerance  /3*6/,
*		abstol	Alternative absolute tolerances /4*9/;


$if not set abstol $set abstol 5
$if not set reltol $set reltol 4
$if not set flexaggdir $set flexaggdir "%fs%gtapingams%fs%flexagg%fs%"

$if not set lstdir $set lstdir listings%fs%

$if not dexist listings $call mkdir listings

*	What version and years are we running now?

*$if not set runv $set runv 81.(04,07),9.(04,07,11),10.(04,07,11,14),10a.(04,07,11,14)
$if not set runv $set runv 10a.(04,07,11)

set	yr	Years for which we have data /04,07,11,14/,
	gtapv	GTAP versions /8,81,9,10,10a/,
	gtapv_yr(gtapv,yr)  Versions and associated years /
		   8.(04,07),
		   81.(04,07),
		   9.(04,07,11),
		   10.(04,07,11,14),
		   10a.(04,07,11,14) /,
	runv(gtapv,yr)	GTAP versions and years to be processed now /%runv%/;

parameter	njob	Counter of the number of jobs in progress
		jobs	Counter of total number of jobs submitted thus far,
		nthread	Number of jobs to run in parallel /8/;

file kcmd; put kcmd; kcmd.lw=0;


$if %task%==filter $goto filter

*	NB: The conversion from HAR to GDX only needs to be done once!

njob = 0;
jobs = 0;
loop(runv(gtapv,yr),
    njob = njob + 1;
    jobs = jobs + 1
    if (njob<nthread and jobs<card(runv),
      put_utility 'shell' /'start "flex2gdx gtap',gtapv.tl,' : 20',yr.tl,'" ',
		'gams "%system.fp%flex2gdx" --flexaggdir=%flexaggdir% --gtapv=',gtapv.tl,' --yr=',yr.tl,' gdxcompress=1 o=%lstdir%flex2gdx_',gtapv.tl,'_',yr.tl,'.lst logfile=%lstdir%flex2gdx_',gtapv.tl,'_',yr.tl,'.log lo=2';

$if not errorfree $abort Problem encountered with flex2gdx

    else
      put_utility 'title' / 'flex2gdx gtap',gtapv.tl,' : 20',yr.tl;
      put_utility 'shell' /
		'gams "%system.fp%flex2gdx" --flexaggdir=%flexaggdir% --gtapv=',gtapv.tl,' --yr=',yr.tl,' gdxcompress=1 o=%lstdir%flex2gdx_',gtapv.tl,'_',yr.tl,'.lst logfile=%lstdir%flex2gdx_',gtapv.tl,'_',yr.tl,'.log lo=2';

$if not errorfree $abort Problem encountered with flex2gdx

      njob = 0;);
);


execute 'pause';

$label filter

*	Run roughly nthread jobs in parallel:

njob = 0;
jobs = 0;
loop(runv(gtapv,yr),
    njob = njob + 1;
    jobs = jobs + 1
    if (njob<nthread and jobs<card(runv),
      put_utility 'shell' /'start "filter gtap',gtapv.tl,' : 20',yr.tl,'" ',
		'gams "%system.fp%filter" --abstol=%abstol% --reltol=%reltol% --yr=',yr.tl,
		' --gtapv=',gtapv.tl,' o=%lstdir%filter_',gtapv.tl,'_',yr.tl,'.lst  gdxcompress=1';

$if not errorfree $abort Problem encountered with filter


    else
      put_utility 'title' /'filter ',gtapv.tl,' : 20',yr.tl;
      put_utility 'shell' / 'gams "%system.fp%filter" --abstol=%abstol% --reltol=%reltol% --yr=',yr.tl,
			' --gtapv=',gtapv.tl,' o=%lstdir%filter_',gtapv.tl,'_',yr.tl,'.lst  gdxcompress=1';

$if not errorfree $abort Problem encountered with filter

      njob = 0;
));


