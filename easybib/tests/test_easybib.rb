require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')

class TestEasyBib < Test::Unit::TestCase
  include EasyBib

  def test_config_no_doublequote
    fake_node = Chef::Node.new
    fake_node.set["fakeapp"]["env"]["database"]["something"] = 'foo"bar'
    assert_raises RuntimeError do 
      get_env("fakeapp", fake_node, "nginx")
    end
  end

  def test_build_nginx_config
    fake_node = Chef::Node.new
    fake_node.set["env"]["database"] = {
      "app" => {
        "hostname" => "127.0.0.1",
        "username" => "root",
        "password" => "test123",
        "database" => "app_stage"
      }
    }

    fake_node["env"]["database"]["app"].each do |k, v|
      assert_equal(
        build_nginx_config("app_#{k}", v),
        "fastcgi_param app_#{k} \"#{v}\";\n"
      )
    end
  end

  def test_build_ini_config
    fake_node = Chef::Node.new
    fake_node.set["env"]["database"] = {
      "app" => {
        "hostname" => "127.0.0.1",
        "username" => "root",
        "password" => "test123",
        "database" => "app_stage"
      }
    }

    fake_node["env"]["database"]["app"].each do |k, v|
      assert_equal(
        "app_#{k} = \"#{v}\"\n",
        build_ini_config("app_#{k}", v)
      )
    end
  end

  def test_ini_config
    fake_node = Chef::Node.new
    fake_node.set["fakeapp"]["env"]["database"] = {
      "something" => "foobar",
      "whatever" => "bar"
    }
    assert_equal(
      get_env("fakeapp", fake_node, "ini"),
      "DATABASE_SOMETHING = \"foobar\"\nDATABASE_WHATEVER = \"bar\"\n"
    )
  end


  def test_get_db_conf
    # breaks on ruby 1.8
    # assert_equal(
    #  get_db_conf("env", fake_node),
    #  "fastcgi_param APP_HOSTNAME \"127.0.0.1\";\nfastcgi_param APP_USERNAME \"root\";\nfastcgi_param APP_PASSWORD \"test123\";\nfastcgi_param APP_DATABASE \"app_stage\";\n"
    # )
  end

  def test_to_php_json
    assert_equal(
      "--- \nBLA: \n",
      to_php_yaml(Chef::Node::ImmutableMash.new(["BLA"]))
    )
  end

  def test_get_domain_conf
    fake_node = Chef::Node.new
    fake_node.set["env"]["domain"] = {
      "api" => "api.local"
    }

    # assert_equal(
    #  get_domain_conf("env", fake_node),
    #  "fastcgi_param DOMAIN_API \"api.local\";\n"
    # )
  end
end
