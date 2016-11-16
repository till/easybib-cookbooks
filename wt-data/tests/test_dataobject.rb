require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'dataobject.rb')

class TestWtDataObjects< Test::Unit::TestCase
  def test_config_remove_unused_params
    fake_node = get_fakenode_chef11_scholarfixture
    cleaned_node = ::WT::Data::AppObject.new('the_app', fake_node['deploy']['the_app'])
    assert_equal('Timestamped', cleaned_node['chef_provider'], 'variables we dont use should still be leveraged using the fallback helper')
    assert_equal('web', cleaned_node['document_root'], 'relevant variables should be still available')
    assert_equal('web', cleaned_node[:document_root], 'access should also work for symbols')
  end

  protected

  def get_fakenode_chef11_scholarfixture
    json = JSON.parse(File.read(File.expand_path('fixtures/deploy.json', File.dirname(__FILE__))))
    fake_node = Chef::Node.new
    fake_node.override['deploy']['the_app'] = json
    fake_node
  end
end
