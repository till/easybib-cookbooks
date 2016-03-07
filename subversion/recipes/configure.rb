node['subversion']['users'].each do |user|

  home_dir = case user
             when 'root'
               '/root'
             when 'www-data'
               '/var/www'
             else
               "/home/#{user}"
             end

  directory "#{home_dir}/.subversion" do
    owner user
    mode '0755'
    action :create
    not_if "test -d #{home_dir}/.subversion"
    recursive true
  end

  cookbook_file "#{home_dir}/.subversion/servers" do
    source 'servers'
    mode 0755
    owner user
    not_if "test -f #{home_dir}/.subversion/servers"
  end

end
