^#^ Data Manipulation

Let's reload the "auto" data to discard any changes made in previous sections and to start fresh.

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~


^#^^#^ `generate`

The `generate` command can be used to create new variables which are functions of existing variables. For example, if we look at the variable label
for `weight`, we see that it is measured in pounds.

~~~~
<<dd_do>>
describe weight
<</dd_do>>
~~~~

Let's create a second weight variable measured in tons. The syntax for `generate` is straightforward,

```
generate <new varname> = <function of old variables>
```

~~~~
<<dd_do>>
generate weight2 = weight/2000
<</dd_do>>
~~~~

The `list` command can be used to output some data, let's use it here to output the first 5 rows' `weight` and `weight2` variables:


~~~~
<<dd_do>>
list weight* in 1/5
<</dd_do>>
~~~~

If you check the arithmetic, you'll see that we've got the right answer. We should probably add a variable label to our new `weight`

~~~~
<<dd_do>>
label variable weight2 "Weight (tons)"
describe weight*
<</dd_do>>
~~~~

In addition to direct arithmetic equations, we can use a number of functions to perform calculations. For example, a common transformation is to take
the log of any dollar amount variable, in our case `price`. This is done because typical dollar amount variables, such as price or salary, tend to be
very right-skewed - most people make $30k-50k, and a few people make 6 or 7 digit incomes.

~~~~
<<dd_do>>
generate logprice = log(price)
label variable logprice "Log price"
list *price in 1/5
<</dd_do>>
~~~~

In that command, `log` is the function name, and it is immediately followed by parentheses which enclose the variable to operate on. Read the
parentheses as "of", so that `log(price)` is read as "log of price".

There are a lot of functions that can be used. We list some commonly used mathematical functions below for your convenience:

- `+`, `-`, `*`, `/`: Standard arithmetic
- `abs( )`: returns the absolute value
- `exp( )`: returns the exponential function of \(e^x\)
- `log( )` or `ln( )`: returns the natural logarithm of the argument
- `round( )`: returns the rounded value
- `sqrt( )`: returns the square root

Stata also offers functions for string variables, such as:

- `length( )`: returns the length of the string
- `lower( )`: returns the string in lower-case letters
- `ltrim( )`: returns the string with any leading spaces stripped
- `rtrim( )`: returns the string with any trailing spaces stripped
- `string( )`: converts a numeric value to a string value
- `upper( )`: returns the string in upper-case letters

You can see a full accounting of all functions you can use in this setting in

```
help functions
```

^#^^#^^#^ Extension to `generate`

The command `egen` offers some functionality that `generate` lacks, for example creating the mean of several variables

```
egen <newvar> = rowmean(var1, var2, var3)
```

The functions which `egen` support are fairly esoteric; you can see the full list in the help:

```
help egen
```

^#^^#^ `replace`

