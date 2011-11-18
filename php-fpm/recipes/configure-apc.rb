cookbook_file "#{node["php-fpm"][:prefix]}/etc/php/apc.ini" do
  source "apc.ini"
  mode "0644"
end
