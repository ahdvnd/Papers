/*

qui drop MTWStatus

foreach var of varlist _all {
	qui replace `var' = . if (`var' == - 1 | `var' == - 2 | `var' == - 3 | `var' == - 4 | `var' == - 5 | `var' == 999999)
	}

rename R0000100 id 

label variable matching_score "Matching score"
label variable grade_matchscore "Grade-Based matching score"
label variable Associate "Has Associate degree"

rename R0536300 gender
label variable gender "Female"
label define genderlabel 0 "Male" 1 "Female"
label values gender genderlabel

rename R0536401 Bday_m
label variable Bday_m "Month of birth"
rename R0536402 Bday_y
label variable Bday_y "Year of birth"

rename R1302400 dad_high_grade
label variable dad_high_grade "Father's highest grade"
rename R1302500 mom_high_grade
label variable mom_high_grade "Mother's highest grade"

// RACE: (1)Black, (2)Hispanic, (3)Mixed Race, (4)White
rename R1482600 race
replace race = . if race == 3
label variable race "Race"
label define racelabel 1 "Black" 2 "Hispanic" 4 "White"
label values race racelabel

rename R9829600 ASVAB_math_verbal
qui gen ASVAB_pct = ASVAB_math_verbal/1000
label variable ASVAB_pct "ASVAB math/verbal pct"

rename T8123600 age_interview
label variable age_interview "Age at interview"

rename T8123700 region
label variable region "Region"
label define regionlabel 1 "Northeast" 2 "North" 3 "South" 4 "West"
label values region regionlabel

rename T8129100 family_income
label variable family_income "Gross family income"

rename T8129300 hh_size
label variable hh_size "Household size"

rename T8129400 num_hh_18
label variable num_hh_18 "Number of HH under 18"

rename T8129500 num_hh_6
label variable num_hh_6 "Number of HH under 6"

rename T8134000 marital_detail

// MARITAL STATUS: never married(0) married(1) separated(2) divorced(3) widowed(4) 
rename T8134100 marital_status
label variable marital_status "Marital status"
qui recode marital_status (0 2 3 4=0) (1=1), gen(married)
label variable married "Married"

rename T8130800 hr_wage_2013
label variable hr_wage_2013 "Hourly wage"

rename T6661500 less_13wk_2013
label variable less_13wk "Job lasts 13 weeks or less"

rename T8131800 hrs_wk_2013
label variable hrs_wk_2013 "Hours worked per week"

rename Z9058904 wk_2013
label variable wk_2013 "Number of weeks worked (employee-type)"

rename Z9066704 hrs_total_2013
label variable hrs_total_2013 "Total hours worked (employee-type)"

rename T8976700 wage_2012
label variable wage_2012 "Income from wages and salary"

rename T8976800 est_wage_2012

rename Z9033700 SAT_math 
label variable SAT_math "Highest SAT math"

rename Z9033800 SAT_round_math 
label variable SAT_round_math "Round of highest SAT math"

rename Z9033900 SAT_verbal 
label variable SAT_verbal "Highest SAT verbal"

rename Z9034000 SAT_round_verbal
label variable SAT_round_verbal "Round of highest SAT varbal"

rename Z9122800 training
label variable training "Has training certificate"

rename Z9065200 exp_wk_employee_teen
label variable exp_wk_employee_teen "Weeks in employee-type job age 14-19"

rename Z9065300 exp_wk_employee_adult
label variable exp_wk_employee_adult "Weeks in employee-type job from age 20"

rename Z9065400 exp_wk_adult
label variable exp_wk_adult "Weeks in all jobs from age 20"

rename Z9083900 degree
label variable degree "Highest degree"

rename T9133500 occ_2013
label variable occ_2013 "Occupation code"


*/

*cd "/Users/Hadzzz/Google Drive/Research/Mismatching/Regression Files"
cd "/Users/Hadzzz/Google Drive/Research/Mismatching/Regression Files"

