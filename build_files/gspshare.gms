$TITLE Share Generation Based On State Level Gross Product

$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF


* -------------------------------------------------------------------
* Read in state level GSP data:
* -------------------------------------------------------------------

SET yr "Years in WiNDC Database"
SET r "Regions in WiNDC Database";
SET s "BEA Goods and sectors categories";
SET si "Dynamically created set from parameter gsp_units, State industry list";
SET gdpcat "Dynamically creates set from parameter gsp_units, GSP components"


* Note the dynamically created set notation here using the '<' character
PARAMETER gsp_units(r,yr,gdpcat<,si<,*) "Annual gross state product with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD s=i
$LOAD yr
$LOAD r
$LOADDC gsp_units
$GDXIN


* Note: GSP <> lab + cap + tax in the data for government affiliated sectors
* (utilities, enterprises, etc.).

PARAMETER gspcalc(r,yr,gdpcat,si) "Calculated gross state product";

gspcalc(r,yr,'cmp',si) = gsp_units(r,yr,'cmp',si,"millions of us dollars (USD)");
gspcalc(r,yr,'gos',si) = gsp_units(r,yr,'gos',si,"millions of us dollars (USD)");
gspcalc(r,yr,'taxsbd',si) = gsp_units(r,yr,'taxsbd',si,"millions of us dollars (USD)");
gspcalc(r,yr,'gdp',si) = gspcalc(r,yr,'cmp',si) + gspcalc(r,yr,'gos',si) + gspcalc(r,yr,'taxsbd',si);



* Note that some capital account elements of GSP are negative (taxes and
* capital expenditures).

* -------------------------------------------------------------------
* Map GSP sectors to national IO definitions:
* -------------------------------------------------------------------

* Note that in the mapping, aggregate categories in the GSP dataset are
* removed. Also, the used and other sectors don't have any mapping to the
* state files. In cases other than used and other, the national files have
* more detail. In cases where multiple sectors are mapped to the state gdp
* estimates, the same profile of GDP will be used. Used and scrap sectors
* are defined by state averages.


SET mapsec(si,s) "Mapping between state sectors and national sectors" /
$INCLUDE '%reldir%%sep%maps%sep%mapgsp.map'
/;

PARAMETER gsp0(yr,r,s,*) "Mapped state level gsp accounts";
PARAMETER gspcat0(yr,r,s,gdpcat) "Mapped gsp categorical accounts";

gsp0(yr,r,s,'Calculated') = sum(mapsec(si,s), gspcalc(r,yr,'gdp',si));
gsp0(yr,r,s,'Reported') = sum(mapsec(si,s), gsp_units(r,yr,'gdp',si,"millions of us dollars (USD)"));
gsp0(yr,r,s,'Diff') = gsp0(yr,r,s,'Calculated') - gsp0(yr,r,s,'Reported');

gspcat0(yr,r,s,gdpcat) = sum(mapsec(si,s), gsp_units(r,yr,gdpcat,si,"millions of us dollars (USD)"));

* For the most part, these figures match (rounding errors produce +-1 on the
* check). However, sector 10 other government affiliated sectors (utilities)
* produces larger error.

* -------------------------------------------------------------------
* Generate io-shares using national data to share out regional GDP
* estimates, first mapping data to state level aggregation:
* -------------------------------------------------------------------

PARAMETER region_shr "Regional share of value added";
PARAMETER labor_shr "Share of regional value added due to labor";
PARAMETER netva "Net value added (compensation + surplus)";

region_shr(yr,r,s)$(sum(r.local, gsp0(yr,r,s,'Reported'))) = gsp0(yr,r,s,'Reported') / sum(r.local,  gsp0(yr,r,s,'Reported'));

* Let the used and scrap sectors be an average of other sectors:

region_shr(yr,r,'use')$sum((r.local,s), region_shr(yr,r,s)) = sum(s, region_shr(yr,r,s)) / sum((r.local,s), region_shr(yr,r,s));
region_shr(yr,r,'oth')$sum((r.local,s), region_shr(yr,r,s)) = sum(s, region_shr(yr,r,s)) / sum((r.local,s), region_shr(yr,r,s));

* Verify regional shares sum to one:

region_shr(yr,r,s)$sum(r.local, region_shr(yr,r,s)) = region_shr(yr,r,s) / sum(r.local, region_shr(yr,r,s));

* Construct factor totals:

netva(yr,r,s,'sudo') = gspcat0(yr,r,s,'cmp') + (gsp0(yr,r,s,'Reported') - gspcat0(yr,r,s,'cmp') - gspcat0(yr,r,s,'taxsbd'));
netva(yr,r,s,'comp') = gspcat0(yr,r,s,'cmp') + gspcat0(yr,r,s,'gos');

* Define labor component of value added demand:

labor_shr(yr,r,s)$netva(yr,r,s,'comp') = gspcat0(yr,r,s,'cmp') / netva(yr,r,s,'comp');

* At least 1 year for a given region-sector pairing has wage shares less than 1:

SET hw(r,s) "Regions with all years of high wage shares";
hw(r,s) = yes$(smin(yr$labor_shr(yr,r,s), labor_shr(yr,r,s))>1);


PARAMETER seclaborshr(yr,s) Sector level average labor shares;

seclaborshr(yr,s)$sum(r$(labor_shr(yr,r,s) < 1), 1) =
    (1/sum(r$(labor_shr(yr,r,s) < 1), 1)) * sum(r$(labor_shr(yr,r,s) < 1), labor_shr(yr,r,s));

* Pick out (year,region,sector) pairings with wage shares greater than 1.

SET wg(yr,r,s) "Index pairs with high wage shares";
wg(yr,r,s) = yes$(labor_shr(yr,r,s) > 1);

* Take an average for a given region-sector across years with shares less
* than 1.

PARAMETER avgwgshr(r,s) "Average wage share";

avgwgshr(r,s)$(not hw(r,s)) =
    (1/sum(yr$(not wg(yr,r,s)), 1)) * sum(yr$(not wg(yr,r,s)), labor_shr(yr,r,s));

labor_shr(yr,r,s)$hw(r,s) = seclaborshr(yr,s);
labor_shr(yr,r,s)$(wg(yr,r,s) and avgwgshr(r,s)) = avgwgshr(r,s);

PARAMETER chkshrs "Check on regional shares";
chkshrs(yr,s) = sum(r, region_shr(yr,r,s));

ABORT$(round(smin((yr,s), chkshrs(yr,s))) <> 1) "Missing GSP shares.";
ABORT$(round(smax((yr,r,s), labor_shr(yr,r,s))) > 1) "Shares greater than 1";

* -------------------------------------------------------------------
* Output regional shares:
* -------------------------------------------------------------------

EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%shares_gsp.gdx' region_shr, labor_shr;
