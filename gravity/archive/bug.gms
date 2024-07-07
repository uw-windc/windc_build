set	r /r1*r3/,
	r_/a,b/;

set	mapr(r,r_) /r1.a, (r2,r3).b/;

alias (r,rr), (r_,rr_), (mapr,maprr);

parameter	v(r,rr);
v(r,rr) = uniform(0,1);

parameter	v_(r_,rr_);
v_(r_,rr_) = sum((mapr(r,r_),maprr(rr,rr_)),v(r,rr));
display v_;