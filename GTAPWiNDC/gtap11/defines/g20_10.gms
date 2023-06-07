$title	Define Region and Sector Mappings for g20_10

parameter	mapbug(*)	Problems with mapping;

$batinclude mappings g20
$batinclude mappings windc_10

*	Retain all the factors:

alias (f,ff);
set	mapf(f,ff); mapf(f,f) = yes;
