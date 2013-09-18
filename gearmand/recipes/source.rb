# WIP to document source install of gearmand

package "gearman-job-server" do
  action :purge
end

prefix = node['gearmand']['prefix']
version = node['gearmand']['source']['version']

directory prefix do
  mode "0755"
end

build_deps = ["libboost-all-dev", "gperf", "libcloog-ppl0", "make"]

case node["lsb"]["codename"]
when 'lucid'
  build_deps.push('libevent-dev')
when 'precise'
  build_deps.push('libevent1-dev')
else
  Chef::Log.fatal!("Unsupported platform: #{node["lsb"]["codename"]}")
end

build_deps.each do |dep|
  package dep
end

remote_file "#{Chef::Config[:file_cache_path]}/gearmand-#{version}.tar.gz" do
  source node['gearmand']['source']['link']
  checksum node['gearmand']['source']['hash']
end

execute "tar -zxvf #{Chef::Config[:file_cache_path]}/gearmand-#{version}.tar.gz" do
  cwd Chef::Config[:file_cache_path]
end


commands = [
  "./configure --prefix=#{prefix}/#{version} #{node['gearmand']['source']['flags']}",
  "make",
  "make install"
]

commands.each do |command|
  execute "Running #{command}" do
    command command
    cwd "#{Chef::Config[:file_cache_path]}/gearmand-#{version}/"
    not_if do
      File.exists?("#{prefix}/#{version}/sbin/gearmand")
    end
  end
end

include_recipe "gearmand::configure"
