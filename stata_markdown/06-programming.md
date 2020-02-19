^#^ Programming & Advanced Features

Stata features the ability to create user-written commands. These can range from simple data manipulation commands to completely new statistical
models. This is an advanced feature that not many users will need.

However, there are several components of the programming capabilities which are very useful even without writing your own commands. Here we'll discuss
several.

Let's open a fresh version of "auto":

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
- You may occasionally see code that excludes the `=` in defining a macro (e.g. `local vars "var1 var2"`). The differences between including and
  excluding the `=` are mostly unimportant, so I recommend sticking with the `=` unless you specifically need the other version.

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

Along with the [One Data][one data] principal, Stata also follows the One _-class principal - meaning you can only view the `return` or `ereturn` for
the most recent command of that class. So if you run a `summarize` command, then do a bunch of n-class calls (`gsort` for example), the `return list`
call will still give you the returns for that first `summarize`. However, as soon as you run another r-class command, you lose access to the first
one. You can save any piece of it using a [macro][macros]. For example, to calculate the average difference in price between foreign and domestic
cars^[There are obviously other ways to compute this, but this gives a flavor of the use.]:

~~~~
<<dd_do>>
summ price if foreign == 1
local fprice = r(mean)
summ price if foreign == 0
local dprice = r(mean)
display `dprice' - `fprice'
<</dd_do>>
~~~~

^#^^#^ Variable Lists

Introduced in Stata 16, variable lists solves a common technique used in previous versions of Stata to define a global containing a list of variables
to be used later in the document. For example, you might see something like this at the top of a Do file:

```
global predictors x1 x2 x3 x4
```

then further down the document something like

```
regress y $predictors
logit z $predictors
```

Stata has formalized this concept with the addition of the `vl` command (**v**ariable **l**ist). It works similarly to the use of globals: lists of variables are defined, then later reference via the `$name` syntax. However, using `vl` has the benefits of improved organization, customizations unique to variable lists, error checking, and overall convenience.

^#^^#^^#^ Initialization of Variable Lists

To begin using variable lists, `vl set` must be run.

~~~~
<<dd_do>>
sysuse auto
vl set
<</dd_do>>
~~~~

This produces a surprisingly large amount of output. When you initialize the use of variable lists, Stata will automatically create four variable lists, called the "System variable lists". Every *numeric* variable in the current data set is automatically placed into one of these four lists:

- `vlcategorical`: Variables which Stata thinks are categorical. These generally have to be non-negative, integer valued variables with less than 10 unique values.
- `vlcontinuous`: Variables which Stata thinks are continuous. These generally are variables which have negative values, have non-integer values, or are non-negative integers with more than 100 unique values.
- `vluncertain`: Variables which Stata is unsure whether they are continuous or categorical. These generally are non-negative integer valued variables with between 10 and 100 unique values.
- `vlother`: Any numeric variables that aren't really useful - either all missing or constant variables.

There is a potential fifth system variable list, `vldummy`, which is created when option `dummy` is passed. Unsurprisingly, this will take variables containing only values 0 and 1 out of `vlcategorical` and into this list.

The "Notes" given below the output are generic; they appear regardless of how well Stata was able to categorize the variables. They can be suppressed with the `nonotes` option to `vl set`^[My guess is that `nonotes` will become the default in a version or 2, once users become used to `vl`.].

The two thresholds given above, 10 and 100, can be adjusted by the `categorical` and `uncertain` options. For example,

```
vl set, categorical(20) uncertain(50)
```

Running `vl set` on an already `vl`-set data set will result in an error, unless the `clear` option is given, which will re-generate the lists.

~~~~
<<dd_do>>
vl set, dummy nonotes
vl set, dummy nonotes clear
<</dd_do>>
~~~~

In the above, we changed our minds and wanted to include the `vldummy` list, but since we'd already `vl`-set, we had the `clear` the existing set.

^#^^#^^#^ Viewing lists

When initializing the variable lists, we're treated to a nice table of all defined lists. We can replay it via

~~~~
<<dd_do>>
vl dir
<</dd_do>>
~~~~

To see the actual contents of the variable lists, we'll need to sue `vl list`.

~~~~
<<dd_do>>
vl list
<</dd_do>>
~~~~

This output produces one row for each variable *in each variable list it is in*. We haven't used this yet, but variables can be in multiple lists.

We can list only specific lists:

~~~~
<<dd_do>>
vl list vlcategorical
<</dd_do>>
~~~~

or specific variables

~~~~
<<dd_do>>
vl list (turn weight)
<</dd_do>>
~~~~

If "turn" was in multiple variable lists, each would appear as a row in this output.

