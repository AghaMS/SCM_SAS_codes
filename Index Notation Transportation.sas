proc optmodel;

set Plants = {'P1','P2','P3'};
set Cities = {'C1', 'C2','C3','C4'};

number Supply{p in Plants} = [35 50 40];
number Peak_D{c in Cities} = [45 20 30 30];
number Cost{p in Plants, c in Cities} = [
8 6 10 9
9 12 13 7
14 9 16 5];

var X{p in Plants, c in Cities} >= 0;

minimize T_cost= sum{p in Plants, c in Cities} X[p,c]*Cost[p,c];

con Supply_T{p in Plants}: sum{c in Cities} X[p,c] <= Supply[p];
con Demand_T{c in Cities}: sum{p in Plants} X[p,c] >= Peak_D[c];

solve;

print T_cost X;
quit;