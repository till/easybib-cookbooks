if defined?(ChefSpec)
  def create_cron_d(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('cron_d', :create, resource_name)
  end
  def delete_cron_d(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('cron_d', :delete, resource_name)
  end
end