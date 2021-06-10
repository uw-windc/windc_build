*		  Build Routine for the WiNDC Core Dataset
*
*	Comment out the following line to run the full build routine!

*.$set runscript calibrate

* Authors: Andrew Schreiber, Thomas Rutherford, Adam Christensen
*
* ------------------------------------------------------------------------------

$SET sep %system.dirsep%

*	Use NEOS for calibration rather than local solvers? 

$if not set neos        $set neos "no"

*	Create environment variables for gdx and list directory:

$set lstdir  lst%sep%
$set gdxdir  gdx%sep%
$set lpdir   loadpoint%sep%

*	Dataset to be generated

$set ds	%system.fp%WiNDCdatabase

*------------------------------------------------------------------------------
*** Create directories if necessary
*------------------------------------------------------------------------------
$if not dexist "%gdxdir%"	$CALL mkdir "%gdxdir%"
$if not dexist "%lstdir%"	$CALL mkdir "%lstdir%"
$if not dexist "%lpdir%"	$CALL mkdir "%lpdir%"

$if set runscript $goto %runscript%
$if set start     $goto %start%

*------------------------------------------------------------------------------
*	Add descriptive text for sets in windc_base.gdx:
*------------------------------------------------------------------------------

$label relabel
$set script relabel
$if %system.filesys% == MSNT $call 'title Inserting descriptive text in windc_base.gdx'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

*------------------------------------------------------------------------------

*------------------------------------------------------------------------------
*** Form CGE parameters using raw input data
*------------------------------------------------------------------------------

$label partitionbea
$set script partitionbea
$if %system.filesys% == MSNT $call 'title Partitioning BEA data'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

*------------------------------------------------------------------------------
*** Calibration
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
*** Regionalization (State Level)
*------------------------------------------------------------------------------

* Regionalization is achieved through shares using GSP, CFS, GovExp, and PCE
* data. The following routines generate a set of consistent shares for use in
* statedisagg.gms. For a link to all regional sources:
* https://www.bea.gov/regional/downloadzip.cfm

* Produce a gams readable GSP dataset using stata. See
* Data\BEA\GDP\State\stategsp.do. Source:
* (https://www.bea.gov/newsreleases/regional/gdp_state/qgsp_newsrelease.htm)

$label gspshare
$set script gspshare
$if %system.filesys% == MSNT $call 'title Reading GSP shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

* Household expenditures follow the Personal Consumption Expenditure Survey
* data. Source: (https://www.bea.gov/newsreleases/regional/pce/pce_newsrelease.htm)

$label pceshare
$set script pceshare
$if %system.filesys% == MSNT $call 'title Reading PCE shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

* Government expenditures are assumed to follow the state government finance tables.
* Source: (https://www.census.gov/programs-surveys/state/data/tables.All.html)

$label sgfshare
$set script sgfshare
$if %system.filesys% == MSNT $call 'title Reading SGF shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

* Regional purchase coefficients which determine flows within and out to other
* states are generated through the 2012 commodity flow survey data. Source:
* (https://www.census.gov/econ/cfs/).

$label cfsshare
$set script cfsshare
$if %system.filesys% == MSNT $call 'title Reading CFS shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

* Shares for exports are generated using Census data from USA Trade Online. The
* data is free, though an account is required to access the data.
* Source: https://usatrade.census.gov/

$label usatradeshare
$set script usatradeshare
$if %system.filesys% == MSNT $call 'title Reading USA trade shares'

$call 'gams %script%.gms o="%lstdir%%script%.lst"'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

*	Disaggregate accounts by region and output a gdx file data for all years. The
*	default year is the latest year (2017) and determines the test year to verify 
*	benchmark consistency.

$label statedisagg
$set script statedisagg

$if %system.filesys% == MSNT $call 'title Regionalizing national summary accounts'

*	Name of the output dataset and put it in the calling directory:

$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%.lst" --ds=%ds%';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

*	Name of the output dataset and put it in the calling directory:

$call 'gams %script%.gms --matbal=huber --ds=%ds%_huber --neos=%neos%  o="%lstdir%%script%_huber.lst"';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit

*	Verify benchmark consistency in both MGE and MCP models, solve a counter-factual
*	and verify consistency at that point as well.

$label replicate

$set script replicate

$if %system.filesys% == MSNT $call 'title Verifying consistency of mgemodel and mcpmodel.'

$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%.lst" --ds=%ds%'
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst"

$call 'gams %script%.gms --neos=%neos%  o="%lstdir%%script%_huber.lst" --ds=%ds%_huber';
$if errorlevel 1 $abort "ERROR: %script%.gms generated an error. See %lstdir%%script%.lst";

$if set runscript $exit



