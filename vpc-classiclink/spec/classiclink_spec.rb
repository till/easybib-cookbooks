require 'chefspec'

describe 'vpc-classiclink::default' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :fatal
    )
  end
  let(:chef_run)   { runner.converge(described_recipe) }
  let(:node)       { runner.node }

  describe 'dependencies' do
    it 'includes awscli' do
      expect(chef_run).to include_recipe('awscli')
    end

    it 'includes classiclink recipe' do
      expect(chef_run).to include_recipe('vpc-classiclink::classiclink')
    end
  end

  describe 'registers my instance with vpc' do
    before do
      node.override['opsworks']['instance'] = { :aws_instance_id => 'SUPER_INSTANCE' }
      node.override['vpc-classiclink']['classiclink_vpc_id'] = 'SOME_VPC'
      node.override['vpc-classiclink']['classiclink_security_group_id'] = 'SOME_SG'
      node.override['vpc-classiclink']['region'] = 'us-east-2'
    end

    it 'calls the registration' do
      expect(chef_run).to run_execute('attach-classiclink-to').with(
        :command => /--instance-id SUPER_INSTANCE --vpc-id SOME_VPC --groups SOME_SG --region us-east-2/
      )
    end
  end

  describe 'it does not register' do
    it 'does not call the registration' do
      expect(chef_run).not_to run_execute('attach-classiclink-to')
    end
  end
end
