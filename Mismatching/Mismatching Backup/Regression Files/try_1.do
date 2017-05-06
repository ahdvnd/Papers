cd  "/Users/pooyaalmasi/Desktop/Papers/mismatching"

clear

set more off

use data_merged.dta

preserve

drop MTWStatus

drop if degree != 4
drop if race_ethnicity == 3


* Getting rid of outliers and normalizing the matching score
qui sum matching_score, de
drop if matching_score > r(p99)

qui sum matching_score, de
gen matching_score_norm = (matching_score - r(min))/(r(max) - r(min))


foreach var of varlist _all {
	replace `var' = . if (`var' == - 2 | `var' == - 3 | `var' == - 4)
	}

	
gen log_wage = log(wage_2012)
//gen exp = exp_wk_adult
gen exp = exp_wk_employee_adult
gen exp_sqrd = exp^2


*ideally we'd like to control for their major since all observations hold Bachelor

* regression 1 (Mincer equation)
reg log_wage exp exp_sqrd, r

* regression 2 (reg1 + matching_score)
reg log_wage matching_score exp exp_sqrd, r

* regression 3 (reg2 + controls)
reg log_wage matching_score_norm exp exp_sqrd i.gender dad_high_grade ///
	mom_high_grade i.race_ethnicity ASVAB_math i.marital_status, r
	
* regression 4 (reg3 + interaction b/w gender and matching)
reg log_wage matching_score_norm exp exp_sqrd i.gender i.gender#c.matching_score_norm ///
    dad_high_grade mom_high_grade i.race_ethnicity ASVAB_math i.marital_status, r

* regression 5 (Mincer + binary matching_score + control)
qui sum matching_score_norm, de
gen hi_match = (matching_score_norm > r(p75))

reg log_wage hi_match exp exp_sqrd i.gender dad_high_grade mom_high_grade ///
	i.race_ethnicity ASVAB_math i.marital_status, r


restore
