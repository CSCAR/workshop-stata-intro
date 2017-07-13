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
topleft of the keyboard) and a single quote, Stata replaces it with the original text. So when you enter

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
command, storing its results in `ereturn

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
any piece of it using a macro. For example, to calculate the average difference in price between foriegn and domestic cars^[There are obviously other
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

Say you need to repeat the same code for many variables. Rather than writing the same line repeatedly, you could create a loop using `foreach`
instead.



^#^^#^ useful commands

^#^^#^^#^ capture

^#^^#^^#^  quietly
