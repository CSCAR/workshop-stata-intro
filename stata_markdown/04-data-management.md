^#^ Data Management

Throughout this chapter, we'll be using the "auto" data set which is distributed with Stata. It can be loaded via

~~~~
<<dd_do>>
sysuse auto
<</dd_do>>
~~~~

You can reload it as necessary (if you modify it and want the original) by re-running this with the `clear` option. Feel free to make frequent use
of [`preserve` and `restore`](working-with-data-sets.html#preserverestore).


Whenever you first begin working with a data set, you'll want to spend some time getting familiar with it. You should be able to answer the following
questions (even if some of them are approximations):

- How many observations does your data have?
- How many variables are in your data set?
- What is the unit of analysis? (What does each row represent - a person? a couple? a classroom?)
    - Is there a variable which uniquely identifies each unit of analysis?
    - If the data is repeated measures in some form (multiple rows per person, or data is students across several classrooms), what variable(s)
      identify the levels and groups?
- Are there any variables which are strings (non-numeric) that you plan on using in some statistical analysis (and will need to be converted to numeric)?
- Which variables are continuous (can take on any value in some reasonable range, such as weight) vs which are categorical (take on a set number of
  values where each represents something).

You'll notice that there are no statistical questions here - we're not even worried about those yet! These are merely logistical.

In this chapter we'll go over various tools and commands you can use to answer these questions (and more) and overall to gain a familiarity with the
logistics of your data.

^#^^#^ `describe`

The first command you should run is `describe`.

~~~~
<<dd_do>>
describe
<</dd_do>>
~~~~

This displays a large amount of information, so let's break in down.

First, the header displays general data set information - the number of observations (`obs`, the number of rows) and variables (`vars`), as well as
the file size^[Reported in bytes. Roughly 1000 bytes = 1 kilobyte, 1000 kilobytes = 1 megabyte, 1000 megabytes = 1 gigabyte.] It also gives a short
label of the data (we discussing adding this [later](#label-data)), the date of last modification and whether there are any [notes](#data-notes).

Next, there is a table listing each variable in the data and some information about them. The "storage type" can be one of `byte`, `int`, `long`,
`float`, `double`; all of which are simply numbers. We'll touch on the differences between these when we discuss [`compress`](#compress), but for now
they all represent numeric variables. String variables are represented as `str##` where the `##` represent the number of characters that the string
can be, e.g. `str18` shows that `make` has a maximum of 18 letters. (This limit is irrelevant, again, see [`compress`](#compress) for details.)

The "display format" column contains format information about each variable which only control how the variables are displayed in data view. For the
most part you can ignore these and leave them at the default, though you may need to work with this if you have date or time information. For further
details see

```
help formats
```

"value label" and "variable label" are used to display more information when running analyses using these variables. See [the label](#labels) section
for further details.

Finally, if the data is sorted, `describe` will provide information about the sorting.

`describe` can also be used on a per variable basis:

~~~~
<<dd_do>>
describe mpg
describe rep78-turn
<</dd_do>>
~~~~

If you have a very large number of variables you may wish to suppress the table of variables entirely:

~~~~
<<dd_do>>
describe, short
<</dd_do>>
~~~~

Alternatively, the `simple` option returns only the names of the variables, in column-dominant order (meaning you read down the columns not across the
rows).

~~~~
<<dd_do>>
describe, simple
<</dd_do>>
~~~~

^#^^#^ Data Notes

You can attach notes to a data set, which will be saved along with the data and reloaded when you open it again. This can be handy to use in place of
a separate data dictionary (along with [`labels`](#labels)).

~~~~
<<dd_do>>
notes
<</dd_do>>
~~~~

We see that there is a single note attached to the auto data. New notes can be easily added either to the whole data set or to a specific variable

~~~~
<<dd_do>>
notes: Data is built-in from Stata.
notes displacement: This variable comes from survey XXX.
notes
<</dd_do>>
~~~~

There are two notes attached to the overall data (listed under `_dta`) and a single note attached to the `displacement` variable. You can list these
separately if desired.

~~~~
<<dd_do>>
notes list _dta
notes list displacement
notes list turn
<</dd_do>>
~~~~

Dropping notes can be accomplished as well. The numbering of notes is within each location (e.g. here the data (`_dta`) has notes 1 and 2, whereas
`displacement` has note 1).

~~~~
<<dd_do>>
notes drop _dta in 2
notes
notes drop displacement in 1
notes
<</dd_do>>
~~~~

^#^^#^ `compress`

As mentioned [above](#describe), there are various ways to store a number variable, such as `byte` and `long`. The various options take more space to
save - types which take less space can store only smaller numbers whereas types that take more space can store larger numbers. For example, a number
stored as a byte can only take on values between -127 and 100 and only integers (e.g. not 2.5) whereas a number stored as float can store numbers up
to \(1.7x10^38\) with up to 38 decimal places. Strings operate similarly; a string variable with 20 characters would store "abc" as 17 blank
characters followed by the "abc".

Understanding the above is not that important these days as computer power and storage has increased to the point where the majority of us will be
reaching its limits. However, Stata does offer the `compress` command which attempts to store variables in the smallest possible type. For example, if
a variable is a float takes on only values 1 through 10, it is replaced by a byte (and similarly, strings are as long as the longest value).

~~~~
<<dd_do>>
compress
describe, short
<</dd_do>>
~~~~

We see here a very modest saving (370 bytes, about 12%), but sometimes you can see much more significant gains.

Don't be afraid of artificially restricting yourself going forward; if one of your values exceeds the limitations its type supports, Stata will
automatically change types. So don't hesitate to run `compress` occasionally!

^#^^#^ Exercise 2

For exercises moving forward, we'll use the "census9" data set.

1. "census9" is accesible via `webuse`. Load it.
2. Spend a minute looking at the data. What does this data seem to represent? What variables do we have? What year is the data collected from?
   (`describe` will come in handy here!)
3. Are there any missing states?
4. What variables (if any) are numeric and what variables (if any) are strings?
5. Compress the data. How much space is saved? Why do you think this is?


^#^^#^ Labels

A raw data set is very sparse on context. In addition to the data itself, it will have at most a variable name, which in Stata cannot include spaces
and is limited to 32 characters. All other context associated with the data must either be documented in a data dictionary or exist in the
recollection of the analyst.

In an Excel file, to get around this, you might add additional content to the sheet outside of the raw data - a note here, a subtitle there,
etc. However, Stata does not allow such arbitrary storage. In contrast, Stata allows you to directly **label** parts of the data with context
information which will be displayed in the appropriate Results, to make Stata output much easier to read as well as removing the need for an external
data dictionary. All three different versions use the `label` command.

^#^^#^^#^ `label data`

^#^^#^^#^ `label variable`

Variables names, as mentioned, are limited to 32 characters and do not allow spaces (or several other special characters). This is to encourage you to
choose short, simple, and memorable variable names, since you'll likely be typing them a lot!

We can easily add more information with a variable label. If you look at the `describe` output, you'll notice that the auto data set already has
variable labels applied to it.

~~~~
<<dd_do>>
describe
<</dd_do>>
~~~~

We can see variable `rep78` (an utterly incomprehensible name at first glance, as opposed to `mpg`) has the label "Repair Record 1978". You can apply
your own variable labels (or overwrite existing by using the command:

```
label variable <variable name> "Variable label"
```

For example:

~~~~
<<dd_do>>
label variable turn "Some new label for turn"
describe turn
<</dd_do>>
~~~~

^#^^#^^#^ `label values`

It is tempting to store categorical variables as strings. If you ask, for example, for someone's state of residence, you might store the answers as
"MI", "OH", "FL", etc. However, Stata (like most statistical software) cannot handle string variables.^[In the few situations where it can, it doesn't
handle them cleanly.] A much better way to store this data would be to assign each state a numerical value, say MI = 1, OH = 2, FL = 3, etc, then keep
a data dictionary linking the values to the labels they represent.

Stata allows you to store this value labels information within the data set, such that whenever the values are output, the labels are printed
instead. Let's take a look at the `foreign` variable. This variable takes on two levels, and we can tabulate it to see how many cars are in each
category.

~~~~
<<dd_do>>
tab foreign
<</dd_do>>
~~~~

Here it appears that `foreign` is stored as two strings, but we know from `describe` that it is not:

~~~~
<<dd_do>>
describe foreign
<</dd_do>>
~~~~

Instead, let's look at that table ignoring the value labels:

~~~~
<<dd_do>>
tab foreign, nolabel
<</dd_do>>
~~~~

Now we see the values which are actually stored.

Look at the `describe` output:

~~~~
<<dd_do>>
describe foreign
<</dd_do>>
~~~~

You'll notice that in the "value label" column has `origin` attached to `foreign`. In Stata, the value labels information are *stored separately* from
the variables. They are two separate components - there is a variable and there is a value label. You connect the value label to a variable to use it.

The benefit of this separated structure is that if you have several variables which have the same coding scheme (e.g. a series of Likert scale
questions, where 1-5 represents "Strongly Disagree"-"Strongly Agree"), you can create a single value label and rapidly apply it to all variables
necessary.

Correspondingly, this process requires two commands. First we define the value labels:

```
label define <label name> <value> "<label>" <value> "<label>" .....
```

For example, if we wanted to recreate the value label associated with `foreign`:

~~~~
<<dd_do>>
label define foreign_label 0 "Domestic" 1 "Foreign"
<</dd_do>>
~~~~

Value labels exist in the data set, regardless of whether they are attached to any variables, we can see all value labels:

~~~~
<<dd_do>>
label list
<</dd_do>>
~~~~

Here we see the original `origin` as well as our new `foreign_label`. To attach it to the variable `foreign`:

~~~~
<<dd_do>>
label values foreign foreign_label
<</dd_do>>
~~~~

If we wanted to attach a single value label to multiple variables, we could simply provide a list of variables:

```
label values <var1> <var2> <var3> <label>
```


To remove the value labels from a variable, use the `label values` command with no label name following the variable name:

~~~~
<<dd_do>>
label values foreign
describe foreign
<</dd_do>>
~~~~

You can view all value labels in the data set:

~~~~
<<dd_do>>
label list
<</dd_do>>
~~~~

Note that value labels exist within a data set regardless of whether they are attached to a variable. If there is a label value that you no longer
want to keep in the data-set, you can drop it:

~~~~
<<dd_do>>
label drop foreign_label
label list
<</dd_do>>
~~~~

This will *not* remove the value labels from any variables, but they will no longer be active (i.e. if you run `describe` it will still show that the
value labels are attached, but running `tab` will not use them). So in order to completely remove a value label, you'll need to both remove it from
the variable as well as the data.

**Do not forget** that modifying value labels counts as modifying the data. Make sure you `save, replace` after making these modifications (if you
want to keep them) or they'll be lost!

^#^^#^ Managing variables

In Stata, managing the names and order of variables is important to make entering commands easier due to
the [shortcuts for referring to variables](basics.html#referring-to-variables). Recall that variables can be referred to using wildcards (e.g. `a*` to
include `age`, `address` or `a10`, or using `var1-var10` to include all variables between `var1` and `var10` as they are ordered). Of course, you may
also want to rename or re-order variables for other reasons such as making the data easier to look at.

To rename variables:

```
rename <oldname> <newname>
```

For example:

~~~~
<<dd_do>>
rename rep78 repair_record_1978
describe, simple
<</dd_do>>
~~~~

The output truncated the name because it was so long.

To rename multiple variables, you can run multiple `rename` commands, or else you can give multiple old and new names:

~~~~
<<dd_do>>
rename (mpg trunk turn) (mpg2 trunk2 turn2)
describe, simple
<</dd_do>>
~~~~

The first old variable is renamed to the first new variable, the second to the second, etc. The parentheses are required.

Variable names are unique; if you wanted to swap to variable names, you'd have to name one to a temporary name, rename the second, then rename the
first again. Alternately, you can do it simultaneously:

```
rename (var1 var2) (var2 var1)
```

You can use wildcards in the renaming too. For example, imagine you had a collection of variables from a longitudinal data set, "visit1\_age",
"visit1\_weight", "visit1\_height", etc. To simplify variable names, we'd prefer to use "age1", "weight1", etc.

```
rename visit1_* *1
```

Finally, you can change a variable name to upper/lower/proper case easily by passing `upper`/`lower`/`proper` as an argument and giving no new
variable name.

~~~~
<<dd_do>>
rename length, upper
describe, simple
<</dd_do>>
~~~~

Turning to variable ordering, the `order` command takes a list of variables and moves them to the front/end/before a certain variable/after a certain
variable. The options `first`, `last`, `before(<variable>)` and `after(<variable>)` control this.

~~~~
<<dd_do>>
order foreign // The default is `first`
describe, simple
order weight, last
describe, simple
order mpg2 trunk2, before(displacement)
describe, simple
<</dd_do>>
~~~~

^#^^#^ Exercise 3

If you've changed to a different data set, load "census9" back up with `webuse`.

1. Going forward, we'll be using a version of "census9" with changes we're making. [Save](working-with-data-sets.html#saving-data) a copy of the data
   to somewhere convenient (such as your Desktop).
2. The `drate` variable is a bit vague - the name of the variable provides no clue that "d" = "death", and the values (e.g. 75) are ambiguous.
    1. [Rename](#managing-variables) `drate` to `deathrate`.
    2. The rate is actually per 10,000 individuals. [Label](#label-variable) `drate` to include this information.
3. The variable `region` has a value label associated with it ("cenreg"). It has some odd choices, namely "NE" and "N Cntrl". Fix this.
    1. [Create a new value label](#label-values) which replaces "NE" and "N Cntrl" with "Northeast" and "North Central" respectively.
    2. Attach this new value label to `region`.
    3. Remove the existing value label "cenreg".
    4. Use `label list` and `tab` to confirm it worked.
4. Save the data, replacing the version you created in step 1.

^#^^#^ Summarizing the data

While these notes will not cover anything statistical, it can be handy from a data management perspective to look at some summary statistics, mostly
to identify problematic variables. Among other things, we can try and detect

- Unexpectedly missing data
- Incorrectly coded data
- Errors/typos in input data
- Incorrect assumptions about variable values

There are numerous ways to look at summary statistics, from obtaining one-number summaries to visualizations, but we will focus on two Stata commands,
`summarize` and `codebook`.

`summarize` produces basic summary statistics *for numeric variables

~~~~
<<dd_do>>
summarize
<</dd_do>>
~~~~

The table reports the total number of non-missing values (`make` appears to be entirely missing because it is non-numeric), the mean (the average
value), the standard deviation (a measure of how spread out the data is) and the minimum and maximum non-missing^[As we
discuss [later](data-manipulation.html#conditional-variable-generation), in Stata, missing values (represented by `.` in the data) are considered to
be higher than any other number (so 99999 < .).] values observed.

Here's some suggestions of how to look at these values.

- Make sure the amount of missing data is expected. If the number of observations is lower than anticipated, is it an issue with the data collection?
  Or did the import into Stata cause issues? 5 cars have no `repair_record_1978`.
- The mean should be a reasonable number, somewhere in the rough middle of the range of possible values for the variable. If you have age recorded for
  a random selection of adults and the mean age is 18, something has gone wrong. If the mean age is -18, something has gone tragically wrong!
- The standard deviation is hard to interpret precisely, but in a very rough sense, 2/3rds of the values should lie within 1 standard deviation of the
  mean. For example, consider `mpg2`. The mean is ~21 and the standard deviation is ~6, so roughly 2/3rds of the cars have `mpg2` between 15
  and 27. Does this seems reasonable? If the standard deviation is very high compared to the mean (e.g. if `mpg2`'s standard deviation was 50) or
  close to 0, that could indicate an issue.
- Are the max and min reasonable? If the minimum `LENGTH` was -9, that's problematic. Maybe -9 is the code for missing values? If the range of
  `LENGTH` is 14 to 2500, maybe the units differ? They measured in feet for some cars and inches for others?

`summarize` can also take a list of variables, e.g.

~~~~
<<dd_do>>
summarize t*
<</dd_do>>
~~~~

For more detailed information, we can look at the codebook. `codebook` works similarly to `describe` and `summarize` in the sense that without any
additional arguments, it displays information on every variable; you can pass it a list of variables to only operate on those. Because `codebook`'s
output is quite long, we only demonstrate the restricted version. Before we do that, we reload the "auto" data because we messed with it quite a bit
earlier!

First, categorical data:

~~~~
<<dd_do>>
sysuse auto, clear
codebook rep78
<</dd_do>>
~~~~

We see that `rep78` takes on six unique values (Up to 5 repairs, plus the missing data represented by `.`). If the unique values is more than
expected, it's something to investigate.

Next, continuous variables:

~~~~
<<dd_do>>
codebook price
<</dd_do>>
~~~~

We still see the number of unique values reported, but here every observation has a unique value (74 unique values, 74 rows in the data). There is no
missing data. The percentiles should be checked to see if they're reasonable, if 90% of the cars had a price under $100, something's not right.

Finally, string variables:

~~~~
<<dd_do>>
codebook make
<</dd_do>>
~~~~

We get less information here, but still useful to check that the data is as expected. There are no empty strings nor any repeated strings. The warning
about "embedded blanks" is spaces; it's telling us that there are spaces in some of the cars (e.g. "Dodge Magnum"). The reason it is a warning is that
"Dodge_Magnum" and "Dodge__Magnum" read the same to us, but that extra space means Stata recognizes these as two different variables.

Two options for `codebook` which come in handy:

~~~~
<<dd_do>>
codebook, compact
<</dd_do>>
~~~~

`compact` shows a reduced size version, most useful for the "Unique" column. (Useful if that's the only thing you're running the codebook for.)

~~~~
<<dd_do>>
codebook, problems
<</dd_do>>
~~~~

This reports potential issues Stata has discovered in the data. In this data, neither are really concerns (We can run `compress`, but this isn't a
"problem" so much as a suggestion. We already saw above the concern about "embedded blanks.") More serious problems that it can detect include:

- Constant columns (all entries being the same value, including all missing).
- Issues with value labels (if you've attached a value label to a variable and subsequently deleted the value label without detaching it; or if your
  variable takes on values unaccounted for in the value label).
- Issues with date variables.
