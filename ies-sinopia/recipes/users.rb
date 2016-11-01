# encoding: utf-8

user node['sinopia']['user'] do
  shell '/bin/nologin'
  system true
  manage_home true
end
