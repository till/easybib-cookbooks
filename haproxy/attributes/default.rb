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
    "500" => "500.http",
    "502" => "502.http",
    "503" => "503.http",
    "504" => "504.http"
}

default["haproxy"]["ctl"] = {}
default["haproxy"]["ctl"]["version"] = "1.1.0"
default["haproxy"]["ctl"]["base_path"] = "/usr/local/share"
