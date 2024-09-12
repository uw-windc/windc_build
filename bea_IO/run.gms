$call gams readsummary
$call pause
$call gams readdetailed
$call pause
$call gams project
$call gams iobalance
$call gams gebalance
$label write
$call gams writexlsx --yr=2022
$call gams model
$call gams atmcalc
