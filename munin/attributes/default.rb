set_unless[:munin]          = {}
set_unless[:munin][:libdir] = '/vol/ganglia/munin/lib'

set_unless[:sysop_email] = 'foo@example.org'
# munin's db dir and log
if attribute?(:scalarium_initial_setup)
  set[:scalarium_initial_setup][:bind_mounts][:mounts] = scalarium_initial_setup[:bind_mounts][:mounts].update({
    "/var/lib/munin" => "/vol/ganglia/munin/lib",
    "/var/log/munin" => "/mnt/var/log/munin"
  })
end
