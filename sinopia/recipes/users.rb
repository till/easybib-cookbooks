# encoding: utf-8
#
# Cookbook Name:: sinopia
# Recipe:: users
#

user_account node['sinopia']['user'] do
  home File.join('/home/', node['sinopia']['user'])
  password nil
  manage_home true
end
