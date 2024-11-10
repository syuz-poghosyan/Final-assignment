clear
set more off

cd "C:\Users\Poghosyan_Syuzanna\Desktop\Syuz\Data"

set linesize 80
capture log close
log using "Cleaning.log", replace
* ----------------------------------------------------------------------------

import delimited Used_cars_raw.csv, varnames(1) bindquotes(strict) encoding("utf-8") clear

describe
summarize

label variable price "Price of the car (in USD)"
label variable fuel "Fuel Type"
label variable type "Car Type"
label variable transmission "Transmission system"
label variable size "Relative size of the car"
rename paintcolor color
label variable color "Color"
label variable odometer "Distance travelled (in miles)"
label variable drive "Drivetrain type"
label variable cylinders "Number of cylinders in the engine"
label variable area "Area"
label variable subarea "Subarea"


generate productionyear = real(substr(name, 1, 4))
replace price = subinstr(price, "$", "", .)
replace price = subinstr(price, ",", "", .)
destring price, replace force

destring odometer, replace force

replace name = subinstr(name, substr(name, 1, 5), "", .)
replace name = upper(name)
replace name = subinstr(name, "_", "", .)
replace name = subinstr(name, ".", "", .)
replace name = subinstr(name, "-", " ", .)
replace name = subinstr(name, "  2016", "", .)
replace name = subinstr(name, "  ", " ", .)
replace name = subinstr(name, "  ", " ", .)
tabulate name

replace area = strproper(area)
replace subarea = strproper(subarea)

replace type = "" if type == "NA"
codebook type

keep price area name fuel odometer productionyear dealer type transmission color

keep if type =="sedan" & transmission == "automatic" & !missing(odometer)
replace color = "" if color == "NA"
drop if missing(color)
drop if missing(price)

mkdir "New_Data"
save New_Data\Used_cars_clean.dta


* ----------------------------------------------------------------------------
log close
