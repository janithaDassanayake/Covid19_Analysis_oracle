


--------------------------------memeber funtions-------------------------

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION numberOf_CLOSED_CASES
RETURN NUMBER CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION numberOf_Active_Cases 
RETURN NUMBER CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION covid_mortality_Rate
RETURN FLOAT CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION Active_Cases_Rate
RETURN FLOAT CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION covid_recover_Rate
RETURN FLOAT CASCADE;



CREATE OR REPLACE TYPE BODY panademic_info_t 
AS MEMBER FUNCTION 
numberOf_CLOSED_CASES
RETURN NUMBER IS 
	BEGIN 
		 RETURN SELF.no_of_covid_Recovered + SELF.no_of_covid_deaths ;
	END numberOf_CLOSED_CASES; 
	
    
    
MEMBER FUNCTION 
numberOf_Active_Cases 
RETURN NUMBER IS 
	BEGIN 
		 RETURN SELF.no_of_covid_confirmed -SELF.no_of_covid_Recovered -SELF.no_of_covid_deaths ;
	END numberOf_Active_Cases ; 
	   
    
MEMBER FUNCTION covid_mortality_Rate
RETURN FLOAT IS
	confirmed NUMBER;
	BEGIN
	confirmed :=1;
	IF self.no_of_covid_confirmed >0 THEN
		confirmed :=self.no_of_covid_confirmed;
	END IF;
	
	RETURN (self.no_of_covid_deaths /confirmed)*100; 		
	
	END covid_mortality_Rate;



MEMBER FUNCTION Active_Cases_Rate
RETURN FLOAT IS
	confirmed NUMBER;
    x NUMBER;
    
	BEGIN
	confirmed :=1;
	IF self.no_of_covid_confirmed >0 THEN
		confirmed :=self.no_of_covid_confirmed;
	END IF;
    
    x:= SELF.no_of_covid_confirmed -SELF.no_of_covid_Recovered -SELF.no_of_covid_deaths ;
	
	RETURN (x /confirmed)*100; 	
	
	END Active_Cases_Rate;



MEMBER FUNCTION covid_recover_Rate
RETURN FLOAT IS
	confirmed NUMBER;
	BEGIN
	confirmed :=1;
	IF self.no_of_covid_confirmed >0 THEN
		confirmed :=self.no_of_covid_confirmed;
	END IF;
	
	RETURN (self.no_of_covid_Recovered /confirmed)*100; 	
	
	END covid_recover_Rate;

END;






--------------------------------report OR SQL-------------------------


SELECT  SUM(p.no_of_covid_confirmed)AS Total_confirmed,
        SUM(p.no_of_covid_deaths)AS Total_confirmed,
        SUM(p.no_of_covid_recovered) AS Total_recovered,
           SUM(p.numberOf_Active_Cases())AS Total_Active_cases,
             SUM(p.numberOf_CLOSED_CASES())AS Total_Closed_Cases,
              p.pdate AS Till_21_MAR_2020  
              
FROM 
    panademic_info p 
WHERE  
     p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0
GROUP  
      by p.pdate;




SELECT
       p.cid.country_Region AS country,
            p.cid.province_State  AS state,
                SUM(p.no_of_covid_confirmed)AS total_confirmed,
                     SUM(p.no_of_covid_deaths) AS total_DEATH,
                     ROUND( p.covid_mortality_Rate(),4) AS Mortality_rate
                    
FROM 
      panademic_info p
WHERE 
        p.pdate = '21-MAR-2020' AND p.no_of_covid_confirmed>0
GROUP BY 
        p.cid.country_Region,ROUND( p.covid_mortality_Rate(),4),p.cid.province_State
/








SELECT
       p.cid.country_Region AS country,
            p.cid.province_State  AS state,
                SUM(p.no_of_covid_confirmed)AS total_confirmed,
                     SUM(p.no_of_covid_recovered) AS total_recovered,
                     ROUND( p.covid_recover_Rate(),4) AS Recovery_rate
                    
FROM 
      panademic_info p
WHERE 
        p.pdate = '21-MAR-2020' AND p.no_of_covid_confirmed>0
GROUP BY 
        p.cid.country_Region,ROUND( p.covid_recover_Rate(),4),p.cid.province_State
/








SELECT
       p.cid.country_Region AS country,
            p.cid.province_State  AS state,
                SUM(p.no_of_covid_confirmed)AS total_confirmed,
                     SUM(p.numberOf_CLOSED_CASES()) AS total_Closed_Cases,
                      ROUND(SUM(p.numberOf_CLOSED_CASES())/SUM(p.no_of_covid_confirmed)*100,4) AS CLOSED_CASES_RATE
                    
