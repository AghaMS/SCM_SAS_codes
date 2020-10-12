proc optmodel;

var X1 binary;
var X2 binary;
var X3 binary;

var X4 binary;
var X5 binary;
var X6 binary;



MINIMIZE Z = - 1.168*X1 + 1.216*X2 + 0.568*X3;

con 218441.04*X1 + 229871.56*X2 +	195202.31*X3 <=	640000;
con 262143.74*X1 +	201213.88*X2 +	191291.7*X3 <=	480000;
con 197025.6*X1 +	115481.53*X2 +	228471.62*X3 <=	640000;


con X1 + X2 + X3 >= 2;

con -41333.27*X1 + 108577.61*X2 + 46431.08*X3 >= 0;


solve;
print Z X1 X2 X3;
quit;