$goto bgravity

$if not dexist datasets     $call mkdir datasets
$if not dexist datasets\a   $call mkdir datasets\a
$if not dexist datasets\b   $call mkdir datasets\b
$if not dexist datasets\lst $call mkdir lst
*.$if not dexist datasets\a\bases $call mkdir bases

$call gams economy	o=lst\economy.lst
$call gams geography	o=lst\geography.lst

$label agravity

$log	Running a_alt
$call gams agravity --ds=alt o=lst\a_alt.lst
$log	Running a_c_b
$call gams agravity --ds=c_b o=lst\a_c_b.lst
$log	Running a_CRP
$call gams agravity --ds=CRP o=lst\a_CRP.lst
$log	Running a_ctl
$call gams agravity --ds=ctl o=lst\a_ctl.lst
$log	Running a_eeq
$call gams agravity --ds=eeq o=lst\a_eeq.lst
$log	Running a_fbp
$call gams agravity --ds=fbp o=lst\a_fbp.lst
$log	Running a_fmp
$call gams agravity --ds=fmp o=lst\a_fmp.lst
$log	Running a_fof
$call gams agravity --ds=fof o=lst\a_fof.lst
$log	Running a_gro
$call gams agravity --ds=gro o=lst\a_gro.lst
$log	Running a_lum
$call gams agravity --ds=lum o=lst\a_lum.lst
$log	Running a_mvh
$call gams agravity --ds=mvh o=lst\a_nmm.lst
$log	Running a_nmm
$call gams agravity --ds=nmm o=lst\a_nmm.lst
$log	Running a_oap
$call gams agravity --ds=oap o=lst\a_oap.lst
$log	Running a_ocr
$call gams agravity --ds=ocr o=lst\a_ocr.lst
$log	Running a_ogs
$call gams agravity --ds=ogs o=lst\a_ogs.lst
$log	Running a_oil
$call gams agravity --ds=oil o=lst\a_oil.lst
$log	Running a_ome
$call gams agravity --ds=ome o=lst\a_ome.lst
$log	Running a_omf
$call gams agravity --ds=omf o=lst\a_omf.lst
$log	Running a_osd
$call gams agravity --ds=osd o=lst\a_osd.lst
$log	Running a_otn
$call gams agravity --ds=otn o=lst\a_otn.lst
$log	Running a_oxt
$call gams agravity --ds=oxt o=lst\a_oxt.lst
$log	Running a_pdr
$call gams agravity --ds=pdr o=lst\a_pdr.lst
$log	Running a_pfb
$call gams agravity --ds=pfb o=lst\a_pfb.lst
$log	Running a_pmt
$call gams agravity --ds=pmt o=lst\a_pmt.lst
$log	Running a_ppp
$call gams agravity --ds=ppp o=lst\a_ppp.lst
$log	Running a_rmk
$call gams agravity --ds=rmk o=lst\a_rmk.lst
$log	Running a_tex
$call gams agravity --ds=tex o=lst\a_tex.lst
$log	Running a_uti
$call gams agravity --ds=uti o=lst\a_uti.lst
$log	Running a_v_f
$call gams agravity --ds=v_f o=lst\a_v_f.lst
$log	Running a_wht
$call gams agravity --ds=wht o=lst\a_wht.lst
$log	Running a_wol
$call gams agravity --ds=wol o=lst\a_wol.lst


$label bgravity

$log	Running b_alt
$call gams bgravity --ds=alt o=lst\b_alt.lst
$log	Running b_c_b
$call gams bgravity --ds=c_b o=lst\b_c_b.lst
$log	Running b_CRP
$call gams bgravity --ds=CRP o=lst\b_CRP.lst
$log	Running b_ctl
$call gams bgravity --ds=ctl o=lst\b_ctl.lst
$log	Running b_eeq
$call gams bgravity --ds=eeq o=lst\b_eeq.lst
$log	Running b_fbp
$call gams bgravity --ds=fbp o=lst\b_fbp.lst
$log	Running b_fmp
$call gams bgravity --ds=fmp o=lst\b_fmp.lst
$log	Running b_fof
$call gams bgravity --ds=fof o=lst\b_fof.lst
$log	Running b_gro
$call gams bgravity --ds=gro o=lst\b_gro.lst
$log	Running b_lum
$call gams bgravity --ds=lum o=lst\b_lum.lst
$log	Running b_mvh
$call gams bgravity --ds=mvh o=lst\b_nmm.lst
$log	Running b_nmm
$call gams bgravity --ds=nmm o=lst\b_nmm.lst
$log	Running b_oap
$call gams bgravity --ds=oap o=lst\b_oap.lst
$log	Running b_ocr
$call gams bgravity --ds=ocr o=lst\b_ocr.lst
$log	Running b_ogs
$call gams bgravity --ds=ogs o=lst\b_ogs.lst
$log	Running b_oil
$call gams bgravity --ds=oil o=lst\b_oil.lst
$log	Running b_ome
$call gams bgravity --ds=ome o=lst\b_ome.lst
$log	Running b_omf
$call gams bgravity --ds=omf o=lst\b_omf.lst
$log	Running b_osd
$call gams bgravity --ds=osd o=lst\b_osd.lst
$log	Running b_otn
$call gams bgravity --ds=otn o=lst\b_otn.lst
$log	Running b_oxt
$call gams bgravity --ds=oxt o=lst\b_oxt.lst
$log	Running b_pdr
$call gams bgravity --ds=pdr o=lst\b_pdr.lst
$log	Running b_pfb
$call gams bgravity --ds=pfb o=lst\b_pfb.lst
$log	Running b_pmt
$call gams bgravity --ds=pmt o=lst\b_pmt.lst
$log	Running b_ppp
$call gams bgravity --ds=ppp o=lst\b_ppp.lst
$log	Running b_rmk
$call gams bgravity --ds=rmk o=lst\b_rmk.lst
$log	Running b_tex
$call gams bgravity --ds=tex o=lst\b_tex.lst
$log	Running b_uti
$call gams bgravity --ds=uti o=lst\b_uti.lst
$log	Running b_v_f
$call gams bgravity --ds=v_f o=lst\b_v_f.lst
$log	Running b_wht
$call gams bgravity --ds=wht o=lst\b_wht.lst
$log	Running b_wol
$call gams bgravity --ds=wol o=lst\b_wol.lst

$exit

