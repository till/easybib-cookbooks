if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher :easybib_crontab
    ChefSpec.define_matcher :easybib_deploy
    ChefSpec.define_matcher :easybib_envconfig
    ChefSpec.define_matcher :easybib_gearmanw
    ChefSpec.define_matcher :easybib_nginx
    ChefSpec.define_matcher :easybib_sslcertificate
    ChefSpec.define_matcher :easybib_supervisor
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method :easybib_crontab
    ChefSpec::Runner.define_runner_method :easybib_deploy
    ChefSpec::Runner.define_runner_method :easybib_envconfig
    ChefSpec::Runner.define_runner_method :easybib_gearmanw
    ChefSpec::Runner.define_runner_method :easybib_nginx
    ChefSpec::Runner.define_runner_method :easybib_sslcertificate
    ChefSpec::Runner.define_runner_method :easybib_supervisor
  end

  def create_easybib_crontab(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_crontab, :create, resource_name)
  end

  def deploy_easybib_deploy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_deploy, :deploy, resource_name)
  end

  def create_easybib_envconfig(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_envconfig, :create, resource_name)
  end

  def create_easybib_gearmanw(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_gearmanw, :create, resource_name)
  end

  def setup_easybib_nginx(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_nginx, :setup, resource_name)
  end

  def remove_easybib_nginx(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_nginx, :remove, resource_name)
  end

  def create_easybib_sslcertificate(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_sslcertificate, :create, resource_name)
  end

  def create_easybib_supervisor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:easybib_supervisor, :create, resource_name)
  end
end
