require 'test/unit'
require 'chef'

# "Hack" to be able to load a provider without failing on the action keyword
# I use this to test the function spec'ed below
def self.action(_unused)
end

require File.join(File.dirname(__FILE__), '../providers', 'crontab.rb')

class TestEasyBibCrontabProvider < Test::Unit::TestCase
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
end
