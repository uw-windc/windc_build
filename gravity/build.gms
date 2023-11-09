*.$call gams geographytrade gdx=geographytrade.gdx
$call gams ..\gtapwindc\gtapwindc_mge.gms --ds=43
$call gams bilatgravity
$call gams gtapwindc_bilat.gms
