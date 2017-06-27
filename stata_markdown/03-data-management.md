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

If you have a very large number of variables you may wish to suppress the table of variables:

~~~~
<<dd_do>>
describe, short
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

^#^^#^ Labels

^#^^#^^#^ `label data`

^#^^#^^#^ `label variable`

^#^^#^^#^ `label values`

^#^^#^ rename, order

^#^^#^ `summary`

^#^^#^ `codebook`
