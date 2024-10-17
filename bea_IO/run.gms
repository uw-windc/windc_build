$call gams readsummary
$call gams readdetailed
$call gams project s=project
$call gams iobalance r=project

$exit

*	For the ATM calculation the following steps are not required.

*.$call gams gebalance
*.$call gams iopartition
*.$call gams taxcompare
$label write
$call gams writexlsx --yr=2022
$call gams model
$call gams atmcalc
