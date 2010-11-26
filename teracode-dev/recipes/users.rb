users = [ 'till', 'teracode' ]

users.each { |user|

  user "#{user}" do
    comment "User: #{user}"
    home "/home/#{user}"
    gid "sudo"
    shell "/bin/zsh"
    password ""
  end

  directory "/home/#{user}/.ssh" do
    chmod "0700"
    owner "#{user}"
    group "#{user}"
  end

  remote_file "/home/#{user}/.ssh/authorized_keys" do
    source "#{user}-pub.key"
    chmod "0600"
    owner "#{user}"
    group "#{user}"
    action :create
  end

}
