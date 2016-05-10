# CitationMachine and BibMe Roles

A cookbook to assemble roles for our CMBM stack.

## Recipes
- role-vagrant      - Entry-point for vagrant box provisioning.
- role-nginxapp     - Entry-point for production instances.
- deploy-vagrant    - Deploy nginx and supervisor configuration files in vagrant box.
- deploy-puma       - Deploy `puma` a multi-threaded high-performance web-server written in Ruby.

## Priming the database
The database is primed (initially created) by manually running the following command on any instance connected to the
database.

    # bundle exec rake db:setup

Database migrations are subsequently handled by Chef's extended deployment hooks
(see: http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-extend-hooks.html)
