cookbook_file "php_fpm.rb" do
  path "#{node['ohai']['plugin_path']}/php_fpm.rb"
  action :create
end
