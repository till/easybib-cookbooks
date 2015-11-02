Chef::Resource.send(:include, EasyBib)

include_recipe 'route53'

host_name = get_hostname(node, true)
stack_name = get_normalized_cluster_name(node)
zone_name = node['ies-route53']['zone']['name']
public_ip = node['opsworks']['instance']['public_ip']

route53_record 'create a record' do
  name                  "#{host_name}.#{stack_name}.#{zone_name}"
  value                 public_ip
  type                  'A'
  ttl                   node['ies-route53']['zone']['ttl']
  zone_id               node['ies-route53']['zone']['id']
  aws_access_key_id     node['ies-route53']['zone']['custom_access_key']
  aws_secret_access_key node['ies-route53']['zone']['custom_secret_key']
  overwrite true
  action :create
  only_if do
    is_aws
  end
  not_if do
    node.fetch('ies-route53', {}).fetch('zone', {}).fetch('id', {}).nil?
  end
end
