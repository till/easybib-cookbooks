require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'helpers.rb')

class TestHelpers < Test::Unit::TestCase
  def test_merge_alias_config
    js_alias = {
      'debugger' => 'debugger',
      'notes'    => 'notebook'
    }
    path = '/some/path'
    expected = {
      'js/debugger' => '/some/path/app/modules/debugger',
      'js/notes' => '/some/path/app/modules/notebook'
    }
    result = ::NginxApp::Helpers.merge_alias_config({}, js_alias, 'js', path)
    assert_equal(expected, result)

    css_alias_config = {
      'notes' => 'notebook'
    }
    alias_config = {
      'js/debugger' => '/some/path/app/modules/debugger',
      'js/notes' => '/some/path/app/modules/notebook'
    }
    # note: ending slash is intentionally only here, to test if autodetect+add works
    path = '/some/path/'
    expected = {
      'js/debugger' => '/some/path/app/modules/debugger',
      'js/notes' => '/some/path/app/modules/notebook',
      'css/notes' => '/some/path/app/modules/notebook'
    }
    result = ::NginxApp::Helpers.merge_alias_config(alias_config, css_alias_config, 'css', path)
    assert_equal(expected, result)
  end

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
