
set	mtype /symm, suse/;

parameter atmval(*,*);
$gdxin 'atmalt.gdx'
$loaddc atmval

parameter	atmval_, atmpy;
$gdxin 'atmval.gdx'
$loaddc atmval_=atmval atmpy

parameter	atm;
alias (g,*);
atm(g,"PE","symm_iter") = atmval(g,"symm_iter");
atm(g,"PY","symm_iter") = atmval(g,"V_py");
atm(g,"PE",mtype) = atmval_(g,mtype);
atm(g,"PY",mtype) = atmpy(g,mtype);


execute_unload 'atm.gdx',atm;
execute 'gdxxrw i=atm.gdx o=atm.xlsx par=atm rng=PivotData!a2 cdim=0';
