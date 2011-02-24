directory node["php-fpm"][:tmpdir] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

directory File.dirname(node["php-fpm"][:logfile]) do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

file node["php-fpm"][:logfile] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

file node["php-fpm"][:slowlog] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

file node["php-fpm"][:fpmlog] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

directory node["php-fpm"][:socketdir] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end
