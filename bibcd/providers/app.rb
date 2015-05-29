require 'yaml'

action :add do

  yml_file = "#{new_resource.path}/config/apps/#{new_resource.app_name}.yml"

  unless ::File.exist?(yml_file)
    Chef::Log.info "Adding #{new_resource.app_name} config to #{yml_file}"
    Chef::Resource.send(:include, ::EasyBib::Php)

    template yml_file do
      cookbook 'bibcd'
      mode   0644
      variables :content => to_php_yaml(new_resource.config.to_hash)
      source 'app.yml.erb'
    end

    new_resource.updated_by_last_action(true)
  end
end
