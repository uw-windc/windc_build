$title	Translate GTAP Distribution Data into GDX

*	File separator:

$set fs %system.dirsep% 

*	GTAP release version and year

$if not set gtapv	$set gtapv 10
$if not set yr		$set yr 14

*	Output data directory:

$if not set datadir	$set datadir "gamsdata%fs%gtap%gtapv%%fs%20%yr%%fs%"

*	Directory in which to find the GTAP zip files:

$if not set gtapdatadir $set gtapdatadir "%fs%gtapingams%fs%gtapdata%fs%"
$if not dexist "%gtapdatadir%" $abort Cannot find GTAP data directory: "%gtapdatadir%".

$if %gtapv%==8		$set zipfile flexagg8aY%yr%
$if %gtapv%==81		$set zipfile flexagg81Y%yr%
$if %gtapv%==9		$set zipfile flexagg9aY%yr%
$if %gtapv%==10		$set zipfile flexagg10Y%yr%

$if not set zipfile $abort  "GTAP version is not recognized: %gtapv%.  Need to set zipfile identification."

$set gtapdatafile %gtapdatadir%%zipfile%.zip
$if not exist "%gtapdatafile%" $abort Cannot find GTAP data file: "%gtapdatafile%".

*	Default is version 10 regions:

$set regions 10

$if %gtapv%==8		$set regions 8
$if %gtapv%==81		$set regions 81
$if %gtapv%==9		$set regions 9

$set	sectors 10
$if %gtapv%==8		$set sectors 8
$if %gtapv%==81		$set sectors 8
$if %gtapv%==9		$set sectors 8

*	Default is version 9 or later:

$if %gtapv%==8	$set factors five
$if %gtapv%==81	$set factors five

*	Use the GAMS scratch directory to hold temporary files:

$set tmpdir %gams.scrdir%

*	Use the following if temporary files are to be retained:

*.$if not dexist tmp $call mkdir tmp
*.$set tmpdir tmp%fs%

$if exist %tmpdir%gsdset.gdx $goto load

*	Unload the har files:

$set zipfile %zipfile%%fs%
$call gmsunzip -j "%gtapdatafile%" %zipfile%gsdset.har	-d %tmpdir%
$call gmsunzip -j "%gtapdatafile%" %zipfile%gsddat.har	-d %tmpdir%
$call gmsunzip -j "%gtapdatafile%" %zipfile%gsdpar.har	-d %tmpdir%
$call gmsunzip -j "%gtapdatafile%" %zipfile%gsdvole.har	-d %tmpdir%
$call gmsunzip -j "%gtapdatafile%" %zipfile%gsdemiss.har -d %tmpdir%

*	Tax rates are computed on the basis of gross and net transactions,
*	so we do not need to read these from the database.  They are 
*	available, however.

*.$call gmsunzip -j "%gtapdatafile%" %zipfile%gsdtax.har	-d %tmpdir%

$call 'har2gdx "%tmpdir%gsdset.har"   "%tmpdir%gsdset.gdx"'
$call 'har2gdx "%tmpdir%gsddat.har"   "%tmpdir%gsddat.gdx"'
$call 'har2gdx "%tmpdir%gsdpar.har"   "%tmpdir%gsdpar.gdx"'
$call 'har2gdx "%tmpdir%gsdvole.har"  "%tmpdir%gsdvole.gdx"'
$call 'har2gdx "%tmpdir%gsdemiss.har" "%tmpdir%gsdemiss.gdx"'

*.$call 'har2gdx "%tmpdir%gsdtax.har"   "%tmpdir%gsdtax.gdx"'

$if not exist %tmpdir%gsdset.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsddat.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdpar.gdx	$goto missinggdxfiles
$if not exist %tmpdir%gsdemiss.gdx	$goto missinggdxfiles

