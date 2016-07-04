if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :cron_d
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :cron_d
  end

  def create_cron_d(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('cron_d', :create, resource_name)
  end

  def delete_cron_d(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('cron_d', :delete, resource_name)
  end
end
