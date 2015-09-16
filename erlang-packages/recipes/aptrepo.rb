include_recipe 'apt::ppa'

apt_repository 'erlang-packages' do
  uri           'http://packages.erlang-solutions.com/ubuntu'
  distribution  node['lsb']['codename']
  components    ['contrib']
  key           'erlang_solutions.asc'
end
