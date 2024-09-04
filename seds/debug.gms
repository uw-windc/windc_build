set t   /
202212,    202211,    202210,    202209,    202208,    202207,    202206,    202205,    202204,    202203,    202202,    202201,    202112,    202111,    202110
202109,    202108,    202107,    202106,    202105,    202104,    202103,    202102,    202101,    202012,    202011,    202010,    202009,    202008,    202007
202006,    202005,    202004,    202003,    202002,    202001,    201912,    201911,    201910,    201909,    201908,    201907,    201906,    201905,    201904
201903,    201902,    201901,    201812,    201811,    201810,    201809,    201808,    201807,    201806,    201805,    201712,    201711,    201710,    201709
201708,    201707,    201706,    201705,    201704,    201703,    201702,    201701,    201804,    201803,    201802,    201801,    201612,    201611,    201610
201609,    201608,    201607,    201606,    201605,    201604,    201603,    201602,    201601,    202405,    202404,    202403,    202402,    202401,    202312
202311,    202310,    202309,    202308,    202307,    202306,    202305,    202304,    202303,    202302,    202301,    201512,    201511,    201510,    201509
201508,    201507,    201307,    201306,    201305,    201304,    201303,    201302,    201301,    201212,    201211,    201210,    201209,    201208,    201207
201206,    201205,    201204,    201203,    201202,    201201,    201112,    201111,    201110,    201109,    201108,    201107,    201106,    201105,    201104
201103,    201102,    201101,    201012,    201011,    201010,    201009,    201008,    201007,    201006,    201005,    201004,    201003,    201002,    201001
200912,    200911,    200910,    200909,    200908,    200907,    200906,    200905,    200904,    200903,    200902,    200901,    200812,    200811,    200810
200809,    200808,    200807,    200806,    200805,    200804,    200803,    200802,    200801,    200712,    200711,    200710,    200709,    200708,    200707
200706,    200705,    200704,    200703,    200702,    200701,    200612,    200611,    200610,    200609,    200608,    200607,    200606,    200605,    200604
200603,    200602,    200601,    200412,    200411,    200410,    200409,    200408,    200407,    200406,    200405,    200404,    200403,    200402,    200401
200312,    200311,    200310,    200309,    200308,    200307,    200306,    200305,    200304,    200303,    200302,    200301,    200212,    200211,    200210
200209,    200208,    200207,    200206,    200205,    200204,    200203,    200202,    200201,    200112,    200111,    200110,    200109,    200108,    200107
200106,    200105,    200104,    200103,    200102,    200101,    201506,    201505,    201504,    201503,    201502,    201501,    201412,    201411,    201410
201409,    201408,    201407,    201406,    201405,    201404,    201403,    201402,    201401,    201312,    201311,    201310,    201309,    201308,    200512
200511,    200510,    200509,    200508,    200507,    200506,    200505,    200504,    200503,    200502,    200501,    2015Q1,    2014Q4,    2014Q3,    2014Q2
2014Q1,    2013Q4,    2013Q3,    2013Q2,    2013Q1,    2012Q4,    2012Q3,    2012Q2,    2012Q1,    2011Q4,    2011Q3,    2011Q2,    2011Q1,    2010Q4,    2010Q3
2010Q2,    2010Q1,    2009Q4,    2009Q3,    2009Q2,    2009Q1,    2008Q4,    2008Q3,    2008Q2,    2008Q1,    2022Q4,    2022Q3,    2022Q2,    2022Q1,    2021Q4
2021Q3,    2021Q2,    2021Q1,    2020Q4,    2020Q3,    2020Q1,    2019Q4,    2019Q3,    2019Q1,    2018Q4,    2018Q3,    2018Q2,    2018Q1,    2017Q4,    2017Q3
2017Q2,    2017Q1,    2016Q4,    2016Q3,    2016Q2,    2016Q1,    2015Q4,    2015Q3,    2015Q2,    2007Q4,    2007Q3,    2007Q1,    2006Q4,    2006Q3,    2006Q2
2006Q1,    2005Q4,    2005Q3,    2005Q2,    2005Q1,    2003Q4,    2003Q3,    2003Q2,    2003Q1,    2002Q4,    2002Q3,    2002Q1,    2001Q4,    2001Q3,    2001Q2
2001Q1,    2020Q2,    2019Q2,    2007Q2,    2004Q4,    2004Q3,    2004Q2,    2004Q1,    2002Q2,    2024Q1,    2023Q4,    2023Q3,    2023Q2,    2023Q1,    2023  
2022  ,    2021  ,    2020  ,    2019  ,    2018  ,    2017  ,    2016  ,    2015  ,    2014  ,    2013  ,    2012  ,    2011  ,    2010  ,    2009  ,    2008  
2007  ,    2006  ,    2005  ,    2004  ,    2003  ,    2002  ,    2001  /;

set	m	Month  /01*12/
	q	Quarter /q1*q4/,
	yr	Year /2001*2023/;

set	tyrm(t,yr,m)	Mapping of time records corresponding to months, 
	tyrq(t,yr,q)	Mapping of time records corresponding to quarters;

tyrm(t,yr,m) =  ord(t.tl,1)=ord(yr.tl,1) and
		ord(t.tl,2)=ord(yr.tl,2) and
		ord(t.tl,3)=ord(yr.tl,3) and
		ord(t.tl,4)=ord(yr.tl,4) and
		ord(t.tl,5)=ord(m.tl,1) and
		ord(t.tl,6)=ord(m.tl,2);

tyrq(t,yr,q) =  ord(t.tl,1)=ord(yr.tl,1) and
		ord(t.tl,2)=ord(yr.tl,2) and
		ord(t.tl,3)=ord(yr.tl,3) and
		ord(t.tl,4)=ord(yr.tl,4) and
		ord(t.tl,5)=ord("Q",1) and
		ord(t.tl,6)=ord(q.tl,2);
option tyrm:0:0:1, tyrq:0:0:1;
display tyrm, tyrq;
