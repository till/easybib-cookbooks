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

  def test_get_vagrant_appdir
    fake_node = Chef::Node.new
    fake_node.set['vagrant']['applications']['app']['app_root_location'] = '/app/root/dir/'
    assert_equal(
      "/app/root/dir/",
      ::EasyBib::Config.get_vagrant_appdir(fake_node, "app")
    )

    fake_node = Chef::Node.new
    fake_node.set['vagrant']['applications']['app']['doc_root_location'] = '/doc/root/dir/'
    assert_equal(
      "/doc/root/",
      ::EasyBib::Config.get_vagrant_appdir(fake_node, "app")
    )

    fake_node = Chef::Node.new
    assert_equal(
      "/vagrant_data/",
      ::EasyBib::Config.get_vagrant_appdir(fake_node, "app")
    )
  end

  def test_get_domains
    fake_node = Chef::Node.new
    fake_node.set['vagrant']['applications']['app']['domain_name'] = 'whatever.local'
    assert_equal(
      "whatever.local",
      ::EasyBib::Config.get_domains(fake_node, "app")
    )

    fake_node = Chef::Node.new
    fake_node.set['vagrant']['applications']['app']['domain_name'] = ['whatever.local', 'thing.local']
    assert_equal(
      "whatever.local thing.local",
      ::EasyBib::Config.get_domains(fake_node, "app")
    )

    fake_node = Chef::Node.new
    fake_node.set['deploy']['app']['domains'] = ['whatever.local', 'thing.local']
    assert_equal(
      "whatever.local thing.local",
      ::EasyBib::Config.get_domains(fake_node, "app")
    )

    fake_node = Chef::Node.new
    fake_node.set['foo']['domain']['app'] = 'bla.local'
    assert_equal(
      'bla.local',
      ::EasyBib::Config.get_domains(fake_node, 'app', 'foo')
    )

    fake_node = Chef::Node.new
    fake_node.set['getcourse']['domain']['consumer'] = 'bla.local'
    assert_equal(
      'bla.local *.bla.local',
      ::EasyBib::Config.get_domains(fake_node, 'consumer')
    )
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
domains = \"foo.tld bar.tld\"
deploy_dir = \"/tmp/bla/\"
app_dir = \"/tmp/bla/current/\"
doc_root_dir = \"/tmp/bla/current/www/\"
[deployed_stack]
stackname = \"opsworks-stack\"
environment = \"playground\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"\n",
      ::EasyBib::Config.get_configcontent('ini', 'some_app', get_fakenode_config)
    )
  end

  def test_config_with_rds_to_ini
    # IMPORTANT: Do not use port as string, since we want to check if no
    # Fixnum to string error happens
    fake_node = get_fakenode_config
    fake_node.set['deploy']['some_app']['database'] = {
          'host' => 'some.db.tld',
          'user' => 'dbuser',
          'port' => 1234
      }

    assert_equal(
      "[deployed_application]
appname = \"some_app\"
domains = \"foo.tld bar.tld\"
deploy_dir = \"/tmp/bla/\"
app_dir = \"/tmp/bla/current/\"
doc_root_dir = \"/tmp/bla/current/www/\"
[deployed_stack]
stackname = \"opsworks-stack\"
environment = \"playground\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"
AWS_DB_HOST = \"some.db.tld\"
AWS_DB_USER = \"dbuser\"
AWS_DB_PORT = \"1234\"\n",
      ::EasyBib::Config.get_configcontent('ini', 'some_app', fake_node)
    )
  end

  def test_config_to_shell
    assert_equal("export DEPLOYED_APPLICATION_APPNAME=\"some_app\"
export DEPLOYED_APPLICATION_DOMAINS=\"foo.tld bar.tld\"
export DEPLOYED_APPLICATION_DEPLOY_DIR=\"/tmp/bla/\"
export DEPLOYED_APPLICATION_APP_DIR=\"/tmp/bla/current/\"
export DEPLOYED_APPLICATION_DOC_ROOT_DIR=\"/tmp/bla/current/www/\"
export DEPLOYED_STACK_STACKNAME=\"opsworks-stack\"
export DEPLOYED_STACK_ENVIRONMENT=\"playground\"
export BLA_SOMEKEY=\"somevalue\"
export BLA_SOMEGROUP_SOMEOTHERKEY=\"someothervalue\"\n",
      ::EasyBib::Config.get_configcontent('shell', 'some_app', get_fakenode_config)
    )
  end

  def test_config_to_nginx
    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/tmp/bla/\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/tmp/bla/current/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/tmp/bla/current/www/\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"opsworks-stack\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";
fastcgi_param BLA_SOMEKEY \"somevalue\";
fastcgi_param BLA_SOMEGROUP_SOMEOTHERKEY \"someothervalue\";\n",
      ::EasyBib::Config.get_configcontent('nginx', 'some_app', get_fakenode_config)
    )
  end

  def test_config_to_nginx_empty_settings
    fake_node = Chef::Node.new
    fake_node.set['deploy'] = {
        'some_app' => {
          'application' => 'some_app',
          'domains' => ['foo.tld', 'bar.tld'],
          'deploy_to' => '/tmp/bla',
          'document_root' => 'www'
        }
      }

    fake_node.set['opsworks'] =  { 'stack' => { 'name' => 'opsworks-stack' } }
    fake_node.set['easybib_deploy'] =  { 'envtype' => 'playground' }

    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/tmp/bla/\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/tmp/bla/current/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/tmp/bla/current/www/\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"opsworks-stack\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";\n",
      ::EasyBib::Config.get_configcontent('nginx', 'some_app', fake_node)
    )
  end

  def test_config_vagrantenv
    fake_node = Chef::Node.new
    fake_node.set['deploy'] = {
        'some_app' => {
          'application' => 'some_app',
          'domains' => ['foo.tld', 'bar.tld']
        }
      }

    fake_node.set['vagrant'] =  { 'applications' => { 'some_app' => { 'app_root_location' => '/some_path', 'doc_root_location' => '/some_path/foo' } } }
    fake_node.set['easybib_deploy'] =  { 'envtype' => 'playground' }

    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/some_path/\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/some_path/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/some_path/foo/\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"vagrant\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";\n",
      ::EasyBib::Config.get_configcontent('nginx', 'some_app', fake_node)
    )
  end

  def test_config_to_php
    assert_equal("<?php
return [
  'deployed_application' => [
    'appname'=>\"some_app\",
    'domains'=>\"foo.tld bar.tld\",
    'deploy_dir'=>\"/tmp/bla/\",
    'app_dir'=>\"/tmp/bla/current/\",
    'doc_root_dir'=>\"/tmp/bla/current/www/\",
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
          'document_root' => 'www'
        }
      }
    fake_node.set['some_app'] = {
        'env' => {
          'bla' => {
            'somekey' => 'somevalue',
            'somegroup' => {
              'someotherkey' => 'someothervalue'
            }
          }
        }
      }

    fake_node.set['opsworks'] =  { 'stack' => { 'name' => 'opsworks-stack' } }
    fake_node.set['easybib_deploy'] =  { 'envtype' => 'playground' }

    fake_node
  end
end
