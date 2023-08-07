$title Regional purchase coefficients (RPC) from freight analysis framework (FAF)


* -------------------------------------------------------------------
* Set options
* -------------------------------------------------------------------

* file separator
$set sep %system.dirsep%


* -------------------------------------------------------------------
* Read in state level FAF data
* -------------------------------------------------------------------

set
    sg 		SCTG2 codes /
		1	"Live animals/fish",
		2	"Cereal�grains",
		3	"Other�ag�prods.",
		4	"Animal�feed",
		5	"Meat/seafood",
		6	"Milled�grain�prods.",
		7	"Other�foodstuffs",
		8	"Alcoholic�beverages",
		9	"Tobacco�prods.",
		10	"Building�stone",
		11	"Natural�sands",
		12	"Gravel",
		13	"Nonmetallic�minerals",
		14	"Metallic�ores",
		15	"Coal",
		16	"Crude�petroleum",
		17	"Gasoline",
		18	"Fuel�oils",
		19	"Natural�gas�and�other�fossil�products",
		20	"Basic�chemicals",
		21	"Pharmaceuticals",
		22	"Fertilizers",
		23	"Chemical�prods.",
		24	"Plastics/rubber",
		25	"Logs",
		26	"Wood�prods.",
		27	"Newsprint/paper",
		28	"Paper�articles",
		29	"Printed�prods.",
		30	"Textiles/leather",
		31	"Nonmetal�min.�prods.",
		32	"Base�metals",
		33	"Articles-base�metal",
		34	"Machinery",
		35	"Electronics",
		36	"Motorized�vehicles",
		37	"Transport�equip.",
		38	"Precision�instruments",
		39	"Furniture",
		40	"Misc.�mfg.�prods.",
		41	"Waste/scrap",
		43	"Mixed�freight" /,

    yr 		Years in WiNDC Database,
    fyr		Years in FAF data (1997-2021),
    g 		BEA Goods and sectors categories,
    sr 		Super Regions in WiNDC Database,
    r(sr) 	Regions in WiNDC Database;

* First two indices in FAF parameter correspond to regions

parameter
    faf_units(sr,sr,sg,fyr) FAF data;

$gdxin '../data/core/windc_base.gdx'
$load yr sr r g=i
$gdxin
alias(r,rr),(*,u);

$call 'csv2gdx added_data/faf_data_1997_2021.csv output=added_data/faf_data_1997_2021.gdx id=faf_units index=(1,2,3,4) colCount=5 value=lastCol useHeader=Y';
$gdxin 'added_data/faf_data_1997_2021.gdx'
$load fyr=Dim4
$load faf_units
$gdxin


* -------------------------------------------------------------------
* Map FAF categories to IO definitions and verify consistency
* -------------------------------------------------------------------

parameter
    d0_(fyr,r,sg) 	State local supply,
    mrt0_(fyr,r,r,sg) 	Multi-regional trade;

d0_(fyr,r,sg) = faf_units(r,r,sg,fyr);
mrt0_(fyr,r,rr,sg)$(not sameas(r,rr)) = faf_units(r,rr,sg,fyr);

* Map to model indices -- use SCTG codes. Trade is through goods markets. Note
* that the mapping includes double counting. In some instances there
* are many to one, and in other there are one to many. No trade data for
* services.

set
    map(sg,g)    Mapping between SCTG and WiNDC indicies /
$include 'maps%sep%mapfaf.map'
/,
    mapy(fyr,yr) Mapping between years /
    		 1997.(1997*1999),
		 2002.(2000*2004),
		 2007.(2005*2009),
		 2012.(2010*2014),
		 2017.(2015*2017) /;
* 		 2018.2018, 2019.2019, 2020.2020, 2021.2021/;

* Note that WiNDC uses the RPC in the Armington nest. Therefore, we need to
* capture all goods coming IN from other states (net imports -- here we care
* only for sub-national trade).

parameter
    d0(yr,r,g) 		Local supply-demand (FAF),
    xn0(yr,r,g) 	National exports (FAF),
    mrt0(yr,r,r,g) 	Interstate trade (FAF),
    mn0(yr,r,g) 	National demand (FAF);

d0(yr,r,g) = sum((map(sg,g),mapy(fyr,yr)), d0_(fyr,r,sg));
mrt0(yr,r,rr,g) = sum((map(sg,g),mapy(fyr,yr)), mrt0_(fyr,r,rr,sg));
xn0(yr,r,g) = sum(rr, mrt0(yr,r,rr,g));
mn0(yr,r,g) = sum(rr, mrt0(yr,rr,r,g));

* Note that services and public sectors (i.e. utilities) are not included
* in the FAF data.

set
    ng(g) 	Sectors not included in the FAF;

ng(g) = yes$(sum((r,yr), d0(yr,r,g) + sum(rr, mrt0(yr,r,rr,g))) = 0);
display ng;

* Without data need to make assumptions on inter-state trade. Assume most follow
* averages. Utilities represents a special case. Later when specifying RPCs,
* assume a 90% of utility demand come from local markets.

d0(yr,r,ng) = (1 / sum(g$(not ng(g)), 1)) * sum(g, d0(yr,r,g));
xn0(yr,r,ng) = (1 / sum(g$(not ng(g)), 1)) * sum(g, xn0(yr,r,g));
mn0(yr,r,ng) = (1 / sum(g$(not ng(g)), 1)) * sum(g, mn0(yr,r,g));

* Define a region-good pairing's RPC as the local share of total subnational
* demand:

parameter
    rpc(yr,*,g) 	Regional purchase coefficient;

rpc(yr,r,g)$(d0(yr,r,g) + mn0(yr,r,g)) = d0(yr,r,g) / (d0(yr,r,g) + mn0(yr,r,g));

* Utility specific regional purchase coefficient:

rpc(yr,r,'uti') = 0.9;

$ontext
* compare faf rpcs with cfs rpcs;
parameter
    cfs_rpc;

$gdxin gdx%sep%cfs_rpcs.gdx
$load cfs_rpc=rpc
$gdxin

parameter
    chk;

chk(r,g,'cfs') = cfs_rpc(r,g);
chk(r,g,'faf') = rpc('2012',r,g);

execute_unload 'added_data/rpc_comparison_2012.gdx', chk;
execute 'gdxxrw i=added_data/rpc_comparison_2012.gdx o=added_data/rpc_comparison_2012.xlsx par=chk rng=data!A2 cdim=0';
$offtext

* -------------------------------------------------------------------
* Output regional shares
* -------------------------------------------------------------------

execute_unload 'gdx%sep%faf_rpcs.gdx' rpc;


* -------------------------------------------------------------------
* End
* -------------------------------------------------------------------
