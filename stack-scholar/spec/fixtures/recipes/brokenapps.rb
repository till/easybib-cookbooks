easybib_deploy_manager get_cluster_name do
  apps node['stack-chefspec']['applications']
  deployments node['deploy']
end
