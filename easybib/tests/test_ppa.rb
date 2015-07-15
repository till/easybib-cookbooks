# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
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

  def test_php_mirror_repo_url
    fake_node = Chef::Node.new
    fake_node.set['apt']['php_mirror_version'] = '55'
    assert_equal(
      'http://ppa.ezbib.com/mirrors/php55',
      php_mirror_repo_url(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['apt']['php_mirror_version'] = '56'
    assert_equal(
      'http://ppa.ezbib.com/mirrors/php56',
      php_mirror_repo_url(fake_node)
    )
  end

  def test_remote_ppa_mirror
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
      'http://ppa.ezbib.com/mirrors/remote-mirrors',
      ppa_mirror(fake_node, 'http://something.com')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    fake_node.set['apt']['php_mirror_version'] = '56'
    assert_equal(
      'http://ppa.ezbib.com/mirrors/remote-mirrors',
      ppa_mirror(fake_node, 'http://something.com')
    )
  end

  def test_php_ppa_mirror
    fake_node = Chef::Node.new
    fake_node.set['apt']['php_mirror_version'] = '55'
    assert_equal(
      'ppa:easybib/php55',
      ppa_mirror(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['apt']['enable_ppa_mirror'] = false
    fake_node.set['apt']['php_mirror_version'] = '55'
    assert_equal(
      'ppa:easybib/php55',
      ppa_mirror(fake_node, 'ppa:easybib/php55')
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    fake_node.set['apt']['php_mirror_version'] = '55'
    assert_equal(
      'http://ppa.ezbib.com/mirrors/php55',
      ppa_mirror(fake_node)
    )
    fake_node = Chef::Node.new
    fake_node.set['lsb']['codename'] = 'trusty'
    fake_node.set['apt']['enable_ppa_mirror'] = true
    fake_node.set['apt']['php_mirror_version'] = '56'
    assert_equal(
      'http://ppa.ezbib.com/mirrors/php56',
      ppa_mirror(fake_node)
    )
  end
end
