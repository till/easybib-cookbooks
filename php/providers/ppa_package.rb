action :install do
  name = new_resource.name

  if new_resource.package_name.nil?
    package_name = "#{node['php']['ppa']['package_prefix']}-#{name}"
  else
    package_name = "#{node['php']['ppa']['package_prefix']}-#{new_resource.package_name}"
  end

  p = package package_name do
    action :install
    notifies :reload, 'service[php-fpm]', :delayed
  end
  updated = p.updated_by_last_action?

  unless new_resource.config.nil?
    c = php_config name do
      config new_resource.config
      notifies :reload, 'service[php-fpm]', :delayed
    end
    updated ||= c.updated_by_last_action?
  end

  new_resource.updated_by_last_action(updated)
end
