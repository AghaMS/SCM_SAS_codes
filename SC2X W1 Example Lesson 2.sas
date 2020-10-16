proc optmodel;

set Plant = {'BO1',	'NA1',	'PR1',	'SP1',	'WO1'};
set City ={'BO','BR','CO','HA','MN','NA','NH','NL','PO','PR','SP','WO'};


number Supply {i in Plant} = [2000 2000 2000 2000 2000];
number Demand {j in City}=[425 12 43 125 110 86 129 28 66 320 220 182];
number Fixed_Cost {i in Plant} = [10000 10000 10000 10000 10000];

number Cost_Distance {i in Plant, j in City} =[
0	93	69	98	55	37	128	95	62	42	82	34
37	65	33	103	20	0	137	113	48	72	79	41
42	106	105	73	92	72	94	57	104	0	68	38
82	59	101	27	93	79	63	57	127	68	0	47
34	68	72	66	60	41	98	71	85	38	47	0
];

number Unity_Matrix {i in City, j in City} = [
1	0	0	0	0	0	0	0	0	0	0	0
0	1	0	0	0	0	0	0	0	0	0	0
0	0	1	0	0	0	0	0	0	0	0	0
0	0	0	1	0	0	0	0	0	0	0	0
0	0	0	0	1	0	0	0	0	0	0	0
0	0	0	0	0	1	0	0	0	0	0	0
0	0	0	0	0	0	1	0	0	0	0	0
0	0	0	0	0	0	0	1	0	0	0	0
0	0	0	0	0	0	0	0	1	0	0	0
0	0	0	0	0	0	0	0	0	1	0	0
0	0	0	0	0	0	0	0	0	0	1	0
0	0	0	0	0	0	0	0	0	0	0	1];

var X{Plant, City} >= 0;
var Y{Plant} binary;


minimize T_Cost = sum{i in Plant, j in City} Cost_Distance[i,j]*X[i,j] + sum{i in Plant} Fixed_Cost[i]*Y[i];

con Meet_Supply{i in Plant}:
 sum{j in City} X[i,j] <= Supply[i];
 
con Meet_Demand{j in City}:
 sum{i in Plant} X[j,i] >= Demand[j];
 
con Linking{i in City}:
 sum{j in City}X[i,j]*Unity_Matrix[i,j] <= Demand[j]*Y[i];

con Min_DistNum: 
 sum{i in Plant} Y[i] =  1;



con Non_Negative {i in Plant, j in City}:
X[i,j] >=  0;

solve;
print T_Cost X Y;
print {i in Plant} (sum{j in City}X[i,j]);
quit;










