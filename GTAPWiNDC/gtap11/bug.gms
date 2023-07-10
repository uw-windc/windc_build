$title	Multiple Set References with .local -- not good.

set	i/1*3/,
	r/a,b/;

set	j(i,r);

j(i,r) = yes;

parameter	test;
test("global,global") = sum((i,j(i,r)), 1);
test("local,global")  = sum((i.local,j(i,r)), 1);

*	This should generate a compile-time error?  Not 

test("global,local")  = sum((i,j(i.local,r)), 1);

*	This should also generate an error message?

test("local,local")   = sum((i.local,j(i.local,r)), 1);
display test;

parameter	n /0/;

set	c /1*100/;

parameter	iterlog		Iteration log;

parameter	passes(i)	Number of passes;

passes(i) = 0;

loop(c$sameas(c,"1"),
  n = 0;
  loop((i.local,j(i.local,r)),
	passes(i) = passes(i) + 1;
	iterlog(c+n,i,j) = i.val;
	n = n + 1;
));

option iterlog:0:0:1, passes:0:0:1;
display iterlog, passes;
