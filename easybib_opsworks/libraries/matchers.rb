if defined?(ChefSpec)
  def easybib_opsworks_deploy_dir(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('easybib_opsworks_deploy_dir', :run, resource_name)
  end

  def easybib_opsworks_deploy_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('easybib_opsworks_deploy_user', :run, resource_name)
  end

  def easybib_opsworks_deploy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('easybib_opsworks_deploy', :run, resource_name)
  end
end
