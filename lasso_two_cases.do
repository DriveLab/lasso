* Using the mylars code to select lasso controls

*******************************************
*				CASE I (Ethiopia)
*******************************************
** CASE I: Individual code selection for each variable/regression.

* Create a global with all the controls that should be inputs in the process

global lassocontr

* Here we use `var' because we're looping over multiple variables and multiple families of variables. This can be amended as needed.
 
mylars `var' $lassocontr, a(lasso)
di "The controls for `var' are the following: `r(names)'"

* This is where we use the modification in the mylars.do
local controls_`var' = "`r(names)'"
dis "`controls_`var''"


*******************************************
*				CASE II (Harambee)
*******************************************

* Case II: Alternately, to select only the variables that show up for more than 50% of the main outcomes under consideration.

* List all the main outcomes for which you want lasso selected controls.
local main_outcomes 

* Generating scalars for each lasso control (this does not need to be at the lasso control-outcome variable level)
foreach x in $lassocontr {
scalar s_`x'=0
}

*Looping over all the main outcomes under consideration.
foreach var in `main_outcomes' {
mylars `var' $lassocontr, a(lasso)
di "The controls for `var' are the following: `r(names)'"
local controls_`var' = "`r(names)'"

foreach x in $lassocontr {
* If the variable is selected by lasso, then we change the scalar to reflect this. 
if regexm("`controls_`var''", "`x'")  scalar s_`x'= s_`x' +1 
}
}

global final_control
* Generate a local and scalar with the number of outcomes in the main_outcomes local.
		local ncontrols: list sizeof main_outcomes
		di "`ncontrols'"
		scalar size_full=`ncontrols'
		scalar size=size_full/2 //reflects that we want it for over 50% of the main outcomes. 

		foreach x in $lassocontr {
		if scalar(s_`x')>scalar(size)  global final_control $final_control `x' 
		}
		
