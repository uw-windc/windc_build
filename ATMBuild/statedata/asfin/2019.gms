
$gdxIn asfin\2019.gdx
$onEmpty
$offEolCom
$eolCom !!

Set S(*) Workbook sheets ;
$loadDC S

Set W(*) Workbook sheets by name ;
$loadDC W

Set WS(*,*) Workbook map ;
$loadDC WS

Set C(*) Columns ;
$loadDC C

Set R(*) Rows ;
$loadDC R

Parameter VF(*,*,*) Cells with values ;
$loadDC VF

Set VS(*,*,*) Cells with explanatory text ;
$loadDC VS

Set VU(*,*,*,*) Cells with potential UEL ;
$loadDC VU

$offEmpty
