require 'chef/resource'

class Chef
  class Resource
    class Pear < Chef::Resource

      def initialize(package, channel=nil, version=nil)
        super
        @resource_name = :pear

        @package = package
        @channel = channel
        @version = version

        @action = :install
        @allowed_actions.push(:install, :uninstall, :upgrade, :install_if_missing)
        @provider = Chef::Provider::Pear
      end

    end
  end
end