cls
clear
graph drop _all
use June12_17.dta


set more off

*preserve


// We decided to drop those below or above a bachelor degree. If we add this command R^2 drops significantly.
qui drop if degree != 4



//=== MATCHING SCORE ===
// Getting rid of outliers and normalizing the matching score
qui sum matching_score, de
qui drop if matching_score > r(p99)

// This is to normalize matching score
qui sum matching_score, de
qui gen matching_score_norm = 100 * (matching_score - r(min))/(r(max) - r(min))

// This created binary matching score high
qui sum matching_score_norm, de
qui gen hi_match = (matching_score_norm > r(p75))

label variable matching_score_norm "Normalized matching score"
label variable hi_match "Matching score high"

// This creates the matching z-score
qui egen matching_z_score = std(matching_score)
qui gen matching_z_sq = (matching_z_score)^2

label variable matching_z_score "Matching z-score"
label variable matching_z_sq "Matching z-score$^2$"


// This creates the grade-based matching z-score
qui egen grade_matching_z_score = std(grade_matchscore)
label variable grade_matching_z_score "Grade-matching z-score"


//=== DEPENDENT VARIABLE (ANNUAL WAGE) ===
qui gen log_wage_yr = log(wage_2012)
label variable log_wage_yr "log(wage)"

//=== DEPENDENT VARIABLE (HOURLY WAGE) ===
qui gen log_wage_hr = log(hr_wage_2013)
label variable log_wage_hr "log(wage)"

//=== DEPENDENT VARIABLE (TOTAL WAGE 2013) ===
qui gen log_wage_2013 = log(hrs_total_2013 * hr_wage_2013)
label variable log_wage_yr "log(wage)"


//=== EXPERIENCE ===
qui gen exp_wk = exp_wk_employee_adult
qui gen exp_wk_sqrd = exp_wk^2
qui gen exp_yr = exp_wk/52
qui gen exp_yr_sq = exp_yr^2

label variable exp_yr "Experience (yr)"
label variable exp_yr_sq "Experience$^2$ (yr)"


//=== FULL/PART TIME JOB ===
qui gen fulltime = (wk_2013>=40 & hrs_wk_2013>=35)
qui gen fulltime2 = (less_13wk_2013==0 & hrs_wk_2013>=35)

label variable fulltime "Full time"
label variable fulltime2 "Full time"


//=== CATEGORIZING OCCUPATIONS 1 ===
// categorize them into 14 major occupations by census 2002 also compatible with SOC

qui gen occ_cat_2013 = .

qui replace occ_cat_2013 = 1 if occ_2013 >= 10 & occ_2013 <= 950		// management/business
qui replace occ_cat_2013 = 2 if occ_2013 >= 1000 & occ_2013 <= 1240  	// math/CS
qui replace occ_cat_2013 = 3 if occ_2013 >= 1300 & occ_2013 <= 1560		// engineer
qui replace occ_cat_2013 = 4 if occ_2013 >= 1600 & occ_2013 <= 1960		// phys/soc sci
qui replace occ_cat_2013 = 5 if occ_2013 >= 2000 & occ_2013 <= 2060		// soc service
qui replace occ_cat_2013 = 6 if occ_2013 >= 2100 & occ_2013 <= 2150		// legal
qui replace occ_cat_2013 = 7 if occ_2013 >= 2200 & occ_2013 <= 2550		// edu
qui replace occ_cat_2013 = 8 if occ_2013 >= 2600 & occ_2013 <= 2960		// arts/sports
qui replace occ_cat_2013 = 9 if occ_2013 >= 3000 & occ_2013 <= 3540		// health
qui replace occ_cat_2013 = 10 if occ_2013 >= 3600 & occ_2013 <= 4650	// services (healthcare support, protective service, food preparation, maintenance, personal care)
qui replace occ_cat_2013 = 11 if occ_2013 >= 4700 & occ_2013 <= 5930	// sales and office (sales, adminstrative)
qui replace occ_cat_2013 = 12 if occ_2013 >= 6000 & occ_2013 <= 7620	// farming, construction
qui replace occ_cat_2013 = 13 if occ_2013 >= 7700 & occ_2013 <= 9750	// production, transportation
qui replace occ_cat_2013 = 14 if occ_2013 >= 9800 & occ_2013 <= 9840	// military
qui replace occ_cat_2013 = 15 if occ_2013 >= 9950 & occ_2013 <= 9990	// ACS special codes


