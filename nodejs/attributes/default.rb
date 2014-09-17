default['nodejs'] = {}
default['nodejs']['version'] = '0.10.25'
default['nodejs']['checksum_linux_x64'] = '1dac61c21fa21e47fc6e799757569c6c3914897ca46fc8f4dd2c8f13f0400626'
default['nodejs']['checksum_linux_x86'] = '3f1fa0bb332b1354bca8d52d89e92c8884b6469a0f5fc3826ee72c2639279995'

default['nodejs']['src_url'] = 'http://nodejs.org/dist'

default['nodejs']['prefix'] = '/opt/nodejs'

default['nodejs']['dir'] = '/usr/local'
default['nodejs']['npm'] = '1.3.5'
default['nodejs']['make_threads'] = node['cpu'] ? node['cpu']['total'].to_i : 2
default['nodejs']['directories'] = ['.npm', 'tmp']

default['nodejs']['npm'] = {
  'install_url' => 'https://www.npmjs.org/install.sh'
}
