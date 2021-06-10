$TITLE Partition IO data in CGE Parameters (1997-2017)

$SET sep %system.dirsep%

* -------------------------------------------------------------------
* 	Read in dataset:
* -------------------------------------------------------------------

SET yr "Years in the dataset";
SET i "BEA Goods and sectors categories";
SET va "BEA Value added categories";
SET fd "BEA Final demand categories";
SET ts "BEA Taxes and subsidies categories";

SET ir_use "Dynamically created set from use_units parameter";
SET ir_supply "Dynamically created set from supply_units parameter";
SET jc_use "Dynamically created set from use_units parameter";
SET jc_supply "Dynamically created set from supply_units parameter";

PARAMETER use_units(yr,ir_use,jc_use,*) "Annual use matrix with units domain";
PARAMETER supply_units(yr,ir_supply,jc_supply,*) "Annual supply matrix with units domain";

$GDXIN 'windc_base.gdx'
$LOAD yr
$LOAD i
$LOAD va
$LOAD fd
$LOAD ts
$LOAD ir_use<use_units.dim2
$LOAD jc_use<use_units.dim3
$LOAD use_units
$LOAD ir_supply<supply_units.dim2
$LOAD jc_supply<supply_units.dim3
$LOAD supply_units
$GDXIN

ALIAS(i,j);

* -------------------------------------------------------------------
* 	Scale dataset:
* -------------------------------------------------------------------

* Scale input-output data to be in billions of dollars.

PARAMETER use(yr,ir_use,jc_use) "Annual use matrix without units domain";
PARAMETER supply(yr,ir_supply,jc_supply) "Annual supply matrix without units domain";

use(yr,ir_use,jc_use) = use_units(yr,ir_use,jc_use,"millions of us dollars (USD)") * 1e-3;
supply(yr,ir_supply,jc_supply) = supply_units(yr,ir_supply,jc_supply,"millions of us dollars (USD)") * 1e-3;


* -------------------------------------------------------------------
* 	Partition dataset:
* -------------------------------------------------------------------

PARAMETER y0(yr,i) "Gross output";
PARAMETER ys0(yr,j,i) "Sectoral supply";
PARAMETER fs0(yr,i) "Household supply";
PARAMETER id0(yr,i,j) "Intermediate demand";
PARAMETER fd0(yr,i,fd) "Final demand,";
PARAMETER va0(yr,va,j) "Value added";
PARAMETER ts0(yr,ts,j) "Taxes and subsidies";
PARAMETER m0(yr,i) "Imports";
PARAMETER x0(yr,i) "Exports of goods and services";
PARAMETER mrg0(yr,i) "Trade margins";
PARAMETER trn0(yr,i) "Transportation costs";
PARAMETER cif0(yr,i) "CIF/FOB Adjustments on Imports";
PARAMETER duty0(yr,i) "Import duties";
PARAMETER sbd0(yr,i) "Subsidies on products";
PARAMETER tax0(yr,i) "Taxes on products";

id0(yr,i(ir_use),j(jc_use)) = use(yr,ir_use,jc_use);
ys0(yr,j(jc_supply),i(ir_supply)) = supply(yr,ir_supply,jc_supply);

* Treat negative inputs as outputs:

ys0(yr,j,i) = ys0(yr,j,i) - min(0,id0(yr,i,j));
id0(yr,i,j) = max(0,id0(yr,i,j));
fd0(yr,i(ir_use),fd(jc_use)) = use(yr,ir_use,jc_use);
va0(yr,va(ir_use),j(jc_use)) = use(yr,ir_use,jc_use);
ts0(yr,ts(ir_use),j(jc_use)) = use(yr,ir_use,jc_use);
ts0(yr,'subsidies',j) = - ts0(yr,'subsidies',j);

m0(yr,i(ir_supply)) = supply(yr,ir_supply,"imports");
mrg0(yr,i(ir_supply)) = supply(yr,ir_supply,"margins");
trn0(yr,i(ir_supply)) = supply(yr,ir_supply,"trncost");
cif0(yr,i(ir_supply)) = supply(yr,ir_supply,"ciffob");
duty0(yr,i(ir_supply)) = supply(yr,ir_supply,"duties");
tax0(yr,i(ir_supply)) = supply(yr,ir_supply,"tax");
sbd0(yr,i(ir_supply)) = - supply(yr,ir_supply,"subsidies");
x0(yr,i(ir_use)) = use(yr,ir_use,"exports");

* Adjust transport margins for transport sectors according to CIF/FOB
* adjustments. Insurance imports are specified as net of adjustments.

trn0(yr,i)$(cif0(yr,i) AND NOT SAMEAS(i,'ins')) = trn0(yr,i) + cif0(yr,i);
m0(yr,i)$(SAMEAS(i,'ins')) = m0(yr,i) + cif0(yr,i);
cif0(yr,i) = 0;

