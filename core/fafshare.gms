$TITLE Generate Regional Purchase Coefficients based on CFS data

$IF NOT SET year	$SET year 2014

$SET sep %system.dirsep%

* Read in raw CFS data, map to sector list and generate RPCs to be used in disagg.gms.

SET n "Dynamically created set from cfs2012 parameter, NAICS codes";
SET sg "Dynamically created set from cfs2012 parameter, SCTG codes";
SET g "BEA Goods and sectors categories";
SET sr "Super Regions in WiNDC Database";
SET r(sr) "Regions in WiNDC Database";

* First two indices in CFS parameter correspond to regions
PARAMETER cfs2012_units(sr,sr,n,sg,*) "CFS data for 2012, with units as domain";


$GDXIN 'windc_base.gdx'
$LOAD sr
$LOAD r
$LOAD n<cfsdata_st_units.dim3
$LOAD sg<cfsdata_st_units.dim4
$LOADDC cfs2012_units=cfsdata_st_units
$LOAD g=i

$GDXIN


ALIAS(*,u);
ALIAS(r,rr);

PARAMETER d0_(r,n,sg) "State local supply";
PARAMETER mrt0_(r,r,n,sg) "Multi-regional trade";

d0_(r,n,sg) = cfs2012_units(r,r,n,sg,"millions of us dollars (USD)");
mrt0_(r,rr,n,sg)$(NOT SAMEAS(r,rr)) = cfs2012_units(r,rr,n,sg,"millions of us dollars (USD)");

* Map to model indices -- use SCTG codes. Trade is through goods markets. Note
* that the mapping includes double counting. In some instances there
* are many to one, and in other there are one to many. The point is to get
* a sense of shares.

SET map(sg,g) /
$INCLUDE 'maps%sep%mapcfs.map'
/;


* Note that WiNDC uses the RPC in the Armington nest. Therefore, we need to
* capture all goods coming IN from other states (net imports -- here we care
* only for sub-national trade).

PARAMETER d0(r,g) "Local supply-demand (CFS)";
PARAMETER xn0(r,g) "National exports (CFS)";
PARAMETER mrt0(r,r,g) "Interstate trade (CFS)";
PARAMETER mn0(r,g) "National demand (CFS)";

d0(r,g) = sum(map(sg,g), sum(n, d0_(r,n,sg)));
mrt0(r,rr,g) = sum(map(sg,g), sum(n, mrt0_(r,rr,n,sg)));
xn0(r,g) = sum(rr, mrt0(r,rr,g));
mn0(r,g) = sum(rr, mrt0(rr,r,g));


* Note that services and public sectors (i.e. utilities) are not included
* in the CFS data.

SET ng(g) "Sectors not included in the CFS";

ng(g) = yes$(sum(r, d0(r,g) + sum(rr, mrt0(r,rr,g))) = 0);
DISPLAY ng;


* Without data need to make assumptions on inter-state trade. Assume most follow
* averages. Utilities represents a special case. Later when specifying RPCs,
* assume a 90% of utility demand come from local markets.

d0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, d0(r,g));
xn0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, xn0(r,g));
mn0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, mn0(r,g));

* Define a region-good pairing's RPC as the local share of total subnational
* demand:


PARAMETER rpc(*,g) "Regional purchase coefficient";
PARAMETER x0shr(*,g) "Export shares supply";

rpc(r,g)$(d0(r,g) + mn0(r,g)) = d0(r,g) / (d0(r,g) + mn0(r,g));

* Utility specific regional purchase coefficient:

rpc(r,'uti') = 0.9;

EXECUTE_UNLOAD 'gdx%sep%cfs_rpcs.gdx' rpc;
