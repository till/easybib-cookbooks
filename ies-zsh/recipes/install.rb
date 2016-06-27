package 'zsh'

cookbook_file '/etc/zsh/zprofile' do
  cookbook 'ies-zsh'
  source 'zprofile'
  user 'root'
  group 'root'
  mode '0644'
end
