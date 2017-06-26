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

`webuse` supports the `clear` option as well.

The exercises in this workshop will be using mostly built-in data sets as it makes distribution easy!

^#^^#^ Opening data

As you may have deduced from the `sysuse` and `webuse` commands above, the command to load local data is `use`:

```
use <filename>
```

As discussed in the [working directory](basics.html#working-directory) section, Stata can see only files in its working directory, so only the name of
the file needs to be passed. If the file exists in a different directory, you will need to give the full (or relative path). For example, if your
working directory is "C:\Documents\Stata" and the file you are looking for, "mydata", is in the "Project" subfolder, you could open it with any of the
following:

```
use C:\Documents\Stata\Project\mydata
use Project\mydata
cd Project
use mydata
```

If the location of your file is much different than your working directory, it can be quicker just to use the menu "File -> Open" and use the file
open dialog box instead. As with all commands, the `use` command will be echoed in the Results after using the dialog box, allowing you to add it to a
Do-file.

As with `sysuse` and `webuse`, the `clear` option discards the existing data regardless of unsaved changes.

^#^^#^^#^ File paths

There are some distinctions between Windows and Mac in regards to file paths, the most blatant that Windows uses forward slashs (`\\`) whereas Mac uses
back slashes (`\/`). You can see full details of this by running `help filename`.

^#^^#^^#^ Loading subsets of the data

Though I would rarely recommend its use, you can load only a subset of the data into the program at a time. Generally I would recommend loading the
full data and then [discarding](data-manipulation.html#keep-drop) the extraneous information. However, if your data is very large, it might be handy
to only load in some of it rather than the entire thing. As this is a lesser-used option we won't go into too much detail, but as an example, if I
wanted to load only the variables named "bp", "heartrate" and "date" from the data set "patientdata", restricted to male patients, I might use
something like

```
use bp heartrate date if gender == "male" using patientdata
```

Here, `using` and `if` are subcommands, which we will see used more as the day goes on. For further details, see `help use`, specifically the manual
which goes into further detail.

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
