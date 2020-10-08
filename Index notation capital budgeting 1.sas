proc optmodel;

set Years = {'Y1', 'Y2', 'Y3'};
set Projects = {'P1', 'P2', 'P3', 'P4', 'P5'};

number expenditure{Projects, Years} = [
5 1 8
4 7 10
3 9 2
7 4 1
8 6 10 ];

number profit{Projects} = [20 40 20 15 30];
number rhs{Years} = [25 25 25];

var X{p in Projects} binary;

maximize Z = sum{p in Projects} X[p]*profit[p];

con available_fund{y in Years}: 
sum{p in Projects} X[p]*expenditure[p,y] <= rhs[y];

solve;
print X Z;
Quit;