module IesRoute53
  class Record
    def initialize(route53_client, zone_id, record_type, record_ttl)
      @client = route53_client
      @zone   = zone_id
      @type   = record_type
      @ttl    = record_ttl
    end

    def add(server_name, ip_address)
      zone = route53_zone
      zone.rrsets.create(
        fqdn(server_name, zone.name),
        @type,
        :ttl => @ttl,
        :resource_records => [{ :value => ip_address }]
      )
    end

    def exists?(server_name)
      route53_record(server_name).exists?
    end

    def fqdn(server_name, zone_name)
      server_name + '.' + zone_name
    end

    def route53_record(server_name)
      zone = route53_zone
      zone.rrsets[fqdn(server_name, zone.name), @type]
    end

    def route53_zone
      @client.hosted_zones.find { |z| z.id == @zone }
    end

    def update(server_name, ip_address)
      existing_record                  = route53_record(server_name)
      existing_record.resource_records = [{ :value => ip_address }]
      existing_record.update
    end
  end
end
