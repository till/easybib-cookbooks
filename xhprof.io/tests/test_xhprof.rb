require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries', 'xhprof.rb')

class TestXHProf < Test::Unit::TestCase
  include XHProf
  def test_get_path
    node = {}
    node["xhprof"] = {}
    node["xhprof"]["url"] = "http://example.org/xhprof/"
    assert_equal get_path(node), "/xhprof"
  end
end
