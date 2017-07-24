^#^ Programming

Stata features the ability to create user-written commands. These can range from simple data manipulation commands to completely new statistical
models. This is an advanced feature that not many users will need.

However, there are several components of the programming capabilities which are very useful even without writing your own commands. Here we'll discuss
several.

Let's open a fresh version of "auto"

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~

^#^^#^ Macros

While variables stored as strings aren't of much use to us, strings stored as other strings can be quite useful. Imagine the following scenario: You
have a collection of 5 variables that you want to perform several different operations on. You might have code like this:

```
list var1 var2 var3 var4 var5 in 1/5
summ var1 var2 var3 var4 var5
label define mylab 0 "No" 1 "Yes"
label values var1 var2 var3 var4 var5 mylab
duplicates list var1 var2 var3 var4 var5
```

This can get extremely tedious as the number of variables and commands increases. You could copy and paste a lot, but even that takes a lot of effort.

Instead, we can store the list of variables (strictly speaking, the string which contains the list of variables) in a shorter key string, and refer to
that instead!

```
local vars = "var1 var2 var3 var4 var5"
list `vars' in 1/5
summ `vars'
label define mylab 0 "No" 1 "Yes"
label values `vars' mylab
duplicates list `vars'
```

The first command, `local`, defines what is known as a "local macro"^["Local" as opposed to "global", a distinction which is not important until you
get deep into programming. For now, `local` is the safer option.]. Whenever it is referred to, wrapped in a backtick (to the left of the 1 key at the
top-left of the keyboard) and a single quote, Stata replaces it with the original text. So when you enter

```
list `vars' in 1/5
```

Stata immediately replaces \\`vars' with var1 var2 var3 var4 var5, then executes

```
list var1 var2 var3 var4 var5 in 1/5
```

**Important**: Local macros are deleted as soon as code finishes executing! That means that you must use them in a do-file, and **you must run all
lines which create and access the macro at the same time**, by highlighting them all.

Some other notes:

- If your macro contains text that should be quoted, you still need to quote it when accessing. For example, if you had

    ```
    label variable price1 "Price (in dollars) at Time Point 1"
    label variable price2 "Price (in dollars) at Time Point 2"
    ```

    you could instead write

    ```
    local pricelab = "Price (in dollars) at Time Point"
    label variable price1 "`pricelab' 1"
    label variable price2 "`pricelab' 2"
    ```
- You can use `display` to print the content of macros to the output to preview them.
~~~~
<<dd_do>>
local test = "abc"
display "`test'"
<</dd_do>>
~~~~
- You may occasionally see code that excludes the `=` in macros. The differences between including and excluding the `=` are mostly unimportant, so I
  recommend sticking with the `=` unless you specifically need the other version.

^#^^#^^#^ Class and Return

Every command in Stata is of a particular type. One major aspect of the type is what the command "returns". Some commands are n-class, which means
they don't return anything. Some are c-class, which are only used by programmers and rarely useful elsewhere. The two common ones are e-class and
r-class. The distinction between the two is inconsequential, besides that they store their "returns" in different places.

