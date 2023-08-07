*	Unload the current year data:

ys0_('%year%',r,g,s) = ys0(r,g,s);
id0_('%year%',r,s,g) = id0(r,s,g);
ld0_('%year%',r,s) = ld0(r,s);
kd0_('%year%',r,s) = kd0(r,s);
ty0_('%year%',r,s) = ty0(r,s);
m0_('%year%',r,g) = m0(r,g);
x0_('%year%',r,g) = x0(r,g);
rx0_('%year%',r,g) = rx0(r,g);
md0_('%year%',r,m,gm) = md0(r,m,gm);
nm0_('%year%',r,gm,m) = nm0(r,gm,m);
dm0_('%year%',r,gm,m) = dm0(r,gm,m);
s0_('%year%',r,g) = s0(r,g);
a0_('%year%',r,g) = a0(r,g);
ta0_('%year%',r,g) = ta0(r,g);
tm0_('%year%',r,g) = tm0(r,g);
cd0_('%year%',r,g) = cd0(r,g);
c0_('%year%',r) = c0(r);
yh0_('%year%',r,g) = yh0(r,g);
bopdef0_('%year%',r) = bopdef0(r);
g0_('%year%',r,g) = g0(r,g);
i0_('%year%',r,g) = i0(r,g);
xn0_('%year%',r,g) = xn0(r,g);
xd0_('%year%',r,g) = xd0(r,g);
dd0_('%year%',r,g) = dd0(r,g);
nd0_('%year%',r,g) = nd0(r,g);
hhadj_('%year%',r) = hhadj(r);
pop_('%year%',r,h) = pop(r,h);
le0_('%year%',r,q,h) = le0(r,q,h);
ke0_('%year%',r,h) = ke0(r,h);
tk0_('%year%',r) = tk0(r);
tl0_('%year%',r,h) = tl0(r,h);
cd0_h_('%year%',r,g,h) = cd0_h(r,g,h);
c0_h_('%year%',r,h) = c0_h(r,h);
sav0_('%year%',r,h) = sav0(r,h);
hhtrn0_('%year%',r,h,trn) = hhtrn0(r,h,trn);
fsav0_("%year%") = fsav0;

$set dataset
* sets in WiNDC
set	yr_(yr) Years of IO data /%year%/;

execute_unload '%datafile%',yr_=yr, s, r, m, gm, h, trn,
