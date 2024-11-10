clear
set more off

cd "C:\Users\Poghosyan_Syuzanna\Desktop\Syuz\Data"

set linesize 80
capture log close
log using "Summary and Graph.log", replace
* ----------------------------------------------------------------------------

use "New_Data\Used_cars_clean.dta", clear 

describe
summarize


summarize price if dealer == 1, detail
summarize price if odometer < 300000 & fuel == "gas", detail


egen mean_price = mean(price), by(dealer)
generate difference_price = price - mean_price
summarize difference_price

gen relative_price = "low" if difference_price <0
replace relative_price = "high" if missing(relative_price)

twoway scatter price odometer



* ----------------------------------------------------------------------------
log close
