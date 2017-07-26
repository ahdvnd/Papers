clear all

cd "/Users/Hadzzz/GitHub/Papers/Anatomy/"
use "/Users/Hadzzz/GitHub/Papers/Anatomy/Regression Data.dta"

destring year, replace

eststo clear

eststo: qui regress gini i.gender i.age ib2.race if year==1979
eststo: qui regress gini i.gender i.age ib2.race if year==1986
eststo: qui regress gini i.gender i.age ib2.race if year==1991
eststo: qui regress gini i.gender i.age ib2.race if year==1994
eststo: qui regress gini i.gender i.age ib2.race if year==1997
eststo: qui regress gini i.gender i.age ib2.race if year==2000
eststo: qui regress gini i.gender i.age ib2.race if year==2004
eststo: qui regress gini i.gender i.age ib2.race if year==2007
eststo: qui regress gini i.gender i.age ib2.race if year==2010
eststo: qui regress gini i.gender i.age ib2.race if year==2013
eststo: qui regress gini i.gender i.age ib2.race i.year



esttab using reg1.tex, replace label star(* 0.10 ** 0.05 *** 0.01) not ///
		alignment(D{.}{.}{-0.5}) depvars ar2 cells(b(star fmt(3))) unstack title(Basic Regression\label{reg1}) ///
		addnotes(Add note here.)




eststo clear
eststo: qui regress theil i.gender i.age ib2.race i.year
eststo: qui regress inc_share i.gender i.age ib2.race i.year
eststo: qui regress gini_emp i.gender i.age ib2.race i.year if age <11
eststo: qui regress gini_fl i.gender i.age ib2.race i.year if age <11


esttab using reg2.tex, replace label star(* 0.10 ** 0.05 *** 0.01) not ///
		alignment(D{.}{.}{-0.5}) depvars ar2 cells(b(star fmt(4))) unstack title(Cross Cohort Inequality Dynamic, Gini Coefficient (Full Time workers)\label{reg2}) ///
		addnotes(Add note here.)




eststo clear
eststo: qui regress theil i.gender i.age ib2.race marr_share var_child highed_share abstract_share manual_share cogroutine_share imgr_share i.year
eststo: qui regress inc_share i.gender i.age ib2.race marr_share var_child highed_share abstract_share manual_share cogroutine_share imgr_share i.year
eststo: qui regress gini i.gender i.age ib2.race marr_share var_child highed_share abstract_share manual_share cogroutine_share imgr_share i.year
eststo: qui regress gini_emp i.gender i.age ib2.race marr_share var_child highed_share abstract_share manual_share cogroutine_share imgr_share i.year if age <11
eststo: qui regress gini_fl i.gender i.age ib2.race marr_share var_child highed_share abstract_share manual_share cogroutine_share imgr_share i.year if age <11


esttab using reg3.tex, replace label star(* 0.10 ** 0.05 *** 0.01) not ///
		alignment(D{.}{.}{-0.5}) depvars ar2 cells(b(star fmt(4))) unstack title(Cross Cohort Inequality Dynamic for Different Inequality Measures\label{reg3}) ///
		addnotes(Add note here.)

