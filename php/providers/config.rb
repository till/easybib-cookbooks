action :generate do

  prefix_dir = new_resource.prefix_dir
  config_dir = new_resource.config_dir

  if new_resource.load_priority.nil?
    ini_file = format(
      '%{prefix}/%{config_dir}/%{ext_name}%{ini_suffix}.ini',
      :prefix => prefix_dir,
      :config_dir => config_dir,
      :ext_name => new_resource.name,
      :ini_suffix => new_resource.suffix
    )
  else
    raise 'load_priority must be >= 0 && <=99' if new_resource.load_priority > 99
    ini_file = format(
      '%{prefix}/%{config_dir}/%{load_priority}-%{ext_name}%{ini_suffix}.ini',
      :prefix => prefix_dir,
      :config_dir => config_dir,
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

  tm = template ini_file do
    cookbook 'php'
    source 'extension.ini.erb'
    mode   '0644'
    variables(
      'directives' => config.get_directives,
      'extensions' => extension
    )
  end

  if config_dir.include?('mods-available')
    ini = ::File.basename(ini_file)
    enabled_module = '%{prefix}/%{config_dir}/%{sapi}/conf.d/%{file}'

    root_dir = ::File.dirname(config_dir)

    cli_ini = format(
      enabled_module,
      :prefix => prefix_dir,
      :config_dir => root_dir,
      :sapi => 'cli',
      :file => ini
    )

    fpm_ini = format(
      enabled_module,
      :prefix => prefix_dir,
      :config_dir => root_dir,
      :sapi => 'fpm',
      :file => ini
    )

    link "enable_module_cli_#{new_resource.name}" do
      target_file cli_ini
      to ini_file
    end

    link "enable_module_fpm_#{new_resource.name}" do
      target_file fpm_ini
      to ini_file
    end
  end

  new_resource.updated_by_last_action(tm.updated_by_last_action?)
end