FROM 
      panademic_info p
WHERE 
        p.pdate = '21-MAR-2020' AND p.no_of_covid_confirmed>0 
GROUP BY 
        p.cid.country_Region,p.cid.province_State
/






SELECT
       p.cid.country_Region AS country,
            p.cid.province_State  AS state,
                SUM(p.no_of_covid_confirmed)AS total_confirmed,
                     SUM(p.numberOf_Active_Cases ()) AS total_Active_Cases,
                        ROUND( p.Active_Cases_Rate(),4) AS ACTIVE_CASES_RATE
                    
FROM 
      panademic_info p
WHERE 
        p.pdate = '21-MAR-2020' AND p.no_of_covid_confirmed>0 
GROUP BY 
        p.cid.country_Region,ROUND( p.Active_Cases_Rate(),4),p.cid.province_State
/





SELECT 
p.pdate AS Till_21_MAR_2020  ,
    SUM(p.no_of_covid_confirmed)AS confirmed ,
         sum(p.no_of_covid_deaths) AS deaths ,
           ROUND(SUM(p.covid_mortality_Rate()),3) AS motality_Rate,
             SUM(p.no_of_covid_recovered) AS recovered,
               ROUND(SUM(p.covid_recover_Rate()),3) AS Recovery_Rate,
                 SUM(p.numberOf_Active_Cases()) AS Active_cases,
                  ROUND(SUM(p.Active_Cases_Rate()),3) AS Active_Rate,
                  SUM(p. numberOf_CLOSED_CASES()) AS closed_cases,
                   ROUND(SUM(p.numberOf_CLOSED_CASES())/SUM(p.no_of_covid_confirmed)*100,4) AS CLOSED_CASES_RATE
                 
FROM 
     panademic_info p 
WHERE 
      p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0 AND p.cid.country_Region ='China'
GROUP by
      p.pdate;








SELECT 
p.pdate AS Till_21_MAR_2020  ,
    SUM(p.no_of_covid_confirmed)AS confirmed ,
         sum(p.no_of_covid_deaths) AS deaths ,
           ROUND(SUM(p.covid_mortality_Rate()),3) AS motality_Rate,
             SUM(p.no_of_covid_recovered) AS recovered,
               ROUND(SUM(p.covid_recover_Rate()),3) AS Recovery_Rate,
                 SUM(p.numberOf_Active_Cases()) AS Active_cases,
                  ROUND(SUM(p.Active_Cases_Rate()),3) AS Active_Rate,
                  SUM(p. numberOf_CLOSED_CASES()) AS closed_cases,
                   ROUND(SUM(p.numberOf_CLOSED_CASES())/SUM(p.no_of_covid_confirmed)*100,4) AS CLOSED_CASES_RATE
                 
FROM 
     panademic_info p 
WHERE 
        p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0 AND NOT p.cid.country_Region='China' 
GROUP by
      p.pdate;





SELECT p.cid.country_Region AS country ,
     p.cid.province_State AS State ,
    SUM(p.no_of_covid_confirmed)AS confirmed ,
         sum(p.no_of_covid_deaths) AS deaths ,
           ROUND(SUM(p.covid_mortality_Rate()),3) AS motality_Rate,
             SUM(p.no_of_covid_recovered) AS recovered,
               ROUND(SUM(p.covid_recover_Rate()),3) AS Recovery_Rate,
                 SUM(p.numberOf_Active_Cases()) AS Active_cases,
                  ROUND(SUM(p.Active_Cases_Rate()),3) AS Active_Rate,
                  SUM(p. numberOf_CLOSED_CASES()) AS closed_cases,
                   ROUND(SUM(p.numberOf_CLOSED_CASES())/SUM(p.no_of_covid_confirmed)*100,4) AS CLOSED_CASES_RATE     
FROM  panademic_info p
WHERE  p.pdate = '21-MAR-2020' AND
                 p.no_of_covid_confirmed IN
                                (SELECT sum(p.no_of_covid_confirmed) 
                                 from panademic_info p
                                 group by p.no_of_covid_confirmed
                                 HAVING sum(p.no_of_covid_confirmed)>10000) 
GROUP BY   p.cid.country_Region,p.cid.province_State,p.no_of_covid_confirmed

HAVING SUM(p.no_of_covid_Recovered) < SUM(p.no_of_covid_deaths) 
/


      select *
      from panademic_info;

 
 
 
 
 
