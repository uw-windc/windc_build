$title Census Trade shares


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

parameter
    usatrd_units(sr,n,yr,t,*) 	Trade data with units as domain;

$gdxin '../data/core/windc_base.gdx'
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
$include 'maps/mapusatrd.map'
/;

parameter
    usatrd(yr,r,s,t) 		Trade data without units,
    usatrd_shr(*,r,s,t) 	Share of total trade by region;

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
* add export shares from usda for the agricultural sector
* -------------------------------------------------------------------

set
    ayr		Years in usda export data;

parameter
    usda(r,ayr)	State level exports from usda of total agricultural output;

$call 'csv2gdx ../data/core/usda_time_series_exports.csv output=gdx/usda_time_series_exports.gdx id=usda useheader=yes index="(1,2)" value=3 CheckDate=yes';
$gdxin 'gdx/usda_time_series_exports.gdx'
$load ayr=Dim2
$loaddc usda
$gdxin

$ontext	 
parameter
    comp;
comp(yr,r,'census') = usatrd_shr(yr,r,'agr','exports');
comp(ayr,r,'usda') = usda(r,ayr) / sum(r.local, usda(r,ayr));
display comp;

execute_unload '%gdxdir%/agr_trade_comparison.gdx', comp;
execute 'gdxxrw i=%gdxdir%/agr_trade_comparison.gdx o=%gdxdir%/agr_trade_comparison.xlsx par=comp rng=data!A2 cdim=0';
$offtext

* assign trade for agriculture to be based on usda shares:

usatrd_shr(ayr,r,'agr','exports')$(ayr.val <= smax(yr,yr.val)) =
    usda(r,ayr) / sum(r.local, usda(r,ayr));


* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx/shares_usatrd.gdx' usatrd_shr, notinc;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
