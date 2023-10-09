### GTAP 11

These routines are automatically called by `GTAPWiNDC/build.gms`. You 
shouldn't need to run these files unless you require different options
than the default.

1. `build.gms` - Imports the GTAP dataset (in GDX format) into the [GTAPinGAMS data structure](https://jgea.org/ojs/index.php/jgea/article/view/38)

    Inputs: GTAP zipfile. Must be set at command line.

    Outputs: `%gtap_version%/%year%/%aggregation%.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2017, 2014, 2011 | 2017 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |
    | aggregation | g20_10,  g20_32,  g20_43, wb12_10, wb12_32, wb12_43 | g20_10, g20_32, g20_43 | Set aggregations |
    | zipfile | | | Required: Path to GTAP zip file |
    | gtap_version | gtap11, gtap11a | | Required: Set version of GTAP |
    


2. `gdx2gdx.gms` - Unzip and load the GTAP raw data.

    Inputs: GTAP zipfile

    Outputs: `%gtap_version%/%year%/gtapingams.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| yr | 2017, 2014, 2011, 2007, 2004 | 2017 | The year to run |
    | zipfile | | | Required: Path to GTAP zip file |
    | gtap_version | gtap11, gtap11a | | Required: Set version of GTAP |
    
3. `filter.gms`

    Inputs: `%gtap_version%/%year%/gtapingams.gdx`

    Outputs: `%gtap_version%/%year%/gtapingams_%reltol%.gdx`

   Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| yr | 2017, 2014, 2011 | 2017 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |
    | gtap_version | gtap11, gtap11a | | Required: Set version of GTAP |

4. `aggregate.gms` - Perform aggregations on the data

    Inputs: `%gtap_version%/%year%/gtapingams_%reltol%.gdx`, `defines/%target%.gms`

    Outputs: `%gtap_version%/%year%/target.gdx`


    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2017, 2014, 2011 | 2017 | The year to run |
    | relative_tolerance | 3, 4, 5| 4 | Filter tolerances |
    | target | msmr, g20_10, g20_32, g20_43, wb12_10, wb12_32, wb12_43 | msmr | Set aggregations |
    | gtap_version | gtap11, gtap11a | | Required: Set version of GTAP |

5. `replicate.gms` - Execute a benchmark calibrated model to verify data consistency

    Inputs: `%gtap_version%/%year%/target.gdx`

    Command line options:

    |Command|Options| Default | Description |
    | ---   | ---   | --- | ---|
	| year | 2017, 2014, 2011 | 2017 | The year to run |
    | target | msmr, g20_10, g20_32, g20_43, wb12_10, wb12_32, wb12_43 | msmr | Set aggregations |
    | gtap_version | gtap11, gtap11a | | Required: Set version of GTAP |