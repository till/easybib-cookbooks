# loggly

## Requirements

 * Ubuntu
 * Ruby (in `/usr/local/bin`)
 * rsyslog
 * [loggly](http://loggly.com) (syslog (TCP) input)

## Usage

Add this to your runlist: `loggly::setup`

## How does it work?

We hope it's pretty simple and straight forward:

 * we write a configuration for rsyslog to send all data to loggly
 * each instance gets a `loggly` init-script, which is customized with necessary variables: user, password, ...)
 * we install a script called `deviceid` (called from the init script)
 * init-script is ran during boot process and shutdown

## Customization (aka attribute files)

Edit the `attributes/default.rb` or read on.

If you happen to use Scalarium, edit your _cloud json_ via the cloud overview, then actions and edit cloud.

### loggly

Set the following in your `node.json`:

    {
      "loggly": {
        "domain": "example",
        "input": 1,
        "user": "account",
        "pass": "password"
      }
    }

Domain is your _subdomain_, e.g. http://example.loggly.com.

### rsyslog

So, yeah - this recipe uses the syslog (TCP) transport only.

For rsyslog's configuration, we have a few options as well:

    {
      "syslog": { 
        "logfiles": {
          "/var/log/nginx/error.log": "error",
          "/var/log/php/slow.log" => "notice"
          "/var/log/php/fpm.log" => "error"
        },
        "host": "logs.loggly.com",
        "haproxy": {
          "log_dir": "/mnt/logs/haproxy",
          "poll": 10
        }
      }
    }

`logfiles` should be interesting since this allows us to configure rsyslog to pick up logfiles as well.

The haproxy-related bits are Scalarium specific. We should probably spin this off some time (PRs welcome!).
