
$if not dexist datasets     $call mkdir datasets
$if not dexist datasets\a   $call mkdir datasets\a
$if not dexist datasets\b   $call mkdir datasets\b
$if not dexist datasets\lst $call mkdir lst
$if not dexist datasets\a\bases $call mkdir bases

$call gams economy	o=lst\economy.lst
$call gams geography	o=lst\geography.lst

$log	Running alt
$call gams gravity --ds=alt o=lst\alt.lst

$log	Running c_b
$call gams gravity --ds=c_b o=lst\c_b.lst
$log	Running CRP
$call gams gravity --ds=CRP o=lst\CRP.lst
$log	Running ctl
$call gams gravity --ds=ctl o=lst\ctl.lst
$log	Running eeq
$call gams gravity --ds=eeq o=lst\eeq.lst
$log	Running fbp
$call gams gravity --ds=fbp o=lst\fbp.lst
$log	Running fmp
$call gams gravity --ds=fmp o=lst\fmp.lst
$log	Running fof
$call gams gravity --ds=fof o=lst\fof.lst
$log	Running gro
$call gams gravity --ds=gro o=lst\gro.lst
$log	Running lum
$call gams gravity --ds=lum o=lst\lum.lst
$log	Running mvh
$call gams gravity --ds=mvh o=lst\nmm.lst
$log	Running nmm
$call gams gravity --ds=nmm o=lst\nmm.lst
$log	Running oap
$call gams gravity --ds=oap o=lst\oap.lst
$log	Running ocr
$call gams gravity --ds=ocr o=lst\ocr.lst
$log	Running ogs
$call gams gravity --ds=ogs o=lst\ogs.lst
$log	Running oil
$call gams gravity --ds=oil o=lst\oil.lst
$log	Running ome
$call gams gravity --ds=ome o=lst\ome.lst
$log	Running omf
$call gams gravity --ds=omf o=lst\omf.lst
$log	Running osd
$call gams gravity --ds=osd o=lst\osd.lst
$log	Running otn
$call gams gravity --ds=otn o=lst\otn.lst
$log	Running oxt
$call gams gravity --ds=oxt o=lst\oxt.lst
$log	Running pdr
$call gams gravity --ds=pdr o=lst\pdr.lst
$log	Running pfb
$call gams gravity --ds=pfb o=lst\pfb.lst
$log	Running pmt
$call gams gravity --ds=pmt o=lst\pmt.lst
$log	Running ppp
$call gams gravity --ds=ppp o=lst\ppp.lst
$log	Running rmk
$call gams gravity --ds=rmk o=lst\rmk.lst
$log	Running tex
$call gams gravity --ds=tex o=lst\tex.lst
$log	Running uti
$call gams gravity --ds=uti o=lst\uti.lst
$log	Running v_f
$call gams gravity --ds=v_f o=lst\v_f.lst
$log	Running wht
$call gams gravity --ds=wht o=lst\wht.lst
$log	Running wol
$call gams gravity --ds=wol o=lst\wol.lst
