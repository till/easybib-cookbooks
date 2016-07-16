instance = get_instance

aws_config = get_aws_config

ies_route53_record 'create a record' do
  name                  get_record_name
  value                 instance['ip']
  type                  'A'
  ttl                   node['ies-route53']['zone']['ttl']
  zone_id               aws_config[:zone_id]
  aws_access_key_id     aws_config[:access_key]
  aws_secret_access_key aws_config[:secret]
  overwrite true
  action :create
  only_if do
    dns_enabled? && !instance['ip'].nil?
  end
end
