include_recipe "php-fpm::service"

commands = [
  "wget -O - http://download.newrelic.com/548C16BF.gpg | apt-key add -",
  "echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' > /etc/apt/sources.list.d/newrelic.list",
  "apt-get update",
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
