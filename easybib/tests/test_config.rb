require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

# rubocop:disable ClassLength
class TestEasyBibConfig < Test::Unit::TestCase
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
    assert_equal(
      "[deployed_application]
appname = \"some_app\"
domains = \"foo.tld,bar.tld\"
deploy_dir = \"/tmp/bla\"
app_dir = \"/tmp/bla/current/\"
[deployed_stack]
stackname = \"opsworks-stack\"
environment = \"playground\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"\n",
      ::EasyBib::Config.get_configcontent('ini', 'some_app', get_fakenode_config)
    )
  end

  def test_config_to_shell
    assert_equal("export DEPLOYED_APPLICATION_APPNAME=\"some_app\"
export DEPLOYED_APPLICATION_DOMAINS=\"foo.tld,bar.tld\"
export DEPLOYED_APPLICATION_DEPLOY_DIR=\"/tmp/bla\"
export DEPLOYED_APPLICATION_APP_DIR=\"/tmp/bla/current/\"
export DEPLOYED_STACK_STACKNAME=\"opsworks-stack\"
export DEPLOYED_STACK_ENVIRONMENT=\"playground\"
export BLA_SOMEKEY=\"somevalue\"
export BLA_SOMEGROUP_SOMEOTHERKEY=\"someothervalue\"\n",
      ::EasyBib::Config.get_configcontent('shell', 'some_app', get_fakenode_config)
    )
  end

  def test_config_to_nginx
    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld,bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/tmp/bla\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/tmp/bla/current/\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"opsworks-stack\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";
fastcgi_param BLA_SOMEKEY \"somevalue\";
fastcgi_param BLA_SOMEGROUP_SOMEOTHERKEY \"someothervalue\";\n",
      ::EasyBib::Config.get_configcontent('nginx', 'some_app', get_fakenode_config)
    )
  end

  def test_config_to_php
    assert_equal("<?php
return [
  'deployed_application' => [
    'appname'=>\"some_app\",
    'domains'=>\"foo.tld,bar.tld\",
    'deploy_dir'=>\"/tmp/bla\",
    'app_dir'=>\"/tmp/bla/current/\",
  ],
  'deployed_stack' => [
    'stackname'=>\"opsworks-stack\",
    'environment'=>\"playground\",
  ],
  'settings' => [
    'BLA_SOMEKEY'=>\"somevalue\",
    'BLA_SOMEGROUP_SOMEOTHERKEY'=>\"someothervalue\",
  ],
];",
      ::EasyBib::Config.get_configcontent('php', 'some_app', get_fakenode_config)
    )
  end

  protected

  def get_fakenode_config
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

    fake_node
  end
end
