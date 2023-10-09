$title	Define Region and Sector Mappings for msmr

$batinclude mappings msmr_regions

*	Retain all the goods and factors:

alias (i,ii);
set	mapi(i,ii); mapi(i,i) = yes;

alias (f,ff);
set	mapf(f,ff); mapf(f,f) = yes;
