$stitle	Aggregate Regions and Commodities to Minimal Size

set r_  Regions in the aggregation /
	USA	United States
	ROW	Rest of world /;

set mapr(r,r_) /
	ARG.ROW	Argentina
	ANZ.ROW	Australia and New Zealand
	BRA.ROW	Brazil
	CAN.ROW	Canada
	CHN.ROW	China and Hong Kong
	FRA.ROW	France
	DEU.ROW	Germany
	IND.ROW	India
	IDN.ROW	Indonesia
	ITA.ROW	Italy
	JPN.ROW	Japan
	MEX.ROW	Mexico
	RUS.ROW	Russia
	SAU.ROW	Saudi Arabia
	ZAF.ROW	South Africa
	KOR.ROW	Korea
	TUR.ROW	Turkey
	GBR.ROW	United Kingdom
	USA.USA	United States
	REU.ROW	Rest of European Union (excluding FRA - DEU - GBR - ITA)
	OEX.ROW	Other oil exporters
	LIC.ROW	Other low-income countries
	MIC.ROW	Other middle-income countries/;

alias (rr,rr_),(mapr,maprr);

set aggregate_sectors	Sectors in the aggregation /
	oxt  "Coal, minining and supporting activities",
	tex  "Textiles",
	lum  "Lumber and wood products",
	ppp  "Paper products, publishing",
	oil  "Petroleum, coal products",
	nmm  "Mineral products nec",
	fmp  "Metal products",
	eeq  "Electronic equipment",
	ome  "Machinery and equipment nec",
	mvh  "Motor vehicles and parts",
	otn  "Transport equipment nec",
	omf  "Manufactures nec",

	aog  "All other goods" /

set	g_(*) /set.aggregate_sectors, G, I/
	i_(g_) /set.aggregate_sectors/;

set	mapi(i,i_)	Sectoral mapping /
	oxt.oxt  "Coal, minining and supporting activities",
	tex.tex  "Textiles",
	lum.lum  "Lumber and wood products",
	ppp.ppp  "Paper products, publishing",
	oil.oil  "Petroleum, coal products",
	nmm.nmm  "Mineral products nec",
	fmp.fmp  "Metal products",
	eeq.eeq  "Electronic equipment",
	ome.ome  "Machinery and equipment nec",
	mvh.mvh  "Motor vehicles and parts",
	otn.otn  "Transport equipment nec",
	omf.omf  "Manufactures nec" /;

mapi(i,"aog")= yes$(not sum(mapi(i,i_),1))

set	mapg(g,g_) /G.G, I.I/;
mapg(mapi) = yes;


alias (i_,j_), (mapi,mapj);

