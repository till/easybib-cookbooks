def aws
  {
    :provider => 'AWS',
    :aws_access_key_id => new_resource.aws_access_key_id,
    :aws_secret_access_key => new_resource.aws_secret_access_key
  }
end

def zone_id
  @zone_id ||= new_resource.zone_id
end

def name
  @name ||= begin
    return new_resource.name + '.' if new_resource.name !~ /\.$/
    new_resource.name
  end
end

def value
  @value ||= new_resource.value
end

def type
  @type ||= new_resource.type
end

def ttl
  @ttl ||= new_resource.ttl
end

def overwrite
  @overwrite ||= new_resource.overwrite
end

action :create do
  require 'aws-sdk'
  AWS.config(aws)

  def same_record?(record)
    record.resource_records[0][:value] == value && record.ttl == ttl
  end

  record = AWS::Route53::HostedZone.new(zone_id).rrsets[name, type]
  batch = AWS::Route53::ChangeBatch.new(zone_id)

  if record.exists?
    if same_record?(record)
      Chef::Log.info("Not touching this record as nothing seems to have changed: #{name}")
    else
      if overwrite
        Chef::Log.info("Update record: #{name}")
        batch << AWS::Route53::DeleteRequest.new(name, type)
        batch << AWS::Route53::CreateRequest.new(name, type, :ttl => ttl, :resource_records => [{ :value => value }])
      else
        Chef.Log.warn("Update required, but override not set: #{name}")
      end
    end
  else
    Chef::Log.info("Creating new record: #{name}")
    batch << AWS::Route53::CreateRequest.new(name, type, :ttl => ttl, :resource_records => [{ :value => value }])
  end

  begin
    batch.call
    new_resource.updated_by_last_action(updated)
  rescue
    Chef::Application.fatal!('Change batch failed!')
  end
end
