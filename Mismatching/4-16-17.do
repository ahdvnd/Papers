cd "/Users/Hadzzz/Google Drive/Research/Mismatching/Regression Files"
clear
use 4-18-17.dta


set more off

*use data_merged.dta

*preserve

drop MTWStatus

drop if degree != 4
*drop if race_ethnicity == 3
*drop if race==3 | race==4 

* Getting rid of outliers and normalizing the matching score
qui sum matching_score, de

drop if matching_score > r(p99)

qui sum matching_score, de
gen matching_score_norm = 100*(matching_score - r(min))/(r(max) - r(min))

* This creates the matching z-score
egen matching_z_score = std(matching_score)


foreach var of varlist _all {
	replace `var' = . if (`var' == - 2 | `var' == - 3 | `var' == - 4 | `var' == - 5 | `var' == 999999)
	}

	
* we should make sure that wage year and most recent occupation data are from the same year. 
gen log_wage = log(wage_2012)
//gen exp = exp_wk_adult
gen exp = exp_wk_employee_adult
gen exp_sqrd = exp^2
gen exp2=exp/52
gen exp2sq=exp2^2
recode marital_status (0 2 3 4=0) (1=1), gen(married)
recode gender (1=0) (2=1)
gen matchxgender = matching_score_norm * gender
gen matchzxgender = matching_z_score * gender
recode citizen_status (1=1) (2 4 6=0)
gen mxgender  = matching_score * gender

// This is the variable for rural/urban, 2 is for unknown
*drop if T8134500==2


// Categorizing majors
// This categories are for those who received their major before 2010
// The major codes for before 2010 was based on NLSY's own coding that you can find here:
// https://github.com/ahdvnd/Papers/blob/master/Mismatching/NLSY%20Major%20Codes.png

gen major = .
replace major=1 if (highest_major == 07 | highest_major == 37) & year_ba<2010 //BusMgmt
replace major=2 if highest_major == 06 & year_ba<2010 //Bio
replace major=3 if highest_major == 08 & year_ba<2010 //Comm
replace major=4 if highest_major == 09 & year_ba<2010 //Comp
replace major=5 if highest_major == 04 & year_ba<2010 //Archct
replace major=6 if highest_major == 11 & year_ba<2010 //Econ
replace major=7 if highest_major == 12 & year_ba<2010 //Edu
replace major=8 if highest_major == 13 & year_ba<2010 //Engin
replace major=9 if highest_major == 14 & year_ba<2010 //English
replace major=10 if highest_major == 16 & year_ba<2010 //Art
replace major=11 if highest_major == 01 & year_ba<2010 //Ag
replace major=12 if highest_major == 17 & year_ba<2010 //ForLang
replace major=13 if (highest_major == 03 | highest_major == 18) & year_ba<2010  //ArchHist
replace major=14 if (highest_major == 10 | highest_major == 28 | highest_major == 47) & year_ba<2010  //LawCrim
replace major=15 if highest_major == 21 & year_ba<2010 //Math
replace major=16 if (highest_major == 22 | highest_major == 23 | highest_major == 27 | highest_major == 29 | highest_major == 30 | highest_major == 36) & year_ba<2010 //Med
replace major=17 if highest_major == 24 & year_ba<2010 //Phil
replace major=18 if (highest_major == 25 | highest_major == 48) & year_ba<2010 //Physic
replace major=19 if highest_major == 31 & year_ba<2010 //Psych
replace major=20 if (highest_major == 02 | highest_major == 05 | highest_major == 15 | highest_major == 20 | highest_major == 32 | highest_major == 33 | highest_major == 43 | highest_major == 41 | highest_major == 40) & year_ba<2010 //SocAnth
replace major=21 if (highest_major == 26 | highest_major == 44) & year_ba<2010 //PolSci
replace major=22 if (highest_major == 39 | highest_major == 42 | highest_major == 45 | highest_major == 46) & year_ba<2010 //Technical
replace major=23 if (highest_major == 38 | highest_major == 19) & year_ba<2010 //LibArts


// This categories are for those who received their major on or after 2010
// The major codes for after 2010 was based on CIP2010 that you can find here:
// https://github.com/ahdvnd/Papers/blob/master/Mismatching/CIP%202010%20Major%20Codes.png

