# this is for vagrant

env_conf = ::EasyBib::Config.get_env('shell', 'getcourse', node)

template '/etc/zsh/zprofile' do
  source 'zprofile.erb'
  mode   '0755'
  variables :env => env_conf
  not_if do
    env_conf.empty?
  end
end
