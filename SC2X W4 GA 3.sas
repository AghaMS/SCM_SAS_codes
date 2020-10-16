proc optmodel;

set Depot={'CDC','ID1','ID2'};
set IntermediateDepot={'ID1','ID2'};
set PointDelivery={'Home','PhysStore','Amazon','Library','GasKiosk'};

number Depot_Capacity{Depot}=[99999 20000 7000];
number Depot_Handling{Depot}=[0 2 1.80];
number ID_Transport{IntermediateDepot}=[3 2.5];
number ID_FixedCost{IntermediateDepot}=[1300 1050];
number POD_Transport{Depot,PointDelivery}=[
 7.50 4.56 6.32 7.85 6.20
 2.40 3.10 9999 9999 9999
 9999 9999 1.23 3.56 1.10 
];
number POD_DeliveryProcessing{PointDelivery}=[0 0 0.85 0.6 0.6];
number POD_Demand{PointDelivery}=[5000 13000 2000 3000 2000];

var ID_Flow{IntermediateDepot} >= 0;
var Use_ID{IntermediateDepot} binary;
var POD_Flow{Depot,PointDelivery} >= 0;

minimize TotalCost = 
/*Intermediate Depot Fixed Costs*/
sum{k in IntermediateDepot}(ID_FixedCost[k]*Use_ID[k])
+
/*Transportation Cost to Intermediate Depot*/
sum{k in IntermediateDepot}(ID_Transport[k]*ID_Flow[k])
+
/*Intermediate Depot Handling Cost*/
sum{i in Depot}(Depot_Handling[i]*sum{j in PointDelivery}(POD_Flow[i,j]))
+
/*Transportation Cost to Point of Delivery*/
sum{i in Depot}(sum{j in PointDelivery}(POD_Transport[i,j]*POD_Flow[i,j]))
+
/*Point of Delivery Processing Cost*/
sum{j in PointDelivery}(POD_DeliveryProcessing[j]*sum{i in Depot}(POD_Flow[i,j]))
;

con Demand{j in PointDelivery}: sum{i in Depot}(POD_Flow[i,j])>=POD_Demand[j];
con Capacity{i in Depot}: sum{j in PointDelivery}(POD_Flow[i,j])<=Depot_Capacity[i];
con LinkingConstraint{k in IntermediateDepot}:sum{j in PointDelivery}POD_Flow[k,j]<=Use_ID[k]*25000;
con BalanceFlow{k in IntermediateDepot}: sum{j in PointDelivery}(POD_Flow[k,j])=ID_Flow[k];
con Pmin: sum{k in IntermediateDepot}Use_ID[k]>=0;
con Pmax: sum{k in IntermediateDepot}Use_ID[k]<=2;

solve;
print TotalCost ID_Flow Use_ID POD_Flow;

quit;