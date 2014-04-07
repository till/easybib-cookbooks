if defined?(ChefSpec)
  def create_pecl_manager_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('pecl-manager_script', :create, resource_name)
  end
end
