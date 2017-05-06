cd "/Users/Hadzzz/GitHub/Papers/IneqEdu-Credit-Constraint/Analysis NLSY"
cls
clear
use "NLSYdata.dta"

set more off

label define vlR0000100   0 "0"
label values r0000100 vlR0000100
label define vlR0536300   1 "Male"  2 "Female"  0 "No Information"
label values r0536300 vlR0536300
label define vlR0536401   1 "1: January"  2 "2: February"  3 "3: March"  4 "4: April"  5 "5: May"  6 "6: June"  7 "7: July"  8 "8: August"  9 "9: September"  10 "10: October"  11 "11: November"  12 "12: December"
label values r0536401 vlR0536401
label define vlR0609800   0 "0"
label values r0609800 vlR0609800
label define vlR0609900   1 "A.  $1               -       $5,000"  2 "B.   $5,001      -     $10,000"  3 "C.   $10,001    -     $25,000"  4 "D.   $25,001    -     $50,000"  5 "E.    $50,001   -    $100,000"  6 "F.    $100,001       $250,000"  7 "G.    More than $250,000"
label values r0609900 vlR0609900
label define vlR1235800   1 "Cross-sectional"  0 "Oversample"
label values r1235800 vlR1235800
label define vlR1482600   1 "Black"  2 "Hispanic"  3 "Mixed Race (Non-Hispanic)"  4 "Non-Black / Non-Hispanic"
label values r1482600 vlR1482600
label define vlR9829600   0 "0"
label values r9829600 vlR9829600
label define vlT8122500   429 "Month of current release in a continuous month format"
label values t8122500 vlT8122500
label define vlT8976700   0 "0"
label values t8976700 vlT8976700
label define vlT8976800   1 "A. $1 - $5,000"  2 "B. $5,001 - $10,000"  3 "C. $10,001 - $25,000"  4 "D. $25,001 - $50,000"  5 "E. $50,001 - $100,000"  6 "F. $100,001 - $250,000"  7 "G. More than $250,000"
label values t8976800 vlT8976800
label define vlZ9033700   1 "200 - 300"  2 "301 - 400"  3 "401 - 500"  4 "501 - 600"  5 "601 - 700"  6 "701 - 800"  0 "Have not yet received the scores"
label values z9033700 vlZ9033700
label define vlZ9083800   0 "None"  1 "1st grade"  2 "2nd grade"  3 "3rd grade"  4 "4th grade"  5 "5th grade"  6 "6th grade"  7 "7th grade"  8 "8th grade"  9 "9th grade"  10 "10th grade"  11 "11th grade"  12 "12th grade"  13 "1st year college"  14 "2nd year college"  15 "3rd year college"  16 "4th year college"  17 "5th year college"  18 "6th year college"  19 "7th year college"  20 "8th year college or more"  95 "Ungraded"
label values z9083800 vlZ9083800
label define vlZ9083900   0 "None"  1 "GED"  2 "High school diploma (Regular 12 year program)"  3 "Associate/Junior college (AA)"  4 "Bachelor's degree (BA, BS)"  5 "Master's degree (MA, MS)"  6 "PhD"  7 "Professional degree (DDS, JD, MD)"
label values z9083900 vlZ9083900
/* Crosswalk for Reference number & Question name
 * Uncomment and edit this RENAME statement to rename variables for ease of use.
 * This command does not guarantee uniqueness
 */
  /* *start* */
/*
  rename R0000100 PUBID_1997 
  rename R0536300 KEY!SEX_1997 
  rename R0536401 KEY!BDATE_M_1997 
  rename R0536402 KEY!BDATE_Y_1997 
  rename R0609800 P5_016_1997   // P5-016
  rename R0609900 P5_017_1997   // P5-017
  rename R1235800 CV_SAMPLE_TYPE_1997 
  rename R1482600 KEY!RACE_ETHNICITY_1997 
  rename R9829600 ASVAB_MATH_VERBAL_SCORE_PCT_1999 
  rename T8122500 VERSION_R16_2013 
  rename T8976700 YINC_1700_2013   // YINC-1700
  rename T8976800 YINC_1800_2013   // YINC-1800
  rename Z9033700 CVC_SAT_MATH_SCORE_2007_XRND 
  rename Z9083800 CVC_HGC_EVER_XRND 
  rename Z9083900 CVC_HIGHEST_DEGREE_EVER_XRND 
*/
  /* *end* */  
/* To convert variable names to lower case use the TOLOWER command 
 *      (type findit tolower and follow the links to install).
 * TOLOWER VARLIST will change listed variables to lower case; 
 *  TOLOWER without a specified variable list will convert all variables in the dataset to lower case
 */
/* tolower */



rename r0536300 sex
rename r0609800 parinc
rename r1482600 race
rename r9829600	ability
rename t8976700 inc
rename z9083900 degree
rename z9033700 satscore
rename z9083800 yrsschool


drop if yrsschool==95


foreach var of varlist _all {
	qui replace `var' = . if (`var' == - 1 | `var' == - 2 | `var' == - 3 | `var' == - 4 | `var' == - 5 | `var' == 999999)
	}
	

// none/GED(1), highschool/associate(2), bachelor and above(3)
qui recode degree (0 1 2=1) (3=2) (4/7=3)

drop if parinc==.
drop if ability==.
qui egen meanpi = mean(parinc)
qui egen meanability = mean(ability)
replace meanability = 1.1 * meanability
replace meanpi = 1.1 * meanpi


qui gen group = 0
qui replace group = 1 if (ability < meanability) & (parinc < meanpi)
qui replace group = 2 if (ability < meanability) & (parinc >= meanpi)
qui replace group = 3 if (ability >= meanability) & (parinc < meanpi)
qui replace group = 4 if (ability >= meanability) & (parinc >= meanpi)

sort group
by group: sum yrsschool
tab group, sum(yrsschool)




