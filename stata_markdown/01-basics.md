^#^ Basics

^#^^#^ The Stata Environment

[![](../images/stata_main_screen.png)](../images/stata_main_screen.png)

When a user first opens Stata, there are five main windows that will appear:

- The Results Window
    - All commands which are run are echoed out here, as well as any output they produce. Not all commands produce output though most do (e.g. obtaining
      summaries of the data or running a statistical procedure). Items that appear in the results window in <span style="color:blue">blue</span> are
      clickable.
- The Command Window
    - This window is where users can interactively type Stata commands and submit them to Stata for processing.  Everything that one can do in Stata
      is based on a set of Stata commands. Stata commands are case sensitive. All Stata commands and options are in lower case. When variables are
      used in any command, the variable names are also case sensitive.
- The Variables Window
    - This window displays all of the variables in the data set that is currently open in Stata, and users can click on variable names in this window
      to carry the variables over into Stata commands in the Command window. Note that Stata allows only one data-set to be open in a session.
- The Review Window
    - Stata will keep a running record of all Stata commands that have been submitted in the current session in this window. Users can simply click on
      previous commands in this window to recall them in the Command window.
- The Properties Window
    - This window allows variable properties and data-set properties to be managed. Variable names, labels, value labels, notes, display formats, and
      storage types can be viewed and modified here.

Each of these five windows will be nested within a larger overall window for the Stata session, which contains menus and tool bars available for
users. There are additional windows that users can access from the Window menu, which include the Graph window (which will open when graphs have been
created), the Viewer window (which is primarily used for help features and Stata news), the Data Editor window (for use when viewing data sets), and
the Do-file Editor window (for use when writing .do files).

In the lower left-hand corner of the main Stata window, there will be a directory displayed. This is known as the working directory, and is where
Stata will look to find data files and other associated Stata files unless the user specifies another directory. We will cover examples of changing
the working directory.

^#^^#^ One Data

One functionality where Stata differs than most other statistical or data analysis software is that Stata can only have a single data set open at a
time. (You can open a second instance of Stata to open a second data set, but the two instances cannot communicate.)

Any command you run knows to operate on the data set you have open. For example, there is a command `summarize` which provides summary information
about variables. The command is simply `summarize`, there is no need to direct it towards a specific data set.

If you have multiple data sets you need to work with, you can either

