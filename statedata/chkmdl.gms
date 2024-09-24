loop(yc,
	yb(yc) = yes;
	ED.L(g)$vx0(yb,g) = 1;
	y_(yc,r,s) = yes$ys0_(yc,r,s)$rs(r);
	pa_(yc,r,g) = a0(yc,r,g)$rs(r);
	ra_(r) = rs(r);

$include symmetric.gen
	solve symmetric using mcp;
);

$exit

*	We have some problems with the calibration.  Quick and dirty fix:

	id0_(yc,r,g,s)$(not pa_(yc,r,g)) = 0;
	x0(yc,r,g)$(not y_(yc,r,g)) = 0;
	rx0(yc,r,g)$(not y_(yc,r,g)) = 0;
	ns0(yc,r,g)$(not y_(yc,r,g)) = 0;
	ms0(yc,r,g,mrg)$(not y_(yc,r,g)) = 0;
	fd0(yc,r,g,xd)$(not pa_(yc,r,g)) = 0;
	yd0(yc,r,g)$(not y_(yc,r,g)) = 0;
	cd0(yc,r,g)$(not y_(yc,r,g)) = 0;

