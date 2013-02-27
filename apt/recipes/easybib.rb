case node[:lsb][:codename]
when 'lucid'
  ppa="easybib/ppa"
  if get_cluster_name() == "EasyBib Playground"
    ppa="easybib/test"
  end

  Chef::Log.debug("Discover ppa: #{ppa}")

  execute "add #{ppa}" do
    command "add-apt-repository ppa:#{ppa}"
  end

  execute "update sources" do
    command "apt-get -y -f -q update"
  end
when 'precise'

  Chef::Log.debug("Discover dotdeb")

  apt_repository "php53.dotdeb.org" do
    keyserver    "keys.gnupg.net"
    key          "89DF5277"
    uri          "http://php53.dotdeb.org"
    distribution "stable"
    components   ["all"]
    action       :add
  end

else
  Chef::Log.debug("Unknown/unsupported distribution: #{node[:lsb][:codename]}")
end
