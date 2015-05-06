# Random notes on testing

## test-kitchen

We should figure that out.

## vagrant-cachier plugin

We should disable that during testing.

Alternative (assuming there is a `./Vagrantfile`):

```
$ rm -rf ~/.vagrant.d/cache && rm -rf .vagrant
$ vagrant up
...
```
