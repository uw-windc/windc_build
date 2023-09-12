$title	GTAPinGAMS Model in Canonical Form

*-----------------------
*   If the gtapingams version is not set via command line,
*   then set its value. Use gtap11 when that data file exists, 
*   otherwise use gtap9.
*-----------------------

$include %system.fp%gtapingams

*	Need to have the g20_32 -- if you want a different default dataset,
*	define it here:

$if not set ds $set ds g20_32

*	Run the standard GTAP multiregional model:

$set mgeonly yes

$include %gtapingams%replicate

