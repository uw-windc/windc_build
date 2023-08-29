*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------


$ifThen.gtapingams not set gtapingams
$ifThen.gtapver exist "../data/GTAPWiNDC/gtap11/GDX_AY1017.zip" 
$setglobal gtapingams  gtap11/
$else.gtapver
$setglobal gtapingams gtap9/
$endif.gtapver
$endif.gtapingams