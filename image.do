********************************************************************************
*Impact of 18O on Emotions
*March 19
*Stata 14
********************************************************************************

set more off

global root = "C:\Users\fjoli\Dropbox\Data\Image de Chile"
global output = "C:\Users\fjoli\Dropbox\200318 18O and pride\Results"

use "${root}\image.dta", clear

***DATA MANAGEMENT

recode sexo (1=1) (2=0)

gen pride_CL = P1
lab var pride "Pride toward the country"

gen energy = P3_3
lab var energy "Proud of Chileans: Energy"

gen pride_in = P3_8
lab var pride_in "Proud of Chile: Income"

gen pride_sym = P3_9
lab var pride_sy "Proud of Chile: Symbols"

gen pride_dev = P11_1
lab var pride_dev "Proud of Chile: Economic development"

gen pride_pl = P11_3
lab var pride_pl "Proud of Chile: Place to live"

gen pride_dev2 = P12_3
lab var pride_dev2 "Proud of Chile: More developed"

gen pride_es = P12_4
lab var pride_es "Proud of Chile: More stable"

recode P14 (2=1) (1=0) (3/6=0), gen(esf2)
logit esf2 i.treat
lab var pride_esf "Proud of Chileans: Effort"

gen treat = .
replace treat = 1 if date_diff>0
replace treat = 0 if date_diff<=0

lab var treat "Estallido social"

***ANALYSIS

local varlist1 sexo edad C2 C3 C4 C5B integrantes ///
               pride_CL esf2 energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es treat

tabstat `varlist1' , stat(mean sd median p10 p25 p75 p90 N min max) c(s)

mark sample
markout sample sexo edad C2 C3 C4 C5B integrantes ///
               pride_CL esf2 energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es treat 
tab sample	

local varlist1 sexo edad C2 C3 C4 C5B integrantes ///
               pride_CL esf2 energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es treat
tabstat `varlist1' if sample==1 , stat(mean sd median p10 p25 p75 p90 N min max) c(s)


*Binary 

set more off
foreach var of varlist ///
pride_CL energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es{ 
ologit `var' i.treat if sample==1
outreg2 using "${output}\180", excel ///
dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

logit esf2 i.treat if sample==1
outreg2 using "${output}\180", ctitle(esf2) alpha(0.001, 0.01, 0.05) symbol(***, **, *) excel dec(3) append	

*Cov

set more off
foreach var of varlist ///
pride_CL energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es{ 
ologit `var' i.treat sexo edad C2 C3 C4 C5B integrantes if sample==1
outreg2 using "${output}\180", excel ///
drop(sexo edad C2 C3 C4 C5B integrantes) ///
dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

logit esf2 i.treat sexo edad C2 C3 C4 C5B integrantes if sample==1
outreg2 using "${output}\180", ///
drop(sexo edad C2 C3 C4 C5B integrantes) ///
ctitle(esf2) alpha(0.001, 0.01, 0.05) symbol(***, **, *) excel dec(3) append	


*Ebalance

ebalance treat sexo edad C2 C3 C4 C5B integrantes

set more off
foreach var of varlist ///
pride_CL energy pride_in pride_sym pride_dev pride_pl pride_dev2 pride_es{ 
ologit `var' i.treat sexo edad C2 C3 C4 C5B integrantes [aw=_webal] if sample==1
outreg2 using "${output}\180", excel ///
drop(sexo edad C2 C3 C4 C5B integrantes) ///
dec(3) alpha(.01, .05, .1) symbol(***, **, *) ctitle(`var') append	
}

logit esf2 i.treat sexo edad C2 C3 C4 C5B integrantes [pw=_webal] if sample==1
outreg2 using "${output}\180", ///
drop(sexo edad C2 C3 C4 C5B integrantes) ///
ctitle(esf2) alpha(0.001, 0.01, 0.05) symbol(***, **, *) excel dec(3) append	

