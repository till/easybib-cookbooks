directory '/etc/bashrc.d' do
  owner     'root'
  group     'root'
  mode      '0755'
  recursive true
end

cookbook_file '/etc/bash.bashrc' do
  source 'bash.bashrc'
  mode   '0644'
end

env_conf = ::EasyBib::Config.get_env('shell', 'getcourse', node)

template '/etc/bashrc.d/getcourse.sh' do
  source 'profile.erb'
  mode '0755'
  variables :env => env_conf
  not_if do
    env_conf.empty?
  end
end

include_recipe 'bash::color_prompt'
