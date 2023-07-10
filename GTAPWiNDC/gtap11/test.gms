set	g /g1*g3/, r/a,b/;

set	y(g,r), p(g,r);
y(g,r) = yes; 
p(g,r) = yes;

parameter	test;
test(g,r) = sum((y(g,r),p(g,r)),ord(g));
display test;

test(g,r) = sum((y(g.local,r),p(g,r)),ord(g));
display test;

*	Not sure why the following does not terminate with an error message:

test(g,r) = sum((y(g.local,r),p(g.local,r)),ord(g));
display test;

