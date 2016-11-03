require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'dataobject.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'appstodeploy.rb')
require File.join(File.dirname(__FILE__), '../libraries', 'injector.rb')

class TestWtDataAccessor< Test::Unit::TestCase
  def test_config_cleanup
    fake_node = get_fakenode_chef11_multipleapps
    result = ::WT::Data::Injector.get_apps_to_deploy(fake_node)
    assert_equal('web', result['the_app']['document_root'], 'relevant variables should be still available for both apps')
    assert_equal('web', result['another_app']['document_root'], 'relevant variables should be still available for both apps')
  end

  protected

  def get_fakenode_chef11_multipleapps
    json = JSON.parse(File.read(File.expand_path('fixtures/deploy.json', File.dirname(__FILE__))))
    fake_node = Chef::Node.new
    fake_node.override['deploy']['the_app'] = json
    fake_node.override['deploy']['another_app'] = json
    fake_node
  end
end
