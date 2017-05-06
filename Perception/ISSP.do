clear all

cd "/Users/Hadzzz/Github/Papers/Perception"
use "ISSP.dta"

set more off
set scheme plotplainblind
graph set window fontface times

replace C_ALPHAN="UK" if C_ALPHAN=="GB-GBN"
replace C_ALPHAN="DE" if C_ALPHAN=="DE-E" | C_ALPHAN=="DE-W"

keep if C_ALPHAN=="AU" | C_ALPHAN=="TW" | C_ALPHAN=="CZ" | C_ALPHAN=="DK" | C_ALPHAN=="EE" | C_ALPHAN=="FI" | C_ALPHAN=="FR" | C_ALPHAN=="DE" | C_ALPHAN=="HU" | C_ALPHAN=="IS" | C_ALPHAN=="IT" | C_ALPHAN=="JP" | C_ALPHAN=="NO" | C_ALPHAN=="PL" | C_ALPHAN=="RU" | C_ALPHAN=="SK" | C_ALPHAN=="SI" | C_ALPHAN=="ZA" | C_ALPHAN=="ES" | C_ALPHAN=="UK" | C_ALPHAN=="US"

drop if V54==. | V54==8 | V54==9

gen V54edu = V54


drop if AGE<20                         
drop if AGE>69
gen AGESQ=(AGE)^2
*recode AGE (20/24=1) (25/29=2) (30/34=3) (35/39=4) (40/44=5) (45/49=6) (50/54=7) (55/59=8) (60/64=9) (65/69=10), gen(age)
recode AGE (20/29=1) (30/39=2) (40/49=3) (50/59=4) (60/69=5), gen(age)

recode SEX (1=0) (2=1), gen(female)

drop if DEGREE==.
recode DEGREE (0 1 2=1) (3 4=2) (5=3), gen(degree)

gen married=0
replace married =1 if MARITAL==1

recode URBRURAL (1/2=1) (3/5=0), gen(city)
recode VOTE_LE (1=1) (2=0), gen(vote)
drop if PARTY_LR==6 
recode PARTY_LR (3 7=1) (1/2=2) (4/5=3), gen(party) // 1= left 2= center, 3= right



drop if ISCO88>=9996
drop if ISCO88==0
recode ISCO88 (0/999=10) (1000/1999=1) (2000/2999=2) (3000/3999=3) (4000/4999=4) (5000/5999=5) (6000/6999=6) (7000/7999=7) (8000/8999=8) (9000/9999=9), gen(occ)




// Since distributions B and C are the closest to the overall distribution in the US, BC shows whether the person chose either of these distributions.


egen match_AU = anymatch(V54) if C_ALPHAN=="AU", values(2)
egen match_TW = anymatch(V54) if C_ALPHAN=="TW", values(3)
egen match_CZ = anymatch(V54) if C_ALPHAN=="CZ", values(3)
egen match_DK = anymatch(V54) if C_ALPHAN=="DK", values(4)
egen match_EE = anymatch(V54) if C_ALPHAN=="EE", values(3)
egen match_FI = anymatch(V54) if C_ALPHAN=="FI", values(3)
egen match_FR = anymatch(V54) if C_ALPHAN=="FR", values(2)
egen match_DE = anymatch(V54) if C_ALPHAN=="DE", values(2)
egen match_HU = anymatch(V54) if C_ALPHAN=="HU", values(3)
egen match_IS = anymatch(V54) if C_ALPHAN=="IS", values(3)
egen match_IT = anymatch(V54) if C_ALPHAN=="IT", values(3)
egen match_JP = anymatch(V54) if C_ALPHAN=="JP", values(2)
egen match_NO = anymatch(V54) if C_ALPHAN=="NO", values(3)
egen match_PL = anymatch(V54) if C_ALPHAN=="PL", values(3)
egen match_RU = anymatch(V54) if C_ALPHAN=="RU", values(3)
egen match_SK = anymatch(V54) if C_ALPHAN=="SK", values(3)
egen match_SI = anymatch(V54) if C_ALPHAN=="SI", values(3)
egen match_ZA = anymatch(V54) if C_ALPHAN=="ZA", values(1)
egen match_ES = anymatch(V54) if C_ALPHAN=="ES", values(3)
egen match_UK = anymatch(V54) if C_ALPHAN=="UK", values(2)
egen match_US = anymatch(V54) if C_ALPHAN=="US", values(2)


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
replace BC=1 if match_NO & C_ALPHAN=="NO"
replace BC=1 if match_PL & C_ALPHAN=="PL"
replace BC=1 if match_RU & C_ALPHAN=="RU"
replace BC=1 if match_SK & C_ALPHAN=="SK"
replace BC=1 if match_SI & C_ALPHAN=="SI"
replace BC=1 if match_ZA & C_ALPHAN=="ZA"
replace BC=1 if match_ES & C_ALPHAN=="ES"
replace BC=1 if match_UK & C_ALPHAN=="UK"
replace BC=1 if match_US & C_ALPHAN=="US"



