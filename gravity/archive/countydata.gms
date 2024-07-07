$title  Quick and Dirty State-Port Geography Calculation

$include sets

parameter	value(fips);
value(fips) = min(round(gdp(fips)),round(abs(loc(fips,"lon"))),round(abs(loc(fips,"lat"))));
display value;

set	c(fips)		Counties for which we have both coordinate and GDP;
c(fips) = yes$value(fips);

set	missing(fips)	Missing counties;
missing(fips) = fips(fips)$(not c(fips));

*	Don't worry about the locations which are not counties:

missing(fips)$( (ord(fips.tl,3)=ord("0",1)) and 
		(ord(fips.tl,4)=ord("0",1)) and 
		(ord(fips.tl,5)=ord("0",1)) )  = no;

option missing:0:0:1;
display missing;

alias (c,cc);
parameter	dist(fips,fips)	Distances,
		r		Radius of the earth (miles) /3949/;

$macro lamda(c)		(pi * loc(c,"lon") / 180)
$macro phi(c)		(pi * loc(c,"lat") / 180)

dist(c,cc)$(not sameas(c,cc)) =
	r*arccos(sin(phi(c))*sin(phi(cc)) +
		 cos(phi(c))*cos(phi(cc)) * cos(abs(lamda(c)-lamda(cc))));

parameter	owndist(fips)	Distances within counties;
owndist(c) = smin(cc$dist(c,cc),dist(c,cc)/2) + eps;
display owndist;

dist(c,c) = owndist(c);

*	Convert to millions of dollars:

gdp(c) = gdp(c)/1e6;

execute_unload 'countydata.gdx',c, dist, gdp;