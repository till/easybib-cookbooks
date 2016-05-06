if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :ies_ruby_deploy
  elsif defined?(ChefSpec::Runner) && ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :ies_ruby_deploy
  end

  def install_ies_ruby_deploy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:ies_ruby_deploy, :install, resource_name)
  end
end
