# haproxy on opsworks

## Recipes

 * `haproxy::ctl` installs https://github.com/flores/haproxyctl
 * `haproxy::down` is a WIP

## Attributes

 * `node["haproxy"]` - mostly populated by opsworks
 * `node["haproxy"]["ctl"]` - for `haproxy::ctl`

## Dependencies

 * [newrelic](https://github.com/till/easybib-cookbooks/tree/master/newrelic)
