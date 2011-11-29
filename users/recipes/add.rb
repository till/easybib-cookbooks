#
# "users": {
#  "johndoe": { "uid": 1, "ssh": "pub-key" }
# }
#
# gem install shadow
#

node[:users].each do |username,prop|

  user_already_exists = `cat /etc/passwd|grep #{username}`
  Chef::Log.debug("User already exists? #{user_already_exists}")

  user "#{username}" do
    shell    "/bin/zsh"
    uid      prop[:uid]
    home     "/home/#{username}"
    supports :manage_home => true
  end

  directory "/home/#{username}/.ssh" do
    mode "0700"
    owner username
    group username
  end

  if prop[:ssh]
    execute "setup .ssh/authorized_keys" do
      command "echo #{prop[:ssh]} > /home/#{username}/.ssh/authorized_keys"
      not_if do
        File.exist?("/home/#{username}/.ssh/authorized_keys")
      end
    end

    execute "chmod 0600" do
      command "chmod 0600 /home/#{username}/.ssh/authorized_keys && chown #{username}:#{username} /home/#{username}/.ssh/authorized_keys"
    end
  end

end
