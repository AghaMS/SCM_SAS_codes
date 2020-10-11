proc optmodel;
set DC={'BO','NA','PR','SP','WO'};
set Plant={'BFPLANT','SCPLANT'};
set RDC={'BO','BR','CO','HA','MN','NA','NH','NL','PO','PR','SP','WO'};

number outbound{DC,RDC}=[
8	93 	69	98	55	37	128	95	62	42	82	34
37	65	33	103	20	12	137	113	48	72	79	41
42	106	105	73	92	72	94	57	104	17	68	38
82	59	101	27	93	79	63	57	127	68	12	47
34	68	72	66	60	41	98	71	85	38	47	18
];

number proxim {DC,RDC}=[
1	0	0	0	0	1	0	0	0	1	0	1  
1	0	1	0	1	1	0	0	1	0	0	1
1	0	0	0	0	0	0	0	0	1	0	1
0	0	0	1	0	0	0	0	0	0	1	1
1	0	0	0	0	1	0	0	0	1	1	1
];

number inbound{DC,PLANT}=[
3.4		4.8
3.0		5.25
4.4		5.12
3.04	4.00
3.36	4.20
];

number VC{DC}=[1 0.95 1.05 1.10 1.12];
number FC{DC}=[5000 5000 9000 8000 7000];
number Vcost{PLANT}=[2.00 0.75];
number Pcapacity{PLANT}=[2000 99999];
number capacity{DC}=[1000 500 1000 500 1000];
number demand{RDC}=[450	60	80	130	110	140	140	70 120 310 200 190];
number FCP{Plant} = [18000 14000];


var open{DC} binary;
var openP{Plant} binary;
var inflow{DC, PLANT} >= 0;
var outflow{DC, RDC} >=0;

minimize Total_Costs = 

/*Central Warehouse Fixed Costs*/
sum{i in DC}(FC[i]*open[i])
+
/*Plants Fixed Costs*/
sum{i in PLANT}(FCP[i]*openP[i])
+
/*Cost of inbound transportation*/
sum{i in DC}(sum{j in PLANT}(inflow[i,j]*inbound[i,j]))
+
/*Cost of outbound transportation*/
sum{i in DC}(sum{k in RDC}(outflow[i,k]*outbound[i,k]*0.55))
+
/*Central Warehouse Variable Costs*/
sum{i in DC}(VC[i]*sum{j in RDC}(outflow[i,j]))
+
/*Production variable costs*/
sum{j in PLANT}(Vcost[j]*sum{i in DC}(inflow[i,j]))
;

con demandRDC{k in RDC}: sum{i in DC}(outflow[i,k])>=demand[k];
con MINused: sum{i in DC}open[i]<=5;
con MAXused: sum{i in DC}open[i]>=1;
con CapacityPlant{j in PLANT}: sum{i in DC}inflow[i,j]<=Pcapacity[j];
con Flow{i in DC}: sum{j in PLANT}inflow[i,j]=sum{k in RDC}(outflow[i,k]);



con AvgDistance: sum{k in RDC,i in DC}outflow[i,k]*outbound[i,k]<=35*sum{k in RDC}(demand[k]);
con fiftyMiles: sum{k in RDC,i in DC}proxim[i,k]*outflow[i,k]>=0.6*sum{k in RDC}(demand[k]);



con CapacityDC{i in DC}: sum{k in RDC}outflow[i,k]<=capacity[i];
con Openess {i in DC}: sum {k in RDC}outflow[i,k]<=open[i]*2000;
con OpenessP {i in PLANT}: sum {j in DC}inflow[j,i]<=openP[i]*2000;

solve;

print Total_Costs open openP inflow outflow;
print (sum{i in DC}(FC[i]*open[i]));
print (sum{i in PLANT}(FCP[i]*openP[i]));
print (sum{i in DC}(sum{j in PLANT}(inflow[i,j]*inbound[i,j])));
print (sum{i in DC}(sum{k in RDC}(outflow[i,k]*outbound[i,k]*0.55)));
print (sum{i in DC}(VC[i]*sum{j in RDC}(outflow[i,j])));
print (sum{j in PLANT}(Vcost[j]*sum{i in DC}(inflow[i,j])));


print {i in DC, j in Plant} (inflow[i,j]);
print {i in DC, j in RDC} (outflow[i,j]);
quit; 