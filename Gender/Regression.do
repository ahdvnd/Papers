cd "/Users/Hadzzz/GitHub/Papers/Gender"

//clear all

//import delimited Gender.csv


egen age2=group(age)
egen race2=group(race)

eststo clear

eststo: qui reg gini20 i.age2 i.race2 i.sex if year==1979
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==1986
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==1991
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==1994
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==1997
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==2000
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==2004
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==2007
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==2010
eststo: qui reg gini20 i.age2 i.race2 i.sex if year==2013
eststo: qui reg gini20 i.age2 i.race2 i.sex i.year

esttab using example1.tex, label star replace title(Regression table\label{reg1})

eststo clear


eststo: qui reg gini35 i.age2 i.race2 i.sex if year==1979
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==1986
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==1991
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==1994
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==1997
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==2000
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==2004
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==2007
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==2010
eststo: qui reg gini35 i.age2 i.race2 i.sex if year==2013
eststo: qui reg gini35 i.age2 i.race2 i.sex i.year

esttab using example2.tex, label star replace title(Regression table\label{reg2})


eststo clear


eststo: qui reg gini20 i.age2 i.race2 i.sex i.year
eststo: qui reg gini35 i.age2 i.race2 i.sex i.year
eststo: qui reg gini20 i.age2 i.race2 i.sex married varchild  higheduc i.year
eststo: qui reg gini35 i.age2 i.race2 i.sex married varchild  higheduc i.year
eststo: qui reg gini20 i.age2 i.race2 i.sex married varchild  higheduc shareabstract sharemanual sharecognitiveroutine i.year
eststo: qui reg gini35 i.age2 i.race2 i.sex married varchild  higheduc shareabstract sharemanual sharecognitiveroutine i.year


esttab using example3.tex, label star replace title(Regression table\label{reg3})

