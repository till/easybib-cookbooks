directory "/etc/bashrc.d" do
  owner     "root"
  group     "root"
  mode      "0755"
  recursive true
end

cookbook_file "/etc/bash.bashrc" do
  source "bash.bashrc"
  mode   "0644"
end

["getcourse"].each do |shell_env|
  env_conf = get_env_for_shell(shell_env)

  template "/etc/bashrc.d/#{shell_env}.sh" do
    source "profile.erb"
    mode "0755"
    variables :env => env_conf
    not_if do
      env_conf.empty?
    end
  end
end
