********************************************************************************
*-------------------------------- Pride & Protest -----------------------------*
* Francisco Olivos
* June 29 
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

gen treat2 = .
replace treat2 = 1 if date_diff>=46
replace treat2 = 0 if date_diff<46

lab var treat2 "Follow-up"

gen treat3 =.
replace treat3 = 0 if date_diff<0
replace treat3 = 1 if date_diff>0 & date_diff<46
replace treat3 = 2 if date_diff>=46

lab var treat3 "Time periods"

ta treat3, gen(treat_)

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
recode P14 (6=.)

*************Proud of Chileans

clonevar pride_chilean = P2
lab var pride_chilean "Proud of being Chilean"


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
               pride_CL pride_esf energy pride_sym pride_dev pride_pl pride_chilean treat 
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
	

******Table 2S: Multinomial model Table 2S	

mlogit P14 i.treat3 ///
	if sample==1, robust base(2)
	outreg2 using "${output}\multinomial_P14", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) eform ctitle(base1) replace	
	
********BALANCING TEST 

***Table 1 Balancing tests of characteristics before and after the protest movement.
mlogit treat3 gender ///
    age ///
	zone1 zone2 zone4 /// Slight difference in zone3 
	edu1 edu3 ///
	household2 household3 household4 /// 
	if sample==1, robust base(0)
	outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) eform ctitle(base1) replace
mlogit treat3 gender ///
    age ///
	zone1 zone2 zone4 /// Slight difference in zone3 
	edu1 edu3 ///
	household2 household3 household4 /// 
	if sample==1, robust base(2)
	outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) eform ctitle(base1) append
 
*********DESCRIPTIVE TIME-TREND 

***Figure 2. Time-trend of shared moral emotions (means by day).
tabstat pride_CL, by(date_diff) stat(mean)
tabstat pride_dev, by(date_diff) stat(mean)
tabstat pride_sym, by(date_diff) stat(mean)
tabstat pride_pl, by(date_diff) stat(mean)

***Figure 3. Time-trend of reciprocal moral emotions (means by day).
tabstat pride_chilean, by(date_diff) stat(mean)
tabstat energy, by(date_diff) stat(mean)

***Figure 4. Time-trend of the multinomial variable of features of Chileans (proportion by day).
tab P14, gen(emotion)
lab var emotion1 "Happy and welcoming"
lab var emotion2 "Dedicated and hardworking"
lab var emotion3 "Environmentaly conscious"
lab var emotion4 "Serious ad responsables"
lab var emotion5 "Quality of products"
tabstat emotion1, by(date_diff) stat(mean)
tabstat emotion2, by(date_diff) stat(mean)
tabstat emotion3, by(date_diff) stat(mean)
tabstat emotion4, by(date_diff) stat(mean)
tabstat emotion5, by(date_diff) stat(mean)


********MAIN MODELS (BINARY, CONTROLLED AND EBALANCE)

***Table 7BS. Means and distribution measurements before and after entropy balance for dummy social crisis.
ebalance treat_2 gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4
rename _webal weight1

***Table 7CS. Means and distribution measurements before and after entropy balance for dummy follow-up.
ebalance treat_3 gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4
rename _webal weight2

***Table 7AS. Means and distribution measurements before and after entropy balance for dummy baseline.
ebalance treat_1 gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4
rename _webal weight3

***Table 3S. Full models for indicators of shared moral sentiments with baseline as reference category.
***Table 4S. Full models for indicators of shared moral sentiments with the social crisis as reference category.
***Figure 5. Effects of the social outburst on the national pride indicators. 
	
foreach var of varlist ///
   pride_CL pride_dev pride_sym pride_pl pride_chilean energy pride_esf{ 
   reg `var' i.treat_2 i.treat_3 if sample==1, robust
   sleep 2000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var') append
   reg `var' i.treat_2 i.treat_3 ///
		gender ///
		age ///
		zone1 zone2 zone4 /// Metropolitan Region as ref cat
		edu1 edu3 /// Secondary completed as ref cat
		household2 household3 household4 if sample==1, robust // Alone as ref cat
	sleep 2000
	outreg2 using "${output}\180", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var'_c) append
   reg `var' i.treat_2 i.treat_3 ///
		[aw=weight1] if sample==1, robust
   sleep 2000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var'_w1) append
   reg `var' i.treat_2 i.treat_3 ///
		[aw=weight2] if sample==1, robust
   sleep 2000
   outreg2 using "${output}\180", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var'_w2) append
}