recode V54 (1=56.64) (2=100) (3=95.8) (4=30.33) (5=0) if C_ALPHAN=="AU"
recode V54 (1=0) (2=72.93) (3=100) (4=74.39) (5=45.93) if C_ALPHAN=="TW"
recode V54 (1=0) (2=72.1) (3=	100) (4=79.35) (5=52.44) if C_ALPHAN=="CZ"
recode V54 (1=0) (2=71.9) (3=96.11) (4=100) (5=69.64) if C_ALPHAN=="DK"
recode V54 (1=46.63) (2=97.72) (3=100) (4=31.38) (5=0) if C_ALPHAN=="EE"
recode V54 (1=0) (2=80.56) (3=100) (4=56.38) (5=12.28) if C_ALPHAN=="FI"
recode V54 (1=33.37) (2=100) (3=99.31) (4=48.05) (5=0) if C_ALPHAN=="FR"
recode V54 (1=57.86) (2=100) (3=94.52) (4=30.83) (5=0) if C_ALPHAN=="DE"
recode V54 (1=0) (2=79.42) (3=100) (4=96.22) (5=57.26) if C_ALPHAN=="HU"
recode V54 (1=0) (2=82.93) (3=100) (4=48.8) (5=5.53) if C_ALPHAN=="IS"
recode V54 (1=3.67) (2=85.63) (3=100) (4=60.55) (5=0) if C_ALPHAN=="IT"
recode V54 (1=65.85) (2=100) (3=87.19) (4=22.52) (5=0) if C_ALPHAN=="JP"
recode V54 (1=0) (2=77.62) (3=100) (4=91.24) (5=47.85) if C_ALPHAN=="NO"
recode V54 (1=0) (2=73.75)  (3=100) (4=74.75) (5=41.23) if C_ALPHAN=="PL"
recode V54 (1=16.48) (2=84.88) (3=100) (4=35.94) (5=0) if C_ALPHAN=="RU"
recode V54 (1=0) (2=76.6) (3=100) (4=97.31) (5=70.45) if C_ALPHAN=="SK"
recode V54 (1=0) (2=82.56) (3=100) (4=99.33) (5=69.85) if C_ALPHAN=="SI"
recode V54 (1=100) (2=81.81) (3=56) (4=3.59) (5=0) if C_ALPHAN=="ZA"
recode V54 (1=6.23) (2=87.31) (3=100) (4=40.14) (5=0) if C_ALPHAN=="ES"
recode V54 (1=56.05) (2=100) (3=97.02) (4=30.75) (5=0) if C_ALPHAN=="UK"
recode V54 (1=72.26) (2=100) (3=90.75) (4=25.15) (5=0) if C_ALPHAN=="US"





// Educational reference group

