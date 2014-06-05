def enable_chef_handler(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:chef_handler, :enable, resource_name)
end
