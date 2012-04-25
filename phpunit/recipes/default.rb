# this cookbook sets up PHPUnit 3.4.15 (or whatever is in attributes/default.rb)

version = node[:phpunit][:version].split('.')
major   = "#{version[0]}#{version[1]}"

ohai "reload_php_easybib" do
  action :reload
  plugin "php_easybib"
end

phpunit_location = "/usr/local/phpunit#{major}"

Chef::Log.debug("HELLO: #{node[:php_easybib][:php_bin]}")

pear     = node[:php_easybib][:pear_bin]
pear_bin = node[:php_easybib][:pear][:bin_dir]
php_dir  = node[:php_easybib][:pear][:php_dir]

execute "enable auto_discover" do
  command "#{pear} config-set auto_discover 1"
end

execute "install PHPUnit #{node[:phpunit][:version]}" do
  command "#{pear} install -o --installroot #{phpunit_location} pear.phpunit.de/PHPUnit-#{node[:phpunit][:version]}"
  not_if  do
    File.exist?("#{phpunit_location}#{pear_bin}/phpunit")
  end
end

template "#{phpunit_location}#{pear_bin}/phpunit" do
  mode   "0755"
  source "phpunit.erb"
  variables({
    :complete_path => "#{phpunit_location}#{php_dir}"
  })
end

link "#{pear_bin}/phpunit#{major}" do
  to "#{phpunit_location}#{pear_bin}/phpunit"
end
