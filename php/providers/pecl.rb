include Chef::Mixin::ShellOut

action :install do
  extension = new_resource.name
  version = new_resource.version

  ext_dir = get_extension_dir(new_resource.prefix)
  ext_dir << ::File::SEPARATOR if ext_dir[-1].chr != ::File::SEPARATOR
  so_file   = "#{ext_dir}/#{extension}.so"

  unless version.nil?
    extension = "#{extension}-#{version}"
  end

  execute "pecl install #{extension}" do
    not_if do
      ::File.exist?(so_file)
    end
  end

  new_resource.updated_by_last_action(true)

end

action :compile do

  if new_resource.source_dir.empty?
    raise "Missing 'source_dir'."
  end

  source_dir = new_resource.source_dir
  unless ::File.exist?(source_dir)
    raise "The 'source_dir' does not exist: #{source_dir}"
  end

  extension = new_resource.name

  configure = './configure'

  cflags = new_resource.cflags
  if !cflags.nil? && !cflags.empty?
    configure = "CFLAGS=\"#{cflags}\" #{configure}"
  end

  commands = [
    'phpize',
    configure,
    'make',
    "cp modules/#{extension}.so #{get_extension_dir(new_resource.prefix)}"
  ]

  commands.each do |command|
    Chef::Log.debug("Running #{command} in #{source_dir}")
    cmd = ::Mixlib::ShellOut.new(command, :cwd => source_dir)
    cmd.run_command
    cmd.error!
  end

  new_resource.updated_by_last_action(true)

end

def get_extension_dir(prefix)
  config = ::Php::Config.new('', {})
  config.get_extension_dir(prefix)
end

def get_extension_files(name)
  config = ::Php::Config.new(new_resource.name, {})
  config.get_extension_files
end
