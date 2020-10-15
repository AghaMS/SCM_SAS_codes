proc optmodel;

set Period={1,2,3,4,5,6,7,8,9,10,11,12};
set Period_with_Zero={0,1,2,3,4,5,6,7,8,9,10,11,12};

number Capacity=99999;
number HoldingCost=0.233333333333;
number SetupCost=945;
number Demand{Period}=[780 180 360 300 1200 3300 1080 840 360 300 600 1500];

var QuantityProduced{Period} >= 0;
var Inventory{Period_with_Zero} >= 0;
var Production{Period} binary;

minimize TotalCost = 
/*Setup Cost*/
sum{t in Period}(SetupCost*Production[t])
+
/*Inventory Holding Cost*/
sum{t in Period}(HoldingCost*Inventory[t])
;

con StartingInventory: Inventory[0]=0;
con FlowConservation{t in Period}: QuantityProduced[t]-Demand[t]+Inventory[t-1]-Inventory[t]=0;
con ManufacturingCapacity{t in Period}: QuantityProduced[t]<=Capacity;
con LinkingConstraint{t in Period}:QuantityProduced[t]-Production[t]*2000<=0;

solve;
print TotalCost Production QuantityProduced;

quit;