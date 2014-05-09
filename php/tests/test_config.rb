require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

class TestConfig < Test::Unit::TestCase
  def test_get_directives

    directives = {
      "opcache.memory_consumption" => 10
    }

    config = ::Php::Config.new("opcache", directives)

    config_directives = config.get_directives
    assert_equal(false, config_directives.empty?)
    assert_equal(1, config_directives.length)
  end
end
