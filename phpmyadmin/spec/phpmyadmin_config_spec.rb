require_relative 'spec_helper'

describe 'phpmyadmin_config' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['phpmyadmin_config']
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('fixtures::phpmyadmin_config') }

  describe 'phpmyadmin_config' do
    it 'does render a file without servers specified' do
      expect(chef_run).to render_file('/some/dir/config.inc.php')
        .with_content(
          include("$cfg['Servers'][$i]['host'] = 'localhost';")
        )
    end
    it 'does render a file with config values specified in servers' do
      expect(chef_run).to render_file('/some/other/dir/config.inc.php')
         .with_content(
           include("$cfg['Servers'][$i]['conf'] = 'thing';")
         )
    end
    it 'does render truevalue as php true' do
      expect(chef_run).to render_file('/some/other/dir/config.inc.php')
         .with_content(
           include("$cfg['Servers'][$i]['cookie'] = true;")
         )
    end
    it 'does render falsevalue as php false' do
      expect(chef_run).to render_file('/some/other/dir/config.inc.php')
         .with_content(
           include("$cfg['Servers'][$i]['something'] = false;")
         )
    end
    it 'does render nilvalue as php null' do
      expect(chef_run).to render_file('/some/other/dir/config.inc.php')
         .with_content(
           include("$cfg['Servers'][$i]['nullvalue'] = null;")
         )
    end
  end
end
