def initialize(*args)
  super(*args)

  @php_cmd = `which php`.strip
  if @php_cmd.empty?
    raise Chef::Exceptions::ShellCommandFailed, "PHP's CLI is not installed, or not in the path."
  end
end

action :install do
  deploy_to = new_resource.name
  if File.exist?("#{deploy_to}/composer.phar")
    execute "install with composer" do
      command "#{@php_cmd} #{deploy_to}/composer.phar install"
      cwd     deploy_to
    end
  end
end
