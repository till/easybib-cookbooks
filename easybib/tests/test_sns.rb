require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'sns.rb')

class FakeSNS
  def publish(params)
    {
      :message_id => 1
    }
  end
end

class TestEasyBibSns < Test::Unit::TestCase
  include EasyBib::SNS

  def test_does_not_send_sns
    fake_node = get_fake_node

    assert_equal(false, sns_notify_spinup(fake_node, FakeSNS.new))
  end

  def test_does_send_sns
    fake_node = get_fake_node
    fake_node.set['easybib']['sns']['topic_arn'] = 'foobar'

    assert_equal(true, sns_notify_spinup(fake_node, FakeSNS.new))
  end

  private

  def get_fake_node
    fake_node = Chef::Node.new
    fake_node.set['opsworks']['stack']['name'] = 'unittest'
    fake_node.set['opsworks']['instance']['hostname'] = 'localhost-test'
    fake_node.set['easybib']['sns']['notify_spinup'] = '-test'

    fake_node
  end
end
