# IES Ruby Provider Cookbook

A collection of providers and recipes for installing Ruby via `rbenv`, allowing multiple Ruby versions to coexist on the
same AWS instance while not interfering at all with the OpsWorks requirements on Ruby.

## Multiple Ruby-Versions on same host
Installing and operating multiple separate Ruby versions on the same host turns out to be quite tricky and cumbersome,
especially since OpsWorks itself (resp. the opsworks-agent) has very specific requirements on the installed Ruby
versions in order to function properly or even install.

This cookbook wraps around `rbenv` and makes it very easy to install as many Ruby version as desired on the same
instance, while not having to care about OpsWorks requirements and still not breaking the opsworks-agent.
