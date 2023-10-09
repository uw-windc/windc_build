- [Data](#data)
- [Build Instructions](#build-instructions)
- [Core](core/README.md)
- [Household](household/README.md)
- [GTAPWiNDC](GTAPWiNDC/README.md)
    - [gtap11](GTAPWiNDC/gtap11/README.md)
    - [gtap9](GTAPWiNDC/gtap9/README.md)


# Data

The data required to build each of piece of the repository is located at 
the following link [WiNDC downloads page](https://windc.wisc.edu/downloads.html). 
Extract `windc_2021.zip` into the `windc_build` directory. This will 
create a directory called `data`.

Data is included to run `core`, `household`, and `gtap9`. In order to run 
`gtap11` or `gtap11a` you need to obtain a license from GTAP. The data for 
GTAPWiNDC for the year 2017 is propriety to GTAP and requires a GTAP license. 

The zip file should have the correct directory structure, but the following 
is the correct naming scheme:

```
|data
|-- core
|  |   windc_base.gdx
|-- household
|  |  |-- cex
|  |  |-- cps
|  |  |-- soi
|-- GTAPWiNDC
|  |-- gtap9
|  |  |  flexagg9aY04.zip
|  |  |  flexagg9aY07.zip
|  |  |  flexagg9aY11.zip
|  |-- gtap11
|  |  |  
|  |-- gtap11a
|  |  |
```

As mentioned, both the `gtap11` and `gtap11a` directories are empty. You 
can either place the correct ZIP file in the folder, or modify the file 
`GTAPWiNDC/gtapingams.gms` to point to the correct location.


# Build Instructions

The build stream must be run in a particular order as subsequent modules 
depend on previously built data. As convention, each module has a file 
`build.gms` that runs all essential methods and builds necessary data. 
Each modules may have other options, this is detailed on their documentation page. 

The correct order is: 

1. `core`
2. `household`
3. `GTAPWiNDC` - Note: You must modify the file `gtapingams.gms` to point 
to your GTAP files. This is detailed in the [GTAPWiNDC documentation](GTAPWiNDC/README.md).


## General Instructions
Use the terminal/command line to navigate to the directory you wish to 
build, we'll use `core` as an example, and run the command:

    gams build.gms

Each of the modules have optional command line options. In `core` 
calibrating using the Huber methods is optional. To build using Huber
run the command:

    gams build.gms --huber=yes

Command line options for every file in each module are detailed on the
modules documentation page.
