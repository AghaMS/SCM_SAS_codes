proc optmodel;

set Models = {'compact','midsize','large'};
set const = {'C1', 'C2'};

number consumption{const, Models} = [
1.5 3 5
30 25 40
];

number Profit{Models} = [2000 3000 4000];
number RHS{const} = [6000 60000];
number Min_req {Models} = [1000 1000 1000];
number F = 100000;

var X{m in Models} integer >= 0;
var y{m in Models} Binary;

maximize Profit_returned = sum{m in Models} X[m]*Profit[m];

con EE{c in const}: 
sum{m in models} X[m]*consumption[c,m] <= RHS[c];
con Minimum {m in Models}:
X[m]>= Min_req[m]*Y[m];
con DD{m in Models}:
X[m]<=F*Y[m];
solve;
print X Profit_returned;
quit;