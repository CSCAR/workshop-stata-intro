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

In addition to direct arithmatic equations, we can use a number of functions to perform calculations. For example, a common transformation is to take
the log of any dollar amount variable, in our case `price`. This is done because typical dollar amount variables, such as price or salary, tend to be
very right-skewed - most people make $30k-50k, and a few people make 6 or 7 digit incomes.

~~~~
<<dd_do>>
generate logprice = log(price)
label variable logprice "Log price"
list *price in 1/5
<</dd_do>>
~~~~

In that command, `log` is the function name, and it is immediately followed by parantheses which enclose the variable to operate on. Read the
parantheses as "of", so that `log(price)` is read as "log of price".

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


^#^^#^^#^ Creating dummies

Dummy variables (also known as indicator variables or binary variables) are variables which take on two values, 0 and 1^[Technically and mathmetically
they can take on any two values, but your life will be easier if you stick with the 0/1 convention.]. These are typically used in a setting where the
0 represents an absence of something (or an answer of "no") and 1 represents the presence (or an answer of "yes"). When naming dummy variables, you
should keep this in mind to make understanding the variable easier, as well as extracting interpretations regarding the variable in a model.

For example, "gender" is a poor dummy variable - what does 0 gender or 1 gender represent? Obviously we could (and should)
use [value labels](data-management.html#value-labels) to associate 0 and 1 with particular genders, but it is more straightforward to use "female" as
the dummy variable - a 0 represents "no" to the question of "Female?", hence male; and a 1 represents a "yes", hence female.

If you are collecting data, consider collecting data as dummies where appropriate - if the question has a binary response, encode it as a dummy
instead of strings. If a question has categorical responses, consider encoding them as a series of dummy variables instead (e.g. "Are you from MI?",
"Are you from OH?" etc). These changes will (usually) need to be made later anyways.

Before we discuss creating dummy variables, we need to understand logical operators. Consider the following statements

^$$^
  4 \gt 2
^$$^
^$$^
  1 \gt 2
^$$^


Remembering back to middle school math classes that ^$^\gt^$^ means "greater than", clearly the first statement is true and the second statement is
false. We can assign values of true and false to any such conditional statements, which use the following set of conditional operators:

| Sign       | Definition                     | True example                        | False example                      |
|:----------:|:-------------------------------|:-----------------------------------:|:----------------------------------:|
| ^$^==^$^   | equality                       | ^$^3 == 3^$^                        | ^$^3 == 2^$^                       |
| ^$^!=^$^   | not equal                      | ^$^3 != 4^$^                        | ^$^3 != 3^$^                       |
| ^$^\gt^$^  | greater than                   | ^$^4 \gt 2^$^                       | ^$^1 \gt 2^$^                      |
| ^$^\lt^$^  | less  than                     | ^$^1 \lt 2^$^                       | ^$^4 \lt 2^$^                      |
| ^$^\gt=^$^ | greater than or equal to       | ^$^4 \gt= 4^$^                      | ^$^1 \gt= 2^$^                     |
| ^$^\lt=^$^ | less than or equal to          | ^$^1 \lt= 1^$^                      | ^$^4 \lt= 2^$^                     |
| \&         | and (both statements are true) | ^$^(4 \gt 2)^$^ \& ^$^(3 == 3)^$^   | ^$^(4 \gt 2)^$^ \& ^$^(1 \gt 2)^$^ |
| ^$^\|^$^   | or (either statement is true)  | ^$^(3 == 2) \| (1 \gt= 2)^$^        | ^$^(4 \lt 2) \| (1 \gt 2)^$^       |

You can also use paranthese in combination with \& and ^$^\|^$^ to create more logical statements (e.g. TRUE \& (FALSE ^$^\|^$^ TRUE) returns true).

Now here's the catch: In Stata^[This is true of most statistical software in fact], conditional statements return 1 (True) and 0 (False). So we can
use them in `generate` statements to create binary variables easily.

~~~~
<<dd_do>>
generate price_over_40k = price > 4000
list price price_over_40k in 1/5, abbr(100)
<</dd_do>>
~~~~

(Note that `list` truncates variable names to 8 characters by default. The `abbr(#)` argument abbreviates to other lengths; setting it to a large
number removes abbreviating at all.)

Now, `price_over_40k` takes on values 1 and 0 depending on whether the conditional statement was true.

For a slightly more complicated example, lets create a dummy variable representing cheap cars. There are two possible definitions of cheap cars - cars
which have a low cost, or cars which have low maintenance costs (high mileage and low repairs).

~~~~
<<dd_do>>
generate cheap = price < 3500 | (rep78 <= 2 & mpg > 20)
list make price rep78 mpg if cheap == 1
<</dd_do>>
~~~~

The `list` commands conditions on `cheap == 1` because again, the conditional statement will return 1 for true and 0 for false. So we see three cheap
cars, two with low cost and one with low maintenance.

^#^^#^^#^ Hidden variables

The name "hidden variables" may be slightly more dramatic than need be. In Stata, under the [One Data](basics.html#one-data) principal, any
information in the data^[We'll see some exceptions to this in the [programming](programming.html) section.] must be in a variable. This includes the
so called "hidden variables" of `_n` and `_N`. You can imagine that each row of your data has two additional columns of data, one for `_n` and one for `_N`.

`_n` represents the row number currently. Currently, meaning if the data is re-sorted, `_n` can change.

`_N` represents the total number of rows in the data, hence this is the same for every row. Again, if the data changes (e.g. you [drop](#keep-drop)
some data) then `_N` may be updated.

While you cannot access these hidden variables normally, you can use them in generating variables or conditional statements. For example, we've seen
that `list` can use `in` to restrict the rows it outputs, and we've seen that it can use `if` to choose conditionally. We can combine these:

~~~~
<<dd_do>>
list make in 1/2
list make if _n <= 2
<</dd_do>>
~~~~

A more useful example is to save the initial row numbering in your data. When we discuss [sorting](#sorting) later, it may be useful to be able to
return to the original ordering. Since `_n` changes when the data is re-sorted, if we save the initial row numbers to a permanent variable, we can
always re-sort by it later. `_N` is slightly less useful but can be used similarly.

~~~~
<<dd_do>>
generate row = _n
generate totalobs = _N
list row totalobs in 1/5
<</dd_do>>
~~~~

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

`replace` features syntax identical to `generate`.^[`generate` has a few features we don't discuss which `replace` doesn't support. Namely, `generate`
can set the [type](data-managedment.html#compress) manually (instead of letting Stata choose the best type automatically), and `generate` can place
the new variable as desired rather than [using `order`](data-management.html#managing-variables). Clearly, neither of these features are needed for
`replace`.]

^#^^#^^#^ Conditional variable generation

One frequent task is recoding variables. This can be "binning" continuous variables into a few categories, re-ordering an ordinal variables, or
collapsing categories in an already-categorical variable. There are also mulit-variable versions; e.g. combining multiple variables into one.

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

^#^^#^ Subsetting

Almost any Stata command which operates on variables can operate on a subset of the data instead of the entire data, using the conditional statements
we just learned. Specifically, we can append the `if <condition>` to a command, and the command will be executed as if the data for which the
conditional does not return True does not exist. This is equivalent to throwing away some data and then peforming the command. In general, you should
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

There is a strong assumption here that `foreign` is already sorted. If `foreign` were not sorted (or if you simply didn't want to check/assume it was), you could instead use

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

By placing `date` in parantheses, this ensures that within each `id`, the data is sorted by `date`. Therefore the first row for each patient is their
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

`drop` removes any listed variables, or removes any row which the codnitional returns true.

^#^^#^ Working with strings and categorical variables

String variables are commonly used during data collection but are ultimately not very useful from a statistical point of view. Typically string
variables should be represented as [categorical variables with value labels](data-management.html#label-values) as we've previously discussed. Here
are some useful commands for operating on strings and categorical variables.

^#^^#^^#^ `destring` and `tostring`

These two commands convert strings and numerics between each other.

```
destring <variable>, gen(<newvar>)
tostring <variable>, replace
```

Either can take `replace` (to replace the existing variable with the new one) or `gen( )` (to generate a new variable). I would recommend always using
`gen` to double-check that the conversion worked as expected, then using `drop`, `rename` and `order` to replace the existing variable.

~~~~
<<dd_do>>
desc mpg
tostring mpg, gen(mpg2)
desc mpg2
list mpg* in 1/5
<</dd_do>>
~~~~
Now that the new string is correct, we can replace the existing `mpg`.
~~~~
<<dd_do>>
drop mpg
rename mpg2 mpg
order mpg, after(price)
<</dd_do>>
~~~~
Let's go the other way around:
~~~~
<<dd_do>>
desc mpg
destring mpg, gen(mpg2)
desc mpg2
list mpg* in 1/5
drop mpg
rename mpg2 mpg
order mpg, after(price)
<</dd_do>>
~~~~
And we're back to the original set-up^[If you are sharp-eyed, you may have noticed that the original `mpg` was an "int" whereas the final one is a "byte". If we had called [`compress`](data-management.html$compress) on the original data, it would have done that type conversion anyways - so we're ok!]

When using `destring` to convert a string variable (that it storing numeric data as strings - "13", "14") to a numeric variable, if there are *any*
non-numeric entries, `destring` will fail:

~~~~
<<dd_do>>
destring make, gen(make2)
<</dd_do>>
~~~~

We must pass the `force` option. With this option, any strings which have non-numeric variables will be marked as missing.

~~~~
<<dd_do>>
destring make, gen(make2) force
tab make2, mi
<</dd_do>>
~~~~

`tostring` also accepts the `force` option when using `replace`, we recommend instead to **never** use `replace` with `tostring` (you probably
shouldn't use it with `destring either!).

^#^^#^^#^ `encode` and `decode`

If we have a string variable which has non-numerical values (e.g. `race` with values "white", "black", "hispanic", etc), the ideal way to store it is
as numerical with [value labels](data-management.html#label-values) attached. While we could do this manually using a combination of `gen` and
`replace` with some conditionals, a less tedious way to do so is via `encode`.

The "auto" data set does not have a good string variable to demonstrate this on, so we'll switch to the "surface" data set, which contains sea surface
temperature measurements from a number of locations over two days. (Remember this will erase any existing unsaved changes! You won't need any
modifications you've made to "auto" going forward, but if you do want to save it, do so first!)

~~~~
<<dd_do>>
sysuse surface, clear
desc date
tab date
<</dd_do>>
~~~~

The `date` variable is a string with two values. First, let's create a numeric with value labels version manually.

~~~~
<<dd_do>>
gen date2 = date == "01mar2011"
label define date 0 "01mar2011" 1 "11mar2011"
label values date2 date
desc date2
tab date2
<</dd_do>>
~~~~

Instead, we can easily use `encode`:

~~~~
<<dd_do>>
encode date, gen(date3)
desc date3
tab date3
<</dd_do>>
~~~~

However, `encode` starts numbering at 1 instead of 0, which is not ideal for dummy variables. To get around this, we can create our value label
manually first, then pass it as an argument to `encode`.

~~~~
<<dd_do>>
label define manualdate 0 "01mar2011" 1 "11mar2011"
encode date, gen(date4) label(manualdate)
tab date3
tab date3, nolab
tab date4
tab date4, nolab
<</dd_do>>
~~~~

This can be extended to allow any sort of ordering desired. For this trivial binary example, it might actually be faster to use `gen` and do it
manually, but for a variable with a large number of categories, this is much easier.

^#^^#^ sorting

^#^^#^ Merging Files

^#^^#^ Reshaping Files

^#^^#^ Dealing with duplicates
