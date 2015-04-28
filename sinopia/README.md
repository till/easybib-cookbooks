# sinopia cookbook
[![CK Version](http://img.shields.io/cookbook/v/sinopia.svg)](https://supermarket.getchef.com/cookbooks/sinopia) [![Build Status](https://img.shields.io/travis/redguide/nodejs.svg)](https://travis-ci.org/BarthV/sinopia-cookbook)

Sinopia project : https://github.com/rlidwka/sinopia/

Sinopia is a private/caching npm repository server.

It allows you to have a local npm registry with zero configuration. You don't have to install and replicate an entire CouchDB database. Sinopia keeps its own small database and, if a package doesn't exist there, it asks npmjs.org for it keeping only those packages you use.

# Requirements

- Chef >= 11
- Supported platforms : Ubuntu 12.04, 14.04.
- Sinopia Cookbook heavily depends on `nodejs` community cookbooks.

# Usage

Add `recipe[sinopia]` to the node runlist.

Default recipe with no other options will :

- Configure sinopia folders (in /etc, /var & /var/log)
- Install node + npm from the official repo at the latest version
- Create a passwordless sinopia user who will run the service
- Install latest version of sinopia from npmjs.org
- Configure log rotation to 30d
- Setup and start sinopia service (based on upstart for now)

## Defaults
* Sinopia will bind to `127.0.0.1:4873`, so you probably need to setup a web frontend.
* Access to the npm service is allowed to everyone.
* All desired packages are cached from https://registry.npmjs.org/
* A single npm account is provisionned to publish private packages with :
 * login : `admin`
 * passw : `admin`

# Attributes
Every single Sinopia configuration item can be managed from node attributes.
Default values are specified each time.

## System configuration

- `node['sinopia']['user']` : (sinopia) default user running sinopia
- `node['sinopia']['confdir']` : (/etc/sinopia) config.yaml file location
- `node['sinopia']['datadir']` : (/var/lib/sinopia) Sinopia cache & private stores location
- `node['sinopia']['logdir']` : (/var/log/sinopia) sinopia.log file location
- `node['sinopia']['logdays']` : (30) log retention policy, `Integer` days
- `node['sinopia']['loglevel']` : (warn) log level, trace | debug | info | http | warn | error | fatal

## Sinopia global conf

- `node['sinopia']['version']` : (nil) Sinopia npm package version, use `nil` for latest
- `node['sinopia']['admin']['pass']` : (admin) Sinopia admin account clear password
- `node['sinopia']['public_url']` : Sinopia rewrite url, url prefix for provided links
- `node['sinopia']['timeout']` : (nil) Cached repo timeout in ms, software default is 30000 ms
- `node['sinopia']['maxage']` : (nil) Sinopia metadata cache max age in sec, software defaut is 120s
- `node['sinopia']['max_body_size']` : (nil) Maximum size of uploaded json document, software default is 1mb

## Users and rights

No users are created by default.

* You can set user list with a hash under `default['sinopia']['users']`, you need to specify a password for each user
* You can give admin right to a specific user with `user['admin'] = true` hash

Example:
```ruby
node['sinopia']['users']['bob']['pass'] = 'incredible'
node['sinopia']['users']['bob']['admin'] = true

node['sinopia']['users']['andy']['pass'] = 'toys'
node['sinopia']['users']['andy']['admin'] = true

node['sinopia']['users']['woody']['pass'] = 'buzz'
```

## NPM Registry

You can store a list of available npm repositories in `node['sinopia']['repos']` following {'name' => 'url'} syntax. 

Default hash is loaded with official npmjs repo : `default['sinopia']['repos'] = {'npmjs' => 'https://registry.npmjs.org/'}`

Example :
```ruby
node['sinopia']['repos'] = {
  'npmjs' => 'https://registry.npmjs.org/', # official npmjs repo
  'myrepo' => 'https://myrepo.local/',
  'other' => 'https://third-party-repo.com'
}
```

`node['sinopia']['mainrepo']` : (npmjs) Caching repository name selected from available repos list

## Filters

- `default['sinopia']['strict_access']` : When set to `true`, this only allow admin and admin users to access sinopia repos, default is `false`
- You can define access & publish filters based on package name under `default['sinopia']['filters']`
- Filter format is an Array with one Hash for one rule  
- Wildcard is accepted in the filter name rule
- Access can be provided to :
 * Default (all)
 * Specified available users : `['user1', 'user2']`
 * admin account + all admin user : '@admins'
- publish can be provided to :
 * Default (admin account only)
 * Specified available users + admin : `['user1', 'user2']`
 * admin account + all admin user : '@admins'
- Storage value is the name of the folder where filtered packages will be set.

Example :
```ruby
node['sinopia']['filters'] = [
  {
    'name' => 'private-*',
    'storage' => 'private-repo'
  },
  {
    'name' => 'admin-*',
    'access' => ['andy', 'woody']
  },
  {
    'name' => 'test-*',
    'access' => '@admins'
  }
]
```

## Logging

This cookbook is reusing specific logging format of Sinopia :

```
type: file | stdout | stderr
level: trace | debug | info | http (default) | warn | error | fatal

{type: 'file', path: 'sinopia.log', level: 'debug'},

parameters for stdout and stderr: format: json | pretty
{type: 'stdout', format: 'pretty', level: 'debug'}
```

You can add as much logger as you want (including '{}') in `default['sinopia']['logs']` Array

Default value is :
```ruby
node['sinopia']['logs'] = [
  "{type: file, path: '/var/log/sinopia/sinopia.log', level: warn}"
]
```

## Proxy

See `attributes/default.rb` to view how to configure `node['sinopia']['use_proxy']` and `node['sinopia']['proxy']`.

## NPM

See `attributes/default.rb` to view Node & npm install options (version, source/package, ...)

# Recipes

`sinopia::default` recipe includes :
- `sinopia::users` : creates users
- `sinopia::nodejs` : install node & npm
- `sinopia::sinopia` : install sinopia, directories, conf and start service

# Testing

Sinopia cookbook is bundled with a Vagrantfile. If you have virtualbox and vagrant ready, just fire a `vagrant up` and this will setup a box running Sinopia and listening 0.0.0.0:4873. Port 4873 is forwaded to your 127.0.0.1:4873 for test purposes.

# Author

Author:: Barthelemy Vessemont (<bvessemont@gmail.com>)
