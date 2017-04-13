clear all

cd "/Users/Hadzzz/Github/Papers/Perception"
use "ISSP.dta"

replace C_ALPHAN="UK" if C_ALPHAN=="GB-GBN"
replace C_ALPHAN="DE" if C_ALPHAN=="DE-E" | C_ALPHAN=="DE-W"

keep if C_ALPHAN=="AU" | C_ALPHAN=="TW" | C_ALPHAN=="CZ" | C_ALPHAN=="DK" | C_ALPHAN=="EE" | C_ALPHAN=="FI" | C_ALPHAN=="FR" | C_ALPHAN=="DE" | C_ALPHAN=="HU" | C_ALPHAN=="IS" | C_ALPHAN=="IT" | C_ALPHAN=="JP" | C_ALPHAN=="KR" | C_ALPHAN=="NO" | C_ALPHAN=="PL" | C_ALPHAN=="RU" | C_ALPHAN=="SK" | C_ALPHAN=="SI" | C_ALPHAN=="ZA" | C_ALPHAN=="ES" | C_ALPHAN=="UK" | C_ALPHAN=="US"

drop if V54==. | V54==8 | V54==9


// Since distributions B and C are the closest to the overall distribution in the US, BC shows whether the person chose either of these distributions.


egen match_AU = anymatch(V54) if C_ALPHAN=="AU", values(3)
egen match_TW = anymatch(V54) if C_ALPHAN=="TW", values(3)
egen match_CZ = anymatch(V54) if C_ALPHAN=="CZ", values(4)
egen match_DK = anymatch(V54) if C_ALPHAN=="DK", values(4)
egen match_EE = anymatch(V54) if C_ALPHAN=="EE", values(3)
egen match_FI = anymatch(V54) if C_ALPHAN=="FI", values(4)
egen match_FR = anymatch(V54) if C_ALPHAN=="FR", values(3)
egen match_DE = anymatch(V54) if C_ALPHAN=="DE", values(4)
egen match_HU = anymatch(V54) if C_ALPHAN=="HU", values(4)
egen match_IS = anymatch(V54) if C_ALPHAN=="IS", values(4)
egen match_IT = anymatch(V54) if C_ALPHAN=="IT", values(3)
egen match_JP = anymatch(V54) if C_ALPHAN=="JP", values(3)
egen match_KR = anymatch(V54) if C_ALPHAN=="KR", values(3)
egen match_NO = anymatch(V54) if C_ALPHAN=="NO", values(4)
egen match_PL = anymatch(V54) if C_ALPHAN=="PL", values(3)
egen match_RU = anymatch(V54) if C_ALPHAN=="RU", values(3)
egen match_SK = anymatch(V54) if C_ALPHAN=="SK", values(4)
egen match_SI = anymatch(V54) if C_ALPHAN=="SI", values(4)
egen match_ZA = anymatch(V54) if C_ALPHAN=="ZA", values(1)
egen match_ES = anymatch(V54) if C_ALPHAN=="ES", values(3)
egen match_UK = anymatch(V54) if C_ALPHAN=="UK", values(3)
egen match_US = anymatch(V54) if C_ALPHAN=="US", values(3)


gen BC=0
replace BC=1 if match_AU & C_ALPHAN=="AU"
replace BC=1 if match_TW & C_ALPHAN=="TW"
replace BC=1 if match_CZ & C_ALPHAN=="CZ"
replace BC=1 if match_DK & C_ALPHAN=="DK"
replace BC=1 if match_EE & C_ALPHAN=="EE"
replace BC=1 if match_FI & C_ALPHAN=="FI"
replace BC=1 if match_FR & C_ALPHAN=="FR"
replace BC=1 if match_DE & C_ALPHAN=="DE"
replace BC=1 if match_HU & C_ALPHAN=="HU"
replace BC=1 if match_IS & C_ALPHAN=="IS"
replace BC=1 if match_IT & C_ALPHAN=="IT"
replace BC=1 if match_JP & C_ALPHAN=="JP"
replace BC=1 if match_KR & C_ALPHAN=="KR"
replace BC=1 if match_NO & C_ALPHAN=="NO"
replace BC=1 if match_PL & C_ALPHAN=="PL"
replace BC=1 if match_RU & C_ALPHAN=="RU"
replace BC=1 if match_SK & C_ALPHAN=="SK"
replace BC=1 if match_SI & C_ALPHAN=="SI"
replace BC=1 if match_ZA & C_ALPHAN=="ZA"
replace BC=1 if match_ES & C_ALPHAN=="ES"
replace BC=1 if match_UK & C_ALPHAN=="UK"
replace BC=1 if match_US & C_ALPHAN=="US"



