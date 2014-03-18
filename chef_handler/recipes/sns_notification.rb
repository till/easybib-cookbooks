unless node["chef_handler"]["sns_topic"].nil?

  chef_gem 'nokogiri'
  chef_gem 'chef-handler-sns'

  # Then activate the handler with the `chef_handler` LWRP
  chef_handler "Chef::Handler::Sns" do
    source "#{Gem::Specification.find_by_name("chef-handler-sns").lib_dirs_glob}/chef/handler/sns"
    arguments [
      :topic_arn => node["chef_handler"]["sns_topic"],
      :filter_opsworks_activities => node["chef_handler"]["sns_alert_activities"]
    ]
    supports :exception => true
    action :enable
  end

end