// only one observation in our sample of 850 and we don't know the occupation
drop if occ_cat_2013 == 15


label variable occ_cat_2013 "Occupation categories"
label define occ_label 1 "Management/Business" 2 "Math/CS" 3 "Engineering" ///
						4 "Physical and Social Science" 5 "Social Serivces" 6 "Legal" ///
						7 "Education" 8 "Arts/entertainment/sports" 9 "Healthcare" ///
						10 "Services" 11 "Sales and office" 12 "Construction/maintenance" ///
						13 "Production/Transportation" 14 "Military"		
label values occ_cat_2013 occ_label

//=== CATEGORIZING OCCUPATIONS 2 ===
// here we have 5 major occupations and put other occupations to "Others" category
qui recode occ_cat_2013 (1 = 1) (2 = 2) (3 = 3) ///
             (4 = 4) (9 = 5) (5 6 7 8 10 11 12 13 14 15 = 6) ///
			 , gen(occ_cat2_2013)

label variable occ_cat2_2013 "Occupation categories"
label define occ_label2 1 "Management/Business" 2 "Math/CS" 3 "Engineering" ///
						4 "Physical and Social Science" 5 "Healthcare" 6 "Others"
label values occ_cat2_2013 occ_label2

//=== CATEGORIZING OCCUPATIONS 3 ===

***** do this later, we'd like to have the same category for occupation and major (for pie and bar charts) *****

/*
qui gen occ_cat = .

// (1) Art
qui replace occ_cat = 1 if occ_2013 > 2600 & occ_2013 < 2960 & occ_2013 != 2720
qui replace occ_cat = 1 if occ_2013 == 1300

// (2) Humanities
qui replace occ_cat = 2 if occ_2013 > 2600 & occ_2013 < 2960 & occ_2013 != 2720
qui replace occ_cat = 2 if occ_2013 == 1300

*/

//=== CATEGORIZING MAJORS ===
// This categories are for those who received their major before 2010
// The major codes for before 2010 was based on NLSY's own coding that you can find here:
// https://github.com/ahdvnd/Papers/blob/master/Mismatching/NLSY%20Major%20Codes.png

qui gen major = .
qui replace major=1 if (highest_major == 07 | highest_major == 37) & year_ba<2010 //BusMgmt
qui replace major=2 if highest_major == 06 & year_ba<2010 //Bio
qui replace major=3 if highest_major == 08 & year_ba<2010 //Comm
qui replace major=4 if highest_major == 09 & year_ba<2010 //Comp
qui replace major=5 if highest_major == 04 & year_ba<2010 //Archct
qui replace major=6 if highest_major == 11 & year_ba<2010 //Econ
qui replace major=7 if highest_major == 12 & year_ba<2010 //Edu
qui replace major=8 if highest_major == 13 & year_ba<2010 //Engin
qui replace major=9 if highest_major == 14 & year_ba<2010 //English
qui replace major=10 if highest_major == 16 & year_ba<2010 //Art
qui replace major=11 if highest_major == 01 & year_ba<2010 //Ag
qui replace major=12 if highest_major == 17 & year_ba<2010 //ForLang
qui replace major=13 if (highest_major == 03 | highest_major == 18) & year_ba<2010  //ArchHist
qui replace major=14 if (highest_major == 10 | highest_major == 28 | highest_major == 47) & year_ba<2010  //LawCrim
qui replace major=15 if highest_major == 21 & year_ba<2010 //Math
qui replace major=16 if (highest_major == 22 | highest_major == 23 | highest_major == 27 | highest_major == 29 | highest_major == 30 | highest_major == 36) & year_ba<2010 //Med
qui replace major=17 if highest_major == 24 & year_ba<2010 //Phil
qui replace major=18 if (highest_major == 25 | highest_major == 48) & year_ba<2010 //Physic
qui replace major=19 if highest_major == 31 & year_ba<2010 //Psych
qui replace major=20 if (highest_major == 02 | highest_major == 05 | highest_major == 15 | highest_major == 20 | highest_major == 32 | highest_major == 33 | highest_major == 43 | highest_major == 41 | highest_major == 40) & year_ba<2010 //SocAnth
qui replace major=21 if (highest_major == 26 | highest_major == 44) & year_ba<2010 //PolSci
qui replace major=22 if (highest_major == 39 | highest_major == 42 | highest_major == 45 | highest_major == 46) & year_ba<2010 //Technical
qui replace major=23 if (highest_major == 38 | highest_major == 19) & year_ba<2010 //LibArts

