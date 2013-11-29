# haproxy on opsworks

## Recipes

 * `haproxy::ctl` installs https://github.com/flores/haproxyctl
 * `haproxy::down` installs custom error message templates
 * `haproxy::logs` sets up logging haproxy to syslog

## Attributes

 * `node["haproxy"]` - mostly populated by opsworks
 * `node["haproxy"]["ctl"]` - for `haproxy::ctl`

## Additional Backends

To host more than one domain with different backends, use the following blurb for json:
```
  "haproxy": {
    "additional_layers": {
      "layername": {
        "acl-1": "hdr_dom(host) -i domain.example.com"
      }
    }
  },
```

layername has to be the name of the stack layer where the instances for the addtl backend are registered.
The recipe will fail if no such layer exists!

The inner array are the haproxy rules which determine when to use the additional backend. It is intentionally
not just a list of domains, so it can be used for all hdr\_* statements (cookie based, etc), which might be
interesting for a/b tests. The key of the inner array is not used, can be any string.


## Dependencies

 * [newrelic](https://github.com/till/easybib-cookbooks/tree/master/newrelic)
