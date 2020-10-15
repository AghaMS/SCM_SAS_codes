proc optmodel;
var X1a, X1b, X2a, X2b, Xa1, Xa2, Xa3, Xb1, Xb2, Xb3;

minimize Z = 60*X1a +  49*X1b + 44*X2a + 53*X2b + 69*Xa1 + 61*Xa2 + 62*Xa3 + 63*Xb1 + 57*Xb2 + 59*Xb3;

con X1a + X1b <= 500;
con X2a + X2b <= 750;

con Xa1 + Xb1 >= 250;
con Xa2 + Xb2 >= 500;
con Xa3 + Xb3 >= 500;

con X1a + X2a = Xa1 + Xa2 + Xa3;
con X1b + X2b = Xb1 + Xb2 + Xb3;

con X1a >= 0;
con X1b >= 0;
con X2a >= 0;
con X2b >= 0;
con Xa1 >= 0;
con Xa2 >= 0;
con Xa3 >= 0;
con Xb1 >= 0;
con Xb2 >= 0;
con Xb3 >= 0;

solve;
print Z X1a X1b X2a X2b Xa1 Xa2 Xa3 Xb1 Xb2 Xb3;
quit;