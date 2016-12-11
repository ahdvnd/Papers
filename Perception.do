* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off
cd "/Users/Hadzzz/Desktop"
clear
quietly infix              ///
  int     year      1-4    ///
  long    serial    5-9    ///
  float   hwtsupp   10-19  ///
  double  cpsid     20-33  ///
  byte    asecflag  34-34  ///
  byte    month     35-36  ///
  byte    pernum    37-38  ///
  double  cpsidp    39-52  ///
  float   wtsupp    53-62  ///
  byte    famsize   63-64  ///
  double  ftotval   65-74  ///
  using `"cps_00020.dat"'

replace hwtsupp  = hwtsupp  / 10000
replace wtsupp   = wtsupp   / 10000

format hwtsupp  %10.4f
format cpsid    %14.0f
format cpsidp   %14.0f
format wtsupp   %10.4f
format ftotval  %10.0f

label var year     `"Survey year"'
label var serial   `"Household serial number"'
label var hwtsupp  `"Household weight, Supplement"'
label var cpsid    `"CPSID, household record"'
label var asecflag `"Flag for ASEC"'
label var month    `"Month"'
label var pernum   `"Person number in sample unit"'
label var cpsidp   `"CPSID, person record"'
label var wtsupp   `"Supplement Weight"'
label var famsize  `"Number of own family members in hh"'
label var ftotval  `"Total family income"'

label define asecflag_lbl 1 `"ASEC"'
label define asecflag_lbl 2 `"March Basic"', add
label values asecflag asecflag_lbl

label define month_lbl 01 `"January"'
label define month_lbl 02 `"February"', add
label define month_lbl 03 `"March"', add
label define month_lbl 04 `"April"', add
label define month_lbl 05 `"May"', add
label define month_lbl 06 `"June"', add
label define month_lbl 07 `"July"', add
label define month_lbl 08 `"August"', add
label define month_lbl 09 `"September"', add
label define month_lbl 10 `"October"', add
label define month_lbl 11 `"November"', add
label define month_lbl 12 `"December"', add
label values month month_lbl

label define famsize_lbl 00 `"Missing"'
label define famsize_lbl 01 `"1 family member present"', add
label define famsize_lbl 02 `"2 family members present"', add
label define famsize_lbl 03 `"3 family members present"', add
label define famsize_lbl 04 `"4 family members present"', add
label define famsize_lbl 05 `"5 family members present"', add
label define famsize_lbl 06 `"6 family members present"', add
label define famsize_lbl 07 `"7 family members present"', add
label define famsize_lbl 08 `"8 family members present"', add
label define famsize_lbl 09 `"9 family members present"', add
label define famsize_lbl 10 `"10 family members present"', add
label define famsize_lbl 11 `"11 family members present"', add
label define famsize_lbl 12 `"12 family members present"', add
label define famsize_lbl 13 `"13 family members present"', add
label define famsize_lbl 14 `"14 family members present"', add
label define famsize_lbl 15 `"15 family members present"', add
label define famsize_lbl 16 `"16 family members present"', add
label define famsize_lbl 17 `"17 family members present"', add
label define famsize_lbl 18 `"18 family members present"', add
label define famsize_lbl 19 `"19 family members present"', add
label define famsize_lbl 20 `"20 family members present"', add
label define famsize_lbl 21 `"21 family members present"', add
label define famsize_lbl 22 `"22 family members present"', add
label define famsize_lbl 23 `"23 family members present"', add
label define famsize_lbl 24 `"24 family members present"', add
label define famsize_lbl 25 `"25 family members present"', add
label define famsize_lbl 26 `"26 family members present"', add
label define famsize_lbl 27 `"27 family members present"', add
label define famsize_lbl 28 `"28 family members present"', add
label define famsize_lbl 29 `"29 family members present"', add
label values famsize famsize_lbl




// Calculating net earnings
gen dpi=ftotval 
// drop if dpi==.    
   

// Variable trim chops off the top and the bottom of the income distribution
// Variable wins winsorizes the top and bottom of the income distribution (trims and add to the lowest and highest bins)
replace dpi=dpi/ (famsize^0.5) 
qui sum dpi [w=hwtsupp], de 
gen trim=dpi if dpi>=r(p1) & dpi<=r(p99)//gen wins=dpireplace dpi=0 if dpi<0replace dpi=r(p99) if dpi>r(p99)


// The following code are for dividing the income distribution into 7 equal bins
qui sum dpi [w=hwtsupp], de 
gen dif=r(max)-r(min)

     
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
      
tab binn  
hist dpi, bin(7) kden
  
