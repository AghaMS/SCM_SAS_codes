proc optmodel;

set Plants = {'P1','P2','P3','P4','P5'};
set Trans = {'T1','T2'};
set Dists = {'D1','D2','D3','D4','D5'};

number Max_P{Plants} = [ 200 300 100 150 220];
number Max_T{Trans} = [450 300];
number Max_D{Dists} = [150 100 110 200 180];
number incost{Plants, Trans} = [
30 50
23 66
35 14
70 12
65 70];
number outcost{Trans, Dists} = [
12 25 22 40 41
65 22 23 12 15];

var inflow{Plants, Trans} >= 0;
var outflow{Trans, Dists} >= 0;

minimize T_Cost = sum{p in Plants, t in Trans} inflow[p,t]*incost[p,t] + sum{t in Trans, d in Dists} outcost[t,d]*outflow[t,d];

con cMaxP{p in Plants}: sum{t in Trans}inflow[p,t] <= Max_P[p];
con cMinD{d in Dists}: sum{t in Trans}outflow[t,d] >= Max_D[d];
con NoStock{t in Trans}: sum{p in Plants} inflow[p,t] = sum{d in Dists} outflow[t,d];
con cMaxT{t in Trans}: sum{p in Plants} inflow[p,t] <= Max_T[t];

solve;
print T_Cost;
print inflow;
print outflow;
print {t in Trans} (sum{p in Plants} inflow[p,t]);
quit;











