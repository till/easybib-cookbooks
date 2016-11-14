module WT
  module Data
    module AppsToDeploy
      # rubocop:disable Style/ModuleFunction
      extend self
      # returns all apps configured to be deploy in the current chef run, so
      # basically what opsworks&chef11 have in node['deploy']
      # This eventually can be further enhanced to filter by the instance layers
      # and therefore remove the need for the allow_deploy calls in the recipes,
      # but for the sake of a easier migration, we should do this in a later step
      def get_apps_to_deploy(node)
        if node['deploy'].nil?
          # chef 12 or empty deploy
          get_apps_to_deploy_chef12
        else
          get_apps_to_deploy_chef11(node)
        end
      end

      def get_apps_to_deploy_chef12
        applications = {}
        query = Chef::Search::Query.new
        apps = query.search(:aws_opsworks_app, 'deploy:true').first
        apps.each do |app|
          applications[app['shortname']] = ::WT::Data::AppObject.new(app)
        end
        applications
      end

      def get_apps_to_deploy_chef11(node)
        applications = {}
        node['deploy'].each do |application, deploy|
          applications[application] = ::WT::Data::AppObject.new(deploy)
        end
        applications
      end
    end
  end
end
