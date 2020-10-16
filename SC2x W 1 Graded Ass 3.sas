proc optmodel;

set Plant ={'Chi',	'Ciu', 'Dur', 'Mex', 'Mon', 'Mor', 'Oax', 'Pue', 'San', 'Vil'};
set City ={'Chi', 'Ciu', 'Dur', 'Mex', 'Mon', 'Mor', 'Oax', 'Pue', 'San', 'Vil'};

number Supply {i in Plant} = [33733530 33733530 33733530 33733530 33733530 33733530 33733530 33733530 33733530 33733530];
number Demand {j in City}=[953780 331660 534570 21031570 4655600 808550 669500 3016870 1072230 659200];
number Fixed_Cost {i in Plant} = [ 464000 464000 464000 464000 464000 464000 464000 464000 464000 464000];

number Cost_Distance {i in Plant, j in City} =[
5	719	503	1158	590	1069	1458	1250	913	1575
719	5	488	475	203	506	720	519	249	787
503	488	5	698	376	579	1008	808	482	1186
1158	475	698	10	643	188	310	127	253	545
590	203	376	643	5	626	911	706	393	990
1069	506	579	188	626	5	470	313	258	730
1458	720	1008	310	911	470	5	208	545	320
1250	519	808	127	706	313	208	5	338	417
913	249	482	253	393	258	545	338	5	704
1575	787	1186	545	990	730	320	417	704	5
];


var X{Plant, City} >= 0;
var Y{Plant} binary;


minimize T_Cost = sum{i in Plant, j in City} Cost_Distance[i,j]*X[i,j] + sum{i in Plant} Fixed_Cost[i]*Y[i];

con Meet_Supply{i in Plant}:
 sum{j in City} X[i,j] <= Supply[i]/1030;
 
con Meet_Demand{j in City}:
 sum{i in Plant} X[i,j] >= Demand[j]/1030;
 
con Linking{i in Plant, j in City}:
 X[i,j] - Demand[j]*Y[i]<= 0;

con Min_DistNum: 
 sum{i in Plant} Y[i] >=  1;

con Max_DistNum: 
 sum{i in Plant} Y[i] <=  10;

con Non_Negative {i in Plant, j in City}:
X[i,j] >=  0;

solve;
print T_Cost X Y;
print {i in Plant} (sum{j in City}X[i,j]);
quit;










