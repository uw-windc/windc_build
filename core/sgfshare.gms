$title State government finance (SGF) shares


* -------------------------------------------------------------------
* Set options
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%


* -------------------------------------------------------------------
* Read in state level SGF data
* -------------------------------------------------------------------

set
    yr 		Years in WiNDC Database,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database,
    ec 		Dynamically created set from the sgf_raw parameter (government expenditure categories),
    g		BEA Goods and sectors categories;

parameter
    sgf_raw_units(yr,sr,ec,*) Personal expenditure data with units as domain;

$gdxin 'windc_base.gdx'
$load yr g=i sr r
$load ec<sgf_units.dim3
$load sgf_raw_units=sgf_units
$gdxin


* -------------------------------------------------------------------
* Map SGF categories to IO definitions and verify consistency
* -------------------------------------------------------------------

set
    map(g,ec) Mapping between SGF and WiNDC indices /
$include 'maps%sep%mapsgf.map'
/;

parameter
    sgf_map(yr,r,g) 	Mapped PCE data,
    sgf_shr(yr,r,g) 	Regional shares of final consumption;

* Note that government expenditures in the dataset exist in both final demand
* and in the production block of government related sectors. The latter is
* accounted for using GSP shares. Note that many of the sectors in WiNDC are
* mapped to the same SGF category so some sectors will have equivalent shares.

sgf_map(yr,r,g) = sum(map(g,ec), sgf_raw_units(yr,r,ec,"millions of us dollars (USD)"));

* DC is not represented in the SGF database. Assume similar expenditures as
* Maryland.

sgf_map(yr,'DC',g) = sgf_map(yr,'MD',g);
sgf_shr(yr,r,g)$sum(r.local, sgf_map(yr,r,g)) = sgf_map(yr,r,g) / sum(r.local, sgf_map(yr,r,g));

* For years: 1998, 2007, 2008, 2009, 2010, 2011, no government
* administration data is listed. In these cases, use all public
* expenditures (police, etc.).

sgf_shr(yr,r,g)$(sum(r.local, sgf_shr(yr,r,g)) = 0) = sgf_shr(yr,r,'fdd');

abort$(round(smax((yr,g), sum(r, sgf_shr(yr,r,g))),6) <> 1) "Regional SGF shares don't sum to 1";


* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx%sep%shares_sgf.gdx' sgf_shr;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
