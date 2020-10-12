proc optmodel;

set Product = {'Haihai',	'Sensei',	'Hiro',	'Kirito'};
set Plant = {'Osaka',	'Nagoya',	'Yokohama',	'Nara',	'Fukuoka'};

number Demand {i in Product}=[541 540 515 506];
number Supply {j in Plant} = [608 618 556 632 636];

number Var_Cost {i in Plant, j in Product} =[
21.8 23.8 25.3 21.55
24.35 22.95 23.8 21.35
24.1 23.3 24.35 23.5
24.9 24.65 21.65 23.9
21.1 24.35 23.3 21.2
];

number Min_Production {i in Plant, j in Product} =[
61 136 150 106
86 124 136 150
70 134 104 119
106 125 100 109
73 96 91 105
];

number Max_Production {i in Plant, j in Product} = [
285	320	277	282
336	296	370	330
332	324	316	365
318	311	369	348
349	297	331	279
];

number Fixed_Cost {i in Plant, j in Product} = [
737	1111 1343 930
741	1291 1316 1404
604	1352 816 906
1194 381 726 586
419	311	327	1071
];

var X{Plant, Product} >= 0;
var Y{Plant, Product} binary;


minimize T_Cost = sum{i in Plant, j in Product} Var_Cost[i,j]*X[i,j] + sum{i in Plant, j in Product} Fixed_Cost[i,j]*Y[i,j];

con Meet_Supply{i in Plant}:
 sum{j in Product} X[i,j] <= Supply[i];
 
con Meet_Demand{i in Product}:
 sum{j in Plant} X[j,i] >= Demand[i];
 
con Meet_Minimum_Amount{i in Plant, j in Product}:
X[i,j] >=  Min_Production[i,j]*Y[i,j];

con Meet_Maximum_Amount{i in Plant, j in Product}:
X[i,j] <=  Max_Production[i,j]*Y[i,j];

con Non_Negative {i in Plant, j in Product}:
X[i,j] >=  0;

solve;
print T_Cost X Y;
print {i in Plant} (sum{j in Product}X[i,j]);
quit;










