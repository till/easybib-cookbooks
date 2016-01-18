require 'aws-sdk-v1'
require_relative './../libraries/record-model'

# credentials
aws_key = ''
aws_secret = ''

# env/case specific settings
zone_id = ''
server_name = ''

route_53_credential_provider = AWS::Core::CredentialProviders::StaticProvider.new(
  :access_key_id => aws_key,
  :secret_access_key => aws_secret
)

route53_client = AWS::Route53.new(:credential_provider => route_53_credential_provider)
model = ::IesRoute53::Record.new(route53_client, zone_id, 'A', 3600)

if model.exists?(server_name)
  puts "Updating..."
  model.update(server_name, '127.0.0.2')
else
  puts "Writing new ..."
  model.add(server_name, '127.0.0.1')
end
