require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

# rubocop:disable ClassLength
class TestEasyBibConfig < Test::Unit::TestCase
  include EasyBib

  def test_get_from_stack
    fake_node = Chef::Node.new
    fake_node.set['value'] = 'content'
    fake_node.set['foo']['bar']['bla']['batz'] = 'thing'
    assert_equal(
      'thing',
      ::EasyBib::Config.node('app', 'foo', 'bar', 'bla', 'batz', fake_node)
    )
    assert_equal(
      'content',
      ::EasyBib::Config.node('app', 'value', fake_node)
    )
  end
  def test_get_for_app
    fake_node = Chef::Node.new
    fake_node.set['value'] = 'content'
    fake_node.set['foo']['bar']['bla']['batz'] = 'thing'
    fake_node.set['app']['value'] = 'app-content'
    fake_node.set['app']['foo']['bar']['bla']['batz'] = 'app-thing'
    assert_equal(
      'app-thing',
      ::EasyBib::Config.node('app', 'foo', 'bar', 'bla', 'batz', fake_node)
    )
    assert_equal(
      'app-content',
      ::EasyBib::Config.node('app', 'value', fake_node)
    )
  end
end
