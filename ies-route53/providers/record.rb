action :create do
  require 'aws-sdk-v1' rescue nil

  Chef::Log.info('Preparing IES-Route53 Record Update...')

  route_53_credential_provider = AWS::Core::CredentialProviders::StaticProvider.new(
    :access_key_id => new_resource.aws_access_key_id,
    :secret_access_key => new_resource.aws_secret_access_key
  )

  r53 = AWS::Route53.new(:credential_provider => route_53_credential_provider)

  zone_id = new_resource.zone_id
  overwrite = new_resource.overwrite
  @name = new_resource.name
  @ttl = new_resource.ttl
  @type = new_resource.type
  @value = new_resource.value

  record_model = ::IesRoute53::Record.new(route53, zone_id, @type, @ttl)

  updated = false

  if record_model.exists?(@name)
    if overwrite
      Chef::Log.info("Updating record!")
      record_model.update(@name, @value)
      updated = true
    else
      Chef::Log.warn("Skipping update! OVERWRITE is not set!")
    end
  else
    Chef::Log.info("Creating new record for!")
    record_model.add(@name, @value)
    updated = true
  end

  new_resource.updated_by_last_action(updated)
end
