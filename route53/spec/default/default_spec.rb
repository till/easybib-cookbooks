require 'spec_helper'

describe package('aws-sdk-core') do
  it { should be_installed.by('gem') }
end