[Earlier](#generate) we created the `weight2` variable which changed the units on weight from pounds to tons. What if, instead of creating a new variable,
we tried to just change the existing `weight` variable.

~~~~
<<dd_do>>
generate weight = weight/2000
<</dd_do>>
~~~~

Here Stata refuses to proceed since `weight` is already defined. To overwrite `weight`, we'll instead need to use the `replace` command.

~~~~
<<dd_do>>
replace weight = weight/2000
list weight in 1/5
<</dd_do>>
~~~~

`replace` features syntax identical to `generate`.^[`generate` has a few features we do not discuss which `replace` does not support. Namely,
`generate` can set the [type](data-management.html#compress) manually (instead of letting Stata choose the best type automatically), and `generate`
can place the new variable as desired rather than [using `order`](data-management.html#managing-variables). Clearly, neither of these features are
needed for `replace`.]

^#^^#^^#^ Conditional variable generation

One frequent task is recoding variables. This can be "binning" continuous variables into a few categories, re-ordering an ordinal variables, or
collapsing categories in an already-categorical variable. There are also multi-variable versions; e.g. combining multiple variables into one.

The general workflow with these cases will be to optionally use `generate` to create the new variable, then use `replace` to conditional replace the
original or new variable.

As a first example, let's collapse the `rep78` variable into a low/mid/high cost of maintenance categorical variable (1 repair, 2-3 repairs, 4-5
repairs). First, we'll generate the new variable.

~~~~
<<dd_do>>
generate cost_maint = 1
tab cost_maint
<</dd_do>>
~~~~

Without any variables or conditions, every row is set to 1. We'll let the 1 represent the "low" category, so next we'll replace it with 2 for cars in
the "mid" category.

~~~~
<<dd_do>>
replace cost_maint = 2 if rep78 >= 2 & rep78 <= 3
tab cost_maint
<</dd_do>>
~~~~

Finish with the "high" category.

~~~~
<<dd_do>>
replace cost_maint = 3 if rep78 > 3
tab cost_maint
<</dd_do>>
~~~~

There's one additional complication. Stata represents missing values by `.`, and `.` has a value of positive infinity. That means that

^$$^
  400 \lt .
^$$^

is true! There is some discussion [on the Stata FAQs](http://www.stata.com/support/faqs/data-management/logical-expressions-and-missing-values/) that
goes into the rationale behind it, but the short version is that this slightly complicates variable generation but greatly simplifies and
protects [data management tasks](#keep-drop).

The complication referred to can be seen in row 3 here:

~~~~
<<dd_do>>
list make rep78 cost_maint in 1/5, abbr(100)
<</dd_do>>
~~~~

The AMC Spirit has a high repair cost even though we do not have its repair record. We can fix this easily.

~~~~
<<dd_do>>
replace cost_maint = . if rep78 == .
tab cost_maint, missing
<</dd_do>>
~~~~

The `missing` option to `tab` forces it to show a row for any missing values. Without it, missing rows are suppressed.

To summarize, we used the following commands:

```
generate cost_maint = 1
replace cost_maint = 2 if rep78 >= 2 & rep78 <= 3
replace cost_maint = 3 if rep78 > 3
replace cost_maint = . if rep78 == .
```

There are various other ways it could have been done, such as

```
generate cost_maint = 1 if rep78 == 1
replace cost_maint = 2 if rep78 >= 2 & rep78 <= 3
replace cost_maint = 3 if rep78 > 3 & rep78 != .
```

```
generate cost_maint = .
replace cost_maint = 1 if rep78 == 1
replace cost_maint = 2 if rep78 >= 2 & rep78 <= 3
replace cost_maint = 3 if rep78 > 3
```

Of course, we could also generate it in the reverse order (3 to 1).

^#^^#^ Missing values

^#^^#^ Subsetting

Almost any Stata command which operates on variables can operate on a subset of the data instead of the entire data, using the conditional statements
we just learned. Specifically, we can append the `if <condition>` to a command, and the command will be executed as if the data for which the
conditional does not return True does not exist. This is equivalent to throwing away some data and then performing the command. In general, you should
avoid discarding data as you never know when you will possible use it. Of course, you could
use [`preserve` and `restore`](working-with-data-sets.html#preserverestore) to temporarily remove the data, but using the conditional subsetting is
more straightforward.

~~~~
<<dd_do>>
summ price
<</dd_do>>
~~~~

This gives us a summary of price across all cars. What if we wanted to look at the summary only for non-foreign cars?

~~~~
<<dd_do>>
tab foreign
summ price if foreign == 0
<</dd_do>>
~~~~

First, we check the label to make sure we're looking at the appropriate value of `foreign`. Now, notice that "Obs", the number of rows of the data, is
only 52 as we expect! If we look also at foreign cars,

~~~~
<<dd_do>>
summ price if foreign == 1
<</dd_do>>
~~~~

we see that American cars are cheaper on average^[Note that this is not a statistical claim, we would have to do a two-sample t-test to make any
statistical claim.].

^#^^#^^#^ `by` and `bysort`

To look at the average price for American and foreign cars, we ran two individual commands. If we wanted to look at the summaries by `rep78`, that
would take 6 commands (values 1 through 5 and `.`)!

Instead, we can use `by` and `bysort` to perform the same operation over each unique value in a variable. For example, we could repeat the above with:

~~~~
<<dd_do>>
by foreign: summ price
<</dd_do>>
~~~~

There is a strong assumption here that `foreign` is already sorted. If `foreign` were not sorted (or if you simply did not want to check/assume it
was), you could instead use

```
bysort foreign: summ price
```

`bysort` is identical to [sorting](#sorting) first and running the `by` statement afterwards. In general, it is recommended to always use `bysort`
instead of `by`, *unless* you believe the data is already sorted and want an error if that assumption is violated.

Before running these commands, consider generating a [original ordering variable](#hidden-variables) first.

`bysort`'s variables cannot be conditional statements, so if you wanted to for example get summaries by low and high mileage cars, you'd need to
generate a dummy variable first.

~~~~
<<dd_do>>
gen highmileage = mpg > 20
bysort highmileage: summ price
<</dd_do>>
~~~~

`bysort` can take two or more variables, and performs its commands within each unique combination of the variable. For example,

~~~~
<<dd_do>>
bysort foreign highmileage: summ price
<</dd_do>>
~~~~

When specifying `bysort`, you can optionally specify a variable to sort on but not to group by. For example, let's say your data consisted of doctors
visits for patients, where patients may have more than one appointment. You want to generate a variable indicating whether a visit is the first by the
patient. Say `id` stores the patient id, `date` stores the date of the visit.

```
bysort id (date): gen firstvisit = _n == 1
```

By placing `date` in parentheses, this ensures that within each `id`, the data is sorted by `date`. Therefore the first row for each patient is their
first visit, so `_n == 1` evaluates to 1 only in that first row and 0 zero otherwise.

^#^^#^^#^ `keep`, `drop`

If you do want to discard data, you can use `keep` or `drop` to do so. They each can perform on variables:

```
keep <var1> <var2> ...
drop <var1> <var2> ...
```

or on observations:

```
keep if <conditional>
drop if <conditional>
```

Note that these *cannot* be combined:

~~~~
<<dd_do>>
drop turn if mpg > 20
<</dd_do>>
~~~~

`keep` removes all variables except the listed variables, or removes any row which the conditional does not return true.

`drop` removes any listed variables, or removes any row which the conditional returns true.

^#^^#^ sorting

We already saw sorting [in the context of `bysort`](#by-and-bysort). We can also sort as a standalone operation. As before, consider generating
a [original ordering variable](#hidden-variables) first.

We'll switch back to "auto" first.

~~~~
<<dd_do>>
sysuse auto, clear
gen order = _n
<</dd_do>>
~~~~

The `gsort` function takes a list of variables to order by.

~~~~
<<dd_do>>
gsort rep78 price
list rep78 price in 1/5
<</dd_do>>
~~~~

Stata first sorts the data by `rep78`, ascending (so the lowest value is in row 1). Then within each set of rows that have a common value of `rep78`,
it sorts by `price`.

You can append "+" or "-" to each variable to change whether it is ascending or descending. Without a prefix, the variable is sorted ascending.

~~~~
<<dd_do>>
gsort +rep78 -price
list rep78 price in 1/5
<</dd_do>>
~~~~

Recall that missing values (`.`) are [larger than any other values](data-manipulation.html#conditional-variable-generation). When sorting with missing
values, they follow this rule as well. If you want to treat missing values as smaller than all other values, you can pass the `mfirst` option to
`gsort`. Note this does *not* make missingness "less than" anywhere else, only for the purposes of the current search.

Sorting strings does work and it does it alphabetically. All capital letters are "less than" all lower case letters, and a blank string ("") is the
"smallest". For example, if you have the strings "DBC", "Daa", "", "EEE", the sorted ascending order would be "", "DBC", "Daa", "EEE". The blank is
first; the two strings starting with "D" are before the string "EEE", and the upper case "B" precedes the lower case "a".

As a side note, there is an additional command, `sort`, which can perform sorting. It does not allow sorting in descending order, however it does allow
you to conditionally sort; that is, passing something like `sort <varname> in <condition>` would sort only those rows for which the condition is true,
the remaining rows remain *in their exact same position*.

^#^^#^ Exercise 3

If you haven't already, open the "RDSL.subset" data.

(Note: Any "interpretation" or "explanation" in this exercise is for illustrative purposes only as I have no idea what the details of this data are!)

1. Create a new variable, `school_primary_focus`, which attempts to represent whether someone's primary focus is their schooling. This variable should
   be a binary variable with a value of 1 if the student has a GPA greater than 2.8 and is enrolled full time.
2. The variable `bage1stsex`, representing age at 1st sex, has some very low values - some that are errors (e.g. 0 or 1) and some that are hopefully
   errors (below 7). Replace values of 0 or 1 with a missing ".", and replace values between 2-7 with missing ".a".
3. Look at a table (`tab`) of public assistance. Compare it with the table of public assistant amongst blacks and non-blacks. Notice any
   relationships?
