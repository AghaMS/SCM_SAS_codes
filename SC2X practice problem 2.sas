proc optmodel;

set Plants = {'P1','P2'};
set Cities = {'C1', 'C2','C3','C4'};

number Supply{p in Plants} = [100000 100000];
number Peak_D{c in Cities} = [40500 22230 85200 47500];
number Cost{p in Plants, c in Cities} = [
52 32 11 69
45 84 76 15];

var X{p in Plants, c in Cities} >= 0;

minimize T_cost= sum{p in Plants, c in Cities} X[p,c]*Cost[p,c];

con Supply_T{p in Plants}: sum{c in Cities} X[p,c] <= Supply[p];
con Demand_T{c in Cities}: sum{p in Plants} X[p,c] >= Peak_D[c];

solve;

print T_cost X;
quit;