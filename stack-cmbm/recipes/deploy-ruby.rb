include_recipe 'ark'

ruby_version = node['ruby']['version']
ruby_install_version = node['ruby_install']['version']
file_cache_path = Chef::Config['file_cache_path']

remote_file "#{file_cache_path}/ruby-install-#{ruby_install_version}.tar.gz" do
  source "https://codeload.github.com/postmodern/ruby-install/tar.gz/v#{ruby_install_version}"
end

execute 'unpack ruby-install archive' do
  command "cd #{file_cache_path}; tar zxvf ruby-install-#{ruby_install_version}.tar.gz"
end

execute 'install ruby-install' do
  command "cd #{file_cache_path}/ruby-install-#{ruby_install_version}; make install"
end

execute 'install ruby-2.2.3' do
  command "ruby-install --system ruby #{ruby_version} -- --disable-install-rdoc"
  not_if do
    File.exist?('/usr/local/bin/ruby')
  end
end

execute 'install bundler' do
  command 'gem install bundler'
end

execute 'install gems' do
  command 'cd /vagrant_cmbm && bundle install'
end

execute 'setup app' do
  command 'cd /vagrant_cmbm && bundle exec rake db:setup ads:populate'
end
