if defined?(ChefSpec)
  def install_ies_rbenv_deploy(name)
    ChefSpec::Matchers::ResourceMatcher.new(:ies_rbenv_deploy, :install, name)
  end
end
