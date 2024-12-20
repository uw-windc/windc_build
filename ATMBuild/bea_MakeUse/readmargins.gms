$title	Read Margins

$set wb data\Margins_After_Redefinitions_2017_DET
$set gdxout data\margins.gdx

$if not exist %wb%.gdx $call xlsdump %wb%.xlsx %wb%.gdx
$call gdxdump %wb%.gdx nodata output=%wb%.gms
$include %wb%.gms

set	yr /2007,2012,2017/;

alias (ui,ug,*);

set		i(ui),g(ug);
parameter	margins(yr,ui,ug,*)	Margins After Redefinitions [Millions of dollars];

alias (vu,vui,vug);
loop(ws(s,yr),
	loop((vui(s,r,"c1",ui),vug(s,r,"c3",ug))$(ord(r)>5),
	  i(ui) = vs(s,r,"c2");
	  g(ug) = vs(s,r,"c4");
	  margins(yr,ui,ug,"pro") = vf(s,r,"c5");
	  margins(yr,ui,ug,"trn") = vf(s,r,"c6");
	  margins(yr,ui,ug,"whl") = vf(s,r,"c7");
	  margins(yr,ui,ug,"rtl") = vf(s,r,"c8");
	  margins(yr,ui,ug,"pur") = vf(s,r,"c9");
	);
);
option margins:3:3:1;
display margins;

execute_unload '%gdxout%',margins,i=s,g;
