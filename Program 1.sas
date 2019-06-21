/*Data import*/
proc import out=mydata
datafile="/home/u37560128/my_courses/Priya_course_work/MKtthursdaydata/data.xlsx"
dbms=xlsx replace; getnames=yes; datarow=2; run;
/*Contents of the data*/
proc contents data=mydata; run;

/*Changing variables from charater to numeric*/
data mynewdata; 
set mydata;
new_Gini_Index = input(Gini_Index, informat.);
new_Human_rights = input(Human_rights, informat.);
new_Inequality_in_income = input(Inequality_in_income, informat.);
new_World_giving_Index = input(World_giving_Index, informat.);
run;
/*Variables that we have in the data set
new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index Accept_of_incomeinequality Alchohol_consumption
Annual_growth_gdp Average_self_ratedhealth Belif_in_god
Change_ISD_Index_genderequality	Control_of_corruption
Economic_Freedom_Index Freedom_choose Freedom_of_speech
GDP Gini_Index Government_size Govt_Effenessectiv
Govt_inter_in_the_economy
HDI Human_rights Hunger Inequality_in_income 
Institutional_quality Internet_user_per1000 
Per_agriculture_share_in_GDP Public_acceptance_of_suicide
Public_health_expenditure Satisfaction_with_life Suppresson_of_civil_liberty
World_giving_Index*/
/*Variable exploration with proc means*/
proc means data=mynewdata;
var new_Gini_Index new_Human_rights new_Inequality_in_income new_World_giving_Index;
run;
/*Variable exploration with proc freq- not useful in this case*/
proc freq data=mynewdata; 
table Annual_growth_gdp*HDI; run; 
/*Plotting variables*/
/*Positively related*/
ods graphics on;
proc gplot data=mynewdata;
plot Annual_growth_gdp*HDI; run; quit;

ods graphics on;
proc gplot data=mynewdata;
plot Annual_growth_gdp*new_Inequality_in_income; run; quit;
/*Shows mostly concentration of scatter points*/
ods graphics on;
proc univariate data=mynewdata;
histogram GDP; run; quit;
/*Correlation*/
proc corr data=mynewdata out=corr_data;
var new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index Accept_of_incomeinequality Alchohol_consumption
Annual_growth_gdp Average_self_ratedhealth Belif_in_god
Change_ISD_Index_genderequality	Control_of_corruption
Economic_Freedom_Index Freedom_choose Freedom_of_speech
GDP Government_size Govt_Effenessectiv
Govt_inter_in_the_economy
HDI Hunger Institutional_quality Internet_user_per1000 
Per_agriculture_share_in_GDP Public_acceptance_of_suicide
Public_health_expenditure Satisfaction_with_life Suppresson_of_civil_liberty;
run; quit; 