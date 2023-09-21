*------------
*~NB(ejb): The following change should probably be imposed upstream to 
* avoid the user thinking there is useful info here?

*	For USA states the information in xd0(i,r,s) is not reliable.
*	This supposidly indicates the local absorbtion of locally 
*	produced goods.  There are some values here, but at least 
*	for the ag goods these seem to be artifacts of the 
*	balancing---not informed by data.

*	For r not USA we already have zeros in these accounts.

loop(bst_(i),
*	The change is to force everything through the national market
nd0(i,r,s) = nd0(i,r,s)+xd0(i,r,s);
xn0(i,r,s) = xn0(i,r,s)+xd0(i,r,s);
xd0(i,r,s) = 0;
*	This eliminates the need for PD in the initial 
*	model where we do not have bilateral state trade
pd_(i,r,s) = no;
);

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Calibration failure";
*------------

*------------
*	First pass let each state export to foreign mkts
*	according to production shares:

Parameter 
	theta_s(i,r,s) State share of national production;

loop((bst_(i),usa(r)),

	theta_s(i,r,s)$y_(i,r,s) = vom(i,r,s)/sum(s.local,vom(i,r,s)); 
	xn0(i,r,s) = vom(i,r,s)/sum(s.local,vom(i,r,s)) * (sum(rr,vxmd(i,r,rr))+vst(i,r));

*	First pass let each state absorb domestic goods 
*	according to source production shares:

	bst0(i,r,ss,s) = theta_s(i,r,ss)*(nd0(i,r,s)+xd0(i,r,s));
	nd0(i,r,s) = 0;
	xd0(i,r,s) = 0;
);

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Calibration failure";
*------------

*	Switch over to a model with internation trade from nodes

parameter 
	node_exp(s,i) international exports from node s,
	node_imp(s,i) international imports from node s;

*	Bring in the nodal export data
$gdxin "trade_data\node_trade_43.gdx"
$loaddc node_exp node_imp

*	Discrepancy between GTAP and Census US trade accounts:
*		Turns out these are very small
Parameter tradechk(r,i,*,*);

loop((bst_(i),usa(r)),
tradechk(r,i,"exp","gtap") = sum(s,xn0(i,r,s));
tradechk(r,i,"exp","census") = sum(s,node_exp(s,i));
tradechk(r,i,"exp","dif")    = sum(s,node_exp(s,i))-sum(s,xn0(i,r,s));
tradechk(r,i,"exp","%")      = 100*(sum(s,node_exp(s,i))/sum(s,xn0(i,r,s)) - 1);
);

display tradechk;

Parameter 
	nodeXshr(i,r,s) Share of r exports from node s,
	nodeMshr(i,r,s) Share of r imports from node s;

*Some accounts may not have HS data (e.g., raw milk).  For these we set a
*	default geographic-central node of MO=Missouri.

nodeXshr(i,"usa","MO") = 1;  
nodeMshr(i,"usa","MO") = 1;  

*	Reassign base on the data:
nodeXshr(i,"usa",s)$sum(ss,node_exp(ss,i)) = node_exp(s,i)/sum(ss,node_exp(ss,i));
nodeMshr(i,"usa",s)$sum(ss,node_imp(ss,i)) = node_imp(s,i)/sum(ss,node_imp(ss,i));

*	Recalibrate with nodal export logic
loop((bst_(i),usa(r)),

	nnx0(i,r,s) = nodeXshr(i,r,s)*sum(ss,xn0(i,r,ss));

*	Again (pre gravity estimation) just use production shares to 
*	fill the accounts.

	xnn0(i,r,s,ss) = theta_s(i,r,s)*nnx0(i,r,ss);
	nx_(i,r,s) = yes$nnx0(i,r,s);
	x_(i,r,s) = no;

);

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Calibration failure with nodal export logic";

*	Recalibrate with nodal import logic
loop((bst_(i),usa(r)),

	Nvim0(i,r,s) = nodeMshr(i,r,s)*vim(i,r);

*	Pre gravity estimation distribute import absorption based on 
*	nodal shares

	Nmd0(i,r,s,ss) = nodeMshr(i,r,s)*md0(i,r,ss);
	nm_(i,r) = yes$sum(s,Nvim0(i,r,s));
	pnm_(i,r,s) = yes$Nvim0(i,r,s);
	md0(i,r,s) = 0;
);

$include gtapwindc.gen
solve gtapwindc using mcp;
Abort$(gtapwindc.objval > 1e-4) "Calibration failure with nodal import logic";
