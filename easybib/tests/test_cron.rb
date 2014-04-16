require 'test/unit'
require 'chef'
require File.join(File.dirname(__FILE__), '../libraries/easybib', 'cron.rb')

class TestCron < Test::Unit::TestCase
  def test_cronparser
    crontab_file = File.join(File.dirname(__FILE__), 'crontabs')

    cron = ::EasyBib::Cron.new("application_name", crontab_file)

    crontabs = cron.parse!
    assert_equal(false, crontabs.empty?)
    assert_equal(2, crontabs.length)
  end
end
