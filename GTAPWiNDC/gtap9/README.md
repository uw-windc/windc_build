### GTAP 9

These routines are automatically called by `GTAPWiNDC/build.gms`. You 
shouldn't need to run these files unless you require different options
than the default.

1. `build.gms` - Imports the GTAP dataset into GAMS format.

    Inputs: GTAP zipfile. Must be set at command line.

    Outputs: `%gtap_version%/%year%/%aggregation%.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2011 | 2011 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |
    | aggregation | g20_10,  g20_32,  g20_43, wb12_10, wb12_32, wb12_43 | g20_10, g20_32, g20_43 | Set aggregations |
    | zipfile | | | Required: Path to GTAP zip file |
    
2. `flex2gdx.gms` - GTAP9 files are stored as FLEX files. This converts them to GDX.

    Inputs: `../../data/GTAPWiNDC/gtap9/flexagg9aY%year%.zip`

    Outputs: Temporary files 

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| yr | 2011 | 2011 | The year to run |

3. `gdx2gdx.gms` - Unzip and load the GTAP raw data.

    Inputs: Temporary files from `flex2gdx.gms`

    Outputs: `%gtap_version%/%year%/gtapingams.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| yr | 2011, 2007, 2004 | 2011 | The year to run |
    | zipfile | | | Required: Path to GTAP zip file |
    
4. `filter.gms`

    Inputs: `%gtap_version%/%year%/gtapingams.gdx`

    Outputs: `%gtap_version%/%year%/gtapingams_%reltol%.gdx`

   Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| yr | 2011 | 2011 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |

5. `aggregate.gms` - Perform aggregations on the data

    Inputs: `%gtap_version%/%year%/gtapingams_%reltol%.gdx`, `defines/%target%.gms`

    Outputs: `%gtap_version%/%year%/target.gdx`


    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2011 | 2011 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |
    | target | msmr, g20_10, g20_32, g20_43, wb12_10, wb12_32, wb12_43 | msmr | Set aggregations |

6. `replicate.gms` - Execute a benchmark calibrated model to verify data consistency

    Inputs: `%gtap_version%/%year%/target.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2011 | 2011 | The year to run |
    | target | msmr, g20_10, g20_32, g20_43, wb12_10, wb12_32, wb12_43 | msmr | Set aggregations |