


$call gams readsummary
$call pause
$call gams readdetailed
$call pause
$call gams project s=project

$call gams iobalance r=project
$call gams gebalance

$call gams iopartition
$call gams taxcompare
$label write
$call gams writexlsx --yr=2022
$call gams model
$call gams atmcalc
