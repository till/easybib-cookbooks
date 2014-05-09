require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

class TestConfig < Test::Unit::TestCase

  # ensures a leading extension name is stripped
  def test_get_directives

    directives = {
      "opcache.memory_consumption" => 10,
      "opcache.super_duper" => true,
      "no_prefix" => 1
    }

    config = ::Php::Config.new("opcache", directives)

    config_directives = config.get_directives
    assert_equal(false, config_directives.empty?)
    assert_equal(directives.length, config_directives.length)
    assert_equal(config_directives["memory_consumption"], 10)
    assert_equal(config_directives["super_duper"], true)
    assert_equal(config_directives["no_prefix"], 1)
  end
end
