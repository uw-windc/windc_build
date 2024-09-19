$title	Compare Tax Rates

$include beadata

parameter
	ty0_io(yr,r,s)	Output tax rate
	tm0_io(yr,r,g)	Import tariff
	ta0_io(yr,r,g)	Product tax;

$gdxin %system.fp%data\iogebalanced.gdx
$loaddc ty0_io=ty0 tm0_io=tm0 ta0_io=ta0

parameter	pivotdata	Comparison of tax rates;
pivotdata("ty","ge",yr,r,s) = ty0(yr,r,s);
pivotdata("ty","io",yr,r,s) = ty0_io(yr,r,s);

pivotdata("tm","ge",yr,r,g) = tm0(yr,r,g);
pivotdata("tm","io",yr,r,g) = tm0_io(yr,r,g);

pivotdata("ta","ge",yr,r,g) = ta0(yr,r,g);
pivotdata("ta","io",yr,r,g) = ta0_io(yr,r,g);
execute_unload 'taxcompare.gdx', pivotdata;
execute 'gdxxrw i=taxcompare.gdx o=taxcompare.xlsx par=pivotdata rng=PivotData!a2 cdim=0 intastext=n';
