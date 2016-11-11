if defined?(ChefSpec)
  def create_pecl_manager_script(resource_name)
    rspec_version = Gem::Version.new(::RSpec::Core::Version::STRING)
    if rspec_version >= Gem::Version.new('3.0.0')
      ChefSpec::Matchers::ResourceMatcher.new('pecl_manager_script', :create, resource_name)
    else
      ChefSpec::Matchers::ResourceMatcher.new('pecl-manager_script', :create, resource_name)
    end
  end
end
