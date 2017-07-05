^#^ Data Manipulation

Let's reload the "auto" data to discard any changes made in previous sections and to start fresh.

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~


^#^^#^ `gen`

The `gen` command can be used to create new variables which are functions of existing variables. For example, if we look at the variable label for
`weight`, we see that it is measured in pounds.

~~~~
<<dd_do>>
describe weight
<</dd_do>>
~~~~

Let's create a second weight variable measured in tons. The syntax for `gen` is straightforward,

```
gen <new varname> = <function of old variables>
```

~~~~
<<dd_do>>
gen weight2 = weight/2000
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
gen logprice = log(price)
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
  4 > 2
^$$^
^$$^
  1 > 2
^$$^


Remembering back to middle school math classes that ^$^>^$^ means "greater than", clearly the first statement is true and the second statement is
false. We can assign values of true and false to any such conditional statements, which use the following set of conditional operators:

| Sign       | Definition                     | True example                        | False example                  |
|:----------:|:-------------------------------|:-----------------------------------:|:------------------------------:|
| ^$^==^$^   | equality                       | ^$^3 == 3^$^                        | ^$^3 == 2^$^                   |
| ^$^>^$^    | greater than                   | ^$^4 > 2^$^                         | ^$^1 > 2^$^                    |
| ^$^<^$^    | less  than                     | ^$^1 < 2^$^                         | ^$^4 < 2^$^                    |
| ^$^\geq^$^ | greater than or equal to       | ^$^4 \geq 4^$^                      | ^$^1 \geq 2^$^                 |
| ^$^\leq^$^ | less than or equal to          | ^$^1 \leq 1^$^                      | ^$^4 \leq 2^$^                 |
| \&         | and (both statements are true) | ^$^(4 > 2)^$^ \& ^$^(3 == 3)^$^     | ^$^(4 > 2)^$^ \& ^$^(1 > 2)^$^ |
| ^$^\|^$^   | or (either statement is true)  | ^$^(3 == 2) \| (1 \geq 2)^$^        | ^$^(4 < 2) \| (1 > 2)^$^       |

Now here's the catch: In Stata^[This is true of most statistical software in fact], conditional statements return 1 (True) and 0 (False). So we can
use them in `gen` statements to create binary variables easily.

~~~~
<<dd_do>>
gen price_over_40k = price > 4000
list price price_over_40k in 1/5, abbr(100)
<</dd_do>>
~~~~

(Note that `list` truncates variable names to 8 characters by default. The `abbr(#)` argument abbreviates to other lengths; setting it to a large
number removes abbreviating at all.)

^#^^#^^#^ Hidden variables

`_n`, `_N`


^#^^#^ `replace`

^#^^#^^#^ Conditional generation

^#^^#^ `egen`

^#^^#^ Subsetting

^#^^#^^#^ `keep`, `drop`

^#^^#^ encode/decode/tostring/destring

^#^^#^ sorting

^#^^#^ Merging Files

^#^^#^ Reshaping Files

^#^^#^ Dealing with duplicates
