proc optmodel;

set Plants = {'Hawaii','Alabama','Mass','Maryland'};
set Trans = {'Rode island','Connectikate', 'Louisiana'};
set Dists = {'Nebraska','Kansas','Oregon','Idaho'};


number Max_P{Plants} = [ 29 36 39 26];
number Max_T{Trans} = [44	48	48];
number Fixed_C_T{Trans} = [950	950 750];
number Max_D{Dists} = [27 9 12 12];
number Fixed_C_P{Plants} = [280	180	180	280];

number incost{Plants, Trans} = [
44	26	45
30	47	39
45	36	35
29	38	26];


number outcost{Trans, Dists} = [
39	21	36	47
36	47	48	37
36	34	34	23];


var inflow{Plants, Trans} >= 0;
var outflow{Trans, Dists} >= 0;
var y{Trans} binary;
var w{Plants} binary;


minimize TCost = sum{p in Plants, t in Trans} inflow[p,t]*incost[p,t] + sum{t in Trans, d in Dists} outcost[t,d]*outflow[t,d] + sum{t in Trans} y[t]*Fixed_C_T[t] + sum{p in Plants} w[p]*Fixed_C_P[p];

con cMaxP{p in Plants}: sum{t in Trans}inflow[p,t] <= Max_P[p];
con cMinD{d in Dists}: sum{t in Trans}outflow[t,d] >= Max_D[d];
con NoStock{t in Trans}: sum{p in Plants} inflow[p,t] = sum{d in Dists} outflow[t,d];
con cMaxT{t in Trans}: sum{p in Plants} inflow[p,t] <= Max_T[t];
con Fixed_Charge{t in Trans}: sum{p in Plants} inflow[p,t] <= 10000*y[t];
con Fixed_CostPlants {p in Plants}: sum{t in Trans} inflow[p,t] <= 10000*w[p];


solve;

print TCost;
print inflow;
print outflow;rint {t in Trans} (sum{p in Plants} inflow[p,t]);
print y;
quit;

