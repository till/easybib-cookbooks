#if attribute?(:scalarium_initial_setup)
#  set[:scalarium_initial_setup][:bind_mounts][:mounts] = scalarium_initial_setup[:bind_mounts][:mounts].update({
#    "/var/log/haproxy" => "/mnt/var/log/haproxy"
#  })
#end

default["haproxy"]             = {}
default["haproxy"]["errorloc"] = {
  "400" => "400.http",
  "403" => "403.http",
  "408" => "408.http",
  "500" => "5xx.http",
  "502" => "5xx.http",
  "503" => "5xx.http",
  "504" => "5xx.http"
}

default["haproxy"]["ctl"] = {}
default["haproxy"]["ctl"]["version"] = "1.1.0"
default["haproxy"]["ctl"]["base_path"] = "/usr/local/share"
default["haproxy"]["hatop"] = {}
default["haproxy"]["hatop"]["version"] = "v0.7.7"
default["haproxy"]["hatop"]["base_path"] = "/usr/local/share"
default["haproxy"]["log_dir"] = "/mnt/var/log/haproxy"