// This categories are for those who received their major on or after 2010
// The major codes for after 2010 was based on CIP2010 that you can find here:
// https://github.com/ahdvnd/Papers/blob/master/Mismatching/CIP%202010%20Major%20Codes.png

qui replace major=1 if (highest_major == 52) & year_ba>=2010 //BusMgmt
qui replace major=2 if highest_major == 26 & year_ba>=2010 //Bio
qui replace major=3 if (highest_major == 6 | highest_major == 10) & year_ba>=2010 //Comm
qui replace major=4 if highest_major == 11 & year_ba>=2010 //Comp
qui replace major=5 if highest_major == 4 & year_ba>=2010 //Archct
qui replace major=7 if highest_major == 13 & year_ba>=2010 //Edu
qui replace major=8 if (highest_major == 14 | highest_major == 15 | highest_major == 29 | highest_major == 41) & year_ba>=2010 //Engin
qui replace major=9 if highest_major == 23 & year_ba>=2010 //English
qui replace major=10 if highest_major == 50 & year_ba>=2010 //Art
qui replace major=11 if highest_major == 1 & year_ba>=2010 //Ag
qui replace major=12 if highest_major == 16 & year_ba>=2010 //ForLang
qui replace major=13 if (highest_major == 54) & year_ba>=2010  //ArchHist
qui replace major=14 if (highest_major == 22) & year_ba>=2010  //LawCrim
qui replace major=15 if highest_major == 27 & year_ba>=2010 //Math
qui replace major=16 if (highest_major == 34 | highest_major == 51) & year_ba>=2010 //Med
qui replace major=17 if highest_major == 38 & year_ba>=2010 //Phil
qui replace major=18 if (highest_major == 40 | highest_major == 3) & year_ba>=2010 //Physic
qui replace major=19 if highest_major == 42 & year_ba>=2010 //Psych
qui replace major=20 if (highest_major == 5 | highest_major == 30 | highest_major == 39 | highest_major == 45) & year_ba>=2010 //SocAnth
qui replace major=22 if (highest_major == 46 | highest_major == 47 | highest_major == 48 | highest_major == 49 | highest_major == 12 | highest_major == 25 | highest_major == 28 | highest_major == 31 | highest_major == 36 | highest_major == 53) & year_ba>=2010 //Technical
qui replace major=23 if (highest_major == 24 | highest_major == 19 | highest_major == 32 | highest_major == 33 | highest_major == 35 | highest_major == 37 | highest_major == 43 | highest_major == 44) & year_ba>=2010 //LibArts

