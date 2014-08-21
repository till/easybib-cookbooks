codename = "trusty" # node["lsb"]["codename"]

apt_repository "qafoo" do
  uri node["qafoo-profiler"]["ppa"]
  distribution codename
  components ["main"]
  key node["qafoo-profiler"]["key"]
end

package "qprofd"

qprofd_flags = []
qprofd_flags << node["qafoo-profiler"]["flags"]
qprofd_flags << "--hostname #{get_normalized_cluster_name}.#{node["opsworks"]["instance"]["hostname"]}"
qprofd_flags << "--logfile #{node["qafoo-profiler"]["log_file"]}"

template "/etc/default/qprofd" do
  mode 0644
  source "defaults.erb"
  variables(
    :flags => qprofd_flags.join(' ')
  )
end
