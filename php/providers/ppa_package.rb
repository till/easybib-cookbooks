action :install do
  name = new_resource.name

  package_name = if new_resource.package_name.nil?
                   "#{node['php']['ppa']['package_prefix']}-#{name}"
                 else
                   "#{node['php']['ppa']['package_prefix']}-#{new_resource.package_name}"
                 end

  p = package package_name do
    action :install
    notifies :reload, 'service[php-fpm]', :delayed
  end

  new_resource.updated_by_last_action(p.updated_by_last_action?)
end
