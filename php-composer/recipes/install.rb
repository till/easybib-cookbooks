# maybe we should create a resource instead? maybe later!
if deploy[:deploy_to]

  deploy_to = "#{deploy[:deploy_to]}/current"

  Chef::Log.debug("Installing dependencies in #{deploy_to}")

  execute "install dependencies with composer" do
    command "/usr/local/php #{deploy_to}/composer.phar"
    cwd     deploy_to
    only_if do
      File.exists?("#{deploy_to}/composer.phar") && File.exists?("#{deploy_to}/package.json")
    end
  end

end
