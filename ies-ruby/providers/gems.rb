action :install do
  ruby_version = new_resource.ruby_version
  rbenv_user = new_resource.rbenv_user
  gems = new_resource.gems
  home = node['etc']['passwd'][rbenv_user]['dir']
  rbenv_home = "#{home}/.rbenv"
  path = %W(#{rbenv_home}/bin #{rbenv_home}/shims /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin).join(':')

  Chef::Application.fatal!('Did not specify Ruby version!') unless ruby_version
  Chef::Application.fatal!('Did not specify any gems!') unless gems

  gems.each do |gem|
    execute "installing gem '#{gem}' for application-specific Ruby version" do
      command "su #{rbenv_user} -l -c '#{home}/.rbenv/versions/#{ruby_version}/bin/gem install #{gem}'"
      environment('PATH' => path, 'HOME' => home, 'USER' => rbenv_user)
    end
  end

  new_resource.updated_by_last_action(true)
end