y0(yr,i) = sum(j, ys0(yr,j,i));

PARAMETER interm(yr,j,*) "Total intermediate inputs (purchasers' prices)";
PARAMETER basicva(yr,j,*) "Basic value added (purchasers' prices)";
PARAMETER valueadded(yr,j,*) "Value added (purchaser's prices)";
PARAMETER output(yr,j,*) "Total industry output (basic prices)";
PARAMETER taxtotal(yr,*) "Check on total taxes";
PARAMETER totint(yr,i,*) "Total intermediate use (purchasers' prices)";
PARAMETER totaluse(yr,i,*) "Total use of commodities (purchasers' prices)";
PARAMETER basicsupply(yr,i,*)	"Basic supply";
PARAMETER tsupply(yr,i,*) "Total supply";

interm(yr,j(jc_use),"use") = use(yr,"interm",jc_use);
interm(yr,j,'id0') = sum(i,id0(yr,i,j));
interm(yr,j,"chk") = interm(yr,j,'id0') - interm(yr,j,"use");

DISPLAY interm;

* Sets with large positive differences are the result of eliminating
* negative input demands. Indicies with negative numbers for "chk"
* represent improper summing in the use tables supplied by the BEA. This
* is likely due to rounding upstream in their data routines. This latter
* point applies to other differences below (for value added, etc.).

basicva(yr,j(jc_use),"use") = use(yr,"basicvalueadded",jc_use);
basicva(yr,j,"va0") = sum(va,va0(yr,va,j));
basicva(yr,j,"chk") = basicva(yr,j,"use") - basicva(yr,j,"va0");
DISPLAY basicva;

valueadded(yr,j(jc_use),"use") = use(yr,"valueadded",jc_use);
valueadded(yr,j,"va0+ts0") = sum(va,va0(yr,va,j)) +
			ts0(yr,"taxes",j) - ts0(yr,"subsidies",j);
valueadded(yr,j,"chk") = valueadded(yr,j,"use") - valueadded(yr,j,"va0+ts0");
DISPLAY valueadded;

taxtotal(yr,"ts_subsidies") = sum(j, ts0(yr,"subsidies",j));
taxtotal(yr,"ts_taxes") = sum(j, ts0(yr,"taxes",j));
taxtotal(yr,"s0") = sum(i,sbd0(yr,i));
taxtotal(yr,"t0+duty") = sum(i,tax0(yr,i)+duty0(yr,i));
DISPLAY taxtotal;

* Differences in subsidy totals from zeroing out taxes and subsidies for
* margin only sectors.

output(yr,j(jc_use),"use") = use(yr,"industryoutput",jc_use);
output(yr,j,"id0+va0") = sum(va,va0(yr,va,j)) + sum(i,id0(yr,i,j));
output(yr,j,'ys0') = sum(i,ys0(yr,j,i));
output(yr,j,"chk") = output(yr,j,"id0+va0") - output(yr,j,"use");
output(yr,j,"chk-ys0") = output(yr,j,"id0+va0") - output(yr,j,'ys0');
DISPLAY output;

totint(yr,i(ir_use),"use") = use(yr,ir_use,"totint");
totint(yr,i,'id0') = sum(j,id0(yr,i,j));
totint(yr,i,"chk") = totint(yr,i,"use") - totint(yr,i,'id0');
DISPLAY totint;

totaluse(yr,i(ir_use),"use") = use(yr,ir_use,"totaluse");
totaluse(yr,i,"id0+fd0") = sum(j,id0(yr,i,j)) + sum(fd,fd0(yr,i,fd)) + x0(yr,i);
totaluse(yr,i,"chk") = totaluse(yr,i,"use") - totaluse(yr,i,"id0+fd0");
DISPLAY totaluse;

basicsupply(yr,i(ir_supply),'supply') = supply(yr,ir_supply,"BasicSupply");
basicsupply(yr,i,'ys0') = sum(j,ys0(yr,j,i));
basicsupply(yr,i,"chk") = basicsupply(yr,i,'supply') - basicsupply(yr,i,'ys0');
DISPLAY basicsupply;

tsupply(yr,i(ir_supply),'supply') = supply(yr,ir_supply,"Supply");
tsupply(yr,i,"ys0+...") = sum(j,ys0(yr,j,i))
	+ m0(yr,i) + mrg0(yr,i) + trn0(yr,i) + duty0(yr,i) + tax0(yr,i) - sbd0(yr,i);
tsupply(yr,i,"totaluse") = sum(j,id0(yr,i,j)) + sum(fd,fd0(yr,i,fd)) + x0(yr,i);
tsupply(yr,i,"chk") = tsupply(yr,i,'supply') - tsupply(yr,i,"totaluse");
tsupply(yr,i,"supply-use") = tsupply(yr,i,"ys0+...") - tsupply(yr,i,"totaluse");
DISPLAY tsupply;

