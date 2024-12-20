@echo off

:	XLSX files can be downloaded from here: https://uwmadison.box.com/s/44npjmzor6qh6juum2arlmlkm3f4jt94

:read
gams readimports o=data\readimports.lst
gams readmargins o=data\readmargins.lst
gams readpro o=data\AllTablesIO\readpro.lst
gams readpur o=data\AllTablesIO\readpur.lst
gams readmake o=data\AllTablesIO\readmake.lst
gams readuse o=data\AllTablesSUP\readuse.lst
gams readsupply o=data\AllTablesSUP\readsupply.lst

:relabel
gams relabelmargins o=data\relabelmargins.lst
gams relabel --id=imports --ds=data\imports  o=data\relabel_imports.lst
gams relabel --id=make --ds=data\AllTablesIO\make		o=data\AllTablesIO\relabel_make.lst
gams relabel --id=use --ds=data\AllTablesIO\use_pro --id=use o=data\AllTablesIO\relabel_use_pro.lst
gams relabel --id=use --ds=data\AllTablesIO\use_pur --id=use o=data\AllTablesIO\relabel_use_pur.lst
gams relabel --ds=data\AllTablesSUP\use --id=use o=data\AllTablesSUP\relabel_use.lst
gams relabel --ds=data\AllTablesSUP\supply --id=supply o=data\AllTablesSUP\relabel_supply.lst

:atmcalc
gams makeuse