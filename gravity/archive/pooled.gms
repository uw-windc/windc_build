rtms(i,r,"usa") = 0.5;
gtapwindc.iterlim = 10000;
$include gtapwindc.gen
solve gtapwindc using mcp;
