*	Test that we can unzip the data file:

$set fs %system.dirsep%
$call mkdir %gams.scrdir%%fs%gtapingams
$set tmpdir %gams.scrdir%%fs%gtapingams%fs%

$set gdxfile h:\gtapingams\build11final\gtapfiles\GDX_AY1017
$set syr 17

$call gmsunzip -j %gdxfile%.zip *GDX%syr%.zip   -d %tmpdir%
$call gmsunzip -j %tmpdir%GDX%syr%.zip          -d %tmpdir%

*.$call rmdir /q /s %tmpdir%