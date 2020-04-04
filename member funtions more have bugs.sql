SELECT 
   SUM(p.no_of_covid_confirmed)AS Total_confirmed_cases ,
         sum(p.no_of_covid_deaths) AS Total_deaths ,
             SUM(p.no_of_covid_recovered) AS Total_recovered,
              SUM(p.numberOf_non_recover())AS Total_NOT_recovered,
                ROUND(SUM(p.covid_mortality_rate()),3) AS motalityRAte,
                    p.pdate AS Till_21_MAR_200     
FROM panademic_info p 
WHERE p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0
GROUP by p.pdate;





SELECT 
   SUM(p.no_of_covid_confirmed)AS Total_confirmed_cases ,
         sum(p.no_of_covid_deaths) AS Total_deaths ,
             SUM(p.no_of_covid_recovered) AS Total_recovered,
              SUM(p.numberOf_non_recover())AS Total_NOT_recovered,
                ROUND(SUM(p.covid_mortality_rate()),3) AS motalityRAte,
                    p.pdate AS Till_21_MAR_200     
FROM panademic_info p 
WHERE p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0 AND p.cid.country_Region ='China'
GROUP by p.pdate;




SELECT 
   SUM(p.no_of_covid_confirmed)AS Total_confirmed_cases ,
         sum(p.no_of_covid_deaths) AS Total_deaths ,
            p.maxDEATH(),
             SUM(p.no_of_covid_recovered) AS Total_recovered,
              SUM(p.numberOf_non_recover())AS Total_NOT_recovered,
                ROUND(SUM(p.covid_mortality_rate()),3) AS motalityRAte,
                
                    p.pdate AS Till_21_MAR_2020     
FROM panademic_info p 
WHERE p.pdate='21-MAR-2020' AND p.no_of_covid_confirmed>0 AND NOT p.cid.country_Region='China' 
GROUP by p.pdate,p.maxDEATH();

























SELECT p.cid.country_Region AS country ,
     p.cid.province_State AS State ,
      p.Growth_Factor_of_Monthly_New_Cases(),
         SUM(p.no_of_covid_Recovered )AS total_Recovered,
             SUM(p.no_of_covid_deaths)AS total_DEATH,
             sum(p.no_of_covid_confirmed)AS total_confirmed
FROM 
     panademic_info p
WHERE 
    p.pdate = '21-MAR-2020' AND
                 p.no_of_covid_confirmed IN
                                (SELECT sum(p.no_of_covid_confirmed) 
                                 from panademic_info p
                                 group by p.no_of_covid_confirmed
                                 HAVING sum(p.no_of_covid_confirmed)>1000) 
GROUP BY   p.cid.country_Region,p.cid.province_State,p.no_of_covid_confirmed,p.Growth_Factor_of_Monthly_New_Cases()

HAVING SUM(p.no_of_covid_Recovered)
                     < SUM(p.no_of_covid_deaths) 
/



SELECT
       p.cid.country_Region AS country,
            p.cid.province_State  AS state,
                SUM(p.no_of_covid_confirmed)AS total_confirmed,
                 SUM(p.no_of_covid_Recovered) AS total_Recovered,
                  ROUND( p.covid_recoverRate(),3)AS Recovery_Rate,
                     SUM(p.no_of_covid_deaths) AS total_DEATH,
                     ROUND( p.covid_mortality_rate(),3) AS mortality_rate
                    
FROM 
      panademic_info p
WHERE 
        p.pdate = '21-MAR-2020' AND p.no_of_covid_confirmed>0
GROUP BY 
        p.cid.country_Region,ROUND( p.covid_recoverRate(),3),ROUND( p.covid_mortality_rate(),3),p.cid.province_State
/







SELECT
     p.cid.province_State AS State ,
        SUM(p.no_of_covid_deaths)AS total_DEATH,
             SUM(p.no_of_covid_Recovered  )AS total_Recovered,
                  sum(p.no_of_covid_confirmed)AS total_confirmed
                    
FROM  panademic_info p
WHERE  p.pdate = '21-MAR-2020' AND p.cid.country_Region ='US'
                                            
GROUP BY 
        p.cid.province_State,p.no_of_covid_confirmed
HAVING  SUM(p.no_of_covid_Recovered)
                           < SUM(p.no_of_covid_deaths)
/







SELECT
     p.cid.country_Region AS country,
       SUM(p.no_of_covid_confirmed) AS confirmed_patients,
          SUM(p.no_of_covid_Recovered) AS Recovered_patients,
            SUM(p.no_of_covid_deaths)AS died_patients,
               p.numberOf_non_recover() AS Not_recoverd_patients,
                 p.cid.latitude AS latitude,
                   p.cid.longtude as longtude
                                                
FROM panademic_info p
WHERE p.no_of_covid_confirmed>0 AND  p.pdate = '21-MAR-2020'
GROUP BY 
        p.cid.country_Region, p.cid.latitude, p.cid.longtude, p.numberOf_non_recover()
HAVING p.numberOf_non_recover()>10000

/










SELECT p.cid.country_Region AS country, 
    SUM(p.no_of_covid_confirmed) AS confirmed_patients,
         ROUND ( AVG(p.no_of_covid_Recovered),2) AS Avarage_Recovered_patients,
           ROUND ( AVG(p.no_of_covid_deaths),2) AS Avarage_died_patients,    
              ROUND ( AVG(p.numberOf_non_recover()),2)AS Avarage_not_Recovered_patients 
                                   
