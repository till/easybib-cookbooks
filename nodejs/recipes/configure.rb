directory "#{node["opsworks"]["deploy_user"]["home"]}/.npm" do
  user node["opsworks"]["deploy_user"]["user"]
  group node["opsworks"]["deploy_user"]["group"]
  mode 0755
  only_if do
    !node["opsworks"]["deploy_user"].nil?
  end
end
