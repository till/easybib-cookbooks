require 'chefspec'

describe 'haproxy::plugin_newrelic' do
  it 'installs the newrelic haproxy plugin' do
    chef_run = ChefSpec::ChefRunner.new

    haproxy_node = {
      'stats_user' => 'my-user',
      'stats_pass' => 'helloworld',
      'stats_url'  => '/haproxy-stats',
      'newrelic' => {
        'backends' => [
          {'name' => 'backend1', 'proxy' => 'my_app_servers'}
        ],
        'frontends' => [
          {'name' => 'frontend1', 'proxy' => 'http-in'}
        ]
      }
    }

    newrelic_node = {
      'haproxy' => {
        'backends' => [
          {'name' => 'backend1', 'proxy' => 'my_app_servers'}
        ],
        'frontends' => [
          {'name' => 'frontend1', 'proxy' => 'http-in'}
        ]
      }
    }

    chef_run.node.set['haproxy'] = haproxy_node
    chef_run.node.set['newrelic'] = newrelic_node

    chef_run.converge 'newrelic::plugin_haproxy'
    expect(chef_run).to install_gem_package 'bundler'
    expect(chef_run).to install_gem_package 'fastercsv'
    expect(chef_run).to install_gem_package 'newrelic_haproxy_agent'

    expect(chef_run).to create_cookbook_file '/etc/init.d/newrelic-haproxy'
    file = chef_run.cookbook_file('/etc/init.d/newrelic-haproxy')
    expect(file.mode).to eq('0755')

    expect(chef_run).to create_file '/etc/newrelic/newrelic_haproxy_agent.yml'
    file = chef_run.template('/etc/newrelic/newrelic_haproxy_agent.yml')
    expect(file.mode).to eq('0644')
  end
end
