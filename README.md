* **Version:** 0.1
* **Author:** Tony Graham
* **Date:** 12 May 2012

# ant-mode

Major mode derived from nXML-mode for editing Ant build files.

Only useful things it does is provide a schema for Ant build files and
make a sorted menu of target names.

## Setting Up

The directory containing `ant-mode` needs to be on your `load-path`
because `ant-mode` only looks on `load-path` for the `ant-schemas.xml`
file that refers to the RELAX NG compact syntax schema for build
files, e.g.:


    (add-to-list 'load-path
	         (expand-file-name "~/site-lisp/ant-mode"))

    (autoload 'ant-mode "Ant" "Major mode for editing Ant build files." t)
