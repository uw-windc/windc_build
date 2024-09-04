set	i(*);

parameter	a(i<) /i1 0.2, i2 1.5/;

set	j(i) /
		i1	My first element,
		i2	My second element /;

i(i) = j(i);
