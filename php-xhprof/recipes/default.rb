Chef::Log.error('This recipe is deprecated, please use `tideways::default`.')

include_recipe 'apt::easybib'

# "graphviz"

['php5-easybib-xhprof'].each do |p|
  package p
end
