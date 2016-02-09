RSpec.shared_context 'mock vagrant_sha256sum' do
  before(:context) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        @vpd_setting = mocks.verify_partial_doubles?
        mocks.verify_partial_doubles = false
      end
    end
  end

  before(:example) do
    allow_any_instance_of(Chef::Recipe).to receive(:vagrant_sha256sum).and_return('abc123')
  end

  after(:context) do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = @vpd_setting
      end
    end
  end
end
