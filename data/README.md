## Data 

The data required to build each of piece of the repository are located at the following link
[WiNDC downloads page](https://windc.wisc.edu/downloads.html). Extract `windc_data.zip` into 
the `data` directory.

Data is included to run `core`, `household`, `bluenote`, and `gtap9`. In order to run `gtap11` you
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
|  |  |  GDX_AY1017.zip
```