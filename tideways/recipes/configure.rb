include_recipe 'tideways::service'
include_recipe 'php-fpm::service'

if is_aws
  hostname = "#{node['opsworks']['instance']['hostname']}.#{get_normalized_cluster_name}"
  environment = if hostname.index('playground')
                  'staging'
                else
                  'production'
                end
else
  hostname = node['fqdn']
  environment = 'development'
end

template '/etc/default/tideways-daemon' do
  source 'tideways-daemon.erb'
  mode 0644
  variables(
    :environment => environment,
    :hostname => hostname
  )
  notifies :restart, 'service[tideways-daemon]'
end

execute 'phpenmod -s ALL -v ALL tideways' do
  not_if do
    node['php']['ppa']['package_prefix'] == 'php5-easybib'
  end
end

{
  '/usr/lib/php/20121212/' => 5.5,
  '/usr/lib/php/20131226/' => 5.6,
  '/usr/lib/php/20151012/' => 7.0,
  '/usr/lib/php/20160303/' => 7.1
}.each do |php_api_path, php_version|
  link "#{php_api_path}/tideways.so" do
    to "/usr/lib/tideways/tideways-php-#{php_version}.so"
    not_if do
      node['php']['ppa']['package_prefix'] == 'php5-easybib'
    end
  end

  link "#{php_api_path}/Tideways.php" do
    to '/usr/lib/tideways/Tideways.php'
    not_if do
      node['php']['ppa']['package_prefix'] == 'php5-easybib'
    end
  end
end

template "#{node['php-fpm']['prefix']}/etc/php/tideways.ini" do
  source 'tideways.ini.erb'
  mode 0644
  notifies :reload, 'service[php-fpm]', :delayed
  only_if do

  end
end
