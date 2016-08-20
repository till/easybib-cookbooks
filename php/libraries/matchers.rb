if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :php_config
    ChefSpec.define_matcher :php_ppa_package
    ChefSpec.define_matcher :php_pear
    ChefSpec.define_matcher :php_pecl
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :php_config
    ChefSpec::Runner.define_runner_method :php_ppa_package
    ChefSpec::Runner.define_runner_method :php_pear
    ChefSpec::Runner.define_runner_method :php_pecl
  end

  def generate_php_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_config, :generate, resource_name)
  end

  def install_php_ppa_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_ppa_package, :install, resource_name)
  end

  def install_php_pear(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pear, :install, resource_name)
  end

  def uninstall_php_pear(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pear, :uninstall, resource_name)
  end

  def upgrade_php_pear(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pear, :upgrade, resource_name)
  end

  def install_if_missing_php_pear(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pear, :install_if_missing, resource_name)
  end

  def install_php_pecl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pecl, :install, resource_name)
  end

  def compile_php_pecl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:php_pecl, :compile, resource_name)
  end
end
