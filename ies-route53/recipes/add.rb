instance = get_instance

host_name = get_hostname(node, true)
stack_name = get_normalized_cluster_name(node)
region_id = instance['region']
public_ip = instance['ip']
record_name = "#{host_name}.#{stack_name}.#{region_id}"

ies_route53_record 'create a record' do
  name                  record_name
  value                 public_ip
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
