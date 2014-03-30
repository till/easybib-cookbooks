require_relative "spec_helper"

describe 'easybib::empty' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ["easybib_crontab"]
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge("fixtures::easybib_crontab") }

  describe "easybib_crontab actions" do
    describe "create" do
      before { stub_crontab_with_one_valid_and_one_invalid_line }

      it "cleans leftover old crontab" do
        expect(chef_run).to run_execute('crontab -u www-data -r; true')
      end

      it "creates a cronjob" do
        expect(chef_run).to create_cron_d('some-app_1')
          .with(
          :minute => "1",
          :hour => "2",
          :day => "3",
          :month => "4",
          :weekday => "5",
          :user => "www-data",
          :command => "cronline"
        )
      end

      it "not to create a cronjob for an invalid line" do
        expect(chef_run).not_to create_cron_d('some-app_2')
      end
    end
  end
end

def stub_crontab_with_one_valid_and_one_invalid_line
  ::File.stub(:exists?).with(anything).and_call_original
  ::File.stub(:exists?).with('/some_file').and_return true

  open_file = double('file')
  expect(open_file).to receive(:each_line)
    .and_yield('1 2 3 4 5 cronline')
    .and_yield('second line')

  ::File.stub(:open).with(anything).and_call_original
  ::File.stub(:open).with('/some_file').and_return open_file
end
