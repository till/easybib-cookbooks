def aws
  {
  :provider => 'AWS',
  :aws_access_key_id => new_resource.aws_access_key_id,
  :aws_secret_access_key => new_resource.aws_secret_access_key,
  :aws_session_token => new_resource.aws_session_token
  }
end

def name
  @name ||= begin
    return new_resource.name + '.' if new_resource.name !~ /\.$/
    new_resource.name
  end
end

def value
  @value ||= Array(new_resource.value)
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

def alias_target
  @alias_target ||= new_resource.alias_target
end

def mock?
  @mock ||= new_resource.mock
end

def mock_env(connection_info)
  Fog.mock!
  conn = Fog::DNS.new(connection_info)
  zone_id = conn.create_hosted_zone(name).body['HostedZone']['Id']
  conn.zones.get(zone_id)
end

def zone(connection_info)
  @zone ||= begin
    if mock?
      @zone = mock_env(connection_info)
    elsif new_resource.aws_access_key_id && new_resource.aws_secret_access_key
      @zone = Fog::DNS.new(connection_info).zones.get( new_resource.zone_id )
    else
      Chef::Log.info "No AWS credentials supplied, going to attempt to use IAM roles instead"
      @zone = Fog::DNS.new({ :provider => "AWS", :use_iam_profile => true }
                             ).zones.get( new_resource.zone_id )
    end
  end
end

def record_attributes
  common_attributes = { :name => name, :type => type }
  common_attributes.merge(record_value_or_alias_attributes)
end

def record
  Chef::Log.info("Getting record: #{name} #{type}")
  records = zone(aws).records
  records.count.zero? ? nil : records.get(name, type)
end

def record_value_or_alias_attributes
  if alias_target
    { :alias_target => alias_target.to_hash }
  else
    { :value => value, :ttl => ttl }
  end
end

action :create do
  require 'fog'
  require 'nokogiri'

  def create
    begin
      zone(aws).records.create(record_attributes)
      Chef::Log.debug("Created record: #{record_attributes.inspect}")
    rescue Excon::Errors::BadRequest => e
      Chef::Log.error Nokogiri::XML( e.response.body ).xpath( "//xmlns:Message" ).text
    end
  end

  def same_record?(record)
    name.eql?(record.name) &&
      same_value?(record) &&
        ttl.eql?(record.ttl.to_i)
  end

  def same_value?(record)
    if alias_target
      same_alias_target?(record)
    else
      value.sort == record.value.sort
    end
  end

  def same_alias_target?(record)
    alias_target &&
      record.alias_target &&
      (alias_target['dns_name'] == record.alias_target['DNSName'].gsub(/\.$/,''))
  end

  if record.nil?
    create
    Chef::Log.info "Record created: #{name}"
  elsif !same_record?(record)
    unless overwrite == false
      record.destroy
      create
      Chef::Log.info "Record modified: #{name}"
   else
      Chef::Log.info "Record #{name} should have been modified, but overwrite is set to false."
      Chef::Log.debug "Current value: #{record.value.first}"
      Chef::Log.debug "Desired value: #{value}"
    end
  else Chef::Log.info "There is nothing to update."
  end
end

action :delete do
  require 'fog'
  require 'nokogiri'

  if mock?
    # Make some fake data so that we can successfully delete when testing.
    zone(aws).records.create(
      name: name,
      type: type,
      value: ['1.2.3.4'],
      ttyl: 300
    )
  end

  def delete
    zone(aws).records.get(name, type).destroy
    Chef::Log.debug("Destroyed record: #{name} #{type}")
  rescue Excon::Errors::BadRequest => e
    Chef::Log.error Nokogiri::XML(e.response.body).xpath('//xmlns:Message').text
  end

  if record.nil?
    Chef::Log.info 'There is nothing to delete.'
  else
    delete
    Chef::Log.info "Record deleted: #{name}"
  end
end
