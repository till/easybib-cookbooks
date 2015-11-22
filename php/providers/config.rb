action :generate do
  file = "#{new_resource.prefix_dir}/etc/php/#{new_resource.name}-settings.ini"
  config = ::Php::Config.new(new_resource.name, new_resource.config)
  extension = nil

  if new_resource.load_extension
    extension = [new_resource.extension_path => new_resource.zend]
  end

  tm = template file do
    source 'extension.ini.erb'
    mode   '0644'
    variables(
      'directives' => config.get_directives,
      'extensions' => extension
    )
    notifies :reload, 'service[php-fpm]', :delayed
  end

  last_updated = true if tm.updated_by_last_action?
end
