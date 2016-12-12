# Contributing

You will need Ruby installed, for version see: `.ruby_version` in the root.

## Setup

You will need bundler (`gem install bundler`):

```
$ cd cookbooks-clone && make install
```

## Run tests

Run all:

```
$ make test
```

### Running individual tests
We use [Appraisal](https://github.com/thoughtbot/appraisal) to test against both Chef11.10 and Chef12.7. The Makefile-triggered commands always test against both versions.

To speed up development, below are some examples how to run only a part of the testsuite or only against one chef version:

Run only chef 12.7 specs:
```
$ bundle exec appraisal chef-12.7 rake spec
```

Run only specs for one cookbook with chef 11.10:
```
$ bundle exec appraisal chef-11.10 rake spec[cookbookname]
```

Run only one spec for a cookbook with both versions:
```
$ bundle exec appraisal rake spec[cookbookname,specname]
```

## Add tests

It's a good habit to add tests for code that is introduced.

Available are:

 * unit tests through `test/unit`
 * [ChefSpec](http://sethvargo.github.io/chefspec/)

### It's complicated

Sometimes tests are not enough and you need to setup a small VM.
We have a few [Vagrant](https://www.vagrantup.com) setups in [vagrant-test](vagrant-test).

## General CI

The following is run on Travis-CI:

```
$ make test && make cs
```

Please run these **before** pushing upstream to save resources and time.
