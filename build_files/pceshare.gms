$TITLE Generate PCE shares

$IF NOT SET year $SET year 2014

* Set directory structure:
$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF

* Read in raw PCE data, map to sector list and generate shares to use in
* disagg.gms.

SET sr "Super Regions in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";
SET pg "Dynamically created set from parameter pce_units, PCE goods";
SET yr "Years in WiNDC Database"
SET g "BEA Goods and sectors categories";

PARAMETER pce_raw_units(yr,sr,pg,*) "Personal expenditure data with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD yr
$LOAD g=i
$LOAD sr
$LOAD r
$LOAD pg<pce_units.dim3
$LOAD pce_raw_units=pce_units
$GDXIN


SET map(g,pg) "Mapping between pce and blueNOTE indices" /
$INCLUDE '%reldir%%sep%maps%sep%mappce.map'
/;


PARAMETER pce_map(r,g,yr) "Mapped PCE data";
PARAMETER pce_shr(yr,r,g) "Regional shares of final consumption";

* Note that many of the sectors in blueNOTE are mapped to the same PCE
* category. Thus, sectors will have equivalent shares.

pce_map(r,g,yr) = sum(map(g,pg), pce_raw_units(yr,r,pg,"millions of us dollars (USD)"));
pce_shr(yr,r,g) = pce_map(r,g,yr) / sum(r.local, pce_map(r,g,yr));

* Test, what do shares look like for %year%?

PARAMETER chkshr(g,r) "Check on PCE shares";
chkshr(g,r) = pce_shr('%year%',r,g);
DISPLAY chkshr;

ABORT$(round(smax(g, sum(r, chkshr(g,r))),6) <> 1) "Regional PCE shares don't sum to 1";

EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%shares_pce.gdx' pce_shr;