if degree==1 {
recode V54edu (1=11.55) (2=82.27) (3=100) (4=35.99) (5=0) if C_ALPHAN=="AU"
recode V54edu (1=0) (2=73.47) (3=100) (4=88.37) (5=58.22) if C_ALPHAN=="TW"
recode V54edu (1=0) (2=51.54) (3=72.11) (4=100) (5=77.36) if C_ALPHAN=="CZ"
recode V54edu (1=0) (2=64.61) (3=87.37) (4=100) (5=83.28) if C_ALPHAN=="DK"
recode V54edu (1=40.09) (2=94.8) (3=100) (4=29.52) (5=0) if C_ALPHAN=="EE" 
recode V54edu (1=0) (2=76.67) (3=100) (4=71.11) (5=33.89) if C_ALPHAN=="FI" 
recode V54edu (1=40.09) (2=100) (3=85.09) (4=31.4) (5=0) if C_ALPHAN=="FR" 
recode V54edu (1=70.82) (2=100) (3=85.51) (4=10.43) (5=0) if C_ALPHAN=="DE" 
recode V54edu (1=0) (2=53.19) (3=73.55) (4=81.52) (5=100) if C_ALPHAN=="HU" 
recode V54edu (1=0) (2=80.23) (3=100) (4=59.21) (5=19.19) if C_ALPHAN=="IS" 
recode V54edu (1=0) (2=83.74) (3=100) (4=83.53) (5=44.39) if C_ALPHAN=="IT" 
recode V54edu (1=63.08) (2=100) (3=92.9) (4=26.56) (5=0) if C_ALPHAN=="JP" 
recode V54edu (1=0) (2=67.77) (3=90.74) (4=100) (5=76.15) if C_ALPHAN=="NO" 
recode V54edu (1=0) (2=63.84) (3=90.08) (4=100) (5=74.33) if C_ALPHAN=="PL" 
recode V54edu (1=20.08) (2=83.4) (3=100) (4=36.3) (5=0) if C_ALPHAN=="RU" 
recode V54edu (1=0) (2=55.03) (3=69.27) (4=100) (5=78.35) if C_ALPHAN=="SK" 
recode V54edu (1=0) (2=63.64) (3=77.88) (4=100) (5=96.19) if C_ALPHAN=="SI" 
recode V54edu (1=80.88) (2=100) (3=93.74) (4=17.8) (5=0) if C_ALPHAN=="ZA" 
recode V54edu (1=0) (2=76.39) (3=100) (4=74.06) (5=40.98) if C_ALPHAN=="ES" 
recode V54edu (1=9.13) (2=84.99) (3=100) (4=39.45) (5=0) if C_ALPHAN=="UK" 
recode V54edu (1=37.55) (2=94.98) (3=100) (4=34.39) (5=0) if C_ALPHAN=="US" 
}
else if degree==2 {
recode V54edu (1=24.84) (2=93.06) (3=100) (4=40.17) (5=0) if C_ALPHAN=="AU" 
recode V54edu (1=0) (2=69.28) (3=98.92) (4=100) (5=73.31) if C_ALPHAN=="TW" 
recode V54edu (1=0) (2=70.79) (3=100) (4=99.68) (5=80.08) if C_ALPHAN=="CZ" 
recode V54edu (1=0) (2=61.11) (3=83.69) (4=100) (5=82.8) if C_ALPHAN=="DK" 
recode V54edu (1=27.35) (2=92.45) (3=100) (4=37.24) (5=0) if C_ALPHAN=="EE" 
recode V54edu (1=0) (2=78.17) (3=100) (4=85.89) (5=50.04) if C_ALPHAN=="FI" 
recode V54edu (1=0) (2=95.32) (3=100) (4=86.58) (5=33.23) if C_ALPHAN=="FR" 
recode V54edu (1=19.5) (2=94.59) (3=100) (4=33.58) (5=0) if C_ALPHAN=="DE" 
recode V54edu (1=0) (2=58.6) (3=76.28) (4=100) (5=89.88) if C_ALPHAN=="HU" 
recode V54edu (1=0) (2=82.8) (3=100) (4=53.44) (5=8.39) if C_ALPHAN=="IS" 
recode V54edu (1=0) (2=80.16) (3=100) (4=99.29) (5=48.88) if C_ALPHAN=="IT" 
recode V54edu (1=64.37) (2=100) (3=87.38) (4=26.12) (5=0) if C_ALPHAN=="JP" 
recode V54edu (1=0) (2=69.48) (3=90.76) (4=100) (5=67.12) if C_ALPHAN=="NO" 
recode V54edu (1=0) (2=71.6) (3=99.88) (4=100) (5=72.03) if C_ALPHAN=="PL" 
recode V54edu (1=0) (2=76.77) (3=100) (4=55.91) (5=21.45) if C_ALPHAN=="RU" 
recode V54edu (1=0) (2=69.48) (3=99.28) (4=100) (5=75.42) if C_ALPHAN=="SK" 
recode V54edu (1=0) (2=57.43) (3=72.12) (4=100) (5=97.03) if C_ALPHAN=="SI" 
recode V54edu (1=100) (2=94.31) (3=69.73) (4=9.96) (5=0) if C_ALPHAN=="ZA" 
recode V54edu (1=0) (2=86.27) (3=100) (4=68.04) (5=26.49) if C_ALPHAN=="ES" 
recode V54edu (1=5.79) (2=87.94) (3=100) (4=43.14) (5=0) if C_ALPHAN=="UK" 
recode V54edu (1=50.56) (2=100) (3=97.65) (4=34.24) (5=0) if C_ALPHAN=="US" 
}
else if degree==3 {
recode V54edu (1=38.85) (2=97.69) (3=100) (4=43.85) (5=0) if C_ALPHAN=="AU" 
recode V54edu (1=0) (2=70.68) (3=100) (4=88.56) (5=63.52) if C_ALPHAN=="TW" 
recode V54edu (1=0) (2=79.93) (3=100) (4=60.87) (5=14.03) if C_ALPHAN=="CZ" 
recode V54edu (1=0) (2=64.03) (3=87.05) (4=100) (5=66.8) if C_ALPHAN=="DK" 
recode V54edu (1=19.53) (2=91.57) (3=100) (4=43.12) (5=0) if C_ALPHAN=="EE" 
recode V54edu (1=0) (2=74.12) (3=100) (4=87.02) (5=54.51) if C_ALPHAN=="FI" 
recode V54edu (1=0) (2=82.63) (3=100) (4=63.97) (5=15.77) if C_ALPHAN=="FR" 
recode V54edu (1=1.4) (2=86.57) (3=100) (4=44.39) (5=0) if C_ALPHAN=="DE" 
recode V54edu (1=0) (2=66.33) (3=87.82) (4=100) (5=70.57) if C_ALPHAN=="HU" 
recode V54edu (1=0) (2=76.14) (3=100) (4=94.42) (5=61.35) if C_ALPHAN=="IS" 
recode V54edu (1=24.12) (2=85.35) (3=100) (4=32.53) (5=0) if C_ALPHAN=="IT" 
recode V54edu (1=52.8) (2=100) (3=90.16) (4=30.43) (5=0) if C_ALPHAN=="JP" 
recode V54edu (1=0) (2=77.39) (3=100) (4=94.74) (5=49.53) if C_ALPHAN=="NO" 
recode V54edu (1=0) (2=72.79) (3=100) (4=80.97) (5=47.09) if C_ALPHAN=="PL" 
recode V54edu (1=0) (2=77.72) (3=100) (4=39.58) (5=3.35) if C_ALPHAN=="RU" 
recode V54edu (1=0) (2=79.46) (3=98.75) (4=100) (5=66.54) if C_ALPHAN=="SK" 
recode V54edu (1=0) (2=74.96) (3=75.41) (4=100) (5=93.7) if C_ALPHAN=="SI" 
recode V54edu (1=45.73) (2=94.81) (3=100) (4=44.3) (5=0) if C_ALPHAN=="ZA" 
recode V54edu (1=0) (2=80.19) (3=100) (4=82.26) (5=45.75) if C_ALPHAN=="ES" 
recode V54edu (1=39.62) (2=95.45) (3=100) (4=41.17) (5=0) if C_ALPHAN=="UK" 
recode V54edu (1=51.31) (2=100) (3=99.83) (4=34.23) (5=0) if C_ALPHAN=="US" 
}


