action :install do

  extension = new_resource.name
  so_file   = "#{new_resource.ext_dir}/#{extension}.so"

  if !new_resource.version.empty?
    extension = "#{extension}-#{new_resource.version}"
  end

  execute "pecl install #{extension}" do
    not_if do
      ::File.exists?(so_file)
    end
  end

  new_resource.updated_by_last_action(true)

end

action :compile do

  if new_resource.source_dir.empty?
    raise "Missing 'source_dir'."
  end

  source_dir = new_resource.source_dir
  if !::File.exists?(source_dir)
    raise "The 'source_dir' does not exist: #{source_dir}"
  end

  extension = new_resource.name

  configure = "./configure"

  cflags = new_resource.cflags
  if !cflags.nil? && !cflags.empty?
    configure = "CFLAGS=\"#{cflags}\" #{configure}"
  end

  commands = [
    "phpize",
    configure,
    "make",
    "cp modules/#{extension}.so #{new_resource.ext_dir}",
  ]

  commands.each do |command|
    Chef::Log.debug("Running #{command} in #{source_dir}")
    cmd = ::Mixlib::ShellOut.new(command, :cwd => source_dir)
    cmd.run_command
    cmd.error!
  end

  new_resource.updated_by_last_action(true)

end

action :setup do

  package  = new_resource.name
  ini_file = "#{new_resource.prefix}/etc/php/#{new_resource.name}.ini"

  if package == "xdebug"
    ::Chef::Log.debug("Need to use zend_extension")
    return
  end

  execute "enable PHP extension #{package}" do
    command "echo 'extension=#{package}.so' >> #{ini_file}"
    not_if do
      ::File.exists?(ini_file)
    end
  end

  new_resource.updated_by_last_action(true)
end
