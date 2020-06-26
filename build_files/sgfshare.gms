$TITLE Generate governmental expenditure shares

* Set directory structure:
$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* ------------------------------------------------------------------------------
* Read in raw State Government Finances data (available on the census website),
* map to sector list and generate shares to use in disagg.gms.
* ------------------------------------------------------------------------------

SET sr "Super Regions in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";
* SET r "Dynamically created set from sgf_raw parameter, regions";
SET ec "Dynamically created set from the sgf_raw parameter, government expenditure categories";
SET yr "Years in WiNDC Database";
SET g	"BEA Goods and sectors categories";

PARAMETER sgf_raw_units(yr,sr,ec,*) "Personal expenditure data, with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD yr
* $LOAD r<sgf_units.dim2
$LOAD sr
$LOAD r
$LOAD ec<sgf_units.dim3
$LOAD sgf_raw_units=sgf_units
$LOAD g=i
$GDXIN

SET map(g,ec) "Mapping between SGF and blueNOTE indices" /
$INCLUDE '%reldir%%sep%maps%sep%mapsgf.map'
/;


* Note that government expenditures in the model are treated indirectly. Most
* government administration expenditures are likely born by the production block
* of government related sectors. Thus, expenditures on public sector goods
* probably encompases public utility expenditures and the likes. That being
* said, I map many sectors to these singletons in the WiNDC model to generate
* an index based on aggregated sectors.


PARAMETER sgf_map(yr,*,g) "Mapped PCE data";
PARAMETER sgf_shr(yr,*,g) "Regional shares of final consumption";

* Note that many of the sectors in WiNDC are mapped to the same SGF
* category. Thus, sectors will have equivalent shares.

sgf_map(yr,r,g) = sum(map(g,ec), sgf_raw_units(yr,r,ec,"millions of us dollars (USD)"));

* DC is not represented in the SGF database. Assume similar expenditures as
* Maryland.

sgf_map(yr,'dc',g) = sgf_map(yr,'md',g);

ALIAS(i,*);

sgf_shr(yr,i,g)$sum(i.local, sgf_map(yr,i,g)) = sgf_map(yr,i,g) / sum(i.local, sgf_map(yr,i,g));

* For years: 1998, 2007, 2008, 2009, 2010, 2011, no government
* administration data is listed. In these cases, use all public
* expenditures (police, etc.).

sgf_shr(yr,i,g)$(sum(i.local, sgf_shr(yr,i,g)) = 0) = sgf_shr(yr,i,'fdd');

* Test, what do shares look like for %year%?

PARAMETER chkshr(g,r) "Check on SGF shares in 2014";
chkshr(g,r) = sgf_shr('2014',r,g);
DISPLAY chkshr;

ABORT$(round(smax(g, sum(r, chkshr(g,r))),6) <> 1) "Regional SGF shares don't sum to 1";


EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%shares_sgf.gdx' sgf_shr;
