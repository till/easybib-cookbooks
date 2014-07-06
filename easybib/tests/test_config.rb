require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

# rubocop:disable ClassLength
class TestEasyBib < Test::Unit::TestCase
  include EasyBib

  def test_config_no_doublequote
    fake_node = Chef::Node.new
    fake_node.set['fakeapp']['env']['database']['something'] = 'foo"bar'
    assert_raises RuntimeError do
      ::EasyBib::Config.get_env('nginx', 'fakeapp', fake_node)
    end
  end

  def test_ini_config
    fake_node = Chef::Node.new
    fake_node.set['fakeapp']['env']['database'] = {
      'something' => 'foobar',
      'whatever' => 'bar'
    }
    assert_equal(
      ::EasyBib::Config.get_env('ini', 'fakeapp', fake_node),
      "DATABASE_SOMETHING = \"foobar\"\nDATABASE_WHATEVER = \"bar\"\n"
    )
  end

  def test_config_to_ini
    fake_node = Chef::Node.new
    fake_node.set['deploy'] = {
        'some_app' => {
          'application' => 'some_app',
          'domains' => ['foo.tld', 'bar.tld'],
          'deploy_to' => '/tmp/bla',
          'env' => {
            'bla' => {
              'somekey' => 'somevalue',
              'somegroup' => {
                'someotherkey' => 'someothervalue'
              }
            }
          }
        }
      }

    fake_node.set['opsworks'] =  { 'stack' => { 'name' => 'opsworks-stack' } }
    fake_node.set['easybib_deploy'] =  { 'envtype' => 'playground' }

    assert_equal(
      ::EasyBib::Config.get_configcontent('ini', 'some_app', fake_node),
      "[deployed_application]
appname = \"some_app\"
domains = \"foo.tld,bar.tld\"
deploy_dir = \"/tmp/bla\"
[deployed_stack]
stackname = \"opsworks-stack\"
environment = \"playground\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"\n"
    )
  end
end
