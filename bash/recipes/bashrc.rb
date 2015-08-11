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

include_recipe 'bash::color_prompt'
