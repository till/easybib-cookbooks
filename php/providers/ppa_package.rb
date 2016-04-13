action :install do
  name = new_resource.name

  package_prefix = new_resource.package_prefix
  package_prefix = node['php']['ppa']['package_prefix'] if package_prefix.nil?

  package_name = if new_resource.package_name.nil?
                   "#{package_prefix}-#{name}"
                 else
                   "#{package_prefix}-#{new_resource.package_name}"
                 end

  p = package package_name do
    action :install
    notifies :reload, 'service[php-fpm]', :delayed
  end

  new_resource.updated_by_last_action(p.updated_by_last_action?)
end
