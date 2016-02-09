# Vagrant Cookbook Changelog

## 0.4.2 - January 7, 2016

* Fix regression in `fetch_platform_checksums_for_version` method. Release 0.4.1
changed the checksums URL to the new Hashicorp location and introduced a regression.
The `fetch_platform_checksums_for_version` method now returns the correct URL.

Thanks to Jeff Bachtel for the PR.

## 0.4.1 - January 6, 2016

* Hashicorp has moved Vagrant package downloads from bintray.com to hashicorp.com. Download Vagrant packages from new location.

## 0.4.0 - December 21, 2015

* Bump default Vagrant version to 1.7.4
* Cookbook no longer fails during compile phase if https://dl.bintray.com is
unavailable. You can override `node['vagrant']['url']` and
`node['vagrant']['checksum']` if you need to download Vagrant from a different
location.
* Fix idempotency when installing Vagrant Windows package.
* Refactor Vagrant::Helpers and add test coverage
* `vagrant_plugin` resource correctly installs vagrant plugins as another user on Windows.
* Refactor LWRP and add unit tests.

#### Dev environment changes
* Add ChefSpec [Custom Matchers](https://github.com/sethvargo/chefspec#packaging-custom-matchers)
for `vagrant_plugin`.
* Add Rakefile for testing/style checks.
* Add Travis-CI integration for style and unit tests
* Move vagrant_sha256sum mock to spec/support/shared_context.rb
* Refactor ChefSpec tests - move platform recipe specs into their own spec files

## 0.3.1:

* #25, #31 Don't evaluate attributes on unsupported platforms

## 0.3.0:

* #11 Custom plugin sources
* #14 Implement user-specific plugin installation
* #20, #21, Fix plugin version detection
* #28 Improve cross platform support

## 0.2.2:

* Fix platform_family, redhat is not a family, rhel is. (#18)

## 0.2.0:

* Add `uninstall_gem` recipe to remove vagrant (1.0) gem.

## 0.1.1:

* Initial release of vagrant
