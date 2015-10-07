if is_aws
  # sns_notify_spinup notifies us if a load based instance spins up.
  ::EasyBib::SNS.sns_notify_spinup(node) if node['opsworks']['activity'] == 'setup'

  # chef_handler_sns notifies of broken/failed chef runs
  include_recipe 'chef_handler_sns::default' unless node.fetch('chef_handler_sns', {})['topic_arn'].nil?
end
