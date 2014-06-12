include_recipe "php-fpm::service"

ENV["NR_INSTALL_SILENT"] = "yes"
ENV["NR_INSTALL_NOKSH"] = "yes"
ENV["NR_INSTALL_KEY"] = node["newrelic"]["license"]

package "newrelic-php5" do
  action node["newrelic"]["action"]
  not_if do
    node["newrelic"]["license"].empty?
  end
end

execute "Running: newrelic-install install" do
  command "newrelic-install install"
  environment(
    "NR_INSTALL_SILENT" => "yes",
    "NR_INSTALL_NOKSH" => "yes",
    "NR_INSTALL_KEY" => node["newrelic"]["license"]
  )
  not_if do
    node["newrelic"]["license"].empty?
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
  not_if do
    node["newrelic"]["license"].empty?
  end
end
