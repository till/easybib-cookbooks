action :create do
  begin
    require 'aws-sdk-v1'
  rescue
    nil
  end

  Chef::Log.info('Preparing IES-Route53 Record Update...')

  access_key = new_resource.aws_access_key_id
  secret_key = new_resource.aws_secret_access_key

  if access_key.nil? || secret_key.nil?
    route53_client = AWS::Route53.new
  else
    route_53_credential_provider = AWS::Core::CredentialProviders::StaticProvider.new(
      :access_key_id => access_key,
      :secret_access_key => secret_key
    )

    route53_client = AWS::Route53.new(
      :credential_provider => route_53_credential_provider
    )
  end

  zone_id = new_resource.zone_id
  overwrite = new_resource.overwrite
  @name = new_resource.name
  @ttl = new_resource.ttl
  @type = new_resource.type
  @value = new_resource.value

  record_model = ::IesRoute53::Record.new(route53_client, zone_id, @type, @ttl)

  updated = false

  if record_model.exists?(@name)
    if overwrite
      Chef::Log.info('Updating record!')
      record_model.update(@name, @value)
      updated = true
    else
      Chef::Log.warn('Skipping update! OVERWRITE is not set!')
    end
  else
    Chef::Log.info('Creating new record for!')
    record_model.add(@name, @value)
    updated = true
  end

  new_resource.updated_by_last_action(updated)
end