There's a bit of odd notation which can be used to sort the output by variable name, which makes it easier to identify variables which appear in multiple lists.

~~~~
<<dd_do>>
vl list (_all), sort
<</dd_do>>
~~~~

The `(_all)` tells Stata to report on all variables, and sorting (when you specify at least one variable) orders by variable name rather than variable list name.

This will also list any numeric variables which are not found in **any** list.

^#^^#^^#^^#^ Moving variables in system lists

After initializing the variable lists, if you plan on using the system lists, you may need to move variables around (e.g. classifying the `vluncertain` variables into their proper lists). This can be done via `vl move` which has the syntax

```
vl move (<variables to move>) <destination list>
```

For example, all the variables in `vluncertain` are actually continuous:

~~~~
<<dd_do>>
vl list vluncertain
vl move (price mpg trunk weight length turn displacement) vlcontinuous
vl dir
<</dd_do>>
~~~~

Alternatively, since we're moving all variables in `vluncertain`, we can see our first use of the variable list!

~~~~
<<dd_do>>
vl set, dummy nonotes clear
vl move ($vluncertain) vlcontinuous
<</dd_do>>
~~~~

Note that variable lists are essentially just global macros so can be referred to via `\$name`. Note, however, that the `\$` is only used when we want to actually use the variable list as a macro - in this case, we wanted to expand `vluncertain` into it's list of variables. When we're referring to a variable list in the `vl` commands, we *do not* use the `\$`.

^#^^#^^#^ User Variable Lists

In addition to the System variable lists, you can define your own User variables lists, which I imagine will be used far more often. These are easy to create with `vl create`:

~~~~
<<dd_do>>
vl create mylist1 = (weight mpg)
vl create mylist2 = (weight length trunk)
vl dir, user
vl list, user
<</dd_do>>
~~~~

Note the addition of the `user` option to `vl list` and `vl dir` to show only User variable lists and suppress the System variable lists. We can also demonstrate the odd sorting syntax here:

~~~~
<<dd_do>>
vl list (_all), sort user
<</dd_do>>
~~~~

You can refer to variable lists in all the usual shortcut ways:

```
vl create mylist = (x1-x100 z*)
```

We can add labels to variable lists:

~~~~
<<dd_do>>
vl label mylist1 "Related to gas consumption"
vl label mylist2 "Related to size"
vl dir, user
<</dd_do>>
~~~~

^#^^#^^#^^#^ Modifying User Variable Lists

First, note that with User Variable Lists, the `vl move` command **does not work**. It only works with system variable lists.

We can create new user variable lists which build off old lists with `vl create`. To add a new variable:

~~~~
<<dd_do>>
vl create mylist3 = mylist2 + (gear_ratio)
vl list, user
vl create mylist4 = mylist2 - (turn)
vl list, user
<</dd_do>>
~~~~

Instead of adding (or removing) single variables at a time, we can instead add or remove lists. Keeping with the comment above, you do *not* use `\$` here to refer to the list.

~~~~
<<dd_do>>
vl create mylist5 = mylist2 - mylist1
vl list mylist5
<</dd_do>>
~~~~

However, if we want to simply modify an existing list, a better approach would be the `vl modify` command. `vl create` and `vl modify` are similar to `generate` and `replace`; the former creates a new variable list while the later changes an existing variable list, but the syntax right of the `=` is the same.

~~~~
<<dd_do>>
vl modify mylist3 = mylist3 + (headroom)
vl modify mylist3 = mylist3 - (weight)
<</dd_do>>
~~~~

^#^^#^^#^ Dropping variable list

Variable lists can be dropped via `vl drop`

~~~~
<<dd_do>>
vl dir, user
vl drop mylist4 mylist5
vl dir, user
<</dd_do>>
~~~~

System lists cannot be dropped; if you run `vl drop vlcontinuous` it just removes all the variables from it.

^#^^#^^#^ Using Variable Lists

To be explicit, we can use variable lists in any command which would take the variables in that list. For example,

~~~~
<<dd_do>>
describe $mylist3
describe $vlcategorical
<</dd_do>>
~~~~

We can also use them in a modeling setting.

~~~~
<<dd_do>>
regress mpg $mylist3
<</dd_do>>
~~~~

However, we'll run into an issue here - how to specify categorical variables or interactions? The `vl substitute` command creates "factor-variable lists" that can include factor variable indicators (`i.`), continuous variable indicators (`c.`), and interactions (`#` or `##`). (The name "factor-variable list" is slightly disingenuous; you could create a "factor-variable list" that includes no actual factors, for example, if you wanted to interact two continuous variables.)

Creating a factor-varible list via `vl substitute` can be done by specifying variables or variable lists.

