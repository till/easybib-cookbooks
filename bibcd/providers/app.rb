require "yaml"

action :add do
  unless ::File.exists?("#{new_resource.path}/config/apps/#{new_resource.app_name}.yml")
    Chef::Log.info "Adding #{new_resource.app_name} config to #{new_resource.path}/config/apps/#{new_resource.app_name}.yml"
    
    template "#{new_resource.path}/config/apps/#{new_resource.app_name}.yml" do
      cookbook "bibcd" #if we dont set this, the template cmd would search in the calling cookbook
      mode   0644
      #This is an ugly quick hack: Ruby Yaml adds !map:Chef::Node::ImmutableMash which the Symfony Yaml 
      #parser doesnt like. So lets remove it.
      variables :content => YAML::dump(new_resource.config.to_hash).gsub('!map:Chef::Node::ImmutableMash','')
      source "app.yml.erb"
    end
    
    new_resource.updated_by_last_action(true)
  end
end