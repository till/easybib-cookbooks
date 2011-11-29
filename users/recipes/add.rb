#
# "users": {
#  "johndoe": { "uid": 1, "ssh": "pub-key" }
# }
#
# gem install shadow
#

node[:users].each do |username,prop|

  home_dir = "/home/#{username}"

  user "#{username}" do
    shell    "/bin/zsh"
    uid      prop[:uid]
    home     home_dir
    supports :manage_home => true
  end

  directory "#{home_dir}/.ssh" do
    mode "0700"
    owner username
    group username
  end

  if prop[:ssh]
    execute "setup .ssh/authorized_keys" do
      command "echo #{prop[:ssh]} > #{home_dir}/.ssh/authorized_keys"
      not_if do
        File.exist?("#{home_dir}/.ssh/authorized_keys")
      end
    end

    execute "chmod 0600" do
      command "chmod 0600 #{home_dir}/.ssh/authorized_keys && chown #{username}:#{username} #{home_dir}/.ssh/authorized_keys"
    end
  end

end
