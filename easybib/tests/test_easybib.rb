require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')

class TestEasyBib < Test::Unit::TestCase
  include EasyBib

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

    fake_node["env"]["database"]["app"].each do |k,v|
      assert_equal(
        build_nginx_config("app_#{k}", v),
        "fastcgi_param APP_#{k.upcase} \"#{v}\";\n"
      )
    end
  end

  def test_get_db_conf
    # breaks on ruby 1.8
    #assert_equal(
    #  get_db_conf("env", fake_node),
    #  "fastcgi_param APP_HOSTNAME \"127.0.0.1\";\nfastcgi_param APP_USERNAME \"root\";\nfastcgi_param APP_PASSWORD \"test123\";\nfastcgi_param APP_DATABASE \"app_stage\";\n"
    #)
  end

  def test_get_domain_conf
    fake_node = Chef::Node.new
    fake_node.set["env"]["domain"] = {
      "api" => "api.local"
    }

    #assert_equal(
    #  get_domain_conf("env", fake_node),
    #  "fastcgi_param DOMAIN_API \"api.local\";\n"
    #)
  end

end
