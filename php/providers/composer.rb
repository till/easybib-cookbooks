def initialize(*args)
  super(*args)
end

action :install do
  deploy_to = new_resource.name
  if !::File.directory?(deploy_to)
    raise "#{deploy_to} is not a directory"
  end
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

      QUIET="--quiet"
      QUIET=""

      COMPOSER="${PHP_CMD} composer.phar $QUIET --no-interaction install"
      echo $COMPOSER

      `$COMPOSER`
      EOH
    end
  end
end
