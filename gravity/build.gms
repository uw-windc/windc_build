*.$call gams geographytrade gdx=geographytrade.gdx
$call gams ..\gtapwindc\gtapwindc_mge.gms --ds=43
$call pause
$call gams bilatgravity
$call pause
$call gams gtapwindc_bilat.gms