FROM panademic_info p
WHERE p.no_of_covid_confirmed>0 AND  p.pdate = '21-MAR-2020'
      
GROUP BY  p.cid.country_Region
        
HAVING SUM(p.no_of_covid_Recovered) < SUM(p.no_of_covid_deaths);



SELECT DISTINCT p.cid.country_Region AS country, 
        p.cid.province_State  AS state,     
              ROUND (p.covid_mortality_rate(),3) AS mortality_rate                              
FROM panademic_info p
WHERE p.no_of_covid_confirmed>0 AND  p.pdate = '21-MAR-2020'
      
GROUP BY  p.cid.country_Region,ROUND (p.covid_mortality_rate(),3),p.cid.province_State ;
        









ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION numberOf_CLOSED_CASES
RETURN NUMBER CASCADE;



ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION numberOf_non_recover
RETURN NUMBER CASCADE;


ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION covid_mortality_rate
RETURN FLOAT CASCADE;



ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION non_recover_rate
RETURN FLOAT CASCADE;


ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION covid_recoverRate
RETURN FLOAT CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION Growth_Factor_of_Monthly_New_Cases
RETURN FLOAT CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION maximum_Comfirmed_Count
RETURN NUMBER CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION maximum_recover_Count
RETURN NUMBER CASCADE;

ALTER TYPE panademic_info_t 
ADD MEMBER FUNCTION maximum_death_Count
RETURN NUMBER CASCADE;




CREATE OR REPLACE TYPE BODY panademic_info_t 
AS MEMBER FUNCTION 
numberOf_non_recover
RETURN NUMBER IS 
	BEGIN 
		 RETURN SELF.no_of_covid_confirmed -SELF.no_of_covid_Recovered -SELF.no_of_covid_deaths ;
	END numberOf_non_recover; 
	
MEMBER FUNCTION covid_mortality_rate
RETURN FLOAT IS
	confirmed NUMBER;
	BEGIN
	confirmed :=1;
	IF self.no_of_covid_confirmed >0 THEN
		confirmed :=self.no_of_covid_confirmed;
	END IF;
	
	RETURN (self.no_of_covid_deaths /confirmed)*100; 		
	
	END covid_mortality_rate;



MEMBER FUNCTION non_recover_rate
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
	
	END non_recover_rate;




MEMBER FUNCTION covid_recoverRate
RETURN FLOAT IS
	confirmed NUMBER;
	BEGIN
	confirmed :=1;
	IF self.no_of_covid_confirmed >0 THEN
		confirmed :=self.no_of_covid_confirmed;
	END IF;
	
	RETURN (self.no_of_covid_Recovered /confirmed)*100; 	
	
	END covid_recoverRate;


MEMBER FUNCTION Growth_Factor_of_Monthly_New_Cases
RETURN FLOAT IS
	
 	x NUMBER;
    y NUMBER;

	BEGIN
    x :=1;
    y:=1;
    
	IF self.pdate = '21-MAR-2020'  THEN
		x :=self.no_of_covid_confirmed;
    ELSIF self.pdate ='21-FEB-2020' THEN
        y:=self.no_of_covid_confirmed;
	END IF;
	
	RETURN   x/y;
    
	END Growth_Factor_of_Monthly_New_Cases;
    
    
    MEMBER FUNCTION maximum_Comfirmed_Count
RETURN NUMBER IS
	maximumComfirmed_Count NUMBER; 
	BEGIN 
		SELECT  MAX(p.no_of_covid_confirmed) INTO maximumComfirmed_Count
                FROM panademic_info p;
		        RETURN maximumComfirmed_Count;
	END maximum_Comfirmed_Count; 
	
    
MEMBER FUNCTION maximum_recover_Count
RETURN NUMBER IS
	maximum_recoverCount NUMBER; 
	BEGIN 
		SELECT  MAX(p.no_of_covid_Recovered) INTO maximum_recoverCount
                FROM panademic_info p;
		        RETURN maximum_recoverCount;
	END maximum_recover_Count;  

    
MEMBER FUNCTION maximum_death_Count
RETURN NUMBER IS
	maximum_deathcount NUMBER; 
	BEGIN 
		SELECT  MAX(p.no_of_covid_deaths) INTO maximum_deathcount
                FROM panademic_info p;
		        RETURN maximum_deathcount;
	END maximum_death_Count;  
    
    
    
END;











SELECT SUM(p.no_of_covid_confirmed)AS Total_confirmed_cases ,
         sum(p.no_of_covid_deaths) AS Total_deaths ,
             SUM(p.no_of_covid_recovered) AS Total_recovered,
              SUM(p.numberOf_non_recover())AS Total_NOT_recovered,
              SUM(p.covid_mortality_rate())AS mortalatyrate,
              p.pdate AS Till_21_MAR_200
FROM panademic_info p
WHERE p.pdate='21-MAR-2020'
GROUP by p.pdate
;



SELECT  p.cid.province_State,  p.Growth_Factor_of_Monthly_New_Cases()
FROM panademic_info p
WHERE p.cid.country_Region  ='China';