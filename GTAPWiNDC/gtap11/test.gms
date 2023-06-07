*	Test that we can unzip the data file:

$set gdxfile h:\gtapingams\build11final\gtapfiles\GDX_AY1017
$set syr 17

$call gmsunzip -j %gdxfile%.zip *GDX%syr%.zip   -d %gams.scrdir%
$call gmsunzip -j %gams.scrdir%GDX%syr%.zip     -d %gams.scrdir%
