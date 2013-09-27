if node.attribute?("gocourse")

  env_conf = get_env_for_shell("gocourse")

  template "/etc/profile.d/gocourse.sh" do
    source "profile.erb"
    mode "0755"
    variables :env => env_conf
    not_if do
      env_conf.empty?
    end
  end

end

cookbook_file "/etc/profile.d/bib-alias.sh" do
  source "alias.sh"
  mode   "0755"
end
