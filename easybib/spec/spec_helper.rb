require 'chefspec'

require_relative '../libraries/matchers'

RSpec.configure do |c|
  c.platform = 'ubuntu'
  c.version = '16.04'
  c.log_level = :error
end
