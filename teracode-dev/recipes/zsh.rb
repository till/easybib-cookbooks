node[:dev][:users].each do |user|

  remote_file "/home/#{user}/.zshrc" do
    source "zshrc"
    mode 0644
    owner "#{user}"
    group "#{user}"
  end

  remote_file "/home/#{user}/.zshfunctions" do
    source "zshfunctions"
    mode 0644
    owner "#{user}"
    group "#{user}"
  end

  remote_file "/home/#{user}/.zshaliases" do
    source "zshaliases"
    mode 0644
    owner "#{user}"
    group "#{user}"
  end

  directory "/home/#{user}/.zsh" do
    mode 0755
    owner "#{user}"
    group "#{user}"
    action :create
  end

end
