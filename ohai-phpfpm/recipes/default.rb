cookbook_file "php_fpm.rb" do
  path node["ohai"]["plugin_path"]
  action :create
end
