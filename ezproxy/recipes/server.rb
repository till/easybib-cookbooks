package "ia32-libs"

directory node[:ezproxy][:install_dir] do
  action :create
end

remote_file "#{node[:ezproxy][:install_dir]}/#{node[:ezproxy][:bin_name]}" do
  source "http://psw.oclc.org/file.aspx?filename=ezproxy/ezproxy-linux.bin"
  mode "0755"
end
