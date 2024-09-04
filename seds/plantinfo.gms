$title	Read Plant Information (state - lat - lon)

set	seq /1*99999/;

$if not exist 2___Plant_Y2022.gdx $call xlsdump 2___Plant_Y2022.xlsx
$call gdxdump 2___Plant_Y2022.gdx nodata >2___Plant_Y2022.gms
$include 2___Plant_Y2022.gms

alias (vu,vu_id,vu_st);

alias (id,st,*);

set	latlon /lat,lon/;

parameter	loc(id,st,latlon)	Plant location;

set	p(id)	Plants;

loop((vu_id("s1",r,"c3",id),vu_st("s1",r,"c7",st))$(ord(r)>2),
	p(id) = vs("s1",r,"c4");
	loc(id,st,"lat") = vf("s1",r,"c10");
	loc(id,st,"lon") = vf("s1",r,"c11");
);

option p:0:0:1;
display p;

