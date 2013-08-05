user node['gearmand']['user'] do
  comment "gearmand user"
  system true
  shell "/bin/false"
end
