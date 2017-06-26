^#^ Working with Data Sets

^#^^#^ Built-in data

Before we turn to using your own data, it is useful to know that Stata comes with a collection of sample data sets which you can use to try the Stata
commands. Additionally, most (if not all) of the examples in [Stata help](basics.html#stata-help) will use these data sets.

To see a list of the built-in data sets, use

~~~~
<<dd_do>>
sysuse dir
<</dd_do>>
~~~~

and use `sysuse` again to load data, for example the `auto` data which contains characteristics of various cars from a 1978 Consumer's Report magazine.

~~~~
<<dd_do>>
sysuse auto
<</dd_do>>
~~~~

If you make any modifications to your data, Stata will try and protect you by refusing to load a new data set which would dispose of your changes. If
you are willing to dispose of your changes, you can either manually do it by calling

```
clear
```

or passing it as an option to `sysuse`,

~~~~
<<dd_do>>
sysuse auto, clear
<</dd_do>>
~~~~

In addition to the data sets distributed with Stata, Stata also makes available a large collection of data sets on their website which can be accessed
with the `webuse` command. These data sets are used as examples in the Manual and can be seen listed
as [http://www.stata-press.com/data/r15/](http://www.stata-press.com/data/r15/).

~~~~
<<dd_do>>
webuse hiwaym
<</dd_do>>
~~~~

The exercises in this workshop will be using mostly built-in data sets as it makes distribution easy!

^#^^#^ Opening data

^#^^#^^#^ `use` vs open

^#^^#^ Saving data

^#^^#^ Importing data

^#^^#^ `preserve`/`restore`

Along with the [One Data](basics.html#one-data) principal, if you wished to modify a data set temporarily, say to remove some subset of your
observations, it must be done destructively. One workflow to use would be:

```
sysuse auto
<modify data set as desired>
save tmp
<subset data>
<obtain results>
use tmp, clear
<delete the tmp file manually>
```

Alternatively, the `preserve` and `restore` commands perform the same set of operations in a more automated fashion:

```
sysuse auto
<modify data set as desired>
preserve
<subset data>
<obtain results>
restore
```

The `preserve` command saves an image of the data as they are now, and the `restore` command reloads the image of the data, discarding any interim
changes. There can only be a single image of the data preserved at a time, so if you `preserve`, then make a change and want to `preserve` again
(without an intervening `restore`), you can pass the option `not` to `restore` to discard the preserved image of the data.

```
restore, not
```

Finally, to restore the image of the data but not discard the preserved image, pass the `preserve` option

```
restore, preserve
```
