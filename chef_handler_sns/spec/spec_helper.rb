require 'rspec/expectations' # https://github.com/rubygems/rubygems/issues/853
require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'support/matchers'

RSpec.configure do |config|
  # Prohibit using the should syntax
  config.expect_with :rspec do |spec|
    spec.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  config.order = 'random'

  # ChefSpec configuration
  config.log_level = :fatal
  config.color = true
  config.formatter = :documentation
end

# at_exit { ChefSpec::Coverage.report! } # still in beta
