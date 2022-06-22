$set target gtap_10
$set output gtap_10

$set fs %system.dirsep%
$set gtapcode   "..%fs%gtap10ingams%fs%code%fs%"
$set runv 10a.14
$set ds gtapingams

$call gams %gtapcode%aggregate --runv="%runv%" --target=%target% --output=%output%      o=listings%fs%gtapaggr_%target%.lst

