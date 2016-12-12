module WT
  module Data
    module AppsToDeploy
      extend self
      # returns all apps configured to be deploy in the current chef run, so
      # basically what opsworks&chef11 have in node['deploy']
      # This eventually can be further enhanced to filter by the instance layers
      # and therefore remove the need for the allow_deploy calls in the recipes,
      # but for the sake of a easier migration, we should do this in a later step
      def get_apps_to_deploy(node)
        return get_apps_to_deploy_vagrant(node) unless node['vagrant'].nil?
        return get_apps_to_deploy_chef11(node) unless node['deploy'].nil?
        # chef 12 or empty deploy
        get_apps_to_deploy_chef12
      end

      def get_apps_to_deploy_chef12
        applications = {}
        query = Chef::Search::Query.new
        apps = query.search(:aws_opsworks_app, 'deploy:true').first
        apps.each do |app|
          applications[app['shortname']] = ::WT::Data::AppObject.new(app['shortname'], app)
        end
        applications
      end

      def get_apps_to_deploy_chef11(node)
        applications = {}
        node['deploy'].each do |application, deploy|
          applications[application] = ::WT::Data::AppObject.new(application, deploy)
        end
        applications
      end

      def get_apps_to_deploy_vagrant(node)
        applications = {}
        node['vagrant']['applications'].each do |application, deploy|
          applications[application] = ::WT::Data::VagrantAppObject.new(application, deploy)
        end
        applications
      end
    end
  end
end