recode V54 (1=0) (2=74) (3=100) (4=66.26) (5=34.61) if C_ALPHAN=="AU"recode V54 (1=0) (2=75.56) (3=100) (4=72.54) (5=38.1) if C_ALPHAN=="TW"recode V54 (1=0) (2=58) (3=	83.91) (4=100) (5=76.9) if C_ALPHAN=="CZ"recode V54 (1=0) (2=55.5) (3=78.74) (4=100) (5=87.46) if C_ALPHAN=="DK"recode V54 (1=0) (2=73.44) (3=100) (4=89.68) (5=57.6) if C_ALPHAN=="EE"recode V54 (1=0) (2=54.8) (3=80.79) (4=100) (5=94.52) if C_ALPHAN=="FI"recode V54 (1=0) (2=74.71) (3=100) (4=95.42) (5=63.52) if C_ALPHAN=="FR"recode V54 (1=0) (2=62.48) (3=90.39) (4=100) (5=84.25) if C_ALPHAN=="DE"recode V54 (1=0) (2=59.86) (3=85.15) (4=100) (5=76.38) if C_ALPHAN=="HU"recode V54 (1=0) (2=49.11) (3=71.79) (4=100) (5=95.59) if C_ALPHAN=="IS"recode V54 (1=0) (2=73.23) (3=100) (4=95.62) (5=59.28) if C_ALPHAN=="IT"recode V54 (1=0) (2=73.32) (3=100) (4=91.28) (5=59.66) if C_ALPHAN=="JP"recode V54 (1=0) (2=81.72) (3=100) (4=55.97) (5=17.13) if C_ALPHAN=="KR"recode V54 (1=0) (2=61.97) (3=82.4) (4=100) (5=83.07) if C_ALPHAN=="NO"recode V54 (1=0) (2=71.6)  (3=100) (4=96.12) (5=64.93) if C_ALPHAN=="PL"recode V54 (1=0) (2=73.71) (3=100) (4=75.57) (5=43.75) if C_ALPHAN=="RU"recode V54 (1=0) (2=54.63) (3=78.3) (4=100) (5=84.63) if C_ALPHAN=="SK"recode V54 (1=0) (2=54.28) (3=76.32) (4=100) (5=90.49) if C_ALPHAN=="SI"recode V54 (1=100) (2=85.02) (3=59.73) (4=6.87) (5=0) if C_ALPHAN=="ZA"recode V54 (1=0) (2=75.48) (3=100) (4=88.09) (5=57.72) if C_ALPHAN=="ES"recode V54 (1=0) (2=73.41) (3=100) (4=79.58) (5=44.56) if C_ALPHAN=="UK"recode V54 (1=0) (2=81.87) (3=100) (4=53.97) (5=12.32) if C_ALPHAN=="US"



drop if AGE<19                         
drop if AGE>69
gen AGESQ=(AGE)^2
recode AGE (min/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=6) (50/54=7) (55/59=8) (60/64=9) (65/69=10) (70/74=11) (75/max=12), gen(age)

recode SEX (1=0) (2=1), gen(female)

drop if DEGREE==.
recode DEGREE (0 1 2=1) (3 4=2) (5=3), gen(degree)

gen married=0
replace married =1 if MARITAL==1

recode URBRURAL (1/2=1) (3/5=0), gen(city)
recode VOTE_LE (1=1) (2=0), gen(vote)
drop if PARTY_LR==6 
recode PARTY_LR (3 7=1) (1/2=2) (4/5=3), gen(party)

drop if ISCO88>=9996
drop if ISCO88==0
recode ISCO88 (0/999=10) (1000/1999=1) (2000/2999=2) (3000/3999=3) (4000/4999=4) (5000/5999=5) (6000/6999=6) (7000/7999=7) (8000/8999=8) (9000/9999=9), gen(occ)


//reg BC i.degree female i.V5 city i.TOPBOT i.party AGE i.occ

eststo clear
eststo: reg V54 i.degree female i.V5 city i.TOPBOT i.party AGE i.occ
esttab using reg1.tex, replace label not ar2 title(Basic Regression\label{reg1})


//reg BCcont loginc female i.age i.edu


// Multinomial logit
//mlogit V54 i.age female i.degree loginc married i.V5, base(2)

