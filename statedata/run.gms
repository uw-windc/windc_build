*	This reads the source data files and then usese these data
*	to disaggregate the symmetric model which is based on the detailed
*	input-output table:

$call gams readsasummary
$call gams SAGDPmap
$call gams readsagdp
$call gams sapceHeirarchy
$call gams readsapce
$call gams readsainc 
$call gams readsgf
$call gams readasfin
$call gams readfiws
$call gams statedisagg
