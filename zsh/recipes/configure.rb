# this is for vagrant

env_conf = get_env_for_shell('getcourse')

template '/etc/zsh/zprofile' do
  source 'zprofile.erb'
  mode   '0755'
  variables :env => env_conf
  not_if do
    env_conf.empty?
  end
end
