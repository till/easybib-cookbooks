def initialize(*args)
  super(*args)
end

action :install do
  deploy_to = new_resource.name
  if ::File.exists?("#{deploy_to}/composer.phar")
    script "install dependencies with composer" do
      interpreter "bash"
      cwd         deploy_to
      user        "www-data"
      code <<-EOH
      PHP_CMD=$(which php)
      COMPOSER="${PHP_CMD} composer.phar --quiet --no-interaction install"
      $($COMPOSER)
      EOH
    end
  end
end
