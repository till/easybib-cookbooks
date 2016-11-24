# This module injects the shared functions into Recipes & Providers.
# The idea is that this only serves as a provider to the actual classes,
# so try not to add "actual" code here, just call the class doing the heavy lifting
module WT
  module Data
    module Injector
      extend self
      def get_apps_to_deploy(node = self.node)
        ::WT::Data::AppsToDeploy.get_apps_to_deploy(node)
      end
    end
  end
end

Chef::Provider.send(:include, ::WT::Data::Injector)
Chef::Recipe.send(:include, ::WT::Data::Injector)
Chef::Resource.send(:include, ::WT::Data::Injector)
