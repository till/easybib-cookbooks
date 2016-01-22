instance = get_instance

ies_route53_record 'create a record' do
  name                  get_record_name
  value                 instance['ip']
  type                  'A'
  ttl                   node['ies-route53']['zone']['ttl']
  zone_id               node['ies-route53']['zone']['id']
  aws_access_key_id     node['ies-route53']['zone']['custom_access_key']
  aws_secret_access_key node['ies-route53']['zone']['custom_secret_key']
  overwrite true
  action :create
  only_if do
    dns_enabled?
  end
end
