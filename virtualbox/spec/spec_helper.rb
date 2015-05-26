require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color_enabled = true
end

at_exit { ChefSpec::Coverage.report! }
