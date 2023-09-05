$title	Aggregate the Census port-district international trade data to a GTAPinGAMS mapping

$if not set imap $set imap 43

*	Read the data:

Sets	s(*)	Subregions (states),
	i(*)	GTAP goods;

$gdxin ..\GTAPWiNDC\gtap11\2017\gtapingams.gdx
$load i

$gdxin ..\core\WiNDCdatabase.gdx
$load s = r

Parameters
	node_exp(s,i),
	node_imp(s,i);

$gdxin "trade_data\node_trade.gdx"
$loaddc node_exp node_imp

*	Read the GTAPinGAMS mapping:

$batinclude ..\GTAPWiNDC\gtap11\mappings.gms windc_%imap%

Parameter 
	node_exp_(s,ii) aggregated nodal exports,
	node_imp_(s,ii) aggregated nodal imports;

node_exp_(s,ii) = sum(mapi(i,ii),node_exp(s,i));
node_imp_(s,ii) = sum(mapi(i,ii),node_imp(s,i));

execute_unload 'trade_data\node_trade_%imap%.gdx', 
	node_imp_=node_imp, 
	node_exp_=node_exp;
