# rdracor 0.7.4

## Resubmission

This is a resubmission. In this version I have:

-   Fixed URL from ReadMe: <https://opensource.org/licenses/GPL-3.0> was moved to <https://opensource.org/license/gpl-3-0/>
-   Added option to return simple igraph object for `get_net_*_igraph()` functions
-   Added option to change 'DraCor' API URL

## R CMD check results

There were no ERRORs or WARNINGs.

There is 1 NOTE:

> -   checking HTML version of manual ... NOTE Skipping checking HTML validation: no command 'tidy' found

-   As  noted in [R-hub issue #548](https://github.com/r-hub/rhub/issues/548), this note is related to missing standalone tool 'tidy'. This note appears only in testing for Ubuntu Linux 20.04.1 LTS, R-release, GCC environment.

## Test environments

-   local OS X install, R 4.4.2
-   Windows Server 2022, R-devel, 64 bit
-   Fedora Linux, R-devel, clang, gfortran
-   Ubuntu Linux 20.04.1 LTS, R-release, GCC

# rdracor 0.7.3

## Resubmission

This is a resubmission. In this version I have:

-   Fixed reference for the package
-   Fixed an error with outdated SSL certificate on Linux
-   Added more informative error message for failing GET request

## R CMD check results

There were no ERRORs or WARNINGs.

There are two NOTEs:

> checking for detritus in the temp directory ... NOTE Found the following files/directories: 'lastMiKTeXException'

As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

> checking for future file timestamps ... NOTE unable to verify current time

As noted in [Posit Community](https://community.rstudio.com/t/r-devel-r-cmd-check-failing-because-of-time-unable-to-verify-current-time/25589), this could be the result of using external API <http://worldclockapi.com/>, that is currently not available

## Test environments

-   local OS X install, R 4.4.2
-   Windows Server 2022, R-devel, 64 bit
-   Fedora Linux, R-devel, clang, gfortran
-   Ubuntu Linux 20.04.1 LTS, R-release, GCC

# rdracor 0.7.1

## Resubmission

This is a resubmission. In this version I have:

-   Fixed DESCRIPTION file
-   Fixed spelling
-   Updated `plot.dracor_meta()` function (fixed changing `par()` options)
-   Added missing Rd-tags from documentation
-   Updated Readme
-   Updated parameters for `get_text_chr_*()` functions

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs.

# rdracor 0.7.2

## Resubmission

This is a resubmission. In this version I have:

-   Fixed DESCRIPTION file
-   Fixed spelling
-   Updated `plot.dracor_meta()` function (fixed changing `par()` options)
-   Added missing Rd-tags from documentation
-   Updated Readme
-   Updated parameters for `get_text_chr_*()` functions

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs.

## Test environments

-   local OS X install, R 4.4.2
-   Windows Server 2022, R-devel, 64 bit
-   Fedora Linux, R-devel, clang, gfortran
-   Ubuntu Linux 20.04.1 LTS, R-release, GCC

# rdracor 0.7.1

## Resubmission

This is a resubmission. In this version I have:

-   Changed hyphens to en-dash in `summary.dracor()`
-   Updated Readme
-   Fixed invalid URLs
-   Deleted extra files
-   added donttest for examples with \>5s
-   updated the package Title to title case

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs.

## Test environments

-   local OS X install, R 4.4.2
-   Windows Server 2022, R-devel, 64 bit

# rdracor 0.7.0

## R CMD check results

0 errors \| 0 warnings \| 1 note

-   This is a new release.
