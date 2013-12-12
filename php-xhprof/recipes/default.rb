include_recipe "apt::easybib"

["php5-easybib-xhprof", "graphviz"].each do |p|
  package p
end
