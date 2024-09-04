$title	Read the EBA Dataset (U.S. Electricity System Operating Data)

set	yr /2018*2024/, month /01*12/, day /01*31/, hr /00*23/, suffix/04*08/;

$if not exist EBA.gdx $call gams readbulk --dataset=EBA

$gdxin 'EBA.gdx'

set
  t  'date/year'
  id 'series_id from txt file, explanatory text has name'
  e  'error strings where we have for NA (not available)'
  errors(id,t,e<) 'could not extract a value from these';

parameter
   series(id,t<) 'data for each series';

$load id 
$loaddc series errors

option id:0:0:1;
display id;

option t:0:0:15;
display t;

*	Read mappings;

$include ebamap

set	yrmap(t,yr), monthmap(t,month), daymap(t,day), hrmap(t,hr),
	tmap(t,yr,month,day,hr), suffixmap(t,suffix);

suffixmap(t,suffix) = yes$((ord(t.tl,13)=ord(suffix.tl,1)) and (ord(t.tl,14)=ord(suffix.tl,2)));

set	ts(t); 
option ts<suffixmap;
option ts:0:0:8;
display ts;

set	id_t(id,t);
option id_t<series;
id_t(id,t)$(not ts(t)) = no;
option id_t:0:0:1;
display id_t;

$exit

set m(id,r,*,item);
m(short(ids,r,z,item)) = yes;
m(ngmap(ids,r,js),"ng") = yes;

option m:0:0:1
display m;

$exit


yrmap(t,yr) = ((ord(t.tl,1)=ord(yr.tl,1)) and 
		(ord(t.tl,2)=ord(yr.tl,2)) and 
		(ord(t.tl,3)=ord(yr.tl,3)) and 
		(ord(t.tl,4)=ord(yr.tl,4)) );

monthmap(t,month) = ((ord(t.tl,5)=ord(month.tl,1)) and 
		      (ord(t.tl,6)=ord(month.tl,2)) );

daymap(t,day) = ((ord(t.tl,7)=ord(day.tl,1)) and 
		  (ord(t.tl,8)=ord(day.tl,2)) );

hrmap(t,hr) = ((ord(t.tl,10)=ord(hr.tl,1)) and 
		(ord(t.tl,11)=ord(hr.tl,2)) );


set	nosuffixmap(t);
nosuffixmap(t) = not ts(t);
option nosuffixmap:0:0:1;
display nosuffixmap;

tmap(t,yr,month,day,hr) = yrmap(t,yr) and monthmap(t,month) and daymap(t,day) and hrmap(t,hr);

set	ymd(yr,month,day);
option ymd<tmap;

parameter	
	date			Date in serial , 
	dow(yr,month,day)	Day of the week;
loop(ymd(yr,month,day),
	date = Jdate(yr.val, month.val, day.val);
	dow(ymd) = Gdow(date);
);
option dow:0:0:1;
display dow;

parameter	woy(t)	Week of year,
		nw	Number of weeks;

loop(yr,
  nw=1;
  loop(month,
	loop(ymd(yr,month,day),
	  loop(tmap(t,ymd,hr),
	    woy(t) = nw;
	  );
	  nw$(dow(ymd)=7) = nw + 1;
	);
  );
);
option woy:0:0:1;
display woy;

