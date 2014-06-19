source_list = "/etc/apt/sources.list.d/qafoo.list"

codename = "trusty" # node["lsb"]["codename"]

group "qafoo" # bugfix

apt_repository "qafoo" do
  uri node["qafoo-profiler"]["ppa"]
  distribution codename
  components ["main"]
  key node["qafoo-profiler"]["key"]
end

package "qprofd"
