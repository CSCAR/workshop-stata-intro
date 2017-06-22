Basics
============

## The Stata Environment

[![](../images/stata_main_screen.png)](../images/stata_main_screen.png)

When a user first opens Stata, there are five main windows that will appear:

- The Results Window
    - All commands which are run are echoed out here, as well as any
      ouptut they produce. Not all commands produce output though most
      do (e.g. obtaining summaries of the data or running a
      statistical procedure). Items that appear in the results window
      in <span style="color:blue">blue</span> are clickable.
- The Command Window
    - This window is where users can interactively type Stata commands
      and submit them to Stata for processing.  Everything that one
      can do in Stata is based on a set of Stata commands. Stata
      commands are case sensitive. All Stata commands and options are
      in lower case. When variables are used in any command, the
      variable names are also case sensitive.
- The Variables Window
    - This window displays all of the variables in the data set that
      is currently open in Stata, and users can click on variable
      names in this window to carry the variables over into Stata
      commands in the Command window. Note that Stata allows only one
      data-set to be open in a session.
- The Review Window
    - Stata will keep a running record of all Stata commands that have
      been submitted in the current session in this window. Users can
      simply click on previous commands in this window to recall them
      in the Command window.
- The Properties Window
    - This window allows variable properties and data-set properties
      to be managed. Variable names, labels, value labels, notes,
      display formats, and storage types can be viewed and modified
      here.

Each of these five windows will be nested within a larger overall
window for the Stata session, which contains menus and tool bars
available for users. There are additional windows that users can
access from the Window menu, which include the Graph window (which
will open when graphs have been created), the Viewer window (which is
primarily used for help features and Stata news), the Data Editor
window (for use when viewing data sets), and the Do-file Editor window
(for use when writing .do files).

In the lower left-hand corner of the main Stata window, there will be
a directory displayed. This is known as the working directory, and is
where Stata will look to find data files and other associated Stata
files unless the user specifies another directory. We will cover
examples of changing the working directory.

## One Data
## Updating
## Installing user-written commands
## Do files
### Comments
### Version control
## Basic command syntax
### referring to variables (`var1 var2 var3` vs `var1-var3` vs `var*`)
## Stata Help
### Short commands
## Working directory
