default["php-hhvm"] = {}

default["php-hhvm"]["build"] = "" # -nightly, -dbg

default["php-hhvm"]["apt"] = {}
default["php-hhvm"]["apt"]["repo"] = "http://dl.hhvm.com/ubuntu"
default["php-hhvm"]["apt"]["key"] = "http://dl.hhvm.com/conf/hhvm.gpg.key"

default["php-hhvm"]["boost"] = {}
default["php-hhvm"]["boost"]["ppa"] = "ppa:mapnik/boost"

default["php-hhvm"]["config"] = {
  "display_errors" => "On",
  "enable_dl" => "Off",
  "error_log" => "/var/log/hhvm/error.log",
  "memory_limit" => '-1'
}
