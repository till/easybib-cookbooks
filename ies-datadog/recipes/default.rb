# Only run if a key is defined
unless node['datadog']['api_key'].nil?

  #
  # Add the datadog repo and pgp key
  apt_repository 'datadog' do
    key          'datadog-archive.key'
    uri          'http://apt.datadoghq.com/'
    distribution 'stable'
    components   ['main']
  end

  #
  # Install the datadog-agent package
  package 'datadog-agent' do
    action :install
  end

  #
  # Configure the primary template
  # should add "only if api_key"
  template '/etc/dd-agent/datadog.conf' do
    source 'datadog.conf.erb'
    owner 'dd-agent'
    group 'dd-agent'
    mode 0640
    variables(
      :datadog_api_key => node['datadog']['api_key'],
      :stack_name => node['easybib_deploy']['envtype'],
      :host_name  => "#{get_normalized_cluster_name(node)}_lb"
    )
    notifies :reload, 'service[datadog-agent]'
  end

  #
  # configure the haproxy monitor if we have the enable_stats node
  template '/etc/dd-agent/conf.d/haproxy.yaml' do
    only_if { node['haproxy']['enable_stats'] }
    source 'haproxy.yaml.erb'
    owner 'dd-agent'
    group 'dd-agent'
    mode 0644
    variables(
      :haproxy_stats_uri => node['haproxy']['stats_url'],
      :haproxy_stats_username => node['haproxy']['stats_user'],
      :haproxy_stats_password => node['haproxy']['stats_password']
    )
    notifies :reload, 'service[datadog-agent]'
  end

  #
  # Run a config test
  execute 'datadog_configtest' do
    command '/etc/init.d/datadog-agent configtest'
  end

  # enable it/start it
  service 'datadog-agent' do
    action [:enable, :start]
  end

  # check if it started
  execute "echo 'checking if dd-agent is running - if not start it'" do
    not_if 'pgrep datadog-agent'
    notifies :start, 'service[datadog-agent]'
  end
end
