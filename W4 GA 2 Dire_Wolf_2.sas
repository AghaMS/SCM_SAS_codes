proc optmodel;

set Period = {1,2,3,4,5,6,7,8,9,10,11,12};
set Period_with_Zero = {0,1,2,3,4,5,6,7,8,9,10,11,12};


number MaterialCost = 7.0112;  /* $/unit */
number InvHoldingCost = 1.5088;  /* $/unit-month */
number StockoutCost = 2.7512;  /* $/unit-month */
number HiringCost = 1775.0;  /* $ */
number LayingOffCost = 3550.0;  /* $ */
number LaborHoursPerUnit = 0.2813;  /* hr/unit */
number LaborCost = 1704.0;  /* $/month */
number OvertimeCost = 17.9867;  /* $/hr */
number OutsourcingCost = 16.0637;  /* $/unit */
number HoursEmployee = 117.75;  /* hr/month-employee */
number MaxOvertime = 8.25;  /* hr/month-employee */
number StartingInventory = 4000.0;  /* units */
number EndingInventory = 4000.0;  /* units */
number StartingBacklog = 0.0;  /* units */
number EndingBacklog = 0.0;  /* units */
number StartingWorkforce = 24.0;  /* employees */
number MinEndingWorkforce = 24.0;  /* employees */
number MaxEndingWorkforce = 24.0;  /* employees */
number BasePrice = 18.7263;  /* $/unit */
number Elasticity = 5; 
number BaseDemand{Period}=[22136	20024	18152	13864	8072	4184	2344	5864	10216	12088	15896	24536];
number PriceDiscount{Period}=[0 0 0 0 0 0 0 0 0 0 0 0];
number Demand{t in Period}=BaseDemand[t]*(1+Elasticity*PriceDiscount[t]);
number Price{t in Period}=BasePrice*(1-PriceDiscount[t]);

var Inventory{Period_with_Zero} >= 0;
var Workforce{Period_with_Zero} integer >= 0;
var Backlogged{Period_with_Zero} >= 0;
var EmployeesHired{Period} integer >=0 ;
var EmployeesFired{Period} integer >=0;
var Overtime{Period} >= 0;
var InternalProduction{Period} >= 0;
var OutsourcedProduction{Period} >= 0;

maximize TotalProfit =
/* Income */
sum{t in Period}(Price[t]*Demand[t])
-(
/*Regular Labor Cost*/
LaborCost*sum{t in Period}(Workforce[t])
+
/*Overtime Labor Cost*/
OvertimeCost*sum{t in Period}(Overtime[t])
+
/*Cost of Hiring*/
HiringCost*sum{t in Period}(EmployeesHired[t])
+
/*Cost of Firing*/
LayingOffCost*sum{t in Period}(EmployeesFired[t])
+
/*Cost of Inventory*/
InvHoldingCost*sum{t in Period}(Inventory[t])
+
/*Cost of Stockouts*/
StockoutCost*sum{t in Period}(Backlogged[t])
+
/*Cost of Materials*/
MaterialCost*sum{t in Period}(InternalProduction[t])
+
/*Cost of Outsourcing*/
OutsourcingCost*sum{t in Period}(OutsourcedProduction[t])
)
;

con StartInventory: Inventory[0]=StartingInventory;
con StartBacklog: Backlogged[0]=StartingBacklog;
con StartWorkforce: Workforce[0]=StartingWorkforce;
con EndInventory: Inventory[12]>=EndingInventory;
con EndBacklog: Backlogged[12]<=EndingBacklog;
con MinEndWorkforce: Workforce[12]>=MinEndingWorkforce;
con MaxEndWorkforce: Workforce[12]<=MaxEndingWorkforce;
con ComputeInventory{t in Period}: Inventory[t]=Inventory[t-1]+InternalProduction[t]+OutsourcedProduction[t]+Backlogged[t]-Backlogged[t-1]-Demand[t];
con ComputeWorkforce{t in Period}: Workforce[t]=Workforce[t-1]+EmployeesHired[t]-EmployeesFired[t];
con MaximOvertime{t in Period}: Overtime[t]<=MaxOvertime*Workforce[t];
con MaxInternalProduction{t in Period}: InternalProduction[t]*LaborHoursPerUnit<=HoursEmployee*Workforce[t]+Overtime[t];

solve;
print TotalProfit Inventory Workforce EmployeesHired EmployeesFired Overtime Backlogged InternalProduction OutsourcedProduction;

quit;