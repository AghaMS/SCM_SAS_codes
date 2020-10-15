proc optmodel;

var X1 binary;
var X2 binary;
var X3 binary;
var X4 binary;
var X5 binary;

maximize Z = 9*X1 + 2*X2 + 2*X3 + 8*X4 + 4*X5;

con 2*X1 + 4*X2 + 3*X3 + 4*X4 + X5 <= 9;

solve;
print Z X1 X2 X3 X4 X5;
QUIT;