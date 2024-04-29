$title	Define Region and Sector Mappings for russia_all


$batinclude "%system.fp%../mappings" russia

*	Retain all the goods and factors:

alias (i,ii);
set	mapi(i,ii); mapi(i,i) = yes;

alias (f,ff);
set	mapf(f,ff); mapf(f,f) = yes;
