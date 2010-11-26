node[:dev][:users].each { |user|

  user "#{user}" do
    comment "User: #{user}"
    home "/home/#{user}"
    gid "sudo"
    shell "/bin/zsh"
  end

  directory "/home/#{user}/.ssh" do
    mode "0700"
    owner "#{user}"
    group "#{user}"
  end

  remote_file "/home/#{user}/.ssh/authorized_keys" do
    source "#{user}-pub.key"
    mode "0600"
    owner "#{user}"
    group "#{user}"
    action :create
  end

}
