include_recipe "php-fpm::service"

commands = [
  "apt-get install -y newrelic-php5",
  "newrelic-install install",
  "echo 'newrelic.license=\"#{node["newrelic"]["license"]}\"' > #{node["php-fpm"][:prefix]}/etc/php/newrelic.ini"
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

service "php-fpm" do
  action :reload
end
