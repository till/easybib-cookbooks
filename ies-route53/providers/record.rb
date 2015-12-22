require 'aws-sdk-v1'

def same_record?(record)
  record.resource_records[:value] == @value && record.ttl == @ttl && record.type == @type
end

action :create do
  Chef::Log.info('Calling IES-Route53 Record-Update...')

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

  zone = r53.hosted_zones.find { |z| z.id == zone_id }

  fqdn = @name + '.' + zone.name
  record = zone.rrsets[fqdn, @type]
  Chef::Log.info("Selected record for update: #{fqdn}")

  if record.exists?
    if same_record?(record)
      Chef::Log.info("Unchanged, not updating: #{fqdn}")
    else
      if overwrite
        Chef::Log.info("Overwriting already existing record: #{fqdn}")
        record.resource_records = [{ :value => @value }]
        record.update
        new_resource.updated_by_last_action(true)
      else
        Chef::Log.warn("Skipping update! OVERWRITE is not set: #{fqdn}")
      end
    end
  else
    Chef::Log.info("Creating new record for: #{fqdn}")
    zone.rrsets.create(@name, @type, :ttl => @ttl, :resource_records => [{ :value => @value }])
    new_resource.updated_by_last_action(true)
  end
end
