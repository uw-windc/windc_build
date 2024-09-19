* $call gdxxrw i=2007a.xls o=2007a.gdx par=data rng=a8..ea188 ignorerows=9,10,11

$if not set ss $set ss 2007a
$call xlsdump %ss%.xls %ss%.gdx
$call gdxdump %ss%.gdx  nodata output=%ss%.gms
$include %ss%.gms

option vs:0:0:1, vu:0:0:1;
display w, s, ws, vs, vu;