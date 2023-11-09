*	Read the data:

$if not set ds $set ds 43

$if not defined y_ $include %system.fp%gtapwindc_data

option sf:0:0:1;
display sf;

parameter	landuse(s,*)	Land inputs;
landuse(s,g) = vfm("lnd",g,"usa",s);
display landuse;

landuse(s,"total") = sum(g,landuse(s,g));
landuse(s,g)$(not sameas(g,"oap")) = 0;
landuse(s,"oap%")$landuse(s,"total") = 100 * landuse(s,"oap")/landuse(s,"total");
display landuse;

$exit

set	lt	Land type / 
		pas	Pasture, 
		frs	Forest, 
		crp	Crop land /;

set	ltmap(g,lt) Mapping from ag sector to land type /
	pdr.crp,
	wht.crp,
	gro.crp,
	v_f.crp,
	osd.crp,
	c_b.crp,
	pfb.crp,
	ocr.crp,
	ctl.pst,
	oap.pst,
	rmk.crp		Raw milk,
	wol.pst		Wool 
	frs.frt  /


parameter
	etrn_lnd	Elasticity of transformation across land types /0.4/
	etrn_pst	Elasticity of transformation across pasture uses /2/
	etrn_crp	Elasticity of transformation across crop uses /2/,
	etrn_frst	Elasticity of transformation across forest uses /2/
	evom_lnd(r,s,g)	Value of benchmark land use by sector;


$prod:LNDUSE(r,s)  t:etrn_lnd  pst(t):etrn_pst crp(t):etrn_crp  frs(t):etrn_frs
	o:PLND(r,s,g)	q:vfm("lnd",g,r,s)  crp:$ltmap(g,"crp") pst:$ltmap(g,"pst") frs:$ltmap(g,"frs")
	i:PK("lnd",r)	q:evom("lnd",r,s)