SET	m	"Margins" / trd "trade",trn "transport" /;

PARAMETER ms0(yr,i,m)	"Margin supply";
PARAMETER md0(yr,m,i)	"Margin demand";
PARAMETER s0(yr,i) "Aggregate supply";
PARAMETER d0(yr,i) "Sales in the domestic market";
PARAMETER a0(yr,i) "Armington supply";
PARAMETER bopdef(yr) "Balance of payments deficit";

bopdef(yr) = 0;
s0(yr,j) = sum(i,ys0(yr,i,j));
ms0(yr,i,"trd") = max(-mrg0(yr,i),0);
ms0(yr,i,'trn') = max(-trn0(yr,i),0);
md0(yr,"trd",i) = max(mrg0(yr,i),0);
md0(yr,'trn',i) = max(trn0(yr,i),0);

* Move household supply of recycled goods into the domestic output market
* from which some may be exported. Net out margin supply from output.

fs0(yr,i) = -min(0, fd0(yr,i,'pce'));
y0(yr,i) = sum(j,ys0(yr,j,i)) + fs0(yr,i) - sum(m,ms0(yr,i,m));

PARAMETER details "Check on accounting identities";

details(yr,i,"y0") = y0(yr,i);
details(yr,i,"m0") = m0(yr,i) + duty0(yr,i);
details(yr,i,"mrg+trn") = mrg0(yr,i) + trn0(yr,i);
details(yr,i,"tax-sbd") = tax0(yr,i)-sbd0(yr,i);
details(yr,i,'id0') = sum(j, id0(yr,i,j));
details(yr,i,"fd0") = sum(fd,fd0(yr,i,fd));
details(yr,i,"x0") = x0(yr,i);
details(yr,i,"balance") = y0(yr,i)+m0(yr,i)+duty0(yr,i) + tax0(yr,i)-sbd0(yr,i)
	- sum(j, id0(yr,i,j)) - sum(fd,fd0(yr,i,fd)) - x0(yr,i)
		+ (mrg0(yr,i) + trn0(yr,i));
DISPLAY details;

SET xfd(fd) "Exogenous components of final demand";

xfd(fd) = yes$(NOT SAMEAS(fd,'pce'));

a0(yr,i) = sum(fd, fd0(yr,i,fd)) + sum(j, id0(yr,i,j));

* Verify that goods that which only produce margins have zero entries
* elsewhere:

* Remove commodity taxes and subsidies on the goods which are produced solely
* for supplying retail sales margin:

SET imrg(i) "Goods which only generate margins" /
	mvt	"Motor vehicle and parts dealers (441)"
	fbt	"Food and beverage stores (445)"
	gmt	"General merchandise stores (452)" /;

PARAMETER imrginfo "Report of margin producing sectors";

imrginfo(yr,"a0",imrg) = a0(yr,imrg);
imrginfo(yr,"tax0",imrg) = tax0(yr,imrg);
imrginfo(yr,"sbd0",imrg) = sbd0(yr,imrg);
imrginfo(yr,"y0",imrg) = y0(yr,imrg);
imrginfo(yr,"x0",imrg) = x0(yr,imrg);
imrginfo(yr,"m0",imrg) = m0(yr,imrg);
imrginfo(yr,"duty0",imrg) = duty0(yr,imrg);
imrginfo(yr,m,imrg) = md0(yr,m,imrg);
DISPLAY imrginfo;

y0(yr,imrg) = 0;
a0(yr,imrg) = 0;
tax0(yr,imrg) = 0;
sbd0(yr,imrg) = 0;
x0(yr,imrg) = 0;
m0(yr,imrg) = 0;
md0(yr,m,imrg) = 0;
duty0(yr,imrg) = 0;

PARAMETER ta0(yr,i) "Tax net subsidy rate on intermediate demand";
PARAMETER tm0(yr,i)	"Import tariff";

* tm0(yr,i)$duty0(yr,i) = duty0(yr,i)/m0(yr,i);
* there could be an error in the BEA Supply Table data here... need to include extra logic to avoid a divide by zero error because of this BEA problem
tm0(yr,i)$(duty0(yr,i) AND m0(yr,i) > 0) = duty0(yr,i)/m0(yr,i);
ta0(yr,i)$(tax0(yr,i)-sbd0(yr,i)) = (tax0(yr,i) - sbd0(yr,i))/a0(yr,i);

* -------------------------------------------------------------------
* 	Output non-calibrated parameters:
* -------------------------------------------------------------------

EXECUTE_UNLOAD 'gdx%sep%national_cgeparm_raw.gdx' y0,ys0,fs0,id0,fd0,
    va0,ts0,m0,x0,mrg0,trn0,duty0,sbd0,tax0,ms0,md0,s0,a0,bopdef,ta0,tm0,
    yr,i,va,fd,ts,m;
