- [Data](#data)
- [Core](core/README.md)
- [Household](household/README.md)
- [GTAPWiNDC](GTAPWiNDC/README.md)
    - [gtap11](GTAPWiNDC/gtap11/README.md)
    - [gtap9](GTAPWiNDC/gtap9/README.md)


# Data

The data required to build each of piece of the repository is located at the following link
[WiNDC downloads page](https://windc.wisc.edu/downloads.html). Extract `windc_2021.zip` into the 
`windc_build` directory. This will create a directory called `data`.

Data is included to run `core`, `household`, `bluenote`, and `gtap9`. In order to run `gtap11` or `gtap11a` you
need to obtain a license from GTAP. The data for GTAPWiNDC for the year 2017 is propriety to GTAP and requires a GTAP license. 

The zip file should have the correct directory structure, but the following is the correct naming scheme:

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

As mentioned, both the `gtap11` and `gtap11a` directories are empty. You can either place the correct
ZIP file in the folder, or modify the file `GTAPWiNDC/gtapingams.gms` to point to the correct location.