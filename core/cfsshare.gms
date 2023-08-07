$title Regional purchase coefficients (RPC) from commodity flow survey (CFS)


* -------------------------------------------------------------------
* Set options
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%


* -------------------------------------------------------------------
* Read in state level CFS data
* -------------------------------------------------------------------

set
    n 		Dynamically created set from cfs2012 parameter (NAICS codes),
    sg 		Dynamically created set from cfs2012 parameter (SCTG codes),
    g 		BEA Goods and sectors categories,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database;

* First two indices in CFS parameter correspond to regions

parameter
    cfs2012_units(sr,sr,n,sg,*) CFS data for 2012 with units as domain;

$gdxin 'windc_base.gdx'
$load sr r g=i
$load n<cfsdata_st_units.dim3
$load sg<cfsdata_st_units.dim4
$loaddc cfs2012_units=cfsdata_st_units
$gdxin
alias(r,rr),(*,u);


* -------------------------------------------------------------------
* Map CFS categories to IO definitions and verify consistency
* -------------------------------------------------------------------

parameter
    d0_(r,n,sg) 	State local supply,
    mrt0_(r,r,n,sg) 	Multi-regional trade;

d0_(r,n,sg) = cfs2012_units(r,r,n,sg,"millions of us dollars (USD)");
mrt0_(r,rr,n,sg)$(not sameas(r,rr)) = cfs2012_units(r,rr,n,sg,"millions of us dollars (USD)");

* Map to model indices -- use SCTG codes. Trade is through goods markets. Note
* that the mapping includes double counting. In some instances there
* are many to one, and in other there are one to many.

set
    map(sg,g)   Mapping between SCTG and WiNDC indicies /
$include 'maps%sep%mapcfs.map'
/;

* Note that WiNDC uses the RPC in the Armington nest. Therefore, we need to
* capture all goods coming IN from other states (net imports -- here we care
* only for sub-national trade).

parameter
    d0(r,g) 	Local supply-demand (CFS),
    xn0(r,g) 	National exports (CFS),
    mrt0(r,r,g) Interstate trade (CFS),
    mn0(r,g) 	National demand (CFS)";

d0(r,g) = sum(map(sg,g), sum(n, d0_(r,n,sg)));
mrt0(r,rr,g) = sum(map(sg,g), sum(n, mrt0_(r,rr,n,sg)));
xn0(r,g) = sum(rr, mrt0(r,rr,g));
mn0(r,g) = sum(rr, mrt0(rr,r,g));

* Note that services and public sectors (i.e. utilities) are not included
* in the CFS data.

set
    ng(g) 	Sectors not included in the CFS;

ng(g) = yes$(sum(r, d0(r,g) + sum(rr, mrt0(r,rr,g))) = 0);
display ng;

* Without data need to make assumptions on inter-state trade. Assume most follow
* averages. Utilities represents a special case. Later when specifying RPCs,
* assume a 90% of utility demand come from local markets.

d0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, d0(r,g));
xn0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, xn0(r,g));
mn0(r,ng) = (1 / sum(g$(NOT ng(g)), 1)) * sum(g, mn0(r,g));

* Define a region-good pairing's RPC as the local share of total subnational
* demand:

parameter
    rpc(*,g) 	Regional purchase coefficient;

rpc(r,g)$(d0(r,g) + mn0(r,g)) = d0(r,g) / (d0(r,g) + mn0(r,g));

* Utility specific regional purchase coefficient:

rpc(r,'uti') = 0.9;


* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx%sep%cfs_rpcs.gdx' rpc;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