replace major=1 if (highest_major == 52) & year_ba>=2010 //BusMgmt
replace major=2 if highest_major == 26 & year_ba>=2010 //Bio
replace major=3 if (highest_major == 6 | highest_major == 10) & year_ba>=2010 //Comm
replace major=4 if highest_major == 11 & year_ba>=2010 //Comp
replace major=5 if highest_major == 4 & year_ba>=2010 //Archct
replace major=7 if highest_major == 13 & year_ba>=2010 //Edu
replace major=8 if (highest_major == 14 | highest_major == 15 | highest_major == 29 | highest_major == 41) & year_ba>=2010 //Engin
replace major=9 if highest_major == 23 & year_ba>=2010 //English
replace major=10 if highest_major == 50 & year_ba>=2010 //Art
replace major=11 if highest_major == 1 & year_ba>=2010 //Ag
replace major=12 if highest_major == 16 & year_ba>=2010 //ForLang
replace major=13 if (highest_major == 54) & year_ba>=2010  //ArchHist
replace major=14 if (highest_major == 22) & year_ba>=2010  //LawCrim
replace major=15 if highest_major == 27 & year_ba>=2010 //Math
replace major=16 if (highest_major == 34 | highest_major == 51) & year_ba>=2010 //Med
replace major=17 if highest_major == 38 & year_ba>=2010 //Phil
replace major=18 if (highest_major == 40 | highest_major == 3) & year_ba>=2010 //Physic
replace major=19 if highest_major == 42 & year_ba>=2010 //Psych
replace major=20 if (highest_major == 5 | highest_major == 30 | highest_major == 39 | highest_major == 45) & year_ba>=2010 //SocAnth
replace major=22 if (highest_major == 46 | highest_major == 47 | highest_major == 48 | highest_major == 49 | highest_major == 12 | highest_major == 25 | highest_major == 28 | highest_major == 31 | highest_major == 36 | highest_major == 53) & year_ba>=2010 //Technical
replace major=23 if (highest_major == 24 | highest_major == 19 | highest_major == 32 | highest_major == 33 | highest_major == 35 | highest_major == 37 | highest_major == 43 | highest_major == 44) & year_ba>=2010 //LibArts



* This is because To standardize and preserve the integrity of the CCM codes, two-digit
* CCM codes are displayed with added leading “1”. For instance, code “01” is displayed as “101”.
*gen major= major_fieldba-100
* 1= Art,  2 = Communication,  3 = Humanities,  4 = Social Sciences,  5 = STEM,  6 = Business,  7 = Professional and Occupations
*recode major (4 50 = 1) (9 = 2) (16 19 23 24 25 30 38 39 54 = 3) (5 42 45 = 4) ///
*             (1 3 10 11 14 15 26 27 29 41 = 5) (52 = 6) ///
*			 (9 12 13 22 28 31 32 33 34 35 36 37 40 43 44 46 47 48 49 51 53 90 = 7) ///
*			 , gen(majorcat)


recode highest_major (4 16=1) (8=2) (3 12 14 17 18 24 33=3) (15 2 5 26 31 32 20=4) (1 6 9 13 21 25=5) ///
					 (7 11 19=6) (22 23 27 29 30 36=7) (10 28=8) (99=9), gen(majorcat)
					 
				
// art=1, comm=2, hum=3, soci=4, stemm=5, busi/econ=6, med=7, law=8, other=9


//The following major codes didn't exist in Sarah's table
// 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49, 50, 51, 52, 54, 999



*ideally we'd like to control for their major since all observations hold Bachelor

* regression 1 
reg log_wage matching_score exp2, r

* regression 2 (reg1 + controls)reg log_wage matching_score_norm exp exp_sqrd i.gender i.gender#c.matching_score_norm ///
reg log_wage matching_score_norm exp2 gender dad_high_grade i.race ASVAB_math married hh_size, r

	
* regression 3 (reg2 + interaction b/w gender and matching)
reg log_wage matching_score_norm exp2 gender matchxgender dad_high_grade i.race ///
    ASVAB_math married hh_size Associate, r


* regression 4 (reg3 + major categories)
* the problem is that when we add the major variable, another 100+ observations are omitted
reg log_wage matching_score_norm exp2 gender matchxgender i.majorcat dad_high_grade ///
    i.race ASVAB_math married hh_size Associate if majorcat != 9, r

	
* regression 4' (reg3 + major)
* the problem is that when we add the major variable, another XX+ observations are omitted
reg log_wage matching_score_norm exp2 gender matchxgender i.major dad_high_grade ///
    i.race ASVAB_math married hh_size Associate, r
	
	

* regression 5 (reg3 + matching z score)
reg log_wage matching_z_score exp2 gender matchzxgender dad_high_grade i.race ///
    ASVAB_math married hh_size Associate, r

* regression 6 (reg3 + simple matching score without any normalization. You can interpret the coefficient as additional matched course)
reg log_wage matching_score exp2 gender mxgender dad_high_grade i.race ASVAB_math ///
    married hh_size Associate, r


* regression 7 (Mincer + binary matching_score + control)
qui sum matching_score_norm, de
gen hi_match = (matching_score_norm > r(p75))

reg log_wage hi_match exp exp_sqrd gender dad_high_grade ///
	i.race_ethnicity ASVAB_math married , r

*restore
