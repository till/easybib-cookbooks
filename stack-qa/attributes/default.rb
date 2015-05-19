default['stack-qa']['vagrant-ci']['apps'] = []
default['stack-qa']['vagrant-ci']['plugins'] = ['bib-vagrant', 'vagrant-cachier']

default['stack-qa']['vagrant-ci']['plugin_config'] = {
  'bib-vagrant' => {
    'chef_log_level' => 'error',
    'cookbook_path' => '/opt/aws/opsworks/current/site-cookbooks',
    'use_nfs' => false,
    'virtualbox_gui' => false
  }
}
