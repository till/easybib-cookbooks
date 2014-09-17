require "yaml"

action :add do
  unless ::File.exist?("#{new_resource.path}/config/apps/#{new_resource.app_name}.yml")
    Chef::Log.info "Adding #{new_resource.app_name} config to #{new_resource.path}/config/apps/#{new_resource.app_name}.yml"

    template "#{new_resource.path}/config/apps/#{new_resource.app_name}.yml" do
      cookbook "bibcd" # if we dont set this, the template cmd would search in the calling cookbook
      mode   0644
      variables :content => ::EasyBib.to_php_yaml(new_resource.config.to_hash)
      source "app.yml.erb"
    end

    new_resource.updated_by_last_action(true)
  end
end
