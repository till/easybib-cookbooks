require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'ppa.rb')

class TestEasyBib < Test::Unit::TestCase
  include EasyBib::Ppa

  def test_use_aptly_mirror
    fake_node = Chef::Node.new
    assert_equal(
      false,
      use_aptly_mirror?(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'precise'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    assert_equal(
      false,
      use_aptly_mirror?(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = false
    assert_equal(
      false,
      use_aptly_mirror?(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    assert_equal(
      true,
      use_aptly_mirror?(fake_node)
    )
  end

  def test_repo_url
    fake_node = Chef::Node.new
    assert_equal(
      'http://ppa.ezbib.com/distrib55',
      repo_url(fake_node, 'distrib')
    )
    fake_node = Chef::Node.new
    fake_node.set['apt']['ppa_mirror_version'] = '56'
    assert_equal(
      'http://ppa.ezbib.com/trusty56',
      repo_url(fake_node, 'trusty')
    )
  end

  def test_ppa_mirror
    fake_node = Chef::Node.new
    assert_equal(
      'http://something.com',
      ppa_mirror(fake_node, 'http://something.com')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'precise'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    assert_equal(
      'http://something.com',
      ppa_mirror(fake_node, 'http://something.com')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = false
    assert_equal(
      'http://something.com',
      ppa_mirror(fake_node, 'http://something.com')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    assert_equal(
      'http://ppa.ezbib.com/trusty55',
      ppa_mirror(fake_node, 'http://something.com')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    fake_node.set['apt']['ppa_mirror_version'] = '56'
    assert_equal(
      'http://ppa.ezbib.com/trusty56',
      ppa_mirror(fake_node, 'http://something.com')
    )
  end
end
