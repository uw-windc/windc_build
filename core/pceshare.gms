$title Personal consumer expenditure (PCE) shares


* -------------------------------------------------------------------
* Set options
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%


* -------------------------------------------------------------------
* Read in state level PCE data
* -------------------------------------------------------------------

set
    yr 		Years in WiNDC Database,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database,
    pg 		Dynamically created set from parameter pce_units (PCE goods),
    g 		BEA Goods and sectors categories;

parameter
    pce_raw_units(yr,sr,pg,*) Personal expenditure data with units as domain;

$gdxin '../data/core/windc_base.gdx'
$load yr g=i sr r
$load pg<pce_units.dim3
$load pce_raw_units=pce_units
$gdxin


* -------------------------------------------------------------------
* Map PCE categories to IO definitions and verify consistency
* -------------------------------------------------------------------

set
    map(g,pg) 	Mapping between pce and WiNDC indices /
$include 'maps%sep%mappce.map'
/;

parameter
    pce_map(yr,r,g) 	Mapped PCE data,
    pce_shr(yr,r,g) 	Regional shares of final consumption;

* Note that many of the sectors in WiNDC are mapped to the same PCE
* category. Thus, sectors will have equivalent shares.

pce_map(yr,r,g) = sum(map(g,pg), pce_raw_units(yr,r,pg,"millions of us dollars (USD)"));
pce_shr(yr,r,g) = pce_map(yr,r,g) / sum(r.local, pce_map(yr,r,g));

abort$(round(smax((yr,g), sum(r, pce_shr(yr,r,g))),6) <> 1) "Regional PCE shares don't sum to 1";


* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx%sep%shares_pce.gdx' pce_shr;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
