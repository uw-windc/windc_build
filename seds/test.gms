set	i /1*4/, j/a*d/;

file kcon /con:/; put kcon; kcon.lw=0;
loop((i,j),
	put i.tl, '.', j.tl/;
);