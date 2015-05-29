require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'easybib.rb')

class TestEasyBib < Test::Unit::TestCase
  include EasyBib

  def test_allow_deploy_not_aws
    # "allow_deploy should never allow when is_aws is false"
    fake_node = Chef::Node.new
    assert_equal(
      false,
      allow_deploy('app', 'app', nil, fake_node)
    )
  end

  def test_allow_deploy_wrong_environment_rejections
    # "allow_deploy should never deploy if [easybib][cluster_name] does not match the stack name"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['some-layer']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-other-name'

    assert_equal(
      false,
      allow_deploy('app', 'app', nil, fake_node)
    )

    # "allow_deploy should never deploy requested_role is not a layer in the stack"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['some-layer']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_equal(
      false,
      allow_deploy('app', 'app', nil, fake_node)
    )
  end

  def test_allow_deploy_valid_singleapp_deploys
    # "allow_deploy should use app name as default layer name"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['app']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_equal(
      true,
      allow_deploy('app', 'app', nil, fake_node)
    )

    # "allow_deploy with custom layer name"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['some-layer']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_equal(
      true,
      allow_deploy('app', 'app', 'some-layer', fake_node)
    )
  end

  def test_allow_deploy_with_multiple_apps
    # "allow_deploy with multiple app names, all wrong"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['app']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_equal(
      false,
      allow_deploy('app', %w(foo-app bar-app), nil, fake_node)
    )

    # "allow_deploy with multiple app names, one correct"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['app']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_equal(
      true,
      allow_deploy('app', %w(app bar-app), nil, fake_node)
    )

    # "allow_deploy should raise an error with wrong vartype for requested app"
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['instance']['layers'] = ['app']
    fake_node.set['opsworks']['stack']['name'] = 'some-name'
    fake_node.set['easybib']['cluster_name'] = 'some-name'

    assert_raise RuntimeError do
      allow_deploy('app', { 'app' => 'bar-app' }, nil, fake_node)
    end
  end

  def test_deploy_crontab
    assert_equal(
      deploy_crontab?([], nil),
      true
    )
  end

  def test_deploy_crontab_wrong_role
    assert_equal(
      deploy_crontab?(%w(role1 role2), 'housekeeping'),
      false
    )
  end

  def test_deploy_crontab_all_roles
    assert_equal(
      deploy_crontab?(%w(role1 housekeeping), 'housekeeping'),
      true
    )
  end

  def test_normalized_cluster_name
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['stack']['name'] = 'EasyBib Playgr$und-123'

    assert_equal(
      'easybib_playgr_und-123',
      get_normalized_cluster_name(fake_node)
    )
  end
end
