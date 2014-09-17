# $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
# $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "fixtures/")
# $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "../../")

require 'chefspec'

RSpec.configure do |c|
  c.platform = 'ubuntu'
  c.version = '12.04'
  #  c.log_level = :debug
end
