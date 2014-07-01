source_list = "/etc/apt/sources.list.d/qafoo.list"

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
qprofd_flags << "--hostname \"#{get_cluster_name}.#{node["opsworks"]["instance"]["hostname"]}\""

template "/etc/init/qprofd.conf" do
  mode 0644
  source "init-qprofd.erb"
  variables(
    :flags => qprofd_flags.join(' '),
    :log_file => node["qafoo-profiler"]["log_file"]
  )
end
