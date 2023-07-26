$title Census Trade shares


* -------------------------------------------------------------------
* Set options
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%


* -------------------------------------------------------------------
* Read in state level USA Trade Online data
* -------------------------------------------------------------------

set
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database,
    yr 		Dynamically created set from parameter usatrd_units (data years 2002-2016),
    t		Dynamically create set from parameter usatrd (Trade type import-export),
    n 		Dynamically created set from parameter usatrd (NAICS codes),
    s 		BEA Goods and sectors categories;

* Note that exports are available from 2002-2016, while imports are available
* from 2008-2012.
parameter
    usatrd_units(sr,n,yr,t,*) 	Trade data with units as domain;

$gdxin 'windc_base.gdx'
$load sr r s=i
$load n<usatrd_units.dim2
$load yr<usatrd_units.dim3
$load t<usatrd_units.dim4
$load usatrd_units
$gdxin


* -------------------------------------------------------------------
* Map Census trade categories to IO definitions and verify consistency
* -------------------------------------------------------------------

set
    map(n,s) Mapping between naics codes and sectors /
$include 'maps%sep%mapusatrd.map'
/;

parameter
    usatrd(yr,r,s,t) 		Trade data without units,
    usatrd_shr(yr,r,s,t) 	Share of total trade by region;

usatrd(yr,r,s,t) = sum(map(n,s), usatrd_units(r,n,yr,t,"millions of us dollars (USD)"));

* Which sectors are not mapped? Could be there just aren't any
* imports/exports for a given sector region pairing or the sector isn't
* included (services/utilities). For exports, it would make more sense to
* differentiate sectors not included based on state gross product for a
* given state.

set
    notinc(s) 	Sectors not included in USA Trade Data;

notinc(s) = yes$(not sum(n, map(n,s)));

usatrd_shr(yr,r,s,t)$(NOT notinc(s) and sum(r.local, usatrd(yr,r,s,t))) =
    usatrd(yr,r,s,t) / sum(r.local, usatrd(yr,r,s,t));

* Note that there isn't data for all years for the publishing sector in
* both exports and imports. Take average of data:

usatrd_shr(yr,r,s,t)$(not notinc(s) and not sum(r.local, usatrd(yr,r,s,t))) =
    sum(yr.local, usatrd(yr,r,s,t)) / sum((r.local,yr.local), usatrd(yr,r,s,t));

* Verify all shares sum to 1:

abort$(smax((yr,s), round(sum(r, usatrd_shr(yr,r,s,'exports')), 4)) <> 1) "Export shares don't sum to 1.";
abort$(smax((yr,s), round(sum(r, usatrd_shr(yr,r,s,'imports')), 4)) <> 1) "Import shares don't sum to 1.";


* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx%sep%shares_usatrd.gdx' usatrd_shr, notinc;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
