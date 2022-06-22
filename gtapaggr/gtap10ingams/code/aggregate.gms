$title	Driver Program for Building a GTAP Dataset

*	Define the source and target:

$if not set source $set source gtapingams
$if not set target $set target g20
$if not set output $set output %target%
$if not set flags  $set flags 

$set fs %system.dirsep% 


$if not set lstdir $set lstdir listings%fs%

*	What version and years are we running now?

$if not set runv $set runv 81.(04,07),9.(04,07,11),10.(04,07,11,14),10a.(04,07,11,14)

set	yr	Years for which we have data /04,07,11,14/,
	gtapv	GTAP versions /8,81,9,10,10a/,
	gtapv_yr(gtapv,yr)  Versions and associated years /
		   8.(04,07),
		   81.(04,07),
		   9.(04,07,11),
		   10.(04,07,11,14),
		   10a.(04,07,11,14) /,

	runv(gtapv,yr)	GTAP versions and years to be processed now /%runv%/;

parameter	njob		Counter of the number of jobs in progress
		jobs		Counter of total number of jobs submitted thus far,
		nthread		Number of jobs to run in parallel /8/;

file kcmd; put kcmd; kcmd.lw=0;

$if %task%==cdecalib $goto cdecalib

jobs = 0;
njob = 0;
loop(runv(gtapv,yr),
    njob = njob + 1;
    jobs = jobs + 1
    if (njob<nthread and jobs <card(runv),
      put_utility 'shell' /'start "gtapaggr gtap',gtapv.tl,' : %source% => %target%, 20',yr.tl,'" ',
		'gams %system.fp%gtapaggr %flags% --gtapv=',gtapv.tl,' --yr=',yr.tl,
			' --source=%source% --target=%target% o=%lstdir%gtapaggr_%target%_',
				gtapv.tl,'_',yr.tl,'.lst --output=%output%  gdxcompress=1';
    else
      put_utility 'title' /'gtapaggr gtap',gtapv.tl,' : %source% => %target%, 20',yr.tl,' -- %output%';
      put_utility 'shell' /'gams %system.fp%gtapaggr %flags% --gtapv=',gtapv.tl,' --yr=',yr.tl,
			' --source=%source% --target=%target% o=%lstdir%gtapaggr_%target%_',
				gtapv.tl,'_',yr.tl,'.lst --output=%output%  gdxcompress=1';
      njob = 0;);

);

$label cdecalib

njob = 0;
jobs = 0;
loop(runv(gtapv,yr),
    njob = njob + 1;
    jobs = jobs + 1
    if (njob<nthread and jobs<card(runv),
      put_utility 'shell' /'start "cdecalib gtap',gtapv.tl,' : %target%, 20',yr.tl,'" ',
		'gams %system.fp%cdecalib --gtapv=',gtapv.tl,' --yr=',yr.tl,
			' --ds=%output% o=%lstdir%cdecalib_%target%_',
				gtapv.tl,'_',yr.tl,'.lst gdxcompress=1';
    else
      put_utility 'title' /'cdecalib gtap',gtapv.tl,' : %target%, 20',yr.tl,' -- %output%';

      put_utility 'shell' /'gams %system.fp%cdecalib --gtapv=',gtapv.tl,' --yr=',yr.tl,
			' --ds=%output% o=%lstdir%cdecalib_%target%_',
				gtapv.tl,'_',yr.tl,'.lst gdxcompress=1';
      njob = 0;);

);