~~~~
<<dd_do>>
vl substitute sublist1 = mpg mylist3
display "$sublist1"
vl dir
<</dd_do>>
~~~~

Note the use of `display "\$listname"` instead of `vl list`. Factor-variable lists are not just lists of vairables, they also can include the features above, so must be displayed. Note that in the `vl dir`, "sublist1" has no number of variables listed, making it stand apart.

We can make this more interesting by actually including continuous/factor indicatores and/or interactions.

~~~~
<<dd_do>>
vl substitute sublist2 = c.mylist1##i.vldummy
display "$sublist2"
<</dd_do>>
~~~~

Note the need to specify that mylist1 is continuous (with `c.`). It follows the normal convention that Stata assumes predictors in a model are continuous by default, unless they're invloved in an interaction, in which case it assumes they are factors by default.

~~~~
<<dd_do>>
regress price $sublist2
<</dd_do>>
~~~~

^#^^#^^#^^#^ Updating factor-variable Lists

Factor-variable lists cannot be directly modified.

~~~~
<<dd_do>>
display "$sublist1"
vl modify sublist1 = sublist1 - mpg
<</dd_do>>
~~~~

However, if you create a factor-variable list using only other variable lists, if those lists get updated, so does the factor-variable list!

~~~~
<<dd_do>>
vl create continuous = (turn trunk)
vl create categorical = (rep78 foreign)
vl substitute predictors = c.continuous##i.categorical
display "$predictors"
vl modify continuous = continuous - (trunk)
quiet vl rebuild
display "$predictors"
<</dd_do>>
~~~~

