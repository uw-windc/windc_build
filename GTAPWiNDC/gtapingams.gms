*-----------------------
*   If the value of gtapingams is not set via command line,
*   then set its value. If the data for gtap11 exists, then
*   gtapingams will be set to gtap11, otherwise gtap9
*-----------------------

$ifThen not set gtapingams
$ifThen exist "../data/GTAPWiNDC/gtap11/GDX_AY1017.zip" 
$set gtapingams  gtap11/
$else
$set gtapingams gtap9/
$endif
$endif