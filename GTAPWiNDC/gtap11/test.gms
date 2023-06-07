*	Test that we can unzip the data file:

$set gdxfile C:\Users\mphillipson\Documents\WiNDC\GDX_AY1017.zip
$set syr 17

$call gmsunzip -j %gdxfile%.zip *GDX%syr%.zip   -d %gams.scrdir%
$call gmsunzip -j %gams.scrdir%GDX%syr%.zip     -d %gams.scrdir%
