*	Define the dataset with all factors:

*	N.B. There are additional factors added with GTAP9, so the number of
*	sectors in the aggregation will depend on the GTAP version.

alias (f,ff);

SET mapf(f,ff)  Mapping for sectors and goods;
mapf(f,ff) = yes$sameas(f,ff);
abort$(card(f)<>card(ff))	"Error: card(f)<>card(ff).";

*	See that each commodity in the source data has been mapped:

abort$(card(mapf)<>card(f))	"Error: card(mapf)<>card(f).";
