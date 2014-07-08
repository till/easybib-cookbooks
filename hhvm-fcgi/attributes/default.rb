default["hhvm-fcgi"] = {}

default["hhvm-fcgi"]["prefix"] = ""

default["hhvm-fcgi"]["inifile"] = {}
default["hhvm-fcgi"]["inifile"]["cli"] = "/etc/hhvm/php.ini"
default["hhvm-fcgi"]["inifile"]["fcgi"] = "/etc/hhvm/php-fcgi.ini"

default["hhvm-fcgi"]["logfile"] = "/var/log/hhvm/error.log"
default["hhvm-fcgi"]["slowlog_timeout"] = 4
default["hhvm-fcgi"]["displayerrors"] = false
default["hhvm-fcgi"]["logerrors"] = true
default["hhvm-fcgi"]["maxexecutiontime"] = 60
default["hhvm-fcgi"]["memorylimit"] = "512M"
default["hhvm-fcgi"]["user"] = "www-data"
default["hhvm-fcgi"]["group"] = "www-data"
default["hhvm-fcgi"]["tmpdir"] = "/tmp/hhvm"

default["hhvm-fcgi"]["listen"] = "127.0.0.1:9000"
