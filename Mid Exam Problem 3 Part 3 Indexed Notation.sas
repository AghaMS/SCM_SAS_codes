proc optmodel;

set Plants = {'Hawaii','Alabama','Mass','Maryland'};
set Trans = {'Rode island','Connectikate', 'Louisiana'};
set Dists = {'Nebraska','Kansas','Oregon','Idaho'};

number Max_P{Plants} = [ 350 105 502 288];
number Max_T{Trans} = [841	918	107];
number Fixed_C_T{Trans} = [6000	8500 6000];
number Max_D{Dists} = [461 176 128 292];

number incost{Plants, Trans} = [
26	45	38
40	40	46
32	45	40
48	37	36];

number outcost{Trans, Dists} = [
49	20	34	43
44	25	44	49
25	49	24	39];

var inflow{Plants, Trans} >= 0;
var outflow{Trans, Dists} >= 0;
var y{Trans} binary;

minimize TCost = sum{p in Plants, t in Trans} inflow[p,t]*incost[p,t] + sum{t in Trans, d in Dists} outcost[t,d]*outflow[t,d] + sum{t in Trans} y[t]*Fixed_C_T[t];

con cMaxP{p in Plants}: sum{t in Trans}inflow[p,t] <= Max_P[p];
con cMinD{d in Dists}: sum{t in Trans}outflow[t,d] >= Max_D[d];
con NoStock{t in Trans}: sum{p in Plants} inflow[p,t] = sum{d in Dists} outflow[t,d];
con cMaxT{t in Trans}: sum{p in Plants} inflow[p,t] <= Max_T[t];
con Fixed_Charge{t in Trans}: sum{p in Plants} inflow[p,t] <= 10000*y[t];


solve;

print TCost;
print inflow;
print outflow;rint {t in Trans} (sum{p in Plants} inflow[p,t]);
print y;
quit;











