if attribute?(:scalarium_initial_setup)
  set[:scalarium_initial_setup][:bind_mounts][:mounts] = scalarium_initial_setup[:bind_mounts][:mounts].update({
    "/var/log/haproxy" => "/mnt/var/log/haproxy"
  })
end

default[:haprox]             = {}
default[:haproxy][:errorloc] = {
    "401" => "401.html",
    "403" => "403.html",
    "408" => "408.html",
    "500" => "5xx.html",
    "502" => "5xx.html",
    "503" => "5xx.html",
    "504" => "5xx.html"
}

default[:silverline][:name] = "haproxy"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name]
else
  default[:silverline][:environment] = "production"
end
