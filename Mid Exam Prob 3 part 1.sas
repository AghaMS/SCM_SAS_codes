proc optmodel;

set Plants = {'Hawaii','Alabama','Mas','Maryland'};
set Cities = {'Nebraska', 'Kansas','Oregon','Idaho'};

number Supply{p in Plants} = [350 105 502 288];
number Peak_D{c in Cities} = [461 176 128 292];
number Cost{p in Plants, c in Cities} = [
63	98	66	49
94	54	51	49
68	68	60	82
43	70	84	44];

var X{p in Plants, c in Cities} >= 0;

minimize T_cost= sum{p in Plants, c in Cities} X[p,c]*Cost[p,c];

con Supply_T{p in Plants}: sum{c in Cities} X[p,c] <= Supply[p];
con Demand_T{c in Cities}: sum{p in Plants} X[p,c] >= Peak_D[c];

solve;

print T_cost X;
quit;