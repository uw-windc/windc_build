$title	Determine Row Hierarchy for the SAPCE Dataset

set	seq /0*1000/;

*	Which dataset?  (1, 2, 3 or 4)

$if not set ds  $set ds 4

*	Where do we read the set of sector

$if %ds%==1 $set n 25
$if %ds%==2 $set n 25
$if %ds%==3 $set n 114
$if %ds%==4 $set n 135

$set s		g2..g%n%
$set lno	e1..e%n%
$set lno_s	e1..g%n%

$set file SAPCE%ds%__ALL_AREAS_1997_2022

$call gdxxrw i=%file%.csv o=%gams.scrdir%s.gdx     set=s     rng=%s%			  rdim=1 cdim=0 trimleft=n 
$call gdxxrw i=%file%.csv o=%gams.scrdir%lno.gdx   set=lno   rng=%lno%   ignorecolumns=f  rdim=1 cdim=0 trimleft=n 
$call gdxxrw i=%file%.csv o=%gams.scrdir%lno_s.gdx set=lno_s rng=%lno_s% ignorecolumns=f  rdim=2 cdim=0 trimleft=n 

set	s(*);
$gdxin %gams.scrdir%s.gdx
$load s

option s:0:0:1;
display s;

set	lno(*)	Line numbers;
$gdxin %gams.scrdir%lno.gdx
$load lno

set	lno_s(lno,s) Line number-sector mapping;
$gdxin %gams.scrdir%lno_s.gdx
$load lno_s


set	L /0*6/;
set	k /1*10/;  
alias (k,kk);


set	a(s,L)	Number of leading blanks;
a(s,L)$(ord(s.tl,1)=ord(" ",1))
  = yes$(L.val = smax(k$(sum(kk$(kk.val<=k.val),1$(ord(s.tl,kk.val)=ord(" ",1)))=k.val),k.val));
a(s,"0") = yes$(ord(s.tl,1)<>ord(" ",1));

alias (i,j,s);

set	lvl(L)	Level /1/
	iL(i,L)	Level mapping id,
	m(i,j)	Mapping;

iL(i,"0") = yes$(ord(i)=1);

m(i,j) = no;
loop(lno,
  loop(lno_s(lno,i),
	loop(a(i,L),
	  loop(iL(j,L-1), m(j,i) = s(i););
	  iL(j,L) = yes$sameas(i,j);
	);
));
option m:0:0:1;
display m;


alias (lno,Li,Lj), (lno_s,imap,jmap);

set	Lm(Li,Lj);
loop((imap(Li,i),jmap(Lj,j)), Lm(Li,Lj)$m(i,j) = lno(Lj); );
option Lm:0:0:1;
display Lm;
