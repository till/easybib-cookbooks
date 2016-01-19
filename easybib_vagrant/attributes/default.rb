# override this to install for a specific account
default['easybib_vagrant']['environment'] = {
  'user' => 'root',
  'group' => 'root'
}

# vagrant plugins
default['easybib_vagrant']['plugin_config'] = {
  'bib-vagrant' => {
    'chef_log_level' => 'error',
    'cookbook_path' => '~/easybib-cookbooks',
    'use_nfs' => false,
    'virtualbox_gui' => false
  },
  'vagrant-cachier' => {
  }
  'vagrant-faster' => {
  }
  'landrush' => {
  }
}

# cookbook repo
default['easybib_vagrant']['cookbooks'] = 'https://github.com/till/easybib-cookbooks.git'
