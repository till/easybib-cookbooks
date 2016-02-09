# encoding: utf-8
#
# Cookbook Name:: sinopia
# Recipe:: users
#

user node['sinopia']['user'] do
  shell '/bin/nologin'
  system true
  manage_home true
end
