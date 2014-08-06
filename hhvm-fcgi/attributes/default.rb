default["hhvm-fcgi"] = {}

default["hhvm-fcgi"]["prefix"] = ""

default["hhvm-fcgi"]["conf"] = {}
default["hhvm-fcgi"]["conf"]["cli"] = "/etc/hhvm/php.ini"
default["hhvm-fcgi"]["conf"]["fcgi"] = "/etc/hhvm/php-fcgi.ini"
default["hhvm-fcgi"]["conf"]["hhvm"] = "/etc/hhvm/config.hdf"

default["hhvm-fcgi"]["user"] = "www-data"
default["hhvm-fcgi"]["group"] = "www-data"

default["hhvm-fcgi"]["listen"] = "127.0.0.1:9000"

default["hhvm-fcgi"]["displayerrors"] = false
default["hhvm-fcgi"]["memorylimit"] = "512M"

default["php-fpm"]["maxexecutiontime"] = 60
default["php-fpm"]["tmpdir"] = "/tmp/hhvm"
default["php-fpm"]["logfile"] = "/var/log/hhvm/error.log"
