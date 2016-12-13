clear all

cd "/Users/Hadzzz/Github/Papers/Perception"
use "ISSP.dta"

keep if C_ALPHAN=="US"
keep V54 AGE DEGREE US_DEGR ISCO88 US_RINC SEX

// drop if ISCO88>=9996
// drop if ISCO88==0
drop if V54==. | V54==8 | V54==9
drop if AGE<19                         
drop if AGE>79

recode SEX (1=0) (2=1), gen(female)

recode US_DEGR (1/2=1) (3/4=2) (5=3)

recode ISCO88 (0/999=10) (1000/1999=1) (2000/2999=2) (3000/3999=3) (4000/4999=4) (5000/5999=5) (6000/6999=6) (7000/7999=7) (8000/8999=8) (9000/9999=9)
recode AGE (min/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=6) (50/54=7) (55/59=8) (60/64=9) (65/69=10) (70/74=11) (75/max=12), gen(age)

gen AGESQ=(AGE)^2
tabulate V54 SEX, col nofreq

// Multinomial logit

mlogit V54 AGE AGESQ female, base(2)
