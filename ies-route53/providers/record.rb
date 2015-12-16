begin
  require 'aws-sdk-v1'
rescue
  Chef::Application.fatal!('aws-sdk-v1 missing!')
end

def credentials
  {
    :aws_access_key_id => new_resource.aws_access_key_id,
    :aws_secret_access_key => new_resource.aws_secret_access_key
  }
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

def zone
  r53 = AWS::Route53.new(credentials)
  r53.hosted_zones.each do |zone|
    if zone.name == name
      return zone
    end
  end
  Chef::Application.fatal!("Zone does not exist: #{name}")
end

def record
  zone.rrsets[name, type]
end

action :create do
  def same_record?(record)
    record.resource_records[0][:value] == value && record.ttl == ttl
  end

  batch = AWS::Route53::ChangeBatch.new(zone.hosted_zone_id)

  if record.exists?
    if same_record?(record)
      Chef::Log.info("Not touching this record as nothing seems to have changed: #{name}")
    else
      if overwrite
        Chef::Log.info("Update record: #{name}")
        batch << AWS::Route53::DeleteRequest.new(name, type)
        batch << AWS::Route53::CreateRequest.new(name, type, :ttl => ttl, :resource_records => [{ :value => value }])
        new_resource.updated_by_last_action(true)
      else
        Chef.Log.warn("Update required, but override not set: #{name}")
      end
    end
  else
    Chef::Log.info("Creating new record: #{name}")
    batch << AWS::Route53::CreateRequest.new(name, type, :ttl => ttl, :resource_records => [{ :value => value }])
    new_resource.updated_by_last_action(true)
  end

  begin
    batch.call
  rescue
    Chef::Application.fatal!('Change batch failed!')
  end
end
