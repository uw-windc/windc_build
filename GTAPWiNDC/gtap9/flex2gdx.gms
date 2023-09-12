$title	Translate GTAP Distribution Data into GDX

$if not set yr $set yr 2011

$if %yr%==2004 $set year 04
$if %yr%==2007 $set year 07
$if %yr%==2011 $set year 11

$if not dexist %system.fp%%yr% $call mkdir %system.fp%%yr%
$if not dexist %system.fp%%yr% $call mkdir %system.fp%%yr%

*	Directory in which to find the GTAP zip files:

$if not set flexaggfile $set flexaggfile %system.fp%../../data/GTAPWiNDC/gtap9/flexagg9aY%year%.zip
$if not set flexaggfile $set flexaggfile %system.fp%../../data/GTAPWiNDC/gtap9/flexagg9aY%year%.zip

$if not exist "%flexaggfile%" $abort Cannot find GTAP data file: "%flexaggfile%".

*	Use the GAMS scratch directory to hold temporary files:

$set tmpdir %gams.scrdir%
$set tmpdir %gams.scrdir%

*	Unload the har files:

$set zipfile flexagg9aY%year%/

$call gmsunzip -j "%flexaggfile%" %zipfile%gsdset.har	-d %tmpdir%
$call gmsunzip -j "%flexaggfile%" %zipfile%gsddat.har	-d %tmpdir%
$call gmsunzip -j "%flexaggfile%" %zipfile%gsdpar.har	-d %tmpdir%
$call gmsunzip -j "%flexaggfile%" %zipfile%gsdvole.har	-d %tmpdir%
$call gmsunzip -j "%flexaggfile%" %zipfile%gsdemiss.har	-d %tmpdir%

$call 'har2gdx "%tmpdir%gsdset.har"   "%tmpdir%gsdset.gdx"'
$call 'har2gdx "%tmpdir%gsddat.har"   "%tmpdir%gsddat.gdx"'
$call 'har2gdx "%tmpdir%gsdpar.har"   "%tmpdir%gsdpar.gdx"'
$call 'har2gdx "%tmpdir%gsdvole.har"  "%tmpdir%gsdvole.gdx"'
$call 'har2gdx "%tmpdir%gsdemiss.har" "%tmpdir%gsdemiss.gdx"'

*	Tax rates are computed on the basis of gross and net transactions,
*	so we do not need to read these from the database.  They are 
*	available, however.

*.$call gmsunzip -j "%flexaggfile%" %flexaggfile%gsdtax.har	-d %tmpdir%
*.$call 'har2gdx "%tmpdir%gsdtax.har"   "%tmpdir%gsdtax.gdx"'

$if not exist %tmpdir%gsdset.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsddat.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdpar.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdemiss.gdx	$goto missinggdxfiles

$set gdxdatafile %system.fp%%yr%/flexagg9a.zip
$log  'gmszip -j %gdxdatafile% %tmpdir%*.gdx'
$call 'gmszip -j %gdxdatafile% %tmpdir%*.gdx'

$exit

$label missinggdxfiles
$log	
$log	*** Error *** Missing GDX files.
$log	
$log	Reading from FLEXAGG archive %flexaggfile%.
$log
$log	The following GDX files (translations from HAR) are missing:
$if not exist %tmpdir%gsdset.gdx	$log	%tmpdir%gsdset.gdx
$if not exist %tmpdir%gsddat.gdx	$log	%tmpdir%gsddat.gdx
$if not exist %tmpdir%gsdpar.gdx	$log	%tmpdir%gsdpar.gdx
$if not exist %tmpdir%gsdvole.gdx	$log	%tmpdir%gsdvole.gdx
$if not exist %tmpdir%gsdemiss.gdx	$log	%tmpdir%gsdemiss.gdx


*	*** Error *** Missing GDX files.
*
*	Reading from FLEXAGG archive %flexaggfile%.
*
*	The following GDX files (translations from HAR) are missing:

$if not exist %tmpdir%gsdset.gdx	*	%tmpdir%gsdset.gdx
$if not exist %tmpdir%gsddat.gdx	*	%tmpdir%gsddat.gdx
$if not exist %tmpdir%gsdpar.gdx	*	%tmpdir%gsdpar.gdx
$if not exist %tmpdir%gsdvole.gdx	*	%tmpdir%gsdvole.gdx
$if not exist %tmpdir%gsdemiss.gdx	*	%tmpdir%gsdemiss.gdx

$abort "Error -- see listing file."
