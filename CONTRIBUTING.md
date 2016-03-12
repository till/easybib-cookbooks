# Contributing

You will need Ruby installed, for version see: `.ruby_version` in the root.

## Setup

You will need bundler (`gem install bundler`):

```
$ cd cookbooks-clone && bundle install
```

## Run tests

```
$ bundle exec rake spec[cookbook]
```

... to only tests of the cookbook `cookbook`.

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
