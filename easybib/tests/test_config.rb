require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

# rubocop:disable ClassLength
class TestEasyBibConfig < Test::Unit::TestCase
  include EasyBib

  def test_config_no_doublequote
    fake_node = Chef::Node.new
    fake_node.override['fakeapp']['env']['database']['something'] = 'foo"bar'
    assert_raises RuntimeError do
      ::EasyBib::Config.get_env('nginx', 'fakeapp', fake_node)
    end
  end

  def test_get_vagrant_appdir
    fake_node = Chef::Node.new
    fake_node.override['vagrant']['applications']['app']['app_root_location'] = '/app/root/dir/'
    fake_node.override['vagrant']['applications']['app']['doc_root_location'] = '/foo/bla/dir/www/'
    assert_equal(
      '/app/root/dir/',
      ::EasyBib::Config.get_appdata(fake_node, 'app', 'app_dir')
    )

    fake_node = Chef::Node.new
    fake_node.override['vagrant']['applications']['app']['doc_root_location'] = '/doc/root/dir/'
    assert_equal(
      '/doc/root/',
      ::EasyBib::Config.get_appdata(fake_node, 'app', 'app_dir')
    )
  end

  def test_get_domains
    fake_node = Chef::Node.new
    fake_node.override['vagrant']['applications']['app']['domain_name'] = 'whatever.local'
    assert_equal(
      'whatever.local',
      ::EasyBib::Config.get_domains(fake_node, 'app')
    )

    fake_node = Chef::Node.new
    fake_node.override['vagrant']['applications']['app']['domain_name'] = ['whatever.local', 'thing.local']
    assert_equal(
      'whatever.local thing.local',
      ::EasyBib::Config.get_domains(fake_node, 'app')
    )

    fake_node = Chef::Node.new
    fake_node.override['deploy']['app']['domains'] = ['whatever.local', 'thing.local']
    assert_equal(
      'whatever.local thing.local',
      ::EasyBib::Config.get_domains(fake_node, 'app')
    )

    fake_node = Chef::Node.new
    fake_node.override['foo']['domain']['app'] = 'bla.local'
    assert_equal(
      'bla.local',
      ::EasyBib::Config.get_domains(fake_node, 'app', 'foo')
    )
  end

  def test_ini_config
    fake_node = Chef::Node.new
    fake_node.override['fakeapp']['env']['database'] = {
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
environment = \"playground\"
stackname = \"opsworks-stack\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"
BLA_SOMEARRAY[0] = \"server1\"
BLA_SOMEARRAY[1] = \"server2\"\n",
      ::EasyBib::Config.get_configcontent('ini', 'some_app', get_fakenode_config)
    )
  end

  # rubocop:disable Metrics/MethodLength
  def test_config_with_rds_to_ini
    # IMPORTANT: Do not use port as string, since we want to check if no
    # Fixnum to string error happens
    fake_node = get_fakenode_config
    fake_node.override['deploy']['some_app']['database'] = {
      'type' => 'mysql',
      'host' => 'some.db.tld',
      'username' => 'dbuser',
      'password' => 'somepass',
      'database' => 'somedb',
      'port' => 1234,
      'reconnect' => true
    }

    assert_equal(
      "[deployed_application]
appname = \"some_app\"
domains = \"foo.tld bar.tld\"
deploy_dir = \"/tmp/bla/\"
app_dir = \"/tmp/bla/current/\"
doc_root_dir = \"/tmp/bla/current/www/\"
[deployed_stack]
environment = \"playground\"
stackname = \"opsworks-stack\"
[settings]
BLA_SOMEKEY = \"somevalue\"
BLA_SOMEGROUP_SOMEOTHERKEY = \"someothervalue\"
BLA_SOMEARRAY[0] = \"server1\"
BLA_SOMEARRAY[1] = \"server2\"
DB_TYPE = \"mysql\"
DB_HOST = \"some.db.tld\"
DB_USERNAME = \"dbuser\"
DB_PASSWORD = \"somepass\"
DB_DATABASE = \"somedb\"
DB_PORT = \"1234\"
DB_RECONNECT = \"true\"
DATABASE_URL = \"mysql2://dbuser:somepass@some.db.tld:1234/somedb?reconnect=true\"\n",
      ::EasyBib::Config.get_configcontent('ini', 'some_app', fake_node)
    )
  end
  # rubocop:enable Metrics/MethodLength

  def test_config_to_shell
    assert_equal("export DEPLOYED_APPLICATION_APPNAME=\"some_app\"
export DEPLOYED_APPLICATION_DOMAINS=\"foo.tld bar.tld\"
export DEPLOYED_APPLICATION_DEPLOY_DIR=\"/tmp/bla/\"
export DEPLOYED_APPLICATION_APP_DIR=\"/tmp/bla/current/\"
export DEPLOYED_APPLICATION_DOC_ROOT_DIR=\"/tmp/bla/current/www/\"
export DEPLOYED_STACK_ENVIRONMENT=\"playground\"
export DEPLOYED_STACK_STACKNAME=\"opsworks-stack\"
export BLA_SOMEKEY=\"somevalue\"
export BLA_SOMEGROUP_SOMEOTHERKEY=\"someothervalue\"
export BLA_SOMEARRAY[0]=\"server1\"
export BLA_SOMEARRAY[1]=\"server2\"\n",
                 ::EasyBib::Config.get_configcontent('shell', 'some_app', get_fakenode_config)
                )
  end

  def test_config_to_nginx
    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/tmp/bla/\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/tmp/bla/current/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/tmp/bla/current/www/\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"opsworks-stack\";
