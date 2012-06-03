def initialize(*args)
  super(*args)
end

def check_target(dir)
  if !::File.directory?(dir)
    raise "#{dir} is not a directory"
  end
end

def shell_out(cmd)

  Chef::Log.debug("Executing command #{cmd}")

  shell = Chef::ShellOut.new(cmd, :env => { 'PATH' => '/usr/bin:/usr/local/bin:/bin' }, :cwd => cwd)
  shell.run_command

  Chef::Log.debug("Executing command: #{cmd}")

  Chef::Log.debug("StdOut: #{shell.stdout}")
  Chef::Log.debug("StdErr: #{shell.stderr}")
  Chef::Log.debug("Status: #{shell.status}")
  Chef::Log.debug("CWD"    #{shell.cwd}")

  shell.error!

  return shell.stdout
end

def find_php
  ret = shell_out("which php")

  @php_bin = ret.strip
  if @php_bin.empty?
    raise "PHP was not found."
  end
end

def has_phar?
  ret = shell_out("#{@php_bin} -m|grep Phar|wc -l")

  count = ret.strip.to_i
  if count == 0
    raise "ext/phar is not installed"
  end
end

action :setup do

  deploy_to = new_resource.name
  check_target(deploy_to)
  find_php()
  has_phar?

  remote_file "#{deploy_to}/installer" do
    source "http://getcomposer.org/installer"
    mode   "0644"
    only_if do
      !::File.exist?("#{deploy_to}/composer.phar")
    end
  end

  execute "install composer" do
    command "#{@php_bin} installer"
    cwd     deploy_to
    only_if do
      ::File.exists?("#{deploy_to}/installer") && ::!File.exits?("#{deploy_to}/composer.phar")
    end
  end

end

action :install do

  deploy_to = new_resource.name
  check_target(deploy_to)
  find_php()
  has_phar?

  if !::File.exists?("#{deploy_to}/composer.phar")
    Chef::Log.info("Could not find 'composer.phar' in #{deploy_to}: silently skipping.")
  else

    composer = ::Chef::ShellOut.new(
      "#{@php_bin} ./composer.phar --no-interaction install",
      :env  => { 'PATH' => '/usr/bin:/usr/local/bin:/bin:/sbin' },
      :cwd  => deploy_to
    )

    composer.run_command

    Chef::Log.debug("StdErr: #{composer.stderr}")
    Chef::Log.debug("StdOut: #{composer.stdout}")
    Chef::Log.debug("Environment: #{composer.environment}")
    Chef::Log.debug("User: #{composer.user}")
    Chef::Log.debug("Status: #{composer.status}")
    Chef::Log.debug("CWD: #{composer.cwd}")

    composer.error!

  end
end
