include_recipe "php-fpm::service"

commands = [
  "apt-get install -y newrelic-php5",
  "newrelic-install install"
]

commands.each do |cmd|
  execute "Running: #{cmd}" do
    command cmd
    environment({
      "NR_INSTALL_SILENT" => "yes",
      "NR_INSTALL_NOKSH" => "yes",
      "NR_INSTALL_KEY" => node["newrelic"]["license"]
    })
  end
end

etc_dir = "#{node["php-fpm"]["prefix"]}/etc/php"

directory etc_dir do
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
  action :create
  recursive true
end

template "#{etc_dir}/newrelic.ini" do
  source "newrelic.ini.erb"
  owner node["php-fpm"]["user"]
  group node["php-fpm"]["group"]
  mode "0644"
  variables(
    :license => node["newrelic"]["license"]
  )
  notifies :reload, "service[php-fpm]", :immediately
end
