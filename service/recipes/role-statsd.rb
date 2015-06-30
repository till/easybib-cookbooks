if !is_aws
  include_recipe 'nodejs'
else
  # override deploy-user so it's only used by this recipe
  node['deploy'].each do |app, deploy|
    next unless allow_deploy(app, deployable_apps, deploy_role)
    next if app != 'statsd'
    node.default['deploy'][app]['user'] = node['statsd']['user']
    node.default['deploy'][app]['group'] = node['statsd']['group']
    node.default['deploy'][app]['home'] = node['statsd']['deploy_dir']
  end
end

include_recipe 'statsd'
