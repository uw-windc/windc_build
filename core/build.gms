$title Build routine for the windc core dataset

* to run individual build scripts, set %runscript% environment variable:
* $set runscript usatradeshare


* ------------------------------------------------------------------------------
* Set options:
* ------------------------------------------------------------------------------

* use neos for calibration rather than local solvers? 
$if not set neos $set neos "no"

* create environment variables for gdx and list directory:
$set lstdir  lst/
$set gdxdir  gdx/
$set lpdir   loadpoint/

* dataset to be generated
$set ds	%system.fp%WiNDCdatabase


*------------------------------------------------------------------------------
* Create directories if necessary:
*------------------------------------------------------------------------------

$if not dexist "%gdxdir%"	$CALL mkdir "%gdxdir%"
$if not dexist "%lstdir%"	$CALL mkdir "%lstdir%"
$if not dexist "%lpdir%"	$CALL mkdir "%lpdir%"

$if set runscript $goto %runscript%


*------------------------------------------------------------------------------
* Add descriptive text for sets in windc_base.gdx:
*------------------------------------------------------------------------------

*$label relabel
*$set script relabel
*$if %system.filesys% == MSNT $call 'title Inserting descriptive text in windc_base.gdx'

*$call 'gams %script%.gms o="%lstdir%%script%.lst"'
*$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
*$if set runscript $exit


*------------------------------------------------------------------------------
* Form cge parameters using raw input data:
*------------------------------------------------------------------------------

$label partitionbea
$set script partitionbea
$if %system.filesys% == MSNT $call 'title Partitioning BEA data'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit


*------------------------------------------------------------------------------
* Calibrate national dataset:
*------------------------------------------------------------------------------

$label calibrate
$set script calibrate
$if %system.filesys% == MSNT $call 'title Calibrating the national model.'

$call 'gams calibrate.gms --neos=%neos% o="%lstdir%calibrate_huber.lst" --matbal=huber';
$if errorlevel 1 $abort "ERROR: calibrate.gms generated an error. See %lstdir%calibrate_huber.lst";

$call 'gams calibrate.gms --neos=%neos% o="%lstdir%calibrate_ls.lst" --matbal=ls';
$if errorlevel 1 $abort "ERROR: calibrate.gms generated an error. See %lstdir%calibrate_ls.lst";
$if set runscript $exit

$label nationalmodel
$set script nationalmodel
$if %system.filesys% == MSNT $call 'title Verifying the national model.'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit


*------------------------------------------------------------------------------
* Create state level regional accounts:
*------------------------------------------------------------------------------

* gross state product shares
$label gspshare
$set script gspshare
$if %system.filesys% == MSNT $call 'title Reading GSP shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* household expenditure shares (personal consumer expenditure data)
$label pceshare
$set script pceshare
$if %system.filesys% == MSNT $call 'title Reading PCE shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* government expenditure shares (state government finances)
$label sgfshare
$set script sgfshare
$if %system.filesys% == MSNT $call 'title Reading SGF shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* commodity flow survey data (regional purchase coefficients)
* $label cfsshare
* $set script cfsshare
* $if %system.filesys% == MSNT $call 'title Reading CFS shares'

* $call 'gams %script%.gms o="%lstdir%%script%.lst"'
* $if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
* $if set runscript $exit

* freight analysis framework data (regional purchase coefficients)
$label fafshare
$set script fafshare
$if %system.filesys% == MSNT $call 'title Reading FAF shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* export and import shares (census usa trade online)
$label usatradeshare
$set script usatradeshare
$if %system.filesys% == MSNT $call 'title Reading USA trade shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* state disaggregation routine
$label statedisagg
$set script statedisagg

$if %system.filesys% == MSNT $call 'title Regionalizing national summary accounts'

* name of the output dataset and put it in the calling directory:
$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%.lst" --ds=%ds%';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

* name of the output dataset and put it in the calling directory:
$call 'gams %script%.gms --matbal=huber --ds=%ds%_huber --neos=%neos%  o="%lstdir%%script%_huber.lst"';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit

* verify benchmark consistency in both MGE and MCP models, solve a counter-factual
* and verify consistency at that point as well.
$label replicate
$set script replicate

$if %system.filesys% == MSNT $call 'title Verifying consistency of mgemodel and mcpmodel.'

$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%.lst" --ds=%ds%'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst"

$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%_huber.lst" --ds=%ds%_huber';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";
$if set runscript $exit


* ------------------------------------------------------------------------------
* End
* ------------------------------------------------------------------------------