//=== CATEGORIZING MAJORS 2 ===
// Major categories based on the variable major_fieldba (major2)
// This is because To standardize and preserve the integrity of the CCM codes, two-digit
// CCM codes are displayed with added leading “1”. For instance, code “01” is displayed as “101”.
qui gen major2 = major_fieldba-100
// (1) Art,  (2) Humanities,  (3) Social Sciences/Communication,  (4) STEM,  (5) Business,  (6) Professional and Occupations
qui recode major2 (4 50 = 1) (16 19 23 24 25 30 38 39 54 = 2) (9 5 42 45 = 3) ///
             (1 3 10 11 14 15 26 27 29 41 = 4) (52 = 5) ///
			 (12 13 22 28 31 32 33 34 35 36 37 40 43 44 46 47 48 49 51 53 90 = 6) ///
			 , gen(major_cat)

label variable major_cat "Major categories"
label define majorcatlabel 1 "Art" 2 "Humanities" 3 "Social Sci./Communication" ///
							4 "STEM" 5 "Business" 6 "Professional/Occupational"
label values major_cat majorcatlabel


//=== OTHER CONTROLS & INTERACTIONS===
qui gen matchXgender = matching_score * gender
qui gen match_normXgender = matching_score_norm * gender
qui gen match_zXgender = matching_z_score * gender
qui gen gradematch_zXgender  = grade_matching_z_score * gender
qui gen match_z_sqrXgender = matching_z_sq * gender

label variable matchXgender "Matching score $\times$ Female"
label variable match_zXgender "Matching z-score $\times$ Female"
label variable gradematch_zXgender "Grade-matching z-score $\times$ Female"
label variable match_z_sqrXgender "Matching z-score$^2$ $\times$ Female"



//=== REGRESIONS ===

eststo clear


// adding exp^2 causes coefficient of both exp and exp^2 to lose significance
// TABLE 1
// regression 1 (matching + exp)
eststo: qui reg log_wage_yr matching_score exp_yr fulltime, r

// regression 2 (1 + some controls)
eststo: qui reg log_wage_yr matching_score exp_yr fulltime gender ib4.race Associate, r

// regression 3 (1 + even more controls)
eststo: qui reg log_wage_yr matching_score exp_yr fulltime gender ib4.race Associate ASVAB_pct mom_high_grade married hh_size , r

// regression 4 (matching z-score + even more controls)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender ib4.race Associate ASVAB_pct mom_high_grade married hh_size , r


esttab using table1.tex, replace label nobaselevels star(* 0.10 ** 0.05 *** 0.01) not ar2 ///
		 gaps nomtitles alignment(D{.}{.}{-0.8}) cells(b(star fmt(4))) order(matching_score matching_z_score exp_yr fulltime gender) ///
		 title(Table 1 \label{tab1}) longtable addnotes()

		
		 
		 
eststo clear


// TABLE 2
// regression 1 (matching z-score + exp + gender interaction)
eststo: qui reg log_wage_yr matching_z_score exp_yr gender match_zXgender, r

// regression 1 (1 + fulltime)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender match_zXgender, r

// regression 2 (1 + more controls)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender match_zXgender ib4.race Associate, r

// regression 3 (1 + all controls)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender match_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size , r			


esttab using table2.tex, replace label nobaselevels star(* 0.10 ** 0.05 *** 0.01) not ar2 ///
		gaps nomtitles order(matching_z_score exp_yr fulltime gender match_zXgender) ///
		alignment(D{.}{.}{-0.8}) cells(b(star fmt(4))) title(Table 2 \label{tab2}) longtable addnotes()

eststo clear


// TABLE 3
// regression 1 (matching z-score + controls + major cat)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender match_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size ib2.major_cat, r

// regression 2 (matching z-score + controls + occupation cat)
eststo: qui reg log_wage_yr matching_z_score exp_yr fulltime gender match_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size ib11.occ_cat_2013, r

// regression 3 (matching z-score + zscore^2 + controls + occupation cat)
eststo: qui reg log_wage_yr matching_z_score matching_z_sq exp_yr fulltime gender match_zXgender match_z_sqrXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size ib11.occ_cat_2013, r


