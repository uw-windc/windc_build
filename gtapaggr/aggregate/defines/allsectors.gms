$stitle		Define a Sectoral Mapping with All Sectors in the GTAPinGAMS Dataset

*	N.B. There are additional sectors added with GTAP10, so the number of
*	sectors in the aggregation will depend on the GTAP version.

alias (i,ii);

SET mapi(i,ii)  Mapping for sectors and goods;
mapi(i,ii) = yes$sameas(i,ii);
abort$(card(i)<>card(ii))	"Error: card(i)<>card(ii).";

*	See that each commodity in the source data has been mapped:

abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).";