fastcgi_param BLA_SOMEKEY \"somevalue\";
fastcgi_param BLA_SOMEGROUP_SOMEOTHERKEY \"someothervalue\";
fastcgi_param BLA_SOMEARRAY[0] \"server1\";
fastcgi_param BLA_SOMEARRAY[1] \"server2\";\n",
                 ::EasyBib::Config.get_configcontent('nginx', 'some_app', get_fakenode_config)
                )
  end

  def test_config_to_nginx_empty_settings
    fake_node = Chef::Node.new
    fake_node.override['deploy'] = {
      'some_app' => {
        'application' => 'some_app',
        'domains' => ['foo.tld', 'bar.tld'],
        'deploy_to' => '/tmp/bla',
        'document_root' => 'www'
      }
    }

    fake_node.override['opsworks'] =  { 'stack' => { 'name' => 'opsworks-stack' } }
    fake_node.override['easybib_deploy'] =  { 'envtype' => 'playground' }

    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/tmp/bla/\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/tmp/bla/current/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/tmp/bla/current/www/\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"playground\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"opsworks-stack\";\n",
                 ::EasyBib::Config.get_configcontent('nginx', 'some_app', fake_node)
                )
  end

  def test_config_vagrantenv
    fake_node = Chef::Node.new
    fake_node.override['deploy'] = {
      'some_app' => {
        'application' => 'some_app',
        'domains' => ['foo.tld', 'bar.tld']
      }
    }

    fake_node.override['vagrant'] =  { 'applications' => { 'some_app' => { 'app_root_location' => '/some_path', 'doc_root_location' => '/some_path/foo' } } }
    fake_node.override['easybib_deploy'] =  { 'envtype' => 'playground' }

    assert_equal("fastcgi_param DEPLOYED_APPLICATION_APPNAME \"some_app\";
fastcgi_param DEPLOYED_APPLICATION_DOMAINS \"foo.tld bar.tld\";
fastcgi_param DEPLOYED_APPLICATION_APP_DIR \"/some_path/\";
fastcgi_param DEPLOYED_APPLICATION_DEPLOY_DIR \"/some_path/\";
fastcgi_param DEPLOYED_APPLICATION_DOC_ROOT_DIR \"/some_path/foo/\";
fastcgi_param DEPLOYED_STACK_ENVIRONMENT \"vagrant\";
fastcgi_param DEPLOYED_STACK_STACKNAME \"vagrant\";\n",
                 ::EasyBib::Config.get_configcontent('nginx', 'some_app', fake_node)
                )
  end

  def test_config_to_php
    assert_equal("<?php
return [
  'deployed_application' => [
    'appname'=>'some_app',
    'domains'=>'foo.tld bar.tld',
    'deploy_dir'=>'/tmp/bla/',
    'app_dir'=>'/tmp/bla/current/',
    'doc_root_dir'=>'/tmp/bla/current/www/',
  ],
  'deployed_stack' => [
    'environment'=>'playground',
    'stackname'=>'opsworks-stack',
  ],
  'settings' => [
    'BLA_SOMEKEY'=>'somevalue',
    'BLA_SOMEGROUP_SOMEOTHERKEY'=>'someothervalue',
    'BLA_SOMEARRAY'=> ['server1', 'server2'],
  ],
];",
                 ::EasyBib::Config.get_configcontent('php', 'some_app', get_fakenode_config)
                )
  end

  def test_merged_config_to_shell
    assert_equal("export DEPLOYED_APPLICATION_APPNAME=\"some_app\"
export DEPLOYED_APPLICATION_DOMAINS=\"foo.tld bar.tld\"
export DEPLOYED_APPLICATION_DEPLOY_DIR=\"/tmp/bla/\"
export DEPLOYED_APPLICATION_APP_DIR=\"/tmp/bla/current/\"
export DEPLOYED_APPLICATION_DOC_ROOT_DIR=\"/tmp/bla/current/www/\"
export DEPLOYED_STACK_ENVIRONMENT=\"playground\"
export DEPLOYED_STACK_STACKNAME=\"some_stack\"
export STACKVALUE_SOMEKEY=\"somevalue\"
export BLA_SOMEKEY=\"somevalue\"
export BLA_SOMEGROUP_SOMEOTHERKEY=\"someothervalue\"
export BLA_SOMEARRAY[0]=\"server1\"
export BLA_SOMEARRAY[1]=\"server2\"\n",
                 ::EasyBib::Config.get_configcontent('shell', 'some_app', get_fakenode_redundant_config, 'some_stack')
                )
  end

  protected

  def get_fakenode_config
    fake_node = Chef::Node.new
    fake_node.override['deploy'] = {
      'some_app' => {
        'application' => 'some_app',
        'domains' => ['foo.tld', 'bar.tld'],
        'deploy_to' => '/tmp/bla',
        'document_root' => 'www'
      }
    }
    fake_node.override['some_app'] = {
      'env' => {
        'bla' => {
          'somekey' => 'somevalue',
          'somegroup' => {
            'someotherkey' => 'someothervalue'
          },
          'somearray' => %w(server1 server2)
        }
      }
    }

    fake_node.override['opsworks'] =  { 'stack' => { 'name' => 'opsworks-stack' } }
    fake_node.override['easybib_deploy'] =  { 'envtype' => 'playground' }

    fake_node
  end

  def get_fakenode_redundant_config
    fake_node = Chef::Node.new
    fake_node.override['deploy']['some_app'] = {
      'application' => 'some_app',
      'domains' => ['foo.tld', 'bar.tld'],
      'deploy_to' => '/tmp/bla',
      'document_root' => 'www'
    }
    fake_node.override['some_app']['env']['bla'] = {
      'somekey' => 'somevalue',
      'somegroup' => {
        'someotherkey' => 'someothervalue'
      },
      'somearray' => %w(server1 server2)
    }
    fake_node.override['some_stack']['env']['stackvalue']['somekey'] = 'somevalue'
    fake_node.override['some_stack']['env']['bla']['somekey'] = 'this-should-not-be-here'
    fake_node.override['opsworks']['stack']['name'] = 'some_stack'
    fake_node.override['easybib_deploy']['envtype'] = 'playground'

    fake_node
  end
end
