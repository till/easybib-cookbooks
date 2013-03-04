default["php-fpm"] = {}

case node[:lsb][:codename]
when 'lucid'
  default["php-fpm"][:prefix] = "/usr/local"
when 'precise'
  default["php-fpm"][:prefix] = ""
end

default["php-fpm"][:logfile] = "/var/log/php/error.log"
default["php-fpm"][:slowlog] = "/var/log/php/slow.log"
default["php-fpm"][:fpmlog] = "/var/log/php/fpm.log"
default["php-fpm"][:displayerrors] = false
default["php-fpm"][:logerrors] = true
default["php-fpm"][:maxexecutiontime] = 60
default["php-fpm"][:memorylimit] = "512M"
default["php-fpm"][:user] = "www-data"
default["php-fpm"][:group] = "www-data"
default["php-fpm"][:tmpdir] = "/tmp/php"
default["php-fpm"][:socketdir] = "/var/run/php-fpm"

case node[:lsb][:codename]
when 'lucid'
  default["php-fpm"][:packages] = "graphviz,php5-easybib,php5-easybib-xhprof,php5-easybib-memcache"
when 'precise'
  default["php-fpm"][:packages] = "graphviz,php5-fpm,php5-cli,php5-curl,php5-xhprof,php5-memcache"
end

default[:silverline][:php_fpm_name] = "php-fpm"
