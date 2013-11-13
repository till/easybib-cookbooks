php_pecl "opcache" do
  config_directives node["php-opcache"]["settings"]
  action :setup
end
