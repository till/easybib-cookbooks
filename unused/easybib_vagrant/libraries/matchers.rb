if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :easybib_vagrant_user
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :easybib_vagrant_user
  end

  def create_easybib_vagrant_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_vagrant_user, :create, resource_name)
  end

end
