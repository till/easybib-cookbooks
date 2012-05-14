def initialize(*args)
  super(*args)
end

action :install do
  deploy_to = new_resource.name
  
  if !::File.directory?(deploy_to)
    raise "#{deploy_to} is not a directory"
  end
  
  if !::File.exists?("#{deploy_to}/composer.phar")
    remote_file "#{deploy_to}/composer.phar" do
      source "http://getcomposer.org/composer.phar"
      mode "0774"
    end
  end
  
  if !::File.exists?("#{deploy_to}/composer.lock")
    execute "install dependencies with composer" do
      cwd deploy_to
      user "root"
      command "php composer.phar install"
    end
  end
end