require 'ohai'
require 'json'

Shindo.tests do
  before do
    Ohai::Config[:hints_path] = ['/etc/chef/ohai/hints']
    @ohai = Ohai::System.new

    @node = JSON.parse(::File.read('/tmp/node.json'))
  end

  tests('exists hints file').returns(true) { ::File.exist?('/etc/chef/ohai/hints/test.json') }
  tests('exists hints data').returns(Hash["a", 'hogehoge']) { @ohai.hint?(:test) }
  tests('includes hint at node data').returns('Ohai Chefs!') { @node['automatic']['test_hint'] }
end
