$TITLE GAMS routine for merging USA Trade Online data into build

* Set directory structure:
$IF NOT SET reldir $SET reldir "."

$IFTHENI %system.filesys% == UNIX $SET sep "/"
$ELSE $SET sep "\"
$ENDIF


SET r "Regions in WiNDC Database";
SET yr "Dynamically created set from parameter usatrd_units, Years in USA trade data set (2002-2016)";
SET t	"Dynamically create set from parameter usatrd, Trade type (import/export)";
SET n "Dynamically created set from parameter usatrd, NAICS codes"
SET s "BEA Goods and sectors categories";

* Note that exports are available from 2002-2016, while imports are available from 2008-2012.
PARAMETER usatrd_units(r,n,yr,t,*) "Trade data with units as domain";

$GDXIN '%reldir%%sep%windc_base.gdx'
$LOAD r
$LOAD s=i
$LOAD n<usatrd_units.dim2
$LOAD yr<usatrd_units.dim3
$LOAD t<usatrd_units.dim4
$LOADDC usatrd_units
$GDXIN


SET map(n,s) "Mapping between naics codes and sectors" /
$INCLUDE '%reldir%%sep%maps%sep%mapusatrd.map'
/;


PARAMETER usatrd(r,n,yr,t) "Trade data without units";

* Data originally in millions of dollars. Scale to billions:
usatrd(r,n,yr,t) = usatrd_units(r,n,yr,t,"millions of us dollars (USD)") * 1e-3;


PARAMETER usatrd_(yr,r,s,t) "Mapped trade data";
PARAMETER usatrd_shr(yr,r,s,t) "Share of total trade by region";

usatrd_(yr,r,s,t) = sum(map(n,s), usatrd(r,n,yr,t));

* Which sectors are not mapped? Could be there just aren't any
* imports/exports for a given sector region pairing or the sector isn't
* included (services/utilities). For exports, it would make more sense to
* differentiate sectors not included based on state gross product for a
* given state.

SET notinc(s) "Sectors not included in USA Trade Data";

notinc(s) = yes$(NOT sum(n, map(n,s)));
usatrd_shr(yr,r,s,t)$(NOT notinc(s) and sum(r.local, usatrd_(yr,r,s,t))) = usatrd_(yr,r,s,t) / sum(r.local, usatrd_(yr,r,s,t));

* Note that there isn't data for all years for the publishing sector in
* both exports and imports. Take average of data:

usatrd_shr(yr,r,s,t)$(NOT notinc(s) AND NOT sum(r.local, usatrd_(yr,r,s,t))) = sum(yr.local, usatrd_(yr,r,s,t)) / sum((r.local,yr.local), usatrd_(yr,r,s,t));

* Perform a comparison between import and export shares:

PARAMETER shrchk "Comparison between imports and exports";

shrchk(s,t) = usatrd_shr('2014','CA',s,t);
DISPLAY shrchk;


* Verify all shares sum to 1:
ABORT$(smax((yr,s), round(sum(r, usatrd_shr(yr,r,s,'exports')), 4)) <> 1) "Export shares don't sum to 1.";
ABORT$(smax((yr,s), round(sum(r, usatrd_shr(yr,r,s,'imports')), 4)) <> 1) "Import shares don't sum to 1.";

EXECUTE_UNLOAD '%reldir%%sep%temp%sep%gdx_temp%sep%shares_usatrd.gdx' usatrd_shr, notinc;