***Table 5S. Full models for indicators of reciprocal moral sentiments with baseline as reference category.	
***Table 6S. Full models for indicators of reciprocal moral sentiments with social crisis as reference category.
***Figure 6. Effects of the social outburst on the indicators of pride toward Chileans.

foreach var of varlist ///
   pride_CL pride_dev pride_sym pride_pl pride_chilean energy pride_esf{ 
   reg `var' i.treat_1 i.treat_3 if sample==1, robust
   sleep 2000
   outreg2 using "${output}\baseline2", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var') append
   reg `var' i.treat_1 i.treat_3 ///
		gender ///
		age ///
		zone1 zone2 zone4 /// Metropolitan Region as ref cat
		edu1 edu3 /// Secondary completed as ref cat
		household2 household3 household4 if sample==1, robust
   sleep 2000
   outreg2 using "${output}\baseline2", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var') append
   reg `var' i.treat_1 i.treat_3 ///
		[aw=weight3] if sample==1, robust
   sleep 2000
   outreg2 using "${output}\baseline2", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var') append
   reg `var' i.treat_1 i.treat_3 ///
		[aw=weight2] if sample==1, robust
   sleep 2000
   outreg2 using "${output}\baseline2", excel ///
           dec(3) alpha(.001, .01, .05) symbol(***, **, *) ctitle(`var') append
   }

xx

********HETEREOGENEITY ANALYSIS

***Figure 7. Heterogeneity of the effects by educational level.
reg pride_CL i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust
margins i.treat##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)  
marginsplot, noci

***Figure 7. Heterogeneity of the effects by educational level.
reg pride_sym i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust
margins i.treat##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)


*reg pride_CL i.treat##i.gender if sample==1 & treat3!=2, robust
*reg pride_CL i.treat##c.age if sample==1 & treat3!=2  , robust
*reg pride_CL i.treat i.edu age gender i.zone1 i.zone2 i.zone4 i.treat#i.zone1 i.treat#i.zone2 i.treat#i.zone4 if sample==1 & treat3!=2, robust


*reg pride_dev i.treat##i.gender if sample==1 & treat3!=2, robust
*reg pride_dev i.treat##c.age if sample==1 & treat3!=2  , robust
*reg pride_dev i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust
*margins i.treat##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)

*reg pride_sym i.treat##i.gender if sample==1 & treat3!=2, robust
*reg pride_sym i.treat##c.age if sample==1 & treat3!=2  , robust
*reg pride_sym i.treat i.edu age gender i.zone1 i.zone2 i.zone4 i.treat#i.zone1 i.treat#i.zone2 i.treat#i.zone4 if sample==1 & treat3!=2, robust

*reg pride_pl i.treat##i.gender if sample==1 & treat3!=2, robust
*reg pride_pl i.treat##c.age if sample==1 & treat3!=2, robust 
*reg pride_pl i.treat i.edu age gender i.zone1 i.zone2 i.zone4 i.treat#i.zone1 i.treat#i.zone2 i.treat#i.zone4 if sample==1 & treat3!=2, robust
*reg pride_pl i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust
*margins i.treat##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)

*reg energy i.treat##i.gender if sample==1 & treat3!=2, robust
*reg energy i.treat##c.age if sample==1 & treat3!=2    , robust
*reg energy i.treat i.edu age gender i.zone1 i.zone2 i.zone4 i.treat#i.zone1 i.treat#i.zone2 i.treat#i.zone4 if sample==1 & treat3!=2, robust
*reg energy i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust

*reg pride_esf i.treat##i.gender if sample==1 & treat3!=2, robust
*reg pride_esf i.treat##c.age if sample==1 & treat3!=2, robust
*reg pride_esf i.treat i.edu age gender i.zone1 i.zone2 i.zone4 i.treat#i.zone1 i.treat#i.zone2 i.treat#i.zone4 if sample==1 & treat3!=2, robust
*reg pride_esf i.treat##i.edu age gender zone1 zone2 zone4 if sample==1 & treat3!=2, robust
*margins i.treat##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)

*reg pride_CL i.treat3##i.edu age gender zone1 zone2 zone4 if sample==1, robust // sigificant interaction
*margins i.treat3##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)

*reg pride_dev i.treat3##i.edu age gender zone1 zone2 zone4 if sample==1, robust
*reg pride_sym i.treat3##i.edu age gender zone1 zone2 zone4 if sample==1, robust // sigificant interaction
*margins i.treat3##i.edu, at(age==40 gender==1 zone1==0 zone2==0 zone4==0)
 
*reg pride_pl i.treat3##i.edu age gender zone1 zone2 zone4 if sample==1, robust

/*
*Mulinomial model for characteristics
recode P14 (6=.), gen(effort_multinomial)
lab def effort 1 "Que los chilenos son alegres y acogedores" /// 
			   2 "Que los chilenos son esforzados y trabajan duro" ///
               3 "Que los chilenos cuidan su territorio y el medioambiente" ///
               4 "Que los chilenos son serios y responsables" ///
               5 "Que los chilenos tienen productos de calidad" 
lab val effort_multinomial effort

*effort as ref cat
mlogit effort_multinomial i.treatment if sample==1, robust base(2)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Only T) replace

mlogit effort_multinomial i.treatment gender ///
		age ///
		zone1 zone2 zone4 /// Metropolitan Region as ref cat
		edu1 edu3 /// Secondary completed as ref cat
		household2 household3 household4 if sample==1, robust base(2)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Controls) append
		   
mlogit effort_multinomial i.treatment [pw=_webal] if sample==1, robust base(2)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Ebalance) append

*happy as ref cat

mlogit effort_multinomial i.treatment if sample==1, robust base(1)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Only T) replace

mlogit effort_multinomial i.treatment gender ///
		age ///
		zone1 zone2 zone4 /// Metropolitan Region as ref cat
		edu1 edu3 /// Secondary completed as ref cat
		household2 household3 household4 if sample==1, robust base(1)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Controls) append
		   
mlogit effort_multinomial i.treatment [pw=_webal] if sample==1, robust base(1)
outreg2 using "${output}\multinomial", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(Ebalance) append		   

		   
*robustness check with matching	

teffects psmatch (pride_CL) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet 
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) replace		   
  
teffects psmatch (pride_dev) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) append
		   
teffects psmatch (pride_dev) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) append
		   
teffects psmatch (pride_pl) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet   
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) append
		   
teffects psmatch (energy) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet   
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) append
		   
teffects psmatch ( pride_esf) (treat gender age zone1 zone2 zone4 edu1 edu3 household2 household3 household4) if sample==1, cal(0.2) atet   
outreg2 using "${output}\matching", excel ///
           dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(pride_CL) append
	   
keep  id treat pride_CL energy pride_sym pride_dev pride_pl pride_esf ///
      gender age geozone zone1 zone2 zone3 zone4 edu edu1 edu2 edu3 ///
	  household household1 household2 household3 household4 sample _webal
	  
rename _webal webal	 

  
saveold "C:\Users\fjoli\Dropbox\200697 Pride and Protests\pride_protests.dta", replace version(12)
*/

/*Marginal effects

reg pride_CL i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Pride in the country") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(4 6)) ylabel (4 "4.0" 4.5 "4.5" 5.0 "5.0" 5.5 "5.5" 6.0 "6.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After")
graph export "${output}\pride_CL.png", replace

reg pride_sym i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Pride in symbols") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(4 6)) ylabel (4 "4.0" 4.5 "4.5" 5.0 "5.0" 5.5 "5.5" 6.0 "6.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\pride_sym.png", replace

reg pride_dev i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Pride in economic development") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(4 6)) ylabel (4 "4.0" 4.5 "4.5" 5.0 "5.0" 5.5 "5.5" 6.0 "6.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\pride_dev.png", replace


reg pride_pl i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Chile as a place to live") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(5 6)) ylabel (4 "4.0" 4.5 "4.5" 5.0 "5.0" 5.5 "5.5" 6.0 "6.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\pride_pl.png", replace

reg pride_chilean i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Pride in Chileans") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(5 7)) ylabel (5.0 "5.0" 5.5 "5.5" 6.0 "6.0" 6.5 "6.5" 7.0 "7.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\pride_chilean.png", replace

reg energy i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Chileans{ energy") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(5 7)) ylabel (5.0 "5.0" 5.5 "5.5" 6.0 "6.0" 6.5 "6.5" 7.0 "7.0") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\energy.png", replace

reg pride_esf i.treat if sample==1, robust
margins treat
marginsplot, title(" ")ytitle("Prob. Chileans' effort") scheme(s2mono) ///
            graphregion(color(white)) bgcolor(white) ///
            graphregion(margin(6 8 8 8)) ///
			yscale(range(0 1)) ylabel (0 "0" 0.2 ".2" 0.4 ".4" 0.6 ".6" 0.8 ".8" 1 "1") ///
			xscale(range(0 1)) xlabel(0 "Before" 1 "After") 
graph export "${output}\pride_esf.png", replace
*/
