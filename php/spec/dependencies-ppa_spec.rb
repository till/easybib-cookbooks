require_relative 'spec_helper.rb'

describe 'php::dependencies-ppa' do

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('ies-apt::ppa')
    expect(chef_run).to include_recipe('aptly::gpg')
    expect(chef_run).to add_apt_repository('easybib-ppa')
  end
end
