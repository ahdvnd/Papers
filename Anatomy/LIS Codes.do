
//This is the code I use for LIS household


// STATA commands for inequality perception paper 
// These commands use Luxembourg Income Study Data. Before running the code, you first need to request for an access to LIS data. 
// You then need to use the LISSY Java Interface to run the codes. 
 
// The following commands use household level data for the United States in 2010. 
 
foreach ccyy in  us10 au10 tw10 cz10 dk10 ee10 fi10 fr10 de10 hu09 is10 it10 jp08 kr10 no10 pl10 ru10 sk10 si10 za10 es10 uk10 {         
di "`ccyy'"         
use age dhi nhhmem hpopwgt using $`ccyy'h, clear       
 

scalar trimrange = 99
scalar agemin = 19
scalar agemax=69




drop if age<agemin                       
drop if age>agemax

// Grouping age
//recode age (min/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=6) (50/54=7) (55/59=8) (60/64=9) (65/69=10) (70/74=11) (75/max=12)
//recode age (min/29=1) (30/39=2) (40/49=3) (50/59=4) (60/max=5)
               
// Grouping education
//drop if educ99==.
//recode educ99 (0/9=1) (10/14=2) (15/18=3), gen(edu) // low = 0-12 grade but no degree, medium = high school degree, high = more than high school

// Grouping occupations
//drop if occ2010==.
//recode occ2010 (0/999=0) (1000/1999=1) (2000/2999=2) (3000/3999=3) (4000/4999=4) (5000/5999=5) (6000/6999=6) (7000/7999=7) (8000/8999=8) (9000/9999=9)


// Variable trim chops off the top and the bottom of the income distribution
// Variable wins winsorizes the top and bottom of the income distribution (trims and add to the lowest and highest bins)

 
// Calculating net earnings 
gen dpi=dhi   
drop if dpi==.     

replace dpi=dpi/ (nhhmem^0.5) 
qui sum dpi [w=hpopwgt], de 

replace dpi=0 if dpi<0
replace dpi=r(p`=trimrange') if dpi>r(p`=trimrange')

  
 
qui sum dpi [w=hpopwgt], de      
 
// The following code are for dividing the income distribution into 7 equal bins 
     
scalar dif=r(max)-r(min)     
      
scalar bin1=r(min)+dif/7      
scalar bin2=r(min)+dif*2/7      
scalar bin3=r(min)+dif*3/7      
scalar bin4=r(min)+dif*4/7      
scalar bin5=r(min)+dif*5/7      
scalar bin6=r(min)+dif*6/7      
scalar bin7=r(min)+dif     
      
gen binn=0      
replace binn=1 if (dpi<bin1)      
replace binn=2 if (dpi<bin2) & (dpi>=bin1)      
replace binn=3 if (dpi<bin3) & (dpi>=bin2)      
replace binn=4 if (dpi<bin4) & (dpi>=bin3)      
replace binn=5 if (dpi<bin5) & (dpi>=bin4)      
replace binn=6 if (dpi<bin6) & (dpi>=bin5)      
replace binn=7 if (dpi<=bin7) & (dpi>=bin6)      
       
di "`ccyy'" 
tab binn      
      
}         
 