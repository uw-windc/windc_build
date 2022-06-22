This code is from Tom Rutherford.

This directory contains GAMS code to aggregate the full GTAP dataset 
for 2014 to 11 regions and 15 sectors.


1. Directory "gtap10ingams"

- GAMS code for GTAPinGAMS 

2. Directory "aggregate" 

- "gtap_10.gms": GAMS code that calls several GAMS routines and takes 
the dataset "gtapingams.gdx" and creates the dataset "gtap_10.gdx".

- Both datasets are stored in the subdirectory "gamsdata".

- The dataset "gtap_10.gdx" is the input dataset for the 
WiNDC module "gtap".

- If you wish to create your own aggregation, you will need to
modify the files in the subdirectory "defines".

