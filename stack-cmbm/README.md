# CitationMachine and BibMe Roles

A cookbook to assemble roles for our CMBM stack.

## Recipes
- role-vagrant      - Entry-point for vagrant box provisioning.
- role-nginxapp     - Entry-point for production instances.
- deploy-vagrant    - Deploy nginx and supervisor configuration files in vagrant box.
- deploy-puma       - Deploy `puma` a multi-threaded high-performance web-server written in Ruby.
- deploy-ruby       - Deploy all required Ruby versions and set OpsWorks required version as global system default.

## Multiple Ruby-Versions on same host
Installing and operating multiple separate Ruby versions on the same host turns out to be quite tricky and cumbersome,
especially since OpsWorks itself (resp. the opsworks-agent) has very specific requirements on the installed Ruby
versions in order to function properly or even install.

We are currently using Chef 11.10 on AWS which requires Ruby-2.0 and does not work with Ruby-2.2.3. Our CMBM application
in turn requires Ruby-2.2.3 or higher. According to the involved developers, it is highly recommended to have a Ruby
Version Manager installed and working. However, AWS does not care much for Ruby Version Managers and just expects the 
system's global Ruby to be the required version for OpsWorks. Frankly, we must install the OpsWorks required
Ruby-Version as global system default and Ruby-2.2.3 for our CMBM app. We than have to ensure that all calls to start
our CMBM app are executed in the correct version context.

### Ruby-Version-Managers
- RVM           - Old and broken.
- Ruby-Install  - Broken.
- Chruby        - Only makes sense in combination with `ruby-install`
- rbenv         - Works like a Charm, but requires some extra efforts for Chef to execute everyting in the correct
                  environment.

It took roughly 5 days to evaluate that the only working option that actually works in our constellation is `rbenv`.

`rbenv` does have very specific requirements on the `$PATH` variable, which must be explicitly set in order for `rbenv`
to function properly (PATH=~/.rbenv/bin:~/.rbenv/shims:$PATH).
