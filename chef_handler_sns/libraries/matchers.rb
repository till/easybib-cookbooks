if defined?(ChefSpec)
  def enable_chef_handler_sns(topic_arn)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_handler_sns, :enable, topic_arn)
  end
end
