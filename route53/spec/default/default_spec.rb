require 'spec_helper'

describe package('build-essential') do
  it { should be_installed }
end

describe package('libxml-dev'), :if => os[:family] == 'debian' do
  it { should be_installed }
end

describe package('libxslt1-dev'), :if => os[:family] == 'debian' do
  it { should be_installed }
end

describe package('libxml-devel'), :if => os[:family] == 'rhel' do
  it { should be_installed }
end

describe package('libxslt1-devel'), :if => os[:family] == 'debian' do
  it { should be_installed }
end

describe package('fog') do
  it { should be_installed.by('gem') }
end
