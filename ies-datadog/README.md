# ies-datadog

Simplified `datadog-agent` installer for `stack-easybib:role-lb`.

## Why make this when Datadog already has a [chef cookbook](https://github.com/DataDog/chef-datadog)?

  * The chef-datadog cookbook includes *everything, including the kitchen sink*.  This means it also includes support for windows, centos, et.al.  This causes the berkshelf artifacts to have a huge list of depenencies and instead of spending time, locating/debugging these; I felt the time was better spent creating a simplified single purpose cookbook to meet our needs.
  * I wanted to simplify the `custom.json` inclusion activator and only create a template for haproxy on the opsworks specific setup.  We do our haproxy stats setup through the stack->layer->settings control panel, and duplicating that for each `custom.json` appeared tedious and unsustainable to me.

## Why isn't this in the `stack-citationapi:role-lb`?

The `citationapi` stack is currently *in progress* to be moved to **AWS ECS** without an haproxy layer.  However, it is easily added by doing the following:

  * Adding `include_recipe 'ies-datadog::default'` to `stack-citationapi/recipes/role-lb.rb`
  * Adding `depends ies-datadog` to `stack-citationapi/metadata.rb`
  * Adding `cookbook 'ies-datadog', :path => '../ies-datadog'` to `stack-citationapi/Berksfile`

## How to test

Beyond the standard `make test` and `make cs`, you can `cd vagrant-test\haproxy-ssl` and then run `vagrant up --provision`.  Before you do that, make sure that the `web-dna.json` file contains something similar to the following:

```
{
  "deploy": [],
  "haproxy" : {
	"ssl": "on",
    "type": "1.5",
    "enable_stats": "on",
    "stats_url": "/haproxy-stats",
    "stats_user": "statsuser",
    "stats_password": "statspass"
  },
  "ies-letsencrypt": {
    "domains": [
      "local.horst"
    ]
  },
  "datadog": {
    "api_key": "40404040404040404040404040404040"
  },
  "sysop_email": "ops@chegg.com"
}
```