esttab using table3.tex, replace label nobaselevels star(* 0.10 ** 0.05 *** 0.01) not ar2 ///
		gaps alignment(D{.}{.}{-0.8}) cells(b(star fmt(4))) nomtitles order(matching_z_score matching_z_sq exp_yr fulltime gender match_zXgender match_z_sqrXgender) ///
		title(Table 3 \label{tab3}) longtable addnotes()

eststo clear


// TABLE 4
// regression 1 (Grade-matching z-score + gender interaction)
eststo: qui reg log_wage_yr grade_matching_z_score exp_yr fulltime gender gradematch_zXgender, r			

// regression 2 (1 + all controls)
eststo: qui reg log_wage_yr grade_matching_z_score exp_yr fulltime gender gradematch_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size , r			

// regression 3 (1 + all controls + major cat)
eststo: qui reg log_wage_yr grade_matching_z_score exp_yr fulltime gender gradematch_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size ib2.major_cat, r			

// regression 4 (1 + all controls + occ cat)
eststo: qui reg log_wage_yr grade_matching_z_score exp_yr fulltime gender gradematch_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size ib11.occ_cat_2013, r			


esttab using table4.tex, replace label nobaselevels star(* 0.10 ** 0.05 *** 0.01) not ar2 ///
		gaps alignment(D{.}{.}{-0.8}) cells(b(star fmt(4))) nomtitles order(grade_matching_z_score exp_yr fulltime gender gradematch_zXgender) ///
		title(Table 4 \label{tab4}) longtable addnotes()

eststo clear


/*

//=== GRAPHS ===

// Pie chart of occupation for each major
graph pie, over(occ_cat2_2013) by(major_cat)
graph export graph1.pdf, replace

graph pie if hi_match==1, over(occ_cat2_2013) by(major_cat)
graph export graph2.pdf, replace


tempfile file1

save "`file1'"

*/

// Major categories bar chart with confidence intervals

/*
		
collapse (mean) meanmatch= matching_score (sd) sdmatch=matching_score (count) n=matching_score, by(major_cat)	
generate himatch = meanmatch + invttail(n-1,0.025)*(sdmatch / sqrt(n))
generate lowmatch = meanmatch - invttail(n-1,0.025)*(sdmatch / sqrt(n))
sort meanmatch
twoway (bar meanmatch major_cat) (rcap himatch lowmatch major_cat), ///
		xlabel(1 "Art" 2 "Humanities" 3 "Social Sci./Communication" 4 "STEM" 5 "Business" ///
		6 "Professional/Occupational", noticks labsize(small) angle (45)) xtitle("") ytitle("")


*/		
		
