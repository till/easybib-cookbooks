action :generate do
  file = "#{new_resource.prefix_dir}/etc/php/#{new_resource.name}-settings.ini"
  config = ::Php::Config.new(new_resource.name, new_resource.config)
  extension = {}

  if new_resource.load_extension
    extension = { new_resource.extension_path => new_resource.zend_extension }
  end

  tm = template file do
    cookbook 'php'
    source 'extension.ini.erb'
    mode   '0644'
    variables(
      'directives' => config.get_directives,
      'extensions' => extension
    )
  end

  new_resource.updated_by_last_action(tm.updated_by_last_action?)
end
