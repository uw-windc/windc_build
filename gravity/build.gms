*	Generate GDX files with Census Port-trade 

$set task read_HS_trade
$log	"Read to %task%"
$if not %pause%==no $call pause
$call gams %task%.gms gdx=%task%
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"


*	Run the new programs from Tom (Jan 2024)
$set task geographytrade
$log	"Read to %task%"
$if not %pause%==no $call pause
$call gams %task%.gms gdx=%task%
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"

*	Check the GTAPWiNDC accounts
$log	"Read to run ..\gtapwindc\gtapwindc_mge --ds=43_filtered"
$if not %pause%==no $call pause
$call gams ..\gtapwindc\gtapwindc_mge --ds=43_filtered
$if errorlevel 1 $log   "Non-zero return code from %task%"
$if errorlevel 1 $abort "Non-zero return code from %task%.gms"

*	Estimate the bilateral flows
$log	"Read to run bilatgravity gdx=bilatgravity"
$call gams bilatgravity gdx=bilatgravity
$if errorlevel 1 $log   "Non-zero return code from bilatgravity.gms"
$if errorlevel 1 $abort "Non-zero return code from bilatgravity.gms"

*	Filter the bilateral flows
$call gams filter gdx=filter

*.$call pause
$call gams gtapwindc_bilat.gms
