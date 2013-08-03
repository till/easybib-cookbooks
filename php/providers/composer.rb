def initialize(*args)
  super(*args)
end

def check_target(dir)
  if !::File.directory?(dir)
    raise "#{dir} is not a directory"
  end
end

def shell_out(cmd, cwd)

  Chef::Log.debug("Executing command #{cmd}")

  shell = Mixlib::ShellOut.new(cmd, :env => { 'PATH' => '/usr/bin:/usr/local/bin:/bin' }, :cwd => cwd)
  shell.run_command

  Chef::Log.debug("Executing command: #{cmd}")

  Chef::Log.debug("StdOut: #{shell.stdout}")
  Chef::Log.debug("StdErr: #{shell.stderr}")
  Chef::Log.debug("Status: #{shell.status}")
  Chef::Log.debug("CWD:    #{shell.cwd}")

  shell.error!

  return shell.stdout.strip
end

def find_php
  @php_bin = shell_out("which php", nil)
  if @php_bin.empty?
    raise "PHP was not found."
  end
end

def has_phar?
  count = shell_out("#{@php_bin} -m|grep Phar|wc -l", nil)
  count = count.to_i
  if count == 0
    raise "ext/phar is not installed"
  end
end

action :setup do

  deploy_to = new_resource.name
  check_target(deploy_to)

  find_php()
  has_phar?

  if ::File.exists?("#{deploy_to}/composer.phar")
    Chef::Log.debug("The composer.phar is already in #{deploy_to} - skipping.")
  else

    shell_out("curl http://getcomposer.org/installer --silent --output #{deploy_to}/installer", deploy_to)

    if !::File.exists?("#{deploy_to}/installer")
      raise "Does not exist?"
    end

    shell_out("#{@php_bin} installer", deploy_to)

    new_resource.updated_by_last_action(true)
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

    composer = Mixlib::ShellOut.new(
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

    new_resource.updated_by_last_action(true)

  end
end
