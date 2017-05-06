
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
***************************************************************
/*When we add household size we get a very significant but not that large negative effect, 
it also increase our R_Squared . In the lit-review on sharelatex I mentioned the R-squared 	
from few of those papers, they are usually around 25 to 35 (not that large). So I think 
this variable helps us. in all sets of controls this is very significant*/
* regression 6 just adding household size
reg log_wage matching_score_norm exp exp_sqrd i.gender i.gender#c.matching_score_norm ///
dad_high_grade mom_high_grade i.race_ethnicity ASVAB_math i.marital_status hh_size , r
	
/*all the observations have bachelor , few certificate or associate. So associate is a 
negative significant variable, it increases R-squared by less than 2 percents. 
the negative sing means ? when we add associate and certificate , the R squared does not 
increase, the certificate is not significant, i dont know how to explain this. 
Good thing is that in all these , the matching score coeff does not change substantially. 
Update: among all the different combinations of SAT scores, only math score was significant, 
so If we include that instead of ASVAB neither the associate nor the certificate are significant. 
I still dont know the link.  
*/
reg log_wage matching_score_norm exp exp_sqrd i.gender i.gender#c.matching_score_norm///
 dad_high_grade mom_high_grade i.race_ethnicity ASVAB_math i.marital_status hh_size Associate , r

/* we notice that experience and experience squared are not significant, so we either 
need to 1.  go with age-years of educations ( which is supposed to be the same for all, unless
someone took his time to finish the bachelors,I am not sure if we have years of education to 
creat this variable) or 2. drop the exp and expsq ( this will reduce the R-squared to 10 percent) and 
add the number of jobs ( this will againe increase R-squared to almost 16 percent and also 
this variable is highly significant. We expect the sign to be negative, ( the same as
we think exp should have possitive effect). */

reg log_wage matching_score_norm num_jobs_20 i.gender i.gender#c.matching_score_norm\\\
 dad_high_grade mom_high_grade i.race_ethnicity ASVAB_math i.marital_status hh_size, r
/* so far I think this is the best regression but unfortunately the matchscore's coeff
slightly changed, from 0.77 to 0.66*/
***********************
/* in regression below I added citizenship status to the analysis. It increases 
R-squared to almost 19 percent. but it causes the coeff of the interactions term 
that we like to become insignificant at 5% (still sig at 10%).*/ 

reg log_wage matching_score_norm num_jobs_20 i.gender i.gender#c.matching_score_norm\\\
 dad_high_grade mom_high_grade i.race_ethnicity ASVAB_math i.marital_status hh_size Associate citizen_status , r	
	

restore
