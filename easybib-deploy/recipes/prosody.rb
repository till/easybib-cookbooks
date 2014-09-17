node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'jabber')

  Chef::Log.info('deploy::jabber - Deployment started.')

  include_recipe 'prosody::default'

end
