#
# "users": {
#  "johndoe": { "uid": 1, "ssh": "pub-key" }
# }
#
node[:users].each do |username,prop|

  group "#{username}" do
    gid prop[:uid]
  end

  user "#{username}" do
    shell    "/bin/zsh"
    uid      prop[:uid]
    home     "/home/#{username}"
    supports :manage_home => true
  end

  user "#{username}" do
    action :modify
    gid    prop[:uid]
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
  else
    foo=`date -u`
    user "#{username}" do
      action :manage
      password `echo "default#{foo}password" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'`
    end
  end
end
