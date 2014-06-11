require_relative '../spec_helper'

describe 'chef_handler_sns resource' do
  let(:topic_arn) { 'arn:aws:sns:us-east-1:12341234:MyTopicName' }
  let(:chef_handler_sns_path) { '/tmp/chef-handler-sns' }
  let(:chef_run) do
    ChefSpec::Runner.new(
        :platform => 'ubuntu', :version => '12.04',
        :step_into => ['chef_handler_sns']
      ) do |node|
      node.set['chef_handler_sns']['topic_arn'] = topic_arn
    end.converge('chef_handler_sns::default')
  end

  before do
    gemspec = Gem::Specification.new
    gemspec.name = 'chef-handler-sns'
    gemspec.stub(:lib_dirs_glob).and_return(chef_handler_sns_path)
    Gem::Specification.stub(:find_by_name).with('chef-handler-sns').and_return(gemspec)
  end

  it 'should include xml::ruby recipe' do
    expect(chef_run).to include_recipe('xml::ruby')
  end

  it 'should install chef-handler-sns gem' do
    expect(chef_run).to install_chef_gem('chef-handler-sns')
  end

  it 'should run chef_handler resource' do
    expect(chef_run).to enable_chef_handler('Chef::Handler::Sns').with(
      :source => "#{chef_handler_sns_path}/chef/handler/sns",
      :supports => Mash.new(
        :exception => true,
        :report => false
      )
    )
  end

end
