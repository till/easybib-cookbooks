require 'spec_helper'

describe 'xml::ruby' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }

  it 'installs nokogiri' do
    expect(chef_run).to install_chef_gem('nokogiri')
  end
end
