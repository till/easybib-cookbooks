require 'chef/application'

def topic_arn
  new_resource.topic_arn
end

def access_key
  new_resource.access_key(
    new_resource.access_key.nil? ? node['chef_handler_sns']['access_key'] : new_resource.access_key
  )
end

def secret_key
  if new_resource.secret_key.nil? && !node['chef_handler_sns']['secret_key'].nil?
    Chef::Log.warn 'You should not use the node["chef_handler_sns"]["secret_key"] attribute. ' \
      'It is best to use the "chef_handler_sns" resource and pass it as argument.'
    new_resource.secret_key(node['chef_handler_sns']['secret_key'])
  else
    new_resource.secret_key
  end
end

def token
  new_resource.token(
    new_resource.token.nil? ? node['chef_handler_sns']['token'] : new_resource.token
  )
end

def region
  new_resource.region(
    new_resource.region.nil? ? node['chef_handler_sns']['region'] : new_resource.region
  )
end

def subject
  new_resource.subject(
    new_resource.subject.nil? ? node['chef_handler_sns']['subject'] : new_resource.subject
  )
end

def body_template
  new_resource.body_template(
    new_resource.body_template.nil? ? node['chef_handler_sns']['body_template'] : new_resource.body_template
  )
end

def chef_handler_supports
  new_resource.supports(
    if new_resource.supports.nil? || new_resource.supports.empty?
      node['chef_handler_sns']['supports'].to_hash
    else
      new_resource.supports
    end
  )
end

def gem_version
  new_resource.version(
    new_resource.version.nil? ? node['chef_handler_sns']['version'] : new_resource.version
  )
end

def gem_prerelease
  gem_version.kind_of?(String) && gem_version.match(/^[0-9.]+$/) != true
end

def whyrun_supported?
  true
end

action :enable do

  # Set `chef-handler-sns` gem arguments
  argument_array = {
    :topic_arn => topic_arn
  }
  argument_array[:access_key] = access_key unless access_key.nil?
  argument_array[:secret_key] = secret_key unless secret_key.nil?
  argument_array[:token] = token unless token.nil?
  argument_array[:region] = region unless region.nil?
  argument_array[:subject] = subject unless subject.nil?
  argument_array[:body_template] = body_template unless body_template.nil?

  # Install nokogiri dependency if required
  unless gem_version.kind_of?(String) && gem_version.split('.', 2)[0].to_i < 1
    @run_context.include_recipe 'xml::ruby'
  end

  # Install the `chef-handler-sns` RubyGem during the compile phase
  if defined?(OpsWorks::InternalGems)
    OpsWorks::InternalGems.internal_gem_package('chef-handler-sns')
  elsif defined?(Chef::Resource::ChefGem)
    chef_gem 'chef-handler-sns' do
      version gem_version
      options(:prerelease => true) if gem_prerelease
    end
  else
    gem_package('chef-handler-sns') do
      version gem_version
      options(:prerelease => true) if gem_prerelease
      action :nothing
    end.run_action(:install)
  end

  # Get the installed `chef-handler-sns` gem path
  sns_handler_path = nil
  if defined?(Bundler) && ENV.key?('BUNDLE_BIN_PATH') && !defined?(ChefSpec)
    # Gem::Specification#each_spec would be better, but requires >= 1.9.2
    bundle_path = ::File.join(Bundler.bundle_path.to_s, 'specifications')
    Dir[::File.join(bundle_path, '*.gemspec')].each do |path|
      spec = Gem::Specification.load(path.untaint)
      if spec.name == 'chef-handler-sns'
        sns_handler_path = spec.lib_dirs_glob
      end
    end
    if sns_handler_path.nil?
      Chef::Application.fatal!("chef-handler-sns not found inside Bundler path: #{bundle_path}")
    end
  else
    sns_handler_path = nil
    if Gem::Specification.respond_to?('find_by_name')
      sns_handler_path = Gem::Specification.find_by_name('chef-handler-sns').lib_dirs_glob
    else
      sns_handler_path = Gem.all_load_paths.grep(/chef-handler-sns/).first
    end
  end

  converge_by("Install #{new_resource}") do
    # Then activate the handler with the `chef_handler` LWRP
    chef_handler 'Chef::Handler::Sns' do
      source "#{sns_handler_path}/chef/handler/sns"
      arguments argument_array
      supports chef_handler_supports
      action :enable
    end
  end

end
