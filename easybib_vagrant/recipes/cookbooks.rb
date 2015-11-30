local_path = generate_cookbook_path(node['easybib_vagrant']['environment']['home'])

git local_path do
  repository node['easybib_vagrant']['cookbooks']
  user node['easybib_vagrant']['environment']['user']
  action :sync
end
