***EC313 Fall 2025
***Assignment 1 Dofile


cap log close
log using "ec313assign1key.log", replace


clear all
set more off

cd "/Users/jsmith/Library/CloudStorage/OneDrive-WilfridLaurierUniversity/Teaching/EC313/assignments"


use ec313assign1.dta, clear

*Q1

tabstat state_tax_per_pack fed_state_tax_per_pack fed_state_tax_percent cost_per_pack cig_sales_percapita cig_tax_rev if year == 1979 | year == 1999 | year == 2019, by(year)  nototal

*Q2

xtsum fed_state_tax_per_pack cost_per_pack cig_sales_percapita

*Q3

xtline fed_state_tax_per_pack

*Q4

save temp.dta, replace
collapse (mean) fed_state_tax_per_pack cost_per_pack, by(year)

twoway (line fed_state_tax_per_pack year) (line cost_per_pack year), title(Tax and Cost per Pack)

*Q5

use temp.dta, clear

regress cost_per_pack fed_state_tax_per_pack

*Q6

regress cost_per_pack fed_state_tax_per_pack i.state_abbr i.year

*Q7


regress cig_sales_percapita fed_state_tax_per_pack i.state_abbr i.year
