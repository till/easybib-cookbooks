node["subversion"]["users"].each do |user|

  case user
  when 'root'
    home_dir = "/root"
  when 'www-data'
    home_dir = "/var/www"
  else
    home_dir = "/home/#{user}"
  end

  directory "#{home_dir}/.subversion" do
    owner user
    mode "0755"
    action :create
    not_if "test -d #{home_dir}/.subversion"
    recursive true
  end

  cookbook_file "#{home_dir}/.subversion/servers" do
    source "servers"
    mode 0755
    owner user
    not_if "test -f #{home_dir}/.subversion/servers"
  end

end
