# 'stack-qa' is the cluster we run in
# 'vagrant-ci' is the layer (role) we are dealing with

default['stack-qa']['vagrant-ci']['deploy']['opsworks-layer'] = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['user']           = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['group']          = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['home']           = '/home/vagrant-ci'

default['stack-qa']['vagrant-ci']['apps'] = []
