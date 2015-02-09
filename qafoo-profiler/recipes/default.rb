user 'qafoo' do
  system true
end

apt_repository 'qafoo' do
  uri node['qafoo-profiler']['ppa']
  distribution 'debian'
  components ['main']
  key node['qafoo-profiler']['key']
end

package 'qprofd' do
  action :upgrade # make sure we have the last version
end

include_recipe 'qafoo-profiler::service'

qprofd_flags = []
qprofd_flags << node['qafoo-profiler']['flags']
qprofd_flags << " --hostname='#{node['opsworks']['instance']['hostname']}.#{get_normalized_cluster_name}'"

unless node.fetch('easybib_deploy', {})['envtype'].nil?
  map = {
    'vagrant' => 'development',
    'playground' => 'staging',
    'production' => 'production'
  }
  env = map[node['easybib_deploy']['envtype']]
  qprofd_flags << " --env=#{env}"
end

template '/etc/default/qprofd' do
  mode 0644
  source 'defaults.erb'
  variables(
    :flags => qprofd_flags.join(' '),
    :logfile => node['qafoo-profiler']['log_file']
  )
  notifies :restart, 'service[qprofd]'
end
