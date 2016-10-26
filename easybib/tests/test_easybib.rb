require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')

class TestEasyBib < Test::Unit::TestCase
  include EasyBib

  def test_has_role_no_role
    assert_equal(
      has_role?([], nil),
      true
    )
  end

  def test_has_role_wrong_role
    assert_equal(
      has_role?(%w(role1 role2), 'housekeeping'),
      false
    )
  end

  def test_has_role_right_role
    assert_equal(
      has_role?(%w(role1 housekeeping), 'housekeeping'),
      true
    )
  end

  def test_normalized_cluster_name
    fake_node = Chef::Node.new
    fake_node.override['opsworks']['stack']['name'] = 'EasyBib Playgr$und-123'

    assert_equal(
      'easybib_playgr_und-123',
      get_normalized_cluster_name(fake_node)
    )
  end
end
