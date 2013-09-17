default["syslog"]                       = {}
default["syslog"]["logfiles"]           = { "/var/log/nginx/error.log" => "error", "/var/log/php/slow.log" => "notice", "/var/log/php/fpm.log" => "error" }
default["syslog"]["host"]               = "logs.loggly.com"
default["syslog"]["haproxy"]            = {}
default["syslog"]["haproxy"]["log_dir"] = "/mnt/logs/haproxy"
default["syslog"]["poll"]               = 10

set_unless["loggly"]["domain"] = "example"
set_unless["loggly"]["input"]  = 1
set_unless["loggly"]["user"]   = "account"
set_unless["loggly"]["pass"]   = "password"
