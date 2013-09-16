default["php-fpm"] = {}

default["php-fpm"]["prefix"] = "/opt/easybib"

default["php-fpm"]["logfile"] = "/var/log/php/error.log"
default["php-fpm"]["slowlog"] = "/var/log/php/slow.log"
default["php-fpm"]["fpmlog"] = "/var/log/php/fpm.log"
default["php-fpm"]["displayerrors"] = false
default["php-fpm"]["logerrors"] = true
default["php-fpm"]["maxexecutiontime"] = 60
default["php-fpm"]["memorylimit"] = "512M"
default["php-fpm"]["user"] = "www-data"
default["php-fpm"]["group"] = "www-data"
default["php-fpm"]["tmpdir"] = "/tmp/php"
default["php-fpm"]["socketdir"] = "/var/run/php-fpm"

default["php-fpm"]["packages"] = "graphviz,php5-easybib,php5-easybib-mbstring,php5-easybib-xhprof,php5-easybib-memcache"
