require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'config.rb')

class TestEasyBibConfig < Test::Unit::TestCase
  include EasyBib

  def test_get_from_stack
    fake_node                                       = Chef::Node.new
    fake_node.override['value']                     = 'content'
    fake_node.override['foo']['bar']['bla']['batz'] = 'thing'
    assert_equal(
      'thing',
      ::EasyBib::Config.node(fake_node, 'app', 'foo', 'bar', 'bla', 'batz')
    )
    assert_equal(
      'content',
      ::EasyBib::Config.node(fake_node, 'app', 'value')
    )
  end

  def test_get_for_app
    fake_node                                              = Chef::Node.new
    fake_node.override['value']                            = 'content'
    fake_node.override['foo']['bar']['bla']['batz']        = 'thing'
    fake_node.override['app']['value']                     = 'app-content'
    fake_node.override['app']['foo']['bar']['bla']['batz'] = 'app-thing'
    assert_equal(
      'app-thing',
      ::EasyBib::Config.node(fake_node, 'app', 'foo', 'bar', 'bla', 'batz')
    )
    assert_equal(
      'app-content',
      ::EasyBib::Config.node(fake_node, 'app', 'value')
    )
  end
end
