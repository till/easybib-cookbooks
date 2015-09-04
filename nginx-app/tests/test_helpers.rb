require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'helpers.rb')

class TestHelpers < Test::Unit::TestCase
  def test_uncached_static_extensions
    cache_config = {
      'enabled' => false,
      'config' => {
        'eot|ttf|woff' => {
        },
        'js' => {
        }
      }
    }

    result = ::NginxApp::Helpers.uncached_static_extensions(nil)
    assert_equal(%w(jpg jpeg gif png css js ico woff ttf eot), result)

    result = ::NginxApp::Helpers.uncached_static_extensions(cache_config)
    assert_equal(%w(jpg jpeg gif png css js ico woff ttf eot), result)

    cache_config['enabled'] = true
    result = ::NginxApp::Helpers.uncached_static_extensions(cache_config)
    assert_equal(%w(jpg jpeg gif png css ico), result)
  end
end
