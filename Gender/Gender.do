//Stata Codes for accessing data from LIS and creating the tables   
   
foreach ccyy in  us13 us79  {                              
di "`ccyy'"                              
use age sex pi immigr enroll educ educ_c nchildren occb1 hours marital emp ethnic_c pxit using $`ccyy'p, clear                              
                          
gen dpi=pi-pxit                    
gen hrs=hours                          
 
// us13 us10 us07 us04 us00 us97 us94 us91 us86 us79                 
drop if dpi==.  
//drop if ethnic_c==. 
drop if age<35                            
drop if age>69 
 
//keep if emp==1          

drop if hrs<=0                      
drop if hrs==.
keep if hrs>=20
                           
//drop if dpi<=0                     
//drop if educ==.               
//drop if educ_c==.                                                
//drop if marital==.    
//drop if nchildren==.   
//drop if immigr==.        
//drop if occb1==. | occb1==10            
        
      

//pshare estimate dpi, nquantiles(10)      
//pshare estimate dpi if sex==1, nquantiles(10)     
//pshare estimate dpi if sex==2, nquantiles(10)     
      
    
 
//drop if ethnic_c > 4       
//recode ethnic_c (1=1) (3=2) (2 4=3), gen(race2) // Racial Categories: 1=white 2=black 3=hispanic                      
             
             
recode age (min/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=6) (50/54=7) (55/59=8) (60/64=9) (65/max=10), gen(age2)                   
//recode age (min/29=1) (30/39=2) (40/49=3) (50/59=4) (60/69=5) (70/max=6), gen(age3)             
           
//recode educ (002/071=1) (073=2) (081/092=3) (111=4) (123/125=5), gen(educ2) // Educational groups 1=less than HS 2=HS 3=Some college 4=College 5=Graduate Degree                    
//recode marital (110=1) (210/223 = 0), gen(marst2) // Marital categories: 0=umnarried 1=married                     
//recode occ2010 (0010/3540=1) (3600/4650=2) (4700/5940=3) (6000/7630=4) (7700/9750=4), gen(occucat) //occupational categories 1=abstract 2=manual 3=cognitive-routine 4=manual-routine             
//sex categories 1=male 2=female             
//drop if race2==5  //getting rid of "Other" as race category             
       
//egen sex_age=group(sex age2)       
             
            
// Autor's calculations            
//recode occb1 (1/3=1) (5=2) (4=3) (6/9=4), gen(occat)            
//drop if occat>4  
//tab sex_race_age if occat==1 nofreq
//tab sex_race_age if occat==2 nofreq
//tab sex_race_age if occat==3 nofreq
//tab sex_race_age nofreq          

//tab occat            
//tab occat if sex==1            
//tab occat if sex==2            
//tab occat, sum(dpi)            
//tab occat if sex==1, sum(dpi)            
//tab occat if sex==2, sum(dpi)    

         
        
//drop if enroll==.        
//keep if enroll==200        
       
 
   
ineqdeco dpi, by(sex_age) 
 
//tab sex_race_age, sum(marst2) nostandard nofreq //for calculating the share married in each cohort             
//tab sex_race_age, sum(nchildren) nomeans nofreq //for calculating the variance of # of children in each cohort             
//tab sex_race_age if immigr==1              
//tab sex_race_age if educ_c>=34 
//tab sex_race_age //for calculating the share of foreign-born individuals in each cohort               
         
                  
}     