Note the call to `vl rebuild`. Among other things, it will re-generate the factor-variable lists. (It produces a `vl dir` output without an option to suppress it, hence the use of [`quiet`](https://errickson.net/stata1/programming.html#quieting-the-output).)

^#^^#^^#^ Stored Statistics

You may have noticed that certain characteristics of the variable are reported.

~~~~
<<dd_do>>
vl list mylist3
<</dd_do>>
~~~~

This reports some characteristics of the variables (integer, whether it's non-negative) and the number of unique values. We can also see some other statistics:

~~~~
<<dd_do>>
vl list mylist3, min max obs
<</dd_do>>
~~~~

This is similar to [`codebook`](https://www.stata.com/manuals/dcodebook.pdf) except faster; these characteristics are saved at the time the variable list is created or modified and not updated automatically. If the data changes, this does *not* get updated.

~~~~
<<dd_do>>
drop if weight < 3000
summarize weight
vl list (weight), min max obs
<</dd_do>>
~~~~

To re-generate these stored statistics, we call `vl set` again, with the `update` option.

~~~~
<<dd_do>>
vl set, update
vl list (weight), min max obs
<</dd_do>>
~~~~

When the `update` option is passed, variable lists are not affected, only stored statistics are updated.

^#^^#^ Linking data sets

In addition to allowing multiple data sets to be open at a time, we can **link** frames together such that rows of data in each frames are connected
to each-other and can inter-operate. This requires a linking variable in each data set which will connect the rows. The two data sets can be at the same levels or at different levels.

For example, we might have data sets collected from multiple waves of surveys and follow-ups during which the same people (modulo some non-responses)
are contained in each data set. Then the person ID variable in the data sets would be the linking variable.

Another example might be one file at the person level, and another file at the city level. The linking variable would be city name, which would be
unique in the city file, but could potentially be repeated in the person level file.

The command to link files is `frlink` and requires specifying both the linking variable(s) and the frame to link to.

```
frlink 1:1 linkvar, frame(otherframe)
```

Let's load some data from NHANES. Each file contains a row per subject.

~~~~
<<dd_do>>
frame reset
frame rename default demographics
frame create diet
frame create bp

import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DEMO_I.XPT", clear
frame diet: import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DR1TOT_I.XPT", clear
frame bp: import sasxport5 "https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/BPX_I.XPT", clear
frame dir
<</dd_do>>
~~~~

So as you can see, the current frame is the "demographics" frame, and the other frames contains diet and blood pressure information. The variable `seqn` records person ID.

~~~~
<<dd_do>>
frlink 1:1 seqn, frame(bp)
frlink 1:1 seqn, frame(diet)
<</dd_do>>
~~~~

The `1:1` subcommand specifies that it is a 1-to-1 link - each person has no more than 1 row of data in each file. An alternative is `m:1` which allows multiple rows in the main file to be linked to a single row in the second frame. `1:m` is *not allowed* at this point in time.

These commands created two new variables `bp` and `diet` (the same new as the linked frames) which indicate which row of the linked from is connected with the given row.

~~~~
<<dd_do>>
list bp diet in 25/29
<</dd_do>>
~~~~

Here we see that row 27 in the demographics file was not found in either "bp" or "diet" and thus has no entry in the `bp` or `diet` variables.

Links are tracked by the variables, we can see the current status of a link via `frlink describe`:

~~~~
<<dd_do>>
frlink describe diet
<</dd_do>>
~~~~

We can see all links from the current frame via `frlink dir`:

~~~~
<<dd_do>>
frlink dir
<</dd_do>>
~~~~

To unlink frames, simply drop the variable.

~~~~
<<dd_do>>
drop diet
<</dd_do>>
~~~~

Finally, the names of the created variables can be modified via the `generate` option to `frlink`:

~~~~
<<dd_do>>
frlink 1:1 seqn, frame(diet) generate(linkdiet)
frlink dir
<</dd_do>>
~~~~

^#^^#^^#^ Working with linked frames

Once we have linked frames, we can use variables in the linked frame in analyses on the main frame.

The `frget` command can copy variables from the linked frame into the primary frame.

~~~~
<<dd_do>>
summarize bpxchr
frget bpxchr, from(bp)
summarize bpxchr
<</dd_do>>
~~~~

This merges appropriately, with a `1:1` or `m:1` link, to properly associate the values of the variable with the right observations.

Alternatively, when using `generate`, we can reference a variable in another frame.

~~~~
<<dd_do>>
gen nonsense = frval(linkdiet, dr1tcalc)/frval(bp, bpxpls) + dmdhrage
<</dd_do>>
~~~~

Note that this calculation used variables from all three frames. A less nonsensical example might be where we want the percent of a countries population located in a given state. Imagine we have the primary frame of county data, and then a separate frame "state" containing state level information.

```
gen percentpopulation = population/frval(state, population)
```

^#^^#^ Loops

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

The loop will create a [macro][macros] that you name (in the example above, it was named "race"), and repeatedly set it to each subsequent entry in
the list of variables. So in the code above, first "race" is set to "total", then the two `gen` commands are run. Next, "race" is set to "white", then
the two commands are run. Etc.

Within each of the `gen` commands, we use the backtick-quote notation just like with [macros][macros].

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
loop over race were

```
foreach race in total-island
```

then Stata would set "race" to "total-island" and the `gen` command would run once! By using "of varlist", you are telling Stata that before it sets
"race" to anything, expand the varlist using the [rules such as `*` and `-`][referring to variables].

There is also

```
foreach <macro name> of numlist <list of numbers>
```

The benefit of "of numlist" is that numlists support things like 1/4 representing 1, 2, 3, 4. So

```
foreach num of numlist 1 3/5
```

Loops over 1, 3, 4, 5, whereas

```
foreach num in 1 3/5
```

loops over just "1" and "3/5".

The use of "in" is for when you need to loop over strings that are neither numbers nor variables (such as "male" and "fem" from above).

^#^^#^ Suppressing output and errors

There are two useful command prefixes that can be handy while writing more elaborate Do-files.

^#^^#^^#^ Capturing an error

Imagine the following scenario. You want to write a Do-file that generates a new variable. However, you may need to re-run chunks of the Do-file
repeatedly, so that the `gen` statement is hit repeatedly. After the first `gen`, we can't call it again and [need to use `replace` instead][replacing
existing variables]. However, if we used `replace`, it wouldn't work the first time! One solution is to `drop` the variable before we gen it:


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

^#^^#^^#^^#^ Return Code

When you `capture` a command that errors, Stata saves the error code in the `_rc` macro.

~~~~
<<dd_do>>
list abc
capture list abc
display _rc
<</dd_do>>
~~~~

If the command does not error, `_rc` contains 0.

~~~~
<<dd_do>>
capture list price
display _rc
<</dd_do>>
~~~~

This can be used to offer additional code if an error occurs

```
capture <code that runs without error if something is true, but errors otherwise>
if _rc > 0 {
  ...
}
```

If the code inside the `capture` runs without error, the `if` block will run. If the code inside the `capture` errors, the `else` block will run.

Say you wanted to rename a variable if it exists, and if doesn't exist, create it. (For example, you have to process a large number of files, and in
some files, this variable may be missing for all rows and thus not reported.) You could run the following:

```
capture rename oldvar newvar
if _rc > 0 {
  gen newvar = .
}
```


^#^^#^^#^ Quieting the output

`quietly` does the same basic thing as `capture`, except it does not hide errors. It can be useful combined
with [the returns][class and return]:

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

With a command that doesn't error (listing `price`), both `quietly` and `capture` perform the same. However, with a command that does error, `quietly`
still errors, whereas `capture` just ignores it!
