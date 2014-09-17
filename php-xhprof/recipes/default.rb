include_recipe 'apt::easybib'

# "graphviz"

['php5-easybib-xhprof'].each do |p|
  package p
end
