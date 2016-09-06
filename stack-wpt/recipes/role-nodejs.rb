node.set['nodejs'] = {
  'version' => '4.2.6',
  'install_method' => 'binary',
  'npm' => {
    'install_method' => 'from_latest',
    'version' => '2.14.16'
  }
}

include_recipe 'nodejs'
include_recipe 'nodejs::npm'

package 'build-essential'
package 'g++'
