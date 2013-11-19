#if attribute?(:scalarium_initial_setup)
#  set[:scalarium_initial_setup][:bind_mounts][:mounts] = scalarium_initial_setup[:bind_mounts][:mounts].update({
#    "/var/log/haproxy" => "/mnt/var/log/haproxy"
#  })
#end

default["haproxy"]             = {}
default["haproxy"]["errorloc"] = {
  "400" => "400.html",
  "401" => "401.html",
  "403" => "403.html",
  "408" => "408.html",
  "500" => "5xx.html",
  "502" => "5xx.html",
  "503" => "5xx.html",
  "504" => "5xx.html"
}

default["haproxy"]["ctl"] = {}
default["haproxy"]["ctl"]["version"] = "1.1.0"
default["haproxy"]["ctl"]["base_path"] = "/usr/local/share"
default["haproxy"]["log_dir"] = "/mnt/logs/haproxy"
