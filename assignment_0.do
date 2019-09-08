***********************************
**** Joao Garcia
**** 2019-09-08
***********************************
clear

use "C:\Users\joaom\Desktop\Jesse\NEW7080.dta"

rename v1 AGE
rename v2 AGEQ
rename v4 EDUC
rename v5 ENOCENT
rename v6 ESOCENT
rename v9 LWKLYWGE
rename v10 MARRIED
rename v11 MIDATL
rename v12 MT
rename v13 NEWENG
rename v16 CENSUS
rename v18 QOB
rename v19 RACE
rename v20 SMSA
rename v21 SOATL
rename v24 WNOCENT
rename v25 WSOCENT
rename v27 YOB
drop v8

gen COHORT = "1920-1929"
replace COHORT = "1930-1939" if YOB<=39 & YOB>=30
replace COHORT = "1940-1949" if YOB<=49 & YOB>=40

keep if COHORT == "1920-1929"

gen AGEQSQ= AGEQ*AGEQ

** Generate YOB*QOB dummies ********
tab QOB, gen(QT)

forvalues year = 1920/1929{
    gen YR`year' = (YOB == `year')
  forvalues quarter = 1/4{
	gen QT`quarter'_YR`year' = (YOB == `year') & (QOB == `quarter')
  }
}

** Col 1 3 5 7 ***
reg LWKLYWGE EDUC i.YOB
reg LWKLYWGE EDUC i.YOB c.AGEQ##c.AGEQ
reg LWKLYWGE EDUC i.YOB c.AGEQ##c.AGEQ
reg LWKLYWGE EDUC RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT ///
  SOATL ESOCENT WSOCENT MT i.YOB
reg LWKLYWGE EDUC RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT ///
  SOATL ESOCENT WSOCENT MT i.YOB c.AGEQ##c.AGEQ


** Col 2 4 6 8 ***
ivregress 2sls LWKLYWGE i.YOB (EDUC = QT1_YR* QT2_YR* QT3_YR*)
ivregress 2sls LWKLYWGE i.YOB AGEQ AGEQSQ (EDUC = QT1_YR* QT2_YR* QT3_YR*)
ivregress 2sls LWKLYWGE i.YOB RACE MARRIED SMSA NEWENG MIDATL ENOCENT /// 
	WNOCENT SOATL ESOCENT WSOCENT MT (EDUC = QT1_YR* QT2_YR* QT3_YR*)
ivregress 2sls LWKLYWGE i.YOB RACE MARRIED SMSA NEWENG MIDATL ENOCENT ///
	WNOCENT SOATL ESOCENT WSOCENT MT AGEQ AGEQSQ (EDUC = QT1_YR* QT2_YR* QT3_YR*)
	
gen EDUC12 = EDUC>=12
gen QTR1 = QOB == 1

logit EDUC12 QTR1 AGEQ AGEQSQ 
margins, dydx(QTR1)



