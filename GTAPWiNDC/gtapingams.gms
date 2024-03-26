* -----------------------------------------------------------------*
* Step 1: Select the version of GTAP to use.                       *
*                                                                  *
* If you choose either gtap11b, gtap11a or gtap11                  *
* -----------------------------------------------------------------*

$setglobal gtap_version gtap11b
*$setglobal gtap_version gtap11a
*$setglobal gtap_version gtap11
*$setglobal gtap_version gtap9


* -----------------------------------------------------------------*
* Step 2: Set the path to the gtap file.                           *
*                                                                  *
* This should be a direct path to the GTAP zip directory you wish  *
* use. For example:                                                *
*                                                                  *
* $setglobal gtap_zip_path "C:\GDX11aAY333.zip"                    *
*                                                                  *
* We provide a default path, but it's possible the names will      *
* be different depending on the user. The default path is          *
*                                                                  *
* windc_build/data/GTAPWiNDC/gtap11/GDX_AY1017.zip"                *
*                                                                  *
* windc_build/data/GTAPWiNDC/gtap11a/GDX11aAY333.zip"              *
* -----------------------------------------------------------------*

*.$setglobal gtap_zip_path /path/to/gtap11/file


* ---------------------------------------------------------------- *
* You shouldn't need to modify below this line.                    *
*                                                                  *
* Unless you want to update the default paths with new zip names   *
* ---------------------------------------------------------------- *

*NB_ejb: the string "333" must indicate the GTAP licensee. I need "1017"

$ifthen not set gtap_zip_path
$if %gtap_version% == "gtap11b" $setglobal gtap_zip_path "%system.fp%../data/GTAPWiNDC/gtap11b/GDX11bAY1017.zip"
$if %gtap_version% == "gtap11a" $setglobal gtap_zip_path "%system.fp%../data/GTAPWiNDC/gtap11a/GDX11aAY333.zip"
$if %gtap_version% == "gtap11" $setglobal gtap_zip_path "%system.fp%../data/GTAPWiNDC/gtap11/GDX_AY1017.zip"
$endif



* ---------------------------------------------------------------- *
* Don't modify below this line.                                    *
* ---------------------------------------------------------------- *

$if %gtap_version% == "gtap9" $setglobal gtapingams gtap9/
$if %gtap_version% == "gtap11" $setglobal gtapingams gtap11/
$if %gtap_version% == "gtap11a" $setglobal gtapingams gtap11/
$if %gtap_version% == "gtap11b" $setglobal gtapingams gtap11/