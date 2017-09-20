^#^ Appendix

^#^^#^ Solutions

^#^^#^^#^ Exercise 1

[Exercise 1](working-with-data-sets.html#exercise-1)

1:
```
sysuse lifeexp
```

3:
```
sysuse sandstone, clear
```
or
```
clear
sysuse sandstone
```

4:
If the working directory isn't convenient, change it using the dialogue box. Then, `save sandstone`.

^#^^#^^#^ Exercise 2

[Exercise 2](data-management.html#exercise-2)

1:
```
webuse census9, clear
```

2: Data is from the 1980 census, which we can see by the label (visible in `describe, simple`). We've got two identifiers of state, death rate,
   population, median age and census region.

3: Since there data has 50 rows, it's a good guess there are no missing sates.

4: Looking at `describe`, we see that the two state identifiers are strings, the rest numeric.

5: `compress`. Nothing saved! Because Stata already did it before posting it!

^#^^#^^#^ Exercise 3

[Exercise 3](data-management.html#exercise-3)

1:
~~~~
<<dd_do>>
webuse census9, clear
save mycensus9
<</dd_do>>
~~~~

2:
~~~~
<<dd_do>>
rename drate deathrate
label variable deathrate "Death rate per 10,000"
<</dd_do>>
~~~~

3:
~~~~
<<dd_do>>
tab region
label list cenreg
label define region_label 1 "Northeast" 2 "North Central" 3 "South" 4 "West"
label values region region_label
label drop cenreg
label list
tab region
<</dd_do>>
~~~~

4:
~~~~
<<dd_do>>
save, replace
<</dd_do>>
~~~~

^#^^#^^#^ Exercise 4

[Exercise 4](data-management.html#exercise-4)

1: Use `summarize` and `codebook` to take a look at the mean/max/min. No errors detected/

2:
~~~~
<<dd_do>>
codebook, compact
<</dd_do>>
~~~~
`deathrate` and `medage` both have less than 50 unique values. This is due to both being heavily rounded. If we saw more precision, there would be more unique entires.

3:
~~~~
<<dd_do>>
codebook, problems
<</dd_do>>
~~~~
This just flags spaces (" ") in the data. Not a real problem!

^#^^#^^#^ Exercise 5

[Exercise 5](data-management.html#exercise-5)

1:
~~~~
<<dd_do>>
gen deathperc = deathrate/10000
label variable deathperc "Percentage of population deceeased in 1980"
list death* in 1/5
<</dd_do>>
~~~~

2:
~~~~
<<dd_do>>
gen agecat = 1 if medage < .
replace agecat = 2 if medage > 26.2 & medage <= 30.1
replace agecat = 3 if medage > 30.1 & medage <= 32.8
replace agecat = 4 if medage > 32.8
label define agecat_label 1 "Significantly below national average" ///
                          2 "Below national average" ///
                          3 "Above national average" ///
                          4 "Significantly above national average"
label values agecat agecat_label
tab agecat, mi
<</dd_do>>
~~~~
We have no missing data (seen with `summarize` and `codebook` in the previous exercise) but it's good practice to check for them anyways.

3:
~~~~
<<dd_do>>
bysort agecat: summarize deathrate
<</dd_do>>
~~~~
We see that the groups with the higher median age tend to have higher deathrates.

4:
~~~~
<<dd_do>>
preserve
gsort -deathrate
list state deathrate in 1
gsort +deathrate
list state deathrate in 1
gsort -medage
list state medage in 1
gsort +medage
list state medage in 1
restore
<</dd_do>>
~~~~

5:
~~~~
<<dd_do>>
encode state2, gen(statecodes)
codebook statecodes
<</dd_do>>
~~~~
