# Xvfb Module

## Overview

The **Xvfb** module installs and configures Xvfb as an init script

## Configuration

The following parameters are configurable in Hiera.

* `xvfb::user` the user to run Xvfb as, defaults to 'hosting'
* `xvfb::options` the options to pass to Xvfb, defaults to ':99 -ac'

## Example

```
xvfb::user: "hosting"
xvfb::options: ":99 -ac"
```

## Dependencies

This module has no dependencies on other puppet modules.

## TODO

Add CentOS support.