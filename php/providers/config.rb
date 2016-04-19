action :generate do

  if new_resource.load_priority.nil?
    file = format(
      '%{prefix}/%{config_dir}/%{ext_name}%{ini_suffix}.ini',
      :prefix => new_resource.prefix_dir,
      :config_dir => new_resource.config_dir,
      :ext_name => new_resource.name,
      :ini_suffix => new_resource.suffix
    )
  else
    file = format(
      '%{prefix}/%{config_dir}/%{load_priority}-%{ext_name}%{ini_suffix}.ini',
      :prefix => new_resource.prefix_dir,
      :config_dir => new_resource.config_dir,
      :load_priority => new_resource.load_priority.to_s.rjust(2, '0'),
      :ext_name => new_resource.name,
      :ini_suffix => new_resource.suffix
    )
  end

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
