default[:syslog]                     = {}
default[:syslog][:logfiles]          = { "/var/log/nginx/error.log" => "error", "/var/log/php/slow.log" => "notice", "/var/log/php/fpm.log" => "error" }
default[:syslog][:host]              = "logs.loggly.com"
default[:syslog][:haproxy]           = {}
default[:syslog][:haproxy][:log_dir] = "/mnt/logs/haproxy"
default[:syslog][:poll]              = 10
