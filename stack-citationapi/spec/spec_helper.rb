require 'chefspec'
require_relative 'shared/nginx-config.rb'

RSpec.configure do |c|
  c.platform = 'ubuntu'
  c.version  = '16.04'
end
