This is just a plain wrapper to Opsworks-Definitions like `opsworks_deploy_dir`.
We are using this since opsworks resides into its own cookbook repo, and we can
by default not test any recipes/providers using one of the `opsworks_*` methods.

This could be fixed by checking the opsworks cookbooks out, adding them to the
test setup paths, etc - but they feature several problems regarding proper
testability, since we should mock a lot of ohai data, or their attribues.rb would
`raise` an error. Also, there are not matchers provided.

We therefore decided to contain those parts into this `easybib_opsworks` cookbook,
which we could run our tests against.

This is intentionally _as stupid as possible_, please do not add unneeded
functionality here. They are supposed to be a wrapper as close as possible to
the original function.