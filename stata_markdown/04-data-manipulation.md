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

^#^^#^^#^ `keep`, `drop`

^#^^#^ encode/decode/tostring/destring

^#^^#^ sorting

^#^^#^ Merging Files

^#^^#^ Reshaping Files

^#^^#^ Dealing with duplicates
