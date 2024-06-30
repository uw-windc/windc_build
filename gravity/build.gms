$title	Build Script for Gravity Estimation

$goto GTAPWINDC

*	Generate GDX files with Census Port-trade 

$label read_HS_trade
$set task read_HS_trade
$log	gams %task%.gms gdx=%task%
$if not %pause%==no $call pause
$call gams %task%.gms gdx=%task%
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"

$label geographytrade
*	Run the new programs from Tom (Jan 2024)
$set task geographytrade
$log	gams %task%.gms gdx=%task%
$if not %pause%==no $call pause
$call gams %task%.gms gdx=%task%
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"

$label GTAPWiNDC
*	Check the GTAPWiNDC accounts
$log	gams ..\gtapwindc\gtapwindc_mge --ds=43_filtered s=gtapwindc_mge
$if not %pause%==no $call pause
$call gams ..\gtapwindc\gtapwindc_mge --ds=43_filtered s=gtapwindc_mge
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"

*	Estimate the bilateral flows

$label bilatgravity
$log	gams bilatgravity s=bilatgravity
$if not %pause%==no $call pause
$call gams bilatgravity s=bilatgravity
$if errorlevel 1 $log   "Non-zero return code from bilatgravity.gms"
$if errorlevel 1 $abort "Non-zero return code from bilatgravity.gms"

$exit

*	Filter the bilateral flows

$label filter
$log $call gams filter gdx=filter
$if not %pause%==no $call pause
$call gams filter gdx=filter

*	Check consistency of the resulting dataset:

$log gams gtapwindc_bilat.gms r=gtapwindc_mge
$if not %pause%==no $call pause
$call gams gtapwindc_bilat.gms r=gtapwindc_mge
