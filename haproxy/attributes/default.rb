set[:scalarium_initial_setup][:bind_mounts][:mounts] = scalarium_initial_setup[:bind_mounts][:mounts].update({
  "/var/log/haproxy" => "/mnt/var/log/haproxy"
})
