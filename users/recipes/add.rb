#
# "users": [{
#  "johndoe": { "uid": "1", "ssh": "pub-key" }
# }]
#
node[:users].each do |username,prop|

  Chef::Log.debug("Username: #{username}")
  Chef::Log.debug(prop.inspect)
  next

  group "#{username}" do
    gid    prop[:uid]
    action :create
  end

  user "#{username}" do
    shell    "/bin/zsh"
    uid      uid
    gid      uid
    home     "/home/#{username}"
    supports :manage_home => true
  end

  directory "/home/#{username}/.ssh" do
    mode "0600"
    owner username
    group username
  end

  if prop[:ssh]
    execute "setup .ssh/authorized_keys" do
      command "echo prop[:ssh] > /home/#{username}/.ssh/authorized_keys"
      not_if do
        File.exist?("/home/#{username}/.ssh/authorized_keys")
      end
    end
  end
end
