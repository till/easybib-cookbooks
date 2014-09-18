env_conf = ::EasyBib::Config.get_env('shell', 'getcourse', node)

template '/etc/profile.d/getcourse.sh' do
  source 'profile.erb'
  mode '0755'
  variables :env => env_conf
  not_if do
    env_conf.empty?
  end
end

cookbook_file '/etc/profile.d/bib-alias.sh' do
  source 'alias.sh'
  mode   '0755'
end
