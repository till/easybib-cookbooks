require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :install do
  extension = new_resource.name
  version = new_resource.version

  ext_dir = get_extension_dir()
  ext_dir << ::File::SEPARATOR if ext_dir[-1].chr != ::File::SEPARATOR
  so_file   = "#{ext_dir}/#{extension}.so"

  if !version.nil?
    extension = "#{extension}-#{version}"
  end

  execute "pecl install #{extension}" do
    not_if do
      ::File.exists?(so_file)
    end
  end

  new_resource.updated_by_last_action(true)

end

action :setup do
  name = new_resource.name
  ext_prefix = get_extension_dir()
  ext_prefix << ::File::SEPARATOR if ext_prefix[-1].chr != ::File::SEPARATOR

  files = get_extension_files(name)
  if files.empty?
    Chef::Log.debug('files list returned by pecl was empty, falling back to default')
    files = [ext_prefix + name + '.so']
  end

  extensions = Hash[ files.map { |filepath|
    rel_file = filepath.clone
    rel_file.slice! ext_prefix if rel_file.start_with? ext_prefix

    zend = new_resource.zend_extensions.include?(rel_file)

    [ (zend ? filepath : rel_file) , zend ]
  }]

  template "#{node["php-fpm"]["prefix"]}/etc/php/#{name}.ini" do
    source "extension.ini.erb"
    cookbook "php"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :name => name,
      :extensions => extensions,
      :directives => new_resource.config_directives
    )
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
    "cp modules/#{extension}.so #{new_resource.source_dir}",
  ]

  commands.each do |command|
    Chef::Log.debug("Running #{command} in #{source_dir}")
    cmd = ::Mixlib::ShellOut.new(command, :cwd => source_dir)
    cmd.run_command
    cmd.error!
  end

  new_resource.updated_by_last_action(true)

end

def get_extension_dir()
  @extension_dir ||= begin
    p = shell_out("#{new_resource.prefix}/bin/php-config --extension-dir")
    p.stdout.strip
  end
end

def get_extension_files(name)
  files = []

  p = shell_out("pecl list-files #{name}")
  p.stdout.each_line.grep(/^src\s+.*\.so$/i).each do |line|
    files << line.split[1]
  end

  files
end
