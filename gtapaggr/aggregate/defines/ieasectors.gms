*	Define an aggregation of GTAPinGAMS consistent with IEA


set	ii	Goods in the IEA classification /
	GAS	Natural gas works,
	ELE	Electricity and heat ,
	OIL	Refined oil products,
	COL	Coal transformation,
	CRU	Crude oil,

	I_S	Iron and steel industry (IRONSTL),
	CHM	Chemical industry (CHEMICAL),
	NFM	Non-ferrous metals (NONFERR),
	NMM	Non-metallic minerals (NONMET),
	OMN	Mining (MINING),
	TEQ	Transport equipment (TRANSEQ),
	OME	Other machinery (MACHINE),
	FPR	Food products (FOODPRO),
	PPP	Paper-pulp-print (PAPERPRO),
	LUM	Wood and wood-products (WOODPRO),
	CNS	Construction (CONSTRUC),
	TWL	Textiles-wearing apparel-leather (TEXTILES),
	OMF	Other manufacturing (INONSPEC),

	AGR	Agricultural products,
	TRN	Transport,
	ATP	Air transport,
	SER	Commercial and public services,
	DWE	Dwellings/;


alias (ui,*);

set mapi(ui,ii)  Mapping for sectors and goods (covers all regions of GTAPinGAMS) /

	(GAS,GDT).GAS				Natural gas works
	ELE.ELE					Electricity and heat 
	OIL.OIL					Refined oil products
	COL.COL					Coal transformation
	CRU.CRU					Crude oil

	I_S.I_S					Iron and steel industry (IRONSTL)
	(CRP,CHM,BPH,RPP).CHM			Chemical industry (CHEMICAL)
	NFM.NFM					Non-ferrous metals (NONFERR)
	NMM.NMM					Non-metallic minerals (NONMET)
	(OXT,OMN).OMN				Mining (MINING)
	(MVH,OTN).TEQ				Transport equipment (TRANSEQ)
	(OME).OME				Other machinery (MACHINE)
	(OMT,VOL,MIL,PCR,SGR,OFD,B_T,CMT).FPR	Food products (FOODPRO)
	PPP.PPP					Paper-pulp-print (PAPERPRO)
	LUM.LUM					Wood and wood-products (WOODPRO)
	CNS.CNS					Construction (CONSTRUC)
	(TEX,WAP,LEA).TWL			Textiles-wearing apparel-leather (TEXTILES)
	(CEO,EEQ,FMP,OMF).OMF			Other manufacturing (INONSPEC)
	(PDR,WHT,GRO,V_F,OSD,C_B,PFB,OCR,
	     CTL,OAP,RMK,WOL,FRS,FSH).AGR	Agricultural products
	(WHS,OTP,WTP).TRN			Transport
	ATP.ATP					Air transport
	(AFS,TRD,OFI,INS,ISR,RSA,OBS,WTR,CMN,ROS,EDU,HHT,OSG).SER   Commercial and public services
	DWE.DWE				Dwellings
	/;

*	We define mappings for commodities in all GTAP versions.  
*	Remove those which are not in the current dataset.


set	noti(ui)	Labels which are not in i;
option noti<mapi;
noti(i) = no;

mapi(noti,ii) = no;

abort$(card(mapi)<>card(i))	"Error: card(mapi)<>card(i).";
