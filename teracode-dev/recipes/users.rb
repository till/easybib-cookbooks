node[:dev][:users].each do |user|

  home_dir = "/home/#{user}"

  directory "#{home_dir}" do
    mode 0755
    recursive true
    action :create
  end

  user "#{user}" do
    comment "#{user}"
    home "#{home_dir}"
    gid "#{user}"
    shell "/bin/zsh"
  end

  group "sudo" do
    members "#{user}"
    append true
  end

  directory "#{home_dir}/.ssh" do
    mode 0700
    owner "#{user}"
    group "#{user}"
    action :create
  end

  remote_file "/home/#{user}/.ssh/authorized_keys" do
    source "#{user}-pub.key"
    mode "0600"
    owner "#{user}"
    group "#{user}"
    action :create
  end

end
