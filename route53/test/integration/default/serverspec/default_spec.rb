require 'spec_helper'

describe command('/opt/chef/embedded/bin/gem list') do
  its(:stdout) { should match /aws-sdk-core/ }
end