/*
use "`file1'", clear

// Occupation categories bar chart with confidence intervals
collapse (mean) meanmatch=matching_score (sd) sdmatch=matching_score (count) n=matching_score, by(occ_cat_2013)
generate himatch = meanmatch + invttail(n-1,0.025)*(sdmatch / sqrt(n))
generate lowmatch = meanmatch - invttail(n-1,0.025)*(sdmatch / sqrt(n))
twoway (bar meanmatch occ_cat_2013) (rcap himatch lowmatch occ_cat_2013), ///
		xlabel(1 "Management/Business" 2 "Math/CS" 3 "Engineering" 4 "Physical and Social Science" ///
				5 "Social Serivces" 6 "Legal" 7 "Education" 8 "Arts/entertainment/sports" 9 "Healthcare" ///
				10 "Services" 11 "Sales and office" 12 "Construction/maintenance" 13 "Production/Transportation" ///
				14 "Military", noticks labsize(small) angle (315)) xtitle("") ytitle("") title("Occupation Categories") legend(off)
graph export graph4.pdf, replace

use "`file1'", clear

// Occupation categories bar chart with confidence intervals for each major
gen occ_maj = occ_cat2_2013 if major_cat == 1
replace occ_maj = occ_cat2_2013 + 10 if major_cat == 2
replace occ_maj = occ_cat2_2013 + 20 if major_cat == 3
replace occ_maj = occ_cat2_2013 + 30 if major_cat == 4
replace occ_maj = occ_cat2_2013 + 40 if major_cat == 5
replace occ_maj = occ_cat2_2013 + 50 if major_cat == 6

collapse (mean) meanmatch=matching_score (sd) sdmatch=matching_score (count) n=matching_score, by(occ_maj)
generate himatch = meanmatch + invttail(n-1,0.025)*(sdmatch / sqrt(n))
generate lowmatch = meanmatch - invttail(n-1,0.025)*(sdmatch / sqrt(n))
twoway (bar meanmatch occ_maj if occ_maj<10) (rcap himatch lowmatch occ_maj if occ_maj<10), name(graph5_1) ///
		xlabel(1 "Management/Business" 2 "Math/CS" 3 "Engineering" 4 "Physical and Social Science" 5 "Healthcare" 6 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("Art") legend(off)
twoway (bar meanmatch occ_maj if 10<occ_maj & occ_maj<20) (rcap himatch lowmatch occ_maj if 10<occ_maj & occ_maj<20), name(graph5_2) ///
		xlabel(11 "Management/Business" 12 "Math/CS" 13 "Engineering" 14 "Physical and Social Science" 15 "Healthcare" 16 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("Humanities") legend(off)
twoway (bar meanmatch occ_maj if 20<occ_maj & occ_maj<30) (rcap himatch lowmatch occ_maj if 20<occ_maj & occ_maj<30), name(graph5_3) ///
		xlabel(21 "Management/Business" 22 "Math/CS" 23 "Engineering" 24 "Physical and Social Science" 25 "Healthcare" 26 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("Social Sci./Communication") legend(off)
twoway (bar meanmatch occ_maj if 30<occ_maj & occ_maj<40) (rcap himatch lowmatch occ_maj if 30<occ_maj & occ_maj<40), name(graph5_4) ///
		xlabel(31 "Management/Business" 32 "Math/CS" 33 "Engineering" 34 "Physical and Social Science" 35 "Healthcare" 36 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("STEM") legend(off)
twoway (bar meanmatch occ_maj if 40<occ_maj & occ_maj<50) (rcap himatch lowmatch occ_maj if 40<occ_maj & occ_maj<50), name(graph5_5) ///
		xlabel(41 "Management/Business" 42 "Math/CS" 43 "Engineering" 44 "Physical and Social Science" 45 "Healthcare" 46 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("Business") legend(off)
twoway (bar meanmatch occ_maj if 50<occ_maj) (rcap himatch lowmatch occ_maj if 50<occ_maj), name(graph5_6) ///
		xlabel(51 "Management/Business" 52 "Math/CS" 53 "Engineering" 54 "Physical and Social Science" 55 "Healthcare" 56 "Others", noticks labsize(vsmall) angle (315)) xtitle("") ytitle("") title("Professional/Occupational") legend(off)
graph combine graph5_1 graph5_2 graph5_3 graph5_4 graph5_5 graph5_6, row(2) col(3)
graph export graph5.pdf, replace

use "`file1'", clear



// Histogram of matching score across all individuals	
*egen matchcat = cut(matching_score), at(0,10,20,30,40,53) label
*tabulate matchcat, nolabel
hist(matching_score), bin(5) name(h1, replace)

*/

// scatter plot of the predicted values of logwage on mismatching_score by gender		
qui reg log_wage_yr matching_z_score exp_yr gender match_zXgender ib4.race Associate ASVAB_pct mom_high_grade married hh_size , r			
predict yhat, xb
scatter yhat matching_z_score || lfitci yhat matching_z_score ||, by(gender, row(1)) name(a2, replace) ytitle("Log Wages")	






*restore




