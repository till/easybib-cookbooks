def initialize(*args)
  super(*args)
end

def check_target(dir)
  if !::File.directory?(dir)
    raise "#{dir} is not a directory"
  end
end

def shell_out(cmd)
  shell = ::Chef::ShellOut.new(cmd)
  shell.run_command
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
  haz_phar?

  remote_file "#{target}/installer" do
    source "http://getcomposer.org/installer"
    mode   "0644"
    only_if do
      !::File.exist?("#{target}/composer.phar")
    end
  end

  execute "install composer" do
    command "#{@php_bin} installer"
    cwd     target
    only_if do
      ::File.exists?("#{target}/installer")
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
    script "install dependencies with composer" do
      interpreter "bash"
      cwd         deploy_to
      user        "www-data"
      code <<-EOH
      set +x
      export PATH=$PATH:/usr/bin:/usr/local/bin
      hash -r
      PHP_CMD=$(which php)

      HAS_PHAR=$($PHP_CMD -m|grep Phar|wc -l)
      if [ $HAS_PHAR -eq 0 ]; then
        echo "No phar installed."
        exit 1        
      fi

      SVN_CMD=$(which svn)

      QUIET="--quiet"

      COMPOSER="${PHP_CMD} composer.phar $QUIET --no-interaction install"

      echo ""
      echo "DEBUG: ${PHP_CMD}, ${SVN_CMD}, ${COMPOSER}"
      echo ""

      $($COMPOSER)

      EOH
    end
  end
end
