ns0(itrd(i),mkt,rb,s) = 0;
nd0(itrd(i),mkt,rb,s) = 0;
vnm(itrd(i),mkt,rb) = 0;
n_(itrd(i),mkt,rb) = no;
pn_(itrd(i),mkt,rb) = no;

ns0(itrd(i),"national",rb,s) = sum(ss,bd0(i,rb,s,ss));
nd0(itrd(i),"national",rb,s) = sum(ss,bd0(i,rb,ss,s));

vnm(itrd(i),mkt,rb) = sum(s,ns0(i,mkt,rb,s));
n_(itrd(i),mkt,rb) = vnm(i,mkt,rb);
pn_(itrd(i),mkt,rb) = vnm(i,mkt,rb);

bd0(itrd(i),rb,s,ss)$sum(n_(i,mkt,rb),1) = 0;

$include gtapwindc.gen
solve gtapwindc using mcp;

rtms(i,r,"usa") = 0.5;
gtapwindc.iterlim = 10000;
$include gtapwindc.gen
solve gtapwindc using mcp;
