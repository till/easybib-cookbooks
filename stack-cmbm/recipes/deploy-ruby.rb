user = if is_aws
         'root'
       else
         'vagrant'
       end

home = if is_aws
         '/root'
       else
         "/home/#{user}"
       end

# Use `rbenv` to manage multiple Ruby version.
# https://github.com/rbenv/rbenv
git "#{home}/.rbenv" do
  repository 'https://github.com/rbenv/rbenv.git'
  revision node['ruby']['rbenv']['version']
  user user
  group user
  action :sync
end

# Ensure that the `rbenv` plugin directory exists.
directory "#{home}/.rbenv/plugins" do
  user user
  group user
  mode '0755'
  action :create
end

# Use rbenv plugin `ruby-build` to be able to install basically any Ruby version using rbenv.
# https://github.com/rbenv/ruby-build
git "#{home}/.rbenv/plugins/ruby-build" do
  repository 'https://github.com/rbenv/ruby-build.git'
  revision 'v20160426'
  action :sync
end

# Compile rbenv bash extensions for better overall performance of rbenv.
execute 'compile rbenv bash extension' do
  command "cd #{home}/.rbenv && src/configure && make -C src"
end

execute 'fix permissions' do
  command "chown -R #{user}:#{user} #{home}/.rbenv"
end

# rbenv requires specific environment variables, such as $PATH.
%w(bash zsh).each do |shell|
  cookbook_file "#{home}/.#{shell}rc" do
    source "#{shell}rc"
    user user
    group user
    mode '0600'
  end
end

# Install Ruby version required by AWS OpsWorks.
ruby_opsworks = node.fetch('ruby', {}).fetch('rubies', {}).fetch('opsworks', '')
execute 'install ruby-version for opsworks-agent' do
  command "su #{user} -l -c '#{home}/.rbenv/bin/rbenv install #{ruby_opsworks}'"
  not_if do
    Dir.exist?("#{home}/.rbenv/versions/#{ruby_opsworks}")
  end
end

# Make the OpsWorks Ruby version the global system default.
execute 'set ruby-version for OpsWorks as global default' do
  command "su #{user} -l -c '#{home}/.rbenv/bin/rbenv global #{ruby_opsworks}'"
end

# Install the Ruby version required by our CMBM app.
ruby_cmbm = node.fetch('ruby', {}).fetch('rubies', {}).fetch('cmbm', '')
execute 'install ruby-version for CMBM' do
  command "su #{user} -l -c '#{home}/.rbenv/bin/rbenv install #{ruby_cmbm}'"
  not_if do
    Dir.exist?("#{home}/.rbenv/versions/#{ruby_cmbm}")
  end
end
