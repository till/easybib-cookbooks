require "yaml"

action :add do
  unless ::File.exists?("#{new_resource.path}/config/apps/#{new_resource.app_name}.yml")
    Chef::Log.info "Adding #{new_resource.app_name} config to #{new_resource.path}/config/apps/#{new_resource.app_name}.yml"

    # This is an ugly quick hack: Ruby Yaml adds !map:Chef::Node::ImmutableMash which the Symfony Yaml
    # parser doesnt like. So lets remove it. First Chef 11.4/Ruby 1.8, then Chef 11.10/Ruby 2.0
    content = YAML.dump(new_resource.config.to_hash).gsub('!map:Chef::Node::ImmutableMash', '')
    content = content.gsub('!ruby/hash:Chef::Node::ImmutableMash', '')

    template "#{new_resource.path}/config/apps/#{new_resource.app_name}.yml" do
      cookbook "bibcd" # if we dont set this, the template cmd would search in the calling cookbook
      mode   0644
      variables :content => content
      source "app.yml.erb"
    end

    new_resource.updated_by_last_action(true)
  end
end
