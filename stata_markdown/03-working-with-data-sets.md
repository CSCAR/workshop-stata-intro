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


^#^^#^ Opening data

As you may have guessed from the `sysuse` command above, the command to load local data is `use`:

```
use <filename>
```

As discussed in the [working directory](basics.html#working-directory) section, Stata can see only files in its working directory, so only the name of
the file needs to be passed. If the file exists in a different directory, you will need to give the full (or relative path). For example, if your
working directory is "C:\Documents\Stata" and the file you are looking for, "mydata.dta", is in the "Project" subfolder, you could open it with any of
the following:

```
use C:\Documents\Stata\Project\mydata.dta
use Project\mydata.dta
cd Documents\Stata\Project
use mydata.dta
```

Note that if the path (or file name) contains any spaces, you need to wrap the entire thing in quotes:

```
use "C:\Documents\Stata\My Project\My Data"
```

It is never wrong to use quotes (just not always required), so perhaps that's a safer option.

If the location of your file is much different than your working directory, it can be quicker just to use the menu "File -> Open" and use the file
open dialog box instead. As with all commands, the `use` command will be echoed in the Results after using the dialog box, allowing you to add it to a
Do-file.

As with `sysuse`, the `clear` option discards the existing data regardless of unsaved changes.

^#^^#^ Saving data

The `save` command can be used to save a data set. Without any further arguments, it saves the existing file with the same name.

```
save
```

However, Stata again tries to save you from yourself and does not allow you to overwrite an existing file, so you'll basically never run `save` by
itself. Instead, passing the `replace` option allows you to overwrite existing files:

```
save, replace
```

Finally, we can pass a name to the command to save a file with a different name:

```
save mynewdata.dta
```

This can also take a `replace` option.

`save` follows the same logic as `use` with regards to the working directory; it saves in the working directory unless you pass a path. Additionally,
a file name with spaces needs to be wrapped in quotes.

The File -> Save (and Save As) menu options can be used instead.

System data (loaded with [`sysuse`](#built-in-data)) can only be saved as a new file; you cannot (easily) modify the built-in data.q

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
(without an intervening `restore`), you'll need to desroy the existing preserved state by passing the option `not` to `restore`.

```
restore, not
```

^#^^#^ Exercise 1

You can access the file you'll be working with in this class here: [RDSL.subset.dta](RDSL.subset.dta).

1. Download the data and move it into your M drive.
2. Open the data with Stata (either double click on the file, or use File -> Open, or use `use`).
3. Use `pwd` to ensure that directory containing the data file is the working directory. If not, use File -> Change Working Directory or `cd` to fix
it.
