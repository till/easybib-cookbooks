# override this to install for a specific account
default['easybib_vagrant']['environment'] = {
  'user' => 'root',
  'group' => 'root'
}

# required plugins, they are installed for the above user
default['easybib_vagrant']['plugins'] = ['bib-vagrant', 'vagrant-cachier']

# plugin configuration
default['easybib_vagrant']['plugin_config'] = {
  'bib-vagrant' => {
    'chef_log_level' => 'error',
    'cookbook_path' => '~/easybib-cookbooks',
    'use_nfs' => false,
    'virtualbox_gui' => false
  }
}

# path to cookbooks
default['easybib_vagrant']['cookbooks'] = 'https://github.com/till/easybib-cookbooks.git'
