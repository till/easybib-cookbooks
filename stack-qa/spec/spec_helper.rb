require 'chefspec'

RSpec.configure do |c|
  c.cookbook_path = "#{File.dirname(__FILE__)}/../../"
  c.log_level = :error
  c.platform = 'ubuntu'
  c.version = '14.04'
end
