********************************************************************************
*-------------------------------- Pride & Protest -----------------------------*
* Francisco Olivos
* June 11 
********************************************************************************

clear all

global root   = "C:\Users\fjoli\Dropbox\Data\Image de Chile"
global output = "C:\Users\fjoli\Dropbox\200697 Pride and Protests\Results"

use "${root}\image_regionrecode.dta"

********************************************************************************
*************DATA MANAGEMENT
********************************************************************************


*************Estallido social

gen treat = .
replace treat = 1 if date_diff>0
replace treat = 0 if date_diff<=0

lab var treat "Social crisis"

*************Country Pride

gen pride_CL = P1
lab var pride "Pride toward the country"

*************Energy

gen energy = P3_3
lab var energy "Proud of Chileans: Energy"

*************Symbols

gen pride_sym = P3_9
lab var pride_sy "Proud of Chile: Symbols"

*************Economic Development

gen pride_dev = P11_1
lab var pride_dev "Proud of Chile: Economic development"

*************Place to Live

gen pride_pl = P11_3
lab var pride_pl "Proud of Chile: Place to live"

*************Effort

recode P14 (2=1) (1=0) (3/6=0), gen(pride_esf)
lab var pride_esf "Proud of Chileans: Effort"


*************Gender (sexo)
tab      sexo
clonevar gender = sexo
recode   gender (1=0) (2=1)
lab var  gender "Female"
lab def  gender 1 "Female"  0 "Male"
lab val  gender gender

tab gender

*************Age (edad)

tab edad
clonevar age = edad
lab var age "Age"

recode age (17/35=1) (36/50=2) (51/65=3) (66/87=4), gen(age_4)
lab var age_4 "Age range"
lab def age 1 "17-35" 2 "36-50" 3 "51-65" 4 "66-87"
lab val age age

tab age_4, gen(age)

lab var age1 "17-35"
lab var age2 "36-50"
lab var age3 "51-65"
lab var age4 "66-87"

*************Political position (C2)

clonevar polpos = C2
recode polpos (1/4=1) (5=2) (6/10=3) (77=4)
lab var polpos "Political identification"
lab def polpos 1 "Left" 2 "Center" 3 "Right" 4 "None"
tab polpos, gen(polpos)

lab var polpos1 "Left"
lab var polpos2 "Center"
lab var polpos3 "Right"
lab var polpos4 "None"

*************Region

clonevar geozone = region
recode geozone (1/4=1) (15=1) (5/6=2) (13=3) (7/14=4) (16=4)
lab var geozone "Geographical zone"
lab def zone 1 "North" 2 "Center" 3 "Metropolitan Region" 4 "South"
lab val geozone zone 
tab geozone, gen(zone)

lab var zone1 "North"
lab var zone2 "Center"
lab var zone3 "Metropolitan Region"
lab var zone4 "South"

*************Respondent's educational level (C3)

clonevar edu = C3
recode edu (1/6=1) (7=2) (8/12=3)
lab var edu "Educational Level"
lab def edu 1 "Less than secondary" 2 "Secondary completed" 3 "More than secondary" 
tab edu, gen(edu)

lab var edu1 "Less than secondary"
lab var edu2 "Secondary completed"
lab var edu3 "More than secondary"

*************Number of people living in the same household (integrantes)

clonevar household = integrantes
lab var household "Number of household members"
recode household (1=1) (2=2) (3=3) (4/7=4)
lab def household 1 "One" 2 "Two" 3 "Three" 4 "Four or more"
lab val household household

tab household, gen(household)

lab var household1 "One"
lab var household2 "Two"
lab var household3 "Three"
lab var household4 "Four or more"


********************************************************************************
*************Analysis
********************************************************************************


*************Aalytical Sample

mark sample
markout sample gender age zone1 zone2 zone3 zone4 edu1 edu2 edu3 household1 household2 household3 household4 ///
               pride_CL pride_esf energy pride_sym pride_dev pride_pl treat 
tab sample
xx
*************Balance

sum gender ///
    age1 age2 age3 age4 ///
	polpos1 polpos2 polpos3 polpos4 ///
	zone1 zone2 zone3 zone4 ///
	edu1 edu2 edu3 ///
	household1 household2 household3 household4

tabstat gender ///
    age1 age2 age3 age4 ///
	polpos1 polpos2 polpos3 polpos4 ///
	zone1 zone2 zone3 zone4 ///
	edu1 edu2 edu3 ///
	household1 household2 household3 household4 if treat==0 & sample==1, stat(mean) columns(statistics)
		
tabstat gender ///
    age1 age2 age3 age4 ///
	polpos1 polpos2 polpos3 polpos4 ///
	zone1 zone2 zone3 zone4 ///
	edu1 edu2 edu3 ///
	household1 household2 household3 household4 if treat==1 & sample==1, stat(mean) columns(statistics)
	
tabstat gender ///
    age age1 age2 age3 age4 ///
	polpos1 polpos2 polpos3 polpos4 ///
	zone1 zone2 zone3 zone4 ///
	edu1 edu2 edu3 ///
	household1 household2 household3 household4 if sample==1, by(treat) stat(mean) 
	
*foreach var of varlist gender ///
*    age ///
*	polpos1 polpos2 polpos3 polpos4 /// Here we have some differences. But these variables are probable affected by T
*	zone1 zone2 zone3 zone4 /// Slight difference in zone3 
*	edu1 edu2 edu3 ///
*	household1 household2 household3 household4 {
*	ttest `var' if sample==1, by(treat)
*	}
	
foreach var of varlist gender ///
    age ///
	zone1 zone2 zone3 zone4 /// Slight difference in zone3 
	edu1 edu2 edu3 ///
	household1 household2 household3 household4 {
	ttest `var' if sample==1, by(treat)
	}
		
*********OLS Models	
	
foreach var of varlist ///
   pride_CL energy pride_esf pride_sym pride_dev pride_pl{ 
   reg `var' i.treat if sample==1
   sleep 1000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

*********OLS + Controls

foreach var of varlist ///
   pride_CL energy pride_esf pride_sym pride_dev pride_pl{ 
   reg `var' i.treat ///
		gender ///
		age ///
		zone1 zone2 zone4 /// Metropolitan Region as ref cat
		edu1 edu3 /// Secondary completed as ref cat
		household2 household3 household4 if sample==1 // Alone as ref cat
   sleep 1000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

*********EBalance

ebalance treat gender age geozone edu household

foreach var of varlist ///
   pride_CL energy pride_esf pride_sym pride_dev pride_pl{ 
   reg `var' i.treat ///
		[aw=_webal] if sample==1 //
   sleep 1000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

saveold "C:\Users\fjoli\Dropbox\200697 Pride and Protests\pride_protests.dta", replace version(12)
