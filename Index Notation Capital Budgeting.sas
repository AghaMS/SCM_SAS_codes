proc optmodel;

set Years= {'Y1','Y2','Y3'};
set Projects= {'P1','P2','P3','P4','P5'};

number Return{Projects} = [20 40 20 15 30];
number Expenditure{Projects, Years} = [
5 1 8
4 7 10
3 9 2
7 4 1
8 6 10 ];
number Available{Years} = [25 25 25];

var X{p in Projects} Binary;

maximize Total_Return = sum {p in Projects} X[p]*Return[p];

con Av_Funds {y in Years}: 
  sum{p in Projects} X[p]*Expenditure[p,y] <= Available[y];
  
  solve;
  print Total_Return X;
  quit;




