gearmand_d = [
  "g++",
  "libevent-dev",
  "uuid-dev",
  "libboost-dev",
  "libboost-program-options-dev",
  "libboost-thread-dev"
]

gearmand_d.each do |p| 
  package p
end

gearmand_v = node[:gearmand][:source][:version]
gearmand_f = "gearmand-#{gearmand_v}.tar.gz"

remote_file "/tmp/gearmand-#{gearmand_v}.tar.gz" do
  source "https://launchpad.net/gearmand/trunk/#{gearmand_v}/+download/#{gearmand_f}"
  not_if do
    File.exists?("#{node[:gearmand][:prefix]}/sbin/gearmand")
  end
  action :create_if_missing
end

execute "extract" do
  command "tar -zxf #{gearmand_f}"
  cwd "/tmp"
  not_if do
    File.exists?("#{node[:gearmand][:prefix]}/sbin/gearmand")
  end
end

execute "gearmand: configure" do
  command "./configure --prefix=#{node[:gearmand][:prefix]}" #{node[:gearmand][:source][:flags]}"
  cwd "/tmp/gearmand-#{gearmand_v}"
  not_if do
    File.exists?("#{node[:gearmand][:prefix]}/sbin/gearmand")
  end
end

execute "gearmand: make install" do
  command "make install"
  cwd "/tmp/gearmand-#{gearmand_v}"
  not_if do
    File.exists?("#{node[:gearmand][:prefix]}/sbin/gearmand")
  end
end
