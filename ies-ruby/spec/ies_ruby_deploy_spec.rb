require_relative 'spec_helper'

describe 'ies_ruby_deploy' do
  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../.."),
      File.expand_path(File.dirname(__FILE__).to_s)
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['ies_ruby_deploy']
    )
  end

  let(:node) { runner.node }
  let(:chef_run) { runner.converge('fixtures::ies_ruby_deploy') }

  before do
    node.set['etc']['passwd']['nobody']['dir'] = '/home/nobody'
  end

  describe 'ies_ruby_deploy actions' do
    describe 'install' do
      it 'syncs rbenv repository' do
        expect(chef_run).to sync_git('/home/nobody/.rbenv')
      end

      it 'ensures the rbenv plugin directory' do
        expect(chef_run).to create_directory('/home/nobody/.rbenv/plugins')
      end

      it 'syncs the ruby-build repository' do
        expect(chef_run).to sync_git('/home/nobody/.rbenv/plugins/ruby-build')
      end

      it 'compiles the rbenv Bash extensions for better performance' do
        expect(chef_run).to run_execute('compile rbenv bash extension')
      end

      it 'deploys bashrc file to /etc/profile.d/' do
        expect(chef_run).to create_cookbook_file('/etc/profile.d/rbenv.sh')
      end

      it 'installs the OpsWorks mandatory Ruby version' do
        expect(chef_run).to run_execute('install opsworks mandatory ruby')
      end

      it 'sets the OpsWorks mandatory Ruby version as global system default' do
        expect(chef_run).to run_execute('set ruby-version for OpsWorks as global default')
      end

      it 'installs the desired Ruby version' do
        expect(chef_run).to run_execute('install desired ruby-version')
      end

      it 'installs bundler' do
        expect(chef_run).to run_execute('install bundler')
      end
    end
    describe 'remove' do
      it 'removes the bashrc file from /etc/profile.d/' do
        expect(chef_run).to delete_cookbook_file('/etc/profile.d/rbenv.sh')
      end

      it 'removes the rbenv root directory' do
        expect(chef_run).to delete_directory('/home/nobody/.rbenv')
      end
    end
  end
end