label define edulabel 1 "Low" 2 "Medium" 3 "High"
label values degree edulabel
label define genderlabel 0 "Male" 1 "Female"
label values female genderlabel
label define agelabel 1 "20- to 24-year olds" 2 "25- to 29-year olds" 3 "30- to 34-year olds" ///
		4 "35- to 39-year olds" 5 "40- to 44-year olds" 6 "45- to 49-year olds" 7 "50- to 54-year olds" ///
		8 "55- to 59-year olds" 9 "60- to 64-year olds" 10 "65- to 69-year olds"
label define agelabel2 1 "20- to 29-year olds" 2 "30- to 39-year olds" ///
		3 "40- to 49-year olds" 4 "50- to 59-year olds" 5 "60- to 69-year olds"
label values age agelabel2
label define incomelabel 1 "1st" 2 "2nd" 3 "3rd" 4 "4th" 5 "5th" 6 "6th" 7 "7th" 8 "8th" 9 "9th" 10 "10th"
label values TOPBOT incomelabel
label define partylabel 1 "Left" 2 "Center" 3 "Right"
label values party partylabel
label define occlabel 1 "Managers" 2 "Professionals" 3 "Technicians \& Associate Professionals" ///
		4 "Clerical Support Workers" 5 "Service \& Sales Workers" 6 "Agricultural, forestry \& Fishery Workers" ///
		7 "Crafts \& Related Trades Workers" 8 "Operators \& Assemblers" 9 "Elementary Occupations" ///
		10 "Armed Forces"
