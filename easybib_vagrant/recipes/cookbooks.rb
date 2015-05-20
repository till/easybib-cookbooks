local_path = node['easybib_vagrant']['plugin_config']['bib-vagrant']['cookbook_path']

git local_path do
  repository node['easybib_vagrant']['cookbooks']
  user node['easybib_vagrant']['environment']['user']
  action :sync
end
