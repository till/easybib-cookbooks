require "yaml"

action :add do
  unless ::File.exists?("#{node['bibcd_path']}/config/apps/#{new_resource.app_name}.yml")
    Chef::Log.info "Adding #{new_resource.app_name} config to #{node['bibcd_path']}/config/apps/#{new_resource.app_name}.yml"
    
    template "#{node['bibcd_path']}/config/apps/#{new_resource.app_name}.yml" do
      mode   0644
      variables :content => YAML::dump(new_resource.config.to_hash)
      source "app.yml.erb"
    end
    
    new_resource.updated_by_last_action(true)
  end
end