label values occ occlabel

label variable city "Lives in Urban Areas"
label variable BC "BC"
label variable V54 "Binary Score"


eststo clear
eststo: qui reg V54 female i.degree i.TOPBOT i.age i.V5
eststo: qui reg V54 female i.degree i.TOPBOT i.age ib2.party i.occ city i.V5  
eststo: qui reg BC  female i.degree i.TOPBOT i.age ib2.party i.occ city i.V5


esttab using reg1.tex, replace label star(* 0.10 ** 0.05 *** 0.01) not ///
		alignment(D{.}{.}{-0.5}) depvars ar2 cells(b(star fmt(4))) title(Basic Regression \label{reg1}) ///
		addnotes(Add note here.)

		
		
// This is for converting the dataset to long form to prepare it for nlogit

* list V3 V54edu female, nolab
*expand 5
*sort V3
*by V3: gen temp = _n	
*gen newV54edu = (temp==V54edu)
*drop V54edu
*rename temp V54edu
* list V3 newV54edu female, nolab

*qui nlogitgen type = V54edu(A: 1, BC: 2 | 3, D: 4, E: 5)


*gen degreexB = degree*(V54edu==2)
*gen degreexC = degree*(V54edu==3)
*gen consFor = (type==2)


*nlogit newV54edu degreexB degreexC || type: female i.degree i.TOPBOT i.age ib2.party i.occ city i.V5, base(E) || V54edu:, noconstant nolog case(V3)


// GRAPHS

// This graphs shows which educational groups are more likely to look at the whole population rather than their reference groups
gen V54dif=V54-V54edu
graph bar (mean) V54dif, over(degree)

// this shows that there are differences in terms of political party
graph bar (mean) V54dif, over(party)




