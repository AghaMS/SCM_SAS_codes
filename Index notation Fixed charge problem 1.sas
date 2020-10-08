proc optmodel;

set products = {'P1', 'P2', 'P3'};
set constraints = {'C1', 'C2'};

number limitations{products, constraints} = [
3 4
2 3
6 4];


number profit{products} = [6 4 7];
number fixed_price{products} = [200 150 100];
number rhs{constraints} = [150 160];

var X{p in products} integer;
var Y{p in products} binary;

maximize Z = sum{p in products} (X[p]*profit[p]-  Y[p]*fixed_price[p]); 

con lim{c in constraints} :
sum{p in products} X[p]*limitations[p,c] <= rhs[c];

con lim_2{p in products}:
X[p]<= 100*Y[p];

con lim_3{p in products}:
X[p] >= 0;

solve;
print X Y Z;
quit;