1. Switch between the two data sets as needed. This can be burdensome, though tools such as [`preserve`](#preserve) help greatly.

2. Merge the data sets, the better option. We'll discuss [merging](#merge) later.

^#^^#^ Give Stata a command

Let's try running a Stata command. In the command window, type (or copy) the following:

```
version
```

The following should appear in the Results window:

~~~~
<<dd_do>>
version
<</dd_do>>
~~~~

The first line proceeded by the `.` indicates the command that was written, `version`, and the rest is the output. Here, I am running Stata version
15.0 (your version may vary).

In this document, if you see a single command without a period, it indicates something that can be run. If you instead see a Results output where the
first line is the command prefaced by the `.`, that was run in Stata and only the Results are included since they include the command. The command can
still be run, *but should be run without the `.`*.

^#^^#^^#^ Saving Results

Any output that appears in the Results window (including the echoed commands and any errors) can by copied to be pasted into another location, such as
Word. In addition, if you highlight text and right-click, you also have the options:

- "Copy table": Useful for exporting to Excel. This can be tempermental; if the selected table is less "regular", this may not produce the best
  results. It is most useful for text which comes naturally as a table rather than results which are forced into a table for display purposes.
- "Copy table as HTML": You can paste this into a plaintext editor (Notepad.exe or TextEdit, *not* Word) and save it as a *.html to produce a
  webpage. If you paste this into Excel you get a slightly different table than the layout for "Copy table" which may be more useful.
- "Copy as picture": Does exactly what it says - equivalent to taking a screenshot. Very handy!

There are a few commands that can be useful for saving results which we will not cover in this workshop, if you are interested, you can look
into [the help](#stata-help) for them.

- `log`: Saves everything that goes into Results into a file.
- `putexcel`: Adds to a spreadsheet specific strings or output.
- `outreg2`: A [user-written](#installing-user-written-commands) command to output the results of a model (e.g. regression).

^#^^#^ Updating

If you have administrative access on your computer (e.g. if it is your personal machine, or your IT department has given you the ability), you can
update Stata freely. Major point upgrades such as the newly released 15.0 require re-installation, but minor upgrades (such as the 14.1 and 14.2
updates) as well as minor internal updates are free.

To check for updates, you can run

```
update query
```

If any updates are available (regardless of whether you ran a query first), you can obtain all updates with

```
update all
```

If you do not have administrative access on your computer, you'll need to reach out to your IT administrators to update.

^#^^#^ Installing user-written commands

In addition to built in commands, Stata supports user-written programs, know as "ado-files"^[As we'll see in [a bit](#do-files), you can save Stata
commands in a "do-file". While I've never seen an official definition, I tend to think of "ado" as "automatic do".]. Once installed, these
user-written programs operate identically to any built-in command, with the caveat that they may not be quite as polished or complete since they're
volunteer written.

We won't be covering any ado-files in these notes, but if you wanted to install a program named `newcommand`:

```
ssc install newcommand
```

You can remove a program with

```
ssc uninstall newcommand
```

Finally, to see a list of all user-written programs you have installed, used

```
ado
```

[Updating Stata](#updating) will not update any ado-files, instead you can run


```
adoupdate
```

to list all available updates and

```
adoupdate, update
```

to perform all updates.

^#^^#^ Do-files

We [saw](#the-stata-environment) that commands can be typed interactively, one command at a time, and the results immediately observed. From this, the
output can be copied/exported/printed, or the results can be saved. However, a better paradigm would save all the commands run separately so that the
analysis is [reproducible](https://en.wikipedia.org/wiki/Reproducibility).

For this purpose, Stata has Do-files (named because they are saved with the .do extension, such as `analysis.do`) which are scripts containing only
commands and [comments](#comments). We can then run any subset of the commands (including the entire file), re-running parts or all of the
analysis. Additionally you can easily save and/or share this command, allowing yourself or a colleague to re-run the analysis.

There are several ways to start a new Do-file.

- File -> New -> Do-file
- You can enter the command
```
doedit
```
- If you select some commands in the Review window, you can right click and choose "Send select to Do-file Editor".

For the last option there, note that performing that twice will create two separate Do-files instead of appending the commands. Instead, you can copy
and paste from the Review window to add to an existing Do-file.

Let's manually add some commands to a Do-file to see how to execute the commands. In a Do-file editor, enter the following

```
sysuse auto
summarize price
compress
```

Once the lines are in the editor, highlight the commands (you do not need to highlight the entire line, you merely need to ensure your selection
includes part of every line you want run) and press the "Execute/Do" (on Windows) or "Do" (on Mac) button. You should see the following appear in your
Results window.

~~~~
<<dd_do>>
sysuse auto
summarize price
compress
<</dd_do>>
~~~~

We will cover in later sections what each of these commands does
([`sysuse`](working-with-data-sets.html#sysuse), [`summarize`](#summarize), [`compress`](#compress)).

^#^^#^^#^ Comments

Comments are information in a Do-file which Stata will ignore. They can be used to stop a command from running without deleting it, or more usefully,
to add information about the code which may be useful for others (or yourself in the future) to understand how some code works or to justify you made
choices you did. In general, comments can also help readability. There are three different ways to enter comments (and one additional special way).

First, to comment out an entire line, precede it by `*`:

~~~~
<<dd_do>>
* This is a comment
<</dd_do>>
~~~~

Second, you can add a comment to the end of a line with `//``

~~~~
<<dd_do>>
version // Returns the Stata version number
// You can also use it to comment out an entire line.
<</dd_do>>
~~~~

Note that there must be a space before the `//` if it comes after a command:

~~~~
<<dd_do>>
version// Returns the Stata version number
<</dd_do>>
~~~~

Thirdly, you can comment out a section by wrapping it in `/\*` and `\*/`

~~~~
<<dd_do>>
/* Here's a several
line comment.
It just keeps going. */
summarize /* comment in the middle of a command! */ price
<</dd_do>>
~~~~

Note that when a command wraps to more than one line in the Results window (either due to a manual line break like this or a command that's too wide
for the Results window), the prefix changes from `.` to `>` to indicate that its all one command.

Finally, there's the special comment, `///`. Stata commands must be on a single line. However, complicated commands may get very long, such that its
hard to read them on a single line. Using `///` instead of `//` allows wrapping onto the next line.

~~~~
<<dd_do>>
summarize ///
price
<</dd_do>>
~~~~

As with `//`, there needs to be a space before the `///`.

Note, only the `*` works on interactive commands entered in the Command window. All four versions work in Do-files.

^#^^#^^#^ Version control

When writing a Do-file, you generally are creating it while using a single version of Stata. If a new version of Stata were released, its possible
that your code may operate differently with the new version. If you add

```
version 14.2
```

to the beginning of your Do-file, Stata will execute the commands as if it were still running version 14.2, even if you've updated to Stata 15. This
works all the way back to Stata 2. (Obviously, this will not work if you try to run as Stata 15 when you only have Stata 14 installed.)

Note that this `version` is the same command as the `version` we've been discussing [before](#giving-stata-a-command). It operates in this special
fashion only when included at the top of a Do-file.

Best practices is to always include a `version ##.#` line at the top of each Do-file, but if its code that will continue to see use, you should test
it with the newer releases and update the code as necessary!

^#^^#^ Basic command syntax

Most commands which operate on variables (as opposed to system commands such as `version` that we've been discussing) follow the same general
format. Recognizing this format will make it easier to understand new commands that you are introduced.

The basic syntax is

```
command <variable(s)>, <options>
```

The command can take on more than one word; e.g. to create a scatter plot, the command is `graph twoway scatter`.

Depending on the command, the list of variables can contain 0 variables, 1 variable, or many variables separated by spaces. Whether the order of
variables matters depends on the specific command.

The options are not required, but if they are given, they too are separated by spaces. There are some options that are consistent across a number of
commands, and some options are specific to commands.

There's an additional piece; if you want to run a command on a subset of the data, we add to the syntax:

```
command <variable(s)> if <condition>, <options>
```

We will cover this [in more detail](data-manipulation.html#subsetting) later, including how to specify the condition.

As an example, if we were to fit a linear regression model^[This course does not cover fitting statistical models, see the follow-up course for
further detail], the command might be

```
regress y x1 x2 x3 x4 if z > 5, vce(robust) beta
```

Without getting too into the details of how the command works, we can see examine the command.

- The command is `regress`.
- In the list of variables, the first position (the `y`) in a privileged position as the dependent variable, and all remaining variables are
  independent. (In other words, the variable is of one type, the remainder (in any order) are another type.)
- We are fitting the model on on the subset where `z > 5`.
- There are two options, `vce(robust)` which changes how the model is estimated and `beta` which changes how the output is displayed.

^#^^#^^#^ Referring to variables

In the example of the `regress` command above, 4 variables we referred to were `x1` through `x4`. If you have only a few variables to refer to, typing
each in (or double-clicking on their entry in the Variables window) is sufficient. However, if the number of variables grows, this becomes
tedious. Thankfully there are two alternatives.

First, we can use the wild card `\*`^[This is the reason why `*` as a comment does not work in the middle of a line (and we use `//` instead).] For
example, we could refer to those four `x#` variables as `x*`. However, be careful, as this would also match `x5`, `x6`, `xage`, `xcats`, etc. It can also
be used in the middle or beginning, e.g.:

- `c*t` would match `cat`, `caught` and `ct`
- `*2` would match `age2`, `gender2` and `salary2012`.

Alternatively, if the variables we want to include are next to each other in the data (e.g. in the Variables window), we can refer to a list of
them. If the variables in the window are `a` through `z`, alphabetically, then `b-e` would include `b`, `c`, `d`, and `e`. We will discuss the
`[order](#order)` command later to re-order variables.

^#^^#^ Stata Help

Stata has, hands down, the best built-in help files of any of the "Big 4" statistical software.^[I consider the "Big 4" as Stata, SAS, SPSS, and
R. Both SAS and SPSS have terrible help; R's is very hit-or-miss.] Stata's help should be your first stop for any of the following:

- Understanding the syntax of a command
- Exploring the options available for a given command
- Looking at examples of the command in use
- Understanding the theoretical statistics behind the command.

Help can be accessed by calling `help <command>`, such as

```
help summarize
```

Each help page has numerous features, I will merely point out a few here.

1. The "Title" section contains a link (in <span style="color:blue">blue</span>) to a PDF which contains the Manual, which has more detail and
   examples than the help file alone.
2. The syntax section shows the basic syntax. Any part written in square brackets (`[...]`) are optional.
3. The examples in the help are great but basic; the PDF help (see #1) usually has more detailed examples.
4. We will discuss the "Stored results" in the [Programming](programming.html) section.

`help` can also be used to search for the appropriate command. For example, if you wanted help merging some data together (which we will cover [later](#merging)), you might try running

```
help merging
```

`merging` is not a valid Stata command, so instead Stata performs a search of the help files. This search is often not great. I would recommend
searching online for the appropriate command to use (just search "Stata" and what you are trying to do), then using the built-in help for details on
using the command.

Finally, `help help` works and brings up some more information on the `help` command.

^#^^#^^#^ Short commands

You'll frequently see commands with partial underlining; for example `summarize` has the "su" underlined. Only the underlined part needs to be given
for Stata to understand the command; e.g. the following are all equivalent:

```
summarize
summ
su
```

This is often true for options as well; `detail` (to report far more summary details) has the "d" underlined. So these are equivalent:

```
summarize, detail
su, detail
summarize, d
su, d
```

The short commands are very useful for quickly writing commands, but not so great at reading them. If you came across someone else's Stata Do-file and
saw `su, d`, you might have trouble figuring that out unless you already knew that short command. Thankfully, the short commands can be used with
`help`, so `help su` will bring up the full `summarize` documentation.

^#^^#^ `set more off`

Stata has an option, `more`, which, if a command were to produce voluminous output, breaks the output into "pages" so that you can see it
page-by-page.

![](../images/s14v15.png)

Through Stata 14, the default was that this was on. Starting with Stata 15, the default is off. You can turn this on or off,

```
set more on
set more off
```

This settings will only last as long as Stata is open. To make the change persist, use the `permanently` options:

```
set more on, permanently
set more off, permanently
```

^#^^#^ Working directory

We mentioned [earlier](#the-stata-environment) the notion of a "working directory", the current one you can see in the bottom left of the Stata
window. You can think of a working directory as an open folder inside Windows Explorer (or Finder if you're on a Mac). You can easily access any file
within that folder without any additional trouble. You can access files in other folders (directories), but it requires moving to that folder.

In the same sense, when referring to files, any file in the working directory can be referred to buy its name. For example, to open a file (we'll go
into detail about doing this [later](working-with-data-sets.html#opening-data)) named "mydata.dta" which is in your current working directory, you
need only enter

```
use mydata.dta
```

If you were in a different working directory, you need to specify the full path to the file:

```
use C:\Documents\Stata\Project\mydata.dta
```

Similarly, when saving files, the working directory is the default choice.

The working directory can be changed with the `cd` command

```
cd C:\Documents\Stata\Project
```

Alternatively and perhaps more easily, you can change the working directory by the menus, choosing "Files -> Change working directory". After
selecting the appropriate directory, the full `cd` command will be printed in the Results, so you can save it in a Do-file for later use.
