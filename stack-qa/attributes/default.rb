# 'stack-qa' is the cluster we run in
# 'vagrant-ci' is the layer (role) we are dealing with

default['stack-qa']['vagrant-ci']['deploy']['opsworks-layer'] = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['user'] = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['group'] = 'vagrant-ci'
default['stack-qa']['vagrant-ci']['deploy']['home'] = '/home/vagrant-ci'

default['stack-qa']['vagrant-ci']['apps'] = []

default['travis-asset-browser']['config'] = {
  'theme' => 'plain',
  'page-header' => 'My Amazon S3 files',
  's3-access-key' => '',
  's3-secret-key' => '',
  'cache-time' => 600,
  'cache-dir' => '/tmp',
  'bucket-name' => '',
  'bucket-url-prefix' => 'http://bucket-name.s3.amazonaws.com'
}
