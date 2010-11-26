node[:dev][:users].each { |user|

  home_dir = "/home/#{user}"

  directory "#{home_dir}/.ssh" do
    mode "0700"
    owner "#{user}"
    group "#{user}"
    recursive true
  end

  user "#{user}" do
    comment "#{user}"
    home "#{home_dir}"
    gid "#{user}"
    shell "/bin/zsh"
  end

  remote_file "/home/#{user}/.ssh/authorized_keys" do
    source "#{user}-pub.key"
    mode "0600"
    owner "#{user}"
    group "#{user}"
    action :create
  end

}
