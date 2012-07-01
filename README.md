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

    (autoload 'ant-mode "ant-mode" "Major mode for editing Ant build files." t)

## Regenerating schema for Ant build files

Run the provided `build.xml` using Ant, but be careful what you wish for...

* The `dtd` target will likely fail unless Ant can find all the jars needed by all its optional tasks, e.g., the `commons-net.jar` file needed by the `ftp` task
* The `rnc` target will likely fail because the generated DTD has two element declarations for `target` and has
syntax errors (e.g., "`( |`") in attribute declarations
* Where Ant uses two element with the same name but different sets of attributes in different contexts, the generated DTD and, hence, the generated RELAX NG schema will likely support one of the sets of attributes only
* The generated DTD will likely not allow `identitymapper`, etc., everywhere where `mapper` is allowed

## Contributors

* tarsius (Jonas Bernoulli)