require_relative 'spec_helper'

describe 'ies-route53::add' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'AWS' do
    before do
      # mock OpsWorks
      node.override['opsworks'] = {
        'instance' => {
          'hostname' => 'spec',
          'region' => 'local',
          'ip' => '127.0.0.8'
        },
        'stack' => {
          'name' => 'chefspec'
        }
      }
    end

    describe 'skip' do
      it 'it does not call route53_record when no zone is set' do
        expect(chef_run).not_to create_ies_route53_record('create a record')
      end
    end

    describe 'add' do
      before do
        node.override['ies-route53']['zone'] = {
          'ttl' => 1,
          'id' => 'foo',
          'custom_access_key' => 'access-key',
          'custom_secret_key' => 'secret-key'
        }
      end

      it 'creates a record' do
        expect(chef_run).to create_ies_route53_record('spec.chefspec.local')
          .with(
            :name => 'spec.chefspec.local',
            :value => '127.0.0.8',
            :type => 'A',
            :ttl => 1,
            :zone_id => 'foo',
            :aws_access_key_id => 'access-key',
            :aws_secret_access_key => 'secret-key'
          )
      end
    end

    describe 'credential auto discovery' do
      before do
        node.override['ies-route53']['zone'] = {
          'ttl' => 2,
          'id' => 'bar'
        }
      end

      it "doesn't need access key id and secret" do
        expect(chef_run).to create_ies_route53_record('spec.chefspec.local')
          .with(
            :name => 'spec.chefspec.local',
            :value => '127.0.0.8',
            :type => 'A',
            :ttl => 2,
            :zone_id => 'bar'
          )
      end
    end
  end
end
