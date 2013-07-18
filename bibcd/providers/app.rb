require "yaml"

action :add do
  unless ::File.exists?("#{bicd_path}/config/apps/#{new_resource.app_name}.yml")
    Chef::Log.info "Adding #{new_resource.app_name} config to #{bicd_path}/config/apps/#{new_resource.app_name}.yml"
    
    template "#{bicd_path}/config/apps/#{new_resource.app_name}.yml" do
      mode   0644
      variables :content => YAML::dump(new_resource.config.to_hash)
      source "app.yml.erb"
    end
    
    new_resource.updated_by_last_action(true)
  end
end