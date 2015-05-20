Chef::Recipe.send(:include, EasyBibVagrant::Helpers)

local_path = generate_cookbook_path(
  Dir.home(node['easybib_vagrant']['environment']['user'])
)

git local_path do
  repository node['easybib_vagrant']['cookbooks']
  user node['easybib_vagrant']['environment']['user']
  action :sync
end
