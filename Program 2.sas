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

/**************************************Cluster analysis with HDI and GDP********************/
ods graphics on;
proc cluster data=mynewdata method=ward print=5 ccc pseudo;
var HDI GDP; 
copy Satisfaction_with_life;
run;
/* ncl Specifies the number of clusters desired in the OUT= data set */
proc tree noprint ncl=3 out=out;
copy HDI GDP Satisfaction_with_life; run;

proc freq;
tables cluster*Satisfaction_with_life / nopercent norow nocol plot=none;
run;

proc candisc noprint out=can;
class cluster;
var HDI GDP; run; 
proc sgplot data=can;
scatter y=can2 x=can1 / group=cluster; run;
/*************************************Cluster analysis with new_Gini_Index new_Inequality_in_income************************/
ods graphics on;
proc cluster data=mynewdata method=ward print=5 ccc pseudo;
var new_Gini_Index new_Inequality_in_income; copy Satisfaction_with_life;
run;
proc tree noprint ncl=3 out=out;
copy new_Gini_Index new_Inequality_in_income; copy Satisfaction_with_life;
run;
proc freq;
tables new_Gini_Index new_Inequality_in_income / nopercent norow nocol plot=none;
run;
proc candisc noprint out=can;
class cluster;
var new_Gini_Index new_Inequality_in_income; run; 
proc sgplot data=can;
scatter y=can2 x=can1 / group=cluster; run;
/*************************************Cluster analysis with Public_health_expenditure GDP************************/
ods graphics on;
proc cluster data=mynewdata method=ward print=5 ccc pseudo;
var Public_health_expenditure GDP; copy Satisfaction_with_life;
run;
proc tree noprint ncl=3 out=out;
copy Public_health_expenditure GDP; copy Satisfaction_with_life;
run;
proc freq;
tables Public_health_expenditure GDP / nopercent norow nocol plot=none;
run;
proc candisc noprint out=can;
class cluster;
var Public_health_expenditure GDP; run; 
proc sgplot data=can;
scatter y=can2 x=can1 / group=cluster; run;

/**************Factor analysis with social indicators contributing towards satisfaction with life**************/
proc corr data=mynewdata out=correl;
var new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index; run;

proc factor data=mynewdata;
var new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index; run; 
/*The first two largest positive eigenvalues of the reduced correlation matrix account for 79%  of the common variance. 
This is possible because the reduced correlation matrix, in general, is not necessarily positive definite, and negative 
eigenvalues for the matrix are possible. A pattern like this suggests that you I might not need more than two common 
factors*/
/*method prin Yields principal component analysis if no PRIORS option or statement is used or if you specify PRIORS=ON
scree displays a scree plot of the eigen values*/
proc factor data=mynewdata method=prin scree;
var new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index; run;
proc factor data=mynewdata method=prin scree n=2 out=data1;
var new_Gini_Index new_Human_rights new_Inequality_in_income 
new_World_giving_Index; run;
/*Factor analysis with economic indicators*/  
proc corr data=mynewdata out=correl1;
var Annual_growth_gdp GDP Internet_user_per1000 
Per_agriculture_share_in_GDP Public_health_expenditure; run;

proc factor data=mynewdata;
var Annual_growth_gdp GDP Internet_user_per1000 
Per_agriculture_share_in_GDP Public_health_expenditure; run;

proc factor data=mynewdata method=prin scree;
var Annual_growth_gdp GDP Internet_user_per1000 
Per_agriculture_share_in_GDP Public_health_expenditure; run;
proc factor data=mynewdata method=prin scree n=2 out=data1;
var Annual_growth_gdp GDP Internet_user_per1000 
Per_agriculture_share_in_GDP Public_health_expenditure; run;

/*********************Factor analysis with health and happiness indicators**/ 
proc corr data=mynewdata out=correl2;
var Suppresson_of_civil_liberty Satisfaction_with_life Institutional_quality
new_Human_rights Hunger Freedom_choose Freedom_of_speech; run;

proc factor data=mynewdata;
var Suppresson_of_civil_liberty Satisfaction_with_life Institutional_quality
new_Human_rights Hunger Freedom_choose Freedom_of_speech; run;

proc factor data=mynewdata method=prin scree;
var Suppresson_of_civil_liberty Satisfaction_with_life Institutional_quality
new_Human_rights Hunger Freedom_choose Freedom_of_speech; run;
proc factor data=mynewdata method=prin scree n=2 out=data1;
var Suppresson_of_civil_liberty Satisfaction_with_life Institutional_quality
new_Human_rights Hunger Freedom_choose Freedom_of_speech; run;

/*Factor analysis with corruption and malpractise indicators*/ 
proc corr data=mynewdata out=correl3;
var Alchohol_consumption Belif_in_god Control_of_corruption new_Human_rights; run;

proc factor data=mynewdata;
var Alchohol_consumption Belif_in_god Control_of_corruption new_Human_rights; run;

proc factor data=mynewdata method=prin scree;
var Alchohol_consumption Belif_in_god Control_of_corruption new_Human_rights; run;
proc factor data=mynewdata method=prin scree n=2 out=data1;
var Alchohol_consumption Belif_in_god Control_of_corruption new_Human_rights; run;

/*****************************Factor and cluster both*****************************************************/

/*Inequality indicators*/
 
proc factor data=mynewdata method=prin scree;
var new_Gini_Index new_Inequality_in_income 
Accept_of_incomeinequality new_Human_rights Hunger ;run;

/*Social indicators*/
proc factor data=mynewdata method=prin scree;
var HDI new_Human_rights Hunger new_Inequality_in_income 
Economic_Freedom_Index Freedom_choose Freedom_of_speech 
Institutional_quality  Alchohol_consumption Belif_in_god
Public_acceptance_of_suicide Control_of_corruption Average_self_ratedhealth
Public_health_expenditure Satisfaction_with_life Suppresson_of_civil_liberty
new_Human_rights Hunger; run;
/*Economic indicators*/
proc factor data=mynewdata method=prin scree rotate=varimax;
var Annual_growth_gdp 
Government_size Govt_Effenessectiv
Govt_inter_in_the_economy
new_Inequality_in_income  
Institutional_quality Internet_user_per1000 
Per_agriculture_share_in_GDP Public_acceptance_of_suicide
Public_health_expenditure Satisfaction_with_life Suppresson_of_civil_liberty
new_World_giving_Index; run;

/*Governmrnt sectors*/
proc factor data=mynewdata method=prin scree n=4 out=data_happiness;
var Government_size Govt_Effenessectiv
Govt_inter_in_the_economy; run;

/*Cluster*/
proc cluster data=work.data_happiness method=ward print=10 ccc pseudo;
var factor1 factor2 factor3;
copy HDI new_Human_rights Hunger new_Inequality_in_income 
Economic_Freedom_Index Freedom_choose Freedom_of_speech 
Institutional_quality  Alchohol_consumption Belif_in_god
Public_acceptance_of_suicide Control_of_corruption Average_self_ratedhealth
Public_health_expenditure Satisfaction_with_life Suppresson_of_civil_liberty
new_Human_rights Hunger; run;


proc tree noprint ncl=3 out=outmydata;
copy HDI new_Human_rights Hunger new_Inequality_in_income 
Economic_Freedom_Index Freedom_choose Freedom_of_speech 
Institutional_quality  Alchohol_consumption Belif_in_god
Public_acceptance_of_suicide Control_of_corruption Average_self_ratedhealth
Public_health_expenditure factor1 factor2 factor3; run;   