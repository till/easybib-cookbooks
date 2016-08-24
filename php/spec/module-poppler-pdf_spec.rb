require_relative 'spec_helper.rb'

describe 'php::module-poppler-pdf' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  it 'runs poppler' do
    expect(chef_run).to include_recipe('poppler')
  end

end
