action :generate do
  file = "#{new_resource.prefix_dir}/etc/php/#{new_resource.name}-settings.ini"
  config = ::Php::Config.new(new_resource.name, new_resource.config)
  extension = nil

  if new_resource.load_extension
    extension = [new_resource.extension_path => new_resource.zend]
  end

  template file do
    source 'extension.ini.erb'
    mode   '0644'
    variables(
      'directives' => config.get_directives,
      'extensions' => extension
    )
    notifies :reload, 'service[php-fpm]', :delayed
  end
end
