require_relative 'spec_helper.rb'

describe 'ies-letsencrypt::default' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'standard' do
    it 'includes all recipes' do
      [
        'ies-letsencrypt::certbot',
        'ies-letsencrypt::setup',
        'ies-letsencrypt::renewal'
      ].each do |recipe|
        expect(chef_run).to include_recipe(recipe)
      end
    end
  end
end
