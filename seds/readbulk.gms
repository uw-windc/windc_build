$ontext

   Reads json file using embedded Python

   Data from: https://www.eia.gov/opendata/bulkfiles.php

$offtext



$if not set dataset $set dataset  ELEC
$if not exist %dataset%.zip $call curl -o %dataset%.zip https://www.eia.gov/opendata/bulk/%dataset%.zip
$if not exist %dataset%.txt $call gmsunzip %dataset%.zip
$set datafile %dataset%.txt
$set gdxfile  %dataset%.gdx


$setenv gdxCompress=1

set
  t  'date/year'
  id 'series_id from txt file, explanatory text has name'
  e  'error strings where we have for NA (not available)'
  errors(id,t,e<) 'could not extract a value from these';

parameter
   series(id,t<) 'data for each series';

$onEmbeddedCode Python:
import json
print("")

fln = '%datafile%'

print(f"read {fln}")
with open(fln) as f:
     lines = f.readlines()
print(f"lines:{len(lines)}")

ids = [] # 1D set
series = [] # 2d parameter
errors = [] # 3d set

print("processing")
k = 0
for s in lines:
     k = k + 1
     if len(s)>1:
        obj = json.loads(s)
        if 'series_id' in obj:
           id = obj['series_id']
           print(f"--{id}")
           name = obj['name']
           ids.append((id,name))
           lastdate = 0
           for item in obj['data']:
                  date = item[0]
                  if (date!=lastdate):
                        value = item[1]
                        if type(value) in [float,int]:
                              series.append((id,date,value))
                        else:
                              series.append((id,date,float('nan')))
                              errors.append((id,date,str(value)))
                        lastdate = date


gams.set('id',ids)
gams.set('series',series)
gams.set('errors',errors)

$offEmbeddedCode id series errors

* count cases
parameter errCount(e) 'observations recoded as NA';
errCount(e) = sum(errors(id,t,e),1);
option errCount:0;
display errCount;

execute_unload "%gdxfile%";