Here, `summarize` is a r-class command, so it stores its returns in "return". We can see them all by `return list`. On the other hand, `mean` (which
we haven't discussed, but basically displays summary statistics similar to `summarize` but provides some additional functionality) is an e-class
command, storing its results in `ereturn`:

~~~~
<<dd_do>>
summ price
return list
mean price
ereturn list
<</dd_do>>
~~~~

Rather than try and keep track of what gets stored where, if you look at the very bottom of any help file, it will say something like "`summarize`
stores the following in `r()`:" or "`mean` stores the following in `e()`:", corresponding to `return` and `ereturn` respectively.

Along with the [One Data](basics.html#one-data) principal, Stata also follows the One _-class principal - meaning you can only view the `return` or
`ereturn` for the most recent command of that class. So if you run a `summarize` command, then do a bunch of n-class calls (`gsort` for example), the
`return list` call will still give you the returns for that first `summarize`. However, as soon as you run another command, you lose it. You can save
any piece of it using a macro. For example, to calculate the average difference in price between foreign and domestic cars^[There are obviously other
ways to compute this, but this gives a flavor of the use.]:

~~~~
<<dd_do>>
summ price if foreign == 1
local fprice = r(mean)
summ price if foreign == 0
local dprice = r(mean)
display `dprice' - `fprice'
<</dd_do>>
~~~~

^#^^#^ loops

Using macros can simplify code if you have to use the same string repeatedly, but what if you want to perform the same command repeatedly with
different variables? Here we can use a `foreach` loop. This is easiest to see with examples.

~~~~
<<dd_do>>
sysuse pop2000, clear
<</dd_do>>
~~~~

The "pop2000" data contains data from the 2000 census, broken down by age and gender. The values are in total counts, lets say instead we want
percentages by gender. For example, what percentage of Asians in age 25-29 are male? We could generate this manually.

~~~~
<<dd_do>>
gen maletotalperc = maletotal/total
gen femtotalperc = femtotal/total
gen malewhiteperc = malewhite/white
<</dd_do>>
~~~~

This gets tedious fast as we need a total of 12 lines! Notice, however, that each line has a predictable pattern:

```
gen <gender><race>perc = <gender><race>/<race>
```

We can exploit this by creating a `foreach` loop over the racial categories and only needing a single command.

~~~~
<<dd_do>>
drop *perc
foreach race of varlist total-island {
  gen male`race'perc = male`race'/`race'
  gen fem`race'perc = fem`race'/`race'
}
list *perc in 1, ab(100)
<</dd_do>>
~~~~

Let's breakdown each piece of the command. The command syntax for `foreach` is

```
foreach <new macroname> of varlist <list of variables>
```

The loop will create a macro that you name (in the example above, it was named "race"), and repeatedly set it to each subsequent entry in the list of
variables. So in the code above, first "race" is set to "total", then the two `gen` commands are run. Next, "race" is set to "white", then the two
commands are run. Etc.

Within each of the `gen` commands, we use the backtick-quote notation just like with [macros](#macros).

Finally, we end the `foreach` line with an open curly brace, `{`, and the line after the last command within the loop has the matching close curly
brace, `}`.

We can also nest these loops. Notice that both `gen` statements above are identical except for "male" vs "fem". Let's put an internal loop:

~~~~
<<dd_do>>
drop *perc
foreach race of varlist total-island {
  foreach gender in male fem {
    gen `gender'`race'perc = `gender'`race'/`race'
  }
}
list *perc in 1, ab(100)
<</dd_do>>
~~~~

Each time "race" gets set to a new variable, we enter another loop where "gender" gets set first to "male" then to "fem". To help visualize it, here
is what "race" and "gender" are set to each time the `gen` command is run:

| `gen` command | "race"     | "gender"   |
|:-------------:|:----------:|:----------:|
| 1             | total      | male       |
| 2             | total      | fem        |
| 3             | white      | male       |
| 4             | white      | fem        |
| 5             | black      | male       |
| 6             | black      | fem        |
| 7             | indian     | male       |
| 8             | indian     | fem        |
| 9             | asian      | male       |
| 10            | asian      | fem        |
| 11            | island     | male       |
| 12            | island     | fem        |

Notice the syntax of the above two `foreach` differs slightly:

```
foreach <macro name> of varlist <variables>
foreach <macro name> in <list of strings>
```

It's a bit annoying, but Stata handles the "of" and "in" slight differently. The "in" treats any strings on the right as strict. Meaning if the above
loop were

```
foreach race in total-island
```

then Stata would set "race" to "total-island" and the `gen` command would run once! By using "of varlist", you are telling Stata that before it sets
"race" to anything, expand the varlist using the [rules such as `*` and `-`](basics.html#referring-to-variables).

There is also

```
foreach <macro name> of numlist <list of numbers>
```

The benefit of "of numlist" is that numlists support things like 1-4 representing 1, 2, 3, 4. So

```
foreach num of numlist 1 3-5
```

Loops over 1, 3, 4, 5, whereas

```
foreach num in 1 3-5
```

loops over just "1" and "3-5".

The use of "in" is for when you need to loop over strings that are neither numbers nor variables (such as "male" and "fem" from above).

^#^^#^ Suppressing output and errors

There are two useful command prefixes that can be handy while writing more elaborate Do-files.

^#^^#^^#^ `capture`

Imagine the following scenario. You want to write a Do-file that generates a new variable. However, you may need to re-run chunks of the Do-file
repeatedly, so that the `gen` statement is hit repeatedly. After the first `gen`, we can't call it again
and [need to use `replace` instead](data-manipulation.html#replace). However, if we used `replace`, it wouldn't work the first time! One solution is
to `drop` the variable before we gen it:


~~~~
<<dd_do>>
sysuse auto, clear
drop newvar
gen newvar = 1
<</dd_do>>
~~~~

That error, while not breaking the code, is awfully annoying! However, if we prefix it by `capture`, the error (and *all output from the command*) are
"captured" and hidden.

~~~~
<<dd_do>>
list price in 1/5
capture list price in 1/5
list abcd
capture list abcd
<</dd_do>>
~~~~

Therefore, the best way to generate our new variable is

~~~~
<<dd_do>>
capture drop newvar
gen newvar = 1
<</dd_do>>
~~~~

^#^^#^^#^ `quietly`

`quietly` does the same basic thing as `capture`, except it does not hide errors. It can be useful combined
with [the returns](programming.html#class-and-return):

~~~~
<<dd_do>>
quietly summ price
display r(mean)
<</dd_do>>
~~~~

This will come in very handy when you start running statistical models, where the output can be over a single screen, whereas you only want a small
piece of it.

Just to make the difference between `capture` and `quietly` clear:

~~~~
<<dd_do>>
list price in 1/5
quietly list price in 1/5
capture list price in 1/5
list abcd in 1/5
quietly list abcd in 1/5
capture list abcd in 1/5
<</dd_do>>
~~~~
