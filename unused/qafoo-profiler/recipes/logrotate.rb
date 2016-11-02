include_recipe 'qafoo-profiler::service'

cookbook_file '/etc/logrotate.d/qprofd.conf' do
  mode 0644
  source 'qafoo-logrotate'
  not_if do
    File.exist?('/etc/logrotate.d/qprofd.conf')
  end
  notifies :restart, 'service[qprofd]'
end
