require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'php.rb')

class TestPhp < Test::Unit::TestCase
  include EasyBib::Php

  def test_to_php_json
    assert_equal(
      "--- \nBLA: \n",
      to_php_yaml(Chef::Node::ImmutableMash.new(['BLA']))
    )
  